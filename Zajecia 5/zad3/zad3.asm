;;;;
BITS 32

section .data
Zero		dw	0

section .text
global iloczyn_skalarny       
iloczyn_skalarny:
   enter 0, 0     ;  tworzymy ramkę stosu na początku funkcji
      ; ENTER 0,0 = PUSH EBP / MOV EPB, ESP
      ; po wykonaniu enter 0,0
      ; w [ebp]    znajduje się stary EBP
      ; w [ebp+4]  znajduje się adres powrotny z procedury
      ; w [ebp+8]  znajduje się pierwszy parametr,
      ; w [ebp+12] znajduje się drugi parametr
      ; itd.
      
; prototyp C:
; long double iloczyn_skalarny(int n, long double * x, long double * y);
      
; pomocnicze makrodefinicje
   %idefine    n	[ebp+8]
   %idefine    x	dword [ebp+12]
   %idefine	   y	dword [ebp+16]		
   
; tu zaczyna się właściwy kod funkcji
	mov		eax, x		;eax = &x
	mov		edx, y		;edx = &y
	
	fild		word [Zero]		;stack: 0 <--- current sum
	xor		ecx, ecx		;zerowanie licznika
	poczatek_while:
	cmp		ecx, n
	jge		koniec_while
	while:			;while(ecx < n)
		;fld		tword [eax + 12*ecx]		;stack: x[i], {current sum}    ;NIE DZIALA, DLACZEGO?
		fld		tword [eax]		;stack: x[i], {current sum}
		fld		tword [edx]		;stack: y[i], x[i], {current sum}
		
		fmulp	st1					;stack: x[i]*y[i], {current sum}
		faddp	st1					;stack: {current sum} + x[i]*y[i]
		
		add		eax, 12			;eax = x[i+1]
		add		edx, 12			;edx = y[i+1]
		
		
		inc		ecx
		jmp		poczatek_while
	koniec_while:
; tu kończy się właściwy kod funkcji
   leave     ; usuwamy ramkę stosu LEAVE = MOV ESP, EBP / POP EBP
ret    ; wynik zwracany jest w rejestrze eax
