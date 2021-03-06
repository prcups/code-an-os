    .globl init_idt, delay_count
init_idt:
    #生成时钟中断描述符并注册到中断表0x20处
    movl  $timer_interrupt,%eax
    movb  $0,%bh
    movb  $0,%bl
    movl  $0x20,%ecx
    call  register_IDT
    #生成系统调用的中断描述符并注册到中断表0x80处
    movl  $system_call_interrupt,%eax
    movb $3,%bh
    movb $1,%bl
    movl $0x80,%ecx
    call register_IDT
    #生成键盘中断描述符并注册到中断表0x21处
    movl  $keyboard_interrupt,%eax
    movb  $0,%bh
    movb  $0,%bl
    movl  $0x21,%ecx
    call  register_IDT 
    #注册中断表到ITDR寄存器中
    lidt  idt_48
    ret

#eax中存放32位中断处理程序入口偏移地址 bl中放IF(一位二进制) bh中放DPL(2位二进制) ecx中放中断号 es中放数据段选择符

register_IDT:
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %esi
    pushl %es
    shlb $5,%bh			#bh左移五位 DPL归位
    addb %bl,%bh		#将IF送入bh
    orb   $0x8E,%bh		#将bh对应位 置1 (1000_1110) 
    andb  $0xEF,%bh		#将bh对应位 置0 (1110_1111)
    movb  $0,%bl		#bl清零
    lea idt(,%ecx,8),%esi	#将idt对应偏移位置赋值esi
    movw %ax,(%esi)		#写中断处理程序入口地址的偏移地址低16位
    movw $0x8,2(%esi)	 	#写中断处理程序入口地址的段选择符
    movw %bx,4(%esi)		#写IF DLP等
    shrl $16,%eax		#右移16位 令原eax高16位送入ax
    movw %ax,6(%esi)		#写中断处理程序入口地址的偏移地址高16位
    popl %es
    popl %esi
    popl %ecx
    popl %ebx
    popl %eax
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
    
