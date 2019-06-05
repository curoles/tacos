.file "start32.S"

.code32
.text
.global _start_in_protected_mode

_start_in_protected_mode:
    jmp .
    hlt
