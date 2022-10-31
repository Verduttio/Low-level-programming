section .text		;początek sekcji kodu


global _start		; linker ld domyślnie rozpoczyna
                    ; wykonywanie programu od etykiety _start
                    ; musi ona być widoczna na zewnątrz (global)
						

_start:                			; punkt startu programu
	;otwieramy plik: filename
	mov rax, 2 					;sys_open (Otwarcie pliku)
    mov rdi, filename			;adres nazwy pliku
    mov rsi, 0q101     			;O_CREAT - 100; O_WRONLY - 001; RAZEM 101 (zapisywane ósemkowo) (0q - jeden ze sposobów zapisu liczb ósemkowych w nasm)
    mov rdx, 0q644     			;owner 6 (read/write), group/user 4 (read)
    syscall

	;zapisujemy wiadomosc myName do pliku			
	mov [fileDescriptor], rax 	;pobieramy deskryptor (id) pliku fileName
	mov rax, 1         			;sys_write (Zapis do pliku)
	mov rdi, [fileDescriptor]   ;deskryptor pliku
	mov rsi, myName       		;wiadomosc do zapisania myName
	mov rdx, myName_len       	;dlugosc wiadomosci myName
    syscall 
    
	;zamknięcie pliku
	mov rax, 3         			;sys_close
    mov rdi, [fileDescriptor]	;podanie deskryptora pliku
    syscall

	mov	rax, 60         		;sys_exit
	mov	rdi, 0          		;kod wyjścia
	syscall

section .data
    myName db 'Super'  	;nadpisuje znaki, w przypadku gdy plik posiada tekst "Rewelacja" a my chcemy wpisać "Super" to wynik bedzie "Superacja"
    myName_len equ $ - myName
    filename db 'zadanie3_data.txt', 0
    fileDescriptor dq 0
