    .globl init_idt, delay_count
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
    movl  $keyboard_interrupt, %edx 
    movw  $0x8e00, %dx
    movl  $0x00080000, %eax
    movw  $keyboard_interrupt, %ax 
    movl  $0x21, %ecx
    lea   idt(,%ecx,8), %esi
    movl  %eax, (%esi)
    movl  %edx, 4(%esi)
    lidt  idt_48
    ret
system_call_interrupt:
    pushl %ds
    pushl %es
    pushl %fs
    pushl %eax
    movw  $0x10, %ax
    movw  %ax, %ds
    movw  %ax, %es    
    movw  $0xf, %ax
    movw  %ax, %fs  
    popl  %eax
    call  *sys_call_table(,%eax,4)
    popl  %fs
    popl  %es
    popl  %ds
    iret
keyboard_interrupt:
    pushl %ds
    pushl %es
    pushl %eax
    movw  $0x10, %ax
    movw  %ax, %ds
    movw  %ax, %es
    call  enable_8259A
    call  enable_keyboard
    call  switch_task
    popl  %eax
    popl  %es
    popl  %ds
    iret
timer_interrupt:
    pushl %ds
    pushl %es
    pushl %eax
    movw  $0x10, %ax
    movw  %ax, %ds
    movw  %ax, %es
    call  enable_8259A
    decl  delay_count
    popl  %eax
    popl  %es
    popl  %ds
    iret
delay_count:
    .long 0
idt_48:
    .word (idt_end-idt)-1
    .long idt
idt:
    .fill 256, 8, 0
idt_end:
    