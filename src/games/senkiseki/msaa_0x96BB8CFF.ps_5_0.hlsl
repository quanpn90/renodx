// ---- Created with 3Dmigoto v1.3.16 on Fri Jun 06 16:40:11 2025
#include "shared.h"
SamplerState LinearClampSampler_s : register(s0);
Texture2D<float4> ColorBuffer : register(t0);


// 3Dmigoto declarations
#define cmp -

float3 ToneMap(float3 color) {
  renodx::draw::Config draw_config = renodx::draw::BuildConfig();
  draw_config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  // draw_config.tone_map_pass_autocorrection = 0.5;

  renodx::tonemap::Config tone_map_config = renodx::tonemap::config::Create();
  tone_map_config.peak_nits = draw_config.peak_white_nits;
  tone_map_config.game_nits = draw_config.diffuse_white_nits;
  tone_map_config.type = draw_config.tone_map_type;
  tone_map_config.gamma_correction = draw_config.gamma_correction;
  tone_map_config.exposure = draw_config.tone_map_exposure;
  tone_map_config.highlights = draw_config.tone_map_highlights;
  tone_map_config.shadows = draw_config.tone_map_shadows;
  tone_map_config.contrast = draw_config.tone_map_contrast;
  tone_map_config.saturation = draw_config.tone_map_saturation;

  tone_map_config.mid_gray_value = 0.18f;
  tone_map_config.mid_gray_nits = tone_map_config.mid_gray_value * 100.f;

  tone_map_config.reno_drt_highlights = 1.0f;
  tone_map_config.reno_drt_shadows = 1.0f;
  tone_map_config.reno_drt_contrast = 1.0f;
  tone_map_config.reno_drt_saturation = 1.0f;
  tone_map_config.reno_drt_blowout = -1.f * (draw_config.tone_map_highlight_saturation - 1.f);
  tone_map_config.reno_drt_dechroma = draw_config.tone_map_blowout;
  tone_map_config.reno_drt_flare = 0.10f * pow(draw_config.tone_map_flare, 10.f);
  tone_map_config.reno_drt_working_color_space = (uint)draw_config.tone_map_working_color_space;
  tone_map_config.reno_drt_per_channel = draw_config.tone_map_per_channel == 1.f;
  tone_map_config.reno_drt_hue_correction_method = (uint)draw_config.tone_map_hue_processor;
  tone_map_config.reno_drt_clamp_color_space = draw_config.tone_map_clamp_color_space;
  tone_map_config.reno_drt_clamp_peak = draw_config.tone_map_clamp_peak;
  tone_map_config.reno_drt_tone_map_method = (uint)draw_config.reno_drt_tone_map_method;
  tone_map_config.reno_drt_white_clip = draw_config.reno_drt_white_clip;

  // removed the code for hue correction
  float3 tonemapped = renodx::tonemap::config::Apply(color, tone_map_config);

  return tonemapped;
}


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = ColorBuffer.SampleLevel(LinearClampSampler_s, v1.xy, 0).xyzw;
  r1.xyz = ColorBuffer.Gather(LinearClampSampler_s, v1.xy).xyz;
  r2.xyz = ColorBuffer.Gather(LinearClampSampler_s, v1.xy, int2(-1, -1)).xzw;
  r1.w = max(r1.x, r0.w);
  r2.w = min(r1.x, r0.w);
  r1.w = max(r1.z, r1.w);
  r2.w = min(r2.w, r1.z);
  r3.x = max(r2.y, r2.x);
  r3.y = min(r2.y, r2.x);
  r1.w = max(r3.x, r1.w);
  r2.w = min(r3.y, r2.w);
  r3.x = 0.100000001 * r1.w;
  r1.w = -r2.w + r1.w;
  r2.w = max(0.0833000019, r3.x);
  r2.w = cmp(r1.w >= r2.w);
  if (r2.w != 0) {
    ColorBuffer.GetDimensions(0, fDest.x, fDest.y, fDest.z);
    r3.xy = fDest.xy;
    r3.xy = float2(1,1) / r3.xy;
    r2.w = ColorBuffer.SampleLevel(LinearClampSampler_s, v1.xy, 0, int2(1, -1)).w;
    r3.z = ColorBuffer.SampleLevel(LinearClampSampler_s, v1.xy, 0, int2(-1, 1)).w;
    r4.xy = r2.yx + r1.xz;
    r1.w = 1 / r1.w;
    r3.w = r4.x + r4.y;
    r4.xy = r0.ww * float2(-2,-2) + r4.xy;
    r4.z = r2.w + r1.y;
    r2.w = r2.z + r2.w;
    r4.w = r1.z * -2 + r4.z;
    r2.w = r2.y * -2 + r2.w;
    r2.z = r3.z + r2.z;
    r1.y = r3.z + r1.y;
    r3.z = abs(r4.x) * 2 + abs(r4.w);
    r2.w = abs(r4.y) * 2 + abs(r2.w);
    r4.x = r2.x * -2 + r2.z;
    r1.y = r1.x * -2 + r1.y;
    r3.z = abs(r4.x) + r3.z;
    r1.y = abs(r1.y) + r2.w;
    r2.z = r2.z + r4.z;
    r1.y = cmp(r3.z >= r1.y);
    r2.z = r3.w * 2 + r2.z;
    r2.x = r1.y ? r2.y : r2.x;
    r1.x = r1.y ? r1.x : r1.z;
    r1.z = r1.y ? r3.y : r3.x;
    r2.y = r2.z * 0.0833333358 + -r0.w;
    r2.z = r2.x + -r0.w;
    r2.w = r1.x + -r0.w;
    r2.x = r2.x + r0.w;
    r1.x = r1.x + r0.w;
    r3.z = cmp(abs(r2.z) >= abs(r2.w));
    r2.z = max(abs(r2.z), abs(r2.w));
    r1.z = r3.z ? -r1.z : r1.z;
    r1.w = saturate(abs(r2.y) * r1.w);
    r2.y = r1.y ? r3.x : 0;
    r2.w = r1.y ? 0 : r3.y;
    r3.xy = r1.zz * float2(0.5,0.5) + v1.xy;
    r3.x = r1.y ? v1.x : r3.x;
    r3.y = r1.y ? r3.y : v1.y;
    r4.xy = r3.xy + -r2.yw;
    r5.xy = r3.xy + r2.yw;
    r3.x = r1.w * -2 + 3;
    r3.y = ColorBuffer.SampleLevel(LinearClampSampler_s, r4.xy, 0).w;
    r1.w = r1.w * r1.w;
    r3.w = ColorBuffer.SampleLevel(LinearClampSampler_s, r5.xy, 0).w;
    r1.x = r3.z ? r2.x : r1.x;
    r2.x = 0.25 * r2.z;
    r0.w = -r1.x * 0.5 + r0.w;
    r1.w = r3.x * r1.w;
    r0.w = cmp(r0.w < 0);
    r3.x = -r1.x * 0.5 + r3.y;
    r3.y = -r1.x * 0.5 + r3.w;
    r3.zw = cmp(abs(r3.xy) >= r2.xx);
    r2.z = -r2.y * 1.5 + r4.x;
    r4.x = r3.z ? r4.x : r2.z;
    r2.z = -r2.w * 1.5 + r4.y;
    r4.z = r3.z ? r4.y : r2.z;
    r4.yw = ~(int2)r3.zw;
    r2.z = (int)r4.w | (int)r4.y;
    r4.y = r2.y * 1.5 + r5.x;
    r4.y = r3.w ? r5.x : r4.y;
    r5.x = r2.w * 1.5 + r5.y;
    r4.w = r3.w ? r5.y : r5.x;
    if (r2.z != 0) {
      if (r3.z == 0) {
        r3.x = ColorBuffer.SampleLevel(LinearClampSampler_s, r4.xz, 0).w;
      }
      if (r3.w == 0) {
        r3.y = ColorBuffer.SampleLevel(LinearClampSampler_s, r4.yw, 0).w;
      }
      r2.z = -r1.x * 0.5 + r3.x;
      r3.x = r3.z ? r3.x : r2.z;
      r2.z = -r1.x * 0.5 + r3.y;
      r3.y = r3.w ? r3.y : r2.z;
      r3.zw = cmp(abs(r3.xy) >= r2.xx);
      r2.z = -r2.y * 2 + r4.x;
      r4.x = r3.z ? r4.x : r2.z;
      r2.z = -r2.w * 2 + r4.z;
      r4.z = r3.z ? r4.z : r2.z;
      r5.xy = ~(int2)r3.zw;
      r2.z = (int)r5.y | (int)r5.x;
      r5.x = r2.y * 2 + r4.y;
      r4.y = r3.w ? r4.y : r5.x;
      r5.x = r2.w * 2 + r4.w;
      r4.w = r3.w ? r4.w : r5.x;
      if (r2.z != 0) {
        if (r3.z == 0) {
          r3.x = ColorBuffer.SampleLevel(LinearClampSampler_s, r4.xz, 0).w;
        }
        if (r3.w == 0) {
          r3.y = ColorBuffer.SampleLevel(LinearClampSampler_s, r4.yw, 0).w;
        }
        r2.z = -r1.x * 0.5 + r3.x;
        r3.x = r3.z ? r3.x : r2.z;
        r2.z = -r1.x * 0.5 + r3.y;
        r3.y = r3.w ? r3.y : r2.z;
        r3.zw = cmp(abs(r3.xy) >= r2.xx);
        r2.z = -r2.y * 2 + r4.x;
        r4.x = r3.z ? r4.x : r2.z;
        r2.z = -r2.w * 2 + r4.z;
        r4.z = r3.z ? r4.z : r2.z;
        r5.xy = ~(int2)r3.zw;
        r2.z = (int)r5.y | (int)r5.x;
        r5.x = r2.y * 2 + r4.y;
        r4.y = r3.w ? r4.y : r5.x;
        r5.x = r2.w * 2 + r4.w;
        r4.w = r3.w ? r4.w : r5.x;
        if (r2.z != 0) {
          if (r3.z == 0) {
            r3.x = ColorBuffer.SampleLevel(LinearClampSampler_s, r4.xz, 0).w;
          }
          if (r3.w == 0) {
            r3.y = ColorBuffer.SampleLevel(LinearClampSampler_s, r4.yw, 0).w;
          }
          r2.z = -r1.x * 0.5 + r3.x;
          r3.x = r3.z ? r3.x : r2.z;
          r2.z = -r1.x * 0.5 + r3.y;
          r3.y = r3.w ? r3.y : r2.z;
          r3.zw = cmp(abs(r3.xy) >= r2.xx);
          r2.z = -r2.y * 2 + r4.x;
          r4.x = r3.z ? r4.x : r2.z;
          r2.z = -r2.w * 2 + r4.z;
          r4.z = r3.z ? r4.z : r2.z;
          r5.xy = ~(int2)r3.zw;
          r2.z = (int)r5.y | (int)r5.x;
          r5.x = r2.y * 2 + r4.y;
          r4.y = r3.w ? r4.y : r5.x;
          r5.x = r2.w * 2 + r4.w;
          r4.w = r3.w ? r4.w : r5.x;
          if (r2.z != 0) {
            if (r3.z == 0) {
              r3.x = ColorBuffer.SampleLevel(LinearClampSampler_s, r4.xz, 0).w;
            }
            if (r3.w == 0) {
              r3.y = ColorBuffer.SampleLevel(LinearClampSampler_s, r4.yw, 0).w;
            }
            r2.z = -r1.x * 0.5 + r3.x;
            r3.x = r3.z ? r3.x : r2.z;
            r2.z = -r1.x * 0.5 + r3.y;
            r3.y = r3.w ? r3.y : r2.z;
            r3.zw = cmp(abs(r3.xy) >= r2.xx);
            r2.z = -r2.y * 2 + r4.x;
            r4.x = r3.z ? r4.x : r2.z;
            r2.z = -r2.w * 2 + r4.z;
            r4.z = r3.z ? r4.z : r2.z;
            r5.xy = ~(int2)r3.zw;
            r2.z = (int)r5.y | (int)r5.x;
            r5.x = r2.y * 2 + r4.y;
            r4.y = r3.w ? r4.y : r5.x;
            r5.x = r2.w * 2 + r4.w;
            r4.w = r3.w ? r4.w : r5.x;
            if (r2.z != 0) {
              if (r3.z == 0) {
                r3.x = ColorBuffer.SampleLevel(LinearClampSampler_s, r4.xz, 0).w;
              }
              if (r3.w == 0) {
                r3.y = ColorBuffer.SampleLevel(LinearClampSampler_s, r4.yw, 0).w;
              }
              r2.z = -r1.x * 0.5 + r3.x;
              r3.x = r3.z ? r3.x : r2.z;
              r2.z = -r1.x * 0.5 + r3.y;
              r3.y = r3.w ? r3.y : r2.z;
              r3.zw = cmp(abs(r3.xy) >= r2.xx);
              r2.z = -r2.y * 2 + r4.x;
              r4.x = r3.z ? r4.x : r2.z;
              r2.z = -r2.w * 2 + r4.z;
              r4.z = r3.z ? r4.z : r2.z;
              r5.xy = ~(int2)r3.zw;
              r2.z = (int)r5.y | (int)r5.x;
              r5.x = r2.y * 2 + r4.y;
              r4.y = r3.w ? r4.y : r5.x;
              r5.x = r2.w * 2 + r4.w;
              r4.w = r3.w ? r4.w : r5.x;
              if (r2.z != 0) {
                if (r3.z == 0) {
                  r3.x = ColorBuffer.SampleLevel(LinearClampSampler_s, r4.xz, 0).w;
                }
                if (r3.w == 0) {
                  r3.y = ColorBuffer.SampleLevel(LinearClampSampler_s, r4.yw, 0).w;
                }
                r2.z = -r1.x * 0.5 + r3.x;
                r3.x = r3.z ? r3.x : r2.z;
                r2.z = -r1.x * 0.5 + r3.y;
                r3.y = r3.w ? r3.y : r2.z;
                r3.zw = cmp(abs(r3.xy) >= r2.xx);
                r2.z = -r2.y * 2 + r4.x;
                r4.x = r3.z ? r4.x : r2.z;
                r2.z = -r2.w * 2 + r4.z;
                r4.z = r3.z ? r4.z : r2.z;
                r5.xy = ~(int2)r3.zw;
                r2.z = (int)r5.y | (int)r5.x;
                r5.x = r2.y * 2 + r4.y;
                r4.y = r3.w ? r4.y : r5.x;
                r5.x = r2.w * 2 + r4.w;
                r4.w = r3.w ? r4.w : r5.x;
                if (r2.z != 0) {
                  if (r3.z == 0) {
                    r3.x = ColorBuffer.SampleLevel(LinearClampSampler_s, r4.xz, 0).w;
                  }
                  if (r3.w == 0) {
                    r3.y = ColorBuffer.SampleLevel(LinearClampSampler_s, r4.yw, 0).w;
                  }
                  r2.z = -r1.x * 0.5 + r3.x;
                  r3.x = r3.z ? r3.x : r2.z;
                  r2.z = -r1.x * 0.5 + r3.y;
                  r3.y = r3.w ? r3.y : r2.z;
                  r3.zw = cmp(abs(r3.xy) >= r2.xx);
                  r2.z = -r2.y * 2 + r4.x;
                  r4.x = r3.z ? r4.x : r2.z;
                  r2.z = -r2.w * 2 + r4.z;
                  r4.z = r3.z ? r4.z : r2.z;
                  r5.xy = ~(int2)r3.zw;
                  r2.z = (int)r5.y | (int)r5.x;
                  r5.x = r2.y * 2 + r4.y;
                  r4.y = r3.w ? r4.y : r5.x;
                  r5.x = r2.w * 2 + r4.w;
                  r4.w = r3.w ? r4.w : r5.x;
                  if (r2.z != 0) {
                    if (r3.z == 0) {
                      r3.x = ColorBuffer.SampleLevel(LinearClampSampler_s, r4.xz, 0).w;
                    }
                    if (r3.w == 0) {
                      r3.y = ColorBuffer.SampleLevel(LinearClampSampler_s, r4.yw, 0).w;
                    }
                    r2.z = -r1.x * 0.5 + r3.x;
                    r3.x = r3.z ? r3.x : r2.z;
                    r2.z = -r1.x * 0.5 + r3.y;
                    r3.y = r3.w ? r3.y : r2.z;
                    r3.zw = cmp(abs(r3.xy) >= r2.xx);
                    r2.z = -r2.y * 2 + r4.x;
                    r4.x = r3.z ? r4.x : r2.z;
                    r2.z = -r2.w * 2 + r4.z;
                    r4.z = r3.z ? r4.z : r2.z;
                    r5.xy = ~(int2)r3.zw;
                    r2.z = (int)r5.y | (int)r5.x;
                    r5.x = r2.y * 2 + r4.y;
                    r4.y = r3.w ? r4.y : r5.x;
                    r5.x = r2.w * 2 + r4.w;
                    r4.w = r3.w ? r4.w : r5.x;
                    if (r2.z != 0) {
                      if (r3.z == 0) {
                        r3.x = ColorBuffer.SampleLevel(LinearClampSampler_s, r4.xz, 0).w;
                      }
                      if (r3.w == 0) {
                        r3.y = ColorBuffer.SampleLevel(LinearClampSampler_s, r4.yw, 0).w;
                      }
                      r2.z = -r1.x * 0.5 + r3.x;
                      r3.x = r3.z ? r3.x : r2.z;
                      r2.z = -r1.x * 0.5 + r3.y;
                      r3.y = r3.w ? r3.y : r2.z;
                      r3.zw = cmp(abs(r3.xy) >= r2.xx);
                      r2.z = -r2.y * 4 + r4.x;
                      r4.x = r3.z ? r4.x : r2.z;
                      r2.z = -r2.w * 4 + r4.z;
                      r4.z = r3.z ? r4.z : r2.z;
                      r5.xy = ~(int2)r3.zw;
                      r2.z = (int)r5.y | (int)r5.x;
                      r5.x = r2.y * 4 + r4.y;
                      r4.y = r3.w ? r4.y : r5.x;
                      r5.x = r2.w * 4 + r4.w;
                      r4.w = r3.w ? r4.w : r5.x;
                      if (r2.z != 0) {
                        if (r3.z == 0) {
                          r3.x = ColorBuffer.SampleLevel(LinearClampSampler_s, r4.xz, 0).w;
                        }
                        if (r3.w == 0) {
                          r3.y = ColorBuffer.SampleLevel(LinearClampSampler_s, r4.yw, 0).w;
                        }
                        r2.z = -r1.x * 0.5 + r3.x;
                        r3.x = r3.z ? r3.x : r2.z;
                        r1.x = -r1.x * 0.5 + r3.y;
                        r3.y = r3.w ? r3.y : r1.x;
                        r2.xz = cmp(abs(r3.xy) >= r2.xx);
                        r1.x = -r2.y * 8 + r4.x;
                        r4.x = r2.x ? r4.x : r1.x;
                        r1.x = -r2.w * 8 + r4.z;
                        r4.z = r2.x ? r4.z : r1.x;
                        r1.x = r2.y * 8 + r4.y;
                        r4.y = r2.z ? r4.y : r1.x;
                        r1.x = r2.w * 8 + r4.w;
                        r4.w = r2.z ? r4.w : r1.x;
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    r1.x = v1.x + -r4.x;
    r2.y = v1.y + -r4.z;
    r1.x = r1.y ? r1.x : r2.y;
    r2.xy = -v1.xy + r4.yw;
    r2.x = r1.y ? r2.x : r2.y;
    r2.yz = cmp(r3.xy < float2(0,0));
    r2.w = r2.x + r1.x;
    r2.yz = cmp((int2)r0.ww != (int2)r2.yz);
    r0.w = 1 / r2.w;
    r2.w = cmp(r1.x < r2.x);
    r1.x = min(r2.x, r1.x);
    r2.x = r2.w ? r2.y : r2.z;
    r1.w = r1.w * r1.w;
    r0.w = r1.x * -r0.w + 0.5;
    r1.x = 0.25 * r1.w;
    r0.w = (int)r0.w & (int)r2.x;
    r0.w = max(r0.w, r1.x);
    r1.xz = r0.ww * r1.zz + v1.xy;
    r2.x = r1.y ? v1.x : r1.x;
    r2.y = r1.y ? r1.z : v1.y;
    r0.xyz = ColorBuffer.SampleLevel(LinearClampSampler_s, r2.xy, 0).xyz;
  }
  o0.xyz = r0.xyz;

  o0.rgb = renodx::color::gamma::DecodeSafe(o0.rgb, 2.2);
  o0.rgb = ToneMap(o0.rgb); // for some reason ToneMapPass causes Artifact
  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  o0.w = 1;
  return;
}