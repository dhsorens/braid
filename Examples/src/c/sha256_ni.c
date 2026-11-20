/* SHA-256 (FIPS 180-4) with the processor's SHA-2 instructions: the compression function of
   sha256.c once more, on the Arm SHA-2 instructions and on the x86-64 SHA instructions, from
   the compilers' intrinsics. As in sha256.c the block is sixteen words, and no byte is
   swapped. Four rounds are one step of a loop: twelve steps that also extend the schedule
   by four words, and four that do not (docs/ISA.md). */

typedef unsigned int u32;

static const u32 K[64] __attribute__((aligned(16))) = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2};

#if defined(__aarch64__)
#include <arm_neon.h>

/* The compression function: update the hash value h[0..7] with the block m[0..15] (words). */
void sha256_compress_ni(u32 *h, const u32 *m) {
  uint32x4_t abcd = vld1q_u32(h), efgh = vld1q_u32(h + 4);
  uint32x4_t w0 = vld1q_u32(m), w1 = vld1q_u32(m + 4);
  uint32x4_t w2 = vld1q_u32(m + 8), w3 = vld1q_u32(m + 12);
  uint32x4_t a = abcd, e = efgh;
  for (int i = 0; i < 12; i++) {
    uint32x4_t wk = vaddq_u32(w0, vld1q_u32(K + 4 * i));
    uint32x4_t t = a;
    a = vsha256hq_u32(a, e, wk);
    e = vsha256h2q_u32(e, t, wk);
    uint32x4_t n = vsha256su1q_u32(vsha256su0q_u32(w0, w1), w2, w3);
    w0 = w1; w1 = w2; w2 = w3; w3 = n;
  }
  for (int i = 12; i < 16; i++) {
    uint32x4_t wk = vaddq_u32(w0, vld1q_u32(K + 4 * i));
    uint32x4_t t = a;
    a = vsha256hq_u32(a, e, wk);
    e = vsha256h2q_u32(e, t, wk);
    w0 = w1; w1 = w2; w2 = w3;
  }
  vst1q_u32(h, vaddq_u32(abcd, a));
  vst1q_u32(h + 4, vaddq_u32(efgh, e));
}

#elif defined(__x86_64__)
#include <immintrin.h>

/* The compression function: update the hash value h[0..7] with the block m[0..15] (words).
   The instructions hold the working variables as two vectors, (a, b, e, f) and (c, d, g, h),
   with the first variable in the highest lane. */
void sha256_compress_ni(u32 *h, const u32 *m) {
  __m128i t = _mm_loadu_si128((const __m128i *)h);
  __m128i s1 = _mm_loadu_si128((const __m128i *)(h + 4));
  t = _mm_shuffle_epi32(t, 0xB1);
  s1 = _mm_shuffle_epi32(s1, 0x1B);
  __m128i s0 = _mm_alignr_epi8(t, s1, 8);
  s1 = _mm_blend_epi16(s1, t, 0xF0);
  __m128i abef = s0, cdgh = s1;
  __m128i w0 = _mm_loadu_si128((const __m128i *)m);
  __m128i w1 = _mm_loadu_si128((const __m128i *)(m + 4));
  __m128i w2 = _mm_loadu_si128((const __m128i *)(m + 8));
  __m128i w3 = _mm_loadu_si128((const __m128i *)(m + 12));
  for (int i = 0; i < 12; i++) {
    __m128i wk = _mm_add_epi32(w0, _mm_load_si128((const __m128i *)(K + 4 * i)));
    s1 = _mm_sha256rnds2_epu32(s1, s0, wk);
    wk = _mm_shuffle_epi32(wk, 0x0E);
    s0 = _mm_sha256rnds2_epu32(s0, s1, wk);
    __m128i n = _mm_sha256msg1_epu32(w0, w1);
    n = _mm_add_epi32(n, _mm_alignr_epi8(w3, w2, 4));
    n = _mm_sha256msg2_epu32(n, w3);
    w0 = w1; w1 = w2; w2 = w3; w3 = n;
  }
  for (int i = 12; i < 16; i++) {
    __m128i wk = _mm_add_epi32(w0, _mm_load_si128((const __m128i *)(K + 4 * i)));
    s1 = _mm_sha256rnds2_epu32(s1, s0, wk);
    wk = _mm_shuffle_epi32(wk, 0x0E);
    s0 = _mm_sha256rnds2_epu32(s0, s1, wk);
    w0 = w1; w1 = w2; w2 = w3;
  }
  s0 = _mm_add_epi32(s0, abef);
  s1 = _mm_add_epi32(s1, cdgh);
  t = _mm_shuffle_epi32(s0, 0x1B);
  s1 = _mm_shuffle_epi32(s1, 0xB1);
  s0 = _mm_blend_epi16(t, s1, 0xF0);
  s1 = _mm_alignr_epi8(s1, t, 8);
  _mm_storeu_si128((__m128i *)h, s0);
  _mm_storeu_si128((__m128i *)(h + 4), s1);
}
#endif
