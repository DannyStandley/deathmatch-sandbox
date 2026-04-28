Shader "Xbox360"
{
    Properties
    {
        _MainTex ("Albedo (Industrial)", 2D) = "white" {}
        _GrimeMap ("Grime (Specular)", 2D) = "gray" {}
        _OcclusionMap ("Shadow Glue (AO)", 2D) = "white" {}
        _TearStrength ("Screen Tear Jitter", Range(0, 0.05)) = 0.01
        _E3Power ("Over-Crank Intensity", Float) = 1.2
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" }
        LOD 200

        // -----------------------------------------------------------
        // PASS 1: The "Sun" & Ambient (The Base)
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
                float3 worldPos : TEXCOORD3;
            };

            sampler2D _MainTex, _GrimeMap, _OcclusionMap;
            float _TearStrength, _E3Power;

            v2f vert (appdata_base v) {
                v2f o;
                float4 clipPos = UnityObjectToClipPos(v.vertex);
                // 360 Screen Tear Jitter
                float tear = sin(_Time.y * 100.0 + clipPos.y * 5.0) * _TearStrength;
                if (tear > 0.005) clipPos.x += tear;
                
                o.pos = clipPos;
                o.uv = v.texcoord.xy;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            float4 frag (v2f i) : SV_Target {
                float4 col = tex2D(_MainTex, i.uv);
                float4 grime = tex2D(_GrimeMap, i.uv);
                float4 ao = tex2D(_OcclusionMap, i.uv);

                float3 lightDir = _WorldSpaceLightPos0.xyz;
                float3 lightColor = _LightColor0.rgb * _E3Power;
                float diff = max(0.1, dot(normalize(i.worldNormal), lightDir)); // Minimal floor

                // Oily Specular
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                float3 halfDir = normalize(lightDir + viewDir);
                float spec = pow(max(0.0, dot(normalize(i.worldNormal), halfDir)), 24.0) * grime.r * 1.5;

// Logic: We raise the ambient floor from 0.05 to 0.15 
// and ensure the AO doesn't kill the base visibility.
float3 ambient = col.rgb * 0.15; 
float3 final = (col.rgb * diff * lightColor * ao.r) + (spec * lightColor * ao.r);

// Result: Even in the dark, the "Industrial Grime" stays visible
return float4(final + ambient, 1.0); 
            }
            ENDCG
        }

        // -----------------------------------------------------------
        // PASS 2: The "Point Lights" (The Additive Logic)
        // -----------------------------------------------------------
        Pass
        {
            Tags { "LightMode"="ForwardAdd" }
            Blend One One // Logic: ADD this light to the base
            ZWrite Off    // Performance: Don't rewrite depth

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

            sampler2D _MainTex, _GrimeMap, _OcclusionMap;
            float _TearStrength, _E3Power;

            v2f vert (appdata_base v) {
                v2f o;
                float4 clipPos = UnityObjectToClipPos(v.vertex);
                // Must match the jitter of Pass 1 exactly
                float tear = sin(_Time.y * 100.0 + clipPos.y * 5.0) * _TearStrength;
                if (tear > 0.005) clipPos.x += tear;
                
                o.pos = clipPos;
                o.uv = v.texcoord.xy;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            float4 frag (v2f i) : SV_Target {
                float4 col = tex2D(_MainTex, i.uv);
                float4 grime = tex2D(_GrimeMap, i.uv);
                float4 ao = tex2D(_OcclusionMap, i.uv);

                // Point Light Calculation
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
                float dist = distance(_WorldSpaceLightPos0.xyz, i.worldPos);
                float atten = 1.0 / (1.0 + dist * dist); // Industrial Falloff

                float3 lightColor = _LightColor0.rgb * _E3Power * atten;
                float diff = max(0.0, dot(normalize(i.worldNormal), lightDir));

                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                float3 halfDir = normalize(lightDir + viewDir);
                float spec = pow(max(0.0, dot(normalize(i.worldNormal), halfDir)), 24.0) * grime.r * 1.5;

                return float4((col.rgb * diff * lightColor * ao.r) + (spec * lightColor * ao.r), 1.0);
            }
            ENDCG
        }
    }
}

