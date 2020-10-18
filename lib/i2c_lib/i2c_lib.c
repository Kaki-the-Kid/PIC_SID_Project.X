#include "../../mcc_generated_files/mcc.h"
//#include <stdio.h>
//#include <string.h>

#ifndef I2C_LIB_H
#include "i2c_lib.h"
#endif

void i2c_init(void) {
    TRISCbits.RC3=1;
    TRISCbits.RC4=1;

    ANSELCbits.ANSC3 = 0;
    ANSELCbits.ANSC4 = 0;
            
    //uint8_t i2c_clock = (_XTAL_FREQ /(4 * 100000)) - 1; // Sætter hastigheden til 100K for I2C bussen #9
    
    SSP1ADD  = 0x9F; //i2c_clock; //SSP1ADD = 0x9F ved 16MHz x 4 software pll
    SSP1CON1 = 0x28;//0b00101000; // 0x28
    SSP1CON2 = 0;
}
//#define errors

void i2c_write_serial(uint8_t addr, uint8_t *data, uint8_t length) {
    uint8_t targetAddr = addr<<1; // Laver addressen om til 8 bit med WRITE condition

    printf("\n\r***********WRITE****************\n\r");

    
    // Venter på bussen er klar
    while ( (SSP1STAT & 0x04) || (SSP1CON2 & 0x1F) );

    printf("Bussen er klar\r\n");

    // Sætter start condition
    SSP1CON2bits.SEN = 1;
    while(SSP1CON2bits.SEN == 1);
    printf("Har sendt start\r\n");
   
    // Skriver sdressen
    SSP1BUF = targetAddr;
    while(SSP1STATbits.R_nW);
    printf("Addresse: %#02X\r\n", targetAddr);
    
    if( SSP1CON2bits.ACKSTAT == 0 ) {
        for (uint8_t i=0; i < length ; i++) {

            printf("Data: %#02X\r\n", data[i]);

            SSP1BUF = (uint8_t) data[i];
            while(SSP1STATbits.R_nW);

            if( SSP1CON2bits.ACKSTAT == 0 ) { // Hvis vi får en Acknowledge
                printf("ACK - Skrev data: %#02X - %c\n\r", data[i], data[i]);
            } else {
                printf("NACK - gensender\r\n");
                SSP1CON2bits.RCEN=1;
                while(SSP1CON2bits.RCEN==1);

                SSP1BUF = (uint8_t) data[i];
                while(SSP1STATbits.R_nW);

                if(SSP1CON2bits.ACKSTAT == 0) {
                    printf("ACK - Skrev data: %#02X - %c\n\r", data[i], data[i]);
                } else {
                    printf("NACK - Fejl i skrivning af data\r\n");
                }
            }
        } 
        
        // Sætter stop condition
        SSP1CON2bits.PEN = 1;
        while(SSP1CON2bits.PEN == 1);

        printf("Har sendt stop\n\r");

    } else {

        printf("Kunne ikke finde enhed\r\n");

    }

    printf("********************************\n\r");

}


void i2c_read_serial(uint8_t addr, uint8_t *data_out, uint8_t length) {
    uint8_t targetAddr = (addr<<1)+1; // Laver addressen om til 8 bit med READ condition
    printf("\r\n***********READ*****************\n\r");
    
    // Venter på bussen er klar
    while ( (SSP1STAT & 0x04) || (SSP1CON2 & 0x1F) );
    printf("Bussen er klar\n\r");
    
    // Sætter start condition
    SSP1CON2bits.SEN = 1;
    while(SSP1CON2bits.SEN == 1);
    printf("Har sendt start\n\r");

    SSP1BUF = targetAddr; // Skriver sdressen
    while(SSP1STATbits.R_nW);
    printf("Skrev adresse: %#0.2X\n\r", targetAddr);
    
    //__delay_ms(3000);
    
    if(SSP1CON2bits.ACKSTAT == 0) {
        for (uint8_t i=0; i < length ; i++) {
            SSP1CON2bits.RCEN = 1;
            while(SSP1CON2bits.RCEN);
            
            data_out[i] = SSP1BUF;
            
            // Sender ACK eller NACK til sidst
            if( i != length -1)
                SSP1CON2bits.ACKDT = 0; // ACK
            else
                SSP1CON2bits.ACKDT = 1; // NACK
           
            SSP1CON2bits.ACKEN = 1;
            while(SSP1CON2bits.ACKEN == 1);
            
            printf("Laeste: %#0.2X\n\r", data_out[i]);

        }
            // Sender NACK
            SSP1CON2bits.ACKDT = 1;
            SSP1CON2bits.ACKEN = 1;
            while(SSP1CON2bits.ACKEN == 1);

            // Sender stop condition
            SSP1CON2bits.PEN = 1;
            while(SSP1CON2bits.PEN == 1);

            printf("Har sendt stop\r\n");
    } else {
        printf("Kunne ikke finde enhed\r\n");
    }

    printf("********************************\n\r");
}


/**
 End of File
*/