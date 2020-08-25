DELAY = 0
MOVE = 1
task2_start:
    movl  $MOVE, %eax
    movl  move_len, %ebx
    int   $0x80
    call  delay
    jmp   task2_start
delay:
    movl  $DELAY, %eax
    movl  delay_time, %ebx
    int   $0x80
    ret
move_len:
    .long -1
delay_time:
    .long 100    
    