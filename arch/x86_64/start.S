.code16
.text
.global _start

_start:
    cli  // disable the interrupts
    //mov %si, msg
    mov $0x61, %ax //%ax, 0x61 //0x0E
    int $0x10
loop:
    jmp loop
halt:
    hlt

//msg: db "TacOS", 0
