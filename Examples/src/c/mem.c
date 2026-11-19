/* Copying and comparing bytes: the first rung of the scaling ladder (docs/Scaling.md). */

typedef unsigned long u64;
typedef unsigned char u8;

/* Copy n bytes from src to dst. The regions do not overlap. */
void copy_bytes(u8 *dst, const u8 *src, u64 n) {
  for (u64 i = 0; i < n; i++) dst[i] = src[i];
}

/* 1 if the n bytes at a and at b are the same, and 0 otherwise. */
u64 equal_bytes(const u8 *a, const u8 *b, u64 n) {
  for (u64 i = 0; i < n; i++)
    if (a[i] != b[i]) return 0;
  return 1;
}

/* The same as equal_bytes, in a time that depends on n alone: every byte is read whatever
   the bytes are, and no branch depends on them. */
u64 equal_bytes_ct(const u8 *a, const u8 *b, u64 n) {
  u8 d = 0;
  for (u64 i = 0; i < n; i++) d |= a[i] ^ b[i];
  return d == 0;
}
