kernel_start:
    movw  $0x10, %ax
    movw  %ax, %ds #段选择符0x10(10_000)的段索引(第2项)即数据段0x7e00
    movw  %ax, %es #段选择符0x10(10_000)的段索引(第2项)即数据段0x7e00
    movw  $0x18,%ax #段选择符0x18(11_000)的段索引(第3项)即栈段0x9000
    movw  %ax, %ss #刷新栈段指针到数据段0x9000
    movl  $0x200, %esp#刷新栈指针到栈底外
    call  print_msg
    jmp   .
