SRC ?= .
BLD ?= .
ARCH ?= tachy
TC ?=
QEMU_DIR ?=

CC := $(TC)gcc
LD := $(TC)ld
OBJCOPY := $(TC)objcopy
OBJDUMP := $(TC)objdump

QEMU := $(QEMU_DIR)qemu-system-$(ARCH)

DEBUG ?= 0
ifeq ($(DEBUG), 1)
  CFLAGS := -g -O2
else
  CFLAGS := -O3
endif

CFLAGS += -ffreestanding -Wall -Werror -I$(SRC)
LDFLAGS := -nostdlib -nolibc

CXX_FILES := tacos
ASM_FILES := arch/$(ARCH)/start

HDR_FILES := os/spinlock.h

include $(SRC)/arch/$(ARCH)/build.mk

OBJ_FILES := $(addprefix $(BLD)/, $(addsuffix .o, $(CXX_FILES) $(ASM_FILES)))

$(BLD)/tacos.elf: $(OBJ_FILES)
	$(LD) $(LDFLAGS) -T $(SRC)/arch/$(ARCH)/tacos.ld $^ -o $@
	$(OBJCOPY) -O binary $@ $(BLD)/tacos.img
	$(OBJDUMP) -d $@ > $(BLD)/objdump.txt

$(BLD)/%.o: $(SRC)/%.cpp $(addprefix $(SRC)/, $(HDR_FILES))
	$(CC) $(CFLAGS) -c $< -o $@

$(BLD)/arch/$(ARCH)/%.o: $(SRC)/arch/$(ARCH)/%.S
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

$(BLD)/arch/$(ARCH)/%.o: $(SRC)/arch/$(ARCH)/%.cpp
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@


.PHONY: run
run:
	$(QEMU) $(QEMU_PARAMS)

$(BLD)/run.bash:
	echo "#!/bin/bash" > $@
	echo "$(QEMU) $(QEMU_PARAMS)" >> $@
	chmod a+x $@

.PHONY: clean
clean:
	rm -f $(OBJ_FILES)
	rm -f $(BLD)/tacos.elf $(BLD)/tacos.img $(BLD)/qemu.log $(BLD)/run.bash
	rm -f $(BLD)/objdump.txt
	rm -f $(BLD)/*.o
