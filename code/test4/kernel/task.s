    .globl init_task1, switch_task
TSS1_SEL = 0x20
LDT1_SEL = 0x28
TSS2_SEL = 0x30
init_task1:
    movb  $1, current_task
    movl  $TSS1_SEL, %eax
    ltr   %ax
    movl  $LDT1_SEL, %eax
    lldt  %ax
    ret
switch_task:
    cmpb  $1, current_task
    je    1f
    movb  $1, current_task
    ljmp  $TSS1_SEL, $0
    jmp   2f
1:  movb  $2, current_task
    ljmp  $TSS2_SEL, $0
2:  ret
current_task:
    .byte 0
