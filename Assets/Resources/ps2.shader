Shader "PS2"
{
Properties
{
_MainTex ("Albedo (RGB)", 2D) = "white" {}
_OcclusionMap ("Occlusion (G)", 2D) = "white" {}
_BumpMap ("Normal Map", 2D) = "bump" {}
_OcclusionStrength ("Occlusion Strength", Range(0, 1)) = 1.0
}
SubShader
{
Tags
{
"RenderType" = "Opaque"
}
LOD 200
CGPROGRAM
#pragma surface surf Lambert
sampler2D _MainTex;
sampler2D _OcclusionMap;
sampler2D _BumpMap;
fixed _OcclusionStrength;
struct Input
{
float2 uv_MainTex;
};
void surf(Input IN, inout SurfaceOutput o)
{
fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
fixed occ = tex2D(_OcclusionMap, IN.uv_MainTex).g;
occ = lerp(1.0, occ, _OcclusionStrength);
o.Albedo = c.rgb *occ;
o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
o.Gloss = 0;
o.Specular = 0;
o.Alpha = c.a;
}
ENDCG
}
FallBack "Diffuse"
}
