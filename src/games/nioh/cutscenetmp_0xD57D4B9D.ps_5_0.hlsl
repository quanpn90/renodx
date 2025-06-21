// ---- Created with 3Dmigoto v1.3.16 on Thu May 22 17:45:39 2025
#include "./shared.h"
cbuffer _Globals : register(b0)
{
  float4 vPreColorCorrectionMatrix[3] : packoffset(c0);
  float3 vColorScale : packoffset(c3) = {1,1,1};
  float3 vSaturationScale : packoffset(c4) = {1,1,1};
  float4 vScreenSize : packoffset(c5) = {1920,1080,1920,1080};
  float4 vSpotParams : packoffset(c6) = {960,540,450,600};
  float fLimbDarkening : packoffset(c7) = {755364.125};
  float fLimbDarkeningWeight : packoffset(c7.y) = {0};
  float2 SimulateHDRParams : packoffset(c7.z);
  float2 vToneCurvCol2Coord : packoffset(c8) = {0.99609375,0.001953125};
}

SamplerState smplAdaptedLumLast_s : register(s0);
SamplerState smplScene_s : register(s1);
SamplerState smplLightShaftLinWork2_s : register(s2);
SamplerState sampToneCurv_s : register(s3);
Texture2D<float4> smplAdaptedLumLast_Tex : register(t0);
Texture2D<float4> smplScene_Tex : register(t1);
Texture2D<float4> smplLightShaftLinWork2_Tex : register(t2);
Texture2D<float4> sampToneCurv_Tex : register(t3);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = smplAdaptedLumLast_Tex.Sample(smplAdaptedLumLast_s, float2(0.25,0.5)).x;
  r0.yzw = smplLightShaftLinWork2_Tex.Sample(smplLightShaftLinWork2_s, v1.xy).xyz;
  r1.xyzw = smplScene_Tex.Sample(smplScene_s, v1.xy).xyzw;
  r1.xyz = max(float3(0,0,0), r1.xyz);
  o0.w = r1.w;
  r2.x = dot(r1.xyz, vPreColorCorrectionMatrix[0].xyz);
  r2.y = dot(r1.xyz, vPreColorCorrectionMatrix[1].xyz);
  r2.z = dot(r1.xyz, vPreColorCorrectionMatrix[2].xyz);
  r0.xyz = r2.xyz * r0.xxx + r0.yzw;
  r1.xyz = vColorScale.xyz * r0.xyz;
  r0.w = dot(r1.xyz, float3(0.298909992,0.586610019,0.114480004));
  r0.xyz = r0.xyz * vColorScale.xyz + -r0.www;
  r0.xyz = vSaturationScale.xyz * r0.xyz + r0.www;
  r1.xy = v1.xy * vScreenSize.zw + -vSpotParams.xy;
  r0.w = dot(r1.xy, r1.xy);
  r1.x = fLimbDarkening + r0.w;
  r0.w = sqrt(r0.w);
  r0.w = -vSpotParams.z + r0.w;
  r1.x = fLimbDarkening / r1.x;
  r1.x = r1.x * r1.x;
  r1.xyz = r1.xxx * r0.xyz;
  r1.w = cmp(0 >= r0.w);
  r0.w = saturate(vSpotParams.w / r0.w);
  r0.w = r1.w ? 1 : r0.w;
  r1.xyz = r1.xyz * r0.www;
  r1.xyz = fLimbDarkeningWeight * r1.xyz;
  r0.w = 1 + -fLimbDarkeningWeight;
  r0.xyz = r0.xyz * r0.www + r1.xyz;

  float3 untonemapped = r0.xyz;
  float3 midgray = renodx::tonemap::uncharted2::BT709(float3(0.18f, 0.18f, 0.18f), SimulateHDRParams.x);
  float mid_gray_nits = renodx::color::y::from::BT709(midgray);
  untonemapped *= mid_gray_nits / 0.18f;  // scale untonemapped midgray, tonemappass expects 0.18f

  // tonemapping
  r1.xyz = r0.xyz * float3(0.219999999,0.219999999,0.219999999) + float3(0.0299999993,0.0299999993,0.0299999993);
  r1.xyz = r0.xyz * r1.xyz + float3(0.00200000009,0.00200000009,0.00200000009);
  r2.xyz = r0.xyz * float3(0.219999999,0.219999999,0.219999999) + float3(0.300000012,0.300000012,0.300000012);
  r0.xyz = r0.xyz * r2.xyz + float3(0.0599999987,0.0599999987,0.0599999987);
  r0.xyz = r1.xyz / r0.xyz;

  // color grading
  r0.xyz = float3(-0.0333000012,-0.0333000012,-0.0333000012) + r0.xyz;
  r0.xyz = SimulateHDRParams.xxx * r0.xyz;
  r0.xyz = r0.xyz * vToneCurvCol2Coord.xxx + vToneCurvCol2Coord.yyy;
  r0.w = 0.5;
  r0.x = sampToneCurv_Tex.Sample(sampToneCurv_s, r0.xw).x;
  o0.x = r0.x;
  r0.x = sampToneCurv_Tex.Sample(sampToneCurv_s, r0.yw).y;
  r0.y = sampToneCurv_Tex.Sample(sampToneCurv_s, r0.zw).z;
  o0.yz = r0.xy;

  float3 sdr = o0.xyz;
  if (shader_injection.tone_map_type != 0.f) {
    o0.rgb = renodx::draw::ToneMapPass(untonemapped, sdr);
    // o0.rgb = renodx::draw::ToneMapPass(untonemapped);

    o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  }
  else {
    o0.rgb = sdr;
  }

  return;
}