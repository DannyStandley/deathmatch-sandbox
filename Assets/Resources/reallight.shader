Shader "RealLight"
{
    Properties
    {
        _MainTex ("Albedo Texture", 2D) = "white" {}
        _NormalMap ("Normal Map", 2D) = "bump" {}
        _OcclusionMap ("Occlusion Map", 2D) = "white" {}
        _LightMap ("Pre-Baked Lightmap", 2D) = "gray" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" }

        // ==========================================
        // PASS 1: The Base Pass (Absolute Blackout Default)
        // ==========================================
        Pass
        {
            Tags { "LightMode"="ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata { float4 vertex : POSITION; };
            struct v2f { float4 pos : SV_POSITION; };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // Baseline state of the open world is pure darkness
                return fixed4(0.0, 0.0, 0.0, 1.0);
            }
            ENDCG
        }

        // ==========================================
        // PASS 2: The Lightmap-Gated Proximity Pass
        // ==========================================
        Pass
        {
            Tags { "LightMode"="ForwardAdd" }
            Blend One One // Adds values uniformly directly over the black base pass
            ZWrite Off    // Performance optimization: avoids redundant depth writes
            ZTest LEqual

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;    // Mapping for Albedo, Normal, Occlusion
                float2 uv1 : TEXCOORD1;   // Mapping for Lightmap
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
            };

            sampler2D _MainTex;
            sampler2D _NormalMap;
            sampler2D _OcclusionMap;
            sampler2D _LightMap;
            
            float4 _MainTex_ST;
            float4 _LightMap_ST;

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv1 = TRANSFORM_TEX(v.uv1, _LightMap);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // FIRST STEP: Sample the lightmap texture before doing any other work
                fixed4 lightmap = tex2D(_LightMap, i.uv1);

                // THE PIXEL-LEVEL MASTER GATE:
                // If the lightmap pixel is pitch black (value < 0.01), execution stops immediately!
                // The GPU throws away the fragment and skips loading the heavy Albedo, Normal, and Occlusion maps.
                clip(length(lightmap.rgb) - 0.01);

                // 1. Sample your high-fidelity material maps only if the lightmap allows it
                fixed4 albedo = tex2D(_MainTex, i.uv);
                fixed4 occlusion = tex2D(_OcclusionMap, i.uv);

                // 2. The Zero-Falloff Proximity Master Switch
                fixed3 lightGate = step(0.01, length(_LightColor0.rgb));

                // 3. Classical retro multiplication blend layer
                fixed3 composition = albedo.rgb * lightmap.rgb * 2.0;
                
                // 4. Multiply by occlusion and our proximity light gate
                fixed3 finalColor = composition * occlusion.r * lightGate;

                return fixed4(finalColor, 1.0);
            }
            ENDCG
        }
    }
}

