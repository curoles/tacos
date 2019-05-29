/*
 * qemu-system-tachy -machine virt -nographic -serial mon:stdio -kernel prg.elf
 */

.text
.align  4
.global _start


_start:
    jsr uart_print_banner
    nop
    nop
    nop
    --
    nop
    nop
    nop
    nop
	--
    jsr _startOS
    --
    nop
    --
	jmp .

#include "hw/tachy/qemu_virt/defines.h"

#define ASCII_T 0x54
#define ASCII_a 0x61
#define ASCII_c 0x63
#define ASCII_O 0x4f
#define ASCII_S 0x53
#define ASCII_LF 0xa

uart_print_banner:
	li r1, `UART_ADDR
	--
	li  r2, ASCII_T
	stl r2,r1,0
	--
	li  r2, ASCII_a
	stl r2,r1,0
	--
	li  r2, ASCII_c
	stl r2,r1,0
	--
	li  r2, ASCII_O
	stl r2,r1,0
	--
	li  r2, ASCII_S
	stl r2,r1,0
    --
    li  r2, ASCII_LF
	stl r2,r1,0
    --
    ret

