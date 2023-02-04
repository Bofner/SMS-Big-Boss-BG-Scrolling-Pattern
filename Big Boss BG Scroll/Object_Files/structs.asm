;==============================================================
;All Structs that are sprites MUST have the following attributes
;==============================================================
/*
    sprNum      db      ;The draw-number of the sprite      
    hw          db      ;The height and width of the entire OBJ
    y           db      ;The Y coord of the OBJ
    x           db      ;The X coord of the OBJ
    cc          db      ;The first character code for the OBJ 
    sprSize     db      ;The total area of the OBJ
*/


;==============================================================
; Palette structure
;==============================================================
.struct paletteStruct
    color0      db
    color1      db
    color2      db
    color3      db
    color4      db
    color5      db
    color6      db
    color7      db
    color8      db
    color9      db
    colorA      db
    colorB      db
    colorC      db
    colorD      db
    colorE      db
    colorF      db
.endst

;==============================================================
; SFS Shimmer
;==============================================================
.struct shimmerStruct
    sprNum      db      ;The draw-number of the sprite      
    hw          db      ;The hight and width of the entire OBJ
    y           db      ;The Y coord of the OBJ
    x           db      ;The X coord of the OBJ
    cc          db      ;The first character code for the OBJ 
    sprSize     db      ;The total area of the OBJ
.endst
