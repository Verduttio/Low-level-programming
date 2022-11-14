%include "/home/bartek/Pulpit/pn/asm64_io/asm64_io.inc"

segment .data
;
; dane zainicjalizowane
;
	liczba_string db "63421",0
	liczba_int	dq	-123456789
	
	bufor_liczba_string db	"XXXXXXXXXXXXXXXXXXXXXXXXX"
	bufor_liczba_string_len equ $-bufor_liczba_string
	

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
	push 	liczba_string		;wrzuć adres liczby (argumentu) na stos
	call 	string_to_int
	call 	println_int
	
	
	push 	liczba_int			;wrzuć adres liczby (argumentu) na stos
	call 	int_to_string
	call 	println_string
; ---

mov rax, 0 ; kod zwracany z funkcji
leave
ret


;---FUNKCJE
int_to_string:
	pop 	r9					;adres powrotu
	
	pop		rax					;zapisz adres liczby do rejestru rax RAX=&liczba
					
	mov		rax, [rax]			;RAX = *liczba
	
	;[INFO] zapisz znak liczby --START
	cmp 	rax, 0
	jnl		else_1
	if_1: ;(rax < 0)
		mov		r8, 1
		;[INFO] zmien liczbe na dodatnia --START
		mov 	rbx, 0
		sub 	rbx, rax
		mov		rax, rbx
		;[INFO] zmien liczbe na dodatnia --END
		jmp 	if_end
	else_1:
		mov		r8, 0
	if_end:
	;[INFO] zapisz znak liczby --END
	
	
	mov		rcx, 1			;counter
	
	;zapisz 0 na koniec by oznaczalo, że to string
	mov 	dl, 0
	mov		rsi, bufor_liczba_string_len
	sub 	rsi, rcx
	mov		[bufor_liczba_string + rsi], dl	;zapisz cyfre na koniec stringa liczby
	;inc		rcx
	
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
		mov		rsi, bufor_liczba_string_len
		sub 	rsi, rcx
		mov		[bufor_liczba_string + rsi], dl	;zapisz cyfre na koniec stringa liczby
		
		
		
		jmp		poczatek_while
	koniec_while:
	;[INFO] Dopisujemy znak do liczby jeśli jest ujemna --START
	cmp		r8, 1
	jne		else_
	if_: ;(rdi == 1)		;liczba jest ujemna
		inc		rcx			;liczba_len++
		mov		rsi, bufor_liczba_string_len
		sub 	rsi, rcx
		mov		rbx, '-'
		mov		[bufor_liczba_string + rsi], 	bl
	else_:
	;[INFO] Dopisujemy znak do liczby jeśli jest ujemna --END

	
	;zapisz w rbx poczatek adresu startu liczby
	mov		rbx, bufor_liczba_string
	add		rbx, bufor_liczba_string_len
	sub		rbx, rcx
	
	mov		rsi, rbx		;adres startu czytania
	mov		rax, rsi
	;mov		rdx, rcx		;ile bajtow przeczytac
	;[INFO] Wypisujemy liczbe --END	
	
	push	r9					;przywroc adres powrotu
	ret





string_to_int:
	;[INFO]
	;Na początku sprawdzamy pierwszy znak
	;jeśli jest to '-' to musimy to zapamiętać 
	;w przeciwnym wypadku do rbx wrzucamy rbx * 10 + cyfra
	pop 	r8					;adres powrotu
	
	pop 	r9					;rdx = &liczba_string
	
	;[COMMAND] Iteruj po znakach stringa --START
	mov		rcx, 0				;licznik w iteracji
	mov 	rbx, 0				;wynik (liczba int przekonwertowana ze stringa)
	
	;Przed pętlą pobierz jeden znak aby stwierdzić i zapamiętać czy liczba jest ujemna czy dodatnia
	mov		rax, 0 				;pierwszy znak (zerujemy wszystkie 64 bity bo wartosc znaku wejdzie tylko do pierwszych 8 (bo znak to 1 bajt))
	mov		al, [r9 + rcx*1]
	inc 	rcx
	
	;Już teraz musimy stwierdzić czy to znak czy to liczba by do rbx'a wrzucić ewentualną wartość 
	cmp		al, '-'
	je		koniec_if
	if: ;if(al != '-')
		mov		rbx, rax
		sub		rbx, '0'
	koniec_if:
	
	;Iterujemy po znakach od 1 do string.length
	while_poczatek:
		mov 	rax, 0				;wyzeruj starsze bity rax'a żeby nie zaciemniły wyniku
		mov		al, [r9 + rcx*1]	;do al bo chcemy tylko jeden bajt
		cmp		al, 0
		je		while_koniec
		body: ;while(string[rcx] != 0)
			sub 	al, '0'			;konwersja z ascii na wartosc liczbową
			;call	println_int
			
			;[COMMAND] rbx*10 + aktualna cyfra --START
			push 	rax				;wrzuc aktualnie odczytana cyfre na stos bo bedzie nam potrzebny rax do mnozenia
			
			mov		rax, 10			;bedziemy wykonywac mnożenie razy 10
			mul		rbx				;RAX = RAX * RBX
			mov		rbx, rax		;RBX = RAX 
			
			pop		rax				;RAX = aktualna cyfra
			
			add		rbx, rax
			;[COMMAND] rbx*10 + aktualna cyfra --END
			
			;[DEBUG] Wypisz utworzoną liczbę do tej pory --START
			;mov		rax, rbx
			;call	println_int
			;[DEBUG] Wypisz utworzoną liczbę do tej pory --END
			
			inc		rcx
			jmp		while_poczatek
		while_koniec:
	;[COMMAND] Iteruj po znakach stringa --END
	
	;[INFO] Jeśli liczba była ujemna to teraz musimy ją zamienić na ujemną
	;weryfikujemy to poprzez pierwszy znak jeszcze raz
	mov		al, [r9 + 0]
	cmp		al, '-'
	jne		else_2
	if_2: ;if(al == '-')
		mov		rax, 0
		sub		rax, rbx
		jmp		koniec_if_2
	else_2:
		mov		rax, rbx				;zapisz wynik do rax'a
	koniec_if_2:
	
			
	push 	r8					;przywroc adres powrotu
	ret
	


 
