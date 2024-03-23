; Clock.s : 時計
;


; モジュール宣言
;
    .module Clock

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "App.inc"
    .include    "Sound.inc"
    .include    "Game.inc"
    .include	"Clock.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; 時計を初期化する
;
_ClockInitialize::
    
    ; レジスタの保存
    
    ; 時計の初期化
    ld      hl, #clockDefault
    ld      de, #_clock
    ld      bc, #CLOCK_LENGTH
    ldir

    ; レジスタの復帰
    
    ; 終了
    ret

; 時計を更新する
;
_ClockUpdate::
    
    ; レジスタの保存

    ; 位置の更新
    ld      hl, (_game + GAME_TIMER_L)
    srl     h
    rr      l
    srl     h
    rr      l
    srl     h
    rr      l
    ld      a, l
    add     a, #0x08
    ld      (_clock + CLOCK_POSITION_X), a

    ; アニメーションの更新
    ld      hl, #(_clock + CLOCK_ANIMATION)
    inc     (hl)

    ; スプライトの設定
;   ld      hl, #(_clock + CLOCK_ANIMATION)
    ld      a, (hl)
    and     #0x04
    ld      e, a
    ld      d, #0x00
    ld      hl, #clockSprite
    add     hl, de
    ld      (_clock + CLOCK_SPRITE_L), hl

    ; レジスタの復帰
    
    ; 終了
    ret

; 時計を描画する
;
_ClockRender::

    ; レジスタの保存

    ; スプライトの描画
    ld      hl, (_clock + CLOCK_SPRITE_L)
    ld      de, #(_sprite + GAME_SPRITE_CLOCK)
    ld      a, (_clock + CLOCK_POSITION_Y)
    add     a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (_clock + CLOCK_POSITION_X)
    ld      c, #0x00
    cp      #0x80
    jr      nc, 10$
    add     a, #0x20
    ld      c, #0x80
10$:
    add     a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    or      c
    ld      (de), a
;   inc     hl
;   inc     de

    ; レジスタの復帰

    ; 終了
    ret

; 何もしない
;
ClockNull:

    ; レジスタの保存

    ; ix < 時計

    ; レジスタの復帰

    ; 終了
    ret

; 時計が投げられる
;
ClockThrow:

    ; レジスタの保存

    ; ix < 時計

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; 種類別の初期値
;
clockDefault:

    .db     CLOCK_STATE_NULL
    .db     CLOCK_FLAG_NULL
    .db     0xf8 ; CLOCK_POSITION_NULL
    .db     0x18 ; CLOCK_POSITION_NULL
    .db     CLOCK_ANIMATION_NULL
    .dw     CLOCK_SPRITE_NULL

; スプライト
;
clockSprite:

    .db     -0x10 - 0x01, -0x10, 0x10, VDP_COLOR_WHITE
    .db     -0x10 - 0x01, -0x10, 0x14, VDP_COLOR_WHITE


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; 時計
;
_clock::
    
    .ds     CLOCK_LENGTH

