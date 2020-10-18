/* 
 * File:   music.h
 * Author: krs
 *
 * Created on February 11, 2020, 1:21 PM
 */

#ifndef MUSIC_H
#define	MUSIC_H

#ifndef MUSIC_NOTES_H
    #include "music_notes.h"
#endif

#ifndef MIDI_MAPPER_H
    #include "../midi_lib/midi_mapper.h"
#endif



// * Star Wars Song Selector
// * Original Composition : Star Wars
// * Composed by : I do not know
// * Coded By : https://code.google.com/p/rbots/source/browse/trunk/StarterKit/Lesson5_PiezoPlayMelody/Lesson5_PiezoPlayMelody.pde
// * Use BSD Clause 2 License for Distribution
// * Collection by GitHub User @abhishekghosh - https://github.com/AbhishekGhosh/Arduino-Buzzer-Tone-Codes
// * Program to choose between two melodies by using a potentiometer and a piezo buzzer.
 
 
// SETUP //
 
//#define sound_out = RB5;    // Set up speaker on digital pin 7
//uint8_t potPin = RB5;      // Set up potentiometer on analogue pin 0.

//Prototypes
void musicPlayerInit(void);
void setup(void);
void playTone(void);
void loop(void);
void delayMicroseconds(uint32_t);

//}
 
// MELODIES and TIMING //
//  melody[] is an array of notes, accompanied by beats[], 
//  which sets each note's relative length (higher #, longer note) 
 
// Melody 1: Star Wars Imperial March
const uint16_t melody1[] = {  a4, R,  a4, R,  a4, R,  f4, R, c5, R,  a4, R,  f4, R, c5, R, a4, R,  e5, R,  e5, R,  e5, R,  f5, R, c5, R,  g5, R,  f5, R,  c5, R, a4, R};
const uint8_t  beats1[]  = {  50, 20, 50, 20, 50, 20, 40, 5, 20, 5,  60, 10, 40, 5, 20, 5, 60, 80, 50, 20, 50, 20, 50, 20, 40, 5, 20, 5,  60, 10, 40, 5,  20, 5, 60, 40};
 
// Melody 2: Star Wars Theme
const uint16_t melody2[] = {  f4, f4, f4, a4s, f5,  d5s, d5,  c5, a5s, f5, d5s,  d5,  c5, a5s, f5, d5s, d5, d5s, c5};
const uint8_t  beats2[]  = {  21, 21, 21, 128, 128, 21,  21,  21, 128, 64,  21,  21,  21, 128, 64,  21, 21,  21, 128 }; 

// Melody 3: Mario Theme Song firstSection
const uint16_t melody3[] = {  a4,  a4,   a4,   f4,   c5,  a4,   f4,   c5,  a4,   R,   e5,  e5,  e5,  f5,  c5,  g4s,  f4,   c5,  a4,   R,   f4,   g4s,  f4,   a4,   c5,  a4,   c5,  e5,  R,   f4,   g4s,  f4,   c5,  a4,   f4,   c5,  a4,   R,   a5,  a4,   a4,   a5,  g5s, g5,  f5s, f5,  f5s, R,   a4s,  d5s, d5,  c5s, c5,  a4s,   c5};
const uint8_t  beats3[]  = {  50, 50, 50, 35, 15, 50, 35, 15, 65, 50, 50, 50, 50, 35, 15, 50, 35, 15, 65, 50, 25, 50, 35, 12, 50, 37, 12, 65, 50, 25, 50, 37, 12, 50, 37, 12, 65, 65, 50, 30, 15, 50, 32, 17, 12, 12, 25, 32, 25, 50, 32, 17, 12, 12, 25};


// Melody 4:
const uint16_t melody4[] = { e4, R,  d4s, R,  e4, R,  d4s, R,  e4, R,  b3, R,  d4, R,  c4, R,  a3, R,   d3, R,  f3, R,  a3, R,  b3, R,   f3, R,  a3s, R,  b3, R,  c4, R,   R,  e4, R,  d4s, R,  e4, R,  d4s, R,  e4, R,  b3, R,  d4, R,  c4, R,  a3, R,   d3, R,  f3, R,  a3, R,  b3, R,   f3, R,  c4, R,  b3, R,  a3, R,   b3, R,  c4, R,  d4, R,  e4, R,   g3, R,  f4, R,  e4, R,  d4, R,   e3, R,  e4, R,  d4, R,  c4, R,   d3, R,  d4, R,  c4, R,  b3, R,   R,  e4, R,  d4s, R,  e4, R,  d4s, R,  e4, R,  b3, R,  d4, R,  c4, R,  a3, R,   d3, R,  f3, R,  a3, R,  b3, R,   f3, R,  a3, R,  b3, R,  c4, R,   R,  e4, R,  d4s, R,  e4, R,  d4s, R,  e4, R,  b3, R,  d4, R,  c4, R,  a3, R,   d3, R,  f3, R,  a3, R,  b3, R,   f3, R,  c4, R,  b3, R,  a3 };
const uint8_t  beats4[]  = { 30, 35, 30,  35, 30, 35, 30,  35, 30, 35, 30, 40, 30, 40, 30, 40, 90, 100, 30, 35, 30, 40, 30, 40, 90, 100, 30, 40, 30,  40, 30, 40, 90, 100, 30, 30, 40, 30,  40, 30, 40, 30,  40, 30, 40, 30, 40, 30, 40, 30, 40, 90, 100, 30, 40, 30, 40, 30, 40, 90, 100, 30, 40, 30, 40, 30, 40, 90, 100, 30, 40, 30, 40, 30, 40, 90, 100, 30, 40, 30, 40, 30, 40, 90, 100, 30, 40, 30, 40, 30, 40, 90, 100, 30, 40, 30, 40, 30, 40, 90, 100, 40, 30, 40, 30,  35, 30, 35, 30,  35, 30, 35, 30, 40, 30, 40, 30, 40, 90, 100, 30, 35, 30, 40, 30, 40, 90, 100, 30, 40, 30, 40, 30, 40, 90, 100, 30, 30, 40, 30,  40, 30, 40, 30,  40, 30, 40, 30, 40, 30, 40, 30, 40, 90, 100, 30, 40, 30, 40, 30, 40, 90, 100, 30, 40, 30, 40, 30, 40, 90 };

const uint16_t tempo = 4000;   // Set overall tempo
short    pause = 0;            // Set length of pause between notes
uint8_t  rest_count = 50;      // Loop variable to increase Rest length (BLETCHEROUS HACK; See NOTES)
 
// Initialize core variables
uint16_t toneM        = 0;
uint8_t  beat         = 0;
uint32_t duration     = 0;
uint32_t elapsed_time = 0;

uint8_t  select = 4;

#endif	/* MUSIC_H */

