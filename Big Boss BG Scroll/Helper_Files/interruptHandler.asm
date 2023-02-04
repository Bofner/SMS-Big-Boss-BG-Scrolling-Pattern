;Get here after coming from $0038
InterruptHandler:
;Check if we are at VBlank, Bit 7 tells us that
    ld a, (VDPStatus)
    bit 7, a                ;Z is set if bit is 0
    jp nz, VBlank     

;=========================================================
; HBlank
;=========================================================

;Cycle through 8 different colors 
    ld hl, streamBuff
    ld bc, (INTPattern)
    add hl, bc
    ld a, (hl)


;Changes the BG color 0 and Sprite color 0
;Parameters: A = BG Color
;Affects: A, HL, BC
Change0thIndexPal:

;Set Setup to write to CRAM
    ld c, VDPCommand
    ld hl, $c000 | VRAMWrite
    ld de, $c010 | VRAMWrite
;Wait until we are in HBlank
    ld b, $0E
-:
    djnz -
    nop
    nop
    nop
    nop

;Write to SPR 0th Color
    ;out (c), e    
    ;out (c), d
;Set SPR 0th color
    ;out (VDPData), a
;Write to BG 0th Color
    out (c), l   
    out (c), h
;Set BG 0th Color
    out (VDPData), a

;Ater every 8 scanlines, repeat the pattern
    ld hl, INTPattern
    inc (hl)
    ld a, (hl)
    cp $08
    jr nz, +
    ld (hl), $00

+:
    ret


;=========================================================
; VBlank
;=========================================================
;If we are on the last scanline
VBlank:
;Set  IntNumber to zero
    xor a
    ld hl, INTNumber
    ld (hl), a
    inc hl                  ;ld hl, INTPattern
    ld (hl), a

;Update frame count
    call UpdateFrameCount


;Scene Specifics
    ld a, (sceneID)
    cp $02
    jp nz, EndVBlank 
    
;Waterfall test scene
;Set Setup to write to CRAM
    ld a, $00
    ld c, VDPCommand
    ld hl, $c000 | VRAMWrite
    ld de, $c010 | VRAMWrite    

;Delay before writing
    nop


;Write to BG 0th Color
    out (c), e    
    out (c), d
;Set BG 0th color
    out (VDPData), a
;Write to SPR 0th Color
    out (c), l   
    out (c), h
;Set SPR 0th Color
    out (VDPData), a

    ld a, (frameCount)
    and %00000001
    jp nz, EndVBlank

    ld hl, scrollY    
    ld a, (hl)
    cp 224
    jr nz, +
    ld (hl), $FF                          
+:
    inc (hl)
    ld a, (hl)
    ld c, $89                           ;Scroll screen vertically
    call UpdateVDPRegister

    ld hl, scrollX                              
    inc (hl)
    ld a, (hl)
    ld c, $88                           ;Scroll screen horizontally
    call UpdateVDPRegister


;Make the water flow
    ld hl, streamBuff
    ld c, (hl)
    ld b, $07
-:
    ld a, c
    inc hl
    ld c, (hl)
    ld (hl), a
    djnz -

    ld a, c
    ld hl, streamBuff
    ld (hl), a

    

EndVBlank:
    ret


