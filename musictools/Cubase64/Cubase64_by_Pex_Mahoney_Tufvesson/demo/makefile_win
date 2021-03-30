
all: cubase64.prg

main.prg:	main.s SIDencodedNoise.s SIDenc3Speed.s SIDencWave.s SIDwaveforms.s
	cl65 --asm-include-dir . -t none -l -m main.map -Ln main.vicelabel -o main.prg main.s
packed.prg: main.prg
	pucrunch -c64 -l600 -x600 -g53 -i0 -ffast main.prg packed.prg
cubase64.prg: packed.prg wrapper.s
	cl65 --asm-include-dir . -t none -l -m wrapper.map -Ln wrapper.vicelabel -o cubase64.prg wrapper.s
run: cubase64.prg
	x64 -sidengine 7 -soundrate 44100 -soundsync 2 cubase64.prg

.PHONY: clean zap

clean:
	@rm -f *~
	@rm -f *.o
	@rm -f *.prg
	@rm -f *.lst
	@rm -f *.map
