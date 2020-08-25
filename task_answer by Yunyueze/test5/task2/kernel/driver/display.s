    .global move_msg,printk
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


#将偏移给了%esi   将从ds:esi取出一个字节的内容打印出来
printk:
    pushl %esi
    pushl %edi
    pushl %eax
    pushl %ecx
    movl $0xb8000,%edi  #就在屏幕开头打印
    movl $0x02780230, (%edi)      #依次打印 0x31 0x02 0x78 0x02 即"0x"
    addl $4,%edi
    movw $0,%ax		 	 #清空ax
    #按16进制打印字节内容  
    movb (%esi),%al		  #打印的值 首先是一个字节 我们想办法取高4位和低4位 然后打印对应的ascii码
    shl  $4,%ax			 #对ax左移4位 这样 ah存放高4位
    shr  $4,%al			 #对al右移4位 这样 al存放低4位  
    #先打印高四位的内容
    #若大于9则加0x37得到对应的大写字母ascii
    movl $2,%ecx
s0: cmp  $9,%ah
    jg   s1
    addb $0x30,%ah		 #al现在只放了 加0x30
    jmp s2
s1: addb $0x37,%ah
s2: movb %ah,(%edi)
    movb $2, 1(%edi)
    addl $2,%edi
    movb %al,%ah		#将低四位的值给ah
    loop s0			#打印低四位的值
    popl %ecx
    popl %eax
    popl %edi
    popl %esi
    ret    
