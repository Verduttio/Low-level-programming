;;;;
BITS 32

section .data
Two		dw	2

section .text
global prostopadloscian       
prostopadloscian:
   enter 0, 0     ;  tworzymy ramkę stosu na początku funkcji
      ; ENTER 0,0 = PUSH EBP / MOV EPB, ESP
      ; po wykonaniu enter 0,0
      ; w [ebp]    znajduje się stary EBP
      ; w [ebp+4]  znajduje się adres powrotny z procedury
      ; w [ebp+8]  znajduje się pierwszy parametr,
      ; w [ebp+12] znajduje się drugi parametr
      ; itd.
      
; prototyp C:
; void prostopadloscian( float a, float b, float c, float * objetosc, float * pole);
; *objetosc = a * b * c
; *pole = 2ab + 2ac + 2bc = 2(ab + ac + bc)
      
; pomocnicze makrodefinicje
   %idefine    a			dword [ebp+8]
   %idefine    b			dword [ebp+12]
   %idefine    c			dword [ebp+16]
   %idefine    objetosc		dword [ebp+20]
   %idefine    pole			dword [ebp+24]
   
; tu zaczyna się właściwy kod funkcji
	;[COMMAND] Liczymy objetosc --START
	fld		a			;stack: a
	fld		b			;stack: b, a
	fmulp 	st1			;stack: b*a
	fld		c			;stack: c, b*a
	fmulp	st1			;stack: b*a*c
	
	mov		eax, objetosc		;ładujemy adres objetosc do rejestru 
	fstp	dword [eax] 		;ściągamy ze stosu (st0) do *objetosc
	;[COMMAND] Liczymy objetosc --END
	
	;[COMMAND] Liczymy pole --START
	fld		b			;stack: b
	fld		c			;stack: c, b
	fmulp	st1			;stack: b*c
	fld		a			;stack: a, b*c
	fld		c			;stack: c, a, b*c
	fmulp	st1			;stack: a*c, b*c
	fld		a			;stack: a, a*c, b*c
	fld		b			;stack: b, a, a*c, b*c
	fmulp	st1			;stack: a*b, a*c, b*c
	
	faddp	st1			;stack: a*c + a*b, b*c
	faddp	st1			;stack: b*c + a*c + a*b
	
	fild	word [Two]	;stack: 2, b*c + a*c + a*b
	fmulp	st1			;stack: (b*c + a*c + a*b) * 2
	
	mov		eax, pole		;ładujemy adres pole do rejestru
	fstp	dword [eax]	;ściągamy ze stosu (st0) do *pole
	;[COMMAND] Liczymy pole --END


; tu kończy się właściwy kod funkcji
   leave     ; usuwamy ramkę stosu LEAVE = MOV ESP, EBP / POP EBP
ret    ; wynik zwracany jest w rejestrze eax
