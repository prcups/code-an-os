    .code16
BOOTSEG = 0x7c0
    ljmp  $BOOTSEG, $go
go:
    movw  %cs, %ax
    movw  %ax, %ds
    movw  %ax, %es
    movw  $0x0600, %ax
    movw  $0x0000, %cx
    movw  $0x184f, %dx
    int   $0x10
    movw  $msg, %bp
    movb  $0x13, %ah
    movb  $0x01, %al
    movb  $2, %bl
    movw  msg_len, %cx
    movb  $0, %dh
    movb  $0, %dl
    int   $0x10
    jmp   .
msg:
    .ascii "nihao, shijie."
msg_len:
    .word . - msg
    .org  0x1fe
    .word 0xaa55
