
#include "./shared.h"
#include "DICE.hlsl"

float3 ToneMapMaxCLL(float3 color, float rolloff_start = 0.375f, float output_max = 1.f) {
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    return color;
  }
  color = min(color, 100.f);
  float peak = max(color.r, max(color.g, color.b));
  peak = min(peak, 100.f);
  float log_peak = log2(peak);

  // Apply exponential shoulder in log space
  float log_mapped = renodx::tonemap::ExponentialRollOff(log_peak, log2(rolloff_start), log2(output_max));
  float scale = exp2(log_mapped - log_peak);  // How much to compress all channels

  return min(output_max, color * scale);
}

// logc c1000 custom encoding
static const float arri_a = renodx::color::arri::logc::c1000::PARAMS.a;
static const float arri_b = renodx::color::arri::logc::c1000::PARAMS.b;
static const float arri_c = renodx::color::arri::logc::c1000::PARAMS.c;
static const float arri_d = renodx::color::arri::logc::c1000::PARAMS.d;

float3 arriDecode(float3 color) {
  return (pow(10.f, (color - arri_d) / arri_c) - arri_b) / arri_a;
}

float3 lutShaper(float3 color, bool builder = false) {
  if (shader_injection.colorGradeLUTShaper == 0.f) {
    color = builder ? arriDecode(color)
                    : saturate(renodx::color::arri::logc::c1000::Encode(color));
  } else {
    color = builder ? renodx::color::bt709::from::BT2020(renodx::color::pq::Decode(color, 100.f))
                    : renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(color), 100.f);
  }
  return color;
}

float3 RestoreHighlightSaturation(float3 color) {
  
    float3 neutral_sdr_color = renodx::tonemap::renodrt::NeutralSDR(color);
    float color_y = renodx::color::y::from::BT709(color);
    // Lerp color and NeutralSDR(color) based on luminance
    // Normally using NeutralSDR alone messes up midtones
    // But the lerp makes sure it only gets applied to highlights
    color = lerp(color, neutral_sdr_color, saturate(color_y));

    return color;
}



//-----TONEMAP-----//
static const float3x3 ACES_to_ACEScg_MAT = float3x3(
    1.4514393161f, -0.2365107469f, -0.2149285693f,
    -0.0765537734f, 1.1762296998f, -0.0996759264f,
    0.0083161484f, -0.0060324498f, 0.9977163014f);

static const float3x3 SRGB_to_ACES_MAT = float3x3(
    0.4397010, 0.3829780, 0.1773350,
    0.0897923, 0.8134230, 0.0967616,
    0.0175440, 0.1115440, 0.8707040);

float3 RRT(float3 aces) {
  static const float3 AP1_RGB2Y = renodx::color::AP1_TO_XYZ_MAT[1].rgb;

  // --- Glow module --- //
  // "Glow" module constants
  static const float RRT_GLOW_GAIN = 0.05;
  static const float RRT_GLOW_MID = 0.08;
  float saturation = renodx::tonemap::aces::Rgb2Saturation(aces);
  float yc_in = renodx::tonemap::aces::Rgb2Yc(aces);
  const float s = renodx::tonemap::aces::SigmoidShaper((saturation - 0.4) / 0.2);
  float added_glow = 1.0 + renodx::tonemap::aces::GlowFwd(yc_in, RRT_GLOW_GAIN * s, RRT_GLOW_MID);
  aces *= added_glow;

  // --- Red modifier --- //
  // Red modifier constants
  static const float RRT_RED_SCALE = 0.82;
  static const float RRT_RED_PIVOT = 0.03;
  static const float RRT_RED_HUE = 0.;
  static const float RRT_RED_WIDTH = 135.;
  float hue = renodx::tonemap::aces::Rgb2Hue(aces);
  const float centered_hue = renodx::tonemap::aces::CenterHue(hue, RRT_RED_HUE);
  float hue_weight;
  {
    // hueWeight = cubic_basis_shaper(centeredHue, RRT_RED_WIDTH);
    hue_weight = smoothstep(0.0, 1.0, 1.0 - abs(2.0 * centered_hue / RRT_RED_WIDTH));
    hue_weight *= hue_weight;
  }

  aces.r += hue_weight * saturation * (RRT_RED_PIVOT - aces.r) * (1. - RRT_RED_SCALE);

  // --- ACES to RGB rendering space --- //
  aces = clamp(aces, 0, 65535.0f);
  float3 rgb_pre = mul(ACES_to_ACEScg_MAT, aces);
  rgb_pre = clamp(rgb_pre, 0, 65504.0f);

  // --- Global desaturation --- //
  // rgbPre = mul( RRT_SAT_MAT, rgbPre);
  static const float RRT_SAT_FACTOR = 0.96f;
  rgb_pre = lerp(dot(rgb_pre, AP1_RGB2Y).xxx, rgb_pre, RRT_SAT_FACTOR);

  return rgb_pre;
}

// tonemap in the game Lysfanga, maybe used in this game as well?
float3 vanillaTonemap(float3 color) {
  static const float a = 2.785085;
  static const float b = 0.107772;
  static const float c = 2.936045;
  static const float d = 0.887122;
  static const float e = 0.806889;
  color = mul(SRGB_to_ACES_MAT, color);
  color = RRT(color);
  color = (color * (a * color + b)) / (color * (c * color + d) + e);
  color = mul(renodx::color::AP1_TO_XYZ_MAT, color);
  color = renodx::tonemap::aces::DarkToDim(color);
  color = mul(renodx::color::XYZ_TO_AP1_MAT, color);
  float3 AP1_RGB2Y = renodx::color::AP1_TO_XYZ_MAT[1].rgb;
  color = lerp(dot(color, AP1_RGB2Y).rrr, color, 0.93);
  color = mul(renodx::color::AP1_TO_XYZ_MAT, color);
  color = mul(renodx::color::D60_TO_D65_MAT, color);
  color = mul(renodx::color::XYZ_TO_BT709_MAT, color);
  return color;
}

float3 applyUserTonemap(float3 untonemapped) {
  // if (RENODX_TONE_MAP_TYPE < 1.f) {
  //   return saturate(untonemapped);
  // } 
  
  // else if (RENODX_TONE_MAP_TYPE == 10000000.f) {
    DICESettings DICEconfig = DefaultDICESettings();
    DICEconfig.Type = 3;
    DICEconfig.ShoulderStart = 0.15f;  // Start shoulder

    float dicePaperWhite = RENODX_DIFFUSE_WHITE_NITS / 80.f;
    float dicePeakWhite = RENODX_PEAK_WHITE_NITS / 80.f;

    return DICETonemap(untonemapped * dicePaperWhite, dicePeakWhite, DICEconfig) / dicePaperWhite;
  //   // float peak_nits = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  //   // return renodx::tonemap::ExponentialRollOff(untonemapped, min(1.f, peak_nits * 0.5f), peak_nits);
  // } 
  
  float3 outputColor;
  // float midGray = renodx::color::y::from::BT709(vanillaTonemap(float3(0.18f, 0.18f, 0.18f)));
  float3 hueCorrectionColor = renodx::tonemap::renodrt::NeutralSDR(untonemapped);
  // float3 hueCorrectionColor = saturate(untonemapped);
  float midGray = 0.18f;
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = min(3, RENODX_TONE_MAP_TYPE);
  config.peak_nits = RENODX_PEAK_WHITE_NITS;
  config.game_nits = RENODX_DIFFUSE_WHITE_NITS;
  config.gamma_correction = RENODX_GAMMA_CORRECTION;
  config.exposure = RENODX_TONE_MAP_EXPOSURE;
  config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  config.shadows = RENODX_TONE_MAP_SHADOWS;
  config.contrast = RENODX_TONE_MAP_CONTRAST;
  config.saturation = RENODX_TONE_MAP_SATURATION;
  config.mid_gray_value = midGray;
  config.mid_gray_nits = midGray * 100;
  // config.mid_gray_nits = 100.f;
  // config.reno_drt_shadows = 1.06f;
  // config.reno_drt_contrast = 1.6f;
  // config.reno_drt_saturation = 0.9f;
  config.reno_drt_shadows = 1.0f;
  config.reno_drt_contrast = 1.0f;
  config.reno_drt_saturation = 1.0f;
  config.reno_drt_dechroma = RENODX_TONE_MAP_BLOWOUT;
  config.reno_drt_flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
  config.hue_correction_type = RENODX_TONE_MAP_PER_CHANNEL != 0.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;

  config.hue_correction_strength = RENODX_TONE_MAP_PER_CHANNEL != 0.f ? (1.f - RENODX_TONE_MAP_HUE_CORRECTION)
                                                                      : RENODX_TONE_MAP_HUE_CORRECTION;

  config.hue_correction_color = lerp(untonemapped, hueCorrectionColor, RENODX_TONE_MAP_HUE_SHIFT);
  
  config.reno_drt_hue_correction_method = (uint)RENODX_TONE_MAP_HUE_PROCESSOR;
  config.reno_drt_tone_map_method = RENODX_TONE_MAP_TYPE == 3.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_working_color_space = (uint)RENODX_TONE_MAP_WORKING_COLOR_SPACE;
  config.reno_drt_per_channel = RENODX_TONE_MAP_PER_CHANNEL != 0.f;
  config.reno_drt_blowout = RENODX_TONE_MAP_BLOWOUT;
  config.reno_drt_white_clip = RENODX_RENO_DRT_WHITE_CLIP;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    outputColor = saturate(hueCorrectionColor);
  } else {
    outputColor = untonemapped;
  }
  return renodx::tonemap::config::Apply(outputColor, config);
}

// float3 FinalizeOutput(float3 color) {
//   if (shader_injection.toneMapGammaCorrection == 2.f) {
//     color = renodx::color::gamma::DecodeSafe(color, 2.4f);
//   } else if (shader_injection.toneMapGammaCorrection == 1.f) {
//     color = renodx::color::gamma::DecodeSafe(color, 2.2f);
//   } else {
//     color = renodx::color::srgb::DecodeSafe(color);
//   }
//   color *= shader_injection.toneMapUINits;
//   color = min(color, shader_injection.toneMapPeakNits); // Clamp UI or Videos

//   if (shader_injection.colorGradeColorSpace == 1.f) {
//     // BT709 D65 => BT709 D93
//     color = mul(float3x3(0.941922724f, -0.0795196890f, -0.0160709824f,
//                          0.00374091602f, 1.01361334f, -0.00624059885f,
//                          0.00760519271f, 0.0278747007f, 1.30704438f),
//                 color);
//   } else if (shader_injection.colorGradeColorSpace == 2.f) {
//     // BT.709 D65 => BT.601 (NTSC-U)
//     color = mul(float3x3(0.939542055f, 0.0501813553f, 0.0102765792f,
//                          0.0177722238f, 0.965792834f, 0.0164349135f,
//                          -0.00162159989f, -0.00436974968f, 1.00599133f),
//                 color);
//   } else if (shader_injection.colorGradeColorSpace == 3.f) {
//     // BT.709 D65 => ARIB-TR-B09 D93 (NTSC-J)
//     color = mul(float3x3(0.871554791f, -0.161164566f, -0.0151899587f,
//                          0.0417598634f, 0.980491757f, -0.00258531118f,
//                          0.00544220115f, 0.0462860465f, 1.73763155f),
//                 color);
//   }

//   color /= 80.f; // or PQ
//   return color;
// }

// float3 RenoDRTSmoothClamp(float3 untonemapped) {
//   renodx::tonemap::renodrt::Config renodrt_config =
//       renodx::tonemap::renodrt::config::Create();
//   renodrt_config.nits_peak = 100.f;
//   renodrt_config.mid_gray_value = 0.18f;
//   renodrt_config.mid_gray_nits = 18.f;
//   renodrt_config.exposure = 1.f;
//   renodrt_config.highlights = 1.f;
//   renodrt_config.shadows = 1.f;
//   renodrt_config.contrast = 1.05f;
//   renodrt_config.saturation = 1.05f;
//   renodrt_config.dechroma = 0.f;
//   renodrt_config.flare = 0.f;
//   renodrt_config.hue_correction_strength = 0.f;
//   renodrt_config.tone_map_method =
//       renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
//   renodrt_config.working_color_space = 2u;

//   return renodx::tonemap::renodrt::BT709(untonemapped, renodrt_config);
// }

// float3 ToneMap(float3 color) {
//   color = max(0, color);
//   color = renodx::color::srgb::DecodeSafe(color);

//   if (shader_injection.toneMapType == 0.f) {
//     color = saturate(color);
//   }
//   renodx::tonemap::Config config = renodx::tonemap::config::Create();
//   config.type = shader_injection.toneMapType;
//   config.peak_nits = shader_injection.toneMapPeakNits;
//   config.game_nits = shader_injection.toneMapGameNits;
//   config.gamma_correction = shader_injection.toneMapGammaCorrection;
//   config.exposure = shader_injection.colorGradeExposure;
//   config.highlights = shader_injection.colorGradeHighlights;
//   config.shadows = shader_injection.colorGradeShadows;
//   config.contrast = shader_injection.colorGradeContrast;
//   config.saturation = shader_injection.colorGradeSaturation;
//   config.reno_drt_contrast = 1.04f;
//   config.reno_drt_saturation = 1.05f;
//   config.mid_gray_nits = 19.f;
//   config.reno_drt_dechroma = shader_injection.colorGradeBlowout;
//   config.reno_drt_hue_correction_method =
//       renodx::tonemap::renodrt::config::hue_correction_method::ICTCP;

//   config.hue_correction_type =
//       renodx::tonemap::config::hue_correction_type::CUSTOM;
//   config.hue_correction_strength = shader_injection.toneMapHueCorrection;
//   config.hue_correction_color = color;
//   if (shader_injection.toneMapHueCorrectionMethod == 1.f) {
//     config.hue_correction_color = saturate(color);
//   } else if (shader_injection.toneMapHueCorrectionMethod == 2.f) {
//     config.hue_correction_color = renodx::tonemap::uncharted2::BT709(color);
//   } else if (shader_injection.toneMapHueCorrectionMethod == 3.f) {
//     config.hue_correction_color = RenoDRTSmoothClamp(color);
//   } else {
//     config.hue_correction_type =
//         renodx::tonemap::config::hue_correction_type::INPUT;
//   }

//   color = renodx::tonemap::config::Apply(color, config);

//   color =
//       renodx::color::bt709::clamp::BT709(color); // Needed for later blending
//   return color;
// }
