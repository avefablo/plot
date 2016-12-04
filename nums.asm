;numbers

shift_down:
	add dx, 3
	add cx, 4
	push cx
	push dx
	push bx
	jmp	next

shift_left:
	sub dx, 3
	sub cx, 3
	push cx
	push dx
	push bx
	jmp	next

number:
	push bx
	push cx
	push dx
	cmp dx, h_mid
	je shift_down
	cmp cx, w_mid
	je shift_left
	jmp next

next:
	pop ax
	cmp ax, 0
	je sign
	mov bx, 10
	mov dx, 0
	div bx
	mov bx, dx
	pop dx
	pop cx
	sub cx, 7
	push cx
	push dx
	push ax

determine:
	cmp bx, 0
	je zero
	cmp bx, 1
	je one
	cmp bx, 2
	je two
	cmp bx, 3
	je three
	cmp bx, 4
	je four
	cmp bx, 5
	je five
	cmp bx, 6
	je six
	cmp bx, 7
	je seven
	cmp bx, 8
	je eight
	cmp bx, 9
	je nine
	

sign:
	cmp dx, h_mid
	jge @@1
	jmp clear
@@1:
	cmp cx, w_mid
	jle @@minus
	jmp clear
@@minus:
	pop dx
	pop cx
	sub cx, 7
	jmp minus

clear:
	pop dx
	pop cx

finish_num:
	pop dx
	pop cx
	pop bx
	ret

vert_line:
	call pixel
	inc dx
	dec bx
	jnz vert_line
	dec dx
	ret

horiz_line:
	call pixel
	inc cx
	dec bx
	jnz horiz_line
	dec cx
	ret

one:
	mov ax, 0c03h
	add dx, 2
	call pixel
	inc cx
	dec dx
	call pixel
	inc cx
	dec dx
	call pixel
	mov bx, 7
	call vert_line
	jmp next

two:
	mov ax, 0c03h
	mov bx, 5
	call horiz_line
	mov bx, 4
	call vert_line
	sub cx, 4
	mov bx, 5
	call horiz_line
	sub cx, 4
	mov bx, 4
	call vert_line
	mov bx, 5
	call horiz_line
	jmp next

three:
	mov ax, 0c03h
	
	mov bx, 5
	call horiz_line
	sub cx, 4
	add dx, 3
	mov bx, 5
	call horiz_line
	sub cx, 4
	add dx, 3
	mov bx, 5
	call horiz_line
	sub dx, 6
	mov bx, 7
	call vert_line
	jmp next

four:
	mov ax, 0c03h
	mov bx, 4
	call vert_line
	mov bx, 5
	call horiz_line
	sub dx, 3
	mov bx, 7
	call vert_line
	jmp next

five:
	mov ax, 0c03h
	mov bx, 5
	call horiz_line
	sub cx, 4
	mov bx, 4
	call vert_line
	mov bx, 5
	call horiz_line
	mov bx, 4
	call vert_line
	sub cx, 4
	mov bx, 5
	call horiz_line
	jmp next

six:
	mov ax, 0c03h
	mov bx, 7
	call vert_line
	sub dx, 6
	mov bx, 5
	call horiz_line
	add dx, 3
	sub cx, 4
	mov bx, 5
	call horiz_line
	add dx, 3
	sub cx, 4
	mov bx, 5
	call horiz_line
	sub dx, 3
	mov bx, 4
	call vert_line	
	jmp next

seven:
	mov ax, 0c03h
	mov bx, 5
	call horiz_line
	mov bx, 3
	call vert_line
	dec cx
	inc dx
	call pixel
	dec cx
	inc dx
	call pixel
	dec cx
	inc dx
	call pixel
	inc dx
	call pixel
	jmp next

eight:
	mov ax, 0c03h
	mov bx, 7
	call vert_line
	sub dx, 6
	mov bx, 5
	call horiz_line
	add dx, 3
	sub cx, 4
	mov bx, 5
	call horiz_line
	add dx, 3
	sub cx, 4
	mov bx, 5
	call horiz_line
	sub dx, 6
	mov bx, 7
	call vert_line	
	jmp next

nine:
	mov ax, 0c03h
	mov bx, 4
	call vert_line
	sub dx, 3
	mov bx, 5
	call horiz_line
	add dx, 3
	sub cx, 4
	mov bx, 5
	call horiz_line
	add dx, 3
	sub cx, 4
	mov bx, 5
	call horiz_line
	sub dx, 6
	mov bx, 7
	call vert_line	
	jmp next

zero:
	mov ax, 0c03h
	mov bx, 7
	call vert_line
	sub dx, 6
	mov bx, 5
	call horiz_line
	add dx, 6
	sub cx, 4
	mov bx, 5
	call horiz_line
	sub dx, 6
	mov bx, 7
	call vert_line	
	jmp next

leading_zero:
	mov ax, 0c03h
	mov bx, 7
	call vert_line
	sub dx, 6
	mov bx, 5
	call horiz_line
	add dx, 6
	sub cx, 4
	mov bx, 5
	call horiz_line
	sub dx, 6
	mov bx, 7
	call vert_line
	ret	

minus:
	mov ax, 0c03h
	add dx, 3
	mov bx, 5
	call horiz_line
	jmp finish_num