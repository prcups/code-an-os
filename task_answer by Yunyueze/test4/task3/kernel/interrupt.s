    .globl init_idt, delay_count
COUNT = 1000
init_idt:
    #将timer_interrupt的处理程序注册到IDT 0x20号位置
    movl  $timer_interrupt, %edx 
    movw  $0x8e00, %dx    #DPL=0 IF=0
    movl  $0x00080000, %eax
    movw  $timer_interrupt, %ax 
    movl  $0x20, %ecx
    lea   idt(,%ecx,8), %esi
    movl  %eax, (%esi)
    movl  %edx, 4(%esi)
    #将系统调用中断的处理程序注册到IDT 0x80号位置
    movl  $system_call_interrupt, %edx 
    movw  $0xef00, %dx    #DPL=3 IF=1(系统调用)
    movl  $0x00080000, %eax 
    movw  $system_call_interrupt, %ax 
    movl  $0x80, %ecx
    lea   idt(, %ecx, 8), %esi
    movl  %eax, (%esi)
    movl  %edx, 4(%esi)

    movl  $keyboard_interrupt, %edx  #将中断处理程序入口偏移地址32位赋给edx
    movw  $0x8e00, %dx            #保留edx高16位(偏移地址高16位) 将低16位覆盖为0x8e00(1_00_0111_0 0000_0000)
    movl  $0x00080000, %eax       #将0x0008_0000给eax
    movw  $keyboard_interrupt, %ax   #eax低16位覆盖为中断处理程序入口偏移地址的>低16位
    movl  $0x21, %ecx             #保存中断号 用来定位中断表中该中断对应的位置
    lea   idt(,%ecx,8), %esi      #将地址 [ds:(idt+ecx*8)] 的偏移地址赋值给esi
    movl  %eax, (%esi)            #(%reg)表示访问寄存器对应偏移 ds对应段基的内存位置 这里是写中断描述符低4字节内容
    movl  %edx, 4(%esi)           #偏移4字节后 写中断描述符高四字节内容

    #注册IDT
    lidt  idt_48
    ret

timer_interrupt:
    pushl %ds
    pushl %es
    pushl %eax
    movw  $0x10, %ax
    movw  %ax, %ds
    movw  $0x18, %ax
    movw  %ax, %es
    call  enable_8259A
    decl  delay_count           #delay_count减1
    #10s调用一次进程切换
    subl  $1, timer_count	#timer_conut减1 每10s 执行一次进程的切换
    jne   1f
    movl  $COUNT, timer_count	
  #  call  switch_task

1:  popl  %eax
    popl  %es
    popl  %ds
    iret

system_call_interrupt:
    pushl %ds
    pushl %es
    pushl %eax
    movw  $0x10, %ax          #数据段
    movw  %ax, %ds
    movw  $0x18, %ax          #显存段
    movw  %ax, %es    
    popl  %eax
    call  *sys_call_table(,%eax,4)   #将ds:sys_call_table+4*%eax处的四字节内容当作系统调用的入口地址
    popl  %es
    popl  %ds
    iret

keyboard_interrupt:
    call enable_8259A
    call enable_keyboard
    call switch_task 
  iret

delay_count:
    .long 0
timer_count:
    .long COUNT
idt_48:
    .word (idt_end-idt)-1
    .long 0x7e00+idt
idt:
    .fill 256, 8, 0
idt_end:
    
