.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf: proc
extern scanf: proc
extern  strcmp: proc
extern strlen: proc
extern strcpy: proc
extern sprintf: proc
extern strcat: proc
extern strncpy: proc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
expresie db 100 dup(0),0
format db "%s ", 0
format_citire db "%s",0
format_caracter db "%c ", 0
format_nr db "%d ", 0
;exit1 db "exit"
var1 db "Introduceti o expresie:",13,10,0
l dd $-var2
var2 db "exit", 0
lungime dd 0
expresie_aux db 100 dup(0),0
plus db '+',0
minus db '-', 0
numar1 dd 0
numar2 dd 0
ten equ 10
char_nr1 db 5 dup(0),0
char_nr2 db 5 dup(0),0
expr_semne db "*+-/=",0
pos dd 0
count db 0
lung_expr dd 4
expr_aux2 db 0,0
lung_aux2 dd 0
expresie2 db 100 dup(0),0
primul_numar dd 0
caract_op dd 0
inceput_op dd 0 
rezultat dd 0
rezultat_char db 100 dup(0),0
aux db 100 dup(0)
rand_nou db 13,10,0
sir_nou db 100 dup(0)
lung_rez dd 0
ceva dd 0
format_caracter2 db "%c",0
rez_precedent dd 0
.code

start:
citire:
	push offset var1
	push offset format
	call printf
	add esp, 8
	
	push offset expresie2
	push offset format_citire
	call scanf 
	add esp, 8
	
	push offset expresie2
	call strlen
	add esp, 4
	mov lungime, eax

	push offset expresie2
	push offset expresie_aux
	call strcpy
	add esp, 8
	
	lea esi, [expresie_aux]
	lea edi, [var2]
	mov ecx, lungime
	repz cmpsb
	je final
	
	cmp expresie2[0],"+"
	je urm
	cmp expresie2[0],"-"
	je urm
	cmp expresie2[0],"*"
	je urm 
	cmp expresie2[0],"/"
	je urm

	mov ecx, lungime
	mov esi, 0
	mov edi, 0
	mov eax, 0
	mov edx, 0
	jmp bucla_parcurgere1
	
	urm:
	mov esi, 1
	
bucla_parcurgere1:
	cmp expresie2[esi],'='
	je final_bucla_parcurgere1
	
	caut_numere:
	
	mov pos, esi
	
	cmp expresie2[esi],'*'
	jne impartire
	
	;mov esi, pos
	mov edi, 0
	
	decrementare_esi:
		cmp esi, 0
		je numarul_este_pe_prima_pos
		dec esi
		mov edi, 0
		jmp bucla_parcugere_inmultire_stanga
		
	bucla_parcugere_inmultire_stanga:
		
		mov dl, expr_semne[edi]
		cmp dl, expresie2[esi]
		je numar_stanga_gasit
		inc edi
		cmp edi, 5
		je decrementare_esi
		jne bucla_parcugere_inmultire_stanga
		
	cmp esi, 0
	jne numar_stanga_gasit
	
	numarul_este_pe_prima_pos:
		mov inceput_op, esi
		mov eax, 0
		mov ecx, pos
		mov ebx, 0
		mov caract_op, ecx
		formare_numar_prima_pos:
		mov bl, expresie2[esi]
		inc esi
		sub bx, '0'
		imul ax, 10
		add ax, bx
		loop formare_numar_prima_pos
	mov primul_numar, eax
	jmp part
	
	numar_stanga_gasit:
	mov inceput_op, esi
	add inceput_op, 1
	mov ecx, pos
	sub ecx, esi
	dec ecx
	mov caract_op, ecx
	mov ebx, 0
	mov eax, 0
	add esi, 1
	formare_numar_stanga:
		mov bl, expresie2[esi]
		inc esi
		sub bx, '0'
		imul ax, 10
		add ax, bx
		loop formare_numar_stanga
	mov numar1, eax
	
	part:
	mov esi, pos
	
	incrementare_esi:
		mov edi, 0
		inc esi
		jmp bucla_parcurgere_inmultire_dreapta
	
	bucla_parcurgere_inmultire_dreapta:
	
		mov dl, expr_semne[edi]
		cmp dl, expresie2[esi]
		je numar_dreapta_gasit
		inc edi
		cmp edi, 5
		je incrementare_esi
		jl bucla_parcurgere_inmultire_dreapta
	
	numar_dreapta_gasit:
	mov ecx, esi
	sub ecx, pos
	sub ecx, 1
	add caract_op, ecx
	add caract_op, 1
	mov ebx, 0
	mov ax, 0
	mov esi, pos
	add esi, 1
	formare_numar_dreapta:
		mov bl, expresie2[esi]
		inc esi
		sub bx, '0'
		imul ax, 10
		add ax, bx
		loop formare_numar_dreapta
	mov numar2, eax
	
	mov eax, 0
	cmp primul_numar, 0
	jne inmultire1
	je inmultire2
	
	inmultire1:
	mov eax, primul_numar
	mul numar2
	jmp next
	
	inmultire2:
	mov eax, numar1
	mul numar2
	
	next:
	mov rezultat, eax
	mov edi, 0
	formare_char:
		
		push rezultat
		push offset format_nr
		push offset rezultat_char
		call sprintf
		add esp, 12
	
	mov numar1, 0
	mov numar2, 0
	mov primul_numar, 0
	
	mov edi, inceput_op
	add edi, caract_op
	lea edi, [expresie_aux+edi]
	
	push edi
	push offset sir_nou
	call strcpy
	
	push offset rezultat_char
	call strlen
	mov lung_rez, eax
	
	push offset sir_nou
	push offset rezultat_char
	call strcat
	add esp, 8
	mov eax, lung_rez
	dec eax
	lea edi, [rezultat_char+eax]
	lea ebx, [rezultat_char+eax+1]
	push ebx
	push edi
	call strcpy
	add esp, 8
	
	mov eax, inceput_op
	lea ecx, [expresie_aux+eax]
	push offset rezultat_char
	push ecx
	call strcpy
	
	push offset expresie_aux
	push offset expresie2
	call strcpy
	add esp, 8
	mov esi, 0
	
	impartire:
	
	cmp expresie2[esi],'/'
	jne sari
	
	mov edi, 0
	
	decrementare_esi2:
		cmp esi, 0
		je numarul_este_pe_prima_pos2
		dec esi
		mov edi, 0
		jmp bucla_parcugere_inmultire_stanga2
		
	bucla_parcugere_inmultire_stanga2:
		
		mov dl, expr_semne[edi]
		cmp dl, expresie2[esi]
		je numar_stanga_gasit2
		inc edi
		cmp edi, 5
		je decrementare_esi2
		jne bucla_parcugere_inmultire_stanga2
	
	cmp esi, 0
	jne numar_stanga_gasit2
	
	numarul_este_pe_prima_pos2:
		mov inceput_op, esi
		mov eax, 0
		mov ecx, pos
		mov ebx, 0
		mov caract_op, ecx
		;dec ecx
		formare_numar_prima_pos2:
		mov bl, expresie2[esi]
		inc esi
		sub bx, '0'
		imul ax, 10
		add ax, bx
		loop formare_numar_prima_pos2
	mov primul_numar, eax
	
	jmp part2
	
	numar_stanga_gasit2:
	mov inceput_op, esi
	add inceput_op, 1
	mov ecx, pos
	sub ecx, esi
	dec ecx
	mov caract_op, ecx
	mov ebx, 0
	mov eax, 0
	;mov esi, pos
	add esi, 1
	formare_numar_stanga2:
		mov bl, expresie2[esi]
		inc esi
		sub bx, '0'
		imul ax, 10
		add ax, bx
		loop formare_numar_stanga2
	mov numar1, eax
	
	part2:
	mov esi, pos
	
	incrementare_esi2:
		mov edi, 0
		inc esi
		jmp bucla_parcurgere_inmultire_dreapta2
	
	bucla_parcurgere_inmultire_dreapta2:
	
		mov dl, expr_semne[edi]
		cmp dl, expresie2[esi]
		je numar_dreapta_gasit2
		inc edi
		cmp edi, 5
		je incrementare_esi2
		jl bucla_parcurgere_inmultire_dreapta2
	
	numar_dreapta_gasit2:
	mov ecx, esi
	sub ecx, pos
	sub ecx, 1
	add caract_op, ecx
	add caract_op, 1
	mov ebx, 0
	mov ax, 0
	mov esi, pos
	add esi, 1
	formare_numar_dreapta2:
		mov bl, expresie2[esi]
		inc esi
		sub bx, '0'
		imul ax, 10
		add ax, bx
		loop formare_numar_dreapta2
	mov numar2, eax
	
	mov eax, 0
	cmp primul_numar, 0
	jne impartire1
	je impartire2
	
	impartire1:
	mov edx, 0
	mov eax, primul_numar
	div numar2
	jmp next2
	
	impartire2:
	mov edx, 0
	mov eax, numar1
	div numar2
	
	next2:
	mov rezultat, eax
	mov edi, 0
	formare_char2:
		
		push rezultat
		push offset format_nr
		push offset rezultat_char
		call sprintf
		add esp, 12
	
	mov numar1, 0
	mov numar2, 0
	mov primul_numar, 0
	
	mov edi, inceput_op
	add edi, caract_op
	lea edi, [expresie_aux+edi]
	
	;;;; copiez in sirul nou sirul de dupa calcul
	push edi
	push offset sir_nou
	call strcpy
	
	push offset rezultat_char
	call strlen
	mov lung_rez, eax
	
	push offset sir_nou
	push offset rezultat_char
	call strcat
	add esp, 8
	mov eax, lung_rez
	dec eax
	lea edi, [rezultat_char+eax]
	lea ebx, [rezultat_char+eax+1]
	push ebx
	push edi
	call strcpy
	add esp, 8
	
	mov eax, inceput_op
	lea ecx, [expresie_aux+eax]
	push offset rezultat_char
	push ecx
	call strcpy
	
	push offset expresie_aux
	push offset expresie2
	call strcpy
	add esp, 8
	mov esi, 0

	sari:
	inc esi
	jmp bucla_parcurgere1
	

	final_bucla_parcurgere1:
	
	cmp expresie2[0],"+"
	je urm1
	cmp expresie2[0],"-"
	je urm1
	cmp expresie2[0],"*"
	je urm1
	cmp expresie2[0],"/"
	je urm1
	
	mov esi, 0
	mov eax, 0
	jmp bucla_parcurgere3
	
	urm1:
	mov esi, 1
	mov eax, 0
	
	bucla_parcurgere3:
	
	cmp expresie2[esi],'='
	je final_bucla_parcurgere3
	
	caut_numere3:
	
	mov pos, esi
	
	cmp expresie2[esi],'+'
	jne scadere
	
	mov edi, 0
	
	decrementare_esi3:
		cmp esi, 0
		je numarul_este_pe_prima_pos3
		dec esi
		mov edi, 0
		jmp bucla_parcugere_inmultire_stanga3
		
	bucla_parcugere_inmultire_stanga3:
		
		mov dl, expr_semne[edi]
		cmp dl, expresie2[esi]
		je numar_stanga_gasit3
		inc edi
		cmp edi, 5
		je decrementare_esi3
		jne bucla_parcugere_inmultire_stanga3
	
	cmp esi, 0
	jne numar_stanga_gasit3
	
	numarul_este_pe_prima_pos3:
		mov inceput_op, esi
		mov eax, 0
		mov ecx, pos
		mov ebx, 0
		mov caract_op, ecx
		formare_numar_prima_pos3:
		mov bl, expresie2[esi]
		inc esi
		sub bx, '0'
		imul ax, 10
		add ax, bx
		loop formare_numar_prima_pos3
	mov primul_numar, eax
	
	jmp part3
	
	numar_stanga_gasit3:
	mov inceput_op, esi
	add inceput_op, 1
	mov ecx, pos
	sub ecx, esi
	dec ecx
	mov caract_op, ecx
	mov ebx, 0
	mov eax, 0

	add esi, 1
	formare_numar_stanga3:
		mov bl, expresie2[esi]
		inc esi
		sub bx, '0'
		imul ax, 10
		add ax, bx
		loop formare_numar_stanga3
	mov numar1, eax
	
	part3:
	mov esi, pos
	
	incrementare_esi3:
		mov edi, 0
		inc esi
		jmp bucla_parcurgere_inmultire_dreapta3
	
	bucla_parcurgere_inmultire_dreapta3:
	
		mov dl, expr_semne[edi]
		cmp dl, expresie2[esi]
		je numar_dreapta_gasit3
		inc edi
		cmp edi, 5
		je incrementare_esi3
		jl bucla_parcurgere_inmultire_dreapta3

	numar_dreapta_gasit3:
	mov ecx, esi
	sub ecx, pos
	sub ecx, 1
	add caract_op, ecx
	add caract_op, 1
	mov ebx, 0
	mov ax, 0
	mov esi, pos
	add esi, 1
	formare_numar_dreapta3:
		mov bl, expresie2[esi]
		inc esi
		sub bx, '0'
		imul ax, 10
		add ax, bx
		loop formare_numar_dreapta3
	mov numar2, eax
	
	mov edx, 0
	cmp primul_numar, 0
	jne adunare1
	je adunare2
	
	adunare1:
	mov edx, primul_numar
	add edx, numar2
	jmp next3
	
	adunare2:
	mov edx, numar1
	add edx, numar2
	
	next3:
	mov rezultat, edx
	;mov edi, 0
	formare_char3:
		
		push rezultat
		push offset format_nr
		push offset rezultat_char
		call sprintf
		add esp, 12
	
	mov numar1, 0
	mov numar2, 0
	mov primul_numar, 0
	
	mov edi, inceput_op
	add edi, caract_op
	lea edi, [expresie_aux+edi]
	
	;;;; copiez in sirul nou sirul de dupa calcul
	push edi
	push offset sir_nou
	call strcpy
	
	push offset rezultat_char
	call strlen
	mov lung_rez, eax
	
	push offset sir_nou
	push offset rezultat_char
	call strcat
	add esp, 8
	mov eax, lung_rez
	dec eax
	lea edi, [rezultat_char+eax]
	lea ebx, [rezultat_char+eax+1]
	push ebx
	push edi
	call strcpy
	add esp, 8
	
	mov eax, inceput_op
	lea ecx, [expresie_aux+eax]
	push offset rezultat_char
	push ecx
	call strcpy
	
	push offset expresie_aux
	push offset expresie2
	call strcpy
	add esp, 8
	mov esi, 0

	scadere:
	
	cmp expresie2[esi],'-'
	jne sari3
	
	mov edi, 0
	
	decrementare_esi4:
		cmp esi, 0
		je numarul_este_pe_prima_pos4
		dec esi
		mov edi, 0
		jmp bucla_parcugere_inmultire_stanga4
		
	bucla_parcugere_inmultire_stanga4:
		
		mov dl, expr_semne[edi]
		cmp dl, expresie2[esi]
		je numar_stanga_gasit4
		inc edi
		cmp edi, 5
		je decrementare_esi4
		jne bucla_parcugere_inmultire_stanga4
	
	cmp esi, 0
	jne numar_stanga_gasit4
	
	numarul_este_pe_prima_pos4:
		mov inceput_op, esi
		mov eax, 0
		mov ecx, pos
		mov ebx, 0
		mov caract_op, ecx
		formare_numar_prima_pos4:
		mov bl, expresie2[esi]
		inc esi
		sub bx, '0'
		imul ax, 10
		add ax, bx
		loop formare_numar_prima_pos4
	mov primul_numar, eax
	
	jmp part4
	
	numar_stanga_gasit4:
	mov inceput_op, esi
	add inceput_op, 1
	mov ecx, pos
	sub ecx, esi
	dec ecx
	mov caract_op, ecx
	mov ebx, 0
	mov eax, 0
	add esi, 1
	formare_numar_stanga4:
		mov bl, expresie2[esi]
		inc esi
		sub bx, '0'
		imul ax, 10
		add ax, bx
		loop formare_numar_stanga4
	mov numar1, eax
	
	part4:
	mov esi, pos
	
	incrementare_esi4:
		mov edi, 0
		inc esi
		jmp bucla_parcurgere_inmultire_dreapta4
	
	bucla_parcurgere_inmultire_dreapta4:
	
		mov dl, expr_semne[edi]
		cmp dl, expresie2[esi]
		je numar_dreapta_gasit4
		inc edi
		cmp edi, 5
		je incrementare_esi4
		jl bucla_parcurgere_inmultire_dreapta4
	
	numar_dreapta_gasit4:
	mov ecx, esi
	sub ecx, pos
	sub ecx, 1
	add caract_op, ecx
	add caract_op, 1
	mov ebx, 0
	mov ax, 0
	mov esi, pos
	add esi, 1
	formare_numar_dreapta4:
		mov bl, expresie2[esi]
		inc esi
		sub bx, '0'
		imul ax, 10
		add ax, bx
		loop formare_numar_dreapta4
	mov numar2, eax
	
	mov edx, 0
	cmp primul_numar, 0
	jne scadere1
	je scadere2
	
	scadere1:
	mov edx, primul_numar
	sub edx, numar2
	jmp next4
	
	scadere2:
	mov edx, numar1
	sub edx, numar2
	
	next4:
	mov rezultat, edx
	
	formare_char4:
		push rezultat
		push offset format_nr
		push offset rezultat_char
		call sprintf
		add esp, 12
	
	mov numar1, 0
	mov numar2, 0
	mov primul_numar, 0
	
	mov edi, inceput_op
	add edi, caract_op
	lea edi, [expresie_aux+edi]
	
	push edi
	push offset sir_nou
	call strcpy
	
	push offset rezultat_char
	call strlen
	mov lung_rez, eax
	
	push offset sir_nou
	push offset rezultat_char
	call strcat
	add esp, 8
	mov eax, lung_rez
	dec eax
	lea edi, [rezultat_char+eax]
	lea ebx, [rezultat_char+eax+1]
	push ebx
	push edi
	call strcpy
	add esp, 8
	
	mov eax, inceput_op
	lea ecx, [expresie_aux+eax]
	push offset rezultat_char
	push ecx
	call strcpy
	
	push offset expresie_aux
	push offset expresie2
	call strcpy
	add esp, 8
	mov esi, 0
	
	sari3:
	inc esi
	jmp bucla_parcurgere3
	
	final_bucla_parcurgere3:
	
	mov edx,0
	mov eax, 0
	mov ecx, 0
	mov esi, 0
	mov ebx, 0
	mov eax, 0
	cmp expresie2[0],"+"
	je aici1
	cmp expresie2[0],"-"
	je aici2
	cmp expresie2[0],"*"
	je aici3
	cmp expresie2[0],"/"
	je aici4
	
	bucla_final:
	cmp expresie2[esi],'='
	je final_b
	
	mov ebx, 0
	mov ecx, 0
	mov cl, expresie2[esi]
	mov bl, expresie2[esi]
	
	sub bx, '0'
	imul ax, 10
	add ax, bx
	
	mov rez_precedent, eax

	add esi, 1
	jmp bucla_final
	
	aici1:
		add esi, 1
		cmp expresie2[esi],'='
		je alt1
		mov ebx, 0
		mov bl, expresie2[esi]
		
		sub bx, '0'
	    imul ax, 10
	    add ax, bx
		jmp aici1
	aici2:
		add esi, 1
		cmp expresie2[esi],'='
		je alt2
		mov ebx, 0
		mov bl, expresie2[esi]
		
		sub bx, '0'
	    imul ax, 10
	    add ax, bx
		jmp aici2
	
	aici3:
		add esi, 1
		cmp expresie2[esi],'='
		je alt3
		mov ebx, 0
		mov bl, expresie2[esi]
		sub bx, '0'
	    imul ax, 10
	    add ax, bx
		
		jmp aici3
	
	aici4:
		add esi, 1
		cmp expresie2[esi],'='
		je alt4
		mov bl, expresie2[esi]
		sub bx, '0'
	    imul ax, 10
	    add ax, bx
		
		jmp aici4
	
	alt1:
		add eax, rez_precedent
		mov rez_precedent, eax
		jmp final_b
	alt2:
		sub rez_precedent, eax
		mov rez_precedent, eax
		jmp final_b
	alt3:
		mul rez_precedent
		mov rez_precedent, eax
		jmp final_b
	alt4:
		mov edx, 0
		mov ebx, eax
		mov eax, rez_precedent
		div ebx
		mov rez_precedent, eax
		jmp final_b

	final_b:
	mov rez_precedent, eax
	push rez_precedent
	push offset format_nr
	call printf
	
	mov expresie2,0
	
	push offset rand_nou
	call printf
	add esp, 4
	
	jmp citire
	final:
	push 0
	call exit
end start