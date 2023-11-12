#include <stdlib.h>
#include <stdio.h>
#include <assert.h> 
#include "extras.h"
#include "fp.h"
#include "constants.h"
#include <inttypes.h>
#include <string.h>

typedef struct biguint { uint64_t c[16]; } biguint;
typedef struct smalluint { uint64_t c[4]; } smalluint;
const struct fp p_minus_2_for_fp = {{
    0x1b81b90533c6c879, 0xc2721bf457aca835, 0x516730cc1f0b4f25, 0xa7aac6c567f35507,
    0x5afbfcc69322c9cd, 0xb42d083aedc88c42, 0xfc8ab0d15e3e4c4a, 0x65b48e8f740f89bf,
}};

void biguint_to_hex_string(const biguint* value, char* buffer, size_t buffer_size) {
    // Start from the end of the biguint array (most significant word)
    for (int i = 16 - 1; i >= 0; i--) {
        // Append each word in hexadecimal format to the buffer
        // snprintf prevents buffer overflow
        int written = snprintf(buffer, buffer_size, "%016" PRIx64, value->c[i]);
        buffer += written; // Move the buffer pointer
        buffer_size -= written; // Decrease the remaining buffer size

        if (buffer_size <= 0) {
            break; // Stop if buffer is full
        }
    }
}


const struct uint muu = {{
    0x66c1301f632e294d,
    0xfe025ed7d0d3b1aa,
    0xf6fe2bc33e915395,
    0x34ed3ea7f1de34c4,
    0xb081b3aba7d05f85,
    0x1232b9eb013dee1e,
    0x3512da337a97b345,
    0xd8c3904b18371bcd
    }};


void fp_print(fp const *x)
{
    for (size_t i = 8*LIMBS-1; i < 8*LIMBS; --i)
        printf("%02hhx", i[(unsigned char *) x->c]);
    printf("\n");
}

void uint_print(uint const *x)
{
    for (size_t i = 8*LIMBS-1; i < 8*LIMBS; --i)
        printf("%02hhx", i[(unsigned char *) x->c]);
    printf("\n");
}

void small_uint_print(smalluint const *x)
{
    for (size_t i = 8*4-1; i < 8*4; --i)
        printf("%02hhx", i[(unsigned char *) x->c]);
    printf("\n");
}

void biguint_print(biguint const *x)
{
    for (size_t i = 8*16-1; i < 8*16; --i)
        printf("%02hhx", i[(unsigned char *) x->c]);
    printf("\n");
}

void biguint_print_lower(uint const *x)
{
    for (size_t i = 8*8-1; i < 8*8; --i)
        printf("%02hhx", i[(unsigned char *) x->c]);
    printf("\n");
}

extern void uint_mul_lower(smalluint *c, smalluint const *a, uint const *b);

extern void uint_mul_128x128(uint *c, uint const *a, uint const *b);

extern void uint_mul_512x512(uint *a, uint *b, biguint *c);


void test_big_mul(void)
{
    uint a = {{0x66c1301f632e294d, 0xfe025ed7d0d3b1aa, 0xf6fe2bc33e915395, 0x34ed3ea7f1de34c4,
               0xb081b3aba7d05f85, 0x1232b9eb013dee1e, 0x3512da337a97b345, 0xd8c3904b18371bcd}};
    uint b = {{0x5afbfcc69322c9cd, 0xb42d083aedc88c42, 0xfc8ab0d15e3e4c4a, 0x65b48e8f740f89bf,
               0x1b81b90533c6c879, 0xc2721bf457aca835, 0x516730cc1f0b4f25, 0xa7aac6c567f35507}};
    printf("a = "); uint_print(&a);
    printf("b = "); uint_print(&b);
    biguint c = {{0}};

    uint_mul_512x512(&a, &b, &c);
    char hex_str[1024];
    biguint_to_hex_string(&c, hex_str, sizeof(hex_str));
    printf("c = %s\n", hex_str);
    const char* expected_c_str = "8df82d4d36c6deeee502f112235d7547ad5d86b2d21ffcc8246aed5ce37d1b6e8bc4bfb59fe4e125d3f45e76bb3921032865b2f347fa0430ac3ee0cc2606008d574f69831079d92c5a143f876bef56f5eaa89aa71df6f1afba7fd463473c3b7018d229d93694b2d30faa3688c0c3760de68210451bb9fcf6187599685d9e87a9";
    assert(strcmp(hex_str, expected_c_str) == 0);
}

void test_big_mul_example1(void)
{
    uint a = {{0x1a2b3c4d5e6f7081, 0x9a8b7c6d5e4f3021, 0x1234567890abcdef, 0xfedcba9876543210,
               0x0f1e2d3c4b5a6978, 0x8172635455766879, 0xabcdef0123456789, 0x0123456789abcdef}};
    uint b = {{0x9988776655443322, 0x1122334455667788, 0x99aabbccddeeff00, 0x0011223344556677,
               0x8899aabbccddeeff, 0x7766554433221100, 0x123456789abcdef0, 0xfedcba9876543210}};
    printf("a = "); uint_print(&a);
    printf("b = "); uint_print(&b);
    biguint c = {{0}};
    uint_mul_512x512(&a, &b, &c);
    char hex_str[1024];
    biguint_to_hex_string(&c, hex_str, sizeof(hex_str));
    printf("c = %s\n", hex_str);
    const char* expected_c_str = "0121fa00ad77d742cd5604541ff04dc086566ce7b922d4343b594245621cf7da07b60769d0fa68158fb34febcc14ac2b3118334e364d56bbc36a30d4db111a0211c428fc066e50b41af019870d04ed81a3cdc3ca2358e000b1e0d115d45ddb33b8dae50a7e8698be95d45b6f550ae6dbed282cb68148c9d016e44c71757aa422";
    assert(strcmp(hex_str, expected_c_str) == 0);
}

void test_uint_mul_lower(void)
{
    smalluint a = {{0x66c1301f632e294d, 0xfe025ed7d0d3b1aa, 0xf6fe2bc33e915395, 0x34ed3ea7f1de34c4}};
    smalluint b = {{0x5afbfcc69322c9cd, 0xb42d083aedc88c42, 0xfc8ab0d15e3e4c4a, 0x65b48e8f740f89bf}};

    printf("a = "); small_uint_print(&a);
    printf("b = "); small_uint_print(&b);
    uint c = {{0,0,0,0,0,0,0,0}};
    uint_mul_lower(&a, &b, &c);
    uint_print(&c);
}

// write another test for uint_mul_512x512

int main(void)
{
    //test_uint_mul_lower();
    test_big_mul();
    test_big_mul_example1();
    printf("All tests passed!\n");
    return 0;
}
