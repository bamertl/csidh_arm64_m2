#include "steps.h"

int steps_guess(long long *bs,long long *gs,long long l)
{
  /* l=3: bs=0 gs=0 bench=73 baseline=93 */
  /* l=5: bs=0 gs=0 bench=88 baseline=87 */
  /* l=7: bs=0 gs=0 bench=118 baseline=120 */
  /* l=11: bs=0 gs=0 bench=176 baseline=182 */
  /* l=13: bs=0 gs=0 bench=204 baseline=210 */
  /* l=17: bs=0 gs=0 bench=262 baseline=268 */
  /* l=19: bs=0 gs=0 bench=291 baseline=301 */
  /* l=23: bs=0 gs=0 bench=350 baseline=364 */
  /* l=29: bs=0 gs=0 bench=436 baseline=449 */
  /* l=31: bs=0 gs=0 bench=466 baseline=483 */
  /* l=37: bs=0 gs=0 bench=552 baseline=564 */
  /* l=41: bs=0 gs=0 bench=612 baseline=622 */
  /* l=43: bs=0 gs=0 bench=641 baseline=656 */
  /* l=47: bs=0 gs=0 bench=697 baseline=719 */
  /* l=53: bs=0 gs=0 bench=784 baseline=800 */
  /* l=59: bs=0 gs=0 bench=873 baseline=890 */
  /* l=61: bs=0 gs=0 bench=900 baseline=919 */
  /* l=67: bs=0 gs=0 bench=1056 baseline=1059 */
  /* l=71: bs=0 gs=0 bench=1060 baseline=1066 */
  /* l=73: bs=0 gs=0 bench=1124 baseline=1119 */
  /* l=79: bs=0 gs=0 bench=1209 baseline=1216 */
  /* l=83: bs=0 gs=0 bench=1271 baseline=1271 */
  /* l=89: bs=0 gs=0 bench=1363 baseline=1357 */
  /* l=97: bs=0 gs=0 bench=1479 baseline=1473 */
  /* l=101: bs=0 gs=0 bench=1538 baseline=1537 */
  if (l <= 101) { *bs = 0; *gs = 0; return 1; }
  /* l=103: bs=6 gs=4 bench=1552 baseline=1571 */
  /* l=107: bs=6 gs=4 bench=1616 baseline=1628 */
  /* l=109: bs=6 gs=4 bench=1630 baseline=1659 */
  /* l=113: bs=6 gs=4 bench=1693 baseline=1713 */
  if (l <= 113) { *bs = 6; *gs = 4; return 1; }
  /* l=127: bs=6 gs=5 bench=1866 baseline=1934 */
  if (l <= 127) { *bs = 6; *gs = 5; return 1; }
  /* l=131: bs=8 gs=4 bench=1891 baseline=1981 */
  /* l=137: bs=8 gs=4 bench=1965 baseline=2068 */
  /* l=139: bs=8 gs=4 bench=1997 baseline=2103 */
  if (l <= 139) { *bs = 8; *gs = 4; return 1; }
  /* l=149: bs=6 gs=6 bench=2132 baseline=2248 */
  /* l=151: bs=6 gs=6 bench=2163 baseline=2286 */
  if (l <= 151) { *bs = 6; *gs = 6; return 1; }
  /* l=157: bs=8 gs=4 bench=2247 baseline=2374 */
  if (l <= 157) { *bs = 8; *gs = 4; return 1; }
  /* l=163: bs=8 gs=5 bench=2196 baseline=2458 */
  /* l=167: bs=8 gs=5 bench=2247 baseline=2521 */
  /* l=173: bs=8 gs=5 bench=2338 baseline=2607 */
  /* l=179: bs=8 gs=5 bench=2410 baseline=2698 */
  /* l=181: bs=8 gs=5 bench=2445 baseline=2727 */
  /* l=191: bs=8 gs=5 bench=2606 baseline=2883 */
  if (l <= 191) { *bs = 8; *gs = 5; return 1; }
  /* l=193: bs=8 gs=6 bench=2477 baseline=2896 */
  /* l=197: bs=8 gs=6 bench=2525 baseline=2961 */
  /* l=199: bs=8 gs=6 bench=2553 baseline=2998 */
  /* l=211: bs=8 gs=6 bench=2721 baseline=3171 */
  /* l=223: bs=8 gs=6 bench=2900 baseline=3357 */
  if (l <= 223) { *bs = 8; *gs = 6; return 1; }
  /* l=227: bs=8 gs=7 bench=2901 baseline=3408 */
  /* l=229: bs=8 gs=7 bench=2931 baseline=3436 */
  /* l=233: bs=8 gs=7 bench=2992 baseline=3497 */
  /* l=239: bs=8 gs=7 bench=3080 baseline=3595 */
  if (l <= 239) { *bs = 8; *gs = 7; return 1; }
  /* l=241: bs=10 gs=6 bench=2956 baseline=3613 */
  /* l=251: bs=10 gs=6 bench=3095 baseline=3771 */
  /* l=257: bs=10 gs=6 bench=3197 baseline=3842 */
  /* l=263: bs=10 gs=6 bench=3270 baseline=3937 */
  /* l=269: bs=10 gs=6 bench=3379 baseline=4028 */
  /* l=271: bs=10 gs=6 bench=3394 baseline=4062 */
  /* l=277: bs=10 gs=6 bench=3488 baseline=4145 */
  if (l <= 277) { *bs = 10; *gs = 6; return 1; }
  /* l=281: bs=10 gs=7 bench=3312 baseline=4206 */
  /* l=283: bs=10 gs=7 bench=3330 baseline=4122 */
  if (l <= 283) { *bs = 10; *gs = 7; return 1; }
  /* l=293: bs=12 gs=6 bench=3437 baseline=4261 */
  /* l=307: bs=12 gs=6 bench=3641 baseline=4469 */
  /* l=311: bs=12 gs=6 bench=3689 baseline=4540 */
  /* l=313: bs=12 gs=6 bench=3709 baseline=4555 */
  /* l=317: bs=12 gs=6 bench=3767 baseline=4616 */
  if (l <= 317) { *bs = 12; *gs = 6; return 1; }
  /* l=331: bs=10 gs=8 bench=3747 baseline=4809 */
  if (l <= 331) { *bs = 10; *gs = 8; return 1; }
  /* l=337: bs=12 gs=7 bench=3798 baseline=4897 */
  /* l=347: bs=12 gs=7 bench=3917 baseline=5050 */
  /* l=349: bs=12 gs=7 bench=3950 baseline=5087 */
  /* l=353: bs=12 gs=7 bench=4015 baseline=5123 */
  /* l=359: bs=12 gs=7 bench=4090 baseline=5223 */
  if (l <= 359) { *bs = 12; *gs = 7; return 1; }
  /* l=367: bs=10 gs=9 bench=4142 baseline=5339 */
  /* l=373: bs=10 gs=9 bench=4177 baseline=5430 */
  if (l <= 373) { *bs = 10; *gs = 9; return 1; }
  /* l=587: bs=16 gs=9 bench=5598 baseline=8497 */
  if (l <= 587) { *bs = 16; *gs = 9; return 1; }
  return 0;
}
