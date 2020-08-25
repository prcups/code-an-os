    .globl init_idt, delay_count
init_idt:

    #生成时钟中断描述符并注册到中断表0x20处
    movl  $timer_interrupt, %edx 
    movw  $0x8e00, %dx
    movl  $0x00080000, %eax
    movw  $timer_interrupt, %ax 
    movl  $0x20, %ecx
    lea   idt(,%ecx,8), %esi
    movl  %eax, (%esi)
    movl  %edx, 4(%esi)

    #生成系统调用的中断描述符并注册到中断表0x80处
    movl  $system_call_interrupt, %edx 
    movw  $0xef00, %dx
    movl  $0x00080000, %eax
    movw  $system_call_interrupt, %ax 
    movl  $0x80, %ecx
    lea   idt(, %ecx, 8), %esi
    movl  %eax, (%esi)
    movl  %edx, 4(%esi)

    #生成键盘中断描述符并注册到中断表0x21处
    movl  $keyboard_interrupt, %edx 
    movw  $0x8e00, %dx
    movl  $0x00080000, %eax
    movw  $keyboard_interrupt, %ax 
    movl  $0x21, %ecx
    lea   idt(,%ecx,8), %esi
    movl  %eax, (%esi)
    movl  %edx, 4(%esi)

    #注册中断表到ITDR寄存器中
    lidt  idt_48
    ret

system_call_interrupt:
    pushl %ds
    pushl %es
    pushl %fs
    pushl %eax

    movw  $0x10, %ax
    movw  %ax, %ds
    movw  %ax, %es      	    #传入数据段的描述符  
    movw  $0xf, %ax
    movw  %ax, %fs                 #fs task1数据段 
    popl  %eax                     #eax中保存功能号 0是延时delay 1是移动move
    call  *sys_call_table(,%eax,4)  #将ds:sys_call_table+4*%eax处的四字节内容当作系统调用的入口地址

    popl  %fs
    popl  %es
    popl  %ds
    iret

keyboard_interrupt:
    pushl %ds
    pushl %es
    pushl %eax
    movw  $0x10, %ax
    movw  %ax, %ds
    movw  %ax, %es
    call  enable_8259A      #使能8259A
    call  enable_keyboard   #使能键盘中断
    call  switch_task       #切换任务
    popl  %eax
    popl  %es
    popl  %ds
    iret

timer_interrupt:
    pushl %ds
    pushl %es
    pushl %eax
    movw  $0x10, %ax
    movw  %ax, %ds
    movw  %ax, %es
    call  enable_8259A  #使能8259A
    decl  delay_count   #计数器每10ms减1 计数器初值由每次调用sys_delay时ebx指定
    popl  %eax
    popl  %es
    popl  %ds
    iret

delay_count:
    .long 0
idt_48:
    .word (idt_end-idt)-1
    .long idt
idt:
    .fill 256, 8, 0
idt_end:
    
