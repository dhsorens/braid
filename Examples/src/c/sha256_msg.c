/* The message of sha256_main.c and its length, each in a section of its own, the message
   last in the binary. */

typedef unsigned char u8;
typedef unsigned long u64;

__attribute__((section(".msglen"))) const u64 msg_len = 3;
__attribute__((section(".msg"))) const u8 msg[3] = {'a', 'b', 'c'};
