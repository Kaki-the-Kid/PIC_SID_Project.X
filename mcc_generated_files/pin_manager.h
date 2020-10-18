/**
  @Generated Pin Manager Header File

  @Company:
    Microchip Technology Inc.

  @File Name:
    pin_manager.h

  @Summary:
    This is the Pin Manager file generated using PIC10 / PIC12 / PIC16 / PIC18 MCUs

  @Description
    This header file provides APIs for driver for .
    Generation Information :
        Product Revision  :  PIC10 / PIC12 / PIC16 / PIC18 MCUs - 1.77
        Device            :  PIC18F26K22
        Driver Version    :  2.11
    The generated drivers are tested against the following:
        Compiler          :  XC8 2.05 and above
        MPLAB 	          :  MPLAB X 5.20	
*/

/*
    (c) 2018 Microchip Technology Inc. and its subsidiaries. 
    
    Subject to your compliance with these terms, you may use Microchip software and any 
    derivatives exclusively with Microchip products. It is your responsibility to comply with third party 
    license terms applicable to your use of third party software (including open source software) that 
    may accompany Microchip software.
    
    THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS". NO WARRANTIES, WHETHER 
    EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY 
    IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS 
    FOR A PARTICULAR PURPOSE.
    
    IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE, 
    INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND 
    WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP 
    HAS BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE FORESEEABLE. TO 
    THE FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL 
    CLAIMS IN ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT 
    OF FEES, IF ANY, THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS 
    SOFTWARE.
*/

#ifndef PIN_MANAGER_H
#define PIN_MANAGER_H

/**
  Section: Included Files
*/

#include <xc.h>

#define INPUT   1
#define OUTPUT  0

#define HIGH    1
#define LOW     0

#define ANALOG      1
#define DIGITAL     0

#define PULL_UP_ENABLED      1
#define PULL_UP_DISABLED     0

// get/set ch1_pos aliases
#define ch1_pos_TRIS                 TRISAbits.TRISA0
#define ch1_pos_LAT                  LATAbits.LATA0
#define ch1_pos_PORT                 PORTAbits.RA0
#define ch1_pos_ANS                  ANSELAbits.ANSA0
#define ch1_pos_SetHigh()            do { LATAbits.LATA0 = 1; } while(0)
#define ch1_pos_SetLow()             do { LATAbits.LATA0 = 0; } while(0)
#define ch1_pos_Toggle()             do { LATAbits.LATA0 = ~LATAbits.LATA0; } while(0)
#define ch1_pos_GetValue()           PORTAbits.RA0
#define ch1_pos_SetDigitalInput()    do { TRISAbits.TRISA0 = 1; } while(0)
#define ch1_pos_SetDigitalOutput()   do { TRISAbits.TRISA0 = 0; } while(0)
#define ch1_pos_SetAnalogMode()      do { ANSELAbits.ANSA0 = 1; } while(0)
#define ch1_pos_SetDigitalMode()     do { ANSELAbits.ANSA0 = 0; } while(0)

// get/set ch1_neg aliases
#define ch1_neg_TRIS                 TRISAbits.TRISA1
#define ch1_neg_LAT                  LATAbits.LATA1
#define ch1_neg_PORT                 PORTAbits.RA1
#define ch1_neg_ANS                  ANSELAbits.ANSA1
#define ch1_neg_SetHigh()            do { LATAbits.LATA1 = 1; } while(0)
#define ch1_neg_SetLow()             do { LATAbits.LATA1 = 0; } while(0)
#define ch1_neg_Toggle()             do { LATAbits.LATA1 = ~LATAbits.LATA1; } while(0)
#define ch1_neg_GetValue()           PORTAbits.RA1
#define ch1_neg_SetDigitalInput()    do { TRISAbits.TRISA1 = 1; } while(0)
#define ch1_neg_SetDigitalOutput()   do { TRISAbits.TRISA1 = 0; } while(0)
#define ch1_neg_SetAnalogMode()      do { ANSELAbits.ANSA1 = 1; } while(0)
#define ch1_neg_SetDigitalMode()     do { ANSELAbits.ANSA1 = 0; } while(0)

// get/set ch2_pos aliases
#define ch2_pos_TRIS                 TRISAbits.TRISA2
#define ch2_pos_LAT                  LATAbits.LATA2
#define ch2_pos_PORT                 PORTAbits.RA2
#define ch2_pos_ANS                  ANSELAbits.ANSA2
#define ch2_pos_SetHigh()            do { LATAbits.LATA2 = 1; } while(0)
#define ch2_pos_SetLow()             do { LATAbits.LATA2 = 0; } while(0)
#define ch2_pos_Toggle()             do { LATAbits.LATA2 = ~LATAbits.LATA2; } while(0)
#define ch2_pos_GetValue()           PORTAbits.RA2
#define ch2_pos_SetDigitalInput()    do { TRISAbits.TRISA2 = 1; } while(0)
#define ch2_pos_SetDigitalOutput()   do { TRISAbits.TRISA2 = 0; } while(0)
#define ch2_pos_SetAnalogMode()      do { ANSELAbits.ANSA2 = 1; } while(0)
#define ch2_pos_SetDigitalMode()     do { ANSELAbits.ANSA2 = 0; } while(0)

// get/set ch2_neg aliases
#define ch2_neg_TRIS                 TRISAbits.TRISA3
#define ch2_neg_LAT                  LATAbits.LATA3
#define ch2_neg_PORT                 PORTAbits.RA3
#define ch2_neg_ANS                  ANSELAbits.ANSA3
#define ch2_neg_SetHigh()            do { LATAbits.LATA3 = 1; } while(0)
#define ch2_neg_SetLow()             do { LATAbits.LATA3 = 0; } while(0)
#define ch2_neg_Toggle()             do { LATAbits.LATA3 = ~LATAbits.LATA3; } while(0)
#define ch2_neg_GetValue()           PORTAbits.RA3
#define ch2_neg_SetDigitalInput()    do { TRISAbits.TRISA3 = 1; } while(0)
#define ch2_neg_SetDigitalOutput()   do { TRISAbits.TRISA3 = 0; } while(0)
#define ch2_neg_SetAnalogMode()      do { ANSELAbits.ANSA3 = 1; } while(0)
#define ch2_neg_SetDigitalMode()     do { ANSELAbits.ANSA3 = 0; } while(0)

// get/set ch3_pos aliases
#define ch3_pos_TRIS                 TRISAbits.TRISA4
#define ch3_pos_LAT                  LATAbits.LATA4
#define ch3_pos_PORT                 PORTAbits.RA4
#define ch3_pos_SetHigh()            do { LATAbits.LATA4 = 1; } while(0)
#define ch3_pos_SetLow()             do { LATAbits.LATA4 = 0; } while(0)
#define ch3_pos_Toggle()             do { LATAbits.LATA4 = ~LATAbits.LATA4; } while(0)
#define ch3_pos_GetValue()           PORTAbits.RA4
#define ch3_pos_SetDigitalInput()    do { TRISAbits.TRISA4 = 1; } while(0)
#define ch3_pos_SetDigitalOutput()   do { TRISAbits.TRISA4 = 0; } while(0)

// get/set ch4_pos aliases
#define ch4_pos_TRIS                 TRISAbits.TRISA5
#define ch4_pos_LAT                  LATAbits.LATA5
#define ch4_pos_PORT                 PORTAbits.RA5
#define ch4_pos_ANS                  ANSELAbits.ANSA5
#define ch4_pos_SetHigh()            do { LATAbits.LATA5 = 1; } while(0)
#define ch4_pos_SetLow()             do { LATAbits.LATA5 = 0; } while(0)
#define ch4_pos_Toggle()             do { LATAbits.LATA5 = ~LATAbits.LATA5; } while(0)
#define ch4_pos_GetValue()           PORTAbits.RA5
#define ch4_pos_SetDigitalInput()    do { TRISAbits.TRISA5 = 1; } while(0)
#define ch4_pos_SetDigitalOutput()   do { TRISAbits.TRISA5 = 0; } while(0)
#define ch4_pos_SetAnalogMode()      do { ANSELAbits.ANSA5 = 1; } while(0)
#define ch4_pos_SetDigitalMode()     do { ANSELAbits.ANSA5 = 0; } while(0)

// get/set IO_g aliases
#define IO_g_TRIS                 TRISAbits.TRISA6
#define IO_g_LAT                  LATAbits.LATA6
#define IO_g_PORT                 PORTAbits.RA6
#define IO_g_SetHigh()            do { LATAbits.LATA6 = 1; } while(0)
#define IO_g_SetLow()             do { LATAbits.LATA6 = 0; } while(0)
#define IO_g_Toggle()             do { LATAbits.LATA6 = ~LATAbits.LATA6; } while(0)
#define IO_g_GetValue()           PORTAbits.RA6
#define IO_g_SetDigitalInput()    do { TRISAbits.TRISA6 = 1; } while(0)
#define IO_g_SetDigitalOutput()   do { TRISAbits.TRISA6 = 0; } while(0)

// get/set IO_dp aliases
#define IO_dp_TRIS                 TRISAbits.TRISA7
#define IO_dp_LAT                  LATAbits.LATA7
#define IO_dp_PORT                 PORTAbits.RA7
#define IO_dp_SetHigh()            do { LATAbits.LATA7 = 1; } while(0)
#define IO_dp_SetLow()             do { LATAbits.LATA7 = 0; } while(0)
#define IO_dp_Toggle()             do { LATAbits.LATA7 = ~LATAbits.LATA7; } while(0)
#define IO_dp_GetValue()           PORTAbits.RA7
#define IO_dp_SetDigitalInput()    do { TRISAbits.TRISA7 = 1; } while(0)
#define IO_dp_SetDigitalOutput()   do { TRISAbits.TRISA7 = 0; } while(0)

// get/set DAC0 aliases
#define DAC0_TRIS                 TRISBbits.TRISB0
#define DAC0_LAT                  LATBbits.LATB0
#define DAC0_PORT                 PORTBbits.RB0
#define DAC0_WPU                  WPUBbits.WPUB0
#define DAC0_ANS                  ANSELBbits.ANSB0
#define DAC0_SetHigh()            do { LATBbits.LATB0 = 1; } while(0)
#define DAC0_SetLow()             do { LATBbits.LATB0 = 0; } while(0)
#define DAC0_Toggle()             do { LATBbits.LATB0 = ~LATBbits.LATB0; } while(0)
#define DAC0_GetValue()           PORTBbits.RB0
#define DAC0_SetDigitalInput()    do { TRISBbits.TRISB0 = 1; } while(0)
#define DAC0_SetDigitalOutput()   do { TRISBbits.TRISB0 = 0; } while(0)
#define DAC0_SetPullup()          do { WPUBbits.WPUB0 = 1; } while(0)
#define DAC0_ResetPullup()        do { WPUBbits.WPUB0 = 0; } while(0)
#define DAC0_SetAnalogMode()      do { ANSELBbits.ANSB0 = 1; } while(0)
#define DAC0_SetDigitalMode()     do { ANSELBbits.ANSB0 = 0; } while(0)

// get/set DAC1 aliases
#define DAC1_TRIS                 TRISBbits.TRISB1
#define DAC1_LAT                  LATBbits.LATB1
#define DAC1_PORT                 PORTBbits.RB1
#define DAC1_WPU                  WPUBbits.WPUB1
#define DAC1_ANS                  ANSELBbits.ANSB1
#define DAC1_SetHigh()            do { LATBbits.LATB1 = 1; } while(0)
#define DAC1_SetLow()             do { LATBbits.LATB1 = 0; } while(0)
#define DAC1_Toggle()             do { LATBbits.LATB1 = ~LATBbits.LATB1; } while(0)
#define DAC1_GetValue()           PORTBbits.RB1
#define DAC1_SetDigitalInput()    do { TRISBbits.TRISB1 = 1; } while(0)
#define DAC1_SetDigitalOutput()   do { TRISBbits.TRISB1 = 0; } while(0)
#define DAC1_SetPullup()          do { WPUBbits.WPUB1 = 1; } while(0)
#define DAC1_ResetPullup()        do { WPUBbits.WPUB1 = 0; } while(0)
#define DAC1_SetAnalogMode()      do { ANSELBbits.ANSB1 = 1; } while(0)
#define DAC1_SetDigitalMode()     do { ANSELBbits.ANSB1 = 0; } while(0)

// get/set DAC2 aliases
#define DAC2_TRIS                 TRISBbits.TRISB2
#define DAC2_LAT                  LATBbits.LATB2
#define DAC2_PORT                 PORTBbits.RB2
#define DAC2_WPU                  WPUBbits.WPUB2
#define DAC2_ANS                  ANSELBbits.ANSB2
#define DAC2_SetHigh()            do { LATBbits.LATB2 = 1; } while(0)
#define DAC2_SetLow()             do { LATBbits.LATB2 = 0; } while(0)
#define DAC2_Toggle()             do { LATBbits.LATB2 = ~LATBbits.LATB2; } while(0)
#define DAC2_GetValue()           PORTBbits.RB2
#define DAC2_SetDigitalInput()    do { TRISBbits.TRISB2 = 1; } while(0)
#define DAC2_SetDigitalOutput()   do { TRISBbits.TRISB2 = 0; } while(0)
#define DAC2_SetPullup()          do { WPUBbits.WPUB2 = 1; } while(0)
#define DAC2_ResetPullup()        do { WPUBbits.WPUB2 = 0; } while(0)
#define DAC2_SetAnalogMode()      do { ANSELBbits.ANSB2 = 1; } while(0)
#define DAC2_SetDigitalMode()     do { ANSELBbits.ANSB2 = 0; } while(0)

// get/set DAC3 aliases
#define DAC3_TRIS                 TRISBbits.TRISB3
#define DAC3_LAT                  LATBbits.LATB3
#define DAC3_PORT                 PORTBbits.RB3
#define DAC3_WPU                  WPUBbits.WPUB3
#define DAC3_ANS                  ANSELBbits.ANSB3
#define DAC3_SetHigh()            do { LATBbits.LATB3 = 1; } while(0)
#define DAC3_SetLow()             do { LATBbits.LATB3 = 0; } while(0)
#define DAC3_Toggle()             do { LATBbits.LATB3 = ~LATBbits.LATB3; } while(0)
#define DAC3_GetValue()           PORTBbits.RB3
#define DAC3_SetDigitalInput()    do { TRISBbits.TRISB3 = 1; } while(0)
#define DAC3_SetDigitalOutput()   do { TRISBbits.TRISB3 = 0; } while(0)
#define DAC3_SetPullup()          do { WPUBbits.WPUB3 = 1; } while(0)
#define DAC3_ResetPullup()        do { WPUBbits.WPUB3 = 0; } while(0)
#define DAC3_SetAnalogMode()      do { ANSELBbits.ANSB3 = 1; } while(0)
#define DAC3_SetDigitalMode()     do { ANSELBbits.ANSB3 = 0; } while(0)

// get/set DAC4 aliases
#define DAC4_TRIS                 TRISBbits.TRISB4
#define DAC4_LAT                  LATBbits.LATB4
#define DAC4_PORT                 PORTBbits.RB4
#define DAC4_WPU                  WPUBbits.WPUB4
#define DAC4_ANS                  ANSELBbits.ANSB4
#define DAC4_SetHigh()            do { LATBbits.LATB4 = 1; } while(0)
#define DAC4_SetLow()             do { LATBbits.LATB4 = 0; } while(0)
#define DAC4_Toggle()             do { LATBbits.LATB4 = ~LATBbits.LATB4; } while(0)
#define DAC4_GetValue()           PORTBbits.RB4
#define DAC4_SetDigitalInput()    do { TRISBbits.TRISB4 = 1; } while(0)
#define DAC4_SetDigitalOutput()   do { TRISBbits.TRISB4 = 0; } while(0)
#define DAC4_SetPullup()          do { WPUBbits.WPUB4 = 1; } while(0)
#define DAC4_ResetPullup()        do { WPUBbits.WPUB4 = 0; } while(0)
#define DAC4_SetAnalogMode()      do { ANSELBbits.ANSB4 = 1; } while(0)
#define DAC4_SetDigitalMode()     do { ANSELBbits.ANSB4 = 0; } while(0)

// get/set DAC5 aliases
#define DAC5_TRIS                 TRISBbits.TRISB5
#define DAC5_LAT                  LATBbits.LATB5
#define DAC5_PORT                 PORTBbits.RB5
#define DAC5_WPU                  WPUBbits.WPUB5
#define DAC5_ANS                  ANSELBbits.ANSB5
#define DAC5_SetHigh()            do { LATBbits.LATB5 = 1; } while(0)
#define DAC5_SetLow()             do { LATBbits.LATB5 = 0; } while(0)
#define DAC5_Toggle()             do { LATBbits.LATB5 = ~LATBbits.LATB5; } while(0)
#define DAC5_GetValue()           PORTBbits.RB5
#define DAC5_SetDigitalInput()    do { TRISBbits.TRISB5 = 1; } while(0)
#define DAC5_SetDigitalOutput()   do { TRISBbits.TRISB5 = 0; } while(0)
#define DAC5_SetPullup()          do { WPUBbits.WPUB5 = 1; } while(0)
#define DAC5_ResetPullup()        do { WPUBbits.WPUB5 = 0; } while(0)
#define DAC5_SetAnalogMode()      do { ANSELBbits.ANSB5 = 1; } while(0)
#define DAC5_SetDigitalMode()     do { ANSELBbits.ANSB5 = 0; } while(0)

// get/set DAC6 aliases
#define DAC6_TRIS                 TRISBbits.TRISB6
#define DAC6_LAT                  LATBbits.LATB6
#define DAC6_PORT                 PORTBbits.RB6
#define DAC6_WPU                  WPUBbits.WPUB6
#define DAC6_SetHigh()            do { LATBbits.LATB6 = 1; } while(0)
#define DAC6_SetLow()             do { LATBbits.LATB6 = 0; } while(0)
#define DAC6_Toggle()             do { LATBbits.LATB6 = ~LATBbits.LATB6; } while(0)
#define DAC6_GetValue()           PORTBbits.RB6
#define DAC6_SetDigitalInput()    do { TRISBbits.TRISB6 = 1; } while(0)
#define DAC6_SetDigitalOutput()   do { TRISBbits.TRISB6 = 0; } while(0)
#define DAC6_SetPullup()          do { WPUBbits.WPUB6 = 1; } while(0)
#define DAC6_ResetPullup()        do { WPUBbits.WPUB6 = 0; } while(0)

// get/set DAC7 aliases
#define DAC7_TRIS                 TRISBbits.TRISB7
#define DAC7_LAT                  LATBbits.LATB7
#define DAC7_PORT                 PORTBbits.RB7
#define DAC7_WPU                  WPUBbits.WPUB7
#define DAC7_SetHigh()            do { LATBbits.LATB7 = 1; } while(0)
#define DAC7_SetLow()             do { LATBbits.LATB7 = 0; } while(0)
#define DAC7_Toggle()             do { LATBbits.LATB7 = ~LATBbits.LATB7; } while(0)
#define DAC7_GetValue()           PORTBbits.RB7
#define DAC7_SetDigitalInput()    do { TRISBbits.TRISB7 = 1; } while(0)
#define DAC7_SetDigitalOutput()   do { TRISBbits.TRISB7 = 0; } while(0)
#define DAC7_SetPullup()          do { WPUBbits.WPUB7 = 1; } while(0)
#define DAC7_ResetPullup()        do { WPUBbits.WPUB7 = 0; } while(0)

// get/set IO_disp1 aliases
#define IO_disp1_TRIS                 TRISCbits.TRISC0
#define IO_disp1_LAT                  LATCbits.LATC0
#define IO_disp1_PORT                 PORTCbits.RC0
#define IO_disp1_SetHigh()            do { LATCbits.LATC0 = 1; } while(0)
#define IO_disp1_SetLow()             do { LATCbits.LATC0 = 0; } while(0)
#define IO_disp1_Toggle()             do { LATCbits.LATC0 = ~LATCbits.LATC0; } while(0)
#define IO_disp1_GetValue()           PORTCbits.RC0
#define IO_disp1_SetDigitalInput()    do { TRISCbits.TRISC0 = 1; } while(0)
#define IO_disp1_SetDigitalOutput()   do { TRISCbits.TRISC0 = 0; } while(0)

// get/set IO_disp2 aliases
#define IO_disp2_TRIS                 TRISCbits.TRISC1
#define IO_disp2_LAT                  LATCbits.LATC1
#define IO_disp2_PORT                 PORTCbits.RC1
#define IO_disp2_SetHigh()            do { LATCbits.LATC1 = 1; } while(0)
#define IO_disp2_SetLow()             do { LATCbits.LATC1 = 0; } while(0)
#define IO_disp2_Toggle()             do { LATCbits.LATC1 = ~LATCbits.LATC1; } while(0)
#define IO_disp2_GetValue()           PORTCbits.RC1
#define IO_disp2_SetDigitalInput()    do { TRISCbits.TRISC1 = 1; } while(0)
#define IO_disp2_SetDigitalOutput()   do { TRISCbits.TRISC1 = 0; } while(0)

// get/set RC6 procedures
#define RC6_SetHigh()            do { LATCbits.LATC6 = 1; } while(0)
#define RC6_SetLow()             do { LATCbits.LATC6 = 0; } while(0)
#define RC6_Toggle()             do { LATCbits.LATC6 = ~LATCbits.LATC6; } while(0)
#define RC6_GetValue()              PORTCbits.RC6
#define RC6_SetDigitalInput()    do { TRISCbits.TRISC6 = 1; } while(0)
#define RC6_SetDigitalOutput()   do { TRISCbits.TRISC6 = 0; } while(0)
#define RC6_SetAnalogMode()         do { ANSELCbits.ANSC6 = 1; } while(0)
#define RC6_SetDigitalMode()        do { ANSELCbits.ANSC6 = 0; } while(0)

// get/set RC7 procedures
#define RC7_SetHigh()            do { LATCbits.LATC7 = 1; } while(0)
#define RC7_SetLow()             do { LATCbits.LATC7 = 0; } while(0)
#define RC7_Toggle()             do { LATCbits.LATC7 = ~LATCbits.LATC7; } while(0)
#define RC7_GetValue()              PORTCbits.RC7
#define RC7_SetDigitalInput()    do { TRISCbits.TRISC7 = 1; } while(0)
#define RC7_SetDigitalOutput()   do { TRISCbits.TRISC7 = 0; } while(0)
#define RC7_SetAnalogMode()         do { ANSELCbits.ANSC7 = 1; } while(0)
#define RC7_SetDigitalMode()        do { ANSELCbits.ANSC7 = 0; } while(0)

/**
   @Param
    none
   @Returns
    none
   @Description
    GPIO and peripheral I/O initialization
   @Example
    PIN_MANAGER_Initialize();
 */
void PIN_MANAGER_Initialize (void);

/**
 * @Param
    none
 * @Returns
    none
 * @Description
    Interrupt on Change Handling routine
 * @Example
    PIN_MANAGER_IOC();
 */
void PIN_MANAGER_IOC(void);



#endif // PIN_MANAGER_H
/**
 End of File
*/