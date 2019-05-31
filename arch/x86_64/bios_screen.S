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

/* bios_puts(%si) -- display 0-terminated string via putc()
 *
 * puts() repeatedly loads a byte from the buffer pointed
 * to by %si into %al, and displays that byte by calling
 * putc(%al), until a \0-byte is encountered.  The buffer
 * should thus be \0-terminated, like a regular C-string.
 */
.global bios_puts
bios_puts:
    lodsb                   # Load next byte from %si buffer into %al
    cmpb  $0x0, %al         # %al == 0?
    je    puts_end          # Yes: end of string!
    callw bios_putc         # No: Display current char
    jmp   bios_puts         # Proceed next char
puts_end:
    retw


/* clrscr() -- clear dislay */
.global bios_clrscr
bios_clrscr:
        /*
         * clrscr() clears the video buffer, using a special case in
         * the BIOS function "SCROLL UP WINDOW".  Note that this
         * function is only available in real mode, and that some
         * buggy BIOSes destroy the base pointer %bp, so we better
         * temporarily save it on the stack.
         */
        pushw %bp               # BIOS call below *can* destroy %BP
         
        movb  $0x06,   %ah      # BIOS function "SCROLL UP WINDOW"
        movb  $0x0,    %al      # nr. of lines to scroll (00=clear window)
        movb  $0x7,    %bh      # attr. to fill new lines at bottom
        movw  $0x0,    %cx      # CH,CL: row,column upper left corner  (00:00)
        movw  $0x184f, %dx      # DH,DL: row,column lower right corner (24:79)
        int   $0x10             # call BIOS
 
        popw  %bp
        retw

/* curshome() -- set cursor position to 0:0 */
.global bios_curshome
bios_curshome:
        /*
         * curshome() moves the cursor to position 0:0 (top:left),
         * using the BIOS function "SET CURSOR POSITION".  This
         * function is only available in real mode.
         */
        movb $0x02, %ah         # BIOS function "SET CURSOR POSITION"
        movb $0x0,  %bh         # page number 0
        movw $0x0,  %dx         # DH=0 row, DL=0 col
        int  $0x10              # call BIOS
        retw


