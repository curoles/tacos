QEMU_PARAMS := -machine virt -nographic -serial mon:stdio -d in_asm -D qemu.log -kernel $(BLD)/tacos.elf

