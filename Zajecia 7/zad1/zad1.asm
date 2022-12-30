; prototyp C:
; int suma(int n, int* tab)

section .text
global suma      
suma:
	;n   = RDI
	;tab = RSI
	
	xor		rax, rax			;suma = rax
	dec		rdi					;bo będziemy przechodzić od konca tablicy (tab[rdi])
	for:
		cmp		rdi, 0
		jl		for_end
		
		add		rax, [rsi + rdi*4 ]
		
		dec		rdi
		jmp		for
	for_end:
   
ret    ; wynik zwracany w RAX
