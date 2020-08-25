kernel_start:
    movw  $0x10, %ax
    movw  %ax, %ds #段选择符0x10(10_000)的段索引(第2项)即数据段0x7e00
    movw  %ax, %ss #刷新栈段指针到数据段0x7e00
    movw  %ax, %es #段选择符0x10(10_000)的段索引(第2项)即数据段0x7e00
    movl  $init_stack_end, %esp#刷新栈指针到栈底外
    call  print_msg
    jmp   .
init_stack:
    .fill 50, 4, 0
init_stack_end:
