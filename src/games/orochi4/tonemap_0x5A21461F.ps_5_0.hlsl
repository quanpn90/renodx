// ---- Created with 3Dmigoto v1.3.16 on Fri May 23 15:41:51 2025
#include "./common.hlsl"
#include "./rcas.hlsl"
#include "./shared.h"

cbuffer _Globals : register(b0)
{
  float4 vUVOffset : packoffset(c0) = {0,0,1,1};
  float fEdgeSharpness : packoffset(c1) = {8};
  float fPixelRange : packoffset(c1.y) = {2};
  float4 vRecipScreenSize : packoffset(c2) = {0.00052083336,0.00092592591,0.00026041668,0.000462962955};
  float4 vLightShaftPower : packoffset(c3) = {0.200000003,0.119999997,0.119999997,37};
  float fBloomWeight : packoffset(c4) = {1};
  float fMaxLum : packoffset(c4.y) = {4.19999981};
  float fStarWeight : packoffset(c4.z);
  float3 vColorScale : packoffset(c5);
  float3 vSaturationScale : packoffset(c6);
  float fParamA : packoffset(c6.w) = {0.219999999};
  float fParamCB : packoffset(c7) = {0.0299999993};
  float fParamDE : packoffset(c7.y) = {0.00200000009};
  float fParamB : packoffset(c7.z) = {0.300000012};
  float fParamDF : packoffset(c7.w) = {0.0599999987};
  float fParamEperF : packoffset(c8) = {0.0333000012};
  float fWhiteTone : packoffset(c8.y) = {1.14999998};
  float fGamma : packoffset(c8.z);
}

SamplerState smplAdaptedLumLast_s : register(s0);
SamplerState smplLightShaft_s : register(s1);
SamplerState smplBloom_s : register(s2);
SamplerState smplStar_s : register(s3);
SamplerState smplScene_s : register(s4);
Texture2D<float4> smplAdaptedLumLast_Tex : register(t0);
Texture2D<float4> smplLightShaft_Tex : register(t1);
Texture2D<float4> smplBloom_Tex : register(t2);
Texture2D<float4> smplStar_Tex : register(t3);
Texture2D<float4> smplScene_Tex : register(t4);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = v2.xyzw * vUVOffset.zwzw + vUVOffset.xyxy;
  r1.xyz = smplScene_Tex.Sample(smplScene_s, r0.xy).xyz;
  r0.xyz = smplScene_Tex.Sample(smplScene_s, r0.zw).xyz;

  // r0.xyz = max(float3(0,0,0), r0.xyz);
  // r0.w = dot(r0.xyz, float3(0.298999995, 0.587000012, 0.114));
  r0.w = dot(r0.xyz, float3(0.2126390059f, 0.7151686788f, 0.0721923154f));

  // r1.xyz = max(float3(0,0,0), r1.xyz);
  // r0.z = dot(r1.xyz, float3(0.298999995, 0.587000012, 0.114));
  r0.z = dot(r1.xyz, float3(0.2126390059f, 0.7151686788f, 0.0721923154f));
  r1.xyzw = v3.xyzw * vUVOffset.zwzw + vUVOffset.xyxy;
  r2.xyz = smplScene_Tex.Sample(smplScene_s, r1.xy).xyz;
  r1.xyz = smplScene_Tex.Sample(smplScene_s, r1.zw).xyz;
  // r1.xyz = max(float3(0,0,0), r1.xyz);
  // r0.x = dot(r1.xyz, float3(0.298999995, 0.587000012, 0.114));
  r0.x = dot(r1.xyz, float3(0.2126390059f, 0.7151686788f, 0.0721923154f));

  // r1.xyz = max(float3(0,0,0), r2.xyz);
  // r0.y = dot(r1.xyz, float3(0.298999995,0.587000012,0.114));
  r0.y = dot(r1.xyz, float3(0.2126390059f, 0.7151686788f, 0.0721923154f));
  r1.xyzw = r0.yzzw + r0.xwyx;
  r1.xy = r1.xz + -r1.yw;
  r1.z = min(abs(r1.x), abs(r1.y));
  r1.z = r1.z * fEdgeSharpness + 0.00100000005;
  r1.zw = r1.xy / r1.zz;
  r2.xy = vRecipScreenSize.zw * r1.xy;
  r1.xy = max(-fPixelRange, r1.zw);
  r1.xy = min(fPixelRange, r1.xy);
  r1.zw = vRecipScreenSize.xy * fPixelRange;
  r2.zw = r1.xy * r1.zw;
  r1.xyzw = v1.xyxy * vUVOffset.zwzw + vUVOffset.xyxy;
  r3.xyzw = r1.zwzw + -r2.xyzw;
  r2.xyzw = r1.xyzw + r2.xyzw;
  r1.xyzw = smplScene_Tex.Sample(smplScene_s, r1.zw).xyzw;
  r4.xyz = smplScene_Tex.Sample(smplScene_s, r3.zw).xyz;
  r3.xyz = smplScene_Tex.Sample(smplScene_s, r3.xy).xyz;
  // r3.xyz = max(float3(0,0,0), r3.xyz);
  // r4.xyz = max(float3(0,0,0), r4.xyz);
  r5.xyz = smplScene_Tex.Sample(smplScene_s, r2.zw).xyz;
  r2.xyz = smplScene_Tex.Sample(smplScene_s, r2.xy).xyz;
  // r2.xyz = max(float3(0,0,0), r2.xyz);
  r2.xyz = r3.xyz + r2.xyz;
  // r3.xyz = max(float3(0,0,0), r5.xyz);
  r3.xyz = r4.xyz + r3.xyz;
  r3.xyz = float3(0.25,0.25,0.25) * r3.xyz;
  r3.xyz = r2.xyz * float3(0.25,0.25,0.25) + r3.xyz;
  r2.xyz = float3(0.5,0.5,0.5) * r2.xyz;
  // r2.w = dot(r3.xyz, float3(0.298999995, 0.587000012, 0.114));
  r2.w = dot(r3.xyz, float3(0.2126390059f, 0.7151686788f, 0.0721923154f));
  r4.xy = min(r0.zy, r0.wx);
  r0.xy = max(r0.zy, r0.wx);
  r0.x = max(r0.x, r0.y);
  r0.y = min(r4.x, r4.y);
  // r4.xyz = max(float3(0,0,0), r1.xyz);
  r4.xyz = r1.xyz;
  // r0.z = dot(r4.xyz, float3(0.298999995, 0.587000012, 0.114));
  r0.z = dot(r4.xyz, float3(0.2126390059f, 0.7151686788f, 0.0721923154f));
  r0.y = min(r0.z, r0.y);
  r0.x = max(r0.z, r0.x);
  r0.x = cmp(r0.x < r2.w);
  r0.y = cmp(r2.w < r0.y);
  r0.x = (int)r0.x | (int)r0.y;
  r0.xyz = r0.xxx ? r2.xyz : r3.xyz;

  // God-Ray
  r2.xyz = smplLightShaft_Tex.Sample(smplLightShaft_s, v1.xy).xyz;
  r2.xyz = vLightShaftPower.xyz * r2.xyz;
  r0.w = smplAdaptedLumLast_Tex.Sample(smplAdaptedLumLast_s, float2(0.5,0.5)).x;
  r1.xyz = r0.xyz * r0.www + r2.xyz;

  // Bloom Pass 
  r0.xyzw = smplBloom_Tex.Sample(smplBloom_s, v1.xy).xyzw;
  r2.x = fBloomWeight / fMaxLum;
  r0.xyzw = r2.xxxx * r0.xyzw; // Bloom texture stored in r0?

  r0.xyzw = r0.xyzw * float4(0.5,0.5,0.5,0.5) + r1.xyzw;
  r1.xyzw = smplStar_Tex.Sample(smplStar_s, v1.xy).xyzw;
  r0.xyzw = r1.xyzw * fStarWeight + r0.xyzw;
  r1.xyz = vColorScale.xyz * r0.xyz;
  // r1.x = dot(r1.xyz, float3(0.298909992,0.586610019,0.114480004));
  r1.x = dot(r1.xyz, float3(0.2126390059f, 0.7151686788f, 0.0721923154f));
  r0.xyz = r0.xyz * vColorScale.xyz + -r1.xxx;
  o0.w = r0.w;
  r0.xyz = vSaturationScale.xyz * r0.xyz + r1.xxx;

  float3 untonemapped = r0.xyz;
  r0.xyz = RestoreHighlightSaturation(untonemapped); 

  r1.xyz = fParamA * r0.xyz + fParamCB;
  r1.xyz = r0.xyz * r1.xyz + fParamDE;
  r2.xyz = fParamA * r0.xyz + fParamB;
  r0.xyz = r0.xyz * r2.xyz + fParamDF;
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = -fParamEperF + r0.xyz;
  r0.xyz = fWhiteTone * r0.xyz;

  float3 sdr = r0.xyz;

  if (shader_injection.tone_map_type == 0.f) {
    o0.xyz = renodx::math::SafePow(r0.xyz, fGamma);
    
  } else {
    // tonemap (0.18) to find mid gray
    r0.xyz = float3(0.18f, 0.18f, 0.18f);
    r1.xyz = fParamA * r0.xyz + fParamCB;
    r1.xyz = r0.xyz * r1.xyz + fParamDE;
    r2.xyz = fParamA * r0.xyz + fParamB;
    r0.xyz = r0.xyz * r2.xyz + fParamDF;
    r0.xyz = r1.xyz / r0.xyz;
    r0.xyz = -fParamEperF + r0.xyz;
    r0.xyz = fWhiteTone * r0.xyz;

    float mid_gray = renodx::color::y::from::BT709(r0.xyz);
    o0.rgb = CustomToneMapPass(untonemapped, sdr, mid_gray);
    o0.rgb = renodx::color::bt709::clamp::BT2020(o0.rgb);

  }

  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);

  return;
}