    .globl init_task1, switch_task
TSS1_SEL = 0x18
LDT1_SEL = 0x20
TSS2_SEL = 0x28
ASCII_1 = 49
ASCII_2 = 50
init_task1:
    movb  $1, current_task
    movl  $TSS1_SEL, %eax
    ltr   %ax
    movl  $LDT1_SEL, %eax
    lldt  %ax
    ret
switch_task:
    cmpb  $ASCII_1, key_ascii
    je    1f
    cmpb  $ASCII_2, key_ascii
    je    2f
    jmp   3f
1:  cmpb  $1, current_task
    je    3f
    movb  $1, current_task
    ljmp  $TSS1_SEL, $0
    jmp   3f
2:  cmpb  $2, current_task
    je    3f
    movb  $2, current_task
    ljmp  $TSS2_SEL, $0
3:  ret
current_task:
    .byte 0
