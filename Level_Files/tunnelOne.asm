WormTunnelOne:
;==============================================================
; Scene beginning
;==============================================================
    ld hl, sceneComplete
    ld (hl), $00

;Start off with no sprites
    ld hl, spriteCount
    ld (hl), $00
    ld hl, sprUpdCnt
    ld (hl), $00


;==============================================================
; Memory (Structures, Variables & Constants) 
;==============================================================

;Structures and Variables
.enum postBoiler export
    color       db
    streamBuff  dsb 8            ;Buffer for the BG palette for the waterfall effect

.ende

;Constants
.define nothingConstant     $0000

;==============================================================
; Clear VRAM
;==============================================================
    call BlankScreen

    call ClearVRAM

    call ClearSATBuff


;==============================================================
; Load Palette
;==============================================================
;All black palette to be used once we are making things pretty
/*
;Write current BG palette to currentPalette struct
    ld hl, currentBGPal.color0
    ld de, FadedPalette
    ld b, $10
    call PalBufferWrite

;Write current SPR palette to currentPalette struct
    ld hl, currentSPRPal.color0
    ld de, FadedPalette
    ld b, $10
    call PalBufferWrite
*/

;Palettes for BG and Sprites
;Write current BG palette to currentPalette struct
    ld hl, currentBGPal.color0
    ld de, WormTunnelOneBgPal
    ld b, $10
    call PalBufferWrite

;Write current SPR palette to currentPalette struct
    ld hl, currentSPRPal.color0
    ld de, WormTunnelOneSprPal
    ld b, $10
    call PalBufferWrite

;Actually update the palettes in VRAM
    call LoadBackgroundPalette
    call LoadSpritePalette


;==============================================================
; Load BG tiles 
;==============================================================
    ld hl, $0000 | VRAMWrite
    call SetVDPAddress
    ld hl, WaterCubeTiles
    ld bc, WaterCubeTilesEnd-WaterCubeTiles
    call CopyToVDP

;==============================================================
; Write background map
;==============================================================
     ld hl, $3800 | VRAMWrite
    call SetVDPAddress
    ld hl, WaterCubeMap
    ld bc, WaterCubeMapEnd-WaterCubeMap
    call CopyToVDP


;==============================================================
; Load Sprite tiles 
;==============================================================
    
;Now we want to write the character data. For now, we will just
;keep all the frames in VRAM since there's so few
    ld hl, $2000 | VRAMWrite
    call SetVDPAddress
    ld hl, SunFishDefaultTiles
    ld bc, SunFishDefaultTilesEnd-SunFishDefaultTiles
    call CopyToVDP


;==============================================================
; Intialize our Variables
;==============================================================
    xor a
    ld hl, color
    ld (hl), a

    ld hl, streamBuff
    ld (hl), 32
    inc hl
    ld (hl), 48
    inc hl
    ld (hl), 52
    inc hl
    ld (hl), 53
    inc hl
    ld (hl), 56
    inc hl
    ld (hl), 57
    inc hl
    ld (hl), 61
    inc hl
    ld (hl), 62
    inc hl
    

;==============================================================
; Intialize our objects
;==============================================================


;==============================================================
; Set Registers for HBlank
;==============================================================

    ld a, $02                               ;$07 = HBlank every 8 scanlines
    ld c, $8A
    call UpdateVDPRegister

;Blank Left Column
    ld a, %00110100                         ;BIT 5 BLANK column
    ld c, $80
    call UpdateVDPRegister

;=============================================================
; Set Scene
;=============================================================
    ld hl, sceneID
    ld (hl), $02


;==============================================================
; Turn on screen
;==============================================================
 ;(Maxim's explanation is too good not to use)
    ld a, %01100010
;           ||||||`- Zoomed sprites -> 16x16 pixels
;           |||||`-- Doubled sprites -> 8x16
;           ||||`--- Mega Drive mode 5 enable
;           |||`---- 30 row/240 line mode
;           ||`----- 28 row/224 line mode
;           |`------ VBlank interrupts
;            `------- Enable display    
    ld c, $81
    call UpdateVDPRegister

    ei

;========================================================
; Game Logic
;========================================================

    ;call FadeIn

WormTunnelOneMainLoop:
;Start LOOP
    halt
    
;End LOOP
    jp WormTunnelOneMainLoop


;========================================================
; Worm Tunnel One Data
;========================================================

;========================================================
; Background Palette
;========================================================
WormTunnelOneBgPal:
    .include "..\\assets\\palettes\\backgrounds\\wormTunnelOne_bgPal.inc"

WormTunnelOneBgPalEnd:


;========================================================
; Background Tiles
;========================================================

WormTunnelOneTiles:
    .include "..\\assets\\tiles\\backgrounds\\wormTunnelOne_tiles.inc"
WormTunnelOneTilesEnd:

WaterCubeTiles:
    .include "..\\assets\\tiles\\backgrounds\\waterCube_tiles.inc"
WaterCubeTilesEnd:


;========================================================
; Tile Maps
;========================================================
WaterCubeMap:
    .include "..\\assets\\maps\\watercube_map.inc"
WaterCubeMapEnd:


;========================================================
; Sprite Palette
;========================================================
WormTunnelOneSprPal:
    .include "..\\assets\\palettes\\sprites\\wormTunnelOne_sprPal.inc"
WormTunnelOneSprPalEnd:


;========================================================
; Sprite Tiles
;========================================================
SunFishDefaultTiles:
    .include "..\\assets\\tiles\\sprites\\sunFish\\default.inc"
SunFishDefaultTilesEnd:

SunFishUpTiles:
    .include "..\\assets\\tiles\\sprites\\sunFish\\up.inc"
SunFishUpTilesEnd:

SunFishDownTiles:
    .include "..\\assets\\tiles\\sprites\\sunFish\\down.inc"
SunFishDownTilesEnd: