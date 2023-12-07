#include "performancecounters/event_counter.h"
#include <algorithm>
#include <charconv>
#include <chrono>
#include <climits>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctype.h>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <locale.h>
#include <random>
#include <sstream>
#include <stdio.h>
#include <vector>
#include "benchmark.h"

event_collector collector;

// void csidh_private(private_key *priv);
// bool csidh(public_key *out, public_key const *in, private_key const *priv);

template <class T>
event_aggregate time_it_ns_csidh_private(T const &function, private_key *priv, size_t repeat)
{
  event_aggregate aggregate{};

  // warm up the cache:
  for (size_t i = 0; i < 10; i++)
  {
    function(priv);
  }
  for (size_t i = 0; i < repeat; i++)
  {
    collector.start();
    function(priv);
    event_count allocate_count = collector.end();
    aggregate << allocate_count;
  }
  return aggregate;
}

template <class T>
event_aggregate time_it_ns_csidh(T const &function, public_key *out, public_key const *in, private_key const *priv, size_t repeat)
{
  event_aggregate aggregate{};

  // warm up the cache:
  for (size_t i = 0; i < 10; i++)
  {
    bool result = function(out, in, priv);
    if (!result)
    {
      printf("bug\n");
    }
  }
  for (size_t i = 0; i < repeat; i++)
  {
    collector.start();
    bool result = function(out, in, priv);
    event_count allocate_count = collector.end();
    if (!result)
    {
      printf("bug\n");
    }
    aggregate << allocate_count;
  }
  return aggregate;
}

void pretty_print(
    std::string name,
    event_aggregate aggregate)
{
  printf("%s", name.c_str());
  printf("\n");
  printf(" %8.2f ns ", aggregate.elapsed_ns());
  printf("\n");
  printf("fastest %8.2f ns ", aggregate.best.elapsed_ns());
  printf("\n");
  printf(" %8.2f ms ", aggregate.elapsed_ns() / 1000000);
  printf("\n");
  printf("fastest %8.2f ms ", aggregate.best.elapsed_ns() / 1000000);
  printf("\n");
  printf(" %8.2f instructions ", aggregate.best.instructions());
  printf("\n");

  printf(" %8.2f cycles ", aggregate.best.cycles());
  printf("\n");

  printf(" %8.2f instructions/cycles ",
         aggregate.best.instructions() / aggregate.best.cycles());
}

template <class T>
void process_csidh_private(T const &function, private_key *priv, size_t repeat)
{
  pretty_print("csidh_private",
               time_it_ns_csidh_private(function, priv, repeat));
}

template <class T>
void process_csidh(T const &function, public_key *out, public_key const *in, private_key const *priv, size_t repeat)
{
  pretty_print("csidh",
               time_it_ns_csidh(function, out, in, priv, repeat));
}

extern "C" void measure_csidh_private(void (*function)(private_key *priv), private_key *priv)
{
  return process_csidh_private(function, priv, 1000);
}

extern "C" void measure_csidh(bool (*function)(public_key *out, public_key const *in, private_key const *priv), public_key *out, public_key const *in, private_key const *priv)
{
  return process_csidh(function, out, in, priv, 1000);
}