//https://farid.hajji.org/en/blog/46-hello-world-on-the-bare-metal
.code16
.text

/* putc(%al) -- output char %al via BIOS call int 10h, func 0Eh.
 *
 * putc(%al) displays the byte %al on the default video
 * buffer, using the BIOS function "TELETYPE OUTPUT".
 * This function interprets some but not all control
 * characters correctly.
 * This BIOS function is
 * only available in real mode.
 *
 */
.global bios_putc
bios_putc:
    movw  $0x7, %bx            # BH: page 0, BL: attribute 7 (normal white)
    movb  $0xe, %ah            # BIOS function "TELETYPE OUTPUT"
    int   $0x10                # call BIOS
    retw
