    .global move_msg
move_msg:                  #参数移动幅度保存在内核栈顶
    pushl %ebp             #压ebp
#将当前栈顶赋给ebp ebp+4是自己的位置 ebp+8是参数移动幅度的位置
    movl  %esp, %ebp
    pushl %eax
    pushl %ecx
    pushl %edi
    pushl %esi
    movl  8(%ebp), %eax    #将移动幅度给了eax
    sall  %eax		   #eax左移1位 相当于乘2 获得了在显存中的偏移
    addl  %eax, vmem_offset
    movl  $msg, %esi
    movl  vmem_offset, %edi
    movl  msg_len, %ecx        
    movb  $0x2, %al
    cld
1:  movsb
    stosb
    loop  1b
    popl  %esi
    popl  %edi
    popl  %ecx
    popl  %eax
    popl  %ebp
    ret
msg:
    .fill  80,1,0
    .ascii " hello, world. "
    .fill  80,1,0
msg_len:
    .long .-msg
vmem_offset:
    .long 0    
        
