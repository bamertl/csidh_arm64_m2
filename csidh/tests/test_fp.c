#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include "extras.h"
#include "fp.h"
#include "constants.h"

#include <stdint.h>
#include <time.h> // Include the time.h header for the time() function

typedef struct biguint
{
    uint64_t c[16];
} biguint;
extern void uint_mul(const fp *a, const uint *b, biguint *c);
extern void fp_mul3_2(const fp *a, const fp *b, fp *c);

const struct fp p_minus_2_for_fp = {{
    0x1b81b90533c6c879,
    0xc2721bf457aca835,
    0x516730cc1f0b4f25,
    0xa7aac6c567f35507,
    0x5afbfcc69322c9cd,
    0xb42d083aedc88c42,
    0xfc8ab0d15e3e4c4a,
    0x65b48e8f740f89bf,
}};

const struct uint muu = {{0x66c1301f632e294d,
                          0xfe025ed7d0d3b1aa,
                          0xf6fe2bc33e915395,
                          0x34ed3ea7f1de34c4,
                          0xb081b3aba7d05f85,
                          0x1232b9eb013dee1e,
                          0x3512da337a97b345,
                          0xd8c3904b18371bcd}};

void fp_print(fp const *x)
{
    for (size_t i = 0; i < 8 * LIMBS; i++)
    {
        printf("%02hhx", i[(unsigned char *)x->c]);
        if (i % 8 == 0)
        {
            printf(" ,0x");
        }
    }

    printf("\n");
}

void uint_print(uint const *x)
{
    for (size_t i = 8 * LIMBS - 1; i < 8 * LIMBS; --i)
        printf("%02hhx", i[(unsigned char *)x->c]);
    printf("\n");
}

void biguint_print(uint const *x)
{
    for (size_t i = 8 * 16 - 1; i < 8 * 16; --i)
        printf("%02hhx", i[(unsigned char *)x->c]);
    printf("\n");
}

void biguint_print_lower(uint const *x)
{
    for (size_t i = 8 * 8 - 1; i < 8 * 8; --i)
        printf("%02hhx", i[(unsigned char *)x->c]);
    printf("\n");
}

void test_fp_eq(*a, *b)
{
    assert(fp_eq(a, b));
}

void test_fp_add(void)
{
    fp a = {{0}};
    fp b = {{3, 1, 2, 3, 4, 5, 6, 7}};
    fp c = {{0, 1, 2, 3, 4, 5, 6, 7}};

    fp expected1 = {{3, 2, 4, 6, 8, 10, 12, 14}};
    fp_add3(&a, &b, &c);
    assert(fp_eq(&a, &expected1));

    fp_add2(&b, &p_minus_2_for_fp);
    fp expected2 = {{1, 1, 2, 3, 4, 5, 6, 7}};

    for (int i = 0; i < LIMBS; i++)
    {
        assert(expected2.c[i] == b.c[i]);
    }
}

void test_mul_3(void)
{
    fp r1 = {{1, 2, 3, 4, 5, 6, 7, 8}};
    fp r2 = {{1, 2, 3, 4, 5, 6, 7, 8}};
    fp b = {{1, 0, 0, 0, 0, 0, 0, 0}};
    fp bigone = {{0x48b72f84899eca48, 0xdb7e0542b77624de, 0xafaeb264ca1bb35a, 0xba24269dff081925, 0x5d6cec71e0fac030, 0x845f1c9d401fac7f, 0x0000000000000002, 0x0000000000000000}};
    fp c = r_squared_mod_p;
    biguint d = {{0}};
    // q is same as r_squared_mod_p
    uint q = {{
        0x36905b572ffc1724,
        0x67086f4525f1f27d,
        0x4faf3fbfd22370ca,
        0x192ea214bcc584b1,
        0x5dae03ee2f5de3d0,
        0x1e9248731776b371,
        0xad5f166e20e4f52d,
        0x4ed759aea6f3917e,
    }};
    uint_mul(&r_squared_mod_p, &q, &d);
    // biguint_print(&d);
    fp expected1 = fp_1;
    fp_mul3(&r1, &fp_1, &p_minus_2_for_fp);
    fp_mul3_2(&r2, &fp_1, &p_minus_2_for_fp);
    test_fp_eq(&r1, &r2);
    fp_mul3(&r1, &p_minus_2_for_fp, &p_minus_2_for_fp);
    fp_mul3_2(&r2, &p_minus_2_for_fp, &p_minus_2_for_fp);
    test_fp_eq(&r1, &r2);
    fp_mul3(&r1, &q, &p_minus_2_for_fp);
    fp_mul3_2(&r2, &q, &p_minus_2_for_fp);
    test_fp_eq(&r1, &r2);
    fp_mul3(&r1, &bigone, &p_minus_2_for_fp);
    fp_mul3_2(&r2, &bigone, &p_minus_2_for_fp);

    test_fp_eq(&r1, &r2);

    fp a = {{1, 2, 3, 4, 5, 6, 7, 8}};
    fp f = {{1, 2, 3, 4, 5, 6, 7, 8}};
    fp_mul3(&r1, &a, &bigone);
    fp_mul3_2(&r2, &a, &bigone);
    test_fp_eq(&r2, &r1);
    fp_mul3(&a, &r_squared_mod_p, &r_squared_mod_p);
    fp_mul3_2(&f, &r_squared_mod_p, &r_squared_mod_p);
    test_fp_eq(&a, &f);
    fp_mul3(&a, &fp_1, &r_squared_mod_p);
    fp_mul3_2(&f, &fp_1, &r_squared_mod_p);
    test_fp_eq(&a, &f);
    fp_mul3(&a, &b, &r_squared_mod_p);
    fp_mul3_2(&f, &b, &r_squared_mod_p);
    test_fp_eq(&a, &f);
    fp_mul3(&a, &b, &b);
    fp_mul3_2(&f, &b, &b);
    test_fp_eq(&a, &f);
    fp_mul3(&a, &fp_1, &fp_1);
    fp_mul3_2(&f, &fp_1, &fp_1);
    test_fp_eq(&a, &f);
    fp_mul3(&a, &fp_1, &p_minus_2_for_fp);
    fp_mul3_2(&f, &fp_1, &p_minus_2_for_fp);
    test_fp_eq(&a, &f);
    fp_mul3(&a, &p, &fp_1);
    fp_mul3_2(&f, &p, &fp_1);
    test_fp_eq(&a, &f);
    fp_mul3(&a, &p, &p);
    fp_mul3_2(&f, &p, &p);
    test_fp_eq(&a, &f);
    fp_mul3(&a, &b, &p);
    fp_mul3_2(&f, &b, &p);
    test_fp_eq(&a, &f);
    ;
}

void ultimate_test(void)
{
    fp a = {{1, 2, 3, 4, 5, 6, 7, 8}};
    fp bigone = {{0x48b72f84899eca48, 0xdb7e0542b77624de, 0xafaeb264ca1bb35a, 0xba24269dff081925, 0x5d6cec71e0fac030, 0x845f1c9d401fac7f, 0x0000000000000002, 0x0000000000000000}};
    fp f = {{1, 2, 3, 4, 5, 6, 7, 8}};
    fp b = {{1, 0, 0, 0, 0, 0, 0, 0}};
    uint c = {{1, 0, 0, 0, 0, 0, 0, 0}};
    biguint d = {{0}};
    // uint_mul(&p, &c, &d);
    // biguint_print(&d);
    fp_mul3(&a, &bigone, &p_minus_2_for_fp);
    // fp_mul3_2(&f, &bigone, &p_minus_2_for_fp);
    // biguint_print_lower(&a);
    // biguint_print_lower(&f);
}

void test_mul_more(void)
{
    uint result = {{0}};
    fp a = {{1, 2, 3, 4, 5, 6, 7, 8}};
    fp b = {{1, 2, 3, 4, 5, 6, 7, 8}};
    fp_set(&a, 5);
    fp_set(&b, 6);
    fp_mul2(&a, &b);
    fp_dec(&result, &a);
    fp expected = {{30, 0, 0, 0, 0, 0, 0, 0}};

    for (int i = 0; i < LIMBS; i++)
    {
        assert(expected.c[i] == result.c[i]);
    }
}

void test_fp_sub(void)
{
    fp a = {{1, 2, 3, 4, 5, 6, 7, 8}};
    fp b = {{1, 2, 3, 4, 5, 6, 7, 8}};
    fp c = {{1, 2, 3, 4, 5, 6, 7, 8}};
    fp expected = {{0}};
    fp_sub3(&a, &b, &c);
    fp_sub2(&b, &c);

    for (int i = 0; i < LIMBS; i++)
    {
        assert(expected.c[i] == a.c[i]);
    }

    for (int i = 0; i < LIMBS; i++)
    {
        assert(expected.c[i] == b.c[i]);
    }
}

void test_encode_decode(void)
{
    uint aa = {{1, 2, 3, 4, 5, 6, 7, 8}};
    uint bb = {{0}};
    fp a = {{0}};
    fp_enc(&a, &aa);
    fp_dec(&bb, &a);
    for (int i = 0; i < LIMBS; i++)
    {
        assert(aa.c[i] == bb.c[i]);
    }
}

void test_sq1(void)
{
    uint aa = {{2, 0, 0, 0, 0, 0, 0, 0}};
    uint bb = {{0}};
    fp a = {{0}};
    fp_enc(&a, &aa);
    fp expected = {{4, 0, 0, 0, 0, 0, 0, 0}};
    fp_sq1(&a);
    fp_dec(&bb, &a);
    for (int i = 0; i < LIMBS; i++)
    {
        assert(expected.c[i] == bb.c[i]);
    }
    fp_sq2(&a, &a);
    fp_dec(&bb, &a);
    fp expected2 = {{16, 0, 0, 0, 0, 0, 0, 0}};
    for (int i = 0; i < LIMBS; i++)
    {
        assert(expected2.c[i] == bb.c[i]);
    }
}

void test_inverse(void)
{
    uint a = {{2, 0, 0, 0, 0, 0, 0, 0}};
    fp b = {{0}};
    fp_enc(&b, &a);
    fp_inv(&b);
    fp_print(&b);
}

void test_fp_pow(void)
{
    printf("p : ");
    uint_print(&p);
    uint aa = {{5, 0, 0, 0, 0, 0, 1, 0}};
    uint bb = {{0}};
    fp a = {{0}};
    fp_enc(&a, &aa);

    printf("a: ");
    fp_print(&a);
    fp_dec(&aa, &a);
    printf("aa: ");
    uint_print(&aa);
    uint b = {{30, 1, 1, 0, 0, 0, 0, 0}};
    fp_pow(&a, &b);
    fp_print(&a);

    printf("a^1: ");
}

void test_decrypt(void)
{
    // uint aa = {{12312312312,13451,1124,11241,112334,141241,1214124,12431289431}};
    uint aa = {{2231231233, 25, 25, 25, 25, 25, 25, 25123123}};
    uint_print(&aa);
    printf("mu: ");
    fp_print(&r_squared_mod_p);
    fp a = {{0}};
    fp_enc(&a, &aa);
    fp_print(&a);
    fp_dec(&aa, &a);
    uint_print(&aa);
}

uint q = {{0x48b72f84899eca48, 0xdb7e0542b77624de, 0xff, 0xf, 0xd, 0xc, 0x0000000000000002, 0x0000000000000000}};

void test_uint_mul(void)
{
    fp a = {{0xd45f914906fc8f68, 0xf2e3f6dff4cef5f1, 0xd927fa85083ccad4, 0x68016cf8e4fc5fd0, 0x5a5a847e9bff7844, 0x6ab1c33fad4a7674, 0xffc157ad48adf78f, 0x1a0d9ee6d73adc9e}};
    biguint b = {{0}};
    fp zero = {{0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}};
    uint_mul(&p_minus_2_for_fp, &zero, &b);
    biguint_print(&b);
}

void test_fp_mul(void)
{
    fp a = {{0xd45f914906fc8f68, 0xf2e3f6dff4cef5f1, 0xd927fa85083ccad4, 0x68016cf8e4fc5fd0, 0x5a5a847e9bff7844, 0x6ab1c33fad4a7674, 0xffc157ad48adf78f, 0x1a0d9ee6d73adc9e}};
    biguint b = {{0}};
    fp zero = {{0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}};
    fp_mul3(&p_minus_2_for_fp, &zero, &b);
    biguint_print(&b);
}

void test_issquare(void)
{
    fp a = {{2}};
    bool itis = fp_issquare(&a);
    printf("itis: %d\n", itis);
}

void ultimate_uint_test(void)
{
    fp a = {{1, 2, 3, 4, 5, 6, 7, 8}};
    fp b = {{1, 0, 0, 0, 0, 0, 0, 0}};
    fp bigone = {{0x48b72f84899eca48, 0xdb7e0542b77624de, 0xafaeb264ca1bb35a, 0xba24269dff081925, 0x5d6cec71e0fac030, 0x845f1c9d401fac7f, 0x2, 0x0}};

    uint c = {{0x1b81b90533c6c879, 0xc2721bf457aca835, 0x516730cc1f0b4f25, 0xa7aac6c567f35507, 0x5afbfcc69322c9cd, 0xb42d083aedc88c42, 0xfc8ab0d15e3e4c4a, 0x65b48e8f740f89b}};
    biguint d = {{0}};
    uint_mul(&bigone, &p_minus_2_for_fp, &d);
    biguint_print(&d);
}

void ultimate_fp_mul_test(void)
{
    fp a = {{1, 2, 3, 4, 5, 6, 7, 8}};
    fp b = {{1, 0, 0, 0, 0, 0, 0, 0}};
    fp r1 = {{1, 2, 3, 4, 5, 6, 7, 8}};
    fp r2 = {{1, 2, 3, 4, 5, 6, 7, 8}};
    fp bigone = {{0x770ab50c5ff463e2, 0x25c9bba55f3e6104, 0x78537e753193710a, 0x46e260f3384b15e0, 0x498941ff524bf210, 0x780122a51289bc30, 0x10a1fcd27add4785, 0x5582abc775dbc1ac}};

    uint c = {{0x2e883fa7730b04ce, 0x5868ab633fcc1ded, 0x71c0d3532a72287d, 0x2cc03c5000b7bf24, 0x1f65d4da56794450, 0x33740c8a07e3526a, 0x5d37b131735237c6, 0x1acbe3503fb8a6ee}};
    biguint d = {{0}};
    /*
    fp_mul3(&r1, &bigone, &c);
    biguint_print_lower(&r1);
    printf("\n");
    fp_mul3_2(&r2, &bigone, &c);
    biguint_print_lower(&r2);
    */
    fp t1 = {{0x121011645ce5c57f,0x7109447e176fe62c,0x33705eb9165ade11,0x27a9398e5701adf9,0x2f44e30f53970607,0x600ce0706d630a53,0x013b07404a58fb61,0x17dfc36963962ebd}};
    fp t2 = {{0x18d6ad5f361044b6,0x660f24746c227004,0x48e84e120b5da523,0x3104a2a927531e63,0x41f009c076103e11,0x245b0aa55517e948,0x14d4a19d13be551a,0x34c528167bcad76a}};
    fp int1 = {{0x1dce692d35c0244a,0x19ebdca15c70fc66,0x902d6720cf3c2352,0xdcaefc48419efa74,0xf727e1ded7f4085b,0x4c43705b5ca98470,0xa3b306dd0c90d148,0x62bcd205629d2dca}};
    fp fail = {{0xda55322e290021fa,0xe255769c72ef34d1,0x7af97c7b02524f47,0xeb92b26a9afcc044,0x269de0b167281607,0xee1dc584f2089961,0x822e02bae1580f8d,0xf9eff47168d55509}};
    uint_mul(&int1, &muu, &b);
    biguint_print(&b);
}

void fillWithRandomFP(fp *term)
{
    for (int i = 0; i < 8; ++i)
    {
        term->c[i] = ((uint64_t)rand() << 32) | rand();
    }
}

void fillWithRandomUint(uint *num)
{
    for (int i = 0; i < LIMBS; ++i)
    {
        num->c[i] = ((uint64_t)rand() << 32) | rand();
    }
}

bool fp_eq_new(const fp *a, const fp *b)
{
    // Implement the logic to check if the two fp structs are equal
    // You need to compare the elements of a and b
    for (int i = 0; i < LIMBS; ++i)
    {
        if (a->c[i] != b->c[i])
        {
            return false;
        }
    }
    return true;
}

bool test_fp_eq_new(const fp *a, const fp *b)
{
    return fp_eq_new(a, b);
}

void test_jan()
{
    srand((unsigned int)time(NULL));

    for (int i = 0; i < 100000; ++i)
    {

        // Create an fp struct and fill it with random values
        fp term;
        fillWithRandomFP(&term);
        uint uintTerm;
        fillWithRandomUint(&uintTerm);

        biguint d = {{0}};
        fp r1 = {{1, 2, 3, 4, 5, 6, 7, 8}};
        fp r2 = {{1, 2, 3, 4, 5, 6, 7, 8}};

        fp_mul3(&r1, &term, &uintTerm);

        fp_mul3_2(&r2, &term, &uintTerm);

        bool result = test_fp_eq_new(&r1, &r2);
        if (!result)
        {
            printf("FP:\n");
            biguint_print_lower(&term);
            printf("UINT:\n");
            biguint_print_lower(&uintTerm);
            printf("RESULT:\n");
            biguint_print_lower(&r1);
            biguint_print_lower(&r2);
        }
    }
}

int main(void)
{
    // test_fp_eq();
    // test_fp_add();
    // test_mul_3();
    // test_mul_more();
    // test_fp_sub();
    // test_encode_decode();
    // test_sq1();
    // test_inverse();
    // test_fp_pow();
    // test_inverse();
    // test_decrypt();
    // test_issquare();
    // test_uint_mul();
    // ultimate_test();
    // ultimate_uint_test();
    //ultimate_fp_mul_test();
    test_jan();
    printf("All tests passed!\n");
    return 0;
}
