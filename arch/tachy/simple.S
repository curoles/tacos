# qemu-system-tachy -machine virt -nographic -serial mon:stdio -kernel ${PRG_NAME}.${PRG_SFX}")

        .text
        .align  4
        .global _start

_start:
	#li r1, `0x10000000 /* UART */
	#--
	#li  r2, 0x48
	/*st  r2,r1,0
	--
	li  r2, 0x65
	st  r2,r1,0
	--
	li  r2, 0x6c
	st  r2,r1,0
	--
	li  r2, 0x6c
	st  r2,r1,0
	--
	li  r2, 0x6f
	st  r2,r1,0*/
	--
	jmp .

