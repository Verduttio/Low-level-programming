BITS 32
section .text
global sortuj        ; funkcja sortuj ma być widziana w innych modułach aplikacji
sortuj:
   enter 0, 0     ;  tworzymy ramkę stosu na początku funkcji
      ; ENTER 0,0 = PUSH EBP / MOV EPB, ESP
      ; po wykonaniu enter 0,0
      ; w [ebp]    znajduje się stary EBP
      ; w [ebp+4]  znajduje się adres powrotny z procedury
      ; w [ebp+8]  znajduje się pierwszy parametr,
      ; w [ebp+12] znajduje się drugi parametr
      ; itd.
; pomocnicze makrodefinicje
   %idefine    x    	[ebp+8]			;x = &x
   %idefine    y    	[ebp+12]		;y = &y
   %idefine    z    	[ebp+16]		;z = &z
; tu zaczyna się właściwy kod funkcji
	;[COMMAND] Sprawdzenie i ew zamiana x <-> y --START
	mov		eax, x
	mov		eax, [eax]					;eax = x
	
	mov		ecx, y
	mov		ecx, [ecx]					;ecx = y
	
	;if(x < y) swap(x, y)
	cmp		eax, ecx
	jnl 	if_1_koniec
	if_1:
		mov		edx, x					;edx = &x
		mov		[edx], ecx				;*edx (*x) = y
		
		mov		edx, y					;edx = &y
		mov		[edx], eax				;*edx (*y) = x
	if_1_koniec:
	;[COMMAND] Sprawdzenie i ew zamiana x <-> y --END
	
	
	
	;[COMMAND] Sprawdzenie i ew zamiana y <-> z --START
	;[INFO] Wczytaj: eax = y; ecx = z
	mov		eax, y
	mov		eax, [eax]					;eax = y
	
	mov		ecx, z
	mov		ecx, [ecx]					;ecx = z
	
	;if(y < z) swap(y, z)
	cmp		eax, ecx
	jnl 	if_2_koniec
	if_2:
		mov		edx, y					;edx = &y
		mov		[edx], ecx				;*edx (*y) = z
		
		mov		edx, z					;edx = &z
		mov		[edx], eax				;*edx (*z) = y
	if_2_koniec:
	;[COMMAND] Sprawdzenie i ew zamiana y <-> z --END
	
	
	
	;[COMMAND] Sprawdzenie i ew zamiana x <-> y --START
	mov		eax, x
	mov		eax, [eax]					;eax = x
	
	mov		ecx, y
	mov		ecx, [ecx]					;ecx = y
	
	;if(x < y) swap(x, y)
	cmp		eax, ecx
	jnl 	if_3_koniec
	if_3:
		mov		edx, x					;edx = &x
		mov		[edx], ecx				;*edx (*x) = y
		
		mov		edx, y					;edx = &y
		mov		[edx], eax				;*edx (*y) = x
	if_3_koniec:
	;[COMMAND] Sprawdzenie i ew zamiana x <-> y --END
	
	
	
; tu kończy się właściwy kod funkcji
   leave     ; usuwamy ramkę stosu LEAVE = MOV ESP, EBP / POP EBP
ret    ; wynik zwracany jest w rejestrze eax
