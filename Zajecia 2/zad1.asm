%include "/home/bartek/Pulpit/pn/asm64_io/asm64_io.inc"

segment .data
;
; dane zainicjalizowane
;
	liczba dq 77
	pierwsza_info db "Liczba jest pierwsza", 0
	notpierwsza_info db "Liczba nie jest pierwsza", 0

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


	mov 	rcx, 2			;zmienna iteracyjna
	;petla while(i < liczba)
while:
	cmp		rcx, [liczba] 		;compare i and liczba
	jnb		koniec				;if( i >= liczba) then end while
	;while body {
	;mov 	rax, rcx		;[DEBUG] print_int wyswietla rax wiec przesylamy do rax to co chcemy wyswietlic
	;call  	println_int		;[DEBUG]
	
	mov		rax, [liczba]
	mov		rdx, 0			;zerowanie dla czystego dzielenia
	div 	rcx				;Dzielimy rax / rcx   |  RAX = iloraz  | RDX = reszta z dzielenia
	cmp		rdx, 0			;compare rdx and 0
	jne		else_			
	mov		rcx, 999999			;zakoncz while warunkiem 24(rcx) < 23
	jmp		if_koniec
else_: ;{nothing}
if_koniec:
		
	;mov 	rax, rcx		;[DEBUG] print_int wyswietla rax wiec przesylamy do rax to co chcemy wyswietlic
	;call  	println_int		;[DEBUG]
	
	inc 	rcx				;i++ (inkrementujemy licznik pętli)
	jmp		while
	;}
koniec:						;wyjście z pętli while
	cmp		rcx, [liczba]			;compare rcx and 23
	jne		else_2			
	mov		rax, pierwsza_info ;if (rcx == 23) body
	jmp 	koniec_2
else_2:
	mov		rax, notpierwsza_info; if(rcx != 23) body
koniec_2:
	call println_string
	

mov rax, 0 ; kod zwracany z funkcji
leave
ret

 
