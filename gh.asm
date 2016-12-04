.model tiny
.386
locals
.code 
org 100h

width_ = 640
height_ = 480

start:	
	mov ax, 12h ; 640x480x16
	int 10h ; call interuption

	; ox axis
	mov dx, h_mid
	mov cx, 0
	call ox_axis

	;oy axis
	mov cx, w_mid
	mov dx, 0
	call oy_axis

	mov cx, w_mid
	mov dx, h_mid
	add cx, 4
	add dx, 4
	call leading_zero

	mov cx, 0
	call draw_plot

	mov ax, 0
	int 16h
	mov ax, 3
	int 10h
	ret

	tmp dq 0.0
	w_mid dw width_/2
	h_mid dw height_/2
	x_step dw 40
	y_step dw 80
	res dq 0.0

;ox_axis
ox_axis:
	mov ax, 0c07h
	call pixel
	inc cx
	cmp cx, width_
	je @@1
	jmp ox_axis

@@1:
	mov bx, 0
	mov cx, w_mid
	call left_ox_dashes
	
	mov bx, 0
	mov cx, w_mid
	call right_ox_dashes
	call ox_arrow
	ret	

left_ox_dashes:
	mov dx, h_mid
	sub dx, 5
	sub cx, x_step
	inc bx
	cmp cx, 0
	jle @@1
	call draw_vert_dash
	call number
	jmp left_ox_dashes
@@1:
	ret

right_ox_dashes:
	mov dx, h_mid
	sub dx, 5
	add cx, x_step
	inc bx
	cmp cx, width_
	jge @@1
	call draw_vert_dash
	call number
	jmp right_ox_dashes
@@1:
	ret

draw_vert_dash:
	mov ax, 0c07h
	call pixel
	cmp dx, h_mid
	je @@1
	inc dx
	jmp draw_vert_dash
@@1:
	ret

ox_arrow:
	mov ax, 0c07h
	mov cx, width_
	mov dx, h_mid
	sub cx, 5
	sub dx, 5
	mov bx, 5
@@1:
	call pixel
	inc cx
	inc dx
	dec bx
	jz @@2
	jmp @@1
@@2:
	mov bx, 6
@@3:
	call pixel
	dec cx
	inc dx
	dec bx
	jz @@4
	jmp @@3
@@4:
	ret

;oy_axis
oy_axis:
	mov ax, 0c07h
	call pixel
	inc dx
	cmp dx, height_
	je @@1
	jmp oy_axis
@@1:
	mov bx, 0
	mov dx, h_mid
	call up_oy_dashes

	mov bx, 0
	mov dx, h_mid
	call down_oy_dashes
	call oy_arrow
	ret	

up_oy_dashes:
	mov cx, w_mid
	add cx, 5
	sub dx, y_step
	inc bx
	cmp dx, 0
	jle @@1
	call draw_horiz_dash
	call number
	jmp up_oy_dashes
@@1:
	ret

down_oy_dashes:
	mov cx, w_mid
	add cx, 5
	add dx, y_step
	inc bx
	cmp dx, height_
	jge @@1
	call draw_horiz_dash
	call number
	jmp down_oy_dashes
@@1:
	ret

draw_horiz_dash:
	mov ax, 0c07h
	call pixel
	cmp cx, w_mid
	je @@1
	dec cx
	jmp draw_horiz_dash
@@1:
	ret

oy_arrow:
	mov ax, 0c07h
	mov cx, w_mid
	mov dx, 0
	sub cx, 5
	add dx, 5
	mov bx, 5
@@1:
	call pixel
	inc cx
	dec dx
	dec bx
	jz @@2
	jmp @@1
@@2:
	mov bx, 6
@@3:
	call pixel
	inc cx
	inc dx
	dec bx
	jz @@4
	jmp @@3
@@4:
	ret


pixel: ;ax - color
	cmp cx, 0
	jle @@1
	cmp cx, width_
	jge @@1
	cmp cx, 0
	jle @@1
	cmp cx, width_
	jge @@1
	int 10h ; call interuption
@@1:
	ret

include nums.asm

fin:
	ret

draw_plot:
	finit
	fild h_mid
	fild w_mid
	fild y_step
	fild x_step
	fld tmp
	mov ax, 0c09h
@@1: ; pixel to coord
	fld st(0)
	fsub st(0), st(4) ;x-w2
	fdiv st(0), st(2) ;(x-w2)/s
@@2: ; calc a func
	fld st(0)
	fsin ;sin = y
	fdiv st(0), st(1); sinx/x = y 
@@3: ; res to pixel
	fmul st(0), st(4) ; y*s
	fchs ;-y*s
	fadd st(0), st(6) ; -y*s + h2
	fistp res
	fistp tmp
@@4: ;inc x
	fld1 ;push 1
	fadd st(1), st(0); add 1
	fstp tmp ;pop 1
	mov dx, word ptr res ;mov res to dx
@@5: ;draw plot pixel
	call pixel
	inc cx
	cmp cx, width_
	jge @@6
	jmp @@1
@@6:
	ret

end start