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


/* This computes mu = -N^(-1) mod r*/
void find_mu(mpz_t mu, mpz_t N_mpz, mpz_t r, unsigned int w) {
    mpz_t y, temp, two_i, two_i_minus_1;
    unsigned long i;

    // Initialize GMP variables
    mpz_init(y);
    mpz_init(temp);
    mpz_init(two_i);
    mpz_init(two_i_minus_1);

    // y ← 1
    mpz_set_ui(y, 1);

    // for i = 2 to w do
    for (i = 2; i <= w; i++) {
        // Compute 2^i and 2^(i-1)
        mpz_ui_pow_ui(two_i, 2, i);
        mpz_ui_pow_ui(two_i_minus_1, 2, i-1);

        // if (N*y mod 2^i) != 1 then
        mpz_mul(temp, N_mpz, y);
        mpz_mod(temp, temp, two_i);
        if (mpz_cmp_ui(temp, 1) != 0) {
            // y ← y + 2^(i−1)
            mpz_add(y, y, two_i_minus_1);
        }
    }

    // μ ← r − y
    mpz_sub(mu, r, y);

    // Clear GMP variables
    mpz_clear(y);
    mpz_clear(temp);
    mpz_clear(two_i);
    mpz_clear(two_i_minus_1);
}

void check_mu(const mpz_t mu, const mpz_t N, mpz_t r) {

    mpz_t neg_one, result, temp, neg_one_mod_r;
    // Initialize GMP variables
    mpz_init(neg_one);
    mpz_init(result);
    mpz_init(temp);
    mpz_init(neg_one_mod_r);


    // Set neg_one = -1
    mpz_set_si(neg_one, -1);


    gmp_printf("%Zx = N\n", N);
    // Compute result = (N * mu) mod r
    mpz_mul(temp, N, mu);
    mpz_mod(result, temp, r);

    mpz_mul(temp, N, mu);
    mpz_mod(temp, temp, r);
    gmp_printf("%Zx = result\n ", temp);
    gmp_printf("%Zx = r\n", r);
    

    mpz_mod(neg_one_mod_r, neg_one, r);
    gmp_printf("%Zx = -1 mod r\n", neg_one_mod_r);

    // Check if result == -1 (mod r)

    // Clear GMP variables
    mpz_clear(neg_one);
    mpz_clear(result);
    mpz_clear(temp);

}

void print_mpz_in_chunks(const mpz_t num) {
    mpz_t temp, mask;
    mpz_init(temp);
    mpz_init_set_str(mask, "FFFFFFFFFFFFFFFF", 16); // Mask to extract lower 64 bits
    
    printf("mu = ");
    for (int i = 0; i < LIMBS; i++) { 
        mpz_tdiv_q_2exp(temp, num, 64 * i); // Shift right by 64*i bits
        mpz_and(temp, temp, mask); // Apply mask to get lower 64 bits
        gmp_printf("%016ZX", temp); // Print in hexadecimal
        if (i > 0) {
            printf(", ");
        }
    }
    printf("\n");

    mpz_clear(temp);
    mpz_clear(mask);
}






void init_mpz_from_uint(mpz_t N, const uint p) {
    mpz_init(N);  // Initialize N to 0
    for (int i = LIMBS-1; i >= 0; i--) {
        mpz_mul_2exp(N, N, 64);  // Shift left by 64 bits
        mpz_add_ui(N, N, p.c[i]); // Add the next 64-bit chunk
    }
}

int main() {
    unsigned int w = 512;
    mpz_t N;
    mpz_t r;
    mpz_init(r);
    // Compute r = 2^w
    mpz_ui_pow_ui(r, 2, w);
    init_mpz_from_uint(N, p);
    gmp_printf("N = %Zx\n", N);
    mpz_t mu;
    // Initialize GMP variables
    mpz_init(mu);
    // Call the function
    find_mu(mu, N,r, w);
    print_mpz_in_chunks(mu);
    // Output the result
    gmp_printf("mu = %Zx\n", mu);
    check_mu(mu, N , r);
   
    // Clear GMP variables
    mpz_clear(mu);

    return 0;
}
