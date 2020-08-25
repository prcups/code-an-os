    .globl init_idt
COUNT = 100
init_idt:
    movl  $timer_interrupt, %edx 
    movw  $0x8e00, %dx
    movl  $0x00080000, %eax
    movw  $timer_interrupt, %ax 
    movl  $0x20, %ecx
    lea   idt(,%ecx,8), %esi
    movl  %eax, (%esi)
    movl  %edx, 4(%esi)
    lidt  idt_48
    ret
timer_interrupt:
    call  enable_8259A
    subl  $1, timer_count
    jne   1f
    movl  $COUNT, timer_count
    call  move_msg
1:  iret
timer_count:
    .long COUNT
idt_48:
    .word (idt_end-idt)-1
    .long 0x7e00+idt
idt:
    .fill 256, 8, 0
idt_end:
