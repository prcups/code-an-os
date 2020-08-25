    .globl sys_call_table
sys_call_table:                   #系统调用入口地址表
    .long sys_delay           
    .long sys_move        

sys_delay:
    movl  %ebx, delay_count      #调用0x80的0号功能时ebx传入计数器初值
1:  cmpl  $0, delay_count 
    jg    1b
    ret

sys_move:
    pushl %ebx
    pushl %ecx
    pushl %edx           #将move_msg需要的三个参数入栈保存
    call  move_msg      #调用move_msg 沿指定方向移动字符串
    addl  $12, %esp     #手动删除压入的三个参数值
    ret

