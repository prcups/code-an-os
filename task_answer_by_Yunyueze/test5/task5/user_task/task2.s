DELAY = 0
MOVE = 1
#基本同task1 只不过move_len 是-1
task2_start:
    movl  $MOVE, %eax
    movl  $msg, %ebx
    movl  msg_len, %ecx
    movl  move_len, %edx
    int   $0x80
    call  delay
    jmp   task2_start
delay:
    movl  $DELAY, %eax
    movl  delay_time, %ebx
    int   $0x80
    ret
msg:
    .ascii "       "
msg_end:
    .ascii "   *   "
    .ascii " ***** "
    .ascii "   *   "
    .ascii "  * *  "
    .ascii "       "

msg_len:
    .long msg_end-msg

move_len:
    .long 80    #方向是向左移动
delay_time:
    .long 2000   

    
