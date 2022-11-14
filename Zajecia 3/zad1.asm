%include "/home/bartek/Pulpit/pn/asm64_io/asm64_io.inc"

segment .data
;
; dane zainicjalizowane
;

segment .bss
;
; dane niezainicjalizowane
;

segment .text
global MAIN
MAIN:
enter 0,0 

; ----
; Właściwy kod wstawiamy tu. 
; Nie należy modyfikować kodu przed i po tym komentarzu
	
	;[COMMAND] Wczytaj liczby aż do napotkania 0 i wstaw je na stos --START
	mov		rcx, 0			;zerowanie licznika pętli
	do_while_poczatek:				;do {
		call	read_int			;pobierz liczbe z klawiatury (do eax)
		push 	rax					;wstaw ją na stos
		inc		rcx					;liczba elementów na stosie ++
		cmp		rax, 0		
		jne		do_while_poczatek	;}while(eax != 0)
	;[COMMAND] Wczytaj liczby aż do napotkania 0 i wstaw je na stos --END
	
	;[INFO (App status)] --START
	;Na stosie jest również 0, dlatego je usuwamy
	;i robimy liczba elementów na stosie--
	;[INFO (App status)] --END
	pop		rax;					;pobierz 0 ze stosu i wrzuc do eax
	dec		rcx;					;liczba elementów na stosie--
	
	;[COMMAND] Wczytaj dodatkową liczbę całkowitą (dzielnik)
	mov		rax, 0;					;wyzerowanie rax aby nic tam nie było gdy skopiujemy eax
	call	read_int;
	mov		rsi, rax;				;rsi = dzielnik
	
	;[COMMAND] Pobieraj elementy ze stosu i zapamiętaj ile z nich jest podzielnych przez r8 --START
	mov		rbx, 0					;ile podzielnych
	podzielnosc: 					;for(rcx;rcx != 0; rcx--)
		pop		rax;
		
		;[DEBUG] Print number from stack--START
		;call	println_int
		;[DEBUG] --END
		
		xor		rdx, rdx			;ZEROWANIE DLA POPRAWNEGO DZIELENIA
		cdq
		idiv		esi;					;RAX = RAX / R8 |  RDX = RAX % RSI  DLACZEGO RSI TUTAJ NIE DZIALA???
		
		;[DEBUG] Print the remainder--START
		;mov		rax, rdx
		;call	println_int
		;[DEBUG] --END
		
		cmp		rdx, 0;				;making if stmnt
		jne		if_koniec;
		if: ;if(rax % r8 == 0)
			inc		rbx
			jmp		if_koniec
		if_koniec:
		loop 	podzielnosc
	;[COMMAND] Pobieraj elementy ze stosu i zapamiętaj ile z nich jest podzielnych przez r8 --END
	
	mov		eax, ebx;
	call	println_int;
	

; ---

mov rax, 0 ; kod zwracany z funkcji
leave
ret

 
