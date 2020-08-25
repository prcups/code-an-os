    .globl init_8259A, mask_8259A, enable_8259A
init_8259A:
    movb  $0x11, %al
    outb  %al, $0x20
    outb  %al, $0xa0
    movb  $0x20, %al
    outb  %al, $0x21
    movb  $0x28, %al
    outb  %al, $0xa1
    movb  $0x04, %al
    outb  %al, $0x21
    movb  $0x02, %al
    outb  %al, $0xa1
    movb  $0x01, %al
    outb  %al, $0x21
    outb  %al, $0xa1
    ret
mask_8259A:
    movb  $0xfc, %al
    outb  %al, $0x21
    movb  $0xff, %al
    outb  %al, $0xa1
    ret
enable_8259A:
    pushl %eax
    movb  $0x20, %al
    outb  %al, $0x20
    outb  %al, $0xa0
    popl  %eax
    ret
