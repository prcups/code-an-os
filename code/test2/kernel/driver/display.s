    .global print_msg
print_msg:
    movl  $msg, %esi
    movl  $0, %edi
    movl  msg_len, %ecx        
    movb  $0x2, %al
    cld
1:  movsb
    stosb
    loop  1b
    ret
msg:
    .ascii "hello, world."
msg_len:
    .long . - msg
    