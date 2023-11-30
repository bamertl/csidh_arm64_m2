#include "steps.h"

int steps_guess(long long *bs,long long *gs,long long l)
{
  /* l=3: bs=0 gs=0 bench=3072 baseline=3072 */
  /* l=5: bs=0 gs=0 bench=3840 baseline=4096 */
  /* l=7: bs=0 gs=0 bench=4864 baseline=5120 */
  /* l=11: bs=0 gs=0 bench=7168 baseline=7936 */
  /* l=13: bs=0 gs=0 bench=8960 baseline=8960 */
  /* l=17: bs=0 gs=0 bench=12032 baseline=11008 */
  /* l=19: bs=0 gs=0 bench=12800 baseline=13056 */
  /* l=23: bs=0 gs=0 bench=15104 baseline=15872 */
  /* l=29: bs=0 gs=0 bench=18944 baseline=18944 */
  /* l=31: bs=0 gs=0 bench=19968 baseline=20992 */
  /* l=37: bs=0 gs=0 bench=23808 baseline=24064 */
  /* l=41: bs=0 gs=0 bench=26112 baseline=26880 */
  /* l=43: bs=0 gs=0 bench=27904 baseline=28160 */
  /* l=47: bs=0 gs=0 bench=29952 baseline=30976 */
  /* l=53: bs=0 gs=0 bench=34048 baseline=34048 */
  /* l=59: bs=0 gs=0 bench=37120 baseline=38144 */
  /* l=61: bs=0 gs=0 bench=38912 baseline=39168 */
  /* l=67: bs=0 gs=0 bench=44032 baseline=44032 */
  /* l=71: bs=0 gs=0 bench=44032 baseline=44032 */
  /* l=73: bs=0 gs=0 bench=46848 baseline=46848 */
  /* l=79: bs=0 gs=0 bench=50176 baseline=50944 */
  /* l=83: bs=0 gs=0 bench=52992 baseline=52992 */
  /* l=89: bs=0 gs=0 bench=57088 baseline=57088 */
  /* l=97: bs=0 gs=0 bench=61952 baseline=61952 */
  if (l <= 97) { *bs = 0; *gs = 0; return 1; }
  /* l=101: bs=6 gs=4 bench=62208 baseline=64000 */
  if (l <= 101) { *bs = 6; *gs = 4; return 1; }
  /* l=103: bs=0 gs=0 bench=64000 baseline=64000 */
  if (l <= 103) { *bs = 0; *gs = 0; return 1; }
  /* l=107: bs=6 gs=4 bench=66048 baseline=68096 */
  /* l=109: bs=6 gs=4 bench=66048 baseline=67840 */
  /* l=113: bs=6 gs=4 bench=69120 baseline=69888 */
  /* l=127: bs=6 gs=4 bench=76032 baseline=78848 */
  if (l <= 127) { *bs = 6; *gs = 4; return 1; }
  /* l=131: bs=8 gs=4 bench=76032 baseline=80128 */
  /* l=137: bs=8 gs=4 bench=79872 baseline=83968 */
  /* l=139: bs=8 gs=4 bench=81152 baseline=84992 */
  if (l <= 139) { *bs = 8; *gs = 4; return 1; }
  /* l=149: bs=6 gs=6 bench=87040 baseline=91136 */
  /* l=151: bs=6 gs=6 bench=89088 baseline=92928 */
  if (l <= 151) { *bs = 6; *gs = 6; return 1; }
  /* l=157: bs=8 gs=4 bench=93952 baseline=97024 */
  if (l <= 157) { *bs = 8; *gs = 4; return 1; }
  /* l=163: bs=8 gs=5 bench=91136 baseline=102912 */
  /* l=167: bs=8 gs=5 bench=91904 baseline=104960 */
  /* l=173: bs=8 gs=5 bench=98048 baseline=107008 */
  /* l=179: bs=8 gs=5 bench=100864 baseline=112896 */
  /* l=181: bs=8 gs=5 bench=102144 baseline=113920 */
  /* l=191: bs=8 gs=5 bench=108800 baseline=121088 */
  if (l <= 191) { *bs = 8; *gs = 5; return 1; }
  /* l=193: bs=8 gs=6 bench=103936 baseline=121088 */
  /* l=197: bs=8 gs=6 bench=105984 baseline=123136 */
  /* l=199: bs=8 gs=6 bench=107008 baseline=124928 */
  /* l=211: bs=8 gs=6 bench=113152 baseline=132096 */
  /* l=223: bs=8 gs=6 bench=121088 baseline=140032 */
  if (l <= 223) { *bs = 8; *gs = 6; return 1; }
  /* l=227: bs=8 gs=7 bench=121088 baseline=143104 */
  /* l=229: bs=8 gs=7 bench=119040 baseline=143104 */
  /* l=233: bs=8 gs=7 bench=121856 baseline=141824 */
  /* l=239: bs=8 gs=7 bench=125952 baseline=145152 */
  if (l <= 239) { *bs = 8; *gs = 7; return 1; }
  /* l=241: bs=10 gs=6 bench=121088 baseline=146944 */
  /* l=251: bs=10 gs=6 bench=128000 baseline=153088 */
  /* l=257: bs=10 gs=6 bench=130048 baseline=156160 */
  /* l=263: bs=10 gs=6 bench=133120 baseline=160000 */
  if (l <= 263) { *bs = 10; *gs = 6; return 1; }
  /* l=269: bs=8 gs=8 bench=141056 baseline=163072 */
  if (l <= 269) { *bs = 8; *gs = 8; return 1; }
  /* l=271: bs=10 gs=6 bench=142080 baseline=169216 */
  if (l <= 271) { *bs = 10; *gs = 6; return 1; }
  /* l=277: bs=8 gs=8 bench=145920 baseline=174080 */
  if (l <= 277) { *bs = 8; *gs = 8; return 1; }
  /* l=281: bs=10 gs=7 bench=141056 baseline=175872 */
  /* l=283: bs=10 gs=7 bench=137216 baseline=177920 */
  if (l <= 283) { *bs = 10; *gs = 7; return 1; }
  /* l=293: bs=12 gs=6 bench=143104 baseline=177920 */
  if (l <= 293) { *bs = 12; *gs = 6; return 1; }
  /* l=307: bs=10 gs=7 bench=155904 baseline=186880 */
  /* l=311: bs=10 gs=7 bench=157952 baseline=194048 */
  if (l <= 311) { *bs = 10; *gs = 7; return 1; }
  /* l=313: bs=12 gs=6 bench=158208 baseline=195840 */
  /* l=317: bs=12 gs=6 bench=161024 baseline=198144 */
  if (l <= 317) { *bs = 12; *gs = 6; return 1; }
  /* l=331: bs=10 gs=8 bench=160000 baseline=206848 */
  if (l <= 331) { *bs = 10; *gs = 8; return 1; }
  /* l=337: bs=12 gs=7 bench=162048 baseline=209920 */
  /* l=347: bs=12 gs=7 bench=169984 baseline=217088 */
  /* l=349: bs=12 gs=7 bench=168960 baseline=218112 */
  /* l=353: bs=12 gs=7 bench=171008 baseline=219904 */
  /* l=359: bs=12 gs=7 bench=180992 baseline=224000 */
  if (l <= 359) { *bs = 12; *gs = 7; return 1; }
  /* l=367: bs=10 gs=9 bench=172800 baseline=221952 */
  /* l=373: bs=10 gs=9 bench=174848 baseline=226048 */
  if (l <= 373) { *bs = 10; *gs = 9; return 1; }
  /* l=587: bs=16 gs=9 bench=233984 baseline=354048 */
  if (l <= 587) { *bs = 16; *gs = 9; return 1; }
  return 0;
}
