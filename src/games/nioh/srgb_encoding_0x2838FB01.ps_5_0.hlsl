// ---- Created with 3Dmigoto v1.3.16 on Thu May 22 02:47:04 2025
#include "./shared.h"
SamplerState __smpsScreen_s : register(s0);
Texture2D<float4> sScreen : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = sScreen.Sample(__smpsScreen_s, v1.xy).xyzw;

  if (shader_injection.tone_map_type == 0.f) {
    r1.xyz = log2(r0.xyz);
    r1.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r1.xyz;
    r1.xyz = exp2(r1.xyz); // x ^ (1 / 2.4)
    r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r2.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
    r0.xyz = cmp(r0.xyz < float3(0.00313100009,0.00313100009,0.00313100009));
    o0.w = r0.w;
    o0.xyz = r0.xyz ? r2.xyz : r1.xyz;
  }
  else
    o0.xyzw = r0.xyzw;
  return;
}