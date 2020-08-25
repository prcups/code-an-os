DELAY = 0
MOVE = 1
task1_start:
    movw  $0xf, %ax  #0xf (1111) LDT第1项数据段(TI=1表明LDT RPL=3用户态)
    movw  %ax, %ds
    movw  %ax, %es
1:  movl  $MOVE, %eax  #eax保存系统调用号
    movl  $msg, %ebx   #ebx保存字符串在task1数据段中的偏移位置
    movl  msg_len, %ecx #ecx保存字符串长度
    movl  move_len, %edx #edx保存字符串的移动幅度和方向
    int   $0x80          #调用0x80 系统调用1号功能
    call  delay 	 #调用delay  延迟1s
    jmp   1b
delay:
    movl  $DELAY, %eax     
    movl  delay_time, %ebx
    int   $0x80			#调用0x80系统调用的0号功能
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
    .long  -80
delay_time:
    .long 2000 
    
