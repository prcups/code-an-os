    .global move_msg
MSG_FROM = 16
MSG_SIZE = 12
MOVE_SIZE = 8
move_msg:
    pushl %ebp
    movl  %esp, %ebp
    pushl %eax
    pushl %ecx
    pushl %edi
    pushl %esi
    movl  MOVE_SIZE(%ebp), %eax
    sall  %eax
    addl  %eax, vmem_offset
    movl  MSG_FROM(%ebp), %esi
    movl  vmem_offset, %edi
    movl  MSG_SIZE(%ebp), %ecx
1:  movb  %fs:(%esi), %al
    movb  %al, (%edi)
    movb  $2, 1(%edi)
    incl  %esi
    addl  $2, %edi
    loop  1b
    popl  %esi
    popl  %edi
    popl  %ecx
    popl  %eax    
    popl  %ebp
    ret
vmem_offset:
    .long 0xb8000 
    