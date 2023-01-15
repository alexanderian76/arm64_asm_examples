.global _main
.align 4


_main:
    mov     X8, #0x480A
    movk    X8, #0x6C65, lsl#16
    movk    X8, #0x6F6C, lsl#32 
    movk    X8, #0x4D20, lsl#48 

    mov     X9, #0x2D31 
     
    movk    X9, #0x6F57, lsl#16
    movk    X9, #0x6C72, lsl#32 
    movk    X9, #0x2164, lsl#48 

    stp     X8, X9, [SP, #-16]!

    mov     X10, #0x250A
   ; movk     X10, #0x0025, lsl#16
    str     X10, [SP, #-8]!
    mov     X2, #23
    
loop:
    cmp     X2, #24
    b.cs    end_loop
    add     X2, X2, #1
    mov	X0, #1	
	;adr	X1, helloworld 
    mov     X1, SP   
   ; add X1, X1, #2
	mov     X16, #4		
	svc     #0x80
    b       loop

end_loop:
	mov     X0, #0		
	mov     X16, #1		
	svc     #0		

helloworld:      .ascii  "\nHello World!\n"
    
