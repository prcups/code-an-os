    .globl init_idt, delay_count
COUNT = 1000
init_idt:
    movl  $timer_interrupt, %edx 
    movw  $0x8e00, %dx
    movl  $0x00080000, %eax
    movw  $timer_interrupt, %ax 
    movl  $0x20, %ecx
    lea   idt(,%ecx,8), %esi
    movl  %eax, (%esi)
    movl  %edx, 4(%esi)
    movl  $system_call_interrupt, %edx 
    movw  $0xef00, %dx
    movl  $0x00080000, %eax
    movw  $system_call_interrupt, %ax 
    movl  $0x80, %ecx
    lea   idt(, %ecx, 8), %esi
    movl  %eax, (%esi)
    movl  %edx, 4(%esi)
    lidt  idt_48
    ret
timer_interrupt:
    pushl %ds
    pushl %es
    pushl %eax
    movw  $0x10, %ax
    movw  %ax, %ds
    movw  $0x18, %ax
    movw  %ax, %es
    call  enable_8259A
    decl  delay_count
    subl  $1, timer_count
    jne   1f
    movl  $COUNT, timer_count
    call  switch_task
1:  popl  %eax
    popl  %es
    popl  %ds
    iret
system_call_interrupt:
    pushl %ds
    pushl %es
    pushl %eax
    movw  $0x10, %ax
    movw  %ax, %ds
    movw  $0x18, %ax
    movw  %ax, %es    
    popl  %eax
    call  *sys_call_table(,%eax,4)
    popl  %es
    popl  %ds
    iret
delay_count:
    .long 0
timer_count:
    .long COUNT
idt_48:
    .word (idt_end-idt)-1
    .long 0x7e00+idt
idt:
    .fill 256, 8, 0
idt_end:
    