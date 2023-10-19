#include <gmp.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LIMBS 8

typedef struct uint_custom {
    uint64_t c[LIMBS];
} uint_custom;

const struct uint_custom p = {{
    0x1b81b90533c6c87b, 0xc2721bf457aca835, 0x516730cc1f0b4f25, 0xa7aac6c567f35507,
    0x5afbfcc69322c9cd, 0xb42d083aedc88c42, 0xfc8ab0d15e3e4c4a, 0x65b48e8f740f89bf,
}};

void init_mpz_from_uint(mpz_t N, const uint_custom p) {
    mpz_init(N);  // Initialize N to 0
    for (int i = LIMBS-1; i >= 0; i--) {
        mpz_mul_2exp(N, N, 64);  // Shift left by 64 bits
        mpz_add_ui(N, N, p.c[i]); // Add the next 64-bit chunk
    }
}


void print_reversed_chunks(const char* input) {
    size_t length = strlen(input);
    size_t chunk_size = 16;
    size_t num_chunks = length / chunk_size;
    if (length % chunk_size != 0) {
        num_chunks++;  // Account for the last partial chunk
    }

    for (ssize_t i = num_chunks - 1; i >= 0; --i) {
        size_t start = i * chunk_size;
        size_t end = start + chunk_size;
        if (end > length) {
            end = length;  // Adjust for the last partial chunk
        }

        putchar('0');
        putchar('x');
        for (size_t j = start; j < end; ++j) {
            putchar(input[j]);
        }

        if (i > 0) {
            putchar(',');
        }
    }
    putchar('\n');
}
/* Compute R^2 mod p, R = r^LIMBS* r = 2^64*/
void compute_R2_mod_N(mpz_t R2_mod_N, const mpz_t N) {
    mpz_t R;
    mpz_init(R);

    // Compute R = 2^(64*LIMBS)
    mpz_ui_pow_ui(R, 2, 64*LIMBS);

    // Compute R^2 mod N
    mpz_powm_ui(R2_mod_N, R, 2, N);

    mpz_clear(R);
}


/* This computes mu = -N^(-1) mod r*/
void find_mu(const uint_custom p) {
    mpz_t r, mp, temp, result;
    mpz_init(result);
    mpz_init(temp);
    init_mpz_from_uint(mp, p);
    mpz_init_set_si(r, 2);
    mpz_pow_ui(r, r, 512);
    gmp_printf("r = %Zx\n", r);
    gmp_printf("p = %Zx\n", mp);
    mpz_neg(mp, mp);
    mpz_invert(result, mp, r);
    gmp_printf("result %Zx\n", result);
    mpz_mul(temp, mp, result);
    mpz_mod(result, temp, r);
    gmp_printf("resultcheck %Zx\n", result);
}

int main() {
    find_mu(p);
    char input[] = "d8c3904b18371bcd3512da337a97b3451232b9eb013dee1eb081b3aba7d05f8534ed3ea7f1de34c4f6fe2bc33e915395fe025ed7d0d3b1aa66c1301f632e294d";
    printf("\nOutput: ");
    print_reversed_chunks(input);
    /*Calculating R^2 mod p*/
    //mpz_t R2_mod_N;
    //mpz_init(R2_mod_N);

    //compute_R2_mod_N(R2_mod_N, N);

    //gmp_printf("R^2 mod N = %Zx\n", R2_mod_N);

    //mpz_clear(R2_mod_N);




    return 0;
}
