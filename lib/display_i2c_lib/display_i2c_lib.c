#include "../../mcc_generated_files/mcc.h"

#ifndef DISPLAY_I2C_LIB_H
#include "display_i2c_lib.h"
#endif

#ifndef I2C_LIB_H
#include "../i2c_lib/i2c_lib.h"
#endif

void displayI2CInit() {
    i2c_write_serial(display_addr, display_init, 4);
}

void displayI2CSetFirstLine(void) {
    i2c_write_serial(display_addr, first_line, 2);
}

void displayI2CSetSecondLine(void) {
    i2c_write_serial(display_addr, shift_line, 2);
}