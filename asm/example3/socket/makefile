all: main1 main2 run
main1: 
	as -o main.o main.asm
main2: 
	ld -o a.out main.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path`

run: 
	./a.out