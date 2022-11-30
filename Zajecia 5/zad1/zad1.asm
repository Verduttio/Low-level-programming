;;;;
BITS 32
section .text
global wartosc        ; funkcja wartosc ma być widziana w innych modułach aplikacji
wartosc:
   enter 0, 0     ;  tworzymy ramkę stosu na początku funkcji
      ; ENTER 0,0 = PUSH EBP / MOV EPB, ESP
      ; po wykonaniu enter 0,0
      ; w [ebp]    znajduje się stary EBP
      ; w [ebp+4]  znajduje się adres powrotny z procedury
      ; w [ebp+8]  znajduje się pierwszy parametr,
      ; w [ebp+12] znajduje się drugi parametr
      ; itd.
      
; prototyp C:
; double wartosc(double a, double b, double  c, double d, double x)
; y = ax^3 + bx^2 + cx + d
      
; pomocnicze makrodefinicje
   %idefine    a	qword [ebp+8]
   %idefine    b	qword [ebp+16]
   %idefine    c	qword [ebp+24]
   %idefine    d	qword [ebp+32]
   %idefine    x	qword [ebp+40]
   
; tu zaczyna się właściwy kod funkcji
	fld		d			;stack: d
	fld		x			;stack: x, d
	fld		c			;stack: c, x, d
	fmulp	st1			;stack: c*x, d
	faddp	st1			;stack: c*x + d
	
	fld		x			;stack: x, c*x + d
	fld		x			;stack: x, x, c*x + d
	fmulp 	st1			;stack: x*x, c*x + d
	fld		b			;stack: b, x*x, c*x + d
	fmulp	st1			;stack: x*x*b, c*x + d
	
	fld		x			;stack: x, b*x*x, c*x + d
	fld		x			;stack: x, x, b*x*x, c*x + d
	fld		x			;stack: x, x, x, b*x*x, c*x + d
	fmulp	st1			;stack: x*x, x, b*x*x, c*x + d
	fmulp	st1			;stack: x*x*x, b*x*x, c*x + d
	fld		a			;stack: a, x*x*x, b*x*x, c*x + d
	fmulp	st1			;stack: x*x*x*a, b*x*x, c*x + d
	
	faddp	st1			;stack: x*x*x*a + b*x*x, c*x + d
	faddp	st1			;stack: x*x*x*a + b*x*x + c*x + d

; tu kończy się właściwy kod funkcji
   leave     ; usuwamy ramkę stosu LEAVE = MOV ESP, EBP / POP EBP
ret    ; wynik zwracany jest w rejestrze eax
