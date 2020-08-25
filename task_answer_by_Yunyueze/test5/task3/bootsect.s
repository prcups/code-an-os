    .code16
BOOTSEG = 0x7c0
OLDKERNELSEG = 0x7e0
NEWKERNELSEG = 0
KERNELLEN = 40	# 20146B   40*512
TASK1LEN = 1	# 70B  
TASK2LEN = 1
    ljmp  $BOOTSEG, $go
go:
    movw  %cs, %ax
    movw  %ax, %ds
    movb  $0x42, %ah
    movb  $0x80, %dl
    movw  $parameters, %si
    int   $0x13
    cli
    movw  $OLDKERNELSEG, %ax
    movw  %ax, %ds
    movw  $0, %si
    movw  $NEWKERNELSEG, %ax
    movw  %ax, %es
    movw  $0, %di
    movl  $KERNELLEN*128, %ecx    #串行传送KL*128次 每次4字节 刚好KL个扇区
    cld;rep;movsd  #cld表示si、di+1 rep修改循环变量不为0就执行movsb ds:si ->es:di 
    movw  $KERNELLEN*512, %di           
    movl  $TASK1LEN*128, %ecx
    cld;rep;movsd    
    movw  $KERNELLEN*512+TASK1LEN*8*512, %di
    movl  $TASK2LEN*128, %ecx
    cld;rep;movsd    
    movw  %cs, %ax
    movw  %ax, %ds    
    lgdt  gdt_48
    movw  $1, %ax
    lmsw  %ax
    ljmp  $8, $0
parameters:
    .word 0x0010
    .word KERNELLEN+TASK1LEN+TASK2LEN
    .long 0x07e00000
    .quad 1
gdt_48:
    .word (gdt_end-gdt)-1
    .long 0x7c00+gdt

#4KB=4*1024  16进制为0x5000
gdt:
    .quad 0 
    .quad 0x00c09a0000000004  #G=1 段限长(4+1)*4KB=5*4KB=0x5000 起始0x0 (40个扇区)
    .quad 0x00c0920000000004  #G=1 段限长40个扇区 起始0x0 
gdt_end:
    .org  0x1fe
    .word 0xaa55
