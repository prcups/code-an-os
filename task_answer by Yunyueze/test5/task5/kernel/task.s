    .globl init_task1, switch_task
TSS1_SEL = 0x18
LDT1_SEL = 0x20
TSS2_SEL = 0x28
TSS3_SEL = 0x38
TSS4_SEL = 0x48

ASCII_w =  0x77    	      #w的ascii
ASCII_s =  0x73		      #s的ascii
ASCII_a =  0x61		      #a的ascii
ASCII_d =  0x64               #d的ascii

init_task1:                   #初始化task1
    movb  $1, current_task
    movl  $TSS1_SEL, %eax
    ltr   %ax
    movl  $LDT1_SEL, %eax
    lldt  %ax
    ret

switch_task:			#任务切换
    cmpb  $ASCII_w, key_ascii  #如果按下的是w	
    je    1f 
    cmpb  $ASCII_s, key_ascii  #如果按下的是s
    je    2f
    cmpb  $ASCII_a, key_ascii  #如果按下的是a
    je    3f
    cmpb  $ASCII_d, key_ascii  #如果按下的是d
    je    4f
    jmp   f0		       #其他按键不做响应
1:  cmpb  $1, current_task     #若按下的是w
    je    f0		       #若当前任务是1 则不做响应
    jmp t1		       #若不是任务1 则切换到任务1	

2:  cmpb  $2, current_task     #若按下的是s	
    je    f0		       #若当前任务是2 则不做响应	
    jmp t2		       #若不是任务2 则切换到任务2   

3:  cmpb  $3, current_task     #若按下的是a
    je    f0                   #若当前任务是3 则不做响应
    jmp t3                     #若不是任务3 则切换到任务3    

4:  cmpb  $4, current_task     #若按下的是d
    je    f0                   #若当前任务是4 则不做响应
    jmp t4                     #若不是任务4 则切换到任务4    

#切换到任务1     
t1: movb  $1, current_task     
    ljmp  $TSS1_SEL, $0      
    jmp f0

#切换到任务2     
t2: movb  $2, current_task     
    ljmp  $TSS2_SEL, $0 
    jmp f0

#切换到任务3     
t3: movb  $3, current_task     
    ljmp  $TSS3_SEL, $0 
    jmp f0

#切换到任务4     
t4: movb  $4, current_task     
    ljmp  $TSS4_SEL, $0 
    jmp f0
f0:  ret
current_task:
    .byte 0
