.data
space: .asciz " "
formatScan: .asciz "%s"
formatPrint: .asciz "%d\n"
res: .space 4
s: .space 400


.text


.global main
main:

pushl $s                                           #citeste sir instructiuni
call gets
popl %ebx


xor %eax, %eax

pushl $space
pushl $s
call strtok
popl %ebx
popl %ebx
mov %eax, res

push res 
call atoi
pop %ebx
pushl %eax

parcurgere:
pushl $space
pushl $0
call strtok
popl %ebx
popl %ebx
cmp $0, %eax
je exit

mov %eax, res
mov %eax, %edi
xorl %ecx, %ecx
cmpb $'a', (%edi, %ecx, 1)
je add
cmpb $'s', (%edi, %ecx, 1)
je sub
cmpb $'m', (%edi, %ecx, 1)
je mul
cmpb $'d', (%edi, %ecx, 1)
je div

numar:
push res 
call atoi
pop %ebx
pushl %eax
jmp parcurgere

add:
popl %ebx
popl %eax
addl %ebx, %eax
pushl %eax
jmp parcurgere
sub:
popl %ebx
popl %eax
subl %ebx, %eax
pushl %eax
jmp parcurgere
mul:
popl %ebx
popl %eax
xorl %edx, %edx
mull %ebx
pushl %eax
jmp parcurgere
div:
popl %ebx
popl %eax
xorl %edx, %edx
divl %ebx
pushl %eax
jmp parcurgere



exit:
popl res      
pushl res
pushl $formatPrint
call printf
popl %ebx
popl %ebx

mov $1, %eax
xor %ebx, %ebx
int $0x80
