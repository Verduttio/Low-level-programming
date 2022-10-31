section .text		;początek sekcji kodu

global _start		;potrzebne do linkera ld

_start:				;punkt startu programu

	;pobranie czasu systemowego
	mov	rax, 201 				;(sys_time)
	syscall
	
	;wczytujemy "XX:XX:X_"
	mov rdx, 0					;zerowanie dla bezpieczeństwa (przy dzieleniu)
	mov rcx, 10					;bedziemy dzielic rax/rcx wiec ładujemy do rcx 10 bo chcemy dzielic przez 10
	div rcx						;rax/rcx   iloraz(wynik)=rax reszta=rdx
	add rdx, '0'				;mamy liczbę a chcemy wartość ASCII tej liczby, bo będziemy wyświetlać
	mov [time + 7], dl			;zapisujemy cyfre sekund do time, bierzemy z dl bo to 8-bitów a z pełnych 64 (rdx) cos nie dziala
	
	;wczytujemy "XX:XX:_s"
	mov rdx, 0					;zerowanie dla bezpieczeństwa (przy dzieleniu)
	mov rcx, 6					;bedziemy dzielic rax/rcx wiec ładujemy do rcx 6 bo chcemy dzielic przez 6
	div rcx						;rax/rcx   iloraz(wynik)=rax reszta=rdx
	add rdx, '0'				;mamy liczbę a chcemy wartość ASCII tej liczby, bo będziemy wyświetlać
	mov [time + 6], dl			;zapisujemy cyfre do time w odpowiednie miejsce
	
	;wczytujemy "XX:X_:ss"
	mov rdx, 0					;zerowanie dla bezpieczeństwa (przy dzieleniu)
	mov rcx, 10					;bedziemy dzielic rax/rcx wiec ładujemy do rcx 10 bo chcemy dzielic przez 10
	div rcx						;rax/rcx   iloraz(wynik)=rax reszta=rdx
	add rdx, '0'				;mamy liczbę a chcemy wartość ASCII tej liczby, bo będziemy wyświetlać
	mov [time + 4], dl			;zapisujemy cyfre do time w odpowiednie miejsce
	
	;wczytujemy "XX:_m:ss"
	mov rdx, 0					;zerowanie dla bezpieczeństwa (przy dzieleniu)
	mov rcx, 6					;bedziemy dzielic rax/rcx wiec ładujemy do rcx 6 bo chcemy dzielic przez 6
	div rcx						;rax/rcx   iloraz(wynik)=rax reszta=rdx
	add rdx, '0'				;mamy liczbę a chcemy wartość ASCII tej liczby, bo będziemy wyświetlać
	mov [time + 3], dl			;zapisujemy cyfre do time w odpowiednie miejsce
	
	;musimy teraz podzielic przez 24 i reszta da nam aktualną godzinę a iloraz liczbę dni od 1970...
	mov rdx, 0					;zerowanie dla bezpieczeństwa (przy dzieleniu)
	mov rcx, 24					;bedziemy dzielic rax/rcx wiec ładujemy do rcx 24 bo chcemy dzielic przez 24
	div rcx						;rax/rcx   iloraz(wynik)=rax reszta=rdx
	
	;liczba godzin jest w rdx. Musimy wyciągnąć cyfrę jedności i dziesiątek
	mov rax, rdx 				;kopiujemy liczbe godzin do rax (aby wykonac dzielenie)
	mov rdx, 0					;zerowanie dla bezpieczeństwa (przy dzieleniu)
	mov rcx, 10					;bedziemy dzielic rax/rcx wiec ładujemy do rcx 10 bo chcemy dzielic przez 10
	div rcx						;rax/rcx   iloraz(wynik)=rax reszta=rdx
	;"X_:mm:ss"
	add rdx, '0'				;reszta to cyfra jednosci, wiec bierzemy wartosc rdx
	mov [time + 1], dl			;zapisujemy cyfre do time w odpowiednie miejsce
	
	;"_h:mm:ss"
	add rax, '0'				;cyfra dziesiątek godzin to iloraz więc rax
	mov [time], al				;zapisujemy cyfre do time w odpowiednie miejsce
	
	
	;wyswietlenie czasu
	mov rax, 1
	mov rdi, 1
	mov rsi, time
	mov rdx, time_len
	syscall
	
	mov	rax, 60         		;sys_exit
	mov	rdi, 0          		;kod wyjścia
	syscall
	
		
section .data
	time db "XX:XX:XX UTC", 0ah
    time_len equ $ - time
