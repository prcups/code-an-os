    .code16
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
    .ascii "hello, world."
msg_len:
    .word . - msg
    .org  0x1fe
    .word 0xaa55
