#include "steps.h"

int steps_guess(long long *bs,long long *gs,long long l)
{
  /* l=3: bs=0 gs=0 bench=3072 baseline=4096 */
  /* l=5: bs=0 gs=0 bench=3840 baseline=3840 */
  /* l=7: bs=0 gs=0 bench=4864 baseline=5120 */
  /* l=11: bs=0 gs=0 bench=7168 baseline=7936 */
  /* l=13: bs=0 gs=0 bench=8960 baseline=8960 */
  /* l=17: bs=0 gs=0 bench=11008 baseline=11008 */
  /* l=19: bs=0 gs=0 bench=12032 baseline=12800 */
  /* l=23: bs=0 gs=0 bench=14848 baseline=15104 */
  /* l=29: bs=0 gs=0 bench=17920 baseline=18944 */
  /* l=31: bs=0 gs=0 bench=20992 baseline=19968 */
  /* l=37: bs=0 gs=0 bench=23040 baseline=23808 */
  /* l=41: bs=0 gs=0 bench=25856 baseline=26112 */
  /* l=43: bs=0 gs=0 bench=26880 baseline=27136 */
  /* l=47: bs=0 gs=0 bench=28928 baseline=29952 */
  /* l=53: bs=0 gs=0 bench=33024 baseline=33024 */
  /* l=59: bs=0 gs=0 bench=36096 baseline=37120 */
  /* l=61: bs=0 gs=0 bench=37888 baseline=38144 */
  /* l=67: bs=0 gs=0 bench=41984 baseline=41984 */
  /* l=71: bs=0 gs=0 bench=44032 baseline=44032 */
  /* l=73: bs=0 gs=0 bench=45056 baseline=45056 */
  /* l=79: bs=0 gs=0 bench=48896 baseline=48896 */
  /* l=83: bs=0 gs=0 bench=51200 baseline=50944 */
  /* l=89: bs=0 gs=0 bench=55040 baseline=55040 */
  /* l=97: bs=0 gs=0 bench=59904 baseline=59904 */
  /* l=101: bs=0 gs=0 bench=61952 baseline=61952 */
  if (l <= 101) { *bs = 0; *gs = 0; return 1; }
  /* l=103: bs=6 gs=4 bench=62976 baseline=64000 */
  /* l=107: bs=6 gs=4 bench=65792 baseline=66048 */
  /* l=109: bs=6 gs=4 bench=66048 baseline=67072 */
  /* l=113: bs=6 gs=4 bench=69120 baseline=69120 */
  if (l <= 113) { *bs = 6; *gs = 4; return 1; }
  /* l=127: bs=6 gs=5 bench=75008 baseline=78080 */
  if (l <= 127) { *bs = 6; *gs = 5; return 1; }
  /* l=131: bs=8 gs=4 bench=76800 baseline=79872 */
  /* l=137: bs=8 gs=4 bench=79872 baseline=83968 */
  /* l=139: bs=8 gs=4 bench=80896 baseline=84992 */
  if (l <= 139) { *bs = 8; *gs = 4; return 1; }
  /* l=149: bs=6 gs=6 bench=86016 baseline=90880 */
  /* l=151: bs=6 gs=6 bench=88832 baseline=92160 */
  /* l=157: bs=6 gs=6 bench=90880 baseline=96000 */
  if (l <= 157) { *bs = 6; *gs = 6; return 1; }
  /* l=163: bs=8 gs=5 bench=89088 baseline=99072 */
  /* l=167: bs=8 gs=5 bench=90880 baseline=102912 */
  /* l=173: bs=8 gs=5 bench=94976 baseline=105216 */
  /* l=179: bs=8 gs=5 bench=98048 baseline=109056 */
  /* l=181: bs=8 gs=5 bench=99072 baseline=111104 */
  /* l=191: bs=8 gs=5 bench=104960 baseline=115968 */
  if (l <= 191) { *bs = 8; *gs = 5; return 1; }
  /* l=193: bs=8 gs=6 bench=100096 baseline=116992 */
  /* l=197: bs=8 gs=6 bench=102144 baseline=119040 */
  /* l=199: bs=8 gs=6 bench=103168 baseline=121088 */
  /* l=211: bs=8 gs=6 bench=110848 baseline=128000 */
  /* l=223: bs=8 gs=6 bench=118016 baseline=135168 */
  if (l <= 223) { *bs = 8; *gs = 6; return 1; }
  /* l=227: bs=8 gs=7 bench=120832 baseline=139008 */
  /* l=229: bs=8 gs=7 bench=122112 baseline=140032 */
  /* l=233: bs=8 gs=7 bench=124160 baseline=145152 */
  /* l=239: bs=8 gs=7 bench=128768 baseline=145920 */
  if (l <= 239) { *bs = 8; *gs = 7; return 1; }
  /* l=241: bs=10 gs=6 bench=124160 baseline=151040 */
  /* l=251: bs=10 gs=6 bench=131072 baseline=157952 */
  /* l=257: bs=10 gs=6 bench=130048 baseline=160000 */
  /* l=263: bs=10 gs=6 bench=136960 baseline=164096 */
  if (l <= 263) { *bs = 10; *gs = 6; return 1; }
  /* l=269: bs=8 gs=8 bench=137984 baseline=168960 */
  if (l <= 269) { *bs = 8; *gs = 8; return 1; }
  /* l=271: bs=10 gs=6 bench=142080 baseline=168960 */
  if (l <= 271) { *bs = 10; *gs = 6; return 1; }
  /* l=277: bs=8 gs=8 bench=145920 baseline=172032 */
  if (l <= 277) { *bs = 8; *gs = 8; return 1; }
  /* l=281: bs=10 gs=7 bench=141056 baseline=174080 */
  /* l=283: bs=10 gs=7 bench=141056 baseline=176128 */
  if (l <= 283) { *bs = 10; *gs = 7; return 1; }
  /* l=293: bs=12 gs=6 bench=146944 baseline=183040 */
  /* l=307: bs=12 gs=6 bench=155904 baseline=192000 */
  /* l=311: bs=12 gs=6 bench=157952 baseline=194048 */
  /* l=313: bs=12 gs=6 bench=158976 baseline=195072 */
  /* l=317: bs=12 gs=6 bench=161024 baseline=197120 */
  if (l <= 317) { *bs = 12; *gs = 6; return 1; }
  /* l=331: bs=10 gs=8 bench=155904 baseline=206080 */
  if (l <= 331) { *bs = 10; *gs = 8; return 1; }
  /* l=337: bs=12 gs=7 bench=156928 baseline=203008 */
  /* l=347: bs=12 gs=7 bench=162048 baseline=209152 */
  /* l=349: bs=12 gs=7 bench=163072 baseline=210944 */
  /* l=353: bs=12 gs=7 bench=165888 baseline=211968 */
  /* l=359: bs=12 gs=7 bench=179968 baseline=216064 */
  if (l <= 359) { *bs = 12; *gs = 7; return 1; }
  /* l=367: bs=10 gs=9 bench=171008 baseline=220928 */
  /* l=373: bs=10 gs=9 bench=173056 baseline=225024 */
  if (l <= 373) { *bs = 10; *gs = 9; return 1; }
  /* l=587: bs=16 gs=9 bench=232192 baseline=352000 */
  if (l <= 587) { *bs = 16; *gs = 9; return 1; }
  return 0;
}
