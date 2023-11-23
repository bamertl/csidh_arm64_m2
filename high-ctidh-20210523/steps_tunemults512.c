#include "steps.h"

int steps_guess(long long *bs,long long *gs,long long l)
{
  /* l=3: bs=0 gs=0 bench=30 baseline=28 */
  /* l=5: bs=0 gs=0 bench=36 baseline=36 */
  /* l=7: bs=0 gs=0 bench=48 baseline=50 */
  /* l=11: bs=0 gs=0 bench=72 baseline=76 */
  /* l=13: bs=0 gs=0 bench=84 baseline=88 */
  /* l=17: bs=0 gs=0 bench=108 baseline=112 */
  /* l=19: bs=0 gs=0 bench=120 baseline=126 */
  /* l=23: bs=0 gs=0 bench=144 baseline=152 */
  /* l=29: bs=0 gs=0 bench=180 baseline=188 */
  /* l=31: bs=0 gs=0 bench=192 baseline=202 */
  /* l=37: bs=0 gs=0 bench=228 baseline=236 */
  /* l=41: bs=0 gs=0 bench=252 baseline=260 */
  /* l=43: bs=0 gs=0 bench=264 baseline=274 */
  /* l=47: bs=0 gs=0 bench=288 baseline=300 */
  /* l=53: bs=0 gs=0 bench=324 baseline=334 */
  /* l=59: bs=0 gs=0 bench=360 baseline=372 */
  /* l=61: bs=0 gs=0 bench=372 baseline=384 */
  /* l=67: bs=0 gs=0 bench=414 baseline=418 */
  /* l=71: bs=0 gs=0 bench=438 baseline=444 */
  /* l=73: bs=0 gs=0 bench=450 baseline=454 */
  /* l=79: bs=0 gs=0 bench=486 baseline=494 */
  /* l=83: bs=0 gs=0 bench=510 baseline=516 */
  /* l=89: bs=0 gs=0 bench=546 baseline=552 */
  if (l <= 89) { *bs = 0; *gs = 0; return 1; }
  /* l=97: bs=6 gs=4 bench=559 baseline=598 */
  /* l=101: bs=6 gs=4 bench=577 baseline=624 */
  /* l=103: bs=6 gs=4 bench=589 baseline=638 */
  /* l=107: bs=6 gs=4 bench=613 baseline=662 */
  /* l=109: bs=6 gs=4 bench=619 baseline=674 */
  /* l=113: bs=6 gs=4 bench=643 baseline=696 */
  if (l <= 113) { *bs = 6; *gs = 4; return 1; }
  /* l=127: bs=6 gs=5 bench=698 baseline=786 */
  if (l <= 127) { *bs = 6; *gs = 5; return 1; }
  /* l=131: bs=8 gs=4 bench=710 baseline=804 */
  /* l=137: bs=8 gs=4 bench=746 baseline=840 */
  /* l=139: bs=8 gs=4 bench=758 baseline=854 */
  if (l <= 139) { *bs = 8; *gs = 4; return 1; }
  /* l=149: bs=6 gs=6 bench=785 baseline=914 */
  /* l=151: bs=6 gs=6 bench=797 baseline=928 */
  /* l=157: bs=6 gs=6 bench=827 baseline=964 */
  if (l <= 157) { *bs = 6; *gs = 6; return 1; }
  /* l=163: bs=8 gs=5 bench=821 baseline=998 */
  /* l=167: bs=8 gs=5 bench=845 baseline=1024 */
  /* l=173: bs=8 gs=5 bench=881 baseline=1060 */
  /* l=179: bs=8 gs=5 bench=911 baseline=1096 */
  /* l=181: bs=8 gs=5 bench=923 baseline=1108 */
  /* l=191: bs=8 gs=5 bench=983 baseline=1172 */
  if (l <= 191) { *bs = 8; *gs = 5; return 1; }
  /* l=193: bs=8 gs=6 bench=916 baseline=1176 */
  /* l=197: bs=8 gs=6 bench=934 baseline=1202 */
  /* l=199: bs=8 gs=6 bench=946 baseline=1216 */
  /* l=211: bs=8 gs=6 bench=1012 baseline=1288 */
  /* l=223: bs=8 gs=6 bench=1084 baseline=1364 */
  if (l <= 223) { *bs = 8; *gs = 6; return 1; }
  /* l=227: bs=8 gs=7 bench=1073 baseline=1384 */
  /* l=229: bs=8 gs=7 bench=1085 baseline=1396 */
  /* l=233: bs=8 gs=7 bench=1109 baseline=1420 */
  /* l=239: bs=8 gs=7 bench=1145 baseline=1460 */
  if (l <= 239) { *bs = 8; *gs = 7; return 1; }
  /* l=241: bs=10 gs=6 bench=1103 baseline=1468 */
  /* l=251: bs=10 gs=6 bench=1157 baseline=1532 */
  if (l <= 251) { *bs = 10; *gs = 6; return 1; }
  /* l=257: bs=8 gs=8 bench=1186 baseline=1560 */
  /* l=263: bs=8 gs=8 bench=1216 baseline=1600 */
  /* l=269: bs=8 gs=8 bench=1252 baseline=1636 */
  /* l=271: bs=8 gs=8 bench=1264 baseline=1650 */
  /* l=277: bs=8 gs=8 bench=1294 baseline=1684 */
  if (l <= 277) { *bs = 8; *gs = 8; return 1; }
  /* l=281: bs=10 gs=7 bench=1260 baseline=1708 */
  /* l=283: bs=10 gs=7 bench=1266 baseline=1722 */
  if (l <= 283) { *bs = 10; *gs = 7; return 1; }
  /* l=293: bs=12 gs=6 bench=1311 baseline=1780 */
  /* l=307: bs=12 gs=6 bench=1395 baseline=1866 */
  /* l=311: bs=12 gs=6 bench=1419 baseline=1892 */
  /* l=313: bs=12 gs=6 bench=1425 baseline=1902 */
  /* l=317: bs=12 gs=6 bench=1449 baseline=1928 */
  if (l <= 317) { *bs = 12; *gs = 6; return 1; }
  /* l=331: bs=10 gs=8 bench=1427 baseline=2010 */
  if (l <= 331) { *bs = 10; *gs = 8; return 1; }
  /* l=337: bs=14 gs=6 bench=1434 baseline=2044 */
  /* l=347: bs=14 gs=6 bench=1488 baseline=2108 */
  /* l=349: bs=14 gs=6 bench=1500 baseline=2120 */
  /* l=353: bs=14 gs=6 bench=1524 baseline=2140 */
  /* l=359: bs=14 gs=6 bench=1560 baseline=2180 */
  if (l <= 359) { *bs = 14; *gs = 6; return 1; }
  /* l=367: bs=10 gs=9 bench=1556 baseline=2230 */
  /* l=373: bs=10 gs=9 bench=1592 baseline=2264 */
  if (l <= 373) { *bs = 10; *gs = 9; return 1; }
  /* l=587: bs=14 gs=10 bench=2108 baseline=3548 */
  if (l <= 587) { *bs = 14; *gs = 10; return 1; }
  return 0;
}
