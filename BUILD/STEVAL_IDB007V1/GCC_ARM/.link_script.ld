_MEMORY_RAM_BEGIN_ = 0x20000000;
_MEMORY_RAM_SIZE_ = 0x6000;
_MEMORY_RAM_END_ = 0x20005FFF;
_MEMORY_FLASH_BEGIN_ = 0x10040000;
_MEMORY_FLASH_SIZE_ = 0x28000;
_MEMORY_FLASH_END_ = 0x10067FFF;
_MEMORY_ROM_BEGIN_ = 0x10000000;
_MEMORY_ROM_SIZE_ = 0x800;
_MEMORY_ROM_END_ = 0x100007FF;
FLASH_NVM_DATASIZE = (4*1024);
_MEMORY_FLASH_OFFSET_ = DEFINED(MEMORY_FLASH_APP_OFFSET) ? (MEMORY_FLASH_APP_OFFSET) : (0) ;
MEMORY_FLASH_APP_SIZE = ( _MEMORY_FLASH_SIZE_ - FLASH_NVM_DATASIZE - _MEMORY_FLASH_OFFSET_);
RESET_SM_MANAGER_SIZE = 0;
RESET_MANAGER_SIZE = 0;
RESET_MANAGER_SIZE = DEFINED(ST_OTA_HIGHER_APPLICATION) ? 0x800 : RESET_MANAGER_SIZE ;
MEMORY_FLASH_APP_SIZE = DEFINED(ST_OTA_HIGHER_APPLICATION) ? ((_MEMORY_FLASH_SIZE_ - RESET_MANAGER_SIZE - FLASH_NVM_DATASIZE - 2048) / 2) : MEMORY_FLASH_APP_SIZE ;
_MEMORY_FLASH_OFFSET_ = DEFINED(ST_OTA_HIGHER_APPLICATION) ? (RESET_MANAGER_SIZE + MEMORY_FLASH_APP_SIZE) : _MEMORY_FLASH_OFFSET_ ;
RESET_MANAGER_SIZE = DEFINED(ST_OTA_LOWER_APPLICATION) ? 0x800 : RESET_MANAGER_SIZE ;
MEMORY_FLASH_APP_SIZE = DEFINED(ST_OTA_LOWER_APPLICATION) ? ((_MEMORY_FLASH_SIZE_ - RESET_MANAGER_SIZE - FLASH_NVM_DATASIZE - 2048) / 2) : MEMORY_FLASH_APP_SIZE ;
_MEMORY_FLASH_OFFSET_ = DEFINED(ST_OTA_LOWER_APPLICATION) ? (RESET_MANAGER_SIZE) : _MEMORY_FLASH_OFFSET_ ;
RESET_SM_MANAGER_SIZE = DEFINED(ST_USE_OTA_SERVICE_MANAGER_APPLICATION) ? 0xF000 : RESET_SM_MANAGER_SIZE ;
MEMORY_FLASH_APP_SIZE = DEFINED(ST_USE_OTA_SERVICE_MANAGER_APPLICATION) ? (_MEMORY_FLASH_SIZE_ - RESET_SM_MANAGER_SIZE - FLASH_NVM_DATASIZE) : MEMORY_FLASH_APP_SIZE ;
_MEMORY_FLASH_OFFSET_ = DEFINED(ST_USE_OTA_SERVICE_MANAGER_APPLICATION) ? (RESET_SM_MANAGER_SIZE) : _MEMORY_FLASH_OFFSET_ ;
MEMORY
{
  FLASH (rx) : ORIGIN = 0x10040000, LENGTH = 160k
  RAM (xrw) : ORIGIN = 0x20000000, LENGTH = 24k
  ROM (rx) : ORIGIN = 0x10000000, LENGTH = 0x800
}
ENTRY(Reset_Handler)
_Min_Heap_Size = 0x0;
_Min_Stack_Size = 0xC00;
SECTIONS
{
 .bootloader (ORIGIN(FLASH)) :
   {
     . = ALIGN(4);
     KEEP(*(.bootloader))
     . = ALIGN(4);
   }>FLASH
    .text :
    {
        KEEP(*(.isr_vector))
        *(.text*)
        KEEP(*(.init))
        KEEP(*(.fini))
        *crtbegin.o(.ctors)
        *crtbegin?.o(.ctors)
        *(EXCLUDE_FILE(*crtend?.o *crtend.o) .ctors)
        *(SORT(.ctors.*))
        *(.ctors)
        *crtbegin.o(.dtors)
        *crtbegin?.o(.dtors)
        *(EXCLUDE_FILE(*crtend?.o *crtend.o) .dtors)
        *(SORT(.dtors.*))
        *(.dtors)
        *(.rodata*)
        KEEP(*(.eh_frame*))
        . = ALIGN(4);
      _etext = .;
    } > FLASH
    .ARM.extab :
    {
        *(.ARM.extab* .gnu.linkonce.armextab.*)
    } > FLASH
    __exidx_start = .;
    .ARM.exidx :
    {
        *(.ARM.exidx* .gnu.linkonce.armexidx.*)
    } > FLASH
    __exidx_end = .;
    _sidata = LOADADDR(.data);
   _sidata2 = LOADADDR(.ram_preamble);
    .data :
    {
        __data_start__ = .;
        _sdata = .;
        *(vtable)
        *(.data*)
        . = ALIGN(4);
        PROVIDE_HIDDEN (__preinit_array_start = .);
        KEEP(*(.preinit_array))
        PROVIDE_HIDDEN (__preinit_array_end = .);
        . = ALIGN(4);
        PROVIDE_HIDDEN (__init_array_start = .);
        KEEP(*(SORT(.init_array.*)))
        KEEP(*(.init_array))
        PROVIDE_HIDDEN (__init_array_end = .);
        . = ALIGN(4);
        PROVIDE_HIDDEN (__fini_array_start = .);
        KEEP(*(SORT(.fini_array.*)))
        KEEP(*(.fini_array))
        PROVIDE_HIDDEN (__fini_array_end = .);
        KEEP(*(.jcr*))
        . = ALIGN(4);
        __data_end__ = .;
        _edata = .;
    } > RAM AT > FLASH
   .ram_preamble :
   {
     . = ALIGN(4);
     _sdata2 = .;
     . = 0x04 ;
     KEEP(*(.ota_sw_activation))
     . = 0x08 ;
     KEEP(*(.savedMSP))
     . = 0x0C ;
     KEEP(*(.wakeupFromSleepFlag))
     . = 0x10 ;
     . = 0x30 ;
     KEEP(*(.__blueflag_RAM))
       _edata2 = .;
     . = 0x34 ;
     KEEP(*(.__crash_RAM))
     . = 0xc0 ;
   } >RAM AT> FLASH
    .bss :
    {
        . = ALIGN(4);
        __bss_start__ = .;
        _sbss = .;
        KEEP(*(.bss.__blue_RAM))
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        __bss_end__ = .;
        _ebss = .;
    } > RAM
   BLOCK_STACKLIB_FLASH_DATA (_MEMORY_FLASH_END_ - FLASH_NVM_DATASIZE + 1) (NOLOAD) :
   {
     . = ALIGN(2048);
     KEEP(*(.noinit.stacklib_flash_data))
     KEEP(*(.noinit.stacklib_stored_device_id_data))
   } >FLASH
 CSTACK (ORIGIN(RAM) + LENGTH(RAM) - _Min_Stack_Size) (NOLOAD) :
   {
     . = ALIGN(4);
     _estack = . + _Min_Stack_Size;
     . = ALIGN(4);
   } > RAM
 .rom_info (NOLOAD) :
 {
     . = ALIGN(4);
     KEEP(*(.rom_info))
     . = ALIGN(4);
 } >FLASH
    .heap (COPY):
    {
        __end__ = .;
        end = __end__;
        *(.heap*)
        __HeapLimit = .;
    } > RAM
    .stack_dummy (COPY):
    {
        *(.stack*)
    } > RAM
    __StackTop = ORIGIN(RAM) + LENGTH(RAM);
    _estack = __StackTop;
    __StackLimit = __StackTop - SIZEOF(.stack_dummy);
    PROVIDE(__stack = __StackTop);
    ASSERT(__StackLimit >= __HeapLimit, "region RAM overflowed with stack")
   .ARM.attributes 0 : { *(.ARM.attributes) }
}
