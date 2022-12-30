; void scaleSSE(float *out,float *in, int N);
; OUT(i,j) = (IN(2*i,2*j) + IN(2*i +1,2*j) + IN(2*i,2*j + 1) + IN(2*i + 1,2*j + 1))/4

segment .data
  four	dd	4.0,4.0,4.0,4.0

segment .text
global scaleSSE

scaleSSE:
	; rdi = &out
	; rsi = &in
	; rdx = N
	
	mov		r8, rdx
	
	xor		rdx, rdx
	mov		rax, r8
	mov		rcx, 2
	div		rcx
	
	
	

	and		rax, -4		; rax = rax - (4-rax%4) ==> największa liczba mniejsza od rax podzielna przez 4
	
	xor		rcx, rcx
	.wektorowo:
		movups	xmm0, [rsi + 2*rcx*4]		; xmm0 = IN(2*i,2*j)     | drugi element to IN(2*i, 2*j+1), trzeci element to pierwszy element 
		; a1 | a2 | next_a1 | next_a2																;dla kolejnej iteracji, czyli dla xmm2... itd.
		
		mov		r9, rcx						; r9 = rcx
		add		r9, r9						; r9 = 2*rcx
		add		r9, r8						; r9 = 2*rcx + N
		movups	xmm1, [rsi + r9*4]			; xmm1 = IN(2*i +1,2*j)  | drugi element to IN(2*i + 1, 2*j + 1)
		; b1 | b2 | next_b1 | next_b2
		
		; w rejestrze wynikowym bedziemy mieli dwa piksele z czterech wolnych 
		; więc możemy policzyć dwa następne tak by skopiować cały rejestr xmm_
		; do tablicy wyjściowej
		
		movups	xmm2, [rsi + 2*rcx*4 + 2*8]	
		; c1 | c2 | next_c1 | next_c2
		
		movups	xmm3, [rsi + r9*4 + 2*8]
		; d1 | d2 | next_d1 | next_d2
		
		;;;;;
		
		addps	xmm0, xmm1
		; a1+b1 | a2+b2 | next_a1 + next_b1 | next_a2 + next_b2
		
		addps	xmm2, xmm3
		; c1+d1 | c2+d2 | next_c1 + next_d1 | next_c2 + next_d2
		
		
		
		; HADDPS - dodawanie poziome
		haddps	xmm0, xmm2
		; a1+b1+a2+b2 | next_a1 + next_b1 + next_a2 + next_b2 | c1+d1+c2+d2 | next_c1 + next_d1 + next_c2 + next_d2
		
		
		;dzielenie przez 4
		
		movups	xmm1, [four]
		divps 	xmm0, xmm1
		
		movups	[rdi + rcx*4], xmm0
		
		
		add		rcx, 4
		cmp		rcx, rax
		jl 	.wektorowo
	
	
	
	mov		rax, 0
	ret
