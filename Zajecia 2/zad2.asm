%include "/home/bartek/Pulpit/pn/asm64_io/asm64_io.inc"

segment .data
;
; dane zainicjalizowane
;
	liczba_string db	"XXXXXXXXXXXXXXXXXXXXXXXXX"
	liczba_string_len equ $-liczba_string

segment .bss
;
; dane niezainicjalizowane
;
	;liczba_string	resb 20

segment .text
global MAIN
MAIN:
enter 0,0 

; ----
; Właściwy kod wstawiamy tu. 
; Nie należy modyfikować kodu przed i po tym komentarzu
default rel

	mov		rax, -123456789			;zapisz liczbę do rejestru
	
	;[INFO] zapisz znak liczby --START
	cmp 	rax, 0
	jnl		else_
	if: ;(rax < 0)
		mov		r8, 1
		;[INFO] zmien liczbe na dodatnia --START
		mov 	rbx, 0
		sub 	rbx, rax
		mov		rax, rbx
		;[INFO] zmien liczbe na dodatnia --END
		jmp 	if_end
	else_:
		mov		r8, 0
	if_end:
	;[INFO] zapisz znak liczby --END
	
	
	mov		rcx, 0			;counter
	;[COMMAND] while(liczba div 10 != 0)
poczatek_while:
	cmp		rax, 0
	je		koniec_while
	inc		rcx
	mov		rsi, 10
	mov 	rdx, 0		;czyszczenie edx by nie bylo bledow przy dzieleniu
	div		rsi			;eax = iloraz	edx	= reszta
	
	;[DEBUG] wypisz cyfre liczby --START
	;mov		rbx, rax	;skopiuj do temp aktualna liczbe
	;mov		rax, rdx	
	;call	println_int	;wyswietl reszte (czyli cyfre)
	;mov		rax, rbx	;przywroc aktualna liczbe do eax
	;[DEBUG] wypisz cyfre liczby --END
	
	add		rdx, '0' 	;konwersja liczby na kod ascii (tak abysmy widzieli jej wartosc w konsoli)
	mov		rsi, liczba_string_len
	sub 	rsi, rcx
	mov		[liczba_string + rsi], dl	;zapisz cyfre na koniec stringa liczby
	
	
	
	jmp		poczatek_while
koniec_while:
	;[INFO] Dopisujemy znak do liczby jeśli jest ujemna --START
	cmp		r8, 1
	jne		else_2
	if_2: ;(rdi == 1)		;liczba jest ujemna
		inc		rcx			;liczba_len++
		mov		rsi, liczba_string_len
		sub 	rsi, rcx
		mov		rbx, '-'
		mov		[liczba_string + rsi], 	bl
	else_2:
	;[INFO] Dopisujemy znak do liczby jeśli jest ujemna --END

	
	;[INFO] Wypisujemy liczbe --START
	mov		rax, 1
	mov		rdi, 1
	
	;zapisz w rbx poczatek adresu startu liczby
	mov		rbx, liczba_string
	add		rbx, liczba_string_len
	sub		rbx, rcx
	
	mov		rsi, rbx		;adres startu czytania
	mov		rdx, rcx		;ile bajtow przeczytac
	syscall
	;[INFO] Wypisujemy liczbe --END	
	
; ---

mov rax, 0 ; kod zwracany z funkcji
leave
ret

 
