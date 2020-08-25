DELAY = 0  #sys_delay 系统调用号为0
MOVE = 1   #sys_move 系统调用号为1
task1_start:
    movw  $0xf, %ax  #0xf (1111) LDT第1项数据段(TI=1表明LDT RPL=3用户态)
    movw  %ax, %ds
    movw  %ax, %es   
    #eax保存系统调用号 ebx保存字符串的移动幅度
1:  movl  $MOVE, %eax
    movl  move_len, %ebx
    int   $0x80     #调用0x80系统调用中断
    call  delay
    jmp   1b
delay:
    movl  $DELAY, %eax     #eax系统调用号
    movl  delay_time, %ebx #ebx传递延时的时间
    int   $0x80    #调用中断
    ret
move_len:
    .long 1
delay_time:
    .long 100    
