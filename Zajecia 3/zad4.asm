%include "/home/bartek/Pulpit/pn/asm64_io/asm64_io.inc"

segment .data
;
; dane zainicjalizowane
;
	szyfr db "ga","de","ry","po","lu","ki", " -", 0, 0
	input_string	db	"ala ma kota",0
;	input_string	db	"123 gug-mg-iptg.",0

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
	mov		rax, input_string
	call	println_string

	push	input_string
	push	szyfr
	call	gaderypoluki
	
	mov		rax, input_string
	call	println_string
; ---

mov rax, 0 ; kod zwracany z funkcji
leave
ret

;----FUNKCJE----
gaderypoluki:
	pop		r8			;adres powrotu
	pop		r9			;r9 = &szyfr
	pop		r10			;r10 = &input_string
	
	;[COMMAND] Iteruj po input_string --START
	mov		rcx, 0								;licznik petli
	petla_input_string:
		mov		rax, 0							;wyzeruj rax'a aby nie bylo tam śmieci gdy wrzucimy coś do al
		
		mov		al, [r10 + rcx]					;akutlana litera
		;[DEBUG]
		;call	println_char					
		
		;[COMMAND] Kodowanie litery --START
		mov		rbx, rax						;wrzuc aktualna litere w input do rbx
		call	encode_letter					;zakoduj literę, która jest w rbx
		;[COMMAND] Kodowanie litery --END
		
		
		;[INFO] litera do zamiany znajduje sie w rbx
		mov		[r10  + rcx], bl
		
	
		inc		rcx
		
		
		;[INFO] Sprawdz czy doszlismy do konca stringu --START
		mov		al, [r10 + rcx]
		cmp		al, 0
		jne		if_koniec_1
		if_1:
			jmp		petla_input_string_koniec
		if_koniec_1:
		;[INFO] Sprawdz czy doszlismy do konca stringu --END
		
		jmp		petla_input_string
	
	petla_input_string_koniec:
	;[COMMAND] Iteruj po input_string --END
	
	
	push	r8			;wstaw z powrotem adres powrotu na stos
	ret


encode_letter:
	push 	rcx								;wrzuc rcx na stos aby potem przywrocic jego wartosc
	;[COMMAND (encode char)] Iteruj po parach szyfru --START
	mov		rcx, 0							;licznik petli
	petla_pary_szyfr:
		mov		rax, 0						;wyzeruj rax'a aby nie bylo tam śmieci gdy wrzucimy coś do al
	
		;[COMMAND] Sprawdz pierwszy znak --START
		mov		al, [r9 + rcx]
		
		;[DEBUG]
		;call	println_char				
		
		;[INFO] if(al == aktualna litera w input) zamien litere na tą z szyfru
		cmp		al, bl
		jne		if_1l_koniec
		if_1l: ;if(al == aktual...)
			mov		al, [r9 + rcx+1]		;kodem bedzie nastepna litera z pary
			mov		rbx, rax				;wrzuc encodowaną do rbx
			jmp 	petla_pary_szyfr_koniec ;zakoncz iterowanie po parach bo już znalezlismy kod
		if_1l_koniec:
		;[COMMAND] Sprawdz pierwszy znak --END
		
		
		
		;[COMMAND] Sprawdz drugi znak --START
		mov		al, [r9 + rcx+1]
		
		;[DEBUG]
		;call	println_char				
		
		;[INFO] if(al == aktualna litera w input) zamien litere na tą z szyfru
		cmp		al, bl
		jne		if_2l_koniec
		if_2l: ;if(al == aktual...)
			mov		al, [r9 + rcx]			;kodem bedzie poprzednia litera z pary
			mov		rbx, rax				;wrzuc encodowaną do rbx
			jmp		petla_pary_szyfr_koniec	;zakoczn iterowanie po parach bo juz znalezlismy kod
		if_2l_koniec:
		;[COMMAND] Sprawdz drugi znak --END
		
		
		
		
		;[INFO] Inc dwa razy bo przeszlismy po jednej parze
		inc		rcx
		inc		rcx
		
		;[INFO] Sprawdz czy już jest koniec szyfru (dwa zera)
		mov		al, [r9 + rcx]
		cmp		al, 0
		jne		if_koniec
		if:
			mov		al, [r9 + rcx+1]
			jne		if_koniec
			if_zagn:
				jmp		petla_pary_szyfr_koniec
		if_koniec:
		
		jmp		petla_pary_szyfr
				
	petla_pary_szyfr_koniec:	
	;[COMMAND (encode char)] Iteruj po parach szyfru --END
	pop 	rcx								;przywroc wartosc rcx z poczatku funkcji
	ret
	
