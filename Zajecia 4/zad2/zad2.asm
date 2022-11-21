BITS 32
section .text
global iloczyn        ; funkcja iloczyn ma być widziana w innych modułach aplikacji
iloczyn:
   enter 0, 0     ;  tworzymy ramkę stosu na początku funkcji
      ; ENTER 0,0 = PUSH EBP / MOV EPB, ESP
      ; po wykonaniu enter 0,0
      ; w [ebp]    znajduje się stary EBP
      ; w [ebp+4]  znajduje się adres powrotny z procedury
      ; w [ebp+8]  znajduje się pierwszy parametr,
      ; w [ebp+12] znajduje się drugi parametr
      ; itd.
; pomocnicze makrodefinicje
   %idefine    n    	[ebp+8]
   %idefine    tab	    [ebp+12]
; tu zaczyna się właściwy kod funkcji
   mov    	eax, 1			;tutaj będzie iloczyn
   
   mov		ecx, 0			;licznik petli
   ;[COMMAND] Iterowanie po elementach tablicy
   poczatek_petli:
		mov		edx, tab			;edx = &tab
		mov		edx, [edx + ecx*4] 	;edx = tab[ecx]
		mul		edx					;eax = eax * edx
		
		inc		ecx
		cmp		ecx, n
		jne		poczatek_petli
   
; tu kończy się właściwy kod funkcji
   leave     ; usuwamy ramkę stosu LEAVE = MOV ESP, EBP / POP EBP
ret    ; wynik zwracany jest w rejestrze eax
