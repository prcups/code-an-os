    .globl init_gdt,tss1,tss2,ldt1,ldt2,gdt
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
    #以下段DPL=0 最高
    .quad 0x00409a007e000fff   #可读可执行的kernel代码段0x7e00开始 长度7*512
    .quad 0x004092007e000fff   #可读写的kernel数据段0x7e00开始 长度7*512
    .quad 0x0040920b80000f9f   #可读写的显存数据段 0xb8000开始 长度4000
#以下段为系统段S=0 因此是8不是9 (P_DPL_S)=(1_00_0) 在S=0时 type=2是LDT段 9是TSS段
    .quad 0 #task1状态段 0x7e00+tss1开始 长度104
    .quad 0 #task1_ldt段 0x7e00+ldt1开始 长度16
    .quad 0 #task2状态段 0x7e00+tss2开始 长度104
    .quad 0 #task2_ldt段 0x7e00+ldt2开始 长度16
gdt_end:

#加载Tss:ltr Tss的段选择符
#每个任务都有一个任务状态段 保存该任务运行到某一时刻的状态
#17个存寄存器的值:4个通用R(eax ebx ecx edx) 6个段R(cs ds es fs gs ss) 5个偏移R(esi edi ebp esp eip) 1个标志R(eflags) 1个开启分页模式使用的CR3
tss1:
    #
    .long 0 
     #esp和ss 内核栈的栈顶指针位置 0x7e00:kernel_stack1_end
    .long kernel_stack1_end, 0x10
    #
    .long 0, 0, 0, 0
    #cr3
    .long 0
    #eip eflags eax ecx edx ebx esp ebp esi edi 
    .long 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    #es cs ss ds fs gs
    .long 0, 0, 0, 0, 0, 0
    #LDT表的段选择符
    .long LDT1_SEL
    #
    .long 0
tss1_end:

tss2:
    #
    .long 0
    # esp和ss 内核栈的栈顶指针位置 0x7e00:kernel_stack2_end
    .long kernel_stack2_end, 0x10
    #
    .long 0, 0, 0, 0
    #cr3
    .long 0
    #eip eflags eax ecx edx ebx esp ebp esi edi 
    .long 0, 0x200, 0, 0, 0, 0, 512, 0, 0, 0
    #es cs ss ds fs gs
    .long 0xf, 0x7, 0xf, 0xf, 0xf, 0xf
    #LDT表的段选择符
    .long LDT2_SEL
    #
    .long 0
tss2_end:

#加载Ldt:lldt LDT表的段选择符
#LDT每个任务都可以拥有一个局部段表来描述自己的数据和代码段
ldt1:
    .quad 0x0040fa008e0001ff #task1 代码段(读/执行)0x8c00开始 长度512 DPL=3用户态
    .quad 0x0040f2008e0001ff #task1 数据段(读/写)0x8c00开始 长度512 DPL=3用户态
ldt1_end:

ldt2:
    .quad 0x0040fa00900001ff#task2 代码段(读/执行)0x8e00开始 长度512 DPL=3用户态
    .quad 0x0040f200900001ff#task2 代码段(读/执行)0x8e00开始 长度512 DPL=3用户态
ldt2_end:

#task1的内核栈
kernel_stack1:
    .fill 50, 4, 0
kernel_stack1_end:

#task2的内核栈
kernel_stack2:
    .fill 50, 4, 0
kernel_stack2_end:
