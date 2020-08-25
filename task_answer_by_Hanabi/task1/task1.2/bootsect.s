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
    movb  $0b00001100, %bl  # "0b"或"0B"开始的是二进制数，这里设置为不闪烁，黑色背景，红色文字
    movw  msg_len, %cx
    movb  $0, %dh
    movb  $0, %dl
    int   $0x10
    jmp   .
msg:
    .ascii "  *"
    .word  0x0d0a   # 输出换行和回车(也可使用输出的起始位置行数来控制)
    .ascii "*****"
    .word  0x0d0a
    .ascii "  *"
    .word  0x0d0a
    .ascii " * *"
msg_len:
    .word . - msg
    .org  0x1fe
    .word 0xaa55
