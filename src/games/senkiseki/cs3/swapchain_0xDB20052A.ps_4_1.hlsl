// ---- Created with 3Dmigoto v1.3.16 on Sat Jun 07 06:09:06 2025
#include "../shared.h"


cbuffer _Globals : register(b0)
{
  uint4 DuranteSettings : packoffset(c0);

  struct
  {
    float3 EyePosition;
    float4x4 View;
    float4x4 Projection;
    float4x4 ViewProjection;
    float4x4 ViewInverse;
    float4x4 ProjectionInverse;
    float2 cameraNearFar;
    float cameraNearTimesFar;
    float cameraFarMinusNear;
    float cameraFarMinusNearInv;
    float2 ViewportWidthHeight;
    float2 screenWidthHeightInv;
    float3 GlobalAmbientColor;
    float Time;
    float3 FakeRimLightDir;
    float3 FogColor;
    float4 FogRangeParameters;
    float3 MiscParameters1;
    float4 MiscParameters2;
    float3 MonotoneMul;
    float3 MonotoneAdd;
    float3 UserClipPlane2;
    float4 UserClipPlane;
    float4 MiscParameters3;
    float AdditionalShadowOffset;
    float AlphaTestDirection;
    float4 MiscParameters4;
    float3 MiscParameters5;
    float4 light1_attenuation;
    float3 light2_position;
    float3 light2_colorIntensity;
    float4 light2_attenuation;
  } scene : packoffset(c1);

  bool PhyreContextSwitches : packoffset(c43);
  float4 FilterColor : packoffset(c44) = {1,1,1,1};
  float4 FadingColor : packoffset(c45) = {1,1,1,1};
  float4 _MonotoneMul : packoffset(c46) = {1,1,1,1};
  float4 _MonotoneAdd : packoffset(c47) = {0,0,0,0};
  float4 GlowIntensity : packoffset(c48) = {1,1,1,1};
  float4 GodrayParams : packoffset(c49) = {0,0,0,0};
  float4 GodrayParams2 : packoffset(c50) = {0,0,0,0};
  float4 GodrayColor : packoffset(c51) = {0,0,0,1};
  float4 SSRParams : packoffset(c52) = {5,0.300000012,15,1024};
  float4 ToneFactor : packoffset(c53) = {1,1,1,1};
  float4 UvScaleBias : packoffset(c54) = {1,1,0,0};
  float4 GaussianBlurParams : packoffset(c55) = {0,0,0,0};
  float4 DofParams : packoffset(c56) = {0,0,0,0};
  float4 DofParams2 : packoffset(c57) = {0,0,0,0};
  float4 GammaParameters : packoffset(c58) = {1,1,1,0};
  float4 NoiseParams : packoffset(c59) = {0,0,0,0};
  float4 WhirlPinchParams : packoffset(c60) = {0,0,0,0};
  float4 UVWarpParams : packoffset(c61) = {0,0,0,0};
  float4 MotionBlurParams : packoffset(c62) = {0,0,0,0};
  float GlobalTexcoordFactor : packoffset(c63);
}

SamplerState LinearClampSamplerState_s : register(s0);
Texture2D<float4> ColorBuffer : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = ColorBuffer.SampleLevel(LinearClampSamplerState_s, v1.xy, 0).xyzw;
  // r0.xyz = saturate(r0.xyz);
  // o0.w = r0.w;
  // r0.xyz = log2(r0.xyz);
  // r0.xyz = GammaParameters.xxx * r0.xyz;
  // o0.xyz = exp2(r0.xyz);

  r0.rgb = renodx::color::bt709::clamp::BT2020(r0.rgb);
  o0.w = r0.w;
  o0.rgb = renodx::math::SignPow(r0.rgb, GammaParameters.x);

  return;
}