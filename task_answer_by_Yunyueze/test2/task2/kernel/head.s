kernel_start:
    movw $0x10,%ax
    movw %ax,%ds
    lgdt gdt_edge   #初始化新的gdt
    #执行拷贝任务
    movw $0x10,%ax
    movw %ax,%es   #es 0x0 数据段
    movl $0,%edi   #edi 0
    movw $0x20,%ax #0x20(100_000)的段索引(第4项)即旧的数据段
    movw %ax,%ds   #ds 0x7e00 数据段
    movl $0,%esi   #esi 0
    movl $0x200,%ecx
    cld #且esi edi每次执行送数后加1 
s:  movsb #[ds:esi]---->[es:edi] 拷贝512次 每次一个字节
    loop s

    ljmp  $0x8,$second_start   #跳转到0x0处 并从second_start开始执行
second_start:    
    movw  $0x10, %ax
    movw  %ax, %ds #段选择符0x10(10_000)的段索引(第2项)即数据段0x0
    movw  %ax, %ss #刷新栈段指针到数据段
    movw  $0x18, %ax 
    movw  %ax, %es #段选择符0x18(11_000)的段索引(第3项)即显存段0xb8000
    movl  $init_stack_end, %esp#刷新栈指针到栈底
    call  print_msg
    jmp   .

gdt_edge:
    .word (init_stack-gdt_new)-1
    .long 0x7e00+gdt_new
gdt_new:
    .quad 0                              #GDT 的第0 项（项号从0 开始）必须为空；8字节
    .word 0x01ff, 0x0000, 0x9a00, 0x0040 #第一项0x0开始的 长度512字节的 可读可执行的代码段
    .word 0x01ff, 0x0000, 0x9200, 0x0040 #第二项0x0开始的 长度512字节的 可读可写的数据段
    .word 0x0f9f, 0x8000, 0x920b, 0x0040 #第三项0xb8000开始的 长度4000字节的 显存数据段 (因为我们之后的显示器驱动 需要访问显存)
    .word 0x01ff, 0x7e00, 0x9200, 0x0040 #第四项0x7e00开始的 长度512字节的旧的数据段
init_stack:
    .fill 50, 4, 0
init_stack_end:

