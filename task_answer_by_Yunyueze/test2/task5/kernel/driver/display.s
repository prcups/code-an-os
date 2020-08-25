    .global print_msg #全局化符号声明
#符号的值是函数的第一条机器指令在函数所在可执行文件中的偏移地址
print_msg:
    movl  $msg, %esi    
    movl  $0xb0200, %edi
    movl  msg_len, %ecx        
    movb  $0x2, %al
    cld #cld esi/edi递增更新 std esi/edi递减更新
s:  movsb #[ds:esi]--1Byte-->[es:edi] esi edi更新 写字符
    stosb # %al------>[es:edi]   edi更新  写属性
    loop  s #计数寄存器ecx减1  若不为0则跳回标记处
    ret
msg:
    .ascii "hello, world."
msg_len:
    .long . - msg
    
