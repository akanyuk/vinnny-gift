	device zxspectrum48


	define _MUSIC_ 1

	org #6000
page0s	di : ld sp, page0s
	xor a : out (#fe), a 
	ld hl, #4000 : ld de, #4001 : ld bc, #17ff : ld (hl), l : ldir

	ld a,#be, i,a, hl,interr, (#beff),hl : im 2 : ei

	ld hl, SCR1
	ld de, #4000
	ld bc, #1b00
	ldir

	ifdef _MUSIC_
	call PT3PLAY
	endif

	ld b, 100 : halt : djnz $-1

	// Poem
	ld hl, #5800 + 6*32 + 5
	ld a, 15
.lineLoop	push af
	push hl

	ld a, 23
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

	ld b, 100 : halt : djnz $-1

	ld hl, SCR2
	ld de, #4000
	ld bc, #1b00
	ldir

	jr $

interr	di
	push af,bc,de,hl,ix,iy
	exx : ex af, af'
	push af,bc,de,hl,ix,iy

	ifdef _MUSIC_
	call PT3PLAY + 5	
	endif

	pop iy,ix,hl,de,bc,af
	exx : ex af, af'
	pop iy,ix,hl,de,bc,af
	ei
	ret

SCR1	incbin "res/stih1 (white ink).scr"
SCR2	incbin "res/sshot000000.scr"
PT3PLAY	include "src/PTxPlay.asm"
	incbin "res/nq-underfiller-cut.pt3"

page0e	display /d, '[page 0] free: ', #ffff - $, ' (', $, ')'	
	include "src/builder.asm"
