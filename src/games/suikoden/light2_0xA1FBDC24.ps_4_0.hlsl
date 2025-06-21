// ---- Created with 3Dmigoto v1.3.16 on Sun May 18 11:50:33 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[29];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = saturate(cb0[28].xyxy * float4(-0.5,-0.5,0.5,-0.5) + v1.xyxy);
  r0.xyzw = cb0[26].xxxx * r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xyzw = saturate(cb0[28].xyxy * float4(-0.5,0.5,0.5,0.5) + v1.xyxy);
  r1.xyzw = cb0[26].xxxx * r1.xyzw;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r0.xyzw = r2.xyzw + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r1.xy = saturate(-cb0[28].xy + v1.xy);
  r1.xy = cb0[26].xx * r1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r2.xyzw = saturate(cb0[28].xyxy * float4(0,-1,1,-1) + v1.xyxy);
  r2.xyzw = cb0[26].xxxx * r2.xyzw;
  r3.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = t0.Sample(s0_s, r2.zw).xyzw;
  r2.xyzw = r3.xyzw + r2.xyzw;
  r1.xyzw = r3.xyzw + r1.xyzw;
  r3.xy = saturate(v1.xy);
  r3.xy = cb0[26].xx * r3.xy;
  r3.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  r1.xyzw = r3.xyzw + r1.xyzw;
  r4.xyzw = saturate(cb0[28].xyxy * float4(-1,0,1,0) + v1.xyxy);
  r4.xyzw = cb0[26].xxxx * r4.xyzw;
  r5.xyzw = t0.Sample(s0_s, r4.xy).xyzw;
  r4.xyzw = t0.Sample(s0_s, r4.zw).xyzw;
  r1.xyzw = r5.xyzw + r1.xyzw;
  r5.xyzw = r5.xyzw + r3.xyzw;
  r1.xyzw = float4(0.03125,0.03125,0.03125,0.03125) * r1.xyzw;
  r0.xyzw = r0.xyzw * float4(0.125,0.125,0.125,0.125) + r1.xyzw;
  r1.xyzw = r4.xyzw + r2.xyzw;
  r2.xyzw = r4.xyzw + r3.xyzw;
  r1.xyzw = r1.xyzw + r3.xyzw;
  r0.xyzw = r1.xyzw * float4(0.03125,0.03125,0.03125,0.03125) + r0.xyzw;
  r1.xyzw = saturate(cb0[28].xyxy * float4(-1,1,0,1) + v1.xyxy);
  r1.xyzw = cb0[26].xxxx * r1.xyzw;
  r3.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r4.xyzw = r5.xyzw + r3.xyzw;
  r1.xyzw = r4.xyzw + r1.xyzw;
  r0.xyzw = r1.xyzw * float4(0.03125,0.03125,0.03125,0.03125) + r0.xyzw;
  r1.xy = saturate(cb0[28].xy + v1.xy);
  r1.xy = cb0[26].xx * r1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = r2.xyzw + r1.xyzw;
  r1.xyzw = r1.xyzw + r3.xyzw;
  o0.xyzw = r1.xyzw * float4(0.03125,0.03125,0.03125,0.03125) + r0.xyzw;
  return;
}