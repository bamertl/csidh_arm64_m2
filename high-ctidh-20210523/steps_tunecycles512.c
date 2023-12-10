#include "steps.h"

int steps_guess(long long *bs,long long *gs,long long l)
{
  /* l=3: bs=0 gs=0 bench=4096 baseline=3840 */
  /* l=5: bs=0 gs=0 bench=4096 baseline=4864 */
  /* l=7: bs=0 gs=0 bench=5888 baseline=5888 */
  /* l=11: bs=0 gs=0 bench=8960 baseline=8960 */
  /* l=13: bs=0 gs=0 bench=9984 baseline=11008 */
  /* l=17: bs=0 gs=0 bench=13056 baseline=13056 */
  /* l=19: bs=0 gs=0 bench=14848 baseline=15104 */
  /* l=23: bs=0 gs=0 bench=17152 baseline=18176 */
  /* l=29: bs=0 gs=0 bench=22016 baseline=23040 */
  /* l=31: bs=0 gs=0 bench=23040 baseline=24064 */
  /* l=37: bs=0 gs=0 bench=27904 baseline=28160 */
  /* l=41: bs=0 gs=0 bench=30976 baseline=32000 */
  /* l=43: bs=0 gs=0 bench=32000 baseline=33024 */
  /* l=47: bs=0 gs=0 bench=35072 baseline=36096 */
  /* l=53: bs=0 gs=0 bench=40960 baseline=41216 */
  /* l=59: bs=0 gs=0 bench=45056 baseline=46080 */
  /* l=61: bs=0 gs=0 bench=45056 baseline=47104 */
  /* l=67: bs=0 gs=0 bench=49920 baseline=50944 */
  /* l=71: bs=0 gs=0 bench=55040 baseline=55040 */
  /* l=73: bs=0 gs=0 bench=56064 baseline=56064 */
  /* l=79: bs=0 gs=0 bench=58880 baseline=59904 */
  /* l=83: bs=0 gs=0 bench=64000 baseline=61952 */
  /* l=89: bs=0 gs=0 bench=66048 baseline=66048 */
  if (l <= 89) { *bs = 0; *gs = 0; return 1; }
  /* l=97: bs=6 gs=4 bench=71936 baseline=73984 */
  /* l=101: bs=6 gs=4 bench=72960 baseline=75008 */
  /* l=103: bs=6 gs=4 bench=75776 baseline=77056 */
  /* l=107: bs=6 gs=4 bench=78080 baseline=79104 */
  if (l <= 107) { *bs = 6; *gs = 4; return 1; }
  /* l=109: bs=0 gs=0 bench=80896 baseline=80896 */
  if (l <= 109) { *bs = 0; *gs = 0; return 1; }
  /* l=113: bs=6 gs=4 bench=81920 baseline=83968 */
  if (l <= 113) { *bs = 6; *gs = 4; return 1; }
  /* l=127: bs=6 gs=5 bench=89856 baseline=94208 */
  if (l <= 127) { *bs = 6; *gs = 5; return 1; }
  /* l=131: bs=8 gs=4 bench=90880 baseline=97024 */
  /* l=137: bs=8 gs=4 bench=94976 baseline=101120 */
  /* l=139: bs=8 gs=4 bench=96000 baseline=102912 */
  if (l <= 139) { *bs = 8; *gs = 4; return 1; }
  /* l=149: bs=6 gs=6 bench=102144 baseline=110848 */
  /* l=151: bs=6 gs=6 bench=104960 baseline=112128 */
  /* l=157: bs=6 gs=6 bench=107776 baseline=115968 */
  if (l <= 157) { *bs = 6; *gs = 6; return 1; }
  /* l=163: bs=8 gs=5 bench=104960 baseline=120064 */
  /* l=167: bs=8 gs=5 bench=108032 baseline=123904 */
  /* l=173: bs=8 gs=5 bench=112128 baseline=126976 */
  /* l=179: bs=8 gs=5 bench=115968 baseline=131072 */
  /* l=181: bs=8 gs=5 bench=118016 baseline=132864 */
  /* l=191: bs=8 gs=5 bench=124928 baseline=140032 */
  if (l <= 191) { *bs = 8; *gs = 5; return 1; }
  /* l=193: bs=8 gs=6 bench=119040 baseline=141824 */
  /* l=197: bs=8 gs=6 bench=121088 baseline=144128 */
  /* l=199: bs=8 gs=6 bench=122112 baseline=146944 */
  /* l=211: bs=8 gs=6 bench=131072 baseline=154880 */
  /* l=223: bs=8 gs=6 bench=139008 baseline=163072 */
  if (l <= 223) { *bs = 8; *gs = 6; return 1; }
  /* l=227: bs=8 gs=7 bench=139008 baseline=166144 */
  /* l=229: bs=8 gs=7 bench=140032 baseline=167936 */
  /* l=233: bs=8 gs=7 bench=143104 baseline=169984 */
  /* l=239: bs=8 gs=7 bench=147968 baseline=176128 */
  if (l <= 239) { *bs = 8; *gs = 7; return 1; }
  /* l=241: bs=10 gs=6 bench=143104 baseline=176896 */
  /* l=251: bs=10 gs=6 bench=150016 baseline=185088 */
  if (l <= 251) { *bs = 10; *gs = 6; return 1; }
  /* l=257: bs=8 gs=8 bench=154112 baseline=187904 */
  /* l=263: bs=8 gs=8 bench=157952 baseline=192000 */
  /* l=269: bs=8 gs=8 bench=162048 baseline=196864 */
  if (l <= 269) { *bs = 8; *gs = 8; return 1; }
  /* l=271: bs=10 gs=6 bench=164096 baseline=198912 */
  if (l <= 271) { *bs = 10; *gs = 6; return 1; }
  /* l=277: bs=8 gs=8 bench=168960 baseline=203008 */
  if (l <= 277) { *bs = 8; *gs = 8; return 1; }
  /* l=281: bs=10 gs=7 bench=162048 baseline=206080 */
  /* l=283: bs=10 gs=7 bench=164096 baseline=207104 */
  if (l <= 283) { *bs = 10; *gs = 7; return 1; }
  /* l=293: bs=12 gs=6 bench=169984 baseline=214016 */
  /* l=307: bs=12 gs=6 bench=179200 baseline=225024 */
  /* l=311: bs=12 gs=6 bench=182016 baseline=228096 */
  /* l=313: bs=12 gs=6 bench=183040 baseline=231168 */
  /* l=317: bs=12 gs=6 bench=186112 baseline=231168 */
  if (l <= 317) { *bs = 12; *gs = 6; return 1; }
  /* l=331: bs=10 gs=8 bench=195072 baseline=241920 */
  if (l <= 331) { *bs = 10; *gs = 8; return 1; }
  /* l=337: bs=12 gs=7 bench=192000 baseline=258048 */
  /* l=347: bs=12 gs=7 bench=199168 baseline=261120 */
  /* l=349: bs=12 gs=7 bench=195072 baseline=261120 */
  /* l=353: bs=12 gs=7 bench=197888 baseline=257024 */
  if (l <= 353) { *bs = 12; *gs = 7; return 1; }
  /* l=359: bs=14 gs=6 bench=212992 baseline=262912 */
  if (l <= 359) { *bs = 14; *gs = 6; return 1; }
  /* l=367: bs=10 gs=9 bench=204032 baseline=269056 */
  /* l=373: bs=10 gs=9 bench=206080 baseline=271872 */
  if (l <= 373) { *bs = 10; *gs = 9; return 1; }
  /* l=587: bs=16 gs=9 bench=274944 baseline=425984 */
  if (l <= 587) { *bs = 16; *gs = 9; return 1; }
  return 0;
}
