all: Hello1 Hello2 run
Hello1: 
	as -arch arm64 -o HelloWorld.o hello.s
Hello2: 
	ld -o HelloWorld HelloWorld.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64

run: 
	./HelloWorld