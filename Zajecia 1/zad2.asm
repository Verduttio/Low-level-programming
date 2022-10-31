section .text		;początek sekcji kodu

global _start		;potrzebne do linkera ld

_start:				;punkt startu programu
	;wyswietlamy napis informacyjny
	mov rax, 1					;sys_write
	mov rdi, 1					;deskryptor pliku (ekran = 1)
	mov rsi, infoMain			;adres ciągu bajtów do zapisania
	mov rdx, infoMain_len 		;liczba bajtów w ciągu
	syscall
	
	;wyswietlamy instrukcję
	mov rax, 1					;sys_write
	mov rdi, 1					;deskryptor pliku (ekran = 1)
	mov rsi, infoProcedura		;adres ciągu bajtów do zapisania
	mov rdx, infoProcedura_len 	;liczba bajtów w ciągu
	syscall


	;pobieramy pierwszy argument
	mov rax, 0					;sys read
	mov rdi, 0					;klawiatura
	mov rsi, cyfraPierwsza		;adres bufora docelowego
	mov	rdx, 2					;CO SIĘ DZIEJE Z DRUGIM WCZYTANYM BAJTEM? ponieważ cyfraPierwsza jesli cyfraPierwsza jest zadeklarowana jako db (1 bajt)	
	syscall

	;pobieramy drugi argument
	mov rax, 0					;sys read
	mov rdi, 0					;klawiatura
	mov rsi, cyfraDruga			;adres bufora docelowego
	mov	rdx, 2		
	syscall
	
	;konwersja na liczby z ascii
	mov al, [cyfraPierwsza]
	sub al, '0'
	mov [cyfraPierwsza], al

	
	;konwersja na liczby z ascii
	mov rax, 0 ;reset
	mov al, [cyfraDruga]
	sub al, '0'
	mov [cyfraDruga], al
	
	;wykonaj dodawanie
	mov al, [cyfraPierwsza]
	add al, [cyfraDruga]
	
	;wynik moze byc dwucyfrowy wiec uzyjemy div aby poznac iloraz i resztę (odpowiednio cyfrę dziesiątek i jedności wyniku)
	mov rdx, 0					;zerowanie dla bezpieczeństwa (przy dzieleniu)
	mov rcx, 10					;bedziemy dzielic rax/rcx wiec ładujemy do rcx 10 bo chcemy dzielic przez 10 (aby poznać cyfre jedności)
	div rcx						;rax/rcx   iloraz(wynik)=rax reszta=rdx
	add rdx, '0'				;mamy liczbę a chcemy wartość ASCII tej liczby, bo będziemy wyświetlać
	mov [infoWynik + 9], dl		;zapisujemy cyfre jedności
	add al, '0'
	mov [infoWynik + 8], al		;zapisujemy cyfre dziesiątek
	
	
	;wyswietl wynik 
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, infoWynik
	mov	rdx, infoWynik_len
	syscall
	
	mov	rax, 60         		;sys_exit
	mov	rdi, 0          		;kod wyjścia
	syscall

section .data
	infoMain db "Kalkulator dwóch cyfr [dodawanie]", 0xa
	infoMain_len equ $ - infoMain
	infoProcedura db "Podaj dwie cyfry rozdzielone spacją bądź enterem: ", 0xa
	infoProcedura_len equ $ - infoProcedura
	infoWynik db "Wynik = XX", 0xa
	infoWynik_len	equ $ - infoWynik
	cyfraPierwsza dw 0  ;(2 bajty, 1 na cyfrę, drugi na enter)
	cyfraDruga	dw	0
