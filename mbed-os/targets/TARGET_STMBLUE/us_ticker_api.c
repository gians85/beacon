/* mbed Microcontroller Library
 */
#include <stddef.h>
#include "us_ticker_api.h"
#include "PeripheralNames.h"
#include "hal_tick.h"

#include "BlueNRG1_sysCtrl.h"
#include "BlueNRG1_mft.h"
#include "bluenrg_x_device.h"

#define aaa

#ifdef aaa
volatile uint32_t a=0;
void MFT1B_IRQHandler(void){
    /*if ( MFT_StatusIT(MFT1,MFT_IT_TND) != RESET ){
    	// Clear MFT2 pending interrupt A
        //MFT_ClearIT(MFT1, MFT_IT_TND);
    	SET_BIT(MFT1->TNICLR, MFT_IT_TND);

    	// Set the counter at 1 us
    	//MFT_SetCounter2(MFT1, 1);
    	//MFT1->TNCNT2 = 0x1;

        //update value
        a++;
    }*/
	// Clear pending interrupt

	MFT_ClearIT(MFT1, MFT_IT_TND);
	a++;
}


void us_ticker_init(void){
	NVIC_InitType NVIC_InitStructure;
	MFT_InitType timer_init;

	SysCtrl_PeripheralClockCmd(CLOCK_PERIPH_MTFX1 | CLOCK_PERIPH_MTFX2, ENABLE);

	MFT_StructInit(&timer_init);

	timer_init.MFT_Mode = MFT_MODE_3;
	timer_init.MFT_Prescaler = 15;

	/* MFT1 configuration */
	timer_init.MFT_Clock1 = MFT_NO_CLK;
	timer_init.MFT_Clock2 = MFT_PRESCALED_CLK;
	timer_init.MFT_CRB = 1;
	MFT_Init(MFT1, &timer_init);

	/* Enable MFT1B Interrupt */
	NVIC_InitStructure.NVIC_IRQChannel = MFT1B_IRQn;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = HIGH_PRIORITY;
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	NVIC_Init(&NVIC_InitStructure);

	/* Enable the MFT1 interrupt */
	MFT_EnableIT(MFT1, MFT_IT_TND, ENABLE);

	/* Enable the MFT1 */
	MFT_Cmd(MFT1, ENABLE);
}


uint32_t us_ticker_read(){
    return a;
}

void us_ticker_set_interrupt(timestamp_t timestamp){
	//UART_SendData((uint8_t)(timestamp+48));
	//MFT_Cmd(MFT1, ENABLE);
	//MFT_SetCounter2(MFT1, 1);
	//MFT_EnableIT(MFT1, MFT_IT_TND, ENABLE);
	SET_BIT(MFT1->TNICTRL, (MFT_IT_TND << 4));
}

/* NOTE: must be called with interrupts disabled! */
void us_ticker_disable_interrupt(void){
	//__disable_irq();
	/** Disable the MFT interrupt */
	//MFT_EnableIT(MFT1, MFT_IT_TND, DISABLE);
	CLEAR_BIT(MFT1->TNICTRL, (MFT_IT_TND << 4));
}

/* NOTE: must be called with interrupts disabled! */
void us_ticker_clear_interrupt(void){
	//MFT_ClearIT(MFT1, MFT_IT_TND);
	SET_BIT(MFT1->TNICLR, MFT_IT_TND);
}

/* NOTE: must be called with interrupts disabled! */
void us_ticker_fire_interrupt(void){
}
#endif //aaaa


#ifdef ddd
uint32_t lSystickCounter = 0;

void SysTick_Handler(void){
	lSystickCounter++;
}

void us_ticker_init(void){
	SysTick_Config(160-1);  //10us
}

uint32_t us_ticker_read(){
    return lSystickCounter;
}

void us_ticker_set_interrupt(timestamp_t timestamp){
    NVIC_EnableIRQ(SysTick_IRQn);
}

void us_ticker_disable_interrupt(void){
    NVIC_DisableIRQ(SysTick_IRQn);
}

void us_ticker_clear_interrupt(void){
}

void us_ticker_fire_interrupt(void){
}
#endif

#ifdef fff
uint32_t a;
void us_ticker_init(void){
}

uint32_t us_ticker_read(){
	return a;
}

void us_ticker_set_interrupt(timestamp_t timestamp){
}

void us_ticker_disable_interrupt(void){
}

void us_ticker_clear_interrupt(void){
}

void us_ticker_fire_interrupt(void){
}
#endif
