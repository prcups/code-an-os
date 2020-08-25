    .globl init_keyboard, enable_keyboard, key_ascii
init_keyboard:
    inb   $0x61, %al
    orb   $0x80, %al
    outb  %al, $0x61
    andb  $0x7f, %al
    outb  %al, $0x61
    ret
enable_keyboard:
    pushl %eax
    xorl  %eax, %eax
    inb   $0x60, %al
    movb  key_map(,%eax,1), %al
    movb  %al, key_ascii
    inb   $0x61, %al
    orb   $0x80, %al
    outb  %al, $0x61
    andb  $0x7f, %al
    outb  %al, $0x61
    popl  %eax
    ret
key_ascii:
    .byte 0
key_map:
    .byte 0,0
    .ascii "1234567890"
    .byte 0,0,0,0
    .ascii "qwertyuiop"
    .byte 0,0,0,0
    .ascii "asdfghjkl"
    .byte 0,0,0,0,0
    .ascii "zxcvbnm"
    