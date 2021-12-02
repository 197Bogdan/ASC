.data
let: .asciz "let"
add: .asciz "add"
sub: .asciz "sub"
mul: .asciz "mul"
div: .asciz "div"
formatScan: .asciz "%s"
formatPrintStringS: .asciz "%s "
formatPrintStringNS: .asciz "%s"         #string fara spatiu dupa
formatPrintInt: .asciz "%d "
minus: .asciz "-"
newLine: .asciz "\n"
s: .space 103
char: .space 4           #variabila folosita ca sa afisam cate un caracter (in print_var)

.text

.global main
main:

pushl $s                                           #citeste sir hex
pushl $formatScan
call scanf
popl %ebx
popl %ebx

lea s, %edi                             #incarca sirul in edi
mov $0, %ecx
mov $0, %edx

parcurgere:
mov $0, %ebx                           #compara primul element din tripletul de hex pt a obtine tipul instructiunii
movb (%edi, %ecx, 1), %bl
cmpb $'8', %bl
je numarp
cmpb $'9', %bl
je numarn
cmpb $'A', %bl
je variabila
cmpb $'C', %bl
je operatie
jmp exit

operatie:                  #verifica ce tip de operatie e
inc %ecx
inc %ecx
movl $0, %ebx
movb (%edi, %ecx, 1), %bl
cmpb $'0', %bl
je print_let
cmpb $'1', %bl
je print_add
cmpb $'2', %bl
je print_sub
cmpb $'3', %bl
je print_mul
jmp print_div

numarn:                    # print "-"
pushl %ecx
pushl $minus
pushl $formatPrintStringNS
call printf
popl %ebx
popl %ebx
popl %ecx

numarp:                       # calculeaza hex[1]*16+hex[2] unde hex e tripletul de string in hexa
inc %ecx
mov $0, %eax
movb (%edi, %ecx, 1), %al
cmp $58, %eax
jb e_cifra

e_hex:                        #transforma din ascii value in cifra baza 10
subl $55, %eax
jmp cont
e_cifra:
subl $48, %eax

cont:
shl $4, %eax    
inc %ecx
movl $0, %ebx
movb (%edi, %ecx, 1), %bl
cmp $58, %ebx
jb e_cifra2

e_hex2:
subl $55, %ebx
jmp cont2

e_cifra2:
subl $48, %ebx

cont2:
addl %ebx, %eax

print_numar:                 #print integer
pushl %ecx
pushl %eax
pushl $formatPrintInt
call printf
popl %ebx
popl %ebx
popl %ecx
inc %ecx
jmp parcurgere

variabila:                  #identic cu int, doar ca foloseste print string
inc %ecx
mov $0, %eax
movb (%edi, %ecx, 1), %al
cmp $58, %eax
jb e_cifra_var

e_hex_var:
subl $55, %eax
jmp cont_var
e_cifra_var:
subl $48, %eax

cont_var:
shl $4, %eax    
inc %ecx
movl $0, %ebx
movb (%edi, %ecx, 1), %bl
cmp $58, %ebx
jb e_cifra2_var

e_hex2_var:
subl $55, %ebx
jmp cont2_var

e_cifra2_var:
subl $48, %ebx

cont2_var:
addl %ebx, %eax

print_variabila:
pushl %ecx
movl %eax, char
pushl $char
pushl $formatPrintStringS
call printf
popl %ebx
popl %ebx
popl %ecx
inc %ecx
jmp parcurgere


print_let:
pushl %ecx
pushl $let
pushl $formatPrintStringS
call printf
popl %ebx
popl %ebx 
popl %ecx
inc %ecx
jmp parcurgere

print_add:
pushl %ecx
pushl $add
pushl $formatPrintStringS
call printf
popl %ebx
popl %ebx 
popl %ecx
inc %ecx
jmp parcurgere

print_sub:
pushl %ecx
pushl $sub
pushl $formatPrintStringS
call printf
popl %ebx
popl %ebx 
popl %ecx
inc %ecx
jmp parcurgere

print_mul:
pushl %ecx
pushl $mul
pushl $formatPrintStringS
call printf
popl %ebx
popl %ebx 
popl %ecx
inc %ecx
jmp parcurgere

print_div:
pushl %ecx
pushl $div
pushl $formatPrintStringS
call printf
popl %ebx
popl %ebx 
popl %ecx
inc %ecx
jmp parcurgere

exit:
pushl $newLine
pushl $formatPrintStringS
call printf
popl %ebx
popl %ebx 

mov $1, %eax
xor %ebx, %ebx
int $0x80
