/* This header can be read by both C and C++ compilers */
#ifndef BENCHMARK_H
#define BENCHMARK_H

#ifndef PARAMS_H
#include "params.h"  // Include params.h if not yet included somewhere
#endif

#ifndef CSIDH_H
#include "csidh.h"  // Include csidh.h if not yet included somewhere
#endif

extern void measure_csidh_private(void (*function)(private_key *priv), private_key *priv);
extern void measure_csidh(bool (*function)(public_key *out, public_key const *in, private_key const *priv), public_key *out, public_key const *in, private_key const *priv);
#endif /*BENCHMARK_H*/
