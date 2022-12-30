; na wyjściu out[i] = wiersz[i+1] - wiersz[i]
; void diff(char *out,char *wiersz, int n);

segment .text
global diff

diff:
	; rdi = &out
	; rsi = &wiersz
	; rdx = n
	
	
	mov		rax, rdx
	and		rax, -16		; rax = ostatni index podzielny przez 16
	
	mov		r9, rdx
	
	xor		rcx, rcx		; rcx = 0
	
	.wektorowo:
		movdqu		xmm1, [rsi + rcx + 1]
		movdqu		xmm0, [rsi + rcx]
		
		psubsb		xmm1, xmm0
		
		movdqu		[rdi + rcx], xmm1
		
		
		add		rcx, 16
		cmp		rcx, rax
		jl .wektorowo
	
	
	
	.skalarnie:
		cmp rcx, r9
		jae .koniec
		
		movdqu		xmm1, [rsi + rcx + 1]
		movdqu		xmm0, [rsi + rcx]
		
		psubsb		xmm1, xmm0				; specjalne odejmowanie
		
		movdqu		[rdi + rcx], xmm1   
    
	inc rcx 
	jmp .skalarnie

	
	.koniec:
		mov		rax, 0
		ret
	
