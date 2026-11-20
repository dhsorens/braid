/* ChaCha20 (RFC 8439), vectorised: the block function over four rows of four 32-bit lanes.
   The state is a 4 by 4 matrix of words; a row is one vector, a column round is four quarter
   rounds at once, and a diagonal round is a column round between two rotations of the rows.
   Written with the compilers' vector types and no intrinsics, so that one source serves
   every instruction set (docs/Leakage.md). */

typedef unsigned int u32;
typedef u32 row __attribute__((vector_size(16)));
/* A row in memory, at any address a word may have. */
typedef u32 urow __attribute__((vector_size(16), aligned(4), may_alias));

#define ROTL(x, n) (((x) << (n)) | ((x) >> (32 - (n))))
/* Four quarter rounds, one in each lane. */
#define QR4(a, b, c, d)                                                        \
  a += b; d ^= a; d = ROTL(d, 16);                                             \
  c += d; b ^= c; b = ROTL(b, 12);                                             \
  a += b; d ^= a; d = ROTL(d, 8);                                              \
  c += d; b ^= c; b = ROTL(b, 7)
/* A row with its lanes rotated left by one, two and three places. */
#define LANES1(x) __builtin_shufflevector(x, x, 1, 2, 3, 0)
#define LANES2(x) __builtin_shufflevector(x, x, 2, 3, 0, 1)
#define LANES3(x) __builtin_shufflevector(x, x, 3, 0, 1, 2)

/* The block function: out = the state after twenty rounds, plus the state. */
void chacha20_block_vec(u32 *out, const u32 *in) {
  const urow *s = (const urow *)in;
  urow *o = (urow *)out;
  row a = s[0], b = s[1], c = s[2], d = s[3];
  for (int i = 0; i < 10; i++) {
    QR4(a, b, c, d);
    b = LANES1(b); c = LANES2(c); d = LANES3(d);
    QR4(a, b, c, d);
    b = LANES3(b); c = LANES2(c); d = LANES1(d);
  }
  o[0] = a + s[0]; o[1] = b + s[1]; o[2] = c + s[2]; o[3] = d + s[3];
}
