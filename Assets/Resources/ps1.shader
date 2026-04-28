Shader "PS1"
{
    Properties
    {
        _MainTex ("Albedo (Industrial)", 2D) = "white" {}
        _VtxSnap ("Jitter Strength", Range(1, 100)) = 40
        _E3Power ("Light Intensity", Float) = 1.0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" }
        LOD 100

        // -----------------------------------------------------------
        // PASS 1: The "Sun" & Ambient (The Jittery Base)
        // -----------------------------------------------------------
        Pass
        {
            Tags { "LightMode"="ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
            };

            sampler2D _MainTex;
            float _VtxSnap, _E3Power;

            v2f vert (appdata_base v) {
                v2f o;
                float4 clipPos = UnityObjectToClipPos(v.vertex);
                float2 snap = _ScreenParams.xy / max(1.0, _VtxSnap);
                clipPos.xy = floor(clipPos.xy * snap + 0.5) / snap;
                o.pos = clipPos;
                o.uv = v.texcoord.xy;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

float4 frag (v2f i) : SV_Target {
    float4 col = tex2D(_MainTex, i.uv);
    float3 lightDir = _WorldSpaceLightPos0.xyz;
    
    // 1. The "Minimalist" Light Hook
    // We use a tiny 0.02 so you can just barely see the "Industrial Grime" 
    // when the sun is out, but it's effectively "Blackout" indoors.
    float3 lightColor = _LightColor0.rgb * _E3Power;
    float3 normal = normalize(i.worldNormal);
    float diff = max(0.02, dot(normal, lightDir)); 

    // 2. The "Dark Anchor"
    // We drop ambient to 0.05. It's just enough to prevent the GPU 
    // from "deleting" the pixel, but it looks like a total blackout.
    float3 ambient = col.rgb * 0.05; 
    
    return float4(ambient + (col.rgb * diff * lightColor), 1.0);
            }
            ENDCG
        }

        // -----------------------------------------------------------
        // PASS 2: The "Point Lights" (The Jittery Additive)
        // -----------------------------------------------------------
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
            float _VtxSnap, _E3Power;

            v2f vert (appdata_base v) {
                v2f o;
                float4 clipPos = UnityObjectToClipPos(v.vertex);
                float2 snap = _ScreenParams.xy / max(1.0, _VtxSnap);
                clipPos.xy = floor(clipPos.xy * snap + 0.5) / snap;
                o.pos = clipPos;
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

