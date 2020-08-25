    .globl init_gdt
LDT1_SEL = 0x20
LDT2_SEL = 0X30
LDT3_SEL = 0x40
LDT4_SEL = 0x50

init_gdt:
    lgdt  gdt_48
    ret
gdt_48:
    .word (gdt_end-gdt)-1
    .long gdt
gdt:
    .quad 0
    .quad 0x00c09a0000000007
    .quad 0x00c09200000000b8 
    .word 0x0067, tss1, 0x8900, 0x0000
    .word 0x0017, ldt1, 0x8200, 0x0000
    .word 0x0067, tss2, 0x8900, 0x0000
    .word 0x0017, ldt2, 0x8200, 0x0000
    .word 0x0067, tss3, 0x8900, 0x0000
    .word 0x0017, ldt3, 0x8200, 0x0000
    .word 0x0067, tss4, 0x8900, 0x0000
    .word 0x0017, ldt4, 0x8200, 0x0000
gdt_end:
tss1:
    .long 0
    .long kernel_stack1_end, 0x10
    .long 0, 0, 0, 0
    .long pg_dir
    .long 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    .long 0, 0, 0, 0, 0, 0
    .long LDT1_SEL
    .long 0
tss1_end:
ldt1:
    .quad 0x04c0fa0000000000
    .quad 0x04c0f20000000000
ldt1_end:

tss2:
    .long 0
    .long kernel_stack2_end, 0x10
    .long 0, 0, 0, 0
    .long pg_dir
    .long 0, 0x200, 0, 0, 0, 0, 0x1000, 0, 0, 0
    .long 0xf, 0x07, 0xf, 0xf, 0xf, 0xf
    .long LDT2_SEL
    .long 0
tss2_end:
ldt2:
    .quad 0x08c0fa0000000000
    .quad 0x08c0f20000000000
ldt2_end:

tss3:
    .long 0
    .long kernel_stack3_end, 0x10
    .long 0, 0, 0, 0
    .long pg_dir
    .long 0, 0x200, 0, 0, 0, 0, 0x1000, 0, 0, 0
    .long 0xf, 0x07, 0xf, 0xf, 0xf, 0xf
    .long LDT3_SEL
    .long 0
tss3_end:

ldt3:
    .quad 0x0cc0fa0000000000
    .quad 0x0cc0f20000000000
ldt3_end:

tss4:
    .long 0
    .long kernel_stack4_end, 0x10
    .long 0, 0, 0, 0
    .long pg_dir
    .long 0, 0x200, 0, 0, 0, 0, 0x1000, 0, 0, 0
    .long 0xf, 0x07, 0xf, 0xf, 0xf, 0xf
    .long LDT4_SEL
    .long 0
tss4_end:
ldt4:
    .quad 0x10c0fa0000000000
    .quad 0x10c0f20000000000
ldt4_end:


kernel_stack1:
    .fill 50, 4, 0
kernel_stack1_end:
kernel_stack2:
    .fill 50, 4, 0
kernel_stack2_end:
kernel_stack3:
    .fill 50, 4, 0
kernel_stack3_end:
kernel_stack4:
    .fill 50, 4, 0
kernel_stack4_end:
