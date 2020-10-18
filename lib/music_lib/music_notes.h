/* 
 * File:   music_notes.h
 * Author: krs
 *
 * Created on February 13, 2020, 5:19 PM
 */

#ifndef MUSIC_NOTES_H
#define	MUSIC_NOTES_H

// TONES //
// Defining the relationship between note, period & frequency. 
 
// period is in microsecond so P = 1/f * (1E6)
// * marked is cycle perfect til 2 decimals
 
#define c0      61162   // 16.35 Hz*
#define c0s     57737  // 17.32 Hz*
#define d0      54496  // 18.35 Hz*
//#define d0s   // 19.45 Hz
//#define e0   // 20.60 Hz
//#define f0   // 21.83 Hz
//#define f0s   // 23.12 Hz
//#define g0   // 24.50 Hz
//#define g0s   // 25.96 Hz
//#define a0   // 27.50 Hz
//#define a0s   // 29.14 Hz
//#define b0   // 30.87 Hz

//#define c1   // 32.70 Hz
//#define c1s   // 34.65 Hz
//#define d1   // 36.71 Hz
//#define d1s   // 38.89 Hz
//#define e1   // 41.20 Hz
//#define f1   // 43.65 Hz
//#define f1s   // 46.25 Hz
//#define g1   // 49.00 Hz
//#define g1s   // 51.91 Hz
//#define a1   // 55.00 Hz
//#define a1s   // 58.27 Hz
//#define b1   // 61.74 Hz

#define c2      15288   // 65.41 Hz*
#define c2s     14430   // 69.30 Hz*
#define d2      13620   // 73.42 Hz*
#define d2s     12857   // 77.78 Hz*
#define e2      12134   // 82.41 Hz*
#define f2      11453   // 87.31 Hz*
#define f2s     10811   // 92.50 Hz*
#define g2      10204   // 98.00 Hz*
#define g2s      9631   // 103.83 Hz*
#define a2       9091   // 110.00 Hz*
#define a2s      8581   // 116.54 Hz*
#define b2       8099   // 123.47 Hz*

#define  c3      7645    // 130.81 Hz*
#define  c3s     7216    // 138.59 Hz*
#define  d3      6811    // 146.83 Hz*
#define  d3s     6428    // 155.56 Hz*
#define  e3      6068    // 164.81 Hz*
#define  f3      5727    // 174.61 Hz*
#define  f3s     5405    // 185.00 Hz*
#define  g3      5102    // 196.00 Hz*
#define  g3s     4816    // 207.65 Hz*
#define  a3      4546    // 220.00 Hz*
#define  a3s     4290    // 233.08 Hz*
#define  b3      4050    // 246.94 Hz*

#define  c4      3822    // 261.63 Hz*
#define  c4s     3608    // 277.18 Hz*
#define  d4      3405    // 293.66 Hz*
#define  d4s     3214    // 311.13 Hz*
#define  e4      3034    // 329.63 Hz*
#define  f4      2863    // 349.23 Hz*
#define  f4s     2703    // 369.99 Hz*
#define  g4      2551    // 392.00 Hz*
#define  g4s     2408    // 415.30 Hz*
#define  a4      2273    // 440.00 Hz*
#define  a4s     2145    // 466.16 Hz*
#define  b4      2029    // 493.88 Hz*

#define  c5      1911    // 523.25 Hz*
#define  c5s     1804    // 554.37 Hz*
#define  d5      1703    // 587.33 Hz*
#define  d5s     1607    // 622.25 Hz*
#define  e5      1517    // 659.25 Hz
#define  f5      1433    // 698.46 Hz
#define  f5s     1351    // 739.99 Hz*
#define  g5      1276    // 783.99 Hz
#define  g5s     1204    // 830.61 Hz*
#define  a5      1136    // 880.00 Hz
#define  a5s     1073    // 932.33 Hz
#define  b5      1012    // 987.77 Hz

#define  c6      956     // 1046.50 Hz*
#define c6s      902     // 1108.73 Hz*
#define d6       851     // 1174.66 Hz*
#define d6s      804     // 1244.51 Hz*
#define e6       758     // 1318.51 Hz*
#define f6       716     // 1396.91 Hz*
#define f6s      676     // 1479.98 Hz*
#define g6       636     // 1567.98 Hz
#define g6s   // 1661.22 Hz
#define a6   // 1760.00 Hz
#define a6s   // 1864.66 Hz
#define b6   // 1975.53 Hz

//#define c7   // 2093.00 Hz
//#define c7s   // 2217.46 Hz
//#define d7   // 2349.32 Hz
//#define d7s   // 2489.02 Hz
//#define e7   // 2637.02 Hz
//#define f7   // 2793.83 Hz
//#define f7s   // 2959.96 Hz
//#define g7   // 3135.96 Hz
//#define g7s   // 3322.44 Hz
//#define a7   // 3520.00 Hz
//#define a7s   // 3729.31 Hz
//#define b7   // 3951.07 Hz

//#define c8   // 4186.01 Hz
//#define c8s   // 4434.92 Hz
//#define d8   // 4698.63 Hz
//#define d8s   // 4978.03 Hz
//#define e8   // 5274.04 Hz
//#define f8   // 5587.65 Hz
//#define f8s   // 5919.91 Hz
//#define g8   // 6271.93 Hz
//#define g8s   // 6644.88 Hz
//#define a8   // 7040.00 Hz
//#define a8s   // 7458.62 Hz
//#define b8   // 7902.13 Hz

#define  R     0      // Define a special note, 'R', to represent a rest

#endif	/* MUSIC_NOTES_H */

