#include "mbed.h"
#include "Beacon.h"


DigitalOut led1(LED1);
DigitalOut led2(LED2);
DigitalOut led3(LED3);
DigitalIn but1(PUSH1);
DigitalIn but2(PUSH2);
SPI spi(SPI_MOSI, SPI_MISO, SPI_SCK, SPI_CS); // mosi, miso, sclk
DigitalOut cs(SPI_CS);


void init();



int main() {
	init();
    beacon();
}



void init(){
	// Buttons
	but1.mode(NoPull);
	but2.mode(NoPull);
	// SPI Interface
	cs=1;
	spi.format(8, 0);
	spi.frequency(100000);
	// Ready
	led2 = 1;
}

