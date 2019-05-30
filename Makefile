SRC ?= .
BLD ?= .
ARCH ?= tachy
TC ?=
QEMU_DIR ?=

CC := $(TC)gcc
LD := $(TC)ld
OBJCOPY := $(TC)objcopy

QEMU := $(QEMU_DIR)qemu-system-$(ARCH)

DEBUG ?= 0
ifeq ($(DEBUG), 1)
  CFLAGS := -g -O2
else
  CFLAGS := -O3
endif

CFLAGS += -Wall -Werror -I$(SRC)
LDFLAGS := -nostdlib -nolibc

CXX_FILES := tacos
ASM_FILES := arch/$(ARCH)/start

include $(SRC)/arch/$(ARCH)/build.mk

OBJ_FILES := $(addprefix $(BLD)/, $(addsuffix .o, $(CXX_FILES) $(ASM_FILES)))

$(BLD)/tacos.elf: $(OBJ_FILES)
	$(LD) $(LDFLAGS) -T $(SRC)/arch/$(ARCH)/tacos.ld $^ -o $@
	$(OBJCOPY) -O binary $@ $(BLD)/tacos.img

$(BLD)/%.o: $(SRC)/%.cpp
	$(CC) $(CFLAGS) -c $< -o $@

$(BLD)/arch/$(ARCH)/%.o: $(SRC)/arch/$(ARCH)/%.S $(BLD)/arch/$(ARCH)
	$(CC) $(CFLAGS) -c $< -o $@

$(BLD)/arch/$(ARCH):
	mkdir -p $@

.PHONY: run
run:
	$(QEMU) $(QEMU_PARAMS)

.PHONY: clean
clean:
	rm -f $(OBJ_FILES)
	rm -f $(BLD)/tacos.elf
	rm -f $(BLD)/*.o
