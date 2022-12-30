; prototyp C:
; double wartosc (double a, double b, double x, int n);
; wartosc = (a*x + b)^n
section .data
one_number: dq 1.0

section .text
global wartosc      
wartosc:
	;XMM0 = a
	;XMM1 = b
	;XMM2 = x
	;RDI  = n
	
	mulsd		XMM0, XMM2			;XMM0 = a*x
	addsd		XMM0, XMM1			;XMM0 = a*x + b
	
	movsd		XMM1, XMM0			;XMM1 = a*x + b
	movsd		XMM0, [one_number]	;XMM0 = 1
	;(a*x + b)^n
	for:
		cmp		RDI, 1
		jl		for_end
		
		mulsd	XMM0, XMM1			;XMM0 = XMM0 * (a*x + b)
		
		dec		RDI
		jmp		for
	for_end:
	
   
ret    ; wynik zwracany w XMM0
