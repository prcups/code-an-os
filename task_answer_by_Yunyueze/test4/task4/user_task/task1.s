t1 = 10
DELAY = 0  #sys_delay 系统调用号为0
MOVE = 1   #sys_move 系统调用号为1
TSS2_SEL=0x33 #(110 011)
task1_start:
    movw  $0xf, %ax  #0xf (1111) LDT第1项数据段(TI=1表明LDT RPL=3用户态)
    movw  %ax, %ds
    movw  %ax, %es   
    #eax保存系统调用号 ebx保存字符串的移动幅度
    movl  $MOVE, %eax
    movl  move_len, %ebx  
    int   $0x80     #调用0x80系统调用中断
    call  delay
    subl $1,t1count
    jz r1
    jmp task1_start
r1: movl  $t1,t1count
    ljmp  $TSS2_SEL, $0
    jmp task1_start        #相当关键
delay:
    movl  $DELAY, %eax     #eax系统调用号
    movl  delay_time, %ebx #ebx传递延时的时间
    int   $0x80    #调用中断
    ret
move_len:
    .long 80
delay_time:
    .long 1000 
t1count:
    .long t1
