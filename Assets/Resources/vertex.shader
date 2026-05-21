Shader "VertexLit"
{
    Properties
    {
        _MainTex ("Base Texture", 2D) = "white" {}
        _CustomRange ("Fallback Range", Float) = 15.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        // ==========================================
        // PASS 1: The Ambient Base Pass (Blackout Default)
        // ==========================================
        Pass
        {
            Tags { "LightMode"="ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata { float4 vertex : POSITION; float2 uv : TEXCOORD0; };
            struct v2f { float4 pos : SV_POSITION; float2 uv : TEXCOORD0; };
            sampler2D _MainTex;

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                // Hardcoded to absolute zero ambient light. 
                // Unless a light pass hits it, the room stays pitch black.
                return col * fixed4(0, 0, 0, 1); 
            }
            ENDCG
        }

        // ==========================================
        // PASS 2: The Point Light Additive Pass
        // ==========================================
        Pass
        {
            Tags { "LightMode"="ForwardAdd" }
            Blend One One // Mathematically adds the light on top of the black base pass
            ZWrite Off    // Avoids re-writing depth buffers repeatedly
            ZTest LEqual

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                fixed4 color : COLOR;
            };

            sampler2D _MainTex;
            float _CustomRange;

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                // Fetch world coordinates for calculations
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                // In ForwardAdd, _WorldSpaceLightPos0 handles Point Light coordinates natively!
                float3 lightPos = _WorldSpaceLightPos0.xyz;

                // Range and distance math
                float3 lightVec = lightPos - worldPos;
                float dist = length(lightVec);
                float atten = saturate((_CustomRange - dist) / _CustomRange);

                // Simple diffuse surface shading
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float3 lightDir = normalize(lightVec);
                float diffuse = saturate(dot(worldNormal, lightDir));

                // Combine with native light component brightness color
                o.color = _LightColor0 * (diffuse * atten);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col * i.color;
            }
            ENDCG
        }
    }
}

