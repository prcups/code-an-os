    .code16
BOOTSEG = 0x7c0
KERNELLEN = 6 #修正为6扇区
    ljmp  $BOOTSEG, $go
go:
    movw  %cs, %ax
    movw  %ax, %ds
    movb  $0x42, %ah
    movb  $0x80, %dl
    movw  $parameters, %si
    int   $0x13
    cli
    lgdt  gdt_48
    movw  $1, %ax
    lmsw  %ax
    ljmp  $8, $0
parameters:
    .word 0x0010
    .word KERNELLEN
    .long 0x07e00000
    .quad 1
gdt_48:
    .word (gdt_end-gdt)-1
    .long 0x7c00+gdt
gdt:
    .quad 0 
    .quad 0x00409a007e000bff   #要修正为6扇区才放得下来
    .quad 0x004092007e000bff
    .quad 0x0040920b80000f9f
gdt_end:
    .org  0x1fe
    .word 0xaa55
