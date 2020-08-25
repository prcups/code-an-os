    .global move_msg
move_msg:
    pushl %eax
    pushl %ecx
    pushl %edi
    pushl %esi
    addl  $2, vmem_offset  	#偏移递增2字节 跳过一个字符
    movl  $msg, %esi		#原字符串的偏移地址
    movl  vmem_offset, %edi     #新字符串的起始位置
    movl  msg_len, %ecx		#循环次数=字符串长度
    movb  $0x2, %al		#字符属性
    cld
1:  movsb
    stosb
    loop  1b
    popl  %esi
    popl  %edi
    popl  %ecx
    popl  %eax
    ret
msg:
    .ascii " hello, world."
msg_len:
    .long . - msg
vmem_offset:
    .long 0    
        
