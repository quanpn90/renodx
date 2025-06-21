// ---- Created with 3Dmigoto v1.3.16 on Thu May 22 17:40:32 2025

cbuffer _Globals : register(b0)
{
  float vATest : packoffset(c0);
}



// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(v1.w < vATest);
  if (r0.x != 0) discard;
  o0.xyzw = v1.xyzw;
  return;
}