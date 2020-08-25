    .code16
BOOTSEG = 0x7c0
    ljmp  $BOOTSEG, $go
go:
    movw  %cs, %ax
    movw  %ax, %ds
    movw  %ax, %es

    movl  $0x6c6c6568, msg
    movl  $0x77202c6f, msg+4
    movl  $0x646c726f, msg+8
    movb  $0x2e, msg+12

    movw  $msg, %bp
    movb  $0x13, %ah
    movb  $0x01, %al
    movb  $2, %bl
    movw  $13, %cx
    movb  $0, %dh
    movb  $0, %dl
    int   $0x10
    jmp   .
# msg:
  # .ascii "hello, world."
msg:
  # .word . - msg
    .org  0x1fe
    .word 0xaa55
