; prototyp C:
; float podatek(Faktura f);
; podatek = (obrót - podatekNaliczony) * stawkaPodatku

; void wypisz(const Faktura & f); 

extern printf

section .data
printf_format: db "Faktura %d : obrot %f podatek %f", 10, 0


section .text

global podatek 
global wypisz     

podatek:
	shr		rdi, 32 		;rdi = obrot
	movq    xmm2, rdi		;xmm2 = obrot
	;https://stackoverflow.com/questions/47946389/how-to-move-a-floating-point-constant-value-into-an-xmm-register
	;https://www.felixcloutier.com/x86/movd:movq
	
	movq	rax, xmm0
	movd	xmm0, eax		;xmm0 = podatekNaliczony
	shr		rax, 32
	movd	xmm1, eax		;xmm1 = stawkaPodatku
	
	subss	xmm2, xmm0		;xmm2 = (obrot - podatekNaliczony)
	mulss	xmm1, xmm2		;xmm1 = stawkaPodatku * (obrot - podatekNaliczony)
	
	movss	xmm0, xmm1		;xmm0 = stawkaPodatku * (obrot - podatekNaliczony)
   
ret    ; wynik zwracany w XMM0

wypisz:
	;rdi = &faktura
	
	;Musimy wywołać podatek(faktura)
	;Czyli należy w RDI wrzucić id, obrot
	;a w XMM0 podatekNaliczony oraz stawkaPodatku
	
	;Zatem musimy skopiować wartość rdi bo referencja do faktury bedzie nam potem potrzebna
	mov		r10, rdi		;r10 = &faktura
	
	movq	xmm0, [rdi + 8]	;xmm0 = dwa pozostałe pola z klasy, float oraz float to razem 8 bajtów, dlatego movq (move quadword)
	mov		rdi, [rdi]		;rdi = dwa pierwsze pola z klasy, int oraz float to razem 8 bajtów, czyli tyle co ma rejestr (64 bity)
	
	
	;Możemy teraz wywołać funkcję podatek ponieważ jej argumenty są już załadowane
	call	podatek
	;Wynik mamy w xmm0

	;Ale chcemy by był w xmm1, ponieważ w xmm0 będzie f.obrot
	movss	xmm1, xmm0
	cvtss2sd	xmm1, xmm1		;konwersja float na double
	
	movd	xmm0, dword[r10+4]	;xmm0 = obrot
	cvtss2sd	xmm0, xmm0		;konwersja float na double
	
	xor		rsi, rsi
	mov		esi, [r10] 			;esi = faktura.id
	
	;pozostal na string, to chyba będzie wskaźnik więc wyląduje w RDI
	mov		rdi, printf_format

	mov		eax, 2			;liczba argumentów znajdujących się w rejestrach XMM
	
	;z debuggera wynika, że rsp teraz nie jest podzielny przez 16 więc trzeba go powiększyć sztuzcnie o 8
	sub 	rsp, 8
	
	call	printf

	;i przywracamy rozmiar stosu
	add		rsp, 8
ret
