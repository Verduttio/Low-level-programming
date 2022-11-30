;;;;
BITS 32

section .data
Two		dd	2
;skok		dq	0
;x_val		dq 	0
;counter		dd 	0

section .text
global tablicuj       
tablicuj:
   enter 0, 0     ;  tworzymy ramkę stosu na początku funkcji
   sub	esp, 20		;alokacja pamieci na dane lokalne procedury
      ; ENTER 0,0 = PUSH EBP / MOV EPB, ESP
      ; po wykonaniu enter 0,0
      ; w [ebp]    znajduje się stary EBP
      ; w [ebp+4]  znajduje się adres powrotny z procedury
      ; dalej parametry
      
; prototyp C:
; void tablicuj(double a, double b, double P, double Q, double xmin, double xmax, int k,  double * wartosci);
; f(x) = a*(sin(P*2*pi*x))^2 + b*(sin(Q*2*pi*x))^2
      
; pomocnicze makrodefinicje
   %idefine    a		qword [ebp+8]
   %idefine    b		qword [ebp+16]
   %idefine    P		qword [ebp+24]
   %idefine    Q		qword [ebp+32]
   %idefine    xmin		qword [ebp+40]
   %idefine    xmax		qword [ebp+48]
   %idefine    k		dword [ebp+56]
   %idefine    wartosci	dword [ebp+60]
   
   ;local
   %idefine    skok		qword [ebp-8]
   %idefine    x_val	qword [ebp-16]
   %idefine    counter	dword [ebp-20]
   
; tu zaczyna się właściwy kod funkcji
	;[COMMAND] Oblicz wartość skoku (różnica między punktami) --START
	fld		xmax		;stack: xmax
	fld		xmin		;stack: xmin, xmax
	fsubp	st1			;stack: xmax - xmin
	fild	k			;stack: k, xmax - xmin
	fld1				;stack: 1.0, k, xmax - xmin
	fsubp	st1			;stack: k-1, xmax - xmin
	fdivp	st1			;stack: (xmax-xmin)/(k-1)
	
	fstp	skok		;stack: /*empty*/ && skok = st0
	;[COMMAND] Oblicz wartość skoku --END


	mov		edx, wartosci	;edx = wartosci[0]  <-- tu będą wartości funkcji
	
	xor		ecx, ecx		;to bedzie licznik petli | counter == ecx (to kopia aby móc ją wykorzystać w fpu)
	mov		counter, ecx
	
	poczatek_while:
	cmp		ecx, k
	jnl		koniec_while
	while: 		;while(ecx < k)
		;[COMMAND] Wyznacz argument (x) --START
		; x_val = xmin + counter*skok
		fild	counter				;stack: counter
		fld		skok				;stack: skok, counter
		fmulp	st1					;stack: counter*skok
		fild	xmin				;stack: xmin, counter*skok
		faddp	st1					;stack: counter*skok + xmin
		
		fstp	x_val				;stack: /*empty*/ && x_val = st0
		;[COMMAND] Wyznacz argument (x) --END
		
		
		;[COMMAND] Oblicz wartosc f(x) --START
		fld 	Q					;stack: Q
		fild	dword [Two]			;stack: 2, Q
		fldpi						;stack: pi, 2, Q
		fld		x_val				;stack: x, pi, 2, Q
		fmulp	st1					;stack: pi*x, 2, Q
		fmulp	st1					;stack: 2*pi*x, Q
		fmulp	st1					;stack: Q*2*pi*x
		fsin						;stack: sin(Q*2*pi*x)
		
		fld 	Q					;stack: Q, sin(Q*2*pi*x)
		fild	dword [Two]			;stack: 2, Q, sin(Q*2*pi*x)
		fldpi						;stack: pi, 2, Q, sin(Q*2*pi*x)
		fld		x_val				;stack: x, pi, 2, Q, sin(Q*2*pi*x)
		fmulp	st1					;stack: pi*x, 2, Q, sin(Q*2*pi*x)
		fmulp	st1					;stack: 2*pi*x, Q, sin(Q*2*pi*x)
		fmulp	st1					;stack: Q*2*pi*x, sin(Q*2*pi*x)
		fsin						;stack: sin(Q*2*pi*x), sin(Q*2*pi*x)
		
		fmulp	st1					;stack: (sin(Q*2*pi*x))^2
		fld		b					;stack: b, (sin(Q*2*pi*x))^2	
		fmulp	st1					;stack: (sin(Q*2*pi*x))^2 * b	
		;mamy juz drugi składnik sumy
		
		;teraz obliczamy pierwszy składnik sumy
		fld 	P					;stack: P, (sin(Q*2*pi*x))^2 * b	
		fild	dword [Two]			;stack: 2, P, (sin(Q*2*pi*x))^2 * b	
		fldpi						;stack: pi, 2, P, (sin(Q*2*pi*x))^2 * b	
		fld		x_val				;stack: x, pi, 2, P, (sin(Q*2*pi*x))^2 * b	
		fmulp	st1					;stack: pi*x, 2, P, (sin(Q*2*pi*x))^2 * b	
		fmulp	st1					;stack: 2*pi*x, P, (sin(Q*2*pi*x))^2 * b	
		fmulp	st1					;stack: P*2*pi*x, (sin(Q*2*pi*x))^2 * b	
		fsin						;stack: sin(P*2*pi*x), (sin(Q*2*pi*x))^2 * b	
		
		fld 	P					;stack: P, sin(P*2*pi*x), (sin(Q*2*pi*x))^2 * b	
		fild	dword [Two]			;stack: 2, P, sin(P*2*pi*x), (sin(Q*2*pi*x))^2 * b	
		fldpi						;stack: pi, 2, P, sin(P*2*pi*x), (sin(Q*2*pi*x))^2 * b	
		fld		x_val				;stack: x, pi, 2, P, sin(P*2*pi*x), (sin(Q*2*pi*x))^2 * b	
		fmulp	st1					;stack: pi*x, 2, P, sin(P*2*pi*x), (sin(Q*2*pi*x))^2 * b	
		fmulp	st1					;stack: 2*pi*x, P, sin(P*2*pi*x), (sin(Q*2*pi*x))^2 * b	
		fmulp	st1					;stack: P*2*pi*x, sin(P*2*pi*x), (sin(Q*2*pi*x))^2 * b	
		fsin						;stack: sin(P*2*pi*x), sin(P*2*pi*x), (sin(Q*2*pi*x))^2 * b	
		
		fmulp	st1					;stack: (sin(P*2*pi*x))^2, (sin(Q*2*pi*x))^2 * b	
		fld		a					;stack: a, (sin(P*2*pi*x))^2, (sin(Q*2*pi*x))^2 * b	
		fmulp	st1					;stack: (sin(P*2*pi*x))^2 * a, (sin(Q*2*pi*x))^2 * b	
		;mamy już oba składniki sumy
		
		;zatem wykonujemy dodawanie
		;[INFO] f(x) = st0 !!!!!
		faddp	st1					;stack: (sin(Q*2*pi*x))^2 * b + (sin(P*2*pi*x))^2 * a
		;[INFO] f(x) = st0 !!!!!
		;[COMMAND] Oblicz wartosc f(x) --END
		
		;[COMMAND] Zapisz f(x) do tablicy wartosci --START
		fstp	qword [edx + 8*ecx]
		;[COMMAND] Zapisz f(x) do tablicy wartosci --END
			
		inc		ecx
		mov		counter, ecx
		jmp		poczatek_while
	koniec_while:
	
	
; tu kończy się właściwy kod funkcji
   leave     ; usuwamy ramkę stosu LEAVE = MOV ESP, EBP / POP EBP
ret    ; wynik zwracany jest w rejestrze eax
