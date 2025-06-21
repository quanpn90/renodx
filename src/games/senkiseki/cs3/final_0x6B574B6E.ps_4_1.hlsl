// ---- Created with 3Dmigoto v1.3.16 on Sat Jun 07 06:11:33 2025
#include "../shared.h"
#include "./common.hlsl"
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
Texture2DMS<float> DepthBuffer : register(t1);
Texture2D<float4> GlareBuffer : register(t2);
Texture2D<float4> FilterTexture : register(t3);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  DepthBuffer.GetDimensions(uiDest.x, uiDest.y, uiDest.z);
  r0.xy = uiDest.xy;
  r0.xy = (uint2)r0.xy;
  r0.xy = w1.xy * r0.xy;
  r0.xy = (int2)r0.xy;
  r0.zw = float2(0,0);
  r0.x = DepthBuffer.Load(r0.xy, 0).x;
  r0.x = DofParams.x + -r0.x;
  r0.x = saturate(DofParams.y / r0.x);
  r0.x = ToneFactor.y + r0.x;
  r0.x = min(1, r0.x);
  r0.yz = v1.xy * float2(1,-1) + float2(0,1);
  r1.xyzw = FilterTexture.SampleLevel(LinearClampSamplerState_s, r0.yz, 0).xyzw;
  r0.yzw = GlareBuffer.SampleLevel(LinearClampSamplerState_s, r0.yz, 0).xyz;
  r0.yzw = GlowIntensity.www * r0.yzw;
  r1.xyzw = FilterColor.xyzw * r1.xyzw;
  r1.xyz = r1.xyz * r1.www;
  r2.xyz = r1.xyz * r0.xxx;
  r3.xy = v1.xy * UvScaleBias.xy + UvScaleBias.zw;
  r3.xyz = ColorBuffer.SampleLevel(LinearClampSamplerState_s, r3.xy, 0).xyz;
  r4.xyz = ToneFactor.xxx * r3.xyz;
  r3.xyz = -r3.xyz * ToneFactor.xxx + float3(1,1,1);
  r0.yzw = r0.yzw * r3.xyz + r4.xyz;
  r3.xyz = float3(1,1,1) + -r0.yzw;
  r2.xyz = r2.xyz * r3.xyz + r0.yzw;
  r0.xyz = r1.xyz * r0.xxx + r0.yzw;
  r1.xyz = r2.xyz + -r0.xyz;
  o0.xyz = r1.xyz * float3(0.5,0.5,0.5) + r0.xyz;
  o0.w = 1;

  o0.rgb = renodx::color::gamma::DecodeSafe(o0.rgb, 2.2);
  o0.rgb = ToneMap(o0.rgb);  // for some reason ToneMapPass causes Artifact
  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  return;
}