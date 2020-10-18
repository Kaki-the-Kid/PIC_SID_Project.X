#include "../../mcc_generated_files/mcc.h"


#ifndef MUSIC_H
    #include "music.h"
#endif

#ifndef MUSIC_NOTES_H
    #include "music_notes.h"
#endif

void setup(void) {
    //pinMode(speakerOut, OUTPUT);
    //Serial.begin(9600); // Set serial out if we want debugging
}


void musicPlayerInit(void) {
    //Set the timers for controlling the pins (like PWM))
    //TMR4_SetInterruptHandler(toneController);
    //TMR6_SetInterruptHandler(endTone);
    
    //Reset the output pins
    ch1_neg_SetLow();
    ch2_neg_SetLow();
    ch2_neg_SetLow();
}




// PLAY TONE  //
// Pulse the speaker to play a tone for a particular duration

void playTone(void) {
    printf("Enter playTone(): toneM=%u\r\n",toneM);
    long elapsed_time = 0;
    
    // if this isn't a Rest beat
    if (toneM > 0) {
        TMR4_INTERRUPT_TICKER_FACTOR = toneM / 20;
        
        TMR4_StartTimer();
        
        while (elapsed_time < beat) {
            elapsed_time++; // (toneM);
            __delay_us(tempo);
        }
        
        TMR4_StopTimer();
    } else { // Rest beat; loop times delay
        while (elapsed_time < beat) {
            elapsed_time++;
            __delay_us(tempo);
        }
    }
}

// LOOP //
void loop(void) {
    if (select == 1) {
        // Set up a counter to pull from melody[] and beats[]
        for (uint8_t i = 0; i < 36; i++) {
            toneM = melody1[i];
            beat = beats1[i];

            playTone(); // A pause between notes
            printf("pause=%d\r\n",pause);
            __delay_ms(pause);// delayMicroseconds(pause);
        }
    } else if (select == 2) {
        for (uint8_t i = 0; i < 19; i++) {
            toneM = melody2[i];
            beat = beats2[i];

            playTone(); // A pause between notes
            __delay_ms(pause);//delayMicroseconds(pause);
        }
    } else if (select == 3) {
        for (uint8_t i = 0; i < 55; i++) {
            toneM = melody3[i];
            beat = beats3[i];

            playTone(); // A pause between notes
            __delay_ms(pause);//delayMicroseconds(pause);
        }
    }  else if (select == 4) {
        //tempo = 3500;
        for (uint8_t i = 0; i < 170; i++) {
            toneM = melody4[i];
            beat = beats4[i];
            beat /= 1.4;

            playTone(); // A pause between notes
            __delay_ms(pause);//delayMicroseconds(pause);
        }
    } else if (select == 5) {
    }
}