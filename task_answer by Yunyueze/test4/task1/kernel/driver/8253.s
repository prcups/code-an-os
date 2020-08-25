    .global init_8253
LATCH = 11931   #10ms发送一次中断请求
init_8253:
    movb  $0x36, %al
    outb  %al, $0x43
    movw  $LATCH, %ax
    outb  %al, $0x40
    movb  %ah, %al
    outb  %al, $0x40
    ret
