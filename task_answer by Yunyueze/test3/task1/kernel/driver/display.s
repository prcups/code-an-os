    .global move_msg
move_msg:
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %edi
    pushl %esi
    #Part1: 打印字符串
    movl  $0,%ebx
    movl  $4,%ecx
    movl  $160,%edx
s:  pushl %ecx			#保存计次循环
    lea   msg(,%ebx,8), %esi	#原字符串的偏移地址(每行多偏了位置1)
    subl  %ebx,%esi             #单行长度要减去多偏的位置
    movl  vmem_offset, %edi     #新字符串的首行起始位置
    cmp $0,%ebx
    je sb                       #若ebx是0 无需进入循环(ecx为0 进循环会死循环)

    movl %ebx,%ecx              #因为之前已经入栈了ecx 所以只要在sb行之前都可以随便用ecx
sa: add %edx,%edi               #累加160 偏移到下一行
    loop sa
    
sb: movl  $7, %ecx  	        #送数的次数等于单行长度
    movb  $0x2, %al		#字符属性
    cld	
1:  movsb
    stosb
    loop  1b
    inc %ebx
    popl %ecx
    loop  s
#Part2: 判断是否到头 是否需要转向
s0: cmpl $0xdb2,vmem_offset #如果到了最右边 则转向为1
    jne s1
    movb $1,offset_direction
    jmp s2
s1: cmpl $0xd20,vmem_offset #如果到了最左边 则转向为0
    jne s2
    movb $0,offset_direction

#Part3:根据方向 更新offset偏移值
s2: cmpb $0,offset_direction #若为0 则偏移加2 反之则减2
    jne s3   
    addl $2,vmem_offset
    jmp f
s3: subl $2,vmem_offset

f:  popl  %esi
    popl  %edi
    popl  %edx
    popl  %ecx
    popl  %ebx
    popl  %eax
    ret
msg:
    .ascii "   *   "
    .ascii " ***** "
    .ascii "   *   "
    .ascii "  * *  "
vmem_offset:
    .long 0xd20   	#每行80个字符 共25行 每行占160个字节 第一行起始位置是0  第二行是160  ...第22行起始位置是21*160=3360=0xd20  终止位置是22*160-2*$msg_len==3520-14=3506=0xdb2
offset_direction:
    .byte 0		#0表示向右(加) 1表示向左(减)
