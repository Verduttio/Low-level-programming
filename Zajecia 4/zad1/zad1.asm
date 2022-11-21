; KOMPILACJA:  plik źródłowy c_asm.asm
; nasm -o c_asm.obj -felf c_asm.asm
; gcc -m32 -nopie c_asm.obj -o c_asm

section .data
	napis_scanf db "%d%d", 0
	napis_printf db "%d", 0
	first_number times 4 db 0
	second_number times 4 db 0


section .text

extern scanf          ; definicja funkcji scanf znajduje się w bibliotece standardowej C
extern printf
global main  
main:                  ; punkt wejścia - funkcja main
	enter 0, 0
								; scanf("%d%d", &first_number, &second_number);
	push   second_number        ; trzeci argument
	push   first_number		    ; drugi argument
	push   dword napis_scanf    ; pierwszy argument 
								; UWAGA: kolejność argumentów RLO (od prawej do lewej)
	call   scanf           		; uruchomienie funkcji
	add    esp, 3*4        		; posprzątanie stosu - rejestr ESP wskazuje to samo, 
								; co przed wywołaniem funkcji printf
						   
	;[INFO] Wykonaj dzielenie
	xor		edx, edx
	mov		eax, dword [first_number]
	mov		ecx, dword [second_number]
	cdq
	idiv		ecx				;eax = eax / ecx
	
	
	;[INFO] Wypisz wynik
	push	eax
	push    dword napis_printf
	
	call	printf
	add		esp, 2*4		;posprzątaj stos
	
	
	xor    eax, eax        ; return 0;
	leave
	ret                    ; wyjście z programu
