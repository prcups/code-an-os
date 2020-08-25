# 汇编、链接bootsect.bin
as -o bootsect.o bootsect.s
ld --oformat binary -Ttext=0 -o bootsect.bin bootsect.o

# 汇编、链接kernel.bin
as -g --32 -o head.o kernel/head.s
as -g --32 -o display.o kernel/driver/display.s
ld -m elf_i386 -Ttext=0 -o kernel.tmp head.o display.o
objcopy -O binary -S kernel.tmp kernel.bin

# 创建map文件
nm -v kernel.tmp > kernel.map

# 制作硬盘镜像文件
dd if=/dev/zero of=../c.img bs=512 count=2048
dd if=bootsect.bin of=../c.img bs=512 seek=0 conv=notrunc
dd if=kernel.bin of=../c.img bs=512 seek=1 conv=notrunc
