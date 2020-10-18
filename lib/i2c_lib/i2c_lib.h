/* 
 * File:   i2c_lib.h
 * Author: krs
 *
 * Created on February 17, 2020, 6:42 PM
 */

#ifndef I2C_LIB_H
#define	I2C_LIB_H

// Prototypes
void i2c_init(void);
void i2c_write_serial(uint8_t, uint8_t *, uint8_t);
void i2c_read_serial(uint8_t, uint8_t *, uint8_t);

// Global vars
uint8_t data_out[4];
uint8_t tmp_string[0x0F];

#endif	/* I2C_LIB_H */