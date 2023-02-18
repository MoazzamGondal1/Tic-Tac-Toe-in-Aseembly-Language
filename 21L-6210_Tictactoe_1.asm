[org 0x0100]
jmp start
entries:db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
Box_coordinates: dw 840,868,898,926,1480,1508,1538,1566,2120,2148,2178,2206,2760,2788,2818,2846
occupied: db 'Box is already occupied',0
turnP1: db 'Player 1 turn',0
turnP2: db 'Player 2 turn',0
P1Win: db 'Player 1 Won the game',0
P2Win: db 'Player 2 Won the game',0
tie: db 'ITS A TIE',0
welcome: db 'Welcome to TIC TAC TOE',0
error: db 'Wong key pressed',0
msg: db 'HOW TO PLAY : Press any key according to box label to mark',0
name:db 'MOAZZAM (21L-6210)',0

delay:
	push ax
	push cx
	mov cx,0x000C
	sleepl1:
		mov ax,0xffff

	sleepl2:
		dec ax
		cmp ax,0
		ja sleepl2

		dec cx
		cmp cx,0
		ja sleepl1
	pop cx
	pop ax
	ret

clrtext:
	push bp
	mov bp,sp
	pusha
	    push ds
		pop es
		mov di,[bp+4]
		mov cx, 0xffff
		xor al,al
		repne scasb
		mov ax, 0xffff
		sub ax, cx
		dec ax
		jz exitclr
	mov cx, ax
	mov ax, 0xb800
	mov es, ax
	mov di, [bp+6]
	mov ah,0x00
	mov al,20h
	cld
	rep stosw
	exitclr:popa
	pop bp
	ret 4



printstr:
		push bp
		mov bp, sp
		pusha
		
		push ds
		pop es
		mov di,[bp+4]
		mov cx, 0xffff
		xor al,al
		repne scasb
		mov ax, 0xffff
		sub ax, cx
		dec ax
		jz exit
		
		mov cx, ax
		mov ax, 0xb800
		mov es, ax
		mov di, [bp+6]
		mov si, [bp+4]
		mov ah, 0x40
		cld
		nextchar:
			lodsb
			stosw
			loop nextchar
		exit:
			popa
			pop bp
			ret 4

GridPrinting:
    pusha
	mov ax, 0xb800
	mov es, ax
	mov di, 0
	mov cx,2000
	mov ah,0x00
	mov al,20h
	cld
	rep stosw

	push 3864
	mov ax,msg
	push ax
	call printstr

	push 0
	mov ax,name
	push ax
	call printstr

	GridBackground:
		mov di, 342
		mov ah,0x00 ;grid background color attribute
		mov al,20h
		mov cx,16
		printBackground:
			add di, 160
			mov bx,58
			printL:
				mov [es:di],ax
				add di,2
				dec bx
				jnz printL
			sub di, 116
			dec cx
			jnz printBackground

	    GridOutline:
		mov di, 502
		mov ah,0x04
		mov al,'-'
		mov cx, 58
		L1:
			mov [es:di],ax
			add di,2
			loop L1

		mov al,'|'
		mov cx, 16
		L2:
			mov [es:di],ax
			add di,160
			loop L2

		mov al,'-'
		mov cx, 58
		L3:
			mov [es:di],ax
			sub di,2
			loop L3

		mov al,'|'
		mov cx, 16
		L4:
			mov [es:di],ax
			sub di,160
			loop L4

		InnerLines:
		mov di, 692
		mov cx, 16
		L1_:
			mov [es:di],ax
			add di,160
			dec cx
			jnz L1_
		
		mov di, 720
		mov cx, 16
		L2_:
			mov [es:di],ax
			add di,160
			dec cx
			jnz L2_

		mov di, 750
		mov cx, 16
		L3_:
			mov [es:di],ax
			add di,160
			dec cx
			jnz L3_

		mov di, 1142
		mov cx, 58
		mov al,'-'
		L4_:
			mov [es:di],ax
			add di,2
			dec cx
			jnz L4_

		mov di, 1782
		mov cx, 58
		L5_:
			mov [es:di],ax
			add di,2
			dec cx
			jnz L5_

		mov di, 2422
		mov cx, 58
		L6_:
			mov [es:di],ax
			add di,2
			dec cx
			jnz L6_

		BoxLabels:		
		mov di, 664
		mov word [es:di],0x0730
		mov di, 694
		mov word [es:di],0x0731
		mov di, 722
		mov word [es:di],0x0732
		mov di, 752
		mov word [es:di],0x0733
		mov di, 1304
		mov word [es:di],0x0734
		mov di, 1334
		mov word [es:di],0x0735
		mov di, 1362
		mov word [es:di],0x0736
		mov di, 1392
		mov word [es:di],0x0737
		mov di, 1944
		mov word [es:di],0x0738
		mov di, 1974
		mov word [es:di],0x0739
		mov di, 2002
		mov word [es:di],0x0741
		mov di, 2032
		mov word [es:di],0x0742
		mov di, 2584
		mov word [es:di],0x0743
		mov di, 2614
		mov word [es:di],0x0744
		mov di, 2642
		mov word [es:di],0x0745
		mov di, 2672
		mov word [es:di],0x0746

    popa
	ret

player1:
    pusha
	mov ax,230
	push ax
	mov ax,turnP1
	push ax
	call clrtext
	mov ax,230
	push ax
	mov ax,turnP1
	push ax
	call printstr

readkeyp1:
	mov ah,0
	int 0x16
	mov ah,0
	cmp ax,70
	ja printError
	jbe i

	printError: 
		mov ax,3420
		push ax
		mov ax, error
		push ax
		call printstr
		call delay
		mov ax,3420
		push ax
		mov ax,error
		push ax
		call clrtext
		jmp readkeyp1

	i: cmp ax,48
	jb printError
	sub ax,48
	mov si,entries
	cmp ax,0x09
	jbe m0
	sub ax,0x07
	m0: add si,ax
	cmp byte [si],0
	jne near occupiedp1
	mov byte [si],1
	mov si, Box_coordinates
	shl ax,1
	add si,ax
	mov di,[si]
	mov ax, 0xb800
	mov es, ax
	mov word [es:di],0x044F
	;jmp exit_p1

	conditionsP1:
		mov si,entries

		row0:
		cmp byte [si],1
		jne row1
		cmp byte [si+1],1
		jne row1
		cmp byte [si+2],1
		jne row1
		cmp byte [si+3],1
		je near returnWin1

		row1:
		cmp byte [si+4],1
		jne row2
		cmp byte [si+5],1
		jne row2
		cmp byte [si+6],1
		jne row2
		cmp byte [si+7],1
		je near returnWin1

		row2:
		cmp byte [si+8],1
		jne row3
		cmp byte [si+9],1
		jne row3
		cmp byte [si+10],1
		jne row3
		cmp byte [si+11],1
		je near returnWin1

		row3:
		cmp byte [si+12],1
		jne col0
		cmp byte [si+13],1
		jne col0
		cmp byte [si+14],1
		jne col0
		cmp byte [si+15],1
		je near returnWin1
		
		col0:
		cmp byte [si],1
		jne col1
		cmp byte [si+4],1
		jne col1
		cmp byte [si+8],1
		jne col1
		cmp byte [si+12],1
		je near returnWin1

		col1:
		cmp byte [si+1],1
		jne col2
		cmp byte [si+5],1
		jne col2
		cmp byte [si+9],1
		jne col2
		cmp byte [si+13],1
		je near returnWin1

		col2:
		cmp byte [si+2],1
		jne col3
		cmp byte [si+6],1
		jne col3
		cmp byte [si+10],1
		jne col3
		cmp byte [si+14],1
		je returnWin1

		col3:
		cmp byte [si+3],1
		jne diagonal1
		cmp byte [si+7],1
		jne diagonal1
		cmp byte [si+11],1
		jne diagonal1 
		cmp byte [si+15],1
		je returnWin1

		diagonal1:
		cmp byte [si],1
		jne diagonal2
		cmp byte [si+5],1
		jne diagonal2
		cmp byte [si+10],1
		jne diagonal2
		cmp byte [si+15],1
		je returnWin1

		diagonal2:
		cmp byte [si+3],1
		jne exit_p1
		cmp byte [si+6],1
		jne exit_p1
		cmp byte [si+9],1
		jne exit_p1
		cmp byte [si+12],1
		je returnWin1
		jmp exit_p1

	occupiedp1:
	mov ax,3420
	push ax
	mov ax, occupied
	push ax
	call printstr
	call delay
	mov ax,3420
	push ax
	mov ax,occupied
	push ax
	call clrtext
	jmp readkeyp1

	returnWin1:
	mov ax,3420
	push ax
	mov ax,P1Win
	push ax
	call printstr
	call delay
	mov ax,3420
	push ax
	mov ax,P1Win
	push ax
	;call clrtext
	jmp exitgame

	exit_p1:popa
	ret

player2:
    pusha
	mov ax,230
	push ax
	mov ax,turnP2
	push ax
	call clrtext
	mov ax,230
	push ax
	mov ax,turnP2
	push ax
	call printstr

readkeyp2:
	mov ah,0
	int 0x16
	mov ah,0

	cmp ax,70
	ja printError_
	jbe i_

	printError_: 
		mov ax,3420
		push ax
		mov ax, error
		push ax
		call printstr
		call delay
		mov ax,3420
		push ax
		mov ax,error
		push ax
		call clrtext
		jmp readkeyp2


	i_:cmp ax,48
	jb printError_
	sub ax,48
	mov si,entries
	cmp ax,0x09
	jbe m0_
	sub ax,0x07
	m0_: add si,ax
	cmp byte [si],0
	jne near occupiedp2
	mov byte [si],2
	mov si, Box_coordinates
	shl ax,1
	add si,ax
	mov di,[si]
	mov ax, 0xb800
	mov es, ax
	mov word [es:di],0x0458
	;jmp exit_p2

	conditionsP2:
		mov si,entries

		row0_:
		cmp byte [si],2
		jne row1_
		cmp byte [si+1],2
		jne row1_
		cmp byte [si+2],2
		jne row1_
		cmp byte [si+3],2
		je near returnWin2

		row1_:
		cmp byte [si+4],2
		jne row2_
		cmp byte [si+5],2
		jne row2_
		cmp byte [si+6],2
		jne row2_
		cmp byte [si+7],2
		je near returnWin2

		row2_:
		cmp byte [si+8],2
		jne row3_
		cmp byte [si+9],2
		jne row3_
		cmp byte [si+10],2
		jne row3_
		cmp byte [si+11],2
		je near returnWin2

		row3_:
		cmp byte [si+12],2
		jne col0_
		cmp byte [si+13],2
		jne col0_
		cmp byte [si+14],2
		jne col0_
		cmp byte [si+15],2
		je near returnWin2
		
		col0_:
		cmp byte [si],2
		jne col1_
		cmp byte [si+4],2
		jne col1_
		cmp byte [si+8],2
		jne col1_
		cmp byte [si+12],2
		je near returnWin2

		col1_:
		cmp byte [si+1],2
		jne col2_
		cmp byte [si+5],2
		jne col2_
		cmp byte [si+9],2
		jne col2_
		cmp byte [si+13],2
		je near returnWin2

		col2_:
		cmp byte [si+2],2
		jne col3_
		cmp byte [si+6],2
		jne col3_
		cmp byte [si+10],2
		jne col3_
		cmp byte [si+14],2
		je returnWin2

		col3_:
		cmp byte [si+3],2
		jne diagonal1_
		cmp byte [si+7],2
		jne diagonal1_
		cmp byte [si+11],2
		jne diagonal1_
		cmp byte [si+15],2
		je returnWin2

		diagonal1_:
		cmp byte [si],2
		jne diagonal2_
		cmp byte [si+5],2
		jne diagonal2_
		cmp byte [si+10],2
		jne diagonal2_
		cmp byte [si+15],2
		je returnWin2

		diagonal2_:
		cmp byte [si+3],2
		jne exit_p1
		cmp byte [si+6],2
		jne exit_p1
		cmp byte [si+9],2
		jne exit_p1
		cmp byte [si+12],2
		je returnWin2
		jmp exit_p2

	occupiedp2:
	mov ax,3420
	push ax
	mov ax, occupied
	push ax
	call printstr
	call delay
	mov ax,3420
	push ax
	mov ax,occupied
	push ax
	call clrtext
	jmp readkeyp2

	returnWin2:
	mov ax,3420
	push ax
	mov ax,P2Win
	push ax
	call printstr
	call delay
	mov ax,3420
	push ax
	mov ax,P2Win
	push ax
	;call clrtext
	jmp exitgame

	exit_p2:popa
	ret

	welcomeScreen:
	pusha
	mov ax, 0xb800
	mov es, ax
	mov di, 0
	mov cx,2000
	mov ah,0x00
	mov al,20h
	cld
	rep stosw
	mov ax, 1974
    push ax
    mov ax, welcome
    push ax 
	call printstr
    mov di, 2126              

    mov ah, 0x04 ; only need to do this once 
    print0: 
        mov al, '-'
        mov [es:di], ax 
        add di, 2
        cmp di, 2190
        jne print0

    mov ah, 0x08
    mov al, 'P'
    mov word [es:2312], ax
    mov al, 'L'
    mov word [es:2314], ax
    mov al, 'A'
    mov word [es:2316], ax
    mov al, 'Y'
    mov word [es:2318], ax
    mov al, '!'
    mov word [es:2320], ax

	mov ah,0x40
	mov al,' '

	mov di,164
	mov cx,76
	b_ : mov word [es:di],ax
	add di,2
	loop b_

	mov cx,23
	b0: mov word [es:di],ax
	add di,160
	loop b0

	mov cx,76
	sub di,160
	sub di,2
	b1: mov word [es:di],ax
	sub di,2
	loop b1

	mov cx,23
	b3: mov word [es:di],ax
	sub di,160
	loop b3


	popa
	ret 4

	clrscr:     
    push es
    push ax
    push di

    mov  ax, 0xb800
    mov  es, ax
    mov  di, 0

    nextloc:
        mov  word [es:di], 0x0720
        add  di, 2
        cmp  di, 4000
        jne  nextloc

    pop  di 
    pop  ax
    pop  es
    ret


start: 
	call welcomeScreen
	mov ah,0
	int 0x16
	call clrscr
	call GridPrinting
	mov cx,8
	gameLoop:
	call player1
	call player2
	jcxz Tie
	loop gameLoop
	Tie: mov ax,3430
	push ax
	mov ax,tie
	push ax
	call printstr
	exitgame:mov ax,0x4c00
	int 21h