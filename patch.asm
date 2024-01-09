; Build params: ------------------------------------------------------------------------------

; Overrides: ---------------------------------------------------------------------------------
    ;Credit
    org $180
    dc.w   $596f, $536f, $794e, $6163, $686f, $0000, $0000 ; ("YoSoyNacho")

    ;SRAM TYPE AND ADDRESS
    org $1B0
    dc.w   $5241, $f820, $0020, $0001, $0020, $3fff ;( "RA",F8h,20h )(00200001)(00203fff)

    ;menu password to load game
    org $3653E
    dc.l $000363D6

    ;Enable SRAM writing
    org $306
    jsr ENABLE_SRAM

    ;remove pword ram writing    
    org $21aa6
    nop

    ;bypass password menu
    org $21afe
    nop

    ;copy password from SRAM TO RAM
    org $21a52
    jsr SRAMtoRAM

    ;store password in sram
    org $21bf2
    jmp StorePword
Here:

    ;bypass password after race
    org $21cae
    nop

; Detours: -----------------------------------------------------------------------------------
    org $1FFFC0
ENABLE_SRAM:
    move.w  ($C00004).l,d0
    move.b  #1,($A130F1).l ; enable SRAM writing
    rts

    org $1fff50
SRAMtoRAM:
    lea     ($fffff5e8).w,a0    ; Beginning of data
    lea     ($200001).l,a1  ; Beginning of SRAM
    move.w  #$27,d0  ; Number of bytes
Loop:
    move.b  (a1),(a0)       ; Write byte to RAM
    addq.l  #1,a0           ; Advance data byte
    addq.l  #2,a1           ; Advance SRAM byte
    dbf     d0,Loop         ; Keep going
    lea     ($0015a350).l,A0
    rts

    org $1fff70
StorePword:
    jsr     $21d92 
    lea     ($fffff5e8).w,a0    ; Beginning of data
    lea     ($200001).l,a1  ; Beginning of SRAM
    move.w  #$27,d0  ; Number of bytes
Loop2:
    move.b  (a0),(a1)       ; Write byte to SRAM
    addq.l  #1,a0           ; Advance data byte
    addq.l  #2,a1           ; Advance SRAM byte
    dbf     d0,Loop2        ; Keep going
    jmp     Here     


