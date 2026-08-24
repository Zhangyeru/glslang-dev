#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputA
{
    float data[];
} A;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

vec2[128] _116()
{
    uint _148 = uint(16);
    uint _150 = uint(0);
    uint _152 = uint(0);
    uint _154 = uint(16);
    uint _156 = uint(0);
    uint _158 = uint(0);
    uint _160 = uint(16);
    uint _162 = uint(0);
    uint _164 = uint(0);
    vec2 _133[128] = vec2[](vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0));
    uint _134 = 0u;
    uint _165;
    for (;;)
    {
        _165 = _134;
        if (_165 < 16u)
        {
            uint _167 = _165 / 1u;
            uint _169 = (_165 % 1u) * 16u;
            uint _170 = _167 * 16u;
            vec2 _136 = vec2(C.data[((_162 + _167) * _160) + (_164 + _169)], C.data[((_162 + _167) * _160) + (_164 + (_169 + 1u))]);
            uint _189 = _169 + 2u;
            vec2 _137 = vec2(C.data[((_162 + _167) * _160) + (_164 + _189)], C.data[((_162 + _167) * _160) + (_164 + (_189 + 1u))]);
            uint _207 = _169 + 4u;
            vec2 _138 = vec2(C.data[((_162 + _167) * _160) + (_164 + _207)], C.data[((_162 + _167) * _160) + (_164 + (_207 + 1u))]);
            uint _225 = _169 + 6u;
            vec2 _139 = vec2(C.data[((_162 + _167) * _160) + (_164 + _225)], C.data[((_162 + _167) * _160) + (_164 + (_225 + 1u))]);
            uint _242 = _169 + 8u;
            vec2 _140 = vec2(C.data[((_162 + _167) * _160) + (_164 + _242)], C.data[((_162 + _167) * _160) + (_164 + (_242 + 1u))]);
            uint _260 = _169 + 10u;
            vec2 _141 = vec2(C.data[((_162 + _167) * _160) + (_164 + _260)], C.data[((_162 + _167) * _160) + (_164 + (_260 + 1u))]);
            uint _278 = _169 + 12u;
            vec2 _142 = vec2(C.data[((_162 + _167) * _160) + (_164 + _278)], C.data[((_162 + _167) * _160) + (_164 + (_278 + 1u))]);
            uint _296 = _169 + 14u;
            vec2 _143 = vec2(C.data[((_162 + _167) * _160) + (_164 + _296)], C.data[((_162 + _167) * _160) + (_164 + (_296 + 1u))]);
            uint _135 = 0u;
            uint _313;
            for (;;)
            {
                _313 = _135;
                if (_313 < 16u)
                {
                    vec2 _323 = vec2(A.data[((_150 + _167) * _148) + (_152 + _313)]);
                    uint _324 = _313 * 16u;
                    _136 = fma(_323, vec2(B.data[((_156 + _313) * _154) + (_158 + _169)], B.data[((_156 + _313) * _154) + (_158 + (_169 + 1u))]), _136);
                    uint _343 = _169 + 2u;
                    _137 = fma(_323, vec2(B.data[((_156 + _313) * _154) + (_158 + _343)], B.data[((_156 + _313) * _154) + (_158 + (_343 + 1u))]), _137);
                    uint _362 = _169 + 4u;
                    _138 = fma(_323, vec2(B.data[((_156 + _313) * _154) + (_158 + _362)], B.data[((_156 + _313) * _154) + (_158 + (_362 + 1u))]), _138);
                    uint _381 = _169 + 6u;
                    _139 = fma(_323, vec2(B.data[((_156 + _313) * _154) + (_158 + _381)], B.data[((_156 + _313) * _154) + (_158 + (_381 + 1u))]), _139);
                    uint _400 = _169 + 8u;
                    _140 = fma(_323, vec2(B.data[((_156 + _313) * _154) + (_158 + _400)], B.data[((_156 + _313) * _154) + (_158 + (_400 + 1u))]), _140);
                    uint _419 = _169 + 10u;
                    _141 = fma(_323, vec2(B.data[((_156 + _313) * _154) + (_158 + _419)], B.data[((_156 + _313) * _154) + (_158 + (_419 + 1u))]), _141);
                    uint _438 = _169 + 12u;
                    _142 = fma(_323, vec2(B.data[((_156 + _313) * _154) + (_158 + _438)], B.data[((_156 + _313) * _154) + (_158 + (_438 + 1u))]), _142);
                    uint _457 = _169 + 14u;
                    _143 = fma(_323, vec2(B.data[((_156 + _313) * _154) + (_158 + _457)], B.data[((_156 + _313) * _154) + (_158 + (_457 + 1u))]), _143);
                    _135 = _313 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _133[_165 * 8u] = _136;
            _133[(_165 * 8u) + 1u] = _137;
            _133[(_165 * 8u) + 2u] = _138;
            _133[(_165 * 8u) + 3u] = _139;
            _133[(_165 * 8u) + 4u] = _140;
            _133[(_165 * 8u) + 5u] = _141;
            _133[(_165 * 8u) + 6u] = _142;
            _133[(_165 * 8u) + 7u] = _143;
            _134 = _165 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _133;
}

vec2[128] _514(vec2 _515[128])
{
    uint _541 = uint(16);
    uint _543 = uint(0);
    uint _545 = uint(0);
    uint _547 = uint(16);
    uint _549 = uint(0);
    uint _551 = uint(0);
    vec2 _537[128] = _515;
    vec2 _526[128] = vec2[](vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0));
    uint _527 = 0u;
    uint _552;
    for (;;)
    {
        _552 = _527;
        if (_552 < 16u)
        {
            uint _554 = _552 / 1u;
            uint _556 = (_552 % 1u) * 16u;
            uint _557 = _554 * 16u;
            uint _559 = _557 + _556;
            uint _560 = _559 + 1u;
            vec2 _529 = vec2(_537[_559 / 2u][_559 % 2u], _537[_560 / 2u][_560 % 2u]);
            uint _572 = _556 + 2u;
            uint _574 = _557 + _572;
            uint _575 = _574 + 1u;
            vec2 _530 = vec2(_537[_574 / 2u][_574 % 2u], _537[_575 / 2u][_575 % 2u]);
            uint _587 = _556 + 4u;
            uint _589 = _557 + _587;
            uint _590 = _589 + 1u;
            vec2 _531 = vec2(_537[_589 / 2u][_589 % 2u], _537[_590 / 2u][_590 % 2u]);
            uint _602 = _556 + 6u;
            uint _604 = _557 + _602;
            uint _605 = _604 + 1u;
            vec2 _532 = vec2(_537[_604 / 2u][_604 % 2u], _537[_605 / 2u][_605 % 2u]);
            uint _617 = _556 + 8u;
            uint _619 = _557 + _617;
            uint _620 = _619 + 1u;
            vec2 _533 = vec2(_537[_619 / 2u][_619 % 2u], _537[_620 / 2u][_620 % 2u]);
            uint _632 = _556 + 10u;
            uint _634 = _557 + _632;
            uint _635 = _634 + 1u;
            vec2 _534 = vec2(_537[_634 / 2u][_634 % 2u], _537[_635 / 2u][_635 % 2u]);
            uint _647 = _556 + 12u;
            uint _649 = _557 + _647;
            uint _650 = _649 + 1u;
            vec2 _535 = vec2(_537[_649 / 2u][_649 % 2u], _537[_650 / 2u][_650 % 2u]);
            uint _662 = _556 + 14u;
            uint _664 = _557 + _662;
            uint _665 = _664 + 1u;
            vec2 _536 = vec2(_537[_664 / 2u][_664 % 2u], _537[_665 / 2u][_665 % 2u]);
            uint _528 = 0u;
            uint _677;
            for (;;)
            {
                _677 = _528;
                if (_677 < 16u)
                {
                    vec2 _687 = vec2(A.data[((_543 + _554) * _541) + (_545 + _677)]);
                    uint _688 = _677 * 16u;
                    _529 = fma(_687, vec2(B.data[((_549 + _677) * _547) + (_551 + _556)], B.data[((_549 + _677) * _547) + (_551 + (_556 + 1u))]), _529);
                    uint _707 = _556 + 2u;
                    _530 = fma(_687, vec2(B.data[((_549 + _677) * _547) + (_551 + _707)], B.data[((_549 + _677) * _547) + (_551 + (_707 + 1u))]), _530);
                    uint _726 = _556 + 4u;
                    _531 = fma(_687, vec2(B.data[((_549 + _677) * _547) + (_551 + _726)], B.data[((_549 + _677) * _547) + (_551 + (_726 + 1u))]), _531);
                    uint _745 = _556 + 6u;
                    _532 = fma(_687, vec2(B.data[((_549 + _677) * _547) + (_551 + _745)], B.data[((_549 + _677) * _547) + (_551 + (_745 + 1u))]), _532);
                    uint _764 = _556 + 8u;
                    _533 = fma(_687, vec2(B.data[((_549 + _677) * _547) + (_551 + _764)], B.data[((_549 + _677) * _547) + (_551 + (_764 + 1u))]), _533);
                    uint _783 = _556 + 10u;
                    _534 = fma(_687, vec2(B.data[((_549 + _677) * _547) + (_551 + _783)], B.data[((_549 + _677) * _547) + (_551 + (_783 + 1u))]), _534);
                    uint _802 = _556 + 12u;
                    _535 = fma(_687, vec2(B.data[((_549 + _677) * _547) + (_551 + _802)], B.data[((_549 + _677) * _547) + (_551 + (_802 + 1u))]), _535);
                    uint _821 = _556 + 14u;
                    _536 = fma(_687, vec2(B.data[((_549 + _677) * _547) + (_551 + _821)], B.data[((_549 + _677) * _547) + (_551 + (_821 + 1u))]), _536);
                    _528 = _677 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _526[_552 * 8u] = _529;
            _526[(_552 * 8u) + 1u] = _530;
            _526[(_552 * 8u) + 2u] = _531;
            _526[(_552 * 8u) + 3u] = _532;
            _526[(_552 * 8u) + 4u] = _533;
            _526[(_552 * 8u) + 5u] = _534;
            _526[(_552 * 8u) + 6u] = _535;
            _526[(_552 * 8u) + 7u] = _536;
            _527 = _552 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _526;
}

void _2844(uint _2845, vec2 _2846)
{
    D.data[_2845] = _2846.x;
    D.data[_2845 + 1u] = _2846.y;
}

vec2[8] _875()
{
    vec2 _1708 = vec2(A.data[0u]);
    vec2 _1725 = vec2(A.data[1u]);
    vec2 _1742 = vec2(A.data[2u]);
    vec2 _1759 = vec2(A.data[3u]);
    vec2 _1776 = vec2(A.data[4u]);
    vec2 _1793 = vec2(A.data[5u]);
    vec2 _1810 = vec2(A.data[6u]);
    vec2 _1827 = vec2(A.data[7u]);
    vec2 _1844 = vec2(A.data[8u]);
    vec2 _1861 = vec2(A.data[9u]);
    vec2 _1863 = fma(_1861, vec2(B.data[144u], B.data[145u]), fma(_1844, vec2(B.data[128u], B.data[129u]), fma(_1827, vec2(B.data[112u], B.data[113u]), fma(_1810, vec2(B.data[96u], B.data[97u]), fma(_1793, vec2(B.data[80u], B.data[81u]), fma(_1776, vec2(B.data[64u], B.data[65u]), fma(_1759, vec2(B.data[48u], B.data[49u]), fma(_1742, vec2(B.data[32u], B.data[33u]), fma(_1725, vec2(B.data[16u], B.data[17u]), fma(_1708, vec2(B.data[0u], B.data[1u]), vec2(D.data[0u], D.data[1u])))))))))));
    vec2 _1865 = fma(_1861, vec2(B.data[146u], B.data[147u]), fma(_1844, vec2(B.data[130u], B.data[131u]), fma(_1827, vec2(B.data[114u], B.data[115u]), fma(_1810, vec2(B.data[98u], B.data[99u]), fma(_1793, vec2(B.data[82u], B.data[83u]), fma(_1776, vec2(B.data[66u], B.data[67u]), fma(_1759, vec2(B.data[50u], B.data[51u]), fma(_1742, vec2(B.data[34u], B.data[35u]), fma(_1725, vec2(B.data[18u], B.data[19u]), fma(_1708, vec2(B.data[2u], B.data[3u]), vec2(D.data[2u], D.data[3u])))))))))));
    vec2 _1867 = fma(_1861, vec2(B.data[148u], B.data[149u]), fma(_1844, vec2(B.data[132u], B.data[133u]), fma(_1827, vec2(B.data[116u], B.data[117u]), fma(_1810, vec2(B.data[100u], B.data[101u]), fma(_1793, vec2(B.data[84u], B.data[85u]), fma(_1776, vec2(B.data[68u], B.data[69u]), fma(_1759, vec2(B.data[52u], B.data[53u]), fma(_1742, vec2(B.data[36u], B.data[37u]), fma(_1725, vec2(B.data[20u], B.data[21u]), fma(_1708, vec2(B.data[4u], B.data[5u]), vec2(D.data[4u], D.data[5u])))))))))));
    vec2 _1869 = fma(_1861, vec2(B.data[150u], B.data[151u]), fma(_1844, vec2(B.data[134u], B.data[135u]), fma(_1827, vec2(B.data[118u], B.data[119u]), fma(_1810, vec2(B.data[102u], B.data[103u]), fma(_1793, vec2(B.data[86u], B.data[87u]), fma(_1776, vec2(B.data[70u], B.data[71u]), fma(_1759, vec2(B.data[54u], B.data[55u]), fma(_1742, vec2(B.data[38u], B.data[39u]), fma(_1725, vec2(B.data[22u], B.data[23u]), fma(_1708, vec2(B.data[6u], B.data[7u]), vec2(D.data[6u], D.data[7u])))))))))));
    vec2 _1871 = fma(_1861, vec2(B.data[152u], B.data[153u]), fma(_1844, vec2(B.data[136u], B.data[137u]), fma(_1827, vec2(B.data[120u], B.data[121u]), fma(_1810, vec2(B.data[104u], B.data[105u]), fma(_1793, vec2(B.data[88u], B.data[89u]), fma(_1776, vec2(B.data[72u], B.data[73u]), fma(_1759, vec2(B.data[56u], B.data[57u]), fma(_1742, vec2(B.data[40u], B.data[41u]), fma(_1725, vec2(B.data[24u], B.data[25u]), fma(_1708, vec2(B.data[8u], B.data[9u]), vec2(D.data[8u], D.data[9u])))))))))));
    vec2 _1873 = fma(_1861, vec2(B.data[154u], B.data[155u]), fma(_1844, vec2(B.data[138u], B.data[139u]), fma(_1827, vec2(B.data[122u], B.data[123u]), fma(_1810, vec2(B.data[106u], B.data[107u]), fma(_1793, vec2(B.data[90u], B.data[91u]), fma(_1776, vec2(B.data[74u], B.data[75u]), fma(_1759, vec2(B.data[58u], B.data[59u]), fma(_1742, vec2(B.data[42u], B.data[43u]), fma(_1725, vec2(B.data[26u], B.data[27u]), fma(_1708, vec2(B.data[10u], B.data[11u]), vec2(D.data[10u], D.data[11u])))))))))));
    vec2 _1875 = fma(_1861, vec2(B.data[156u], B.data[157u]), fma(_1844, vec2(B.data[140u], B.data[141u]), fma(_1827, vec2(B.data[124u], B.data[125u]), fma(_1810, vec2(B.data[108u], B.data[109u]), fma(_1793, vec2(B.data[92u], B.data[93u]), fma(_1776, vec2(B.data[76u], B.data[77u]), fma(_1759, vec2(B.data[60u], B.data[61u]), fma(_1742, vec2(B.data[44u], B.data[45u]), fma(_1725, vec2(B.data[28u], B.data[29u]), fma(_1708, vec2(B.data[12u], B.data[13u]), vec2(D.data[12u], D.data[13u])))))))))));
    vec2 _1877 = fma(_1861, vec2(B.data[158u], B.data[159u]), fma(_1844, vec2(B.data[142u], B.data[143u]), fma(_1827, vec2(B.data[126u], B.data[127u]), fma(_1810, vec2(B.data[110u], B.data[111u]), fma(_1793, vec2(B.data[94u], B.data[95u]), fma(_1776, vec2(B.data[78u], B.data[79u]), fma(_1759, vec2(B.data[62u], B.data[63u]), fma(_1742, vec2(B.data[46u], B.data[47u]), fma(_1725, vec2(B.data[30u], B.data[31u]), fma(_1708, vec2(B.data[14u], B.data[15u]), vec2(D.data[14u], D.data[15u])))))))))));
    vec2 _1878 = vec2(A.data[10u]);
    vec2 _1895 = vec2(A.data[11u]);
    vec2 _1912 = vec2(A.data[12u]);
    vec2 _1929 = vec2(A.data[13u]);
    vec2 _1946 = vec2(A.data[14u]);
    vec2 _1963 = vec2(A.data[15u]);
    return vec2[](fma(_1963, vec2(B.data[240u], B.data[241u]), fma(_1946, vec2(B.data[224u], B.data[225u]), fma(_1929, vec2(B.data[208u], B.data[209u]), fma(_1912, vec2(B.data[192u], B.data[193u]), fma(_1895, vec2(B.data[176u], B.data[177u]), fma(_1878, vec2(B.data[160u], B.data[161u]), _1863)))))), fma(_1963, vec2(B.data[242u], B.data[243u]), fma(_1946, vec2(B.data[226u], B.data[227u]), fma(_1929, vec2(B.data[210u], B.data[211u]), fma(_1912, vec2(B.data[194u], B.data[195u]), fma(_1895, vec2(B.data[178u], B.data[179u]), fma(_1878, vec2(B.data[162u], B.data[163u]), _1865)))))), fma(_1963, vec2(B.data[244u], B.data[245u]), fma(_1946, vec2(B.data[228u], B.data[229u]), fma(_1929, vec2(B.data[212u], B.data[213u]), fma(_1912, vec2(B.data[196u], B.data[197u]), fma(_1895, vec2(B.data[180u], B.data[181u]), fma(_1878, vec2(B.data[164u], B.data[165u]), _1867)))))), fma(_1963, vec2(B.data[246u], B.data[247u]), fma(_1946, vec2(B.data[230u], B.data[231u]), fma(_1929, vec2(B.data[214u], B.data[215u]), fma(_1912, vec2(B.data[198u], B.data[199u]), fma(_1895, vec2(B.data[182u], B.data[183u]), fma(_1878, vec2(B.data[166u], B.data[167u]), _1869)))))), fma(_1963, vec2(B.data[248u], B.data[249u]), fma(_1946, vec2(B.data[232u], B.data[233u]), fma(_1929, vec2(B.data[216u], B.data[217u]), fma(_1912, vec2(B.data[200u], B.data[201u]), fma(_1895, vec2(B.data[184u], B.data[185u]), fma(_1878, vec2(B.data[168u], B.data[169u]), _1871)))))), fma(_1963, vec2(B.data[250u], B.data[251u]), fma(_1946, vec2(B.data[234u], B.data[235u]), fma(_1929, vec2(B.data[218u], B.data[219u]), fma(_1912, vec2(B.data[202u], B.data[203u]), fma(_1895, vec2(B.data[186u], B.data[187u]), fma(_1878, vec2(B.data[170u], B.data[171u]), _1873)))))), fma(_1963, vec2(B.data[252u], B.data[253u]), fma(_1946, vec2(B.data[236u], B.data[237u]), fma(_1929, vec2(B.data[220u], B.data[221u]), fma(_1912, vec2(B.data[204u], B.data[205u]), fma(_1895, vec2(B.data[188u], B.data[189u]), fma(_1878, vec2(B.data[172u], B.data[173u]), _1875)))))), fma(_1963, vec2(B.data[254u], B.data[255u]), fma(_1946, vec2(B.data[238u], B.data[239u]), fma(_1929, vec2(B.data[222u], B.data[223u]), fma(_1912, vec2(B.data[206u], B.data[207u]), fma(_1895, vec2(B.data[190u], B.data[191u]), fma(_1878, vec2(B.data[174u], B.data[175u]), _1877)))))));
}

void _2880(uint _2881, vec2 _2882)
{
    D.data[_2881] = _2882.x;
    D.data[_2881 + 1u] = _2882.y;
}

vec2[8] _1981()
{
    vec2 _2570 = vec2(A.data[0u]);
    vec2 _2587 = vec2(A.data[1u]);
    vec2 _2604 = vec2(A.data[2u]);
    vec2 _2621 = vec2(A.data[3u]);
    vec2 _2638 = vec2(A.data[4u]);
    vec2 _2655 = vec2(A.data[5u]);
    vec2 _2672 = vec2(A.data[6u]);
    vec2 _2689 = vec2(A.data[7u]);
    vec2 _2706 = vec2(A.data[8u]);
    vec2 _2723 = vec2(A.data[9u]);
    vec2 _2725 = fma(_2723, vec2(B.data[144u], B.data[145u]), fma(_2706, vec2(B.data[128u], B.data[129u]), fma(_2689, vec2(B.data[112u], B.data[113u]), fma(_2672, vec2(B.data[96u], B.data[97u]), fma(_2655, vec2(B.data[80u], B.data[81u]), fma(_2638, vec2(B.data[64u], B.data[65u]), fma(_2621, vec2(B.data[48u], B.data[49u]), fma(_2604, vec2(B.data[32u], B.data[33u]), fma(_2587, vec2(B.data[16u], B.data[17u]), fma(_2570, vec2(B.data[0u], B.data[1u]), vec2(D.data[0u], D.data[1u])))))))))));
    vec2 _2727 = fma(_2723, vec2(B.data[146u], B.data[147u]), fma(_2706, vec2(B.data[130u], B.data[131u]), fma(_2689, vec2(B.data[114u], B.data[115u]), fma(_2672, vec2(B.data[98u], B.data[99u]), fma(_2655, vec2(B.data[82u], B.data[83u]), fma(_2638, vec2(B.data[66u], B.data[67u]), fma(_2621, vec2(B.data[50u], B.data[51u]), fma(_2604, vec2(B.data[34u], B.data[35u]), fma(_2587, vec2(B.data[18u], B.data[19u]), fma(_2570, vec2(B.data[2u], B.data[3u]), vec2(D.data[2u], D.data[3u])))))))))));
    vec2 _2729 = fma(_2723, vec2(B.data[148u], B.data[149u]), fma(_2706, vec2(B.data[132u], B.data[133u]), fma(_2689, vec2(B.data[116u], B.data[117u]), fma(_2672, vec2(B.data[100u], B.data[101u]), fma(_2655, vec2(B.data[84u], B.data[85u]), fma(_2638, vec2(B.data[68u], B.data[69u]), fma(_2621, vec2(B.data[52u], B.data[53u]), fma(_2604, vec2(B.data[36u], B.data[37u]), fma(_2587, vec2(B.data[20u], B.data[21u]), fma(_2570, vec2(B.data[4u], B.data[5u]), vec2(D.data[4u], D.data[5u])))))))))));
    vec2 _2731 = fma(_2723, vec2(B.data[150u], B.data[151u]), fma(_2706, vec2(B.data[134u], B.data[135u]), fma(_2689, vec2(B.data[118u], B.data[119u]), fma(_2672, vec2(B.data[102u], B.data[103u]), fma(_2655, vec2(B.data[86u], B.data[87u]), fma(_2638, vec2(B.data[70u], B.data[71u]), fma(_2621, vec2(B.data[54u], B.data[55u]), fma(_2604, vec2(B.data[38u], B.data[39u]), fma(_2587, vec2(B.data[22u], B.data[23u]), fma(_2570, vec2(B.data[6u], B.data[7u]), vec2(D.data[6u], D.data[7u])))))))))));
    vec2 _2733 = fma(_2723, vec2(B.data[152u], B.data[153u]), fma(_2706, vec2(B.data[136u], B.data[137u]), fma(_2689, vec2(B.data[120u], B.data[121u]), fma(_2672, vec2(B.data[104u], B.data[105u]), fma(_2655, vec2(B.data[88u], B.data[89u]), fma(_2638, vec2(B.data[72u], B.data[73u]), fma(_2621, vec2(B.data[56u], B.data[57u]), fma(_2604, vec2(B.data[40u], B.data[41u]), fma(_2587, vec2(B.data[24u], B.data[25u]), fma(_2570, vec2(B.data[8u], B.data[9u]), vec2(D.data[8u], D.data[9u])))))))))));
    vec2 _2735 = fma(_2723, vec2(B.data[154u], B.data[155u]), fma(_2706, vec2(B.data[138u], B.data[139u]), fma(_2689, vec2(B.data[122u], B.data[123u]), fma(_2672, vec2(B.data[106u], B.data[107u]), fma(_2655, vec2(B.data[90u], B.data[91u]), fma(_2638, vec2(B.data[74u], B.data[75u]), fma(_2621, vec2(B.data[58u], B.data[59u]), fma(_2604, vec2(B.data[42u], B.data[43u]), fma(_2587, vec2(B.data[26u], B.data[27u]), fma(_2570, vec2(B.data[10u], B.data[11u]), vec2(D.data[10u], D.data[11u])))))))))));
    vec2 _2737 = fma(_2723, vec2(B.data[156u], B.data[157u]), fma(_2706, vec2(B.data[140u], B.data[141u]), fma(_2689, vec2(B.data[124u], B.data[125u]), fma(_2672, vec2(B.data[108u], B.data[109u]), fma(_2655, vec2(B.data[92u], B.data[93u]), fma(_2638, vec2(B.data[76u], B.data[77u]), fma(_2621, vec2(B.data[60u], B.data[61u]), fma(_2604, vec2(B.data[44u], B.data[45u]), fma(_2587, vec2(B.data[28u], B.data[29u]), fma(_2570, vec2(B.data[12u], B.data[13u]), vec2(D.data[12u], D.data[13u])))))))))));
    vec2 _2739 = fma(_2723, vec2(B.data[158u], B.data[159u]), fma(_2706, vec2(B.data[142u], B.data[143u]), fma(_2689, vec2(B.data[126u], B.data[127u]), fma(_2672, vec2(B.data[110u], B.data[111u]), fma(_2655, vec2(B.data[94u], B.data[95u]), fma(_2638, vec2(B.data[78u], B.data[79u]), fma(_2621, vec2(B.data[62u], B.data[63u]), fma(_2604, vec2(B.data[46u], B.data[47u]), fma(_2587, vec2(B.data[30u], B.data[31u]), fma(_2570, vec2(B.data[14u], B.data[15u]), vec2(D.data[14u], D.data[15u])))))))))));
    vec2 _2740 = vec2(A.data[10u]);
    vec2 _2757 = vec2(A.data[11u]);
    vec2 _2774 = vec2(A.data[12u]);
    vec2 _2791 = vec2(A.data[13u]);
    vec2 _2808 = vec2(A.data[14u]);
    vec2 _2825 = vec2(A.data[15u]);
    return vec2[](fma(_2825, vec2(B.data[240u], B.data[241u]), fma(_2808, vec2(B.data[224u], B.data[225u]), fma(_2791, vec2(B.data[208u], B.data[209u]), fma(_2774, vec2(B.data[192u], B.data[193u]), fma(_2757, vec2(B.data[176u], B.data[177u]), fma(_2740, vec2(B.data[160u], B.data[161u]), _2725)))))), fma(_2825, vec2(B.data[242u], B.data[243u]), fma(_2808, vec2(B.data[226u], B.data[227u]), fma(_2791, vec2(B.data[210u], B.data[211u]), fma(_2774, vec2(B.data[194u], B.data[195u]), fma(_2757, vec2(B.data[178u], B.data[179u]), fma(_2740, vec2(B.data[162u], B.data[163u]), _2727)))))), fma(_2825, vec2(B.data[244u], B.data[245u]), fma(_2808, vec2(B.data[228u], B.data[229u]), fma(_2791, vec2(B.data[212u], B.data[213u]), fma(_2774, vec2(B.data[196u], B.data[197u]), fma(_2757, vec2(B.data[180u], B.data[181u]), fma(_2740, vec2(B.data[164u], B.data[165u]), _2729)))))), fma(_2825, vec2(B.data[246u], B.data[247u]), fma(_2808, vec2(B.data[230u], B.data[231u]), fma(_2791, vec2(B.data[214u], B.data[215u]), fma(_2774, vec2(B.data[198u], B.data[199u]), fma(_2757, vec2(B.data[182u], B.data[183u]), fma(_2740, vec2(B.data[166u], B.data[167u]), _2731)))))), fma(_2825, vec2(B.data[248u], B.data[249u]), fma(_2808, vec2(B.data[232u], B.data[233u]), fma(_2791, vec2(B.data[216u], B.data[217u]), fma(_2774, vec2(B.data[200u], B.data[201u]), fma(_2757, vec2(B.data[184u], B.data[185u]), fma(_2740, vec2(B.data[168u], B.data[169u]), _2733)))))), fma(_2825, vec2(B.data[250u], B.data[251u]), fma(_2808, vec2(B.data[234u], B.data[235u]), fma(_2791, vec2(B.data[218u], B.data[219u]), fma(_2774, vec2(B.data[202u], B.data[203u]), fma(_2757, vec2(B.data[186u], B.data[187u]), fma(_2740, vec2(B.data[170u], B.data[171u]), _2735)))))), fma(_2825, vec2(B.data[252u], B.data[253u]), fma(_2808, vec2(B.data[236u], B.data[237u]), fma(_2791, vec2(B.data[220u], B.data[221u]), fma(_2774, vec2(B.data[204u], B.data[205u]), fma(_2757, vec2(B.data[188u], B.data[189u]), fma(_2740, vec2(B.data[172u], B.data[173u]), _2737)))))), fma(_2825, vec2(B.data[254u], B.data[255u]), fma(_2808, vec2(B.data[238u], B.data[239u]), fma(_2791, vec2(B.data[222u], B.data[223u]), fma(_2774, vec2(B.data[206u], B.data[207u]), fma(_2757, vec2(B.data[190u], B.data[191u]), fma(_2740, vec2(B.data[174u], B.data[175u]), _2739)))))));
}

void _2905(uint _2906, vec2 _2907)
{
    D.data[_2906] = _2907.x;
    D.data[_2906 + 1u] = _2907.y;
}

void main()
{
    vec2 _55[128] = _116();
    vec2 tempArg[128] = _55;
    vec2 d0[128] = _55;
    vec2 _62[128] = _514(_55);
    vec2 tempArg_1[128] = _62;
    vec2 d1[128] = _62;
    vec2 _2855[128] = _62;
    uint _2856 = 0u;
    uint _2861;
    for (;;)
    {
        _2861 = _2856;
        if (_2861 < 256u)
        {
            _2844(((uint(0) + (_2861 / 16u)) * uint(16)) + (uint(0) + (_2861 % 16u)), _2855[_2861 / 2u]);
            _2856 = _2861 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _89[8] = _875();
    vec2 tempArg_2[8] = _89;
    vec2 y0[8] = _89;
    vec2 _2891[8] = _89;
    uint _2892 = 0u;
    uint _2897;
    for (;;)
    {
        _2897 = _2892;
        if (_2897 < 16u)
        {
            _2880(0u + _2897, _2891[_2897 / 2u]);
            _2892 = _2897 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _102[8] = _1981();
    vec2 tempArg_3[8] = _102;
    vec2 y1[8] = _102;
    vec2 _2915[8] = _102;
    uint _2916 = 0u;
    uint _2921;
    for (;;)
    {
        _2921 = _2916;
        if (_2921 < 16u)
        {
            _2905(0u + _2921, _2915[_2921 / 2u]);
            _2916 = _2921 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

