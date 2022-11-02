%include "/home/bartek/Pulpit/pn/asm64_io/asm64_io.inc"

segment .data
;
; dane zainicjalizowane
;
liczba dq	60

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
	mov 	rax, [liczba]
	mov		rcx, 2			;dzielnik
poczatek_while:
	cmp 	rax, 1
	je		koniec_while
	poczatek_while_zagniezdzony:
		mov		rbx, rax		;skopiuj rax'a po to, że jeśli dzielenie da reszte to aby przywrocic wartosc sprzed dzielenia i sprobowac podzielic przez wieksza liczbe
		mov		rdx, 0			;zerowanie aby poprawnie divowac
		div		rcx				;rax/rcx ILORAZ=RAX  RESZTA=RDX	
		cmp		rdx, 0
		jne		koniec_while_zagniezdzony ;jesli rax % rcx != 0
		
		;--- wypisywanie start
		mov		rbx, rax			;skopiuj na potrzeby wypisania liczby
		mov		rax, rcx
		call 	println_int
		mov		rax, rbx			;przywroc by dalej kontynuowac
		;--- wypisywanie end
		
		jmp		poczatek_while_zagniezdzony
	koniec_while_zagniezdzony:
	
	mov		rax, rbx		;przywróc poprzednią wartosc i sprobuj podzielic przez wieksza liczbe
	inc		rcx				;inkrementuj dzielnik
	jmp		poczatek_while
koniec_while:




; ---

mov rax, 0 ; kod zwracany z funkcji
leave
ret

 
