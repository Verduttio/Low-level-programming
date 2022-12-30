;;void kopiuj(unsigned int * cel, unsigned int * zrodlo, unsigned int n);
;;void zeruj(unsigned int * tablica, unsigned int n);


segment .text
global _Z6kopiujPjS_j, _Z5zerujPjj

_Z6kopiujPjS_j:
	; rdi = &cel
	; rsi = &zrodlo
	; rdx = n
	
	cld					; zerujemy flagę DF (czyli rejestry beda zwiekszane tzn. add ESI/EDI)
	mov		rcx, rdx	; rcx = rdx = licznik petli
	rep		movsd		; rep powtowarza instrukcję rcx razy
ret

_Z5zerujPjj:
	; rdi = &cel
	; rsi = n
	
	mov		eax, 0		; eax = 0
	mov		rcx, rsi	
	rep 	stosd		; mov [ES:EDI], eax
ret


global _ZN6BigInt5dodajEj, _ZN6BigInt6pomnozEj, _ZN6BigInt14podzielZResztaEj

_ZN6BigInt5dodajEj:   	; int dodaj({&obiekt_klasy}, unsigned int n); 
	; rdi = &obiekt_klasy
	; rsi = n
	
	; BigInt
	;  	unsigned int rozmiar;   	; [rdi]     = rozmiar
	; 	unsigned int * dane;  		; [rdi + 8] = &dane   ale dlaczego +8 skoro rozmiar ma 4 bajty? Czy wskaznik musi miec wyrownanie do 8?
	
	mov		ecx, [rdi]				; ecx = rozmiar
	mov		rdx, [rdi + 8] 			; rdx = &dane


	;mov		rax, rsi				; rax = n
	add		[rdx], esi				; tab[0] += n
	
	.iterate:
		jnc		.not_overflow		; jump to not_overflow if carry flag is not set
		.overflow:
			dec		ecx				; ecx = rozmiar--   (licznik petli)
			cmp		ecx, 0
			je		.BigInt_overflow	;przeszlismy po całym BigIncie i nadal należy przenieść 1, czyli mamy przepełnienie BigInta
			
			add		rdx, 4			; tab[i] = tab[i+1]	
			add		dword[rdx], 1	; tab[i] += 1 (przenieś 1 bo było przepełnienie)
			
		
			jmp		.iterate
			
	.not_overflow:
		xor 	rax, rax
		ret
		
	.BigInt_overflow:
		mov		rax, 1
		ret
	
_ZN6BigInt6pomnozEj:		; int pomnoz(unsigned int n); 
	; rdi = &obiekt_klasy
	; rsi = n
	
	; BigInt
	;  	unsigned int rozmiar;   
	; 	unsigned int * dane; 
	
	mov		r10, [rdi]			; r10 = rozmiar
	mov		rdi, [rdi + 8]		; rdi = &dane
	mov		rcx, rsi			; rcx = n
	
	
	; eax * ecx					; edx:eax = eax * ecx
	xor		esi, esi			; poprzednie "przeniesienie"
	.multiply:
		cmp		r10, 0
		je		.BigInt_possible_overflow
		
		mov		eax, [rdi]		; eax = dane[i]
		
		mul		ecx				; edx:eax = eax * ecx
		add		eax, esi		; dodajemy przeniesienie z poprzedniego mnożenia
		
		mov		[rdi], eax
		
		mov		esi, edx		; skopiuj "nadmiar" po pomnożeniu
		
		dec		r10
		add		rdi, 4
		jmp		.multiply
		
	.multiply_end:
		xor		rax, rax
		ret
		
	.BigInt_possible_overflow:
		cmp		edx, 0
		jne		.overflow
		.not_overflow:
			xor		rax, rax
			ret
		.overflow:
			mov		rax, 1
			ret
	
	
	
_ZN6BigInt14podzielZResztaEj:		; int podzielZReszta(unsigned int n); 	
	; rdi = &obiekt_klasy
	; rsi = n
	
	; BigInt
	;  	unsigned int rozmiar;   
	; 	unsigned int * dane; 
	
	mov		ecx, [rdi] 			; ecx = rozmiar
	mov		rdi, [rdi + 8] 		; rdi = &dane
								; rsi = n
	xor 	edx, edx			; to musi być tutaj raz bo potem dzielna bedzie edx:eax czyli reszta poprzednia bedzie wykozrystana
	
	.for:
		cmp		ecx, 0
		je		.for_end
		
		mov		eax, [rdi + rcx*4 - 4] 		;eax = dane[ecx]
			
		div		esi				; eax = iloraz	| edx = reszta
		mov		[rdi + rcx*4 - 4], eax		; dane[ecx] = iloraz
		
		dec		ecx
		jmp		.for
	
	.for_end:
		mov		eax, edx		; ostatnia reszta
		ret
		
	
global _ZplRK6BigIntS1_, _ZmiRK6BigIntS1_

extern _ZN6BigIntC1Ej 			; konstruktor BigInt
								; BigInt(unsigned int rozmiar) 

_ZplRK6BigIntS1_:				; operator dodawania
								; BigInt operator+ (const BigInt & a, const BigInt & b);  
	; rdi = obiekt_wynikowy (czyli rezultat dodawania) ??
	; rsi = a
	; rdx = b

	; wrzucamy rejestry na stos bo one mogą się zmienić podczas wywołania konstruktora, a nie chcemy ich stracić
	push 	rdi
	push	rsi
	push	rdx
	
	
	; Przygotowanie argumentów dla konstruktora BigInt
	; rdi = adres pod którym będzie obiekt?
	; czyli rdi pozostaje bez zmian bo mamy tę wartość z wywowałania operator +
	; rsi = rozmiar (zakładamy prostszą wersję, czyli obiekty są tego samego rozmiaru)
	
	mov		rsi, [rsi]			; rsi = a.rozmiar
	call	_ZN6BigIntC1Ej		; konstruktor
	
	pop		r9					; r9 = b
	pop		r8 					; r8 = a
	pop		rdi					; rdi = output
	
	
	clc							; Clear Carry  
	pushf
		
								; ADC *Add with Carry*  SYNTAX: ADC 	Dest, Source
								
    mov		r8, [r8 + 8]		; r8 = a.dane								
    mov		r9, [r9 + 8]		; r9 = b.dane								
    mov		r10, [rdi + 8] 		; r10 = output.dane
					
	mov		rcx, 0								
	.for:
		cmp		rcx, rsi
		je		.for_end
		
		popf					; zdejmij flagi ze stosu
		mov		eax, [r8]		; eax = a.dane[rcx]
								; bo nie da się potem bezpośrednio adc [..] [..]
        adc		eax, [r9]									
		mov		[r10], eax		
		pushf					; wrzuć flagi na stos (ponieważ cmp ustawia flagę przeniesienia...)
		
		add		r8, 4
		add 	r9, 4
		add		r10, 4
		
		
		inc		rcx
		jmp		.for
	.for_end:
	
	popf						; zdejmij flagi, żeby opróżnić stos
	mov		rax, rdi			; adres obiektu wynikowego
	ret
	
	


_ZmiRK6BigIntS1_:    			; operator odejmowania
								; BigInt operator- (const BigInt & a, const BigInt & b);  
									; BigInt operator+ (const BigInt & a, const BigInt & b);  

	
	;TO SAMO CO DLA OPERATORA DODAWANIA 
	;TYLKO ADC ZMIENIONE NA SBB
	
	push 	rdi
	push	rsi
	push	rdx
	
	
	mov		rsi, [rsi]			; rsi = a.rozmiar
	call	_ZN6BigIntC1Ej		; konstruktor
	
	pop		r9					; r9 = b
	pop		r8 					; r8 = a
	pop		rdi					; rdi = output
	
	
	clc							; Clear Carry  
	pushf
		
								; ADC *Add with Carry*  SYNTAX: ADC 	Dest, Source
								
    mov		r8, [r8 + 8]		; r8 = a.dane								
    mov		r9, [r9 + 8]		; r9 = b.dane								
    mov		r10, [rdi + 8] 		; r10 = output.dane
					
	mov		rcx, 0								
	.for:
		cmp		rcx, rsi
		je		.for_end
		
		popf					; zdejmij flagi ze stosu
		mov		eax, [r8]		; eax = a.dane[rcx]
								; bo nie da się potem bezpośrednio adc [..] [..]
        sbb		eax, [r9]									
		mov		[r10], eax		
		pushf					; wrzuć flagi na stos (ponieważ cmp ustawia flagę przeniesienia...)
		
		add		r8, 4
		add 	r9, 4
		add		r10, 4
		
		
		inc		rcx
		jmp		.for
	.for_end:
	
	popf						; zdejmij flagi, żeby opróżnić stos
	mov		rax, rdi			; adres obiektu wynikowego
	ret

