MCU_VARIANT = AT32F437ZMT7
MCU_LINKER_NAME = AT32F437xM

JLINK_DEVICE = ${MCU_VARIANT}

# ArteryTek OpenOCD fork scripts
OPENOCD_OPTION ?= -f interface/atlink_dap_v2.cfg -f target/${MCU_LINKER_NAME:AT32F4%=at32f4%}.cfg

CFLAGS += \
  -D${MCU_VARIANT}
