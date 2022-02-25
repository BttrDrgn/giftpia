#---------------------------------------------------
# Giftpia Disassembly Makefile
#---------------------------------------------------

ifneq (,$(findstring Windows,$(OS)))
  EXE := .exe
else
  WINE ?= wine
endif

# Unknown what actual compiler version it uses
MWCC_VERSION = 2.6
MWLD_VERSION := 2.6

VERBOSE ?= 0

# Don't echo build commands unless VERBOSE is set
ifeq ($(VERBOSE),0)
  QUIET := @
endif

# default recipe
default: all

#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------

AS      := $(DEVKITPPC)/bin/powerpc-eabi-as
CC      = $(WINE) tools/mwcc_compiler/$(MWCC_VERSION)/mwcceppc.exe
LD      := $(WINE) tools/mwcc_compiler/$(MWLD_VERSION)/mwldeppc.exe
OBJCOPY := $(DEVKITPPC)/bin/powerpc-eabi-objcopy
OBJDUMP := $(DEVKITPPC)/bin/powerpc-eabi-objdump
GCC     := $(DEVKITPPC)/bin/powerpc-eabi-gcc
HOSTCC  := cc
SHA1SUM := sha1sum
ELF2DOL := tools/elf2dol$(EXE)

# Options
INCLUDE_DIRS := src
SYSTEM_INCLUDE_DIRS := include

INCLUDES := -i include/
ASM_INCLUDES := -I include/

RUNTIME_INCLUDE_DIRS := libraries/PowerPC_EABI_Support/Runtime/Inc

#ASFLAGS     := -mgekko -I asm
ASFLAGS     := -mgekko $(ASM_INCLUDES)
CFLAGS      := -O4,p -inline auto -nodefaults -proc gekko -fp hard -Cpp_exceptions off -enum int -warn pragmas -pragma 'cats off' $(INCLUDES)
CPPFLAGS     = $(addprefix -i ,$(INCLUDE_DIRS) $(dir $^)) -I- $(addprefix -i ,$(SYSTEM_INCLUDE_DIRS))
ifeq ($(VERBOSE),1)
# this set of LDFLAGS outputs warnings.
DOL_LDFLAGS := -fp hard -nodefaults
endif
ifeq ($(VERBOSE),0)
# this set of LDFLAGS generates no warnings.
DOL_LDFLAGS := -fp hard -nodefaults -w off
endif

HOSTCFLAGS   := -Wall -O3 -s

CC_CHECK     := $(GCC) -Wall -Wextra -Wno-unused -Wno-main -Wno-unknown-pragmas -Wno-unused-variable -Wno-unused-parameter -Wno-sign-compare -Wno-missing-field-initializers -Wno-char-subscripts -fsyntax-only -fno-builtin -nostdinc $(addprefix -I ,$(INCLUDE_DIRS) $(SYSTEM_INCLUDE_DIRS)) -DNONMATCHING

ifeq ($(VERBOSE),0)
# this set of ASFLAGS generates no warnings.
ASFLAGS += -W
endif

#-------------------------------------------------------------------------------
# Files
#-------------------------------------------------------------------------------

NAME := giftpia
VERSION ?= final

LINK_INFO_DIR := linker
BUILD_DIR := build/$(NAME).$(VERSION)
DOL     := $(BUILD_DIR)/main.dol
ELF     := $(DOL:.dol=.elf)
MAP     := $(BUILD_DIR)/main.map

DOL_LCF := $(LINK_INFO_DIR)/static.lcf

include $(LINK_INFO_DIR)/obj_files.mk

O_FILES :=	$(SOURCES)
ALL_DIRS := $(sort $(dir $(O_FILES)))
ALL_O_FILES := $(O_FILES)
DUMMY != mkdir -p $(ALL_DIRS)
$(ELF): $(O_FILES)

#-------------------------------------------------------------------------------
# Recipes
#-------------------------------------------------------------------------------

.PHONY: all default

all: $(DOL)
	$(QUIET)

# static module (.dol file)
%.dol: %.elf $(ELF2DOL)
	@echo Converting $< to $@
	$(QUIET) $(ELF2DOL) $(filter %.elf,$^) $@

%.elf: $(DOL_LCF)
	@echo Linking static module $@
	$(QUIET) $(LD) -lcf $(DOL_LCF) $(DOL_LDFLAGS) $(filter %.o,$^) -map $(@:.elf=.map) -o $@

# Canned recipe for compiling C or C++
# Uses CC_CHECK to check syntax and generate dependencies, compiles the file,
# then disassembles the object file
define COMPILE =
@echo Compiling $<
$(QUIET) $(CC_CHECK) -MMD -MF $(@:.o=.dep) -MT $@ $<
$(QUIET) $(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<
$(QUIET) $(OBJDUMP) -Drz $@ > $(@:.o=.dump)
endef

$(BUILD_DIR)/%.o: %.c
	@echo "Compiling " $<
	$(QUIET) $(CC) $(CFLAGS) -c -o $@ $<
$(BUILD_DIR)/%.o: %.cpp
	$(COMPILE)
$(BUILD_DIR)/%.o: %.cp
	$(COMPILE)

$(BUILD_DIR)/%.o: %.s
	@echo Assembling $<
	$(QUIET) $(AS) $(ASFLAGS) -o $@ $<

clean:
	$(RM) $(DOL) $(ELF) $(MAP) $(ELF2DOL)
	rm -f -d -r build
	find . -name '*.o' -exec rm {} +
	find . -name '*.dep' -exec rm {} +
	find . -name '*.dump' -exec rm {} +
	find . -name 'ctx.c' -exec rm {} +
	find ./include -name "*.s" -type f -delete

# Automatic dependency files
DEP_FILES := $(addsuffix .dep,$(basename $(ALL_O_FILES)))
-include $(DEP_FILES)

#-------------------------------------------------------------------------------
# Tool Recipes
#-------------------------------------------------------------------------------

$(ELF2DOL): tools/elf2dol.c
	@echo Building tool $@
	$(QUIET) $(HOSTCC) $(HOSTCFLAGS) -o	 $@ $^

print-% : ; $(info $* is a $(flavor $*) variable set to [$($*)]) @true