DELAY = 0
MOVE = 1
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
    .ascii " hello, world. "
msg_len:
    .long .-msg
move_len:
    .long -1
delay_time:
    .long 100    
    