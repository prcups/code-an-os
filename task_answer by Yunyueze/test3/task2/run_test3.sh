# 汇编、链接bootsect.bin
as -o bootsect.o bootsect.s
ld --oformat binary -Ttext=0 -o bootsect.bin bootsect.o

# 汇编、链接kernel.bin
as -g --32 -o head.o kernel/head.s
as -g --32 -o interrupt.o kernel/interrupt.s
as -g --32 -o display.o kernel/driver/display.s
as -g --32 -o 8259A.o kernel/driver/8259A.s
as -g --32 -o 8253.o kernel/driver/8253.s
as -g --32 -o keyboard.o kernel/driver/keyboard.s
ld -m elf_i386 -Ttext=0 -o kernel.tmp head.o interrupt.o display.o 8259A.o 8253.o keyboard.o
objcopy -O binary -S kernel.tmp kernel.bin

# 创建map文件
nm -v kernel.tmp > kernel.map

# 制作硬盘镜像文件
dd if=/dev/zero of=../c.img bs=512 count=2048
dd if=bootsect.bin of=../c.img bs=512 seek=0 conv=notrunc
dd if=kernel.bin of=../c.img bs=512 seek=1 conv=notrunc
