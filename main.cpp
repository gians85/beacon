#include "mbed.h"
#include "BlueNRG1_gpio.h"

//void mbed_die(void){};
void mydelay(void);



Serial pc(USBTX, USBRX);

DigitalOut led1(LED1);
DigitalOut led2(LED2);
DigitalOut led3(LED3);
DigitalIn but1(PUSH1);

void Rx_interrupt();
void Tx_interrupt();

int main() {
	led2 = 1;
	pc.printf("Hello\n\r");
	but1.mode(NoPull);
	// Setup a serial interrupt function to receive data
	pc.attach(&Rx_interrupt, Serial::RxIrq);
	while(1){
		while (!but1){
			led1 = !led1;
			wait_ms(50);
		}
	}
}

// Interupt Routine to read in data from serial port
void Rx_interrupt() {
	pc.putc(pc.getc());
	return;
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



