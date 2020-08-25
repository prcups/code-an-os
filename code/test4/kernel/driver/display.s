    .global move_msg
move_msg:
    pushl %ebp
    movl  %esp, %ebp
    pushl %eax
    pushl %ecx
    pushl %edi
    pushl %esi
    movl  8(%ebp), %eax
    sall  %eax
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
    .ascii " hello, world. "
msg_len:
    .long .-msg
vmem_offset:
    .long 0    
        