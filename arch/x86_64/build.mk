
  QEMU_PARAMS := -machine pc -serial mon:stdio -d in_asm -D qemu.log -drive file=$(BLD)/tacos.img,format=raw

ASM_FILES += arch/x86_64/bios_screen
