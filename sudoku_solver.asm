.data
formatPrintInteger: .asciz "%d "
sep: .asciz " \n\t"
file_name: .asciz "sudoku.txt"
space: .asciz " "
invalid: .asciz "Puzzle-ul Sudoku nu are o solutie."
counter: .space 50
valori_string: .space 200
valori: .space 350				# valori citite transformate in int

.text

valid:
pushl %ebp
movl %esp, %ebp

movl 8(%ebp), %eax		# indexul elementului curent
mov %eax, %ecx
movl 12(%ebp), %ebx		#elementul curent

lea counter, %edi
cmpl $9, (%edi, %ebx, 4)		# verificam daca elementul curent a aparut deja de 9 ori
je nr_invalid

pushl %ecx			# salvam pe stiva indexul elementului

lea valori, %edi
mov $9, %ebp		
xorl %edx, %edx
divl %ebp
cmp $0, %edx	# coloana element (0 -> 9)
mov $1, %ebp			# ebp va fi folosit ca loop counter
jne sudoku_check
mov $9, %edx
mov %edx, %ecx
jmp linii_check

sudoku_check:
mov %edx, %ecx
incl %eax			# linie element

linii_check:
cmpl $9, %ebp
ja coloane_check_setup
cmpl %eax, %ebp
jne pas
inc %ebp
addl $9, %ecx
jmp linii_check
pas:

cmpl (%edi, %ecx, 4), %ebx
je nr_invalid_pop
addl $9, %ecx

incl %ebp
jmp linii_check

coloane_check_setup:
popl %ecx					# recuperam indexul
mov $1, %ebp
pushl %ecx				# salvam iar indexul
pushl %eax
pushl %edx
subl $1, %eax
mov $9, %ecx
mull %ecx
mov %eax, %ecx
inc %ecx
popl %edx
popl %eax

coloane_check:
cmpl $9, %ebp
ja patrat_check_setup

cmpl %edx, %ebp
jne pas2
incl %ebp
incl %ecx
jmp coloane_check

pas2:
cmpl (%edi, %ecx, 4), %ebx
je nr_invalid_pop
inc %ecx

incl %ebp
jmp coloane_check

patrat_check_setup:
mov $3, %esi
mov %edx, %ebp			# salvam coloana in ebp, avem linia in eax
popl %ecx						# ecx = index
xorl %edx, %edx
div %esi
cmpl $0, %edx
je modulo_linie
subl $1, %edx			# if
jmp modulo_linie2

modulo_linie:				# else
mov $2, %edx

modulo_linie2:
mov %ebp, %eax
mov $3, %esi
mov %edx, %ebp				# ebp = linie % 3;  0 -> 2, 1-> 0, 2 -> 1;
xorl %edx, %edx
divl %esi

cmpl $0, %edx
je modulo_coloana
subl $1, %edx			# if
jmp modulo_coloana2
modulo_coloana:		# else	# edx = coloana % 3;  0 -> 2, 1-> 0, 2 -> 1;
mov $2, %edx

modulo_coloana2:
mov %ebp, %eax
xorl %ebp, %ebp		# eax = format linie ; edx = format coloana ; ecx = index 
xorl %esi, %esi		# ebx = element; ebp = loop counter 1 ; esi = loop counter 2

patrat_check1:
cmpl %esi, %edx
je patrat_check2

subl $1, %ecx
cmpl (%edi, %ecx, 4), %ebx
je nr_invalid

incl %esi
jmp patrat_check1

patrat_check2:
cmp %ebp, %eax
je nr_valid

subl $6, %ecx
incl %ebp
xorl %esi, %esi
mov $3, %edx
jmp patrat_check1


nr_invalid_pop:
popl %ecx

nr_invalid:
xorl %eax, %eax		# return 0
popl %ebp
ret

nr_valid:
mov $1, %eax			# return 1
popl %ebp
ret





debug:
jmp debug_end

sudoku:

pushl %ebp
movl %esp, %ebp
mov 8(%ebp), %eax


cmpl $81, %eax
ja solutie					# sfarsit backtracking

lea valori, %edi
movl (%edi, %eax, 4), %edx
cmp $0, %edx
jne element_fixat		# daca elementul e fixat trecem peste

incl %edx			# edx=1 va lua valori de la 1 la 9
loop:
cmpl $2, %eax
je debug
debug_end:
cmpl $9, %edx
jbe skip
popl %ebp
ret					# pas inapoi in backtracking	daca edx a iesit din intervalul [1,9]

skip:
pushl %eax	#salvam eax si edx
pushl %edx

pushl %edx	#numar
pushl %eax	 #index
call valid
popl %ecx
popl %ecx

cmpl $0, %eax
je element_invalid
popl %edx 			# restauram eax si edx
popl %eax

element_valid:
lea valori, %edi
movl %edx, (%edi, %eax, 4)		# construim solutia in vector
lea counter, %edi
addl $1, (%edi, %edx, 4)

pushl %edx
incl %eax
pushl %eax
call sudoku		# permutare(index+1)
popl %eax
subl $1, %eax

popl %edx
lea counter, %edi
subl $1, (%edi, %edx, 4)

lea valori, %edi
movl $0, (%edi, %eax, 4)

incl %edx
jmp loop

element_invalid: 
popl %edx 		# restauram eax si edx
popl %eax
incl %edx
jmp loop

element_fixat:

pushl %eax	#salvam eax si edx
pushl %edx

pushl %edx	#numar
pushl %eax	 #index
call valid
popl %ecx
popl %ecx

cmpl $1, %eax				
je skip2

popl %edx						#pas inapoi daca e nevoie
popl %eax
popl %ebp
ret 

skip2:
popl %edx
popl %eax

lea counter, %edi
addl $1, (%edi, %edx, 4)

pushl %edx
incl %eax
pushl %eax
call sudoku		# permutare(index+1)
popl %eax
subl $1, %eax
popl %edx

lea counter, %edi
subl $1, (%edi, %edx, 4)

popl %ebp
ret 





.global main
main:

mov $5, %eax							#open file
mov $file_name, %ebx
xorl %ecx, %ecx
movl $0777, %edx
int $0x80

mov %eax, %ebx						#read from file
mov $3, %eax
mov $valori_string, %ecx
movl $170, %edx
int $0x80

movl $6, %eax							#close file
int $0x80

pushl $sep
pushl $valori_string
call strtok
pop %edx
pop %edx

push %eax 
call atoi
pop %ebx

mov $1, %ecx
lea valori, %edi
movl %eax, (%edi, %ecx, 4)			# primul numar citit
incl %ecx

str_to_int:				# transforma inputul din string in vector de int
pushl %ecx

pushl $sep
pushl $0
call strtok
pop %edx
pop %edx

popl %ecx

cmpl $0, %eax
je str_to_int_exit

pushl %ecx
push %eax 
call atoi
pop %ebx
popl %ecx

lea valori, %edi
mov %eax, (%edi, %ecx, 4)
incl %ecx
jmp str_to_int

str_to_int_exit:
mov $1, %eax
pushl %eax
call sudoku		# sudoku(%eax) unde %eax creste de la 1 la 81 
popl %eax				

fara_solutie:			# daca se iese din backtracking fara sa se gaseasca o solutie, se reajunge aici
push $invalid
call puts
popl %ebx
jmp exit_2


solutie:
mov $1, %ebx
mov $1, %ecx
mov $1, %edx
lea valori, %edi

print_loop:
cmpl $9, %ecx
ja newLine

pushl %edx
pushl %ecx

pushl (%edi, %ebx, 4)
pushl $formatPrintInteger
call printf
popl %ecx
popl %ecx

popl %ecx		#recuperam valorile
popl %edx

incl %ebx
incl %ecx
jmp print_loop

newLine:
push %ecx
push %edx

push $space
call puts
popl %ecx

pop %edx
pop %ecx

cmpl $9, %edx
je exit_2
mov $1, %ecx
incl %edx
jmp print_loop

exit_2:
mov $1, %eax
xor %ebx, %ebx
int $0x80
