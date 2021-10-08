.code16
BOOTSEG = 0x7c0
ljmp $BOOTSEG, $_start

msg:
.ascii "Hello World!"
msg_len:
.word . - msg

_start:
	movw %cs, %ax
	movw %ax, %ds
	movw %ax, %es

	/*
	ah: 0x06为清屏
	cx: 左上角坐标
	dx: 右下角坐标
	*/
	movw $0x0600, %ax
	movw $0, %cx
	movw $0x174f, %dx
	int $0x10

	/*
	ah: 0x13为打印
	al：指定属性
	bl: 可选保存字符的属性值
	cx: 字符串长度
	dx: 起始坐标
	es:bp: 首字符地址
	*/
	movw $0x1301, %ax
	movw $msg, %bp
	movw msg_len, %cx
	movw $0x1001, %dx
	movb $2, %bl
	int $0x10

	jmp .

.org 0x1fe
.word 0xaa55
