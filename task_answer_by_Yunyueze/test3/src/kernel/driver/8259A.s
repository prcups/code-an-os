    .globl init_8259A, mask_8259A, enable_8259A
#通过out和in完成对外设控制寄存器的写和读操作 外设对应的寄存器统一用编号来表示

init_8259A:#初始化两片8259A芯片 设定中断编号 并完成主从连接
    movb  $0x11, %al #工作方式0x11(先接收中断编号 再接收主从连接和工作模式)
    outb  %al, $0x20 #设置主芯片工作方式
    outb  %al, $0xa0 #设置从芯片工作方式
    movb  $0x20, %al 
    outb  %al, $0x21 #设定主芯片的8个引脚对应的中断号从0x20开始
    movb  $0x28, %al
    outb  %al, $0xa1 #设定从芯片的8个引脚对应的中断号从0x28开始
    #将从芯片接到主芯片的IR2引脚上
    movb  $0x04, %al #0x04(0000_0100按照位图方式对应主芯片7~0编号引脚 1表示启用)
    outb  %al, $0x21 #设定主芯片开放的引脚
    movb  $0x02, %al #0x02表示2号引脚(主开放和从欲连指定引脚的方式不同！)
    outb  %al, $0xa1 #设定从芯片要连接的引脚号
    movb  $0x01, %al #0x01设置两片芯片的工作模式:均需要手动使能
    outb  %al, $0x21
    outb  %al, $0xa1
    ret

mask_8259A:#屏蔽不想/不能处理的中断请求.由于本实验只用8253,因此其他中断均屏蔽
    movb  $0xfe, %al #0xfe(1111_1110)屏蔽码 对应芯片8引脚 1表示屏蔽 0不处理
    outb  %al, $0x21 #将屏蔽码写给主芯片 从而使得只有IR0的8253芯片请求可被响应
    movb  $0xff, %al #0xff(1111_1111)屏蔽码 8引脚全屏蔽
    outb  %al, $0xa1 #从芯片屏蔽码为全部屏蔽
    ret

enable_8259A:#使能8259A芯片 由于init中的设置 必须手动使能 才会让芯片开始工作
    pushl %eax
    movb  $0x20, %al #8259A使能信号
    outb  %al, $0x20 #手动使能主芯片
    outb  %al, $0xa0 #手动使能从芯片
    popl  %eax
    ret
