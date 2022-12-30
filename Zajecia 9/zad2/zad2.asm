; void gradientSSE(float *grad, float * data, int N, float scale);
; Na wyjściu: grad[i] = scale * sqrt( (data[i+1] - data[i-1])^2 + (data[i+N] - data[i-N])^2)
; dla i=0,1,...,N-2
segment .text
global gradientSSE

gradientSSE:
	; rdi = &grad  = &grad[1]
	; rsi = &data  = &data[1]
	; rdx = N
	; xmm0 = scale

	shufps	xmm0, xmm0, 0x0		; 00 00 00 00 -> przekopiuj zerowy element do wszystkich czterech

	mov		rax, rdx
	sub		rax, 2			; ostatni index jaki bedziemy obrabiać czyli (398)
	and		rax, -4			; rax = ostatni index podzielny przez 4
	
	
	;mov		rcx, 1		; licznik petli
	mov		rcx, 0		; licznik petli
	.wektorowo:
		movups	xmm1, [rsi + rcx*4 + 4]			; xmm1 = data[i+1]
		movups	xmm2, [rsi + rcx*4 - 4]			; xmm2 = data[i-1]
		
		
		mov		r8, rcx
		add		r8, rdx							; r8 = rcx + N
		movups	xmm3, [rsi + r8*4]		  		; xmm3 = data[i+N]   ;*4 bo rcx + N to elementy a musimy *4 bo float to 4 bajty
		
		mov		r9, rcx
		sub		r9, rdx
		movups	xmm4, [rsi + r9*4]				; xmm4 = data[i-N]
		
		subps	xmm1, xmm2						; xmm1 -= xmm2  | xmm1 = data[i+1] - data[i-1]
		subps	xmm3, xmm4						; xmm3 -= xmm4  | xmm3 = data[i+N] - data[i-N]
		
		mulps	xmm1, xmm1						; xmm1 *= xmm1  | xmm1 = (data[i+1] - data[i-1])^2
		mulps	xmm3, xmm3						; xmm3 *= xmm3  | xmm3 = (data[i+N] - data[i-N])^2
		
		addps	xmm1, xmm3						; xmm1 += xmm3	| xmm1 = (data[i+1] - data[i-1])^2 + (data[i+N] - data[i-N])^2
		
		sqrtps	xmm1, xmm1						; xmm1 = sqrt(xmm1)	| xmm1 = sqrt((data[i+1] - data[i-1])^2 + (data[i+N] - data[i-N])^2)
		
		mulps	xmm1, xmm0						; xmm1 = scale * sqrt((data[i+1] - data[i-1])^2 + (data[i+N] - data[i-N])^2)
		
		
		
		
		movups	[rdi + rcx*4], xmm1				; zapisz wynik
		
		add		rcx, 4
		cmp		rcx ,rax
		jl	.wektorowo

	xor		rax, rax
	ret
