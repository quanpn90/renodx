// ---- Created with 3Dmigoto v1.3.16 on Tue May 20 17:31:24 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[131];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[130].w + cb0[130].w;
  r1.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[19].x).xyzw;
  r0.yzw = min(cb0[130].yyy, r1.xyz);
  r1.x = max(r0.y, r0.z);
  r1.x = max(r1.x, r0.w);
  r1.y = -cb0[130].z + r1.x;
  r1.z = cb0[130].w + r1.y;
  r1.xz = max(float2(9.99999975e-005,0), r1.xz);
  r0.x = min(r1.z, r0.x);
  r0.x = r0.x * r0.x;
  r1.z = cb0[130].w * 4 + 9.99999975e-005;
  r0.x = r0.x / r1.z;
  r0.x = max(r1.y, r0.x);
  r0.x = r0.x / r1.x;
  r0.xyz = r0.yzw * r0.xxx;
  // o0.xyz = max(float3(0,0,0), r0.xyz);
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}