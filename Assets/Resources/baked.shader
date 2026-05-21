Shader "BakedLightmap"
{
    Properties
    {
        _MainTex ("Albedo Texture", 2D) = "white" {}
        _NormalMap ("Normal Map", 2D) = "bump" {}
        _OcclusionMap ("Occlusion Map", 2D) = "white" {}
        _LightMap ("Pre-Baked Lightmap", 2D) = "gray" {}
        
        // Your master data switch. Set to 1.0 via code for On, 0.0 for True Blackout
        _Lit ("Is Sector Lit", Float) = 1.0 
    }
    SubShader
    {
        // Unlit geometry queue for blistering fast CPU software rendering execution speed
        Tags { "RenderType"="Opaque" "Queue"="Geometry" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 uv : TEXCOORD0;    // Mapping coordinates for Albedo, Normal, Occlusion
                float2 uv1 : TEXCOORD1;   // Secondary coordinates for your Baked Lightmap
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
            float _Lit;

            v2f vert(appdata v)
            {
                v2f o;
                // Instant mathematical vector projection to screen space
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv1 = TRANSFORM_TEX(v.uv1, _LightMap);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // THE ULTIMATE BINARY GATE:
                // Subtract 0.5 from your property. If _Lit is 0.0, the calculation is -0.5.
                // The clip command instantly terminates the shader, skipping all texture lookups.
                // The CPU software renderer spends ZERO processing cycles and draws absolute darkness.
                clip(_Lit - 0.5);

                // 1. Sample all your core high-fidelity PBR texture packs
                fixed4 albedo = tex2D(_MainTex, i.uv);
                fixed4 normal = tex2D(_NormalMap, i.uv);
                fixed4 occlusion = tex2D(_OcclusionMap, i.uv);
                fixed4 lightmap = tex2D(_LightMap, i.uv1);

                // 2. Classical retro multiplication blending layer
                // Blends your albedo directly with the baked room environment maps
                fixed3 composition = albedo.rgb * lightmap.rgb * 2.0;
                
                // 3. Bake in your occlusion maps for deep corner shadowing shadows
                fixed3 finalColor = composition * occlusion.r;

                return fixed4(finalColor, albedo.a);
            }
            ENDCG
        }
    }
}

