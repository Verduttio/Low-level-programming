; wersja NASM na system 64-bitowy (x86-64)
; kompilacja: nasm -felf64 hello.asm -o hello.o
; linkowanie: ld hello.o -o hello
; linkowanie: ld -m elf_x86_64  hello.o -o hello

section .text            ; początek sekcji kodu.

global _start            ; linker ld domyślnie rozpoczyna
                         ; wykonywanie programu od etykiety _start
                         ; musi ona być widoczna na zewnątrz (global)
_start:                   ; punkt startu programu
  ;wyswietl powitanie
  mov	rax, 1          	; numer funkcji systemowej:
							; 1=sys_write - zapisz do pliku
  mov	rdi, 1          	; numer pliku, do którego piszemy.
							; 1 = standardowe wyjście = ekran
  mov	rsi, zapytanie      ; RSI = adres tekstu
  mov	rdx, zapytanie_len  ; RDX = długość tekstu
  syscall                 	; wywołujemy funkcję systemową


  ;pobierz imie
  mov	rax, 0				; sys_read RAX=0
  mov	rdi, 0				; indentyfikator pliku (RDI=0 to klawiatura)
  mov	rsi, imie			; adres bufora docelowego
  mov	rdx, 20				; liczba bajtów do przeczytania
  syscall
  
  ;kasowanie entera wczytanego razem z imieniem
  dec	rax 				;wykasuj enter
  mov	[imie_len], rax 	;skopiuj liczbe zapisanych bajtów
  
  
  ;Wyswietl "Witaj "
  mov	rax, 1
  mov 	rdi, 1
  mov	rsi, powitanie
  mov	rdx, powitanie_len 
  syscall
  
  ;Wyswietl imie
  mov	rax, 1
  mov	rdi, 1
  mov	rsi, imie
  mov	rdx, [imie_len]
  syscall
  
  ;Wyswietl wykrzyknik
  mov	rax, 1
  mov	rdi, 1
  mov	rsi, wykrzyknik
  mov	rdx, 1
  syscall
  
  mov	rax, 60         	; numer funkcji systemowej
							; (60=sys_exit - wyjdź z programu)
  mov	rdi, 0          	; RDI - kod wyjścia
  syscall                 	; wywołujemy funkcję systemową

section .data                   		; początek sekcji danych.
  zapytanie db "Jak masz na imię? "   	; nasz napis, który wyświetlimy
  zapytanie_len equ $ - zapytanie   	; długość napisu
  powitanie db "Witaj "
  powitanie_len equ $-powitanie
  wykrzyknik db "!"

section .bss
	imie resb 20
	imie_len resb 1
	
