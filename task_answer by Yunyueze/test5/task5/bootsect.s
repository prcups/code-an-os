    .code16
BOOTSEG = 0x7c0
OLDKERNELSEG = 0x7e0
OLDTASKSEG = 0x1020
NEWKERNELSEG = 0
KERNELLEN = 60	  
TASK1LEN = 1	# 70B  
TASK2LEN = 1
TASK3LEN = 1
TASK4LEN = 1
    ljmp  $BOOTSEG, $go
go:
#将引导扇区内容拷贝到0x10000
    movw  $0x7c0,%ax
    movw  %ax, %ds			
    movw  $0,%si
    movw  $0x1000,%ax
    movw  %ax,%es
    movw  $0,%di
    movw  $128,%cx
    cld;rep;movsd
    ljmp  $0x1000,$new_start

new_start:   
    #加载内核到内存中
    movw  %cs, %ax
    movw  %ax, %ds
    movb  $0x42, %ah
    movb  $0x80, %dl
    movw  $parameters_1, %si
    int   $0x13
    #加载task到内存中
    movw  %cs, %ax
    movw  %ax, %ds
    movb  $0x42, %ah
    movb  $0x80, %dl
    movw  $parameters_2, %si
    int   $0x13

    cli
    #先拷贝内核
    movw  $OLDKERNELSEG, %ax
    movw  %ax, %ds
    movw  $0, %si
    movw  $NEWKERNELSEG, %ax
    movw  %ax, %es
    movw  $0, %di
    movl  $KERNELLEN*128, %ecx    #串行传送KL*128次 每次4字节 刚好KL个扇区
    cld;rep;movsd  #cld表示si、di+1 rep修改循环变量不为0就执行movsb ds:si ->es:di 
    #再拷贝task
    movw  $OLDTASKSEG, %ax
    movw  %ax, %ds
    movw  $0, %si
    movw  $NEWKERNELSEG, %ax
    movw  %ax, %es
 
    movw  $0x8000, %di           
    movl  $TASK1LEN*128, %ecx
    cld;rep;movsd    
    movw  $0x9000, %di
    movl  $TASK2LEN*128, %ecx
    cld;rep;movsd    
    movw  $0xa000, %di
    movl  $TASK3LEN*128, %ecx
    cld;rep;movsd    
    movw  $0xb000, %di
    movl  $TASK4LEN*128, %ecx
    cld;rep;movsd    

    movw  %cs, %ax
    movw  %ax, %ds    
    lgdt  gdt_48
    movw  $1, %ax
    lmsw  %ax
    ljmp  $8, $0

parameters_1:
    .word 0x0010
    .word KERNELLEN
    .long 0x07e00000
    .quad 1
parameters_2:
    .word 0x0010
    .word TASK1LEN+TASK2LEN+TASK3LEN+TASK4LEN
    .long 0x10200000
    .quad 61					#从第61号扇区开始加载

gdt_48:
    .word (gdt_end-gdt)-1
    .long 0x10000+gdt

#4KB=4*1024  16进制为0x1000
gdt:
    .quad 0 
     #实际能访问到的扇区大小要高于有意义区间60扇区
    .quad 0x00c09a0000000007  #G=1 段限长(7+1)*4KB=8*4KB=0x8000 起始0x0 (64个扇区)
    .quad 0x00c0920000000007  #G=1 段限长64个扇区 起始0x0 
gdt_end:
    .org  0x1fe
    .word 0xaa55
