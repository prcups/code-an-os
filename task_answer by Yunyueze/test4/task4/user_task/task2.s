DELAY = 0
MOVE = 1
TSS1_SEL = 0x23 #(100_011)
t2=10
task2_start:
    movl  $MOVE, %eax
    movl  move_len, %ebx
    int   $0x80
    call  delay
    subl $1,t2count
    jz r2
    jmp task2_start
r2: movl $t2,t2count
    ljmp $TSS1_SEL,$0
    jmp task2_start   #相当关键
delay:
    movl  $DELAY, %eax
    movl  delay_time, %ebx
    int   $0x80
    ret

move_len:
    .long -80
delay_time:
    .long 1000    
t2count:
    .long t2    
