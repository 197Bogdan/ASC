How to use: 

as --32 sudoku_solver.asm -o sudoku_solver.o \n
gcc -m32 sudoku_solver.o -o sudoku_solver \n
./sudoku_solver

	Programul citeste un puzzle Sudoku 9x9 din fisierul "sudoku.txt". Input-ul are forma unei matrice, iar pentru spatiile 
	goale se completeaza cu "0". Solutia este scrisa in fisierul "sudoku_solved.txt".
	
	Timp aproximativ de rulare:
	Mai mult de 25 de cifre cunoscute: instantaneu
	21 de cifre cunoscute: apx. 0.1 secunde
	17 cifre cunoscute: 10-75 secunde (depinde mult de input)
	
	Toate exemplele de input din arhiva au solutie unica si au fost generate cu ajutorul https://kjell.haxx.se/sudoku/
