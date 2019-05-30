.code16
.text
.global _start

.extern bios_putc

_start:
    cli  // disable the interrupts
    mov $0x61, %al
    callw bios_putc
loop:
    jmp loop
halt:
    hlt

message:
    .asciz "TacOS" // asciz puts a 0 byte at the end
