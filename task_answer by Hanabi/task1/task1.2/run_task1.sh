# 汇编、链接bootsect.bin
as -o bootsect.o bootsect.s
ld --oformat binary -Ttext=0 -o bootsect.bin bootsect.o

# 制作硬盘镜像文件
dd if=/dev/zero of=../c.img bs=512 count=2048
dd if=bootsect.bin of=../c.img bs=512 seek=0 conv=notrunc
