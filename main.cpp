#include "mbed.h"

Serial pc(USBTX, USBRX);

DigitalOut led1(LED1);
DigitalOut led2(LED2);
DigitalOut led3(LED3);
DigitalIn but1(PUSH1);

SPI spi(SPI_MOSI, SPI_MISO, SPI_SCK, SPI_CS); // mosi, miso, sclk
DigitalOut cs(SPI_CS);


void Rx_interrupt();
void Tx_interrupt();
void mydelay();

int main() {
	led2 = 1;
	pc.printf("Hello\n\r");
	but1.mode(NoPull);
	pc.attach(&Rx_interrupt, Serial::RxIrq);
	pc.attach(&Tx_interrupt, Serial::TxIrq);

    //spi.format(8, 0);
    spi.frequency(100000);

    //cs=1;
    //int foo =spi.write(0x8F);
    //spi.write(0x0A);
//    int whoami = spi.write(0x0A);  //0x00
//    pc.printf("WHOAMI register = 0x%X\n", whoami);ù
    cs=1;
    pc.printf("%d", spi.write(0x8F));
    wait_ms(50);

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

void Tx_interrupt(){
	 led3 = !led3;
	return;
}




void mydelay(){
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



