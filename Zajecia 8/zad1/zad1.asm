;unsigned int rotate(unsigned int x, int n = 1);
;unsigned char rotate(unsigned char x, int n = 1);

;https://www.aldeid.com/wiki/X86-assembly/Instructions/rol

;https://stackoverflow.com/questions/25644445/cannot-shift-to-the-right-because-of-an-invalid-combination-of-opcode-and-operan
segment .text
global _Z6rotatehi, _Z6rotateji

_Z6rotateji:
	;rdi = x
	;rsi = n
	
	mov		rcx, rsi		;kopiujemy rsi do rcx ponieważ
							;rol może przyjmować tylko jeden bajt
							;wiec damy mu rejestr cl.
							;Wykorzystujemy rcx bo jest wolny i można go modyfikować w funkcji.
							
	rol		edi, cl			;edi bo unsigned int to 4 bajty
	mov		rax, rdi
ret	
	


_Z6rotatehi:
	;rdi = x
	;rsi = n
	
	mov		rax, rdi		;Kopiujemy od razu char'a do rax'a
							;ponieważ char to 8 bajtów więc mozemy się do niego łatwo dostać
							;za pomocą rejestru al
							
	mov		rcx, rsi	
	rol		al, cl
	
ret
