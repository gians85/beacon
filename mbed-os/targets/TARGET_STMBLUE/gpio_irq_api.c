/*
 * gpio_irq_api.c
 *
 *  Created on: 26 gen 2018
 *      Author: Gianluca
 */
#ifdef DEVICE_INTERRUPTIN

#include "gpio_irq_api.h"
#include "objects.h"
#include "serial_mylib.h"
#include "BlueNRG1_gpio.h"



int gpio_irq_init(gpio_irq_t *obj, PinName pin, gpio_irq_handler handler, uint32_t id){
	if (pin == NC) return -1;
	return 0;
}


void gpio_irq_free(gpio_irq_t *obj){}

void gpio_irq_set(gpio_irq_t *obj, gpio_irq_event event, uint32_t enable){
}

#endif //DEVICE_INTERRUPTIN
