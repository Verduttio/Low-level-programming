BITS 32
section .text
global minmax        ; funkcja minmax ma być widziana w innych modułach aplikacji
minmax:
   enter 0, 0     ;  tworzymy ramkę stosu na początku funkcji
      ; ENTER 0,0 = PUSH EBP / MOV EPB, ESP
      ; po wykonaniu enter 0,0
      ; w [ebp]    znajduje się stary EBP
      ; w [ebp+4]  znajduje się adres powrotny z procedury
      ; w [ebp+8]  znajduje się pierwszy parametr,
      ; w [ebp+12] znajduje się drugi parametr
      ; itd.
; pomocnicze makrodefinicje
   %idefine    obiekt_minmax    	[ebp+8]			
   %idefine    n			    	[ebp+12]			
   %idefine	   current_number		[ebp + 12 + ecx*4]
; tu zaczyna się właściwy kod funkcji



	;[COMMAND] Iterujemy po liczbach (parametrach) --START
	mov		ecx, 1					;licznik petli
	
	mov		eax, current_number		   	;min = eax = pierwsza liczba
	mov		edx, current_number 	   	;max = edx = pierwsza liczba
	
	inc 	ecx
	
	while_poczatek:
		cmp		ecx, n
		jg		while_koniec
		
		;if(min > obecna_liczba) then min = obecna_liczba  --START
		cmp		eax, current_number
		jng		if_min_else
		if_min:
			mov		eax, current_number
			jmp		if_min_koniec
		if_min_else:
			;if(max < obecna_liczba) then max = obecna_liczba --START
			cmp		edx, current_number
			jnl		if_min_koniec
			if_max:
				mov		edx, current_number
				jmp		if_max_koniec
			if_max_koniec:
			;if(max < obecna_liczba) then max = obecna_liczba --END
		if_min_koniec:
		;if(min > obecna_liczba) then min = obecna_liczba  --END
		
		
		
		inc		ecx
		jmp		while_poczatek
	while_koniec:
	;[COMMAND] Iterujemy po liczbach (parametrach) --END
	
	
	;[INFO] min = eax; max = edx;
	
	;[COMMAND] Zapisujemy min i max do struktury
	;Pierwsze 4 bajty to chyba min
	;Nastepne 4 bajty to pewnie max
	
	mov		ecx, obiekt_minmax			;ecx = &obiekt_minmax
	mov		[ecx], eax					;obiekt_minmax.min = eax
	mov		[ecx+4], edx				;obiekt_minmax.max = edx
	
	
; tu kończy się właściwy kod funkcji
   leave     ; usuwamy ramkę stosu LEAVE = MOV ESP, EBP / POP EBP
ret    ; wynik zwracany jest w rejestrze eax
