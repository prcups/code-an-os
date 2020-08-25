kernel_start:
    movw  $0x10, %ax      		#数据段的段选择符
    movw  %ax, %ds    			
    movw  %ax, %ss    			#初始化栈信息
    movl  $init_stack_end, %esp 	
    movw  $0x18, %ax
    movw  %ax, %es 			#设置es为显存段选择符
    call  init_8259A 			#初始化8259A
    call  init_8253			#初始化8253
    call  init_keyboard                 #键盘初始化
    call  mask_8259A			#屏蔽8253A芯片对除8253外的其他硬件中断的转发 只转发IR0引脚的0x20中断请求
    call  init_idt			#初始化中断系统(创建中断表 注册中断表 创建时钟中断处理程序 中断处理程序绑定0x20中断号并将中断描述符写入表中对应位置)
    sti					#开启保护模式下的CPU的中断响应
    jmp   .				
#死循环中每间隔10ms 定时器减到0发送一个中断请求给8259A 8259A加工后转发给CPU CPU检测到后回询8259A得到中断号0x20 
#根据中断表找到时钟中断处理程序 若处理程序的100次计数器归零 则复位并令msg发生移动(实际实现了1s移动一次的效果)
init_stack:
    .fill 50, 4, 0
init_stack_end:
