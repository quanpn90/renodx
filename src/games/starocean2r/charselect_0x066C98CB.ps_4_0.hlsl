// ---- Created with 3Dmigoto v1.3.16 on Sun May 25 02:31:17 2025
#include "./shared.h"
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[4];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 255 * v1.w;
  r0.x = round(r0.x);
  r0.w = 0.00392156886 * r0.x;
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r1.xyzw = cb0[3].xyzw + r1.xyzw;
  r0.xyz = v1.xyz;
  r0.xyzw = r1.xyzw * r0.xyzw;
  o0.xyz = r0.xyz * r0.www;

  float3 untonemapped = renodx::color::srgb::DecodeSafe(o0.xyz);
  float dicePeak = RESTORE_HIGHLIGHT_PEAK;          // 2.f default
  float diceShoulder = RESTORE_HIGHLIGHT_SHOULDER;  // 0.5f default
  float3 sdr = renodx::tonemap::dice::BT709(untonemapped, dicePeak, diceShoulder);
  o0.rgb = renodx::draw::ToneMapPass(untonemapped);
  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);

  // o0.xyz = sdr;
  o0.w = r0.w;
  return;
}