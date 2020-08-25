    .globl init_task1
TSS1_SEL = 0x20
LDT1_SEL = 0x28

#初始化task1
init_task1:
    movl  $TSS1_SEL, %eax   
    ltr   %ax               #注册TSS1
    movl  $LDT1_SEL, %eax
    lldt  %ax               #注册LDT1
    ret

