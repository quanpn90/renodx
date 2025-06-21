
#include "./shared.h"

float3 PostToneMapScale(float3 color) {
  if (shader_injection.gamma_correction == 2.f) {
    color = renodx::color::srgb::EncodeSafe(color);
    color = renodx::color::gamma::DecodeSafe(color, 2.4f);
    color *= shader_injection.diffuse_white_nits / shader_injection.graphics_white_nits;
    color = renodx::color::gamma::EncodeSafe(color, 2.4f);
  } else if (shader_injection.gamma_correction == 1.f) {
    color = renodx::color::srgb::EncodeSafe(color);
    color = renodx::color::gamma::DecodeSafe(color, 2.2f);
    color *= shader_injection.diffuse_white_nits / shader_injection.graphics_white_nits;
    color = renodx::color::gamma::EncodeSafe(color, 2.2f);
  } else {
    color *= shader_injection.diffuse_white_nits / shader_injection.graphics_white_nits;
    color = renodx::color::srgb::EncodeSafe(color);
  }
  return color;
}

float3 RestoreHighlightSaturation(float3 color) {
  if (RENODX_TONE_MAP_TYPE != 0.f && RESTORE_HIGHLIGHT != 0.f) {
    if (RESTORE_HIGHLIGHT == 1.f) {  // Dice

      float dicePeak = RESTORE_HIGHLIGHT_PEAK;          // 2.f default
      float diceShoulder = RESTORE_HIGHLIGHT_SHOULDER;  // 0.5f default
      color = renodx::tonemap::dice::BT709(color, dicePeak, diceShoulder);

    } else if (RESTORE_HIGHLIGHT == 2.f) {  // Frostbite

      float frostbitePeak = RESTORE_HIGHLIGHT_PEAK;     // 2.f default
      float diceShoulder = RESTORE_HIGHLIGHT_SHOULDER;  // 0.5f default
      float diceSaturation = 1.f;                 // Hardcode to 1.f
      color = renodx::tonemap::frostbite::BT709(color, frostbitePeak, diceShoulder, diceSaturation);
      // color = RenoDRTSmoothClamp(color, 10000.f, 100.f, 5.f); // Testing smoothclamp
    } else if (RESTORE_HIGHLIGHT == 3.f) {
      float3 neutral_sdr_color = renodx::tonemap::renodrt::NeutralSDR(color);
      float color_y = renodx::color::y::from::BT709(color);
      // Lerp color and NeutralSDR(color) based on luminance
      // Normally using NeutralSDR alone messes up midtones
      // But the lerp makes sure it only gets applied to highlights
      color = lerp(color, neutral_sdr_color, saturate(color_y));
    }
  } else {
    // We dont want to Display Map if the tonemapper is vanilla/preset off or display map is none
    color = color;
  }

  return color;
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
