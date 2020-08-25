    .globl setup_paging
#本实验中采用二级页表 1张1KB的页目录和1024张1KB的页表 页目录和页表中的项 数据结构完全相同 大小均为4B（32位） 其中低12位用来保存属性 高20位来表示页号 页号后面添12个0就是对应物理页的起始地址 低12位的属性本实验只用低3位 0位是有效位(1有0无) 1位是读写位(1可写0只读) 2位是权限位(1内核态用户态都可访问该页 0只能内核态访问该页)
#令CR3中保存页目录的起始物理地址 页目录中保存1024个表项 每个表项对应描述一张页表的信息(包含其所在的物理页页号)；页表中保存1024个表项 每个表项对应一个物理页的信息(包含其物理页号)
#本实验中我们使用了0号页为页目录 1号页作为内核的页表 2号页作为task1的页表 3号页作为task2的页表 4号页作为task3的页表 5号页作为task4的页表 6~7号页上存放内核的代码数据 8号页上放task1数据代码 9号页上放task2数据代码段  10号页上放task3数据代码段 11号页放task4数据代码段
#我们令 线性空间中低16M的页面页号同物理页号意义对应 将kernel放在线性空间的低64M中(0~0x3FFFFFF) 接下来64MB task1(0x4000000~0x7FFFFFF)  然后64MB放task2(0x8000000~0xbFFFFFF) 然后64MB放task3(0xC000000~0xFFFFFFF)  最后64MB放task4(0x10_000000~)
#物理内存中 kernel StartFrom 0x6000~0x7FFFF(6 7号页)  task1 StartFrom 0x8000(8号页) task2 StartFrom 0x9000(9号页)   task3 StartFrom 0xA000(10号页)  task4 StartFrom(0xB000)(11号页)
#线性空间中 kernel StartFrom 0x0            task1 StartFrom 0x4000000 线性页号0x4000(高10位0x10 低10位0x0)   task2 StartFrom 0x8000000 线页号0x8000(高10位 0x20 低10位0x0)   task3 StartFrom 0xC000000 线性页号0xC000(高十位0x30 低十位0x0)  task4 StartFrom 0x10_000000 线性页号0x10000(高十位0x40 低十位0x0)           

setup_paging:
    #将0x0开始的 1024*6*4=24KB内存区域 全部清0  也就是把0～5号这6个页清空
    xorl  %eax, %eax			#eax清0
    movl  $0, %edi
    movl  $1024*6, %ecx
    cld;rep;stosl             		#将ds:edi用%eax填充 每次填充4字节 共填充%ecx次 cld表示每次执行后edi+1 rep控制循环计数(若stosb则是用al填充)

    movl  %eax, %cr3          		#将页目录表的物理地址送入cr3

    movl  $0x1003, pg_dir+0*4		#页目录第0项  指向0x1000 内核页表的起始页号  3->(011) 内核态可访问 可读写 有效
    movl  $0x2007, pg_dir+0x10*4        #页目录第16项 指向0x2000 task1页表的起始页号 7->(111) 用户态 内核态可访问 可读写 有效    
    movl  $0x3007, pg_dir+0x20*4        #页目录第32项 指向0x3000 task2页表的起始页号 7->(111) 用户态 内核态可访问 可读写 有效
    movl  $0x4007, pg_dir+0x30*4        #页目录第48项 指向0x4000 task3页表的起始页号 7->(111) 用户态 内核态可访问 可读写 有效
    movl  $0x5007, pg_dir+0x40*4        #页目录第64项 指向0x5000 task4页表的起始页号 7->(111) 用户态 内核态可访问 可读写 有效

    movl  $0x0003, pg_kernel+0*4        #内核页表第0项 指向0x0000 0号页    3->(011)内核态可访问 可读写 有效 (同下)
    movl  $0x1003, pg_kernel+1*4        #内核页表第1项 指向0x1000 1号页 
    movl  $0x2003, pg_kernel+2*4	#内核页表第2项 指向0x2000 2号页 
    movl  $0x3003, pg_kernel+3*4	#内核页表第3项 指向0x3000 3号页 
    movl  $0x4003, pg_kernel+4*4	#内核页表第4项 指向0x4000 4号页 
    movl  $0x5003, pg_kernel+5*4        #内核页表第5项 指向0x5000 5号页 
    movl  $0x6003, pg_kernel+6*4        #内核页表第6项 指向0x6000 6号页
    movl  $0x7003, pg_kernel+7*4        #内核页表第7项 指向0x7000 7号页
 
    movl  $0xb8003, pg_kernel+0xb8*4    #内核页表第0xb8项 指向0xb8000 0xb8号页 
  
    movl  $0x8007, pg_task1+0*4         #task1页表第0项 指向0x8000 7->(111) 用户态 内核态可访问 可读写 有效 (同下)
    movl  $0x9007, pg_task2+0*4         #task2页表第0项 指向0x9000
    movl  $0xA007, pg_task3+0*4         #task3页表第0项 指向0xA000
    movl  $0xB007, pg_task4+0*4         #task4页表第0项 指向0xB000

    #将Cr0最高位置1 开启分页模式
    movl  %cr0, %eax                    #将cr0赋值给eax
    orl   $0x80000000, %eax             #将eax最高位置1
    movl  %eax, %cr0                    #eax写回cr0
first_instruction:
    ret
