;;void kopiuj(unsigned int * cel, unsigned int * zrodlo, unsigned int n);

;;void zeruj(unsigned int * tablica, unsigned int n);



segment .text
global _Z6kopiujPjS_j, _Z5zerujPjj

_Z6kopiujPjS_j:
	; rdi = &cel
	; rsi = &zrodlo
	; rdx = n
	
	cld					; zerujemy flagę DF (czyli rejestry beda zwiekszane tzn. add ESI/EDI)
	mov		rcx, rdx	; rcx = rdx = licznik petli
	rep		movsd		; rep powtowarza instrukcję rcx razy
		
ret

_Z5zerujPjj:
	; rdi = &cel
	; rsi = n
	
	mov		eax, 0		; eax = 0
	mov		rcx, rsi	
	rep 	stosd		; mov [ES:EDI], eax
	
ret
