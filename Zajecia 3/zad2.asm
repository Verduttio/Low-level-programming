%include "/home/bartek/Pulpit/pn/asm64_io/asm64_io.inc"

segment .data
;
; dane zainicjalizowane
;
  tab1 dd 4, -5, 91, 44, 104, 4
  tab2 dd -1, -2, -3, -5

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
	push 	tab1
	push 	6
	call 	find_max    ; wynik = 104
	call 	println_int
	
	
	push 	tab2
	push 	4
	call 	find_max    ; wynik = -1
	call 	println_int 
; ---

mov rax, 0 ; kod zwracany z funkcji
leave
ret

;----FUNKCJE
find_max:
	pop		r8;			;adres powrotu
	pop		rcx;		;liczba elementów w tablicy
	pop		rbx;		;adres tab1
	;[rbx + 4*rcx - 4]  ;odwolanie do elementu w tablicy
	
	mov		esi, [rbx + 4*rcx - 4]	;max = tab1[last]
	dec		rcx
	petla:
		mov		eax, [rbx + 4*rcx - 4]
		
		;[COMMAND] if(r9 < eax) esi = eax
		cmp		esi, eax
		jge		if_koniec
		if:
			mov		esi, eax
		if_koniec:
		loop petla
	;esi = max(table)
	mov		eax, esi
	push	r8;
	ret

 
