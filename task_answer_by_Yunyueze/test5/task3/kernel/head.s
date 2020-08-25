    .globl pg_dir, pg_kernel, pg_task1, pg_task2
kernel_start:
#在head.s中 先执行pg_dir和go下的指令 待最后开启分页 将这部分指令清空覆盖
pg_dir:   #0号页
    movw  $0x10, %ax
    movw  %ax, %ds
    movw  %ax, %ss
    movw  %ax, %es              #初始化ds ss es寄存器
    movl  $init_stack_end, %esp #初始化栈指针
    call  init_gdt              #注册新的gdt
    ljmp  $8, $go               #重新加载代码段信息到cs 并跳到go
go:
    movw  $0x10, %ax            
    movw  %ax, %ds
    movw  %ax, %ss
    movw  %ax, %es              #更新数据段 栈段
    movl  $init_stack_end, %esp #更新栈指针
    #初始化一系列硬件中断
    call  init_keyboard
    call  init_8253
    call  init_8259A
    call  mask_8259A
    call  init_idt              #初始化中断表
    jmp   after_page_tables     #调到4号页处的代码位置
    .org  0x1000                #填充0占位
pg_kernel: #1号页
    .org  0x2000 
pg_task1:  #2号页
    .org  0x3000
pg_task2: #3号页
    .org  0x4000
after_page_tables:             #4号页
    call  setup_paging         #初始化页目录表和页表 开启分页模式
    call  init_task1           #初始化task1
    sti                        #开中断
move_to_user:                  #切换到用户态开始执行task1
    pushl $0x17                 #task1 ss
    pushl $0x1000              #task1 esp
    pushf		       #task1 flag
    pushl $0x07  #(0_111)ldt1中的代码段选择符  (cs) #task1 cs
    pushl $0			#task1 eip
    iret         #将上述压栈的内容纷纷出栈到对应寄存器 从而进入用户态
init_stack:
    .fill 50, 4, 0
init_stack_end:
