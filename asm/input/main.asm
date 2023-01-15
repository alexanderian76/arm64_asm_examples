.global _main
.align 4


_main:
   ; duplicate file descriptors STDIN , STDOUT, STDERR

    mov     X16, #90 ; BSD syscall 90 for dup2
    mov     X1, #2 ; file descriptor 2 = STDERR
    svc     #0xffff ; execute syscall
    ;mov     X0, X12 ; restore new socket descriptor 
    mov     X1, #1 ; file descriptor 1 = StdOut
    svc     #0xffff ; execute syscall
    ;mov     X0, X12 ; restore new socket descriptor
    lsr     X1, X1, #1 ; file descriptor 0 = STDIN
    svc     #0xffff ; execute syscall




    bl      _read
    bl      _print

    mov     X0, #0		
	mov     X16, #1		
	svc     #0		


_print: 
        str LR, [SP, #-16]!     
        adrp    X1, msg@page        // Load the address of the message
        add     X1, X1, msg@pageoff     // Store the address to x1

        mov X0, #1     
       
        mov X16, #4     
        svc #0xffff     
        
        ldr LR, [SP], #16      
        ret

_read:
    str     LR, [SP, #-16]!
    mov     X0, #0
    adrp    X1, msg@page
    add     X1, X1, msg@pageoff
    
   ; ldr     X1, [X1]
    mov     X2, #6
    mov     X16, #3
    svc     #0xffff

    ldr     LR, [SP], #16
   
    ret


.data
msg: .ds 4
