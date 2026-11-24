#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

constant int S2A_AT [[function_constant(100)]]; constant bool S2A_AT_ON = is_function_constant_defined(S2A_AT); constant bool S2A_MSOFF [[function_constant(101)]]; constant bool S2A_MSOFF_ON = is_function_constant_defined(S2A_MSOFF) ? S2A_MSOFF : false; constant bool S2A_FSOUT [[function_constant(102)]]; constant bool S2A_FSOUT_ON = is_function_constant_defined(S2A_FSOUT) ? S2A_FSOUT : false;   static inline bool s2a_alpha_pass(int f, float a, float r) { return f == 8 || (f == 2 && a < r) || (f == 3 && a == r) || (f == 4 && a <= r) || (f == 5 && a > r) || (f == 6 && a != r) || (f == 7 && a >= r); }   // S2Arm S2A_FSOUT: forced-output diagnosis (102 is free in all 3,935 shaders)

struct _12
{
    uint4 _m0;
    uint4 _m1[8];
    float4 _m2;
    float4 _m3;
    int _m4;
    float4 _m5[73];
    int4 _m6;
    int _m7;
    int4 _m8;
    int4 _m9;
    int4 _m10;
    float4 _m11[73];
    int4 _m12[73];
};

struct _18
{
    float4 _m0[4096];
};

struct _27
{
    uint _m0[1];
};

struct _1025
{
    uint _m0[14];
};

struct spvDescriptorSetBuffer0
{
    constant _12* support_buffer [[id(0)]];
    constant _18* fp_c1 [[id(1)]];
    constant _18* fp_c3 [[id(2)]];
    constant _18* fp_c4 [[id(3)]];
    const device _27* fp_s0 [[id(4)]];
    texture2d<float> fp_t_cb196613_10570002 [[id(5)]];
    sampler fp_t_cb196613_10570002Smplr [[id(6)]];
    texture2d<float> fp_t_cb196613_10568000 [[id(7)]];
    sampler fp_t_cb196613_10568000Smplr [[id(8)]];
    texture3d<float> fp_t_cb196610_1057805A [[id(9)]];
    sampler fp_t_cb196610_1057805ASmplr [[id(10)]];
    const device _1025* gal_ubo_len [[id(11)]];
    constant uint* spvBufferSizeConstants [[id(12)]];
    constant float4* s2a_uvx [[id(13)]];
    constant float* s2a_lb [[id(14)]];
};

static inline float2 s2a_uv(float2 c, float4 q) { return float2(fma(c.x, q.x, c.x) + q.y, fma(c.y, q.z, c.y) + q.w); }


struct main0_out
{
    float4 m_52 [[color(0)]];
    uint s2a_smask [[sample_mask, function_constant(S2A_MSOFF_ON)]];
};

struct main0_in
{
    float4 m_45 [[user(locn2)]];
    float4 m_49 [[user(locn3)]];
};

#ifndef S2A_HALF_ROUND
#define S2A_HALF_ROUND
static inline float s2a_half_rtz(float x) {
    uint u = as_type<uint>(x), e = (u >> 23) & 255u;
    if (e == 255u) return x;
    if (e > 142u) u = (u & 0x80000000u) | 0x477fe000u;
    else if (e >= 113u) u &= 0xffffe000u;
    else if (e >= 103u) u &= ~((1u << (126u - e)) - 1u);
    else u &= 0x80000000u;
    return as_type<float>(u);
}
static inline float4 s2a_half_rtz(float4 x) {
    return float4(s2a_half_rtz(x.x), s2a_half_rtz(x.y), s2a_half_rtz(x.z), s2a_half_rtz(x.w));
}
#endif
fragment main0_out main0(main0_in in [[stage_in]], constant spvDescriptorSetBuffer0& spvDescriptorSet0 [[buffer(0)]], constant uint* spvBufferSizeConstants [[buffer(25)]], float4 gl_FragCoord [[position]], constant uint& s2a_half_mask [[buffer(27)]], constant float* s2a_aref [[buffer(30)]])
{
    main0_out out = {};
    constant uint& spvDescriptorSet0_fp_s0BufferSize = spvDescriptorSet0.spvBufferSizeConstants[4];
    uint _1038 = (spvDescriptorSet0_fp_s0BufferSize - 0) / 4;
    uint _1040 = max(_1038, 1u) - 1u;
    float _59 = fma(in.m_45.x, 2.0, -1.0);
    float _61 = fma(in.m_45.y, 2.0, -1.0);
    bool _65 = abs(_59) == 0.0;
    float _67 = abs(_61) + (-0.0);
    float _69 = sqrt((-abs(_61)) + 1.0);
    float _71 = float((-_61) < 0.0);
    float _73 = sqrt((-fma(_61, _61, _59 * _59)) + 1.0);
    bool _75 = (abs(_73) == 0.0) && _65;
    float _77 = fma(fma(fma(_67, (*spvDescriptorSet0.fp_c1)._m0[1].z, 0.074261002242565155029296875), _67, (*spvDescriptorSet0.fp_c1)._m0[1].w), _67, (*spvDescriptorSet0.fp_c1)._m0[2].x) * _69;
    bool _79 = abs(_73) == 0.0;
    int _82 = 0;
    float _84 = _67;
    int _86 = _75 ? (-1) : 0;
    float _88 = _69;
    if (_75)
    {
        _82 = ((-_73) < 0.0) ? (-1) : 0;
    }
    if (_75)
    {
        _84 = ((~_82) != 0) ? 0.0 : (*spvDescriptorSet0.fp_c1)._m0[0].x;
    }
    float _90 = _84;
    int _92 = 0;
    int _94 = as_type<int>(_90);
    if (_75)
    {
        _92 = as_type<int>((-_90) + (-0.0));
    }
    if (((-_59) < 0.0) && _75)
    {
        _94 = _92;
    }
    int _96 = _94;
    int _98 = _96;
    float _100 = as_type<float>(_96);
    if (!(_65 && (((_79 ? (-1) : 0) < 0) || (!((_79 ? (-1) : 0) == 0)))))
    {
        bool _102 = abs(_59) == as_type<float>(0x7f800000u /* inf */);
        bool _104 = abs(_73) == as_type<float>(0x7f800000u /* inf */);
        bool _106 = (abs(_73) == as_type<float>(0x7f800000u /* inf */)) && _102;
        if (_106)
        {
            _86 = ((-_73) < 0.0) ? (-1) : 0;
        }
        if (_106)
        {
            _98 = 1061752795;
        }
        int _108 = _98;
        float _110 = as_type<float>(_108);
        if (_106)
        {
            _110 = ((~_86) != 0) ? as_type<float>(_108) : (*spvDescriptorSet0.fp_c1)._m0[0].y;
        }
        float _112 = _110;
        float _114 = _112;
        if (_106)
        {
            _88 = (-_112) + (-0.0);
        }
        if (((-_59) < 0.0) && _106)
        {
            _114 = _88;
        }
        _100 = _114;
        if (!(_102 && (((_104 ? (-1) : 0) < 0) || (!((_104 ? (-1) : 0) == 0)))))
        {
            float _116 = precise::max(abs(_59), abs(_73));
            float _118 = precise::min(abs(_59), abs(_73));
            bool _120 = _116 >= 16.0;
            float _122 = _116;
            float _124 = _118;
            if (_120)
            {
                _122 = _116 * 0.0625;
            }
            if (_120)
            {
                _124 = _118 * 0.0625;
            }
            float _126 = (1.0 / _122) * _124;
            float _128 = _126 * _126;
            float _130 = fma(_126 * (_128 * fma(_128, fma(_128, (*spvDescriptorSet0.fp_c1)._m0[0].z, -5.674867153167724609375), (*spvDescriptorSet0.fp_c1)._m0[1].x)), 1.0 / fma(_128, fma(_128, _128 + 11.33538818359375, (*spvDescriptorSet0.fp_c1)._m0[0].w), (*spvDescriptorSet0.fp_c1)._m0[1].y), _126);
            float _132 = _130;
            if (abs(_59) > abs(_73))
            {
                _132 = (-_130) + 1.57079637050628662109375;
            }
            float _134 = _132;
            float _136 = _134;
            if ((-_73) < 0.0)
            {
                _136 = (-_134) + 3.1415927410125732421875;
            }
            float _138 = _136;
            _100 = _138;
            if ((-_59) < 0.0)
            {
                _100 = (-_138) + (-0.0);
            }
        }
    }
    float _140 = fma(_100, (*spvDescriptorSet0.fp_c1)._m0[2].y, 0.5);
    float _142 = (-fma(fma(_71, (*spvDescriptorSet0.fp_c1)._m0[0].x, fma(_77 * _71, -2.0, _77)), (*spvDescriptorSet0.fp_c1)._m0[2].y, 1.0)) + (-0.0);
    float2 _541 = float2(_142, _140);
    float2 _146 = spvDescriptorSet0.fp_t_cb196613_10570002.sample(spvDescriptorSet0.fp_t_cb196613_10570002Smplr, s2a_uv(select(_541, float2(0.0), isnan(_541)), spvDescriptorSet0.s2a_uvx[5]), bias(((*spvDescriptorSet0.fp_c3)._m0[148].y) + spvDescriptorSet0.s2a_lb[6])).yw;
    float2 _554 = float2(_142, _140);
    float3 _150 = spvDescriptorSet0.fp_t_cb196613_10568000.sample(spvDescriptorSet0.fp_t_cb196613_10568000Smplr, s2a_uv(select(_554, float2(0.0), isnan(_554)), spvDescriptorSet0.s2a_uvx[7]), level(((*spvDescriptorSet0.fp_c3)._m0[148].y + (-1.0)) + spvDescriptorSet0.s2a_lb[8])).xyz;
    float _152 = gl_FragCoord.x / (*spvDescriptorSet0.support_buffer)._m5[0].x;
    float _154 = gl_FragCoord.y / (*spvDescriptorSet0.support_buffer)._m11[0].x;
    float _156 = gl_FragCoord.z;
    float _158 = in.m_49.w;
    uint _1041 = uint(16);
    float _160 = as_type<float>((*spvDescriptorSet0.fp_s0)._m0[min(_1041, _1040)]);
    uint _1044 = uint(17);
    float _162 = as_type<float>((*spvDescriptorSet0.fp_s0)._m0[min(_1044, _1040)]);
    uint _1047 = uint(18);
    float _164 = as_type<float>((*spvDescriptorSet0.fp_s0)._m0[min(_1047, _1040)]);
    float _166 = fma(_59, _59, _61 * _61);
    float _168 = 1.0 / (fma(_156, (*spvDescriptorSet0.fp_c3)._m0[46].w, fma(_154, (*spvDescriptorSet0.fp_c3)._m0[45].w, _152 * (*spvDescriptorSet0.fp_c3)._m0[44].w)) + (*spvDescriptorSet0.fp_c3)._m0[47].w);
    float _170 = _59 * (-rsqrt(_166));
    float _172 = _61 * rsqrt(_166);
    float _174 = (-_73) + 1.0;
    float _176 = _172 * sqrt(_166);
    float _178 = _170 * sqrt(_166);
    float _180 = fma(fma(_156, (*spvDescriptorSet0.fp_c3)._m0[46].x, fma(_154, (*spvDescriptorSet0.fp_c3)._m0[45].x, _152 * (*spvDescriptorSet0.fp_c3)._m0[44].x)) + (*spvDescriptorSet0.fp_c3)._m0[47].x, _168, -(*spvDescriptorSet0.fp_c3)._m0[75].x);
    float _182 = (_172 * _170) * _174;
    float _184 = fma(fma(_156, (*spvDescriptorSet0.fp_c3)._m0[46].y, fma(_154, (*spvDescriptorSet0.fp_c3)._m0[45].y, _152 * (*spvDescriptorSet0.fp_c3)._m0[44].y)) + (*spvDescriptorSet0.fp_c3)._m0[47].y, _168, -(*spvDescriptorSet0.fp_c3)._m0[75].y);
    float _186 = fma(fma(_156, (*spvDescriptorSet0.fp_c3)._m0[46].z, fma(_154, (*spvDescriptorSet0.fp_c3)._m0[45].z, _152 * (*spvDescriptorSet0.fp_c3)._m0[44].z)) + (*spvDescriptorSet0.fp_c3)._m0[47].z, _168, -(*spvDescriptorSet0.fp_c3)._m0[75].z);
    float _188 = fma(_146.y, 2.0, -1.0);
    float _190 = fma(_146.x, 2.0, -1.0);
    float _192 = _188 * _164;
    float _194 = _190 * _164;
    float _196 = sqrt(precise::clamp((-fma(_190, _190, _188 * _188)) + 1.0, 0.0, 1.0));
    float _198 = rsqrt(fma(_196, _196, fma(_194, _194, _192 * _192)));
    uint _1088 = uint(20);
    float _200 = as_type<float>((*spvDescriptorSet0.fp_s0)._m0[min(_1088, _1040)]);
    uint _1091 = uint(22);
    float _202 = as_type<float>((*spvDescriptorSet0.fp_s0)._m0[min(_1091, _1040)]);
    float _204 = _194 * _198;
    float _206 = _192 * _198;
    float _208 = _196 * _198;
    float _210 = fma(_73, _208, fma(_178, _206, _176 * (-_204)));
    uint _1094 = uint(14);
    uint _1097 = uint(13);
    uint _1100 = uint(12);
    float _212 = fma(_210, as_type<float>((*spvDescriptorSet0.fp_s0)._m0[min(_1094, _1040)]), fma(fma(_176, _208, fma(_206, _182, _204 * fma(_174, _170 * _170, _73))), as_type<float>((*spvDescriptorSet0.fp_s0)._m0[min(_1097, _1040)]), fma(_178, -_208, fma(_206, fma(_174, _172 * _172, _73), _204 * _182)) * as_type<float>((*spvDescriptorSet0.fp_s0)._m0[min(_1100, _1040)])));
    float _214 = precise::clamp(fma(_162, _150.y, _160), 0.0, 1.0);
    uint _1103 = uint(19);
    float _216 = as_type<float>((*spvDescriptorSet0.fp_s0)._m0[min(_1103, _1040)]) * precise::clamp(_210 + (-0.0), 0.0, 1.0);
    float _218 = precise::clamp(fma(_162, _150.x, _160), 0.0, 1.0);
    float _220 = precise::clamp(fma(_162, _150.z, _160), 0.0, 1.0);
    uint _1106 = uint(21);
    float _222 = exp2(as_type<float>((*spvDescriptorSet0.fp_s0)._m0[min(_1106, _1040)]) * log2(abs(_212)));
    float _224 = _158;
    if (_212 <= 0.0)
    {
        _222 = 0.0;
    }
    float _226 = precise::clamp(_222 + (-0.0), 0.0, 1.0);
    if (0.0 < (*spvDescriptorSet0.fp_c4)._m0[133].x)
    {
        float _228 = fma(_186, (*spvDescriptorSet0.fp_c3)._m0[6].w, fma(_184, (*spvDescriptorSet0.fp_c3)._m0[5].w, _180 * (*spvDescriptorSet0.fp_c3)._m0[4].w)) + (*spvDescriptorSet0.fp_c3)._m0[7].w;
        float _230 = 1.0 / _228;
        float3 _936 = float3(fma((fma(_186, (*spvDescriptorSet0.fp_c3)._m0[6].x, fma(_184, (*spvDescriptorSet0.fp_c3)._m0[5].x, _180 * (*spvDescriptorSet0.fp_c3)._m0[4].x)) + (*spvDescriptorSet0.fp_c3)._m0[7].x) * _230, 0.5, 0.5) * (*spvDescriptorSet0.fp_c3)._m0[339].x, fma((fma(_186, (*spvDescriptorSet0.fp_c3)._m0[6].y, fma(_184, (*spvDescriptorSet0.fp_c3)._m0[5].y, _180 * (*spvDescriptorSet0.fp_c3)._m0[4].y)) + (*spvDescriptorSet0.fp_c3)._m0[7].y) * _230, -0.5, 0.5) * (*spvDescriptorSet0.fp_c3)._m0[339].y, (log2(fma(_228, (*spvDescriptorSet0.fp_c3)._m0[221].x, (*spvDescriptorSet0.fp_c3)._m0[221].y)) * (*spvDescriptorSet0.fp_c3)._m0[221].z) * (*spvDescriptorSet0.fp_c3)._m0[220].z);
        _224 = _158 * spvDescriptorSet0.fp_t_cb196610_1057805A.sample(spvDescriptorSet0.fp_t_cb196610_1057805ASmplr, select(_936, float3(0.0), isnan(_936)), level((0.0) + spvDescriptorSet0.s2a_lb[10])).w;
    }
    float _232 = _224;
    uint _1151 = uint(5);
    float _234 = (precise::max(0.0, fma(fma(_200, fma(_214, as_type<float>((*spvDescriptorSet0.fp_s0)._m0[min(_1151, _1040)]), -_214), _214), _226, _216 * _214) * _202) * _232) * (*spvDescriptorSet0.fp_c3)._m0[140].y;
    uint _1156 = uint(6);
    float _236 = (precise::max(0.0, fma(fma(_200, fma(_220, as_type<float>((*spvDescriptorSet0.fp_s0)._m0[min(_1156, _1040)]), -_220), _220), _226, _216 * _220) * _202) * _232) * (*spvDescriptorSet0.fp_c3)._m0[140].y;
    uint _1161 = uint(4);
    out.m_52.x = (precise::max(0.0, fma(fma(_200, fma(_218, as_type<float>((*spvDescriptorSet0.fp_s0)._m0[min(_1161, _1040)]), -_218), _218), _226, _216 * _218) * _202) * _232) * (*spvDescriptorSet0.fp_c3)._m0[140].y;
    out.m_52.y = _234;
    out.m_52.z = _236;
    out.m_52.w = 0.0;
    {
        if (s2a_half_mask & 1u) out.m_52 = s2a_half_rtz(out.m_52);
        { if (S2A_MSOFF_ON) out.s2a_smask = 0xffffffffu; if (S2A_AT_ON && !(s2a_alpha_pass(S2A_AT, float(out.m_52.w), s2a_aref[0]))) discard_fragment(); if (S2A_FSOUT_ON) out.m_52 = float4(0.0f, 4096.0f, 0.0f, 0.0f); return out; }   // S2Arm: alpha 0 on purpose (src_a=ZERO, dst_a=1-SRC_ALPHA: alpha 1 would zero the target alpha)
    }
}

