/* ***********************************************************************
 *
 * Programa que faz um PIC reproduzir sons utilizando PWM
 *
 * O som está codificado em PCM, com 8 bits por amostra e com frequencia
 * de amostragem entre 8000Hz e 11025Hz. Frequencias superiores diminuem
 * o numero de bits de resolução do PWM. (Quase 8 bits para 8000Hz e 
 * um pouco menos para 11000Hz)
 *
 * Para utilizar este programa com outros sons é necessário gerar um
 * ficheiro .h que contenha as amostras no formato const char samples[] ou
 * const int samples[] caso se trate de 8 ou 16 bits respectivamente.
 * 
 * Este ficheiro a partir de um WAV, utilizando o Linux MPLayer e o PCM2H.
 * 
 * A ordem é:
 *   Arranjar o WAV no formato apropriado (ex: 8bits, 8000Hz, mono)
 *   Gerar ficheiro PCM retirando o cabeçalho ao WAV
 *     (ex: mplayer ficheiro.wav -ao pcm:nowaveheader:file=ficheiro.pcm)
 *   Gerar o ficheiro H a partir do PCM com o programa PCM2H e indicar o
 *   numero de bits por amostra
 *     (ex: pcm2h ficheiro.pcm ficheiro.h)
 *   Já está!
 *
 * ***********************************************************************
 *
 * Este programa diz OKAY de 4 em 4 segundos
 *
 * O som provém do CD MIDI & WAVE WORKSHOP da PowerSource
 *
 */
//#include    <pic18.h>
#include "../../mcc_generated_files/mcc.h"


#define FOSC	8000000UL
#define T2_FREQ	(11000)		// Entre 8000Hz e 11025Hz
#define K_TMR2	 (FOSC/4)/(T2_FREQ) 

#define ON  1
#define OFF 0

#include"ok.h"

// --------------------------------------------------------------------------
// Configuração dos bits do uP
//
__CONFIG(1, IESODIS & FCMDIS & RCIO);
__CONFIG(2, PWRTEN & BORDIS & WDTDIS);
__CONFIG(4, STVREN & DEBUGDIS & LVPDIS);
//__CONFIG(5, CPA & CPB);

// --------------------------------------------------------------------------
// Variaveis globais
//
unsigned char sample;
volatile int wait;


// --------------------------------------------------------------------------
// Inicialização de todos os pinos e perifericos
//
void initPic(void)
{
	GIE = 0;			// Desliga as interrupcoes
	OSCCON = 0xF2;		// Oscilador a 8MHz RC INT com IDLE MODE

	/* RB7=1 
	 * RB6=1
	 * RB5=1
	 * RB4=1
	 * RB3=0 speaker e 470R
	 * RB2=1 
	 * RB1=1
	 * RB0=1
	 * 0xF7
	 */
	TRISB = 0xF7;

	/* PCFG7=0	NAO EXISTE ESTE BIT
	 * PCFG6=1 RB4
	 * PCFG5=1 RB1
	 * PCFG4=1 RB0
	 * PCFG3=1 RA3
	 * PCFG2=1 RA2
	 * PCFG1=1 RA1
	 * PCFG0=1 RA0	
	 * 0x7F
	 */
	ADCON1 = 0x7F;

	
	// Timer 2 sem interrupção (apenas gera periodo para PWM do CCP)
	T2CON = 0x00;	// Timer 2 off, FOSC/4, pre 1:1, post 1:1
	PR2  = K_TMR2;	// Carrega valor de comparação (periodo do PWM)
	TMR2IF= 0;		// Limpa a flag
	TMR2IE= 1;		// Permite interrupções (nao necessario para o PWM via ccp)
	TMR2ON= 1;		// Liga o timer

	/* CCP para desligar o som
	 * P1M1=  0
	 * P1M0=  0  single output P1A for PWM mode
	 * DC1B1= 0
	 * DC1B0= 0  lsb of pwm duty cycle (ver no valor inicial abaixo)
	 * CCP1M3=1
	 * CCP1M2=1
	 * CCP1M1=0
	 * CCP1M0=0  PWM mode all active high
	 *
	 */
	CCP1CON = 0x0C;

	// valor inicial do PWM
	CCPR1L=0;	// 8bits
	DC1B1=0;
	DC1B0=0;	// restantes 2 bits
	
	PEIE = 1;			// Enable Low Priority Interrupts
	GIE=1;				// Enable High Priority Interrupts
}


// --------------------------------------------------------------------------
//
//#pragma interrupt_level 0
void interrupt hi_isr(void)
{
	if(TMR2IF)
	{
		if(wait) wait--;

		TMR2IF = 0;
	}
}


void setPWM(unsigned char sample)
{
	CCPR1L = sample >> 2;
	DC1B1 = (sample&0x02)>>1;
	DC1B0 = (sample&0x01);
}


void play(const char *sound, int size)
{
	int i;
	for(i=0; i<size; i++)
	{
		setPWM(sound[i]);
		wait=1;
		while(wait);
	}
}
		
void pause(int cycles)
{
	setPWM(0);
	wait=cycles;
	while(wait);
}

// --------------------------------------------------------------------------
//
void main(void)
{

	initPic();

	while(1)
	{
		// sincroniza com o inicio do PWM
		wait=1;
		while(wait);

		// Fala happy birthday
		play(okay, 5399);
		
		// Pausa 4seg
		pause(32000);
	}

	while(1);
}

