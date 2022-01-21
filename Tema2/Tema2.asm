.data
formatPrintInteger: .asciz "%d "
newLine: .asciz "\n"
sep: .asciz " "
n: .long 0
m: .long 0
invalid: .asciz "-1"
counter: .space 128		
valori_string: .space 300
valori: .space 400				# valori citite transformate in int
nr_elemente: .long 0

.text
avoid_negative_index:
mov m, %ecx
subl %eax, %ecx
inc %ecx
mov $1, %eax
jmp compare_last_elements

valid:
pushl %ebp
movl %esp, %ebp

movl 8(%ebp), %eax		# indexul elementului curent
movl 12(%ebp), %ebx		#elementul curent

lea counter, %edi
cmpl $3, (%edi, %ebx, 4)		# verificam daca elementul curent a aparut deja de 3 ori
je nr_invalid

lea valori, %edi
xorl %ecx, %ecx

cmpl %eax, m
jae avoid_negative_index
subl m, %eax						# eax = index curent - m, primul element cu care vom compara (doar daca eax > m)

compare_last_elements:						# comparam ultimele m elemente fata de indexul curent cu elementul curent
cmpl m, %ecx			# ecx = counter de la 0 la m-1
je nr_valid

cmpl (%edi, %eax, 4), %ebx
je nr_invalid

incl %ecx
incl %eax
jmp compare_last_elements


nr_invalid:
xorl %eax, %eax		# return 0
popl %ebp
ret

nr_valid:
mov $1, %eax			# return 1
popl %ebp
ret

permutare:

pushl %ebp
movl %esp, %ebp
mov 8(%ebp), %eax

cmpl nr_elemente, %eax
ja print_solutie					# sfarsit backtracking

lea valori, %edi
movl (%edi, %eax, 4), %edx
cmp $0, %edx
jne element_fixat		# daca elementul e fixat trecem peste

incl %edx			# edx=1 va lua valori de la 1 la n 
loop:
cmpl n, %edx
jbe skip
popl %ebp
ret					# pas inapoi in backtracking	daca edx a iesit din intervalul [1,n]

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
call permutare		# permutare(index+1)
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
call permutare		# permutare(index+1)
popl %eax
subl $1, %eax
popl %edx

lea counter, %edi
subl $1, (%edi, %edx, 4)

popl %ebp
ret 

.global main
main:

pushl $valori_string					# citire
call gets
pop %edx

pushl $sep
pushl $valori_string
call strtok
pop %edx
pop %edx

push %eax 
call atoi
pop %ebx

movl %eax, n
movl $3, %edx
mull %edx
mov %eax, nr_elemente

pushl $sep
pushl $0
call strtok
pop %edx
pop %edx

push %eax 
call atoi
pop %ebx

movl %eax, m

mov $1, %ecx
lea valori, %edi
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
call permutare		# permutare(%eax) unde %eax creste de la 1 la n*3 (nr elem permutare) 
popl %eax				

fara_solutie:			# daca se iese din backtracking fara sa se gaseasca o solutie, se reajunge aici
push $invalid
call puts
popl %ebx
jmp exit_2


print_solutie:
mov $1, %ecx
lea valori, %edi

print_loop:
cmpl nr_elemente, %ecx
ja exit
pushl %ecx

pushl (%edi, %ecx, 4)
pushl $formatPrintInteger
call printf
popl %ebx
popl %ebx

popl %ecx
incl %ecx
jmp print_loop

exit:    
push $sep
call puts
popl %ebx
exit_2:
mov $1, %eax
xor %ebx, %ebx
int $0x80
