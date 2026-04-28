Shader "PictureLight"
{
    Properties
    {
        _MainTex ("Albedo (Industrial)", 2D) = "white" {}
        _E3Power ("Light Intensity", Float) = 1.0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" }
        LOD 100

        // 1. BASE PASS: The Sun / Ambient Floor
        Pass
        {
            Tags { "LightMode"="ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
            };

            sampler2D _MainTex;
            float _E3Power;

            v2f vert (appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord.xy;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            float4 frag (v2f i) : SV_Target {
                float4 col = tex2D(_MainTex, i.uv);
                float3 lightColor = _LightColor0.rgb * _E3Power;
                float3 normal = normalize(i.worldNormal);
                float diff = max(0.05, dot(normal, _WorldSpaceLightPos0.xyz)); 

                // Minimum floor of 0.05 so the textures aren't "deleted"
                return float4(col.rgb * diff * (lightColor + 0.1), 1.0);
            }
            ENDCG
        }

        // 2. ADDITIVE PASS: The Mesh-Attached Point Lights
        Pass
        {
            Tags { "LightMode"="ForwardAdd" }
            Blend One One 
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdadd_fullshadows
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                float3 worldPos : TEXCOORD3;
            };

            sampler2D _MainTex;
            float _E3Power;

            v2f vert (appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord.xy;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            float4 frag (v2f i) : SV_Target {
                float4 col = tex2D(_MainTex, i.uv);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
                float dist = distance(_WorldSpaceLightPos0.xyz, i.worldPos);
                float atten = 1.0 / (1.0 + dist * dist); 

                float3 lightColor = _LightColor0.rgb * _E3Power * atten;
                float diff = max(0.0, dot(normalize(i.worldNormal), lightDir));

                return float4(col.rgb * diff * lightColor, 1.0);
            }
            ENDCG
        }
    }
}

