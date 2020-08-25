kernel_start:
    movw  $0x10, %ax
    movw  %ax, %ds
    movw  %ax, %ss
    movw  $0x18, %ax
    movw  %ax, %es 
    movl  $init_stack_end, %esp
    call  print_msg
    jmp   .
init_stack:
    .fill 50, 4, 0
init_stack_end:
