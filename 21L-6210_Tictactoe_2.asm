[org 0x0100]
jmp start
entries:dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
Box_coordinates: dw 840,868,898,926,1480,1508,1538,1566,2120,2148,2178,2206,2760,2788,2818,2846
compare_index: dw 664,694,722,752,1304,1334,1362,1392,1944,1974,2002,2032,2584,2614,2642,2672
occupied: db 'Box is already occupied',0
turnP1: db 'Player 1 turn',0
turnP2: db 'Player 2 turn',0
P1Win: db 'Player 1 Won the game',0
P2Win: db 'Player 2 Won the game',0
tie: db 'ITS A TIE',0
welcome: db 'Welcome to TIC TAC TOE',0
error:db 'Wrong Click, Click in the box only',0
msg:db 'HOW TO PLAY : Click on the box to mark',0
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
	mov ah,0x70
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
		mov ah, 0x60
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
	mov ah,0xF0
	mov al,20h
	cld
	rep stosw

	push 3880
	mov ax,msg
	push ax
	call printstr

	push 0
	mov ax,name
	push ax
	call printstr

	GridBackground:
		mov di, 342
		mov ah,0xE0 ;grid background color attribute
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
		mov ah,0x00
		mov al,' '
		mov cx, 58
		L1:
			mov [es:di],ax
			add di,2
			loop L1

		mov cx, 16
		L2:
			mov [es:di],ax
			add di,160
			loop L2

		mov cx, 58
		L3:
			mov [es:di],ax
			sub di,2
			loop L3

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

    popa
	ret

printnum: push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx
push di
mov ax, 0xb800
mov es, ax 
mov ax, [bp+4] 
mov bx, 10 
mov cx, 0 
nextdigit: mov dx, 0 
div bx
add dl, 0x30 
push dx
inc cx 
cmp ax, 0 
jnz nextdigit 
mov di, [bp+6]
nextpos: pop dx 
mov dh, 0x07 
mov [es:di], dx 
add di, 2 
loop nextpos 
pop di
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret 4



player1:
	push bp
	mov bp,sp
	sub sp,2
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

	waitForMouseClick:
	mov ax, 0001h 			;to show mouse
	int 33h
	mov ax,0003h
	int 33h
	or bx,bx
	jz short waitForMouseClick
	mov ax, 0002h 			;hide mouse after clicking
	int 33h

	mov si,dx                    
	mov dx,0
	mov ax,cx
	mov bx,8
	div bx                         ;dividing by 8 to convert it into row column format.
	mov cx,ax		        
	mov ax,si
	mov dx,0
	div bx                         ;dividing by 8 to convert it into row column format.
	mov dx,ax

	mov ah,0
	mov al,80
	mul dl
	add ax,cx
	shl ax,1
	;jmp waitForMouseClick
	mov si,-2
	mov bx,664

		cmp ax,bx
		jb printError
		jg comparison

		printError: 
		mov ax,3400
		push ax
		mov ax, error
		push ax
		call printstr
		call delay
		mov ax,3400
		push ax
		mov ax,error
		push ax
		call clrtext
		jmp readkeyp1

	comparison:
		add si,2
		mov bx,[compare_index+si]
		cmp ax,bx
		mov word [bp-2],si
		compare:
		cmp ax,bx
		je near printInBox
		jb printError
		add bx,26
		cmp ax,bx
		jbe near printInBox
		add bx,134
		cmp ax,bx
		jb comparison
		je near printInBox
		add bx,26
		cmp ax,bx
		jbe near printInBox
		add bx,134
		cmp ax,bx
		jb comparison
		je near printInBox
		add bx,26
		cmp ax,bx
		jbe near printInBox
		jg comparison

	printInBox:
		xor di,di
		xor si,si
		mov di,[bp-2]
		mov si,[entries+di]
		cmp si,0
		jne near occupiedp1
		mov word [entries+di],1
		mov si,Box_coordinates
		add si,di
		mov di,[si]
		mov ax, 0xb800
		mov es, ax
		mov word [es:di],0x604F
		;jmp exitgame

	conditionsP1:
		mov si,entries

		row0:
		cmp word [si],1
		jne row1
		cmp word [si+2],1
		jne row1
		cmp word [si+4],1
		jne row1
		cmp word [si+6],1
		je near returnWin1

		row1:
		cmp word [si+8],1
		jne row2
		cmp word [si+10],1
		jne row2
		cmp word [si+12],1
		jne row2
		cmp word [si+14],1
		je near returnWin1

		row2:
		cmp word [si+16],1
		jne row3
		cmp word [si+18],1
		jne row3
		cmp word [si+20],1
		jne row3
		cmp word [si+22],1
		je near returnWin1

		row3:
		cmp word [si+24],1
		jne col0
		cmp word [si+26],1
		jne col0
		cmp word [si+28],1
		jne col0
		cmp word [si+30],1
		je near returnWin1
		
		col0:
		cmp word [si],1
		jne col1
		cmp word [si+8],1
		jne col1
		cmp word [si+16],1
		jne col1
		cmp word [si+24],1
		je near returnWin1

		col1:
		cmp word [si+2],1
		jne col2
		cmp word [si+10],1
		jne col2
		cmp word [si+18],1
		jne col2
		cmp word [si+26],1
		je near returnWin1

		col2:
		cmp word [si+4],1
		jne col3
		cmp word [si+12],1
		jne col3
		cmp word [si+20],1
		jne col3
		cmp word [si+28],1
		je returnWin1

		col3:
		cmp word [si+6],1
		jne diagonal1
		cmp word [si+14],1
		jne diagonal1
		cmp word [si+22],1
		jne diagonal1 
		cmp word [si+30],1
		je returnWin1

		diagonal1:
		cmp word [si],1
		jne diagonal2
		cmp word [si+10],1
		jne diagonal2
		cmp word [si+20],1
		jne diagonal2
		cmp word [si+30],1
		je returnWin1

		diagonal2:
		cmp word [si+6],1
		jne exit_p1
		cmp word [si+12],1
		jne exit_p1
		cmp word [si+18],1
		jne exit_p1
		cmp word [si+24],1
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
	jmp exitgame

	exit_p1:popa
	mov sp,bp
	pop bp
	ret

player2:
	push bp
	mov bp,sp
	sub sp,2
    pusha
	mov word [bp-2],0
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

	waitForMouseClick_:
	mov ax, 0001h 			;to show mouse
	int 33h
	mov ax,0003h
	int 33h
	or bx,bx
	jz short waitForMouseClick_
	mov ax, 0002h 			;hide mouse after clicking
	int 33h

	mov si,dx                    
	mov dx,0
	mov ax,cx
	mov bx,8
	div bx                         ;dividing by 8 to convert it into row column format.
	mov cx,ax
	mov ax,si
	mov dx,0
	div bx                         ;dividing by 8 to convert it into row column format.
	mov dx,ax 

	mov ah,0
	mov al,80
	mul dl
	add ax,cx
	shl ax,1
	mov si,-2

	mov bx,664

		cmp ax,bx
		jb printError_
		jg comparison_

		printError_: 
		mov ax,3400
		push ax
		mov ax, error
		push ax
		call printstr
		call delay
		mov ax,3400
		push ax
		mov ax,error
		push ax
		call clrtext
		jmp readkeyp2

	comparison_:
		add si,2
		mov bx,[compare_index+si]
		mov word [bp-2],si
		compare_:
		cmp ax,bx
		je near printInBox_
		jb printError_
		add bx,26
		cmp ax,bx
		jbe near printInBox_
		add bx,134
		cmp ax,bx
		jb comparison_
		je near printInBox_
		add bx,26
		cmp ax,bx
		jbe near printInBox_
		add bx,134
		cmp ax,bx
		jb comparison_
		je near printInBox_
		add bx,26
		cmp ax,bx
		jbe near printInBox_
		jg comparison_

	printInBox_:
		xor di,di
		xor si,si
		mov di,[bp-2]
		mov si,[entries+di]
		cmp si,0
		jne near occupiedp2
		mov word [entries+di],2
		mov si,Box_coordinates
		add si,di
		mov di,[si]
		mov ax, 0xb800
		mov es, ax
		mov word [es:di],0x6058
		;jmp exit_p2

	conditionsP2:
		mov si,entries

		row0_:
		cmp word [si],2
		jne row1_
		cmp word [si+2],2
		jne row1_
		cmp word [si+4],2
		jne row1_
		cmp word [si+6],2
		je near returnWin2

		row1_:
		cmp word [si+8],2
		jne row2_
		cmp word [si+10],2
		jne row2_
		cmp word [si+12],2
		jne row2_
		cmp word [si+14],2
		je near returnWin2

		row2_:
		cmp word [si+16],2
		jne row3_
		cmp word [si+18],2
		jne row3_
		cmp word [si+20],2
		jne row3_
		cmp word [si+22],2
		je near returnWin2

		row3_:
		cmp word [si+24],2
		jne col0_
		cmp word [si+26],2
		jne col0_
		cmp word [si+28],2
		jne col0_
		cmp word [si+30],2
		je near returnWin2
		
		col0_:
		cmp word [si],2
		jne col1_
		cmp word [si+8],2
		jne col1_
		cmp word [si+16],2
		jne col1_
		cmp word [si+24],2
		je near returnWin2

		col1_:
		cmp word [si+2],2
		jne col2_
		cmp word [si+10],2
		jne col2_
		cmp word [si+18],2
		jne col2_
		cmp word [si+26],2
		je near returnWin2

		col2_:
		cmp word [si+4],2
		jne col3_
		cmp word [si+12],2
		jne col3_
		cmp word [si+20],2
		jne col3_
		cmp word [si+28],2
		je returnWin2

		col3_:
		cmp word [si+6],2
		jne diagonal1_
		cmp word [si+14],2
		jne diagonal1_
		cmp word [si+22],2
		jne diagonal1_ 
		cmp word [si+30],2
		je returnWin2

		diagonal1_:
		cmp word [si],2
		jne diagonal2_
		cmp word [si+10],2
		jne diagonal2_
		cmp word [si+20],2
		jne diagonal2_
		cmp word [si+30],2
		je returnWin2

		diagonal2_:
		cmp word [si+6],2
		jne exit_p2
		cmp word [si+12],2
		jne exit_p2
		cmp word [si+18],2
		jne exit_p2
		cmp word [si+24],2
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
	jmp exitgame

	exit_p2:
	
	popa
	mov sp,bp
	pop bp
	ret

	welcomeScreen:
	pusha
	mov ax, 0xb800
	mov es, ax
	mov di, 0
	mov cx,2000
	mov ah,0xF0
	mov al,20h
	cld
	rep stosw
	mov ax, 1974
    push ax
    mov ax, welcome
    push ax 
	call printstr
    mov di, 2126              

    mov ah, 0x74 ; only need to do this once 
    print0: 
        mov al, '-'
        mov [es:di], ax 
        add di, 2
        cmp di, 2190
        jne print0

    mov ah, 0x76
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

	mov ah,0x60
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
	call delay
	call player2
	call delay
	jcxz Tie
	loop gameLoop
	Tie: mov ax,3430
	push ax
	mov ax,tie
	push ax
	call printstr
	exitgame:mov ax,0x4c00
	int 21h