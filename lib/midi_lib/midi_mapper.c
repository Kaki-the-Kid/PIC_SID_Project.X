#include "../../mcc_generated_files/mcc.h"
#include <string.h>

#ifndef MIDI_MAPPER_H
#include "midi_mapper.h"
#include "../../music/hex/Super_Mario_Bros._Theme_midi.h"
#endif

//#include "Super_Mario_Bros._Theme_midi.h"

/* The melody midi data is in Super_Mario_Bros._Theme_midi.h
 */
void midiFileParse(void) {
    char buffer[64]; //For sprintf
    
    /* 
     * Passing header data
     */

    // MThd
    char midi_header[4];
    extractElements(rawData, midi_header, 4); // 4D 54 68 64
    
    if( strncmp(midi_header, "MThd", 4) ){ //strcmp returns 0 if match
        printf("Error: Not valid Midi Header\r\n", midi_header);
    } else {
        printf("Midi Header: %s\r\n", midi_header);
    }
    
    //break;
    //return 0;
    
    // dword: Header size = 6
    char midi_header_size[6];
    extractElements(rawData, midi_header_size, 4); // 00 00 00 06
    if( atoi(midi_header_size)!=6 )
        printf("Midi Header Size: %d\r\n", atoi(midi_header_size) );
    else
        printf("Midi Header Size: %d\r\n", atoi(midi_header_size) );
    
    // word: Typefile format size = 0-2
    // 0 - the file contains a single multi-channel track
    // 1 - the file contains one or more simultaneous tracks (or MIDI outputs) of a sequence
    // 2 - the file contains one or more sequentially independent single-track patterns
    char midi_header_typefile[2];
    extractElements(rawData, midi_header_typefile, 2); // 00 01
    printf("Midi Header Size: %d\r\n", atoi(midi_header_typefile) );
    
    // word: Number of tracks = 1-65535
    char midi_header_number_tracks[2];
    extractElements(rawData, midi_header_number_tracks, 2); // 00 01
    printf("Midi Header Size: %d\r\n", atoi(midi_header_number_tracks) );

    /*
     * word: Resolution = 1-65535
     * The third word, <division>, specifies the meaning of the delta-times. It has two formats, 
     * one for metrical time, and one for time-code-based time:
     * 
     * +-----------+-------------------------+----------------------+
     * |  bit 15   |      bits 14 thru 8	 |     bits 7 thru 0    |
     * +-----------+-------------------------+----------------------+            
     * |     0	   |  ticks per quarter-note                        |
     * +----------´+-------------------------+----------------------+
     * |     1	   |  negative SMPTE format  |    ticks per frame   |
     * +-----------+-------------------------+----------------------+
     */
    char midi_header_resolution[2];
    extractElements(rawData, midi_header_resolution, 2); //01 E0
    /* Mask bit15 delta_times_meaning
     * If bit 15 of <division> is zero, the bits 14 thru 0 represent the number of delta time "ticks" 
     * which make up a quarter-note. For instance, if division is 96, then a time interval of an 
     * eighth-note between two events in the file would be 48.
     */
    //[TODO] unmask bit 15 -> delta_times_meaning
//    if(uint8_t delta_times_meaning=1) {
//        uint16_t ticks_per_quarter_note = atoi(midi_header_resolution); // [TODO] unmask bit15
    /*
     * If bit 15 of <division> is a one, delta times in a file correspond to subdivisions of a second, 
     * in a way consistent with SMPTE and MIDI Time Code. 
     */
//    } else {
        /* Bits 14 thru 8 contain one of the four values 
         * -24, -25, -29, or -30, corresponding to the four standard SMPTE and MIDI Time Code 
         * formats (-29 corresponds to 30 drop frame), and represents the number of frames per second. 
         * These negative numbers are stored in two's compliment form. 
         */
        //[TODO] Unamsk bit14-8
        
        /* The second byte (stored positive) is the resolution 
         * within a frame: typical values may be 4 (MIDI Time Code resolution), 8, 10, 80 (bit resolution), 
         * or 100. This stream allows exact specifications of time-code-based tracks, but also allows 
         * millisecond-based tracks by specifying 25 frames/sec and a resolution of 40 units per frame. 
         * If the events in a file are stored with a bit resolution of thirty-frame time code, the division 
         * word would be E250 hex. */
        //[TODO]]
//    }
        
    printf("Midi Header Size: %d\r\n", atoi(midi_header_resolution  ) );
    
    

    
    /* 
     * Passing the track data 
     */
    
    // char[4]: "MTrk"
    char midi_data_trackid[4];
    extractElements(rawData, midi_data_trackid, 4); // 4D 54 72 6B
    if ( strncmp(midi_data_trackid,"MTrk", 4) ) {
        printf( "Error: Nor valid Midi Track Id\r\n" );
    } else {
        printf( "Midi Track Id: %s\r\n", midi_data_trackid );
    }
    

    // dword: Size track
    char midi_data_sizetrack[4];
    extractElements(rawData, midi_data_sizetrack, 4) ; //00 00 0A A3
    printf("Midi Header Size: %d\r\n", atoi(midi_data_sizetrack  ) );
    
    // 00<-Delta-time
    // FF <- Midi event, 08  <- Event type, 18 <- Length of message
    // $1A-$33: 53 75 70 65 72 20 4D 61 72 69 6F 20 42 72 6F 73 2E 20 54 68 65 6D 65 00 00
    // Super Mario Bros. Theme, 00
    
    // 00<-Delta-time
    // FF <- Midi event, 0A <- Event type, 1C <- Length of message
    // $36-$51: 4B 6F 6A 69 20 4B 6F 6E 64 6F 0A 74 72 61 6E 73 2E 20 53 74 65 6C 6C 61 20 4C 75 00 00
    // Koji Kondo trans. Stella Lu, 00, 
    
    // 00<-Delta-time
    // FF <- Midi event, 58 <- Event type (time signature), 04 <- Length of message
    // 04 02 18 08 
    
    // 00<-Delta-time, C0 28
    
    // 00 90 4C 50
    
    //
}

/*
 */
void extractElements(char const *srcArray, char *subArray, uint8_t n)
{
    /* initialize elements of array n to 0 */
    for (int i = 0; i < n; i++)
    {
//        subArray[i] = srcArray[i + midiindex++];
    }
}

void WriteVarLen(uint32_t value) {
    uint32_t buffer;
    
    buffer = value & 0x7f;

    while ((value >>= 7) > 0) {
        buffer <<= 8;
        buffer |= 0x80;
        buffer += (value & 0x7f);
    }
//    while (1) {
//        putc(buffer, outfile);
//        if (buffer & 0x80)
//            buffer >>= 8;
//        else
//            break;
//    }
}

uint32_t doublewordReadVarLen(void) {
    uint32_t value;
//    uint8_t bytec;
//    
//    if ((value = getc(infile))&0x80) {
//        value &= 0x7f;
//        do {
//            value = (value << 7)+((c = getc(infile)))&0x7f);
//        } while (c & 0x80);
//    }
    
    return (value);
}

static void mferror(char *s);

static int readmt(s)		/* read through the "MThd" or "MTrk" header string */
char *s;
{
	int n = 0;
	char *p = s;
	int c;

//	while ( n++<4 && (c=(*Mf_getc)()) != EOF ) {
//		if ( c != *p++ ) {
//			char buff[32];
//			(void) strcpy(buff,"expecting ");
//			(void) strcat(buff,s);
//			mferror(buff);
//		}
//	}
	return(c);
}


static long to32bit(c1,c2,c3,c4)
int c1, c2, c3, c4;
{
	long value = 0L;

	value = (c1 & 0xff);
	value = (value<<8) + (c2 & 0xff);
	value = (value<<8) + (c3 & 0xff);
	value = (value<<8) + (c4 & 0xff);
	return (value);
}

static int to16bit(c1,c2)
int c1, c2;
{
	return ((c1 & 0xff ) << 8) + (c2 & 0xff);
}

static long read32bit()
{
	int c1, c2, c3, c4;

	//c1 = egetc();
	//c2 = egetc();
	//c3 = egetc();
	//c4 = egetc();
	return to32bit(c1,c2,c3,c4);
}

static int read16bit()
{
	int c1, c2;
	//c1 = egetc();
	//c2 = egetc();
	return to16bit(c1,c2);
}

static int egetc()			/* read a single character and abort on EOF */
{
	int c = (*Mf_getc)();

//	if ( c == EOF )
//		mferror("premature EOF");
	//Mf_toberead--;
	return(c);
}