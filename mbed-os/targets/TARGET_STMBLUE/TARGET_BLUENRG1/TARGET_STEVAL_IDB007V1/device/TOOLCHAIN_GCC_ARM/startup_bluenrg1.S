/**
  ******************************************************************************
  *
  ******************************************************************************
  */

  .syntax unified
  .cpu cortex-m0
  .fpu softvfp
  .thumb

.global g_pfnVectors
.global Default_Handler

/* start address for the initialization values of the .data section.
defined in linker script */
.word _sidata
/* start address for the .data section. defined in linker script */
.word _sdata
/* end address for the .data section. defined in linker script */
.word _edata

/**
 * This is the code that gets called when the processor first
 * starts execution following a reset event. Only the absolutely
 * necessary set is performed, after which the application
 * supplied main() routine is called.
*/
  .section .text.Reset_Handler
  .weak Reset_Handler
  .type Reset_Handler, %function

Reset_Handler:
/* set stack pointer */
  ldr   r0, =_estack
  mov   sp, r0


/* Copy the data segment initializers from flash to SRAM
  movs r1, #0
  b LoopCopyDataInit
  
CopyDataInit:
  ldr r3, =_sidata
  ldr r3, [r3, r1]
  str r3, [r0, r1]
  adds r1, r1, #4
  
LoopCopyDataInit:
  ldr r0, =_sdata
  ldr r3, =_edata
  adds r2, r0, r1     //r2=r0 & condition code flags are updated
  cmp r2, r3
  bcc CopyDataInit    //branch if Carry=0 : b if r2<r3
*/


/* Copy the data segment initializers from flash to SRAM */
  ldr r0, =_sdata
  ldr r1, =_edata
  ldr r2, =_sidata
  movs r3, #0
  b LoopCopyDataInit

CopyDataInit:
  ldr r4, [r2, r3]
  str r4, [r0, r3]
  adds r3, r3, #4

LoopCopyDataInit:
  adds r4, r0, r3     //r4=r0 & condition code flags are updated
  cmp r4, r1          //branch if Carry=0 : b if r4<r1
  bcc CopyDataInit


/* Call the clock system intitialization function */
    bl  SystemInit

/* Call the application's entry point */
    bl _start


LoopForever:
    b LoopForever


.size Reset_Handler, .-Reset_Handler

/**
 * @brief  This is the code that gets called when the processor receives an
 *         unexpected interrupt.  This simply enters an infinite loop, preserving
 *         the system state for examination by a debugger.
 *
 * @param  None
 * @retval : None
*/
    .section .text.Default_Handler,"ax",%progbits
Default_Handler:
Infinite_Loop:
  b Infinite_Loop
  .size Default_Handler, .-Default_Handler
/******************************************************************************
*
* The minimal vector table for a Cortex M0.  Note that the proper constructs
* must be placed on this to ensure that it ends up at physical address
* 0x0000.0000.
*
******************************************************************************/
   .section .isr_vector,"a",%progbits
  .type g_pfnVectors, %object
  .size g_pfnVectors, .-g_pfnVectors


g_pfnVectors:
  .word  _estack
  .word  Reset_Handler
  .word  NMI_Handler
  .word  HardFault_Handler
  .word  0
  .word  0
  .word  0
  .word  0
  .word  0
  .word  0
  .word  0
  .word  SVC_Handler
  .word  0
  .word  0
  .word  PendSV_Handler
  .word  SysTick_Handler
  .word  GPIO_IRQHandler                   	/* GPIO			            	*/
  .word  FLASH_IRQHandler                  	/* FLASH                   	 	*/
  .word  0
  .word  0
  .word	 UART_IRQHandler                   	/* UART			            	*/
  .word  SPI_IRQHandler                   	/* SPI			            	*/
  .word  BLE_IRQHandler                   	/* BLE controller			*/
  .word  WDG_IRQHandler                   	/* WatchDog        		(WWDG)	*/
  .word  0
  .word  0
  .word  0
  .word  0
  .word  0
  .word  ADC_IRQHandler              		/* ADC                          */
  .word  I2C1_IRQHandler              		/* I2C1                         */
  .word  I2C2_IRQHandler              		/* I2C2                         */
  .word  0
  .word  MFT1A_IRQHandler              		/* MFT1 A                       */
  .word  MFT1B_IRQHandler              		/* MFT1 B                       */
  .word  MFT2A_IRQHandler              		/* MFT2 A                       */
  .word  MFT2B_IRQHandler              		/* MFT2 B                       */
  .word  RTC_IRQHandler              		/* RTC                          */
  .word  PKA_IRQHandler              		/* PKA                          */
  .word  DMA_IRQHandler              		/* DMA                          */
  .word  0
  .word  0
  .word  0
  .word  0
  .word  0
  .word  0
  .word  0
  .word  0

/*******************************************************************************
*
* Provide weak aliases for each Exception handler to the Default_Handler.
* As they are weak aliases, any function with the same name will override
* this definition.
*
*******************************************************************************/

  .weak      NMI_Handler
  .thumb_set NMI_Handler,Default_Handler

  .weak      HardFault_Handler
  .thumb_set HardFault_Handler,Default_Handler

  .weak      SVC_Handler
  .thumb_set SVC_Handler,Default_Handler

  .weak      PendSV_Handler
  .thumb_set PendSV_Handler,Default_Handler

  .weak      SysTick_Handler
  .thumb_set SysTick_Handler,Default_Handler

  .weak      GPIO_IRQHandler
  .thumb_set GPIO_IRQHandler,Default_Handler

  .weak      FLASH_IRQHandler
  .thumb_set FLASH_IRQHandler,Default_Handler

  .weak      UART_IRQHandler
  .thumb_set UART_IRQHandler,Default_Handler

  .weak      SPI_IRQHandler
  .thumb_set SPI_IRQHandler,Default_Handler

  .weak      BLE_IRQHandler
  .thumb_set BLE_IRQHandler,Default_Handler

  .weak      WDG_IRQHandler
  .thumb_set WDG_IRQHandler,Default_Handler

  .weak      ADC_IRQHandler
  .thumb_set ADC_IRQHandler,Default_Handler

  .weak      I2C1_IRQHandler
  .thumb_set I2C1_IRQHandler,Default_Handler

  .weak      I2C2_IRQHandler
  .thumb_set I2C2_IRQHandler,Default_Handler

  .weak      MFT1A_IRQHandler
  .thumb_set MFT1A_IRQHandler,Default_Handler

  .weak      MFT1B_IRQHandler
  .thumb_set MFT1B_IRQHandler,Default_Handler

  .weak      MFT2A_IRQHandler
  .thumb_set MFT2A_IRQHandler,Default_Handler

  .weak      MFT2B_IRQHandler
  .thumb_set MFT2B_IRQHandler,Default_Handler

  .weak      RTC_IRQHandler
  .thumb_set RTC_IRQHandler,Default_Handler

  .weak      PKA_IRQHandler
  .thumb_set PKA_IRQHandler,Default_Handler

  .weak      DMA_IRQHandler
  .thumb_set DMA_IRQHandler,Default_Handler


/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/

