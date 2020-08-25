    .globl pg_dir, pg_kernel, pg_task1, pg_task2
kernel_start:
pg_dir:
    movw  $0x10, %ax
    movw  %ax, %ds
    movw  %ax, %ss
    movw  %ax, %es
    movl  $init_stack_end, %esp
    call  init_gdt
    ljmp  $8, $go
go:
    movw  $0x10, %ax
    movw  %ax, %ds
    movw  %ax, %ss
    movw  %ax, %es
    movl  $init_stack_end, %esp
    call  init_keyboard
    call  init_8253
    call  init_8259A
    call  mask_8259A
    call  init_idt
    jmp   after_page_tables
    .org  0x1000
pg_kernel:
    .org  0x2000
pg_task1:
    .org  0x3000
pg_task2:
    .org  0x4000
after_page_tables:
    call  setup_paging
    call  init_task1
    sti
move_to_user:
    pushl $0xf
    pushl $0x1000
    pushf
    pushl $0x07
    pushl $0
    iret
init_stack:
    .fill 50, 4, 0
init_stack_end:
