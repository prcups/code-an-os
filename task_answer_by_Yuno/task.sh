#!/bin/bash
as -o $1.o $1.s
if [ $? -eq 0 ];then
	ld --oformat binary -Ttext=0 -o $1.bin $1.o
	qemu-img create $1.img 1M
	dd if=$1.bin of=$1.img bs=512 seek=0 conv=notrunc
	qemu-system-i386 --drive file=$1.img,format=raw -m 1M 
	rm $1.img $1.o $1.bin
fi
