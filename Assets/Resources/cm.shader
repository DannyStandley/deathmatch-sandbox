Shader "ColonialMarines"
{
    Properties
    {
        _MainTex ("Albedo (Industrial Texture)", 2D) = "white" {}
        _GrimeMap ("Grime & Noise (Specular)", 2D) = "gray" {}
        
        [Header(Atmosphere)]
        _FogIntensity ("Fog/Mist Strength", Range(0, 1)) = 0.5
        _FogColor ("Fog Color (Port Wine/Blue)", Color) = (0.05, 0.05, 0.1, 1)
        _MistDensity ("Mist Density (Indoor)", Float) = 0.02
        
        [Header(Specular)]
        _Glossiness ("Glossiness (Wetness)", Range(0, 1)) = 0.8
        _MetallicEdge ("Metallic Edge (Fresnel)", Range(0, 5)) = 2.0
        _E3Power ("E3 Light Intensity", Float) = 1.0
        _ShadowIntensity("Intensity of shadows", Float) = 0.0
        _SpecPower("Sets the power of specular.", Float) = 0.0
    }

    SubShader
    {
        // Change RenderType to TransparentCutout so the "Boring" engine knows it has holes
        Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest" }
        LOD 200

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
                float fogFactor : TEXCOORD4;
            };

            sampler2D _MainTex;
            sampler2D _GrimeMap;
            float4 _FogColor;
            float _FogIntensity, _MistDensity, _Glossiness, _MetallicEdge, _E3Power, _ShadowIntensity, _SpecPower;

            v2f vert (appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                float dist = distance(_WorldSpaceCameraPos, o.worldPos);
                o.fogFactor = exp(-_MistDensity * dist); 
                return o;
            }

            float4 frag (v2f i) : SV_Target {
                float4 col = tex2D(_MainTex, i.uv);
                

                float4 grime = tex2D(_GrimeMap, i.uv);
                float3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * col.rgb;
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                float3 lightColor = _LightColor0.rgb * _E3Power; 
                float3 worldNormal = normalize(i.worldNormal);
                float diff = max(_ShadowIntensity, dot(worldNormal, lightDir));

                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                float3 halfDir = normalize(lightDir + viewDir);
                float specBase = pow(max(_SpecPower, dot(worldNormal, halfDir)), _Glossiness * 128.0);
                float3 spec = specBase * grime.r * lightColor;

                float3 finalRGB = (col.rgb * diff * lightColor) + spec;
                float fogAmount = saturate((1.0 - i.fogFactor) * _FogIntensity);
                finalRGB = lerp(finalRGB, _FogColor.rgb, fogAmount);

                return float4(finalRGB, 1.0);
            }
            ENDCG
        }

        Pass
        {
            Tags { "LightMode"="ForwardAdd" }
            Blend One One 
            ZWrite Off    
            Fog { Color (0,0,0,0) } 

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdadd_fullshadows 
            
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "UnityLightingCommon.cginc"

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                float3 worldPos : TEXCOORD3;
            };

            sampler2D _MainTex;
            sampler2D _GrimeMap;
            float _Glossiness, _E3Power, _ShadowIntensity, _SpecPower;

            v2f vert (appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            float4 frag (v2f i) : SV_Target {
                float4 col = tex2D(_MainTex, i.uv);
                

                float4 grime = tex2D(_GrimeMap, i.uv);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
                float dist = length(_WorldSpaceLightPos0.xyz - i.worldPos);
                float attenuation = 1.0 / (1.0 + dist * dist); 

                float3 lightColor = _LightColor0.rgb * _E3Power * attenuation;
                float3 worldNormal = normalize(i.worldNormal);
                float diff = max(_ShadowIntensity, dot(worldNormal, lightDir));

                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                float3 halfDir = normalize(lightDir + viewDir);
                float specBase = pow(max(_SpecPower, dot(worldNormal, halfDir)), _Glossiness * 128.0);
                float3 spec = specBase * grime.r * lightColor;

                return float4((col.rgb * diff * lightColor) + spec, 1.0);
            }
            ENDCG
        }
    }
}

