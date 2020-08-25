    .global move_msg
MSG_FROM = 16
MSG_SIZE = 12
MOVE_SIZE = 8

#16-------  <-ebp+16
#ebx
#12-------  <-ebp+12
#ecx
#8-------   <-ebp+8
#edx
#4-------
#esp
#0------- <-ebp

move_msg:
    pushl %ebp
    movl  %esp, %ebp            #将栈指针的值给ebp 便于后续ebp从栈中取参数
    pushl %eax
    pushl %ecx
    pushl %edi
    pushl %esi


    movl  MOVE_SIZE(%ebp), %eax   #取出字符串移动幅度和方向到eax
    sall  %eax			  #*2
    addl  %eax, vmem_offset	  #更新偏移
    movl  MSG_FROM(%ebp), %esi    #取出字符串源偏移位置到esi
    movl  vmem_offset, %edi       #起始偏移作为目标位置
    movl  MSG_SIZE(%ebp), %ecx    #字符串长度送入ecx

1:  movb  %fs:(%esi), %al         #取出一个字符
    movb  %al, (%edi)             #写到edi
    movb  $2, 1(%edi)             #写属性 
    incl  %esi			  #esi+1
    addl  $2, %edi		  #edi+2
    loop  1b			  #循环检查


    popl  %esi
    popl  %edi
    popl  %ecx
    popl  %eax    
    popl  %ebp
    ret
vmem_offset:
    .long 0xb8000 
    
