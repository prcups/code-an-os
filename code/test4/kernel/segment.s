    .globl init_gdt
LDT1_SEL = 0x28
LDT2_SEL = 0X38
init_gdt:
    lgdt  gdt_48
    ret
gdt_48:
    .word (gdt_end-gdt)-1
    .long 0x7e00+gdt
gdt:
    .quad 0
    .quad 0x00409a007e000dff
    .quad 0x004092007e000dff
    .quad 0x0040920b80000f9f
    .word 0x0067, 0x7e00+tss1, 0x8900, 0x0000
    .word 0x000f, 0x7e00+ldt1, 0x8200, 0x0000
    .word 0x0067, 0x7e00+tss2, 0x8900, 0x0000
    .word 0x000f, 0x7e00+ldt2, 0x8200, 0x0000
gdt_end:
tss1:
    .long 0
    .long kernel_stack1_end, 0x10
    .long 0, 0, 0, 0
    .long 0
    .long 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    .long 0, 0, 0, 0, 0, 0
    .long LDT1_SEL
    .long 0
tss1_end:
ldt1:
    .quad 0x0040fa008c0001ff
    .quad 0x0040f2008c0001ff
ldt1_end:
tss2:
    .long 0
    .long kernel_stack2_end, 0x10
    .long 0, 0, 0, 0
    .long 0
    .long 0, 0x200, 0, 0, 0, 0, 512, 0, 0, 0
    .long 0xf, 0x7, 0xf, 0xf, 0xf, 0xf
    .long LDT2_SEL
    .long 0
tss2_end:
ldt2:
    .quad 0x0040fa008e0001ff
    .quad 0x0040f2008e0001ff
ldt2_end:
kernel_stack1:
    .fill 50, 4, 0
kernel_stack1_end:
kernel_stack2:
    .fill 50, 4, 0
kernel_stack2_end:
