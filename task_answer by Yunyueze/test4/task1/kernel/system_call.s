    .globl sys_call_table
#调用表
sys_call_table:
    .long sys_delay
    .long sys_move

#延时调用
#计数器delay_count的初始值由调用系统调用时时的ebx传入 
#delay_count定义在interrupt.s中 由timer_interrupt处理程序每次减1(即每10ms减1)
sys_delay:
    movl $0,jiffies
1:  cmpl  %ebx, jiffies 	#只要延时计数器比ebx小就循环执行cmp
    jl    1b
    ret

#字符串打印调用
sys_move:
    pushl %ebx		    #将ebx值压入栈内
    call  move_msg   	    #执行move_msg 移动一定的幅度
    addl  $4, %esp          #手动删除压入的ebx值
    ret
tmp_buff:
.long  0
