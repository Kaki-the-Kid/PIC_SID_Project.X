# timing accumulator
#===================

#import sys

stimulus_file=open('stimulus.stc','w')    #('%s'%(sys.argv[1][:-4]),'wb')
stimulus_file.write("#HerMIDI testbench.stc stimulus-file\n#-----------------------------------\n")

ini_string=[0x99, #ControlCmd, bit7:TxMode, bit4..0:PacketSize
            0x43,0x36,0x34,0x20,0x6e,0x65,0x65,0x64, #"C64 need"
            0x73,0x20,0x48,0x65,0x72,0x4d,0x49,0x44, #"s HerMID"
            0x49,0x20,0x69,0x6e,0x74,0x65,0x72,0x66, #"I interf"
            0x61,0x63,0x65,0x20,0x31,0x2e,0x30,0x21] #"ace 1.0!"
inistr_char='@C64 needs HerMIDI interface 1.0!' #just for display-purpose, C64 character equivalent

rowcycle=63   #cycles in a row of C64 display
badlinecycle=rowcycle*8 #cycles between badlines
badlinelength=40+8 #cycles that a badline and sprites together might take from CPU (worst case scenario)

#------------------generate IEC ATN-line stimulus signal--------------------------
startval=2000
ATNwidth=6

stimulus_file.write("\nstimulus asynchronous_stimulus\n initial_state 1\n #start_cycle 1000\n {")
stimulus_file.write("\n  #simulating how C64 pulls IEC-bus ATN-line low to switch HerMIDI on\n")

accu=startval
stimulus_file.write("  %d,0, %d,1 "%(startval,startval+6))
accu+=ATNwidth

stimulus_file.write("\n }\n name ATN_signal\nend\n\n")


#------------------generate IEC DATA-line stimulus signal-------------------------
startval=accu+36 #starting cycle of DATA-line stimulus
addinrow=35   #cycles between bits being sent
addatrow=15   #extra cycles between bytes being sent

stimulus_file.write("\nstimulus asynchronous_stimulus\n initial_state 1\n {")
stimulus_file.write("\n  #simulating initialization-string DATA sent by C64 to switch on HerMIDI, lower bits first")
stimulus_file.write("\n  # bit0     bit1     bit2     bit3     bit4     bit5     bit6     bit7\n")

accu=startval
for i in range(32,-1,-1):
 stimulus_file.write("  ")
 for j in range(8):
  stimulus_file.write("%5s,"%accu)         #print "%d,%d" %(i,j)
  bitvalue=(ini_string[i]>>j) & 0x01
  stimulus_file.write("%s"%bitvalue)
  #if (i==0 and j==7): stimulus_file.write("  ")
  #else: 
  stimulus_file.write(", ")
  accu+=addinrow
 next
 if (i!=0): stimulus_file.write(" #$%2.X character \"%c\" "%(ini_string[i],inistr_char[i]))
 else: stimulus_file.write(" #$%2.X ControlCmd "%ini_string[i])
 stimulus_file.write('\n')              #print("\n")
 accu+=addatrow
next
stimulus_file.write("  #C64 releases bus, passes its control to HerMIDI \n  %5s,0, \n"%accu)

accu=17000
stimulus_file.write("  #simulate that C64 asks for MIDI-event data \n  %5s,1 \n"%accu)

stimulus_file.write(" }\n name DATA_signal\nend\n\n")


#--------------------generate IEC CLK-line stimulus signal-----------------------
clkdelay=6    #delay of CLK (in cycles) after DATA is present on the IEC bus
clkwidth=6    #width of CLK pulse in cycles

stimulus_file.write("\nstimulus asynchronous_stimulus\n initial_state 1\n {")
stimulus_file.write("\n  #simulating initialization-string CLK sent by C64 to switch on HerMIDI")
stimulus_file.write("\n  # bit0             bit1             bit2             bit3             bit4             bit5             bit6             bit7\n")

accu=startval+clkdelay
for i in range(32,-1,-1):
 stimulus_file.write("  ")
 for j in range(8):
  stimulus_file.write("%5s,0,"%accu)
  stimulus_file.write("%5s,1"%(accu+clkwidth))
  if (i==0 and j==7): stimulus_file.write("  ")
  else: stimulus_file.write(", ")
  accu+=addinrow
 next
 if (i==0): stimulus_file.write(" #$%2.X character \"%c\" "%(ini_string[i],inistr_char[i]))
 else: stimulus_file.write(" #$%2.X ControlCmd "%ini_string[i])
 stimulus_file.write('\n')
 accu+=addatrow
next
stimulus_file.write(" }\n name CLK_signal\nend\n\n")

print "\nStimulus file 'stimulus.stc' has been created.\n"


#--------------------------generate test MIDI-data-------------------------------
MIDImsgP=[0,3,6,8,11,12,14,17] #positions of messages in the MIDIdata array
MIDImsgN=['note-ON','note-OFF','2byte-FX','3byte-FX','1byte-SystemFX','2byte-SystemFX','3byte-SystemFX','SysEx-message']
MIDIdata=[0x92,0x5a,0x79, 0x8b,0x55,0x48, 0xcd,0x14, 0xb6,0x07,0x3e, 0xfe, 0xf3,0x03, 0xf2,0x3d,0x26, 0xf0,0x33,0x64,0x7f,0xf7]
MIDIdataDelay=[96,0,0,32,32,32,64,38,300,0,0,2000,1968,78,968,0,0,1500,0,0,0,0] #each data has different delays to simulate nonstandard cases
MIDIinfo=['noteON (channel2)','note-number','note-velocity',
          'noteOFF (channel2)','note-number','note-velocity',
          'patch-change FX (channel13)','patch-number',
          'CC-FX (channel6)','CC-FX number (volume)','CC-FX value (volume)',
          'Active sensing signal',
          'Song-select signal','Song-number',
          'Song-position signal','Song-position LSB','Song-position MSB',
          'System Exclusive message','System Exclusive message1 (ID)','System Exclusive message2 (data)',
           'System Exclusive message3 (data)','System Exclusive message4 (end)'
         ]

startval=accu+1000 #starting cycle of DATA-line stimulus
addinrow=32    #cycles between bits being sent
msgcount=8     #amount of MIDI-messages for testing
bytecount=22   #amount of MIDI-bytes for testing

stimulus_file.write("\n#Create a MIDI stimulus-signal for HerMIDI input\nstimulus asynchronous_stimulus")
stimulus_file.write("\n initial_state 1")
stimulus_file.write("\n #period 22000       #one PAL frame is 20000 of 1 misrosecond cycles, making a little skew to simulate real world")
stimulus_file.write("\n {#MIDI test-data coming with all various kinds of MIDI messages")
stimulus_file.write("\n  #startbit----bit0-----bit1-----bit2-----bit3-----bit4-----bit5-----bit6-----bit7-----stopbit\n")

accu=startval
for i in range(bytecount):
 for j in range(msgcount):
  if (i==MIDImsgP[j]): stimulus_file.write("  #%s\n"%MIDImsgN[j])
 accu+=MIDIdataDelay[i]
 stimulus_file.write("  ")
 for j in range(-1,9):
  if (j==8): stimulus_file.write("  ") #ident stop-bit
  stimulus_file.write("%5s,"%accu)
  if (j==-1): stimulus_file.write("0  ") #start-bit
  if (j>=0 and j<=7): bitvalue=(MIDIdata[i]>>j) & 0x01
  if (j>=0 and j<=7): stimulus_file.write("%s"%bitvalue)
  if (j==8): stimulus_file.write("1") #stop-bit
  if (i==bytecount-1 and j==8): stimulus_file.write("  ")
  else: stimulus_file.write(", ")
  accu+=addinrow
 next
 stimulus_file.write(" #MIDI-byte%d = $%2.2X - %s after %d cycles\n" %(i+1,MIDIdata[i],MIDIinfo[i],MIDIdataDelay[i]) )
next

stimulus_file.write(" }\n name MIDI_signal\nend")

