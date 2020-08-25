kernel_start:
    movw  $0x10, %ax
    movw  %ax, %ds
    movw  %ax, %ss
    movw  $0x18, %ax
    movw  %ax, %es 
    movl  $init_stack_end, %esp
    call  init_gdt
    ljmp  $8, $go
go:
    movw  $0x10, %ax
    movw  %ax, %ds
    movw  %ax, %ss
    movw  $0x18, %ax
    movw  %ax, %es 
    movl  $init_stack_end, %esp
    call  init_8253
    call  init_8259A
    call  mask_8259A
    call  init_idt
    sti
    call  init_task1
move_to_user:
    pushl $0xf
    pushl $0x200
    pushf
    pushl $0x7
    pushl $0
    iret
init_stack:
    .fill 50, 4, 0
init_stack_end:
