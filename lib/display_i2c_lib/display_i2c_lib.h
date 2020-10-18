/* 
 * File:   display_i2c_lib.h
 * Author: karsten
 *
 * Created on 22. februar 2020, 19:26
 */

#ifndef DISPLAY_I2C_LIB_H
#define	DISPLAY_I2C_LIB_H


//Prototype


//Global vars
uint8_t display_addr    = 0b0111100; // Addresse(7) for display 0x3C 60
uint8_t display_init[]  = {0x00, 0x38, 0x0C, 0x06};
uint8_t first_line[]    = {0x00, 0x80};
uint8_t shift_line[]    = {0x00, 0xC0};

#endif	/* DISPLAY_I2C_LIB_H */