    .globl init_task1, switch_task
TSS1_SEL = 0x20
LDT1_SEL = 0x28
TSS2_SEL = 0x30

#初始化task1
init_task1:
    movb  $1, current_task  #修改当前task标号为1
    movl  $TSS1_SEL, %eax   
    ltr   %ax               #注册TSS1
    movl  $LDT1_SEL, %eax
    lldt  %ax               #注册LDT1
    ret

#切换进程(1->2 or 2->1)
switch_task:		    
    cmpb  $1, current_task  
    je    1f
    movb  $1, current_task #当前不是1就写1
    ljmp  $TSS1_SEL, $0    #该步骤由CPU完成了当前task的tss保存 和新task的ltr lldt操作 并将新task的tss内容加载到各寄存器中
    jmp   2f
1:  movb  $2, current_task  #当前是哦1就写2
    ljmp  $TSS2_SEL, $0     
2:  ret
current_task:
    .byte 0
