AT32_FAMILY = at32f435_437
AT32_SDK_LIB = hw/mcu/artery/${AT32_FAMILY}/libraries

include $(TOP)/$(BOARD_PATH)/board.mk

CPU_CORE ?= cortex-m4

CFLAGS += \
  -flto

# Both OTG cores are full speed. Default keeps device on OTG2 (PB14/PB15, CN3 on
# AT-START) and host on OTG1 (PA11/PA12, CN2). Override with RHPORT_DEVICE=0 to
# put the device on OTG1.
RHPORT_SPEED ?= OPT_MODE_FULL_SPEED OPT_MODE_FULL_SPEED
RHPORT_DEVICE ?= 1
RHPORT_HOST ?= 0

ifndef RHPORT_DEVICE_SPEED
ifeq ($(RHPORT_DEVICE), 0)
  RHPORT_DEVICE_SPEED = $(firstword $(RHPORT_SPEED))
else
  RHPORT_DEVICE_SPEED = $(lastword $(RHPORT_SPEED))
endif
endif

ifndef RHPORT_HOST_SPEED
ifeq ($(RHPORT_HOST), 0)
  RHPORT_HOST_SPEED = $(firstword $(RHPORT_SPEED))
else
  RHPORT_HOST_SPEED = $(lastword $(RHPORT_SPEED))
endif
endif

CFLAGS += \
	-DCFG_TUSB_MCU=OPT_MCU_AT32F435_437 \
	-DBOARD_TUD_RHPORT=${RHPORT_DEVICE} \
	-DBOARD_TUD_MAX_SPEED=${RHPORT_DEVICE_SPEED} \
	-DBOARD_TUH_RHPORT=${RHPORT_HOST} \
	-DBOARD_TUH_MAX_SPEED=${RHPORT_HOST_SPEED} \

LDFLAGS += \
	-flto --specs=nosys.specs -nostdlib -nostartfiles

SRC_C += \
	src/portable/synopsys/dwc2/dcd_dwc2.c \
	src/portable/synopsys/dwc2/hcd_dwc2.c \
	src/portable/synopsys/dwc2/dwc2_common.c \
	$(AT32_SDK_LIB)/drivers/src/${AT32_FAMILY}_gpio.c \
	$(AT32_SDK_LIB)/drivers/src/${AT32_FAMILY}_misc.c \
	$(AT32_SDK_LIB)/drivers/src/${AT32_FAMILY}_usart.c \
	$(AT32_SDK_LIB)/drivers/src/${AT32_FAMILY}_crm.c \
	$(AT32_SDK_LIB)/drivers/src/${AT32_FAMILY}_acc.c \
	$(AT32_SDK_LIB)/drivers/src/${AT32_FAMILY}_exint.c \
	$(AT32_SDK_LIB)/cmsis/cm4/device_support/system_${AT32_FAMILY}.c

INC += \
	$(TOP)/$(BOARD_PATH) \
	$(TOP)/$(AT32_SDK_LIB)/drivers/inc \
	$(TOP)/$(AT32_SDK_LIB)/cmsis/cm4/core_support \
	$(TOP)/$(AT32_SDK_LIB)/cmsis/cm4/device_support

SRC_S += ${AT32_SDK_LIB}/cmsis/cm4/device_support/startup/gcc/startup_${AT32_FAMILY}.s

LD_FILE ?= ${AT32_SDK_LIB}/cmsis/cm4/device_support/startup/gcc/linker/${MCU_LINKER_NAME}_FLASH.ld

flash: flash-atlink
