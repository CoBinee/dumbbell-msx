; Sound.s : サウンド
;


; モジュール宣言
;
    .module Sound

; 参照ファイル
;
    .include    "bios.inc"
    .include    "System.inc"
    .include    "App.inc"
    .include	"Sound.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; BGM を再生する
;
_SoundPlayBgm::

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; a < BGM

    ; 現在再生している BGM の取得
    ld      bc, (_soundChannel + SOUND_CHANNEL_A + SOUND_CHANNEL_HEAD)

    ; サウンドの再生
    add     a, a
    ld      e, a
    add     a, a
    add     a, e
    ld      e, a
    ld      d, #0x00
    ld      hl, #soundBgm
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    inc     hl
    ld      a, e
    cp      c
    jr      nz, 10$
    ld      a, d
    cp      b
    jr      z, 19$
10$:
    ld      (_soundChannel + SOUND_CHANNEL_A + SOUND_CHANNEL_REQUEST), de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    inc     hl
    ld      (_soundChannel + SOUND_CHANNEL_B + SOUND_CHANNEL_REQUEST), de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
;   inc     hl
    ld      (_soundChannel + SOUND_CHANNEL_C + SOUND_CHANNEL_REQUEST), de
19$:

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; SE を再生する
;
_SoundPlaySe::

    ; レジスタの保存
    push    hl
    push    de

    ; a < SE

    ; サウンドの再生
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      hl, #soundSe
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
;   inc     hl
    ld      (_soundChannel + SOUND_CHANNEL_D + SOUND_CHANNEL_REQUEST), de

    ; レジスタの復帰
    pop     de
    pop     hl

    ; 終了
    ret

; サウンドを停止する
;
_SoundStop::

    ; レジスタの保存

    ; サウンドの停止
    call    _SystemStopSound

    ; レジスタの復帰

    ; 終了
    ret

; BGM が再生中かどうかを判定する
;
_SoundIsPlayBgm::

    ; レジスタの保存
    push    hl

    ; cf > 0/1 = 停止/再生中

    ; サウンドの監視
    ld      hl, (_soundChannel + SOUND_CHANNEL_A + SOUND_CHANNEL_REQUEST)
    ld      a, h
    or      l
    jr      nz, 10$
    ld      hl, (_soundChannel + SOUND_CHANNEL_A + SOUND_CHANNEL_PLAY)
    ld      a, h
    or      l
    jr      nz, 10$
    or      a
    jr      19$
10$:
    scf
19$:

    ; レジスタの復帰
    pop     hl

    ; 終了
    ret

; SE が再生中かどうかを判定する
;
_SoundIsPlaySe::

    ; レジスタの保存
    push    hl

    ; cf > 0/1 = 停止/再生中

    ; サウンドの監視
    ld      hl, (_soundChannel + SOUND_CHANNEL_D + SOUND_CHANNEL_REQUEST)
    ld      a, h
    or      l
    jr      nz, 10$
    ld      hl, (_soundChannel + SOUND_CHANNEL_D + SOUND_CHANNEL_PLAY)
    ld      a, h
    or      l
    jr      nz, 10$
    or      a
    jr      19$
10$:
    scf
19$:

    ; レジスタの復帰
    pop     hl

    ; 終了
    ret

; 共通
;
soundNull:

    .ascii  "T1@0"
    .db     0x00

; BGM
;
soundBgm:

    .dw     soundNull, soundNull, soundNull
    .dw     soundMuscleA, soundMuscleB, soundMuscleC

; マッスル
soundMuscleA:

    .ascii  "T3@0V15,5"
    .ascii  "L3O5R5A-1A-1A-A-FRE-"
    .ascii  "L3RFE-FA-7"
    .ascii  "L3O5R5A-1A-1A-A-FRE-"
    .ascii  "L3RFE-FO6C5O5B-A-"
    .ascii  "L3O5R5A-1A-1A-A-FRE-"
    .ascii  "L3RFE-FA-5B-A-"
    .ascii  "L3O6C7C7"
    .ascii  "L3C4O5B-4A-E-E-E5"

    .ascii  "L3O5R5A-1A-1A-A-FRE-"
    .ascii  "L3RFE-FA-7"
    .ascii  "L3O5R5A-1A-1A-A-FRE-"
    .ascii  "L3RFE-FO6C5O5B-A-"
    .ascii  "L3O5R5A-1A-1A-A-FRE-"
    .ascii  "L3RFE-FA-5B-A-"
    .ascii  "L3O6C7C7"
    .ascii  "L3C4O5B-4A-E-E-E5"

    .ascii  "L3O5R5A-1A-1A-A-FRE-"
    .ascii  "L3RFE-FA-7"
    .ascii  "L3O5R5A-1A-1A-A-FRE-"
    .ascii  "L3RFE-FO6C5O5B-A-"
    .ascii  "L3O5R5A-1A-1A-A-FRE-"
    .ascii  "L3RFE-FA-5B-A-"
    .ascii  "L3O6C7C7"
    .ascii  "L3C4O5B-4A-E-E-E5"

    .ascii  "L3O5R5A-1A-1A-A-FRR"
    .db     0x00

soundMuscleB:

    .ascii  "T3@0V15,2"
    .ascii  "L3O2FO3FO2F1O3FO2F1O3FC1AO2F1O3F"
    .ascii  "L3O2A-O3A-O2A-1O3A-O2A-1O3A-E-1O4CO2A-1O3A-"
    .ascii  "L3O3D-O4D-O3D-1O4D-O3D-1O4D-O3A-1O4FO3D-1O4D-"
    .ascii  "L3O3E-O4E-O3E-1O4E-O3E-1O4E-O3B-1O4GO3E-1O4E-"
    .ascii  "L3O3FO4CO3F1O4CO3F1O4CO3F1O4FO3F1O4C"
    .ascii  "L3O2A-O3A-O2A-1O3A-O2A-1O3A-E-1O4CO2A-1O3A-"
    .ascii  "L3O3D-O4D-O3D-1O4D-O3D-1O4D-O3A-1O4FO3D-1O4D-"
    .ascii  "L3O3E-O4E-O3E-1O4E-O3E-1E-B-EB-"

    .ascii  "L3O2FO3FO2F1O3FO2F1O3FC1AO2F1O3F"
    .ascii  "L3O2A-O3A-O2A-1O3A-O2A-1O3A-E-1O4CO2A-1O3A-"
    .ascii  "L3O3D-O4D-O3D-1O4D-O3D-1O4D-O3A-1O4FO3D-1O4D-"
    .ascii  "L3O3E-O4E-O3E-1O4E-O3E-1O4E-O3B-1O4GO3E-1O4E-"
    .ascii  "L3O3FO4CO3F1O4CO3F1O4CO3F1O4FO3F1O4C"
    .ascii  "L3O2A-O3A-O2A-1O3A-O2A-1O3A-E-1O4CO2A-1O3A-"
    .ascii  "L3O3D-O4D-O3D-1O4D-O3D-1O4D-O3A-1O4FO3D-1O4D-"
    .ascii  "L3O3E-O4E-O3E-1O4E-O3E-1E-B-EB-"

    .ascii  "L3O2FO3FO2F1O3FO2F1O3FC1AO2F1O3F"
    .ascii  "L3O2A-O3A-O2A-1O3A-O2A-1O3A-E-1O4CO2A-1O3A-"
    .ascii  "L3O3D-O4D-O3D-1O4D-O3D-1O4D-O3A-1O4FO3D-1O4D-"
    .ascii  "L3O3E-O4E-O3E-1O4E-O3E-1O4E-O3B-1O4GO3E-1O4E-"
    .ascii  "L3O3FO4CO3F1O4CO3F1O4CO3F1O4FO3F1O4C"
    .ascii  "L3O2A-O3A-O2A-1O3A-O2A-1O3A-E-1O4CO2A-1O3A-"
    .ascii  "L3O3D-O4D-O3D-1O4D-O3D-1O4D-O3A-1O4FO3D-1O4D-"
    .ascii  "L3O3E-O4E-O3E-1O4E-O3E-1E-B-EB-"

    .ascii  "L1R"
    .db     0x00

soundMuscleC:

    .ascii  "T3@0V15,2"
    .ascii  "L3O1FO3CO2F1O3CO2F1O3CC1F-O2F1O3C"
    .ascii  "L3O1A-O3E-O2A-1O3E-O2A-1O3E-E-1A-O2A-1O3E-"
    .ascii  "L3O2D-O3A-D-1A-D-1A-A-1O4D-O3D-1A-"
    .ascii  "L3O2E-O3B-E-1B-E-1B-B-1O4E-O3E-1B-"
    .ascii  "L3O2F-O3A-F1A-F1A-F1O4CO3F1A-"
    .ascii  "L3O1A-O3E-O2A-1O3E-O2A-1O3E-E-1A-O2A-1O3E-"
    .ascii  "L3O2D-O3A-O3D-1A-D-1A-A-1O4D-O3D-1A-"
    .ascii  "L3O2E-O3B-E-1B-E-1O2E-O3GO2EO3G"

    .ascii  "L3O1FO3CO2F1O3CO2F1O3CC1F-O2F1O3C"
    .ascii  "L3O1A-O3E-O2A-1O3E-O2A-1O3E-E-1A-O2A-1O3E-"
    .ascii  "L3O2D-O3A-D-1A-D-1A-A-1O4D-O3D-1A-"
    .ascii  "L3O2E-O3B-E-1B-E-1B-B-1O4E-O3E-1B-"
    .ascii  "L3O2F-O3A-F1A-F1A-F1O4CO3F1A-"
    .ascii  "L3O1A-O3E-O2A-1O3E-O2A-1O3E-E-1A-O2A-1O3E-"
    .ascii  "L3O2D-O3A-O3D-1A-D-1A-A-1O4D-O3D-1A-"
    .ascii  "L3O2E-O3B-E-1B-E-1O2E-O3GO2EO3G"

    .ascii  "L3O1FO3CO2F1O3CO2F1O3CC1F-O2F1O3C"
    .ascii  "L3O1A-O3E-O2A-1O3E-O2A-1O3E-E-1A-O2A-1O3E-"
    .ascii  "L3O2D-O3A-D-1A-D-1A-A-1O4D-O3D-1A-"
    .ascii  "L3O2E-O3B-E-1B-E-1B-B-1O4E-O3E-1B-"
    .ascii  "L3O2F-O3A-F1A-F1A-F1O4CO3F1A-"
    .ascii  "L3O1A-O3E-O2A-1O3E-O2A-1O3E-E-1A-O2A-1O3E-"
    .ascii  "L3O2D-O3A-O3D-1A-D-1A-A-1O4D-O3D-1A-"
    .ascii  "L3O2E-O3B-E-1B-E-1O2E-O3GO2EO3G"

    .ascii  "L1R"
    .db     0x00

; SE
;
soundSe:

    .dw     soundNull
    .dw     soundSeBoot
    .dw     soundSeClick

; ブート
soundSeBoot:

    .ascii  "T2@0V15L3O6BO5BR9"
    .db     0x00

; クリック
soundSeClick:

    .ascii  "T2@0V15O4B0"
    .db     0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;
