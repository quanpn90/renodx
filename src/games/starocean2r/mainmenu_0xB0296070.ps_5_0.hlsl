// ---- Created with 3Dmigoto v1.3.16 on Sun May 25 02:31:17 2025
#include "./common.hlsl"
#include "./shared.h"
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3)
{
  float4 cb3[11];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[14];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[768];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[132];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  float4 v4 : TEXCOORD4,
  float4 v5 : TEXCOORD5,
  float4 v6 : TEXCOORD6,
  float4 v7 : TEXCOORD7,
  float4 v8 : SV_POSITION0,
  float4 v9 : COLOR0,
  out float4 o0 : SV_Target0)
{
  const float4 icb[] = { { 1.000000, 0, 0, 0},
                              { 0, 1.000000, 0, 0},
                              { 0, 0, 1.000000, 0},
                              { 0, 0, 0, 1.000000} };
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  float4 x0[8];
  r0.xyzw = cb3[2].wxyz * v9.wxyz;
  r1.xyzw = cb3[1].xyxy * float4(1,0,-1,0) + v0.xyxy;
  r2.xyzw = -cb3[0].zwzw + r1.xyzw;
  r2.xyzw = r2.xyzw / cb3[0].xyxy;
  r2.xyzw = float4(0.50999999,0.50999999,0.50999999,0.50999999) + -r2.xyzw;
  r2.xyzw = cmp(float4(0.5,0.5,0.5,0.5) >= abs(r2.xyzw));
  r2.xyzw = r2.xyzw ? float4(1,1,1,1) : 0;
  r1.x = t0.SampleBias(s0_s, r1.xy, cb0[19].x).w;
  r1.x = r1.x * r2.x;
  r1.x = r1.x * r2.y;
  r1.y = t0.SampleBias(s0_s, r1.zw, cb0[19].x).w;
  r1.y = r1.y * r2.z;
  r1.y = r1.y * r2.w;
  r2.xyzw = cb3[1].xyxy * float4(0,1,0,-1) + v0.xyxy;
  r3.xyzw = -cb3[0].zwzw + r2.xyzw;
  r3.xyzw = r3.xyzw / cb3[0].xyxy;
  r3.xyzw = float4(0.50999999,0.50999999,0.50999999,0.50999999) + -r3.xyzw;
  r3.xyzw = cmp(float4(0.5,0.5,0.5,0.5) >= abs(r3.xyzw));
  r3.xyzw = r3.xyzw ? float4(1,1,1,1) : 0;
  r1.z = t0.SampleBias(s0_s, r2.xy, cb0[19].x).w;
  r1.z = r1.z * r3.x;
  r1.z = r1.z * r3.y;
  r1.w = t0.SampleBias(s0_s, r2.zw, cb0[19].x).w;
  r1.w = r1.w * r3.z;
  r1.w = r1.w * r3.w;
  r2.xyzw = t0.SampleBias(s0_s, v0.xy, cb0[19].x).xyzw;
  r3.xyzw = r2.wxyz * r0.xyzw;
  r0.x = r2.w * r0.x + -cb3[3].x;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.xyz = t1.SampleBias(s1_s, v0.xy, cb0[19].x).xyw;
  r0.x = r0.z * r0.x;
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r0.z = dot(r0.xy, r0.xy);
  r0.z = min(1, r0.z);
  r0.z = 1 + -r0.z;
  r0.z = sqrt(r0.z);
  r2.w = max(1.00000002e-016, r0.z);
  r0.xy = cb3[3].ww * r0.xy;
  r2.xy = cb3[5].yy * r0.xy;
  r0.xyz = t2.SampleBias(s2_s, v0.xy, cb0[19].x).xyz;
  

  r4.xyz = v4.yzx * v3.zxy;
  r4.xyz = v3.yzx * v4.zxy + -r4.xyz;
  r4.xyz = v4.www * r4.xyz;
  r4.xyz = r4.xyz * r2.yyy;
  r4.xyz = r2.xxx * v4.xyz + r4.xyz;
  r4.xyz = r2.www * v3.xyz + r4.xyz;
  r0.w = dot(r4.xyz, r4.xyz);
  r0.w = max(1.17549435e-038, r0.w);
  r0.w = rsqrt(r0.w);
  r0.w = r4.z * r0.w;
  r0.w = max(0.0500000007, r0.w);
  r4.xyz = cb0[130].xyz * r0.www;
  r0.w = min(cb2[11].y, cb0[10].x);
  r0.w = (int)r0.w;
  r0.w = min(4, (int)r0.w);
  r4.w = 0;
  while (true) {
    r5.x = cmp((uint)r4.w >= (uint)r0.w);
    if (r5.x != 0) break;
    r5.x = (uint)r4.w >> 2;
    r5.y = (int)r4.w & 3;
    int r5x12 = r5.x + 12;
    r5.x = dot(cb2[r5x12].xyzw, icb[r5.y+0].xyzw);
    r5.x = (int)r5.x;

    int r5x = r5.x;
    r5.yzw = cb1[r5x+0].xyz + -v2.xyz;
    r5.y = dot(r5.yzw, r5.yzw);
    r5.y = max(6.10351563e-005, r5.y);
    r5.y = cb1[r5x+0].w * r5.y;
    r5.z = 1 / cb1[r5x+512].x;
    r5.z = max(1.17549435e-038, r5.z);
    r5.y = r5.y / r5.z;
    r5.y = sqrt(r5.y);
    r5.y = min(1, r5.y);
    r5.y = 1 + -r5.y;
    r5.y = cb0[127].x * r5.y;
    r5.xyz = cb1[r5x+256].xyz * r5.yyy;

    int r4w = r4.w;
    x0[r4w+0].xyz = r5.xyz;
    r4.w = (int)r4.w + 1;
  }
  r4.xyz = r4.xyz * r3.yzw;
  r4.xyz = cb0[131].xyz * r3.yzw + r4.xyz;
  r5.xyz = r4.xyz;
  r4.w = 0;
  while (true) {
    r5.w = cmp((uint)r4.w >= (uint)r0.w);
    if (r5.w != 0) break;

    int r4_w = r4.w;
    r6.xyz = x0[r4_w+0].xyz;
    r5.xyz = r3.yzw * r6.xyz + r5.xyz;
    r4.w = (int)r4.w + 1;
  }

  r0.xyz = r0.xyz * cb3[4].xyz + r5.xyz;
  float3 untonemapped = renodx::color::srgb::DecodeSafe(r0.xyz);
  
  r0.xyz = RestoreHighlightSaturation(untonemapped);

  r0.w = r1.x * r1.y;
  r0.w = r0.w * r1.z;
  r0.w = r0.w * r1.w;
  r1.x = cmp(0 < r0.w);
  r0.w = cmp(r0.w < 0);
  r0.w = (int)r1.x + (int)-r0.w;
  r0.w = (int)r0.w + 1;
  r0.w = (int)r0.w;
  r0.w = cb3[8].y * r0.w + 1;
  r2.z = cb3[5].y * r2.y;
  r1.x = dot(r2.xzw, cb3[6].xyz);
  r1.x = 1 + r1.x;
  r1.x = 0.5 * r1.x;
  r0.w = cb3[8].x * r0.w;
  r1.y = cb3[8].w + -cb3[8].z;
  r0.w = r1.x * r0.w + -cb3[8].z;
  r1.x = 1 / r1.y;
  r0.w = saturate(r1.x * r0.w);
  r1.x = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r1.x * r0.w;
  r1.xyz = cb3[7].xyz * cb0[130].xyz;
  r1.xyz = r1.xyz * r0.www;
  r0.xyz = r0.xyz * r1.xyz + r0.xyz;
  

  r1.xyz = cb0[124].xyz * r0.xyz;
  r0.xyz = -r0.xyz * cb0[124].xyz + r0.xyz;
  o0.xyz = cb3[10].yyy * r0.xyz + r1.xyz;
  r0.x = cmp(cb3[5].x == 1.000000);
  o0.w = r0.x ? r3.x : 1;

  float3 sdr = renodx::color::srgb::DecodeSafe(o0.rgb);
  o0.rgb = renodx::draw::ToneMapPass(untonemapped, sdr);
  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);

  // o0 = saturate(o0);
  return;
}