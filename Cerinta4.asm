.data
space: .asciz " "
formatPrintInteger: .asciz "%d "
empty: .asciz ""
p: .long 1
nr: .long 0
suma: .long 0
tip_operatie: .space 1
nrCol: .space 4
nrLinii: .space 4
nrElem: .space 4
operand: .space 4
s: .space 100 
matrice: .space 1600

.text
.global main
main:

pushl $s                                           #citeste sir instructiuni
call gets
popl %ebp

pushl $s
call strlen
popl %ebp

lea s, %edi
addl %eax, %edi              #index ultimul caracter (\0)
subl $3, %edi                   #index - 3

xor %ecx, %ecx
xor %edx, %edx
movb (%edi, %ecx, 1), %dl             # add sub mul div rot90d
movb %dl, tip_operatie

cmpb $'9', %dl
je construieste_matrice

subl $2, %ecx                            #daca nu e rot90d, calculam operandul, aici luam ultima cifra din operand
movb (%edi, %ecx, 1), %dl

loop_suma:
xor %edx, %edx
movb (%edi, %ecx, 1), %dl

cmpb $48, %dl
jb check								#e - sau spatiu
cmpb $57, %dl
ja check						 

subb $48, %dl                 #char to int

xor %eax, %eax
mov %edx, %eax               #suma = suma + dl * p, dl e cifra curenta
mull p 
add %eax, suma


zero:
mov p, %eax
mov $10, %ebp
mull %ebp                          # p = p* 10
mov %eax, p 

subl $1, %ecx
jmp loop_suma


check:
cmpb $'-', %dl
jne pozitiv

minus:
mov suma, %eax
not %eax               # eax *= -1
inc %eax
mov %eax, operand

jmp construieste_matrice

pozitiv:
mov suma, %eax
mov %eax, operand

construieste_matrice:
pushl $space                           #primul element din input (numele matricei)
pushl $s
call strtok
popl %ebx
popl %ebx

pushl $space
pushl $0
call strtok                               # nr linii
popl %ebx
popl %ebx

push %eax 
call atoi
pop %ebx
mov %eax, nrLinii

pushl $space
pushl $0
call strtok                               # nr coloane
popl %ebx
popl %ebx

push %eax 
call atoi
pop %ebx
mov %eax, nrCol

mov nrLinii, %ebx
mull %ebx                             #nr elemente
mov %eax, nrElem


xor %ebx, %ebx 	             # ebx va fi counter pt loop
parcurgere:

pushl $space
pushl $0
call strtok                               
popl %ebp
popl %ebp

mov %eax, %edi
xor %ebp, %ebp
xor %edx, %edx                              #verifica daca e cifra 0
movb (%edi, %ebp, 1), %dl

lea matrice, %edi
cmpb $'0', %dl
je cifra_0

push %eax 
call atoi
pop %ebp

cmp $0, %eax                         #s au citit toate elementele
je operatie

cifra:                    									#alta cifra in afara de 0
movl %eax, (%edi, %ebx, 4)

inc %ebx
jmp parcurgere

cifra_0:
xor %eax, %eax
movl %eax, (%edi, %ebx, 4)

inc %ebx
jmp parcurgere

operatie:
xor %edx, %edx
mov tip_operatie, %dl                      #print linii si coloane
cmpb $'9', %dl
je rot90d

pushl nrLinii
pushl $formatPrintInteger
call printf
popl %ebx
popl %ebx

pushl nrCol
pushl $formatPrintInteger
call printf
popl %ebx
popl %ebx

xor %ebx, %ebx                  #ebx counter pt parcurgere
lea matrice, %edi

xor %edx, %edx
mov tip_operatie, %dl

cmpb $'a', %dl                               # x 2 3 1 2 3 4 5 6 let x -2 add
je add
cmpb $'s', %dl
je sub
cmpb $'m', %dl
je mul
cmpb $'d', %dl
je div


rot90d:
lea matrice, %edi

pushl nrCol
pushl $formatPrintInteger                   #print coloane si linii
call printf
popl %ebx
popl %ebx

pushl nrLinii
pushl $formatPrintInteger
call printf
popl %ebx
popl %ebx

xor %ecx, %ecx               # ecx = counter1

loop_pereche_noua:

movl nrElem, %ebx          # ebx = counter2
subl nrCol, %ebx             #indexul primului element din fiecare pereche (linie din matricea rotita)
addl %ecx, %ebx

movl (%edi, %ebx, 4), %eax
pushl %ecx
pushl %eax
pushl $formatPrintInteger
call printf
popl %ebp
popl %ebp
popl %ecx

loop_print:
subl nrCol, %ebx
cmp $0, %ebx
jge cont

inc %ecx
cmp nrCol, %ecx              #au fost printate toate perechile (un numar de nrLinii perechi)
je exit
jmp loop_pereche_noua

cont:

movl (%edi, %ebx, 4), %eax
pushl %ecx
pushl %eax
pushl $formatPrintInteger
call printf
popl %ebp
popl %ebp
popl %ecx

jmp loop_print


add:

movl (%edi, %ebx, 4), %eax
add operand, %eax

pushl %eax
pushl $formatPrintInteger
call printf
popl %ebp
popl %ebp

inc %ebx
cmp nrElem, %ebx
je exit
jmp add

sub:

movl (%edi, %ebx, 4), %eax
subl operand, %eax

pushl %eax
pushl $formatPrintInteger
call printf
popl %ebp
popl %ebp

inc %ebx
cmp nrElem, %ebx
je exit
jmp sub

mul:

movl (%edi, %ebx, 4), %eax
imull operand

pushl %eax
pushl $formatPrintInteger
call printf
popl %ebp
popl %ebp

inc %ebx
cmp nrElem, %ebx
je exit
jmp mul

div:
xor %ebp, %ebp

movl (%edi, %ebx, 4), %eax
mov operand, %ecx

cmp $0, %ecx
jge div_1
addl $1, %ebp
notl %ecx
inc %ecx

div_1:                                                  #fac ambele numere pozitive apoi le impart ca altfel nu vrea
cmp $0, %eax
jge div_2
addl $1, %ebp
not %eax
inc %eax

div_2:
xor %edx, %edx
divl %ecx

cmp $1, %ebp
jne print_div

not %eax
inc %eax


print_div:

pushl %eax
pushl $formatPrintInteger
call printf
popl %ebp
popl %ebp

inc %ebx
cmp nrElem, %ebx
je exit
jmp div

exit:    
pushl $empty
call puts
popl %ebx

mov $1, %eax
xor %ebx, %ebx
int $0x80
