    .globl init_idt
COUNT = 100
init_idt:
    #将timer_interrupt的中断描述符高32位存edx 低32位存eax
    movl  $timer_interrupt, %edx  #将中断处理程序入口偏移地址32位赋给edx
    movw  $0x8e00, %dx            #保留edx高16位(偏移地址高16位) 将低16位覆盖为0x8e00(1_00_0111_0 0000_0000)
    movl  $0x00080000, %eax       #将0x0008_0000给eax
    movw  $timer_interrupt, %ax   #eax低16位覆盖为中断处理程序入口偏移地址的低16位
    
    movl  $0x20, %ecx             #保存中断号 用来定位中断表中该中断对应的位置
    lea   idt(,%ecx,8), %esi      #将地址 [ds:(idt+ecx*8)] 的偏移地址赋值给esi
    movl  %eax, (%esi)            #(%reg)表示访问寄存器对应偏移 ds对应段基的内存位置 这里是写中断描述符低4字节内容
    movl  %edx, 4(%esi)           #偏移4字节后 写中断描述符高四字节内容
    lidt  idt_48		  #注册idt lidt 加载idt表信息到IDTR寄存器
    ret
timer_interrupt:
    call  enable_8259A        #使能8259A
    subl  $1, timer_count     #ds:timer_count处的计数值减1 
    jne   1f		      #检测zeroFlag 若不为0则跳过 若为0则表示已经过了100个10ms(即1s) 
    movl  $COUNT, timer_count #重置timer_count为100 
    call  move_msg	      #并调用move_msg移动一下字符串
1:  iret
timer_count:
    .long COUNT
idt_48:
    .word (idt_end-idt)-1 #中断表边界
    .long 0x7e00+idt #中断表的物理地址
idt:
    .fill 256, 8, 0  #预留下256个中断描述符
idt_end:
