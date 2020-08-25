#键盘初始化和使能 具体参数意义暂不清晰 
 .globl init_keyboard, enable_keyboard
init_keyboard:
    inb  $0x61,%al
    orb  $0x80,%al
    outb %al,$0x61
    andb $0x7f,%al
    outb %al,$0x61
    ret

enable_keyboard:
   pushl %eax
   inb  $0x60,%al
   inb  $0x61,%al
   orb  $0x80,%al
   outb %al, $0x61
   andb $0x7f,%al
   outb %al,$0x61
   popl %eax
   ret
