Shader "Skybox/Weather"
{
    Properties
    {
        _Tint ("Sky Tint Color", Color) = (.5, .5, .5, 1)
        _FrontTex ("Front (+Z) (Static)", 2D) = "grey" {}
        _BackTex ("Back (-Z) (Static)", 2D) = "grey" {}
        _LeftTex ("Left (+X) (Static)", 2D) = "grey" {}
        _RightTex ("Right (-X) (Static)", 2D) = "grey" {}
        _UpTex ("Up (+Y) (Static)", 2D) = "grey" {}
        _DownTex ("Down (-Y) (Static)", 2D) = "grey" {}
        
        [Header(Wind Engine)]
        _WindTex ("Wind/Mist Texture (Scrolling)", 2D) = "black" {}
        _WindSpeed ("Wind Velocity", Vector) = (0.1, 0, 0, 0)
        _WindIntensity ("Wind Visibility", Range(0, 1)) = 0.5
        _Exposure ("Sky Brightness", Range(0, 8)) = 1.0
        
        [Header(Storm Engine)]
        _RainTex ("Rain/Snow Texture", 2D) = "black" {}
        _RainColor ("Rain Color", Color) = (1, 1, 1, 1)
        _RainSpeed ("Rain Velocity", Float) = 0.0
        _RainScale ("Rain Scale (X, Y)", Vector) = (10, 10, 0, 0)
        _RainIntensity ("Rain Opacity", Range(0, 1)) = 0.0
    }

    SubShader
    {
        Tags { "Queue"="Background" "RenderType"="Background" "PreviewType"="Skybox" }
        Cull Off ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f {
                float4 pos : SV_POSITION;
                float3 viewDir : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            sampler2D _FrontTex, _BackTex, _LeftTex, _RightTex, _UpTex, _DownTex, _RainTex, _WindTex;
            float4 _Tint, _WindSpeed, _RainScale, _RainColor;
            float _RainSpeed, _RainIntensity, _Exposure, _WindIntensity;

            v2f vert (appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.viewDir = v.vertex.xyz;
                o.uv = v.texcoord.xy;
                return o;
            }

            float4 frag (v2f i) : SV_Target {
                float3 dir = normalize(i.viewDir);
                float3 absDir = abs(dir);
                float2 baseUV;
                float3 skyRGB;

                // 1. Static Sky Logic: Landmarks stay put
                if (absDir.x > absDir.y && absDir.x > absDir.z) {
                    baseUV = (dir.x > 0) ? float2(-dir.z, dir.y) : float2(dir.z, dir.y);
                    baseUV = baseUV * 0.5 + 0.5;
                    skyRGB = (dir.x > 0) ? tex2D(_RightTex, baseUV).rgb : tex2D(_LeftTex, baseUV).rgb;
                } else if (absDir.y > absDir.z) {
                    baseUV = (dir.y > 0) ? float2(dir.x, -dir.z) : float2(dir.x, dir.z);
                    baseUV = baseUV * 0.5 + 0.5;
                    skyRGB = (dir.y > 0) ? tex2D(_UpTex, baseUV).rgb : tex2D(_DownTex, baseUV).rgb;
                } else {
                    baseUV = (dir.z > 0) ? float2(dir.x, dir.y) : float2(-dir.x, dir.y);
                    baseUV = baseUV * 0.5 + 0.5;
                    skyRGB = (dir.z > 0) ? tex2D(_FrontTex, baseUV).rgb : tex2D(_BackTex, baseUV).rgb;
                }

                // 2. Wind Overlay Logic: Mist/Dust scrolls over the landmarks
                float2 windUV = baseUV + (_WindSpeed.xy * _Time.y);
                float4 mist = tex2D(_WindTex, windUV);
                float3 windRGB = mist.rgb * _Tint.rgb * _WindIntensity;

                // Combine Static and Wind
                float3 finalRGB = (skyRGB * _Tint.rgb * _Exposure) + windRGB;
                
                // 3. Storm Logic: Scaled Rain
                float2 tiledRainUV = (baseUV * _RainScale.xy) + float2(0, -_Time.y * _RainSpeed);
                float rainPattern = tex2D(_RainTex, tiledRainUV).r;
                
                // 4. Horizon Mask
                float rainMask = saturate(dir.y * 5.0) * rainPattern * _RainIntensity;
                float3 rainFinal = rainMask * _RainColor.rgb;

                return float4(finalRGB + rainFinal, 1.0);
            }
            ENDCG
        }
    }
}

