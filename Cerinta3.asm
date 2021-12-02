.data
space: .asciz " "
formatPrintInteger: .asciz "%d\n"
formatString: .asciz "%d"              #pentru sprintf
v1: .space 4
string_int: .space 4
suma: .space 4
res: .space 4
s: .space 100
variabile: .asciz ""  

.text
.global main
main:

pushl $s                                           #citeste sir instructiuni
call gets
popl %ebx


xor %eax, %eax

pushl $space                           #primul element din input
pushl $s
call strtok
popl %ebx
popl %ebx

mov %eax, res

mov %eax, %edi
xor %ecx, %ecx
cmpb $'0', (%edi, %ecx, 1)     #prima cifra e fix 0
jne skip

xorl %eax, %eax
pushl %eax
jmp parcurgere


skip:
push res 
call atoi
pop %ebx
cmp $0, %eax     #prima instructiune e variabila?
je variabila

pushl %eax         #primul element e cifra diferita de 0

parcurgere:
pushl $space
pushl $0
call strtok
popl %ebx
popl %ebx

mov %eax, res

cmp $0, %eax                  #s-a terminat inputul
je exit


mov %eax, %edi
xor %ecx, %ecx
cmpb $'0', (%edi, %ecx, 1)               #caz particular cifra 0
jne cont

xorl %eax, %eax
pushl %eax
jmp parcurgere

cont:                                         #verifica daca e operatie
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
cmpb $'l', (%edi, %ecx, 1)
je let

                                 #verifica daca e variabila (diferita de a, s, m, d, l)
push res 
call atoi
pop %ebx
cmp $0, %eax     
je variabila

numar:                                     #sigur e numar diferit de 0
pushl %eax
jmp parcurgere

add:
inc %ecx
cmpb $'d', (%edi, %ecx, 1)
jne variabila
popl %ebx
popl %eax
addl %ebx, %eax
pushl %eax
jmp parcurgere
sub:
inc %ecx
cmpb $'u', (%edi, %ecx, 1)
jne variabila
popl %ebx
popl %eax
subl %ebx, %eax
pushl %eax
jmp parcurgere
mul:
inc %ecx
cmpb $'u', (%edi, %ecx, 1)
jne variabila
popl %ebx
popl %eax
xorl %edx, %edx
mull %ebx
pushl %eax
jmp parcurgere
div:
inc %ecx
cmpb $'i', (%edi, %ecx, 1)
jne variabila
popl %ebx
popl %eax
xorl %edx, %edx
divl %ebx
pushl %eax
jmp parcurgere

let:                #adauga in stringul cu variabile valoarea noii variabile
inc %ecx
cmpb $'e', (%edi, %ecx, 1)
jne variabila
popl %ebx
popl %eax

pushl %eax
pushl $variabile
call strcat
popl %ebp
popl %ebp

mov %ebx, v1
pushl v1
pushl $formatString
pushl $string_int
call sprintf
popl %ebp
popl %ebp
popl %ebp

pushl $string_int
pushl $variabile
call strcat
popl %ebp 
popl %ebp 

jmp parcurgere

variabila:
lea variabile, %edi
xorl %ecx, %ecx
xorl %ebx, %ebx

mov res, %ebp
xorl %edx, %edx
movb (%ebp, %ebx, 1), %dl

parcurge_sir:
movb (%edi, %ecx, 1), %al
cmpb $0, %al
je var_noua          # capat de sir

cmpb %dl, %al             # e in sir deja
je not_var_noua

inc %ecx
jmp parcurge_sir

not_var_noua:
addl %ecx, %edi      #aici se afla variabila gasita anterior

mov $1, %ecx
xorl %edx, %edx
xorl %eax, %eax      # in eax vom calcula valoarea variabilei citite

loop_variabila:           # suma cifrelor pt variabila gasita
movb (%edi, %ecx, 1), %dl
cmp $0, %dl
je inloc_var            # \0 final de string
cmp $'0', %dl         #caz particular pt 0 ca sa nu strice atoi
je cifra_0
cmp $58, %dl
ja inloc_var
cmp $48, %dl               #nu e cifra, urmeaza alta variabila
jb inloc_var

subb $48, %dl
xorl %ebx, %ebx
movl %edx, %ebx

calc_var:
mov $10, %ebp
mull %ebp
addl %ebx, %eax 

inc %ecx
jmp loop_variabila

cifra_0:
movl $10, %ebp
mull %ebp

inc %ecx
jmp loop_variabila

inloc_var:
pushl %eax
jmp parcurgere

var_noua:
pushl res

jmp parcurgere


exit:
popl res      
pushl res
pushl $formatPrintInteger
call printf
popl %ebx
popl %ebx

mov $1, %eax
xor %ebx, %ebx
int $0x80
