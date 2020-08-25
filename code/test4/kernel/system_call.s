    .globl sys_call_table
sys_call_table:
    .long sys_delay
    .long sys_move
sys_delay:
    movl  %ebx, delay_count
1:  cmpl  $0, delay_count
    jg    1b
    ret
sys_move:
    pushl %ebx
    call  move_msg
    addl  $4, %esp
    ret
        