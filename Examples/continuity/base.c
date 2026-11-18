/* The base program of the continuity experiment: see docs/Continuity.md. */
typedef unsigned long long u64;

u64 clamp(u64 x, u64 lo, u64 hi) {
  if (x < lo) return lo;
  if (x > hi) return hi;
  return x;
}

u64 checksum(const u64 *p, u64 n) {
  u64 s = 0;
  for (u64 i = 0; i < n; i++) {
    s = (s << 5) ^ p[i];
    s += 17;
  }
  return s;
}

u64 poly(u64 x) { return 3 * x * x + 5 * x + 7; }
