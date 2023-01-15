//
// Assembler program to print "Hello World!"
// to stdout.
//
// X0-X2 - parameters to Unix system calls
// X16 - Mach System Call function number
//

// as -arch arm64 -o HelloWorld.o hello.s 
// ld -o HelloWorld HelloWorld.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64
.global _start			// Provide program starting address to linker
.align 2			// Make sure everything is aligned properly

// Setup the parameters to print hello world
// and then call the Kernel to do it.
_start: mov	X0, #1		// 1 = StdOut
        mov X2, XZR
loop:
    cmp X2, #14
    b.cs end_loop
    add X2, X2, #1
    mov	X0, #1	
	adr	X3, helloworld 	// string to print
    //mov X4, #0x4
    mov X1, X3
	//mov	X2, #13	    	// length of our string
	mov	X16, #4		// Unix write system call
	svc	#0x80		// Call kernel to output the string
    b loop
// Setup the parameters to exit the program
// and then call the kernel to do it.
end_loop:
	mov     X0, #0		// Use 0 return code
	mov     X16, #1		// System call number 1 terminates this program
	svc     #0		// Call kernel to terminate the program

helloworld:      .ascii  "\nHello World!\n"
