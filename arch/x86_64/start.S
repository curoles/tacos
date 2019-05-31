.file "start.S"

.set LOAD,      0x7c00     // BIOS loads and jumps here
.set MAGIC,     0xaa55     // Must be at the end of the 512-byte block
.set BLOCKSIZE, 512        // Boot block is BLOCKSIZE bytes long

/*
 * https://farid.hajji.org/en/blog/46-hello-world-on-the-bare-metal
 *
 * The processor starts in real mode and executes the first
 * instruction at address $0xFFFF:FFF0.  System designers
 * usually map BIOS at this address, so the CPU starts running
 * BIOS code.  The BIOS initializes RAM and other components.
 * Then, it loads $BLOCKSIZE bytes from the first boot device
 * in RAM, starting at address $0x0:$LOAD.
 *
 * If that block finishes with the $MAGIC sequence 0x55, 0xaa
 * (it is reversed, because IA-32 arch is little endian), BIOS
 * considers this block a valid boot block, and jumps right here.
 */

/* Real mode mem map:
    00000 – 003FF, RAM, Real Mode Interrupt Vector Table (IVT)
    00400 – 004FF, RAM, BIOS Data Area (BDA)
    00500 – 9FBFF, RAM, Free Memory (below 1MB), 630K
    9FC00 – 9FFFF, RAM, Extended BIOS Data Area (EBDA)
    A0000 – BFFFF, VRAM, VGA Frame Buffer
    C0000 – C7FFF, ROM, Video BIOS 32K
    C8000 – EFFFF, Nothing (hole)
    F0000 – FFFFF, ROM, Motherboard BIOS 64K

 BIOS loads our 512-bytes program at address 0000:7C00, in the 00500 – 9FBFF area.
 On the IA-32 platform, the stack grows towards lower addresses.
 In other words, if %sp points to 0x7c00, a pushw would decrement %sp by two,
 so it would then point to 0x7bfe, i.e. below our code.
*/



.code16            // Boot code runs in 16-bit real mode
.text              // Text section
.global _start

_start:
    cli                           // disable the interrupts
    ljmp $0, $setcs
setcs:

    // Initialize segment descriptors %ds, %es, and %ss to 0x0.
    // %cs:%ip is already set by the BIOS to 0x0:$LOAD.
    xorw %ax, %ax
    movw %ax, %es
    movw %ax, %ds
    movw %ax, %ss


    /*
     * Initialize the stack.
     * 
     * Since the stack on x86 grows towards *lower* addresses,
     * we anchor it at $LOAD.  Note that we don't collide with
     * the code because the stack will always remain below
     * (i.e. less than) $LOAD and grows downwards from there.
     */
    //movw $LOAD, %sp
    mov $__stack_top, %esp

    cld // clear direction flag, string processed from lo to hi addr

    callw bios_clrscr             // clear screen
    callw bios_curshome           // move cursor home - top:left
    callw greeting                // display a greeting string

    callw x86_init

loop:
    hlt
    jmp loop
halt:
    hlt

/* greeting() -- display the banner */       
greeting:
    /*
     * greeting dislays the string located at label banner,
     * using the convenience function puts() defined below.
     * We pass the *address* of that string (thus $banner instead
     * of msg) in the %si register.
     */
    movw  $banner, %si
    callw bios_puts
    retw


// The string buffer to be displayed.
banner:
    .asciz "TacOS\r\n" // asciz puts a 0 byte at the end

 
/*
 * The boot block MUST end with a MAGIC sequence.
 * 
 * The BIOS checks this, and would refuse to boot unless
 * MAGIC is there.  The last two bytes of the BLOCKSIZE
 * long block must contain the magic sequence 0x55, 0xaa.
 * We move the assembler pointer .org there, and emit the
 * word MAGIC.  Note that MAGIC is set to 0xaa55, and not
 * 0x55aa, because the IA-32 platform is little endian.
 */
//.org BLOCKSIZE - 2
//.word MAGIC
