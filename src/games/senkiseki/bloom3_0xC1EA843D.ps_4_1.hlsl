// ---- Created with 3Dmigoto v1.3.16 on Sun Jun 08 14:51:03 2025
#include "shared.h"
SamplerState LinearClampSamplerState_s : register(s0);
Texture2D<float4> ColorBuffer : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (BROKEN_BLOOM > 0.f) {
    r0.xyzw = ColorBuffer.SampleLevel(LinearClampSamplerState_s, v2.xy, 0).xyzw;
    r0.xyzw = float4(0.100000001,0.100000001,0.100000001,0.100000001) * r0.xyzw;
    r1.xyzw = ColorBuffer.SampleLevel(LinearClampSamplerState_s, v1.xy, 0).xyzw;
    r0.xyzw = r1.xyzw * float4(0.400000006,0.400000006,0.400000006,0.400000006) + r0.xyzw;
    r1.xyzw = ColorBuffer.SampleLevel(LinearClampSamplerState_s, v2.zw, 0).xyzw;
    r0.xyzw = r1.xyzw * float4(0.200000003,0.200000003,0.200000003,0.200000003) + r0.xyzw;
    r1.xyzw = ColorBuffer.SampleLevel(LinearClampSamplerState_s, v3.xy, 0).xyzw;
    r0.xyzw = r1.xyzw * float4(0.200000003,0.200000003,0.200000003,0.200000003) + r0.xyzw;
    r1.xyzw = ColorBuffer.SampleLevel(LinearClampSamplerState_s, v3.zw, 0).xyzw;
    o0.xyzw = r1.xyzw * float4(0.100000001, 0.100000001, 0.100000001, 0.100000001) + r0.xyzw;
  } else {
    r0.xyzw = ColorBuffer.SampleLevel(LinearClampSamplerState_s, v1.xy, 0).xyzw;
    // r0.xyzw = float4(0.100000001, 0.100000001, 0.100000001, 0.100000001) * r0.xyzw;
    // r1.xyzw = ColorBuffer.SampleLevel(LinearClampSamplerState_s, v1.xy, 0).xyzw;
    // r0.xyzw = r1.xyzw * float4(0.400000006, 0.400000006, 0.400000006, 0.400000006) + r0.xyzw;
    // r1.xyzw = ColorBuffer.SampleLevel(LinearClampSamplerState_s, v2.zw, 0).xyzw;
    // r0.xyzw = r1.xyzw * float4(0.200000003, 0.200000003, 0.200000003, 0.200000003) + r0.xyzw;
    // r1.xyzw = ColorBuffer.SampleLevel(LinearClampSamplerState_s, v3.xy, 0).xyzw;
    // r0.xyzw = r1.xyzw * float4(0.200000003, 0.200000003, 0.200000003, 0.200000003) + r0.xyzw;
    // r1.xyzw = ColorBuffer.SampleLevel(LinearClampSamplerState_s, v3.zw, 0).xyzw;
    // o0.xyzw = r1.xyzw * float4(0.100000001, 0.100000001, 0.100000001, 0.100000001) + r0.xyzw;
    o0 = r0;
    // o0 = 0.f;
    // o0.w = 1.f;
  }

  return;
}