    .code16
BOOTSEG = 0x7c0
    ljmp  $BOOTSEG, $go
go:
    movw  %cs, %ax
    movw  %ax, %ds
    movw  %ax, %es
    call clear
    #Print string
    movw  $0x1301, %ax 	#ah 0x13 功能号 al 1 光标和字符属性
    movb  $4, %bl    	#字符属性(亮度位/闪烁位+rgb) 0000 0100
    movw  $msg,%bp      #字符串首地址
    movw  $0,%dx	#起始打印位置
    movw  $4,%cx    	#循环次数(对应字符串行数)
msg_len=5
s:
    push %cx
    movw  $msg_len, %cx 	#字符串长度
    int   $0x10			
    push %bx
    movw $msg_len,%bx
    addw %bx,%bp		#bp偏移一行
    pop %bx
    incb %dh			#dh下移一行
    pop %cx			#出栈计次变量cx
loop s  
    jmp   .
msg:
    .ascii "  *  "
    .ascii "*****"
    .ascii "  *  "
    .ascii " * * "
clear:
    push  %ax
    push  %cx
    push  %dx
    #Clear screen
    movw  $0x0600,%ax	#ah 0x6功能号,al 0(上卷行数 0表示全部)
    movw  $0,%cx	#左上角坐标(ch,cl)
    movw  $0x184F,%dx   #右下角坐标(dh,dl)
    int   $0x10
    pop   %dx
    pop   %cx
    pop   %ax
    ret
.org  0x1fe
.word 0xaa55
