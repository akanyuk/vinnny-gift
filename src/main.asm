	device zxspectrum48


	; define _MUSIC_ 1

	org #6000
page0s	di : ld sp, page0s
	xor a : out (#fe), a 
	ld hl, #4000 : ld de, #4001 : ld bc, #1aff : ld (hl), l : ldir

	ld a,#be, i,a, hl,interr, (#beff),hl : im 2 : ei

	ld hl, POEM
	call screenReplace

	ifdef _MUSIC_
	call PT3PLAY
	endif

	ld b, 100 : halt : djnz $-1

	// Poem
	ld hl, #5800 + 6*32 + 5
	ld a, 16
.lineLoop	push af
	push hl

	ld a, 24
.charLoop	ld (hl), %01111001
	dup 4
	halt
	edup
	inc hl
	dec a : jr nz, .charLoop

	dup 8
	halt
	edup

	pop hl
	ld de, #0020
	add hl, de

	pop af : dec a : jr nz, .lineLoop


	ld hl, amigaPlayer
	call interrStart

	ld b, 200 : halt : djnz $-1
	ld b, 200 : halt : djnz $-1
	ld b, 200 : halt : djnz $-1

	call interrStop

	ld hl, FACE
	call screenReplace

	jr $

	; запуск нужной процедуры на прерываниях
	; HL - адрес процедура
interrStart	ld de, interrCurrent
	ex de, hl
	ld (hl), #c3 ; jp
	inc hl : ld (hl), e
	inc hl : ld (hl), d
	ret

	; остановка процедуры на прерываниях
interrStop	ld hl, interrCurrent
	ld (hl), #c9 ; ret
	ret

interrCurrent	ret
	nop
	nop


interr	di
	push af,bc,de,hl,ix,iy
	exx : ex af, af'
	push af,bc,de,hl,ix,iy

	ifdef _MUSIC_
	call PT3PLAY + 5	
	endif

	call interrCurrent

	pop iy,ix,hl,de,bc,af
	exx : ex af, af'
	pop iy,ix,hl,de,bc,af
	ei
	ret

	; hl - screen
screenReplace	ld (.movePixels+1), hl
	ld de, #1800
	add hl, de
	ld (.moveAttrs+1), hl
	
	ld hl, #4000
	ld (.movePixels+4), hl

	ld hl, #5800
	ld (.moveAttrs+4), hl

	ld b,32
.loop	push bc
.movePixels	ld hl, #0000
	ld de, #4000

	ld a, 192
	ld bc, #0020
	push hl
	push de
1	push af
	ld a,(hl) : ld(de),a
	call DownDE
	add hl,bc
	pop af : dec a : jr nz,1b
	pop de : inc de : ld (.movePixels+4),de
	pop hl : inc hl : ld (.movePixels+1),hl	

.moveAttrs	ld hl, #0000
	ld de, #5800
	
	ld a,24
	ld bc,#001f
	push hl
	push de	
1	push af
	ldi : inc bc
	add hl,bc
	ex de,hl : add hl,bc : ex de,hl
	pop af : dec a : jr nz,1b
	pop de : inc de : ld (.moveAttrs+4),de
	pop hl : inc hl : ld (.moveAttrs+1),hl	

	halt
	pop bc
	djnz .loop
	ret

DownDE	inc d : ld a,d : and #07 : ret nz : ld a,e : sub #e0 : ld e,a : sbc a,a : and #f8 : add a,d : ld d,a : ret

amigaPlayer	ld a, 0 : inc a : and #03 : ld (amigaPlayer + 1), a
	cp #01 : jr z, 1f
	cp #03 : ret nz
	ld de, #4000
	call amiga1.DisplayFrame
	jp amiga1.NextFrame
1	ld de, #401a
	call amiga2.DisplayFrame
	jp amiga2.NextFrame
	module amiga1
	include "res/amiga/player.asm"
	endmodule
	module amiga2
	include "res/amiga/player.asm"
	endmodule
	include "res/amiga/frames.asm"

POEM	incbin "res/poem.bin"
FACE	incbin "res/face.bin"

	display $

	org #c000
PT3PLAY	include "src/PTxPlay.asm"
	incbin "res/nq-underfiller-cut.pt3"

page0e	display /d, '[page 0] free: ', #ffff - $, ' (', $, ')'	
	include "src/builder.asm"
