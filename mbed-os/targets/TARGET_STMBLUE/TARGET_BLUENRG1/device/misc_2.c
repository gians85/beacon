/*
 * misc_2.c
 *
 *  Created on: 22 gen 2018
 *      Author: Gianluca
 */

#include "misc_2.h"
#include "cmsis.h"
#include "BlueNRG1_uart.h"

void printf_no_mbed(char *str){
	uint8_t i=0;
	while (str[i]!='\0'){
		/* Wait if TX fifo is full. */
		while (UART_GetFlagStatus(UART_FLAG_TXFF) == SET);
		/* send the data */
		UART_SendData((uint16_t)str[i]);
		i++;
	}
}


