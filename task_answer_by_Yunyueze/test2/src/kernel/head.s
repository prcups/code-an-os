kernel_start:
    movw  $0x10, %ax
    movw  %ax, %ds #段选择符0x10(10_000)的段索引(第2项)即数据段0x7e00
    movw  %ax, %ss #刷新栈段指针到数据段
    movw  $0x18, %ax 
    movw  %ax, %es #段选择符0x18(11_000)的段索引(第3项)即显存段0xb8000
    movl  $init_stack_end, %esp#刷新栈指针到栈底
    call  print_msg
    jmp   .
init_stack:
    .fill 50, 4, 0
init_stack_end:
