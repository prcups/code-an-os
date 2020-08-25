.code16
BOOTSEG = 0x7c0
    ljmp  $BOOTSEG, $go
go:
    movw  %cs, %ax
    movw  %ax, %ds
    movw  %ax, %es
    #开始写字符串 
    movw  $buff,%bx
# hell_o wo_rld.
    movl  $0x6c6c6568,0(%bx)
    movl  $0x6f77206f,4(%bx)
    movl  $0x2e646c72,8(%bx)
    movw  %bx, %bp
    xorw  %bx, %bx
    movb  $0x13, %ah
    movb  $0x01, %al
    movb  $2, %bl
    movw  $0xc, %cx
    movb  $0, %dh
    movb  $0, %dl
    int   $0x10
    jmp   .
buff:
    .org  0x1fe
    .word 0xaa55
