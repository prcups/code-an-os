    .globl init_keyboard, enable_keyboard, key_ascii
#初始化
init_keyboard:
    inb   $0x61, %al    #将0x61寄存器的值读入al中

    orb   $0x80, %al    #将al的最高位设为1
    outb  %al, $0x61    #将al结果写回0x61号寄存器中

    andb  $0x7f, %al    #将al的最高位设为0
    outb  %al, $0x61    #将al结果写回0x61
    ret

#使能
enable_keyboard:
    pushl %eax
    xorl  %eax, %eax
    inb   $0x60, %al             #按下键后 0x60寄存器获得一个对应按键的扫描码 令其保存到al中
    movb  key_map(,%eax,1), %al  #由al、key_map生成对应按键的ascii码 放回al中
    movb  %al, key_ascii         #将ascii码写到key_ascii区域
    #一些初始化操作	         #key_ascii区域在switch_task中被使用
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
    
