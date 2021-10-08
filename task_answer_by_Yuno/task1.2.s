.code 16
BOOTSEG = 0x7c0
ljmp $BOOTSEG, $_start

plane:
.ascii	"  *"
.word	0x0d0a
.ascii	"*****"
.word	0x0d0a
.ascii	"  *"
.word	0x0d0a
.ascii	" * *"
len:
.word . - plane

_start:
	movw %cs, %ax
	movw %ax, %ds
	movw %ax, %es

	movw $0x0600, %ax
	movw $0, %cx
	movw $0x174f, %dx
	int $0x10

	movw $0x1301, %ax
	movb $2, %bl
	movw $plane, %bp
	movw len, %cx
	movw $0x1003, %dx
	int $0x10

	jmp .

.org 0x1fe
.word 0xaa55
