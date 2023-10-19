#include <gmp.h>
#include <stdint.h>
#include <stdio.h>

#define LIMBS 8

typedef struct uint {
    uint64_t c[LIMBS];
} uint;

const struct uint p = {{
    0x1b81b90533c6c87b, 0xc2721bf457aca835, 0x516730cc1f0b4f25, 0xa7aac6c567f35507,
    0x5afbfcc69322c9cd, 0xb42d083aedc88c42, 0xfc8ab0d15e3e4c4a, 0x65b48e8f740f89bf,
}};

const struct uint R_squared_mod = {{
    0x36905b572ffc1724,
    0x67086f4525f1f27d,
    0x4faf3fbfd22370ca,
    0x192ea214bcc584b1,
    0x5dae03ee2f5de3d0,
    0x1e9248731776b371,
    0xad5f166e20e4f52d,
    0x4ed759aea6f3917e
}};

/* 2^512 mod p */
const struct uint fp_1 = {{
    0xc8fc8df598726f0a, 0x7b1bc81750a6af95, 0x5d319e67c1e961b4, 0xb0aa7275301955f1,
    0x4a080672d9ba6c64, 0x97a5ef8a246ee77b, 0x06ea9e5d4383676a, 0x3496e2e117e0ec80,
}};

uint64_t r[9] = {0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x1};

const struct uint mu = {{
    0x66c1301f632e294d,
    0xfe025ed7d0d3b1aa,
    0xf6fe2bc33e915395,
    0x34ed3ea7f1de34c4,
    0xb081b3aba7d05f85,
    0x1232b9eb013dee1e,
    0x3512da337a97b345,
    0xd8c3904b18371bcd
    }};

const struct uint a = {{0x0000000000000001, 0x0, 0x0, 0x0,0x0,0x0,0x0, 0x0}};

void uint_print(uint64_t const *x)
{
    for (size_t i = 8*LIMBS-1; i < 8*LIMBS; --i)
       printf("%02hhx", i[(unsigned char *) x]);
    printf("\n");
}

void print_larger(uint64_t *x)
{
    for (size_t i = 8*16-1; i < 8*16; --i)
       printf("%02hhx", i[(unsigned char *) x]);
    printf("\n");
}

void init_mpz_from_uint(mpz_t N, const uint64_t numba[8]) {
    mpz_init(N);  // Initialize N to 0
    for (int i = LIMBS-1; i >= 0; i--) {
        mpz_mul_2exp(N, N, 64);  // Shift left by 64 bits
        mpz_add_ui(N, N, numba[i]); // Add the next 64-bit chunk
    }
}

void init_mpz_from_r(mpz_t N, uint64_t numba[9]) {
    mpz_init(N);  // Initialize N to 0
    for (int i = 9-1; i >= 0; i--) {
        mpz_mul_2exp(N, N, 64);  // Shift left by 64 bits
        mpz_add_ui(N, N, numba[i]); // Add the next 64-bit chunk
    }
}

void multiply_modulo(const uint64_t a[8], const uint64_t b[8], const uint64_t mod[8], uint64_t result[8]) {
    mpz_t ma, mb, mmod, mresult;

    init_mpz_from_uint(ma, a);
    init_mpz_from_uint(mb, b);
    init_mpz_from_uint(mmod,mod);
    mpz_init(mresult);

    // Perform the multiplication and modulo operation
    mpz_mul(mresult, ma, mb);
    mpz_mod(mresult, mresult, mmod);

    // Extract the result back into the result array
    for (int i = 0; i < 8; i++) {
    result[i] = mpz_get_ui(mresult);
    mpz_tdiv_q_2exp(mresult, mresult, 64);
    }

    // Clean up
    mpz_clear(ma);
    mpz_clear(mb);
    mpz_clear(mmod);
    mpz_clear(mresult);
}

void mpz_to_uint_large(mpz_t N, uint64_t result[16]) {
    for (int i = 0; i < 16; i++) {
        result[i] = mpz_get_ui(N);
        mpz_tdiv_q_2exp(N, N, 64);
    }
}


void test_mul(){
    mpz_t mr_squared_mod, mmu, mresult, q, mr, PQ, mp, ma, temp, C, amodr;
    init_mpz_from_uint(mr_squared_mod, R_squared_mod.c);
    init_mpz_from_uint(mmu, mu.c);
    init_mpz_from_r(mr, r);
    init_mpz_from_uint(mp, p.c);
    init_mpz_from_uint(ma, a.c);
    mpz_init(mresult);
    mpz_init(q);
    mpz_init(PQ);
    mpz_init(temp);
    mpz_init(C);
    mpz_init(amodr);
    gmp_printf("r in hex: %Zx\n", mr);
    gmp_printf("p in hex: %Zx\n", mp);
    mpz_mod(amodr, ma, mr);

    mpz_mul(mresult, amodr, mmu);
    mpz_mod(q, mresult, mr);

    gmp_printf("q in hex: %Zx\n", q);
    mpz_mul(PQ, q,mp);
    gmp_printf("PQ in hex: %Zx\n", PQ);

    mpz_add(temp, PQ, ma);
    gmp_printf("added a %Zx\n", temp);
    mpz_div(C, temp, mr);
    mpz_mod(C, C, mp);

    gmp_printf("C monte mul in hex: %Zx\n", C);

    mpz_mul(C, C, mr);
    mpz_mod(C, C, mp);
    gmp_printf("C * r monte mul in hex: %Zx\n", C);

    //print_larger(result);
}


void easy_result(){
    mpz_t ma, mp, mr,mr_squared_mod, result;
    init_mpz_from_uint(ma, a.c);
    init_mpz_from_uint(mr_squared_mod, R_squared_mod.c);
    init_mpz_from_uint(mp, p.c);
    init_mpz_from_r(mr, r);
    mpz_init(result);

    mpz_mul(result, ma, mr); // a * r
    mpz_mod(result, result, mp); // a*r mod p
    gmp_printf("a*r mod p in hex: %Zx\n", result);

}


int main(){
    easy_result();
    test_mul();
   }