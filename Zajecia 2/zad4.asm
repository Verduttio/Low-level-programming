%include "/home/bartek/Pulpit/pn/asm64_io/asm64_io.inc"

segment .data
;
; dane zainicjalizowane
;
	n dq 12
	a dq 20
	b dq 93
	rownasie	db " = ",0
	przecinek 	db ", ",0
	program_info_string		db "Liczby względnie pierwsze z ",0
	slowo_rightBracket_to	db "] to:", 0
	slowo_w_przedziale_leftBracket	db	" w przedziale [", 0

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


	;[INFO] Display program functionality --START
	mov		rax, program_info_string
	call	print_string
	
	mov		rax, [n]
	call	print_int
	
	mov		rax, slowo_w_przedziale_leftBracket
	call	print_string
	
	mov		rax, [a]
	call	print_int
	
	mov		rax, przecinek
	call	print_string
	
	mov		rax, [b]
	call	print_int
	
	mov		rax, slowo_rightBracket_to
	call	println_string
	;[INFO] Display program functionality --END


	mov		rcx, [a] 		;zmienna iteracyjna
poczatek_while:
	cmp		rcx, [b]		;warunek while (rcx <= b) ?
	jg		koniec_while ;if (rcx > b) then jump to koniec_while
	;while body rcx != b
	mov		rbx, [n]
	mov		rax, rcx
	poczatek_while_zagniezdzony:   ;obliczanie nwd([n], rcx)
		cmp		rbx, 0
		je		koniec_while_zagniezdzony
		;while body (b != 0)
		mov		rdx, 0    	;zerowanie dla poprawnego dzielenia
		div		rbx			;rax/rbx	ILORAZ = RAX | Reszta = RDX
		mov		rax, rbx	;a = b
		mov		rbx, rdx	;b = a%b
		jmp poczatek_while_zagniezdzony
	koniec_while_zagniezdzony:
	;[INFO] nwd ([n], rcx) = rax
	
	;[COMMAND] if (nwd(n, rcx) == 1) print(rcx)
	cmp		rax, 1
	jne 	else_
	if: ;(rax == 1)
		mov		rax, rcx
		call	println_int
	else_:
	else_koniec:
	
	
	; [DEBUG] wypisz nwd n oraz rcx podczas kazdej iteracji --START
	;call	print_int		;wypisz nwd ([n], rcx)
	
	;mov		rax, rownasie	;wypiz ' = '
	;call	print_string
	
	;mov		rax, [n]		;wypisz n
	;call	print_int
	
	;mov		rax, przecinek
	;call	print_string	;wypisz ','
	
	;mov		rax, rcx		;wypisz rcx
	;call	println_int
	; [DEBUG] --END
	
	
	
	
	;--[DEBUG] wyswietl licznik --start
	;mov		rax, rcx
	;call 	println_int
	;--[DEBUG] wyswietl licznik --end
	inc 	rcx
	jmp		poczatek_while
koniec_while:




; ---

mov rax, 0 ; kod zwracany z funkcji
leave
ret

 
