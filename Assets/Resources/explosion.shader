Shader "Explosion" {
    Properties {
        _MainTex ("Albedo (Metal Exterior)", 2D) = "white" {}
        _BackdropTex ("Interior/Backing (Dark)", 2D) = "black" {}
        _EmissiveColor ("Heat Glow Color", Color) = (1,0.5,0,1)
        _BlastProgress ("Blast Progress (0-1)", Range(0,1)) = 0
    }
    SubShader {
        Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest" }
        Cull Off 

        Pass {
            Tags { "LightMode"="ForwardBase" }
            
            CGPROGRAM // Using CGPROGRAM for better legacy compatibility
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase // Essential for _LightColor0 and shadows
            
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc" // Where _LightColor0 lives

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
            };

            sampler2D _MainTex;
            sampler2D _BackdropTex;
            float4 _EmissiveColor;
            float _BlastProgress;

            v2f vert (appdata v) {
                v2f o;
                // Physical "Bloat" + Shake logic
                float displacement = _BlastProgress * 0.8;
                float shake = sin(_Time.y * 60.0) * _BlastProgress * 0.05;
                v.vertex.xyz += v.normal * (displacement + shake);
                
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i, bool facing : SV_IsFrontFace) : SV_Target {
                // 1. DISSOLVE
                float noise = frac(sin(dot(i.uv ,float2(12.9898,78.233))) * 43758.5453);
                clip(noise - _BlastProgress);

                // 2. TEXTURE SELECTION
                fixed4 col = facing ? tex2D(_MainTex, i.uv) : tex2D(_BackdropTex, i.uv);

                // 3. LEGACY LIGHTING
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                // Flip normal for the 'inside' faces so they catch light
                float3 normal = i.worldNormal * (facing ? 1 : -1);
                float ndotl = saturate(dot(normal, lightDir));
                
                // _LightColor0 is now properly recognized via UnityLightingCommon
                float3 finalLight = (ndotl * _LightColor0.rgb);

                // 4. MOLTEN EDGE GLOW
                float edgeWidth = 0.03;
                float isEdge = step(noise - _BlastProgress, edgeWidth);
                float3 heat = _EmissiveColor.rgb * isEdge * 20.0 * saturate(1.0 - _BlastProgress);

                return fixed4((col.rgb * finalLight) + heat, 1.0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}

