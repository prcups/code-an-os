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
    pushl %edx
    pushl %edi
    pushl %esi
    movl $0,%edx		  #清空edx

    movl  MOVE_SIZE(%ebp), %eax   #取出飞机单行的移动幅度和方向到eax
    sall  %eax			  #*2
    addl  %eax, vmem_offset	  #更新首行的偏移
    movl  MSG_FROM(%ebp), %esi    #取出字符串源偏移位置到esi
    movl  vmem_offset, %edi       #起始偏移作为目标位置
    movl  $6,%ecx		  #飞机的行数
p0:
    pushl %ecx
   #打印单行飞机
    movl  MSG_SIZE(%ebp), %ecx    #单行长度送入ecx
1:  
    movb  %fs:(%esi), %al         #取出一个字符
    movb  %al, (%edi)             #写到edi
    movb  $2, 1(%edi)             #写属性 
    incl  %esi			  #esi+1
    addl  $2, %edi		  #edi+2
    loop  1b			  #循环检查
    addl  $160,%edx		  #行偏移因子+160
    movl  vmem_offset, %edi       #起始偏移作为目标位置
    addl  %edx,%edi		  #edi偏移到下一行
    popl %ecx
    loop  p0

    popl  %esi
    popl  %edi
    popl  %edx
    popl  %ecx
    popl  %eax    
    popl  %ebp
    ret
vmem_offset:
    .long 0xb8c2a
#每行80个字符 共25行 每行占160个字节 第一行起始位置是0 第二行是160
#第20行是19*160=3040=0xbe0    0xbe0+0xb8000=0xb8be0
#每行占160B 而飛機單行占14B 要打印到中間位置應該偏移160/2-8=72=0x48 
#最終的飛機第一空行的打印位置是 0xb8be0+0x48=0xb8c2b-1
