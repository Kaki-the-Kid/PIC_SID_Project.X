/****************************************************************************
 * Undersøgelse af de forskellige måder at lave lyd på PIC kreds
 *
 ****************************************************************************
 *
 * Dette er hovedfilen som kÃ¸rer forskellige mÃ¥der at frembringe lyd pÃ¥
 *
*/

#include "mcc_generated_files/mcc.h"
//#include <stdio.h>
//#include <string.h>

#include "lib/i2c_lib/i2c_lib.h"
#include "lib/music_lib/music.h"
#include "lib/sid_lib/sid_pic.h"
#include "lib/midi_lib/midi_mapper.h"

//Global vars


//Prototype
void toneController(void);
void endTone(void);


/*
                         Main application
 */
void main(void)
{
    // Initialize the device
    SYSTEM_Initialize();
    INTERRUPT_GlobalInterruptEnable();
    INTERRUPT_PeripheralInterruptEnable();
    EUSART1_Initialize();
    i2c_init();
    musicPlayerInit();


    loop();

    while (1)
    {
        //__delay_ms(3000);
        //printf("Starting music\r\n");
        //loop();
    }
}


void toneController(void)
{
    ch1_pos_Toggle();
}

void endTone(void) {
    TMR6_StopTimer();
}

/**
 End of File
*/