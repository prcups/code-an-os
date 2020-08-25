    .globl init_task1, switch_task
TSS1_SEL = 0x18
LDT1_SEL = 0x20
TSS2_SEL = 0x28
ASCII_1 = 49    	      #1的ascii
ASCII_2 = 50		      #2的ascii
init_task1:                   #初始化task1
    movb  $1, current_task
    movl  $TSS1_SEL, %eax
    ltr   %ax
    movl  $LDT1_SEL, %eax
    lldt  %ax
    ret

switch_task:			#任务切换
    cmpb  $ASCII_1, key_ascii	
    je    1f
    cmpb  $ASCII_2, key_ascii
    je    2f
    jmp   3f		       #其他按键不做响应
1:  cmpb  $1, current_task     #若按下的是1
    je    3f		       #若当前任务是1 则不做响应	
    movb  $1, current_task     #若当前任务是2 则修改为1	
    ljmp  $TSS1_SEL, $0	       #切换到任务1
    jmp   3f
2:  cmpb  $2, current_task     #若按下的是2	
    je    3f		       #若当前任务是2 则不做响应	
    movb  $2, current_task     #若当前任务是1 则修改为2	
    ljmp  $TSS2_SEL, $0	       #切换到任务2	
3:  ret
current_task:
    .byte 0
