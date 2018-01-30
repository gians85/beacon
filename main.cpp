#include "mbed.h"

//void mbed_die(void){};
void mydelay(void);

Serial pc(USBTX, USBRX);

DigitalOut led1(LED1);
DigitalOut led2(LED2);
DigitalIn but1(PUSH1);

//InterruptIn button(PUSH1);

int main() {
	led2 = 1;
	//button.rise(&flip);
	pc.printf("Hello\n\r");
	but1.mode(NoPull);

	/* BUTTON_1 initialization
	SdkEvalPushButtonInit(BUTTON_1);
	SdkEvalPushButtonIrq(BUTTON_1, IRQ_ON_BOTH_EDGE);*/

	/* BUTTON_2 initialization
	SdkEvalPushButtonInit(BUTTON_2);
	SdkEvalPushButtonIrq(BUTTON_2, IRQ_ON_RISING_EDGE); */

	while(1){
		while (!but1){
			led1 = !led1;
			wait_ms(50);
		}
	}
}


void mydelay(void){
	uint32_t i;
	for(i=0; i<0xFFF; i++){
#ifdef __GNUC__
		//__asm__(".syntax unified; movs r1,#0xFF; delay: subs r1,r1,#1; bne delay; .syntax divided;");
		__asm__(".syntax unified; movs r1,#0xFF; dlay: subs r1,r1,#1; cmp r1,#0; bne dlay; .syntax divided;");
#elif defined(__ICCARM__) || defined(__IAR_SYSTEMS_ASM__)
		__asm("      movs r1,#0xFF \n"
				"dlay: subs r1,r1,#1 \n"
				"      cmp r1,#0     \n"
				"      bne dlay        ");
#endif
	}
}



