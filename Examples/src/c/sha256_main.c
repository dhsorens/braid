/* A whole program: SHA-256 of a message in the data section, written out, then exit.
   It pads the message block by block, calls the compression function of sha256.c for each
   block, writes the 32 bytes of the digest out, and exits with code 0. There is no library
   and no loader beneath it: `_start` sets the stack pointer to a stack in `.bss`. */

typedef unsigned char u8;
typedef unsigned int u32;
typedef unsigned long u64;

void sha256_compress(u32 *h, const u32 *m);

/* The stack: the program's own, so that "the binary is loaded" says where it is. */
__attribute__((aligned(16))) u8 stack[2048];

/* The message and its length are in sha256_msg.c, so that the code here is compiled for a
   message it does not know. */
extern const u64 msg_len;
extern const u8 msg[];

#if defined(__riscv)
/* The host interface of the pinned model (a zkVM's): `t0 = 0x10` writes `a1` bytes at `a0`
   to the public output, and `t0 = 0` halts with the code in `a0`. */
__asm__(".globl _start\n.balign 4\n.type _start, %function\n_start:\n"
        "  lui sp, %hi(stack + 2048)\n  addi sp, sp, %lo(stack + 2048)\n  j main\n"
        ".size _start, . - _start\n");
static inline void sys_write(const u8 *p, u64 n) {
  register u64 a0 __asm__("a0") = (u64)p;
  register u64 a1 __asm__("a1") = n;
  register u64 t0 __asm__("t0") = 0x10;
  __asm__ volatile("ecall" : : "r"(a0), "r"(a1), "r"(t0) : "memory");
}
static inline void sys_exit(u64 code) {
  register u64 a0 __asm__("a0") = code;
  register u64 t0 __asm__("t0") = 0;
  __asm__ volatile("ecall" : : "r"(a0), "r"(t0));
  __builtin_unreachable();
}
#elif defined(__aarch64__)
/* Linux: `x8 = 64` is write(fd, buf, n) and `x8 = 93` is exit(code). */
__asm__(".globl _start\n_start:\n  adrp x9, stack + 2048\n  add x9, x9, :lo12:stack + 2048\n"
        "  mov sp, x9\n  b main\n");
static inline void sys_write(const u8 *p, u64 n) {
  register u64 x0 __asm__("x0") = 1;
  register u64 x1 __asm__("x1") = (u64)p;
  register u64 x2 __asm__("x2") = n;
  register u64 x8 __asm__("x8") = 64;
  __asm__ volatile("svc #0" : "+r"(x0) : "r"(x1), "r"(x2), "r"(x8) : "memory");
}
static inline void sys_exit(u64 code) {
  register u64 x0 __asm__("x0") = code;
  register u64 x8 __asm__("x8") = 93;
  __asm__ volatile("svc #0" : : "r"(x0), "r"(x8));
  __builtin_unreachable();
}
#else
/* x86-64: the pinned model has no system call, so the program ends in a loop with the
   digest in `digest` (docs/ISA.md). */
__asm__(".globl _start\n_start:\n  lea rsp, [rip + stack + 2048]\n  jmp main\n");
u8 digest[32];
static inline void sys_write(const u8 *p, u64 n) {
  for (u64 i = 0; i < n; i++) digest[i] = p[i];
}
static inline void sys_exit(u64 code) {
  (void)code;
  for (;;) {}
}
#endif

void main(void) {
  u32 h[8];
  u32 m[16];
  u8 out[32];
  u64 n = msg_len;
  u64 total = ((n + 8) / 64 + 1) * 64;
  h[0] = 0x6a09e667; h[1] = 0xbb67ae85; h[2] = 0x3c6ef372; h[3] = 0xa54ff53a;
  h[4] = 0x510e527f; h[5] = 0x9b05688c; h[6] = 0x1f83d9ab; h[7] = 0x5be0cd19;
  for (u64 off = 0; off < total; off += 64) {
    for (u64 j = 0; j < 16; j++) {
      u32 w = 0;
      for (u64 i = 0; i < 4; i++) {
        u64 k = off + 4 * j + i;
        u32 b;
        if (k < n) b = msg[k];
        else if (k == n) b = 0x80;
        else if (k >= total - 8) b = (u8)((n * 8) >> (8 * (total - 1 - k)));
        else b = 0;
        w = (w << 8) | b;
      }
      m[j] = w;
    }
    sha256_compress(h, m);
  }
  for (u64 i = 0; i < 8; i++) {
    out[4 * i] = (u8)(h[i] >> 24);
    out[4 * i + 1] = (u8)(h[i] >> 16);
    out[4 * i + 2] = (u8)(h[i] >> 8);
    out[4 * i + 3] = (u8)h[i];
  }
  sys_write(out, 32);
  sys_exit(0);
}
