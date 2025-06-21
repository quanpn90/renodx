// ---- Created with 3Dmigoto v1.3.16 on Thu May 22 02:47:04 2025

cbuffer _Globals : register(b0)
{
  float4 WhiteColorInterpolationRGBA : packoffset(c0);
  float4 BlackColorInterpolationRGBA : packoffset(c1);
  float vATest : packoffset(c2);
}

SamplerState __smpsStage0_s : register(s0);
Texture2D<float4> sStage0 : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = sStage0.Sample(__smpsStage0_s, v2.xy).xyzw;
  r1.xyzw = v1.xyzw * r0.xyzw;
  float3 final = r1.rgb;
  r0.w = cmp(r1.w < vATest);
  if (r0.w != 0) discard;
  r2.xyz = WhiteColorInterpolationRGBA.xyz * WhiteColorInterpolationRGBA.xyz;
  r3.xyz = BlackColorInterpolationRGBA.xyz * BlackColorInterpolationRGBA.xyz;
  r0.xyz = -r0.xyz * v1.xyz + float3(1,1,1);
  r0.xyz = r3.xyz * r0.xyz;
  o0.xyz = r2.xyz * r1.xyz + r0.xyz;

  // o0.xyz *= 2;
  o0.w = r1.w;
  return;
}