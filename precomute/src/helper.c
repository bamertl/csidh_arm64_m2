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

void uint_print(uint64_t const *x)
{
    for (size_t i = 8*LIMBS-1; i < 8*LIMBS; --i)
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

int main(){
    uint_print(p.c);
    uint64_t a[8] = {0x0000000000000002, 0x0, 0x0, 0x0,0x0,0x0,0x0, 0x0};
    uint64_t c[8] = {0};
    multiply_modulo(a, R_squared_mod.c, p.c, c);
    uint_print(c);
    return 0;
}