                                      // ---- Created with 3Dmigoto v1.3.16 on Wed May 14 22:04:14 2025
#include "./common.hlsl"
#include "./shared.h"

cbuffer _Globals : register(b0)
{
  float vATest : packoffset(c0);
}

SamplerState smp_s : register(s0);
Texture2D<float4> tex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = v1.w; // -vATest + v1.w;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.xyzw = tex.Sample(smp_s, v2.xy).xyzw;
  o0.xyz = v1.xyz * r0.xyz;
  o0.w = v1.w;

  // o0.rgb = renodx::color::gamma::EncodeSafe(o0.rgb, 2.2f);

  // o0 = saturate(o0);
  // o0 = renodx::color::srgb::DecodeSafe(o0);

  // The below code doesn't work, can't separate UI and FMVs. 

  float3 inverse = o0.rgb;
  // // Inverse tonemapping code

  // // uint texWidth, texHeight;
  // // tex.GetDimensions(texWidth, texHeight);

  // // bool is_fmv = (vATest < -1e30);  // Negative infinity-ish
  // // bool is_ui = !is_fmv;

  // // if (shader_injection.tone_map_type != 0.f) {
  //   // float3 saturated = saturate(r0.rgb);
  float3 saturated = r0.rgb;

  float videoPeak =
      shader_injection.peak_white_nits;
  inverse = renodx::color::gamma::Decode(saturated, 2.4f);  // 2.4 for BT2446a
  inverse = renodx::tonemap::inverse::bt2446a::BT709(inverse, 100.f, videoPeak);
  inverse /= videoPeak;                                                               // Normalize to 1.0f = peak;
  inverse *= shader_injection.peak_white_nits /
      shader_injection.diffuse_white_nits;  // 1.f = game nits

  o0.rgb = PostToneMapScale(inverse);  // Gamma Correct
  // }
  
  return;
}