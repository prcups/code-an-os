    .code16
BOOTSEG = 0x7c0
    ljmp  $BOOTSEG, $go
go:
    movw  %cs, %ax
    movw  %ax, %ds
    movw  %ax, %es
    call clear
    #Print string
    movw  $msg, %bp
    movw  $0x1301, %ax 	#ah 0x13 功能号 al 1 光标和字符属性
    movb  $4, %bl    	#字符属性(亮度位/闪烁位+rgb) 0000 0100
    movw  msg_len, %cx 	#字符串长度
    movw  $0, %dx	#开始打印位置(dh,dl)
    int   $0x10
    jmp   .
msg:
    .ascii "  *\r\n"
    .ascii "*****\r\n"
    .ascii "  *\r\n"
    .ascii " * *"

msg_len:
    .word . - msg
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
