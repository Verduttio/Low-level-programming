; prototyp C:
; int iloczyn (int n, ...);

section .text
global iloczyn      
iloczyn:
	pop		R10			;R10 = RET adres powrotu 
						;(R10 jest jednym z wolnych rejestrów, które można zmieniać
						;podczas wywołania funkcji)
						
	mov		R11, RSP	;R11 = RSP
						;Stos musi mieć taki sam rozmiar po zakończeniu funkcji
						;ponieważ potem wywoływacz funkcji musi ten stos zwolnić
						;więc nie chcemy by skasował coś czego nie miał skasować.
						;Ponieważ my zdejmiemy ze stosu te argumenty, które miał ktoś potem posprzątać
						;dlatego ustawimy na koniec szczyt stosu tam gdzie on był wcześniej.
	
	;Wrzucamy rejestry, przechowujące argumenty całkowitoliczbowe, na stos
	;robimy to od końca, by na szczycie był RDI czyli pierwszy argument
	push	R9
	push	R8
	push	RCX
	push	RDX
	push	RSI
	push 	RDI				
	
	
	;pobieramy pierwszy argument ze stosu
	pop		RDI				;RDI = n
	mov 	RAX, 1			;RAX = wynik
	;iterujemy po pozostałych argumentach
	for:
		cmp		RDI, 1
		jl		for_end
		
		pop		RSI			;RSI = kolejny argument funkcji
		mul		RSI			;RAX *= RSI
		
		dec		RDI
		jmp		for
	for_end:
	
	;na stosie nie ma już argumentów
	;musimy przywrócić jego oryginalny rozmiar i wrzucić adres powrotu na szczyt
	
	mov		RSP, R11			;RSP = szczyt stosu po zdjęciu adresu powrotu
	push	R10					;Na szczycie jest adres powrotu i stos ma taki sam rozmiar jak przed wywołaniem funkcji
   
ret    ; wynik zwracany w RAX
