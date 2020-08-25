    .globl setup_paging
setup_paging:
    xorl  %eax, %eax
    movl  $0, %edi
    movl  $1024*4, %ecx
    cld;rep;stosl
    movl  %eax, %cr3
    movl  $0x1003, pg_dir+0*4
    movl  $0x0003, pg_kernel+0*4
    movl  $0x1003, pg_kernel+1*4
    movl  $0x2003, pg_kernel+2*4
    movl  $0x3003, pg_kernel+3*4
    movl  $0x4003, pg_kernel+4*4
    movl  $0xb8003, pg_kernel+0xb8*4
    movl  $0x2007, pg_dir+0x10*4    
    movl  $0x5007, pg_task1+0*4
    movl  $0x3007, pg_dir+0x20*4
    movl  $0x6007, pg_task2+0*4
    movl  %cr0, %eax
    orl   $0x80000000, %eax
    movl  %eax, %cr0
first_instruction:
    ret
