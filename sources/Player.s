; Player.s : プレイヤ
;


; モジュール宣言
;
    .module Player

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "App.inc"
    .include    "Sound.inc"
    .include    "Game.inc"
    .include	"Player.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; プレイヤを初期化する
;
_PlayerInitialize::
    
    ; レジスタの保存
    
    ; プレイヤの初期化
    ld      hl, #playerDefault
    ld      de, #_player
    ld      bc, #PLAYER_LENGTH
    ldir

    ; 状態の設定
    ld      a, #PLAYER_STATE_PLAY
    ld      (_player + PLAYER_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; プレイヤを更新する
;
_PlayerUpdate::
    
    ; レジスタの保存

    ; 状態別の処理
    ld      hl, #10$
    push    hl
    ld      a, (_player + PLAYER_STATE)
    and     #0xf0
    rrca
    rrca
    rrca
    ld      e, a
    ld      d, #0x00
    ld      hl, #playerProc
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ex      de, hl
    jp      (hl)
;   pop     hl
10$:

    ; レジスタの復帰
    
    ; 終了
    ret

; プレイヤを描画する
;
_PlayerRender::

    ; レジスタの保存

    ld      hl, (_player + PLAYER_SPRITE_L)

    ; コアの描画
    ld      de, #(_sprite + GAME_SPRITE_PLAYER_CORE)
    ld      a, (_player + PLAYER_POSITION_Y_H)
    add     a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (_player + PLAYER_POSITION_X_H)
    add     a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
;   inc     de

    ; エッジの描画
    ld      de, #(_sprite + GAME_SPRITE_PLAYER_EDGE)
    ld      a, (_player + PLAYER_POSITION_Y_H)
    add     a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (_player + PLAYER_POSITION_X_H)
    add     a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
;   inc     de

    ; レジスタの復帰

    ; 終了
    ret

; 何もしない
;
PlayerNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; プレイヤを操作する
;
PlayerPlay:

    ; レジスタの保存

    ; 初期化
    ld      a, (_player + PLAYER_STATE)
    and     #0x0f
    jr      nz, 09$

    ; 初期化の完了
    ld      hl, #(_player + PLAYER_STATE)
    inc     (hl)
09$:

    ; ←へ歩く
100$:
    ld      a, (_input + INPUT_KEY_LEFT)
    or      a
    jr      z, 110$
    ld      hl, (_player + PLAYER_SPEED_X_L)
    ld      de, #PLAYER_SPEED_ACCEL
    or      a
    sbc     hl, de
    jp      p, 101$
    ld      a, h
    cp      #-PLAYER_SPEED_MAXIMUM
    jr      nc, 101$
    ld      hl, #-(PLAYER_SPEED_MAXIMUM << 8)
101$:
    ld      a, #PLAYER_DIRECTION_LEFT
    ld      (_player + PLAYER_DIRECTION), a
    jr      130$

    ; →へ歩く
110$:
    ld      a, (_input + INPUT_KEY_RIGHT)
    or      a
    jr      z, 120$
    ld      hl, (_player + PLAYER_SPEED_X_L)
    ld      de, #PLAYER_SPEED_ACCEL
    or      a
    adc     hl, de
    jp      m, 111$
    jr      z, 111$
    ld      a, h
    cp      #PLAYER_SPEED_MAXIMUM
    jr      c, 111$
    ld      hl, #(PLAYER_SPEED_MAXIMUM << 8)
111$:
    ld      a, #PLAYER_DIRECTION_RIGHT
    ld      (_player + PLAYER_DIRECTION), a
    jr      130$

    ; 停止
120$:
    ld      hl, (_player + PLAYER_SPEED_X_L)
    ld      de, #PLAYER_SPEED_BRAKE
    ld      a, h
    or      l
    jr      z, 190$
    ld      a, h
    or      h
    jp      p, 121$
;   or      a
    adc     hl, de
    jp      m, 130$
    ld      hl, #0x0000
    jr      130$
121$:
;   or      a
    sbc     hl, de
    jp      p, 130$
    ld      hl, #0x0000
;   jr      130$

    ; 位置の更新
130$:
    ld      (_player + PLAYER_SPEED_X_L), hl
    ld      de, (_player + PLAYER_POSITION_X_L)
    add     hl, de
    ld      a, h
    cp      #PLAYER_POSITION_LEFT
    jr      nc, 131$
    ld      hl, #(PLAYER_POSITION_LEFT << 8)
    jr      139$
131$:
    cp      #PLAYER_POSITION_RIGHT
    jr      c, 139$
    ld      hl, #(PLAYER_POSITION_RIGHT << 8)
;   jr      139$
139$:
    ld      (_player + PLAYER_POSITION_X_L), hl

    ; アニメーションの更新
    ld      hl, #(_player + PLAYER_ANIMATION)
    inc     (hl)

    ; 移動の完了
190$:

    ; スプライトの設定
    ld      a, (_player + PLAYER_DIRECTION)
    add     a, a
    add     a, a
    add     a, a
    add     a, a
    add     a, a
    ld      e, a
    ld      a, (_player + PLAYER_ANIMATION)
    and     #0x18
    add     a, e
    ld      e, a
    ld      d, #0x00
    ld      hl, #playerSprite
    add     hl, de
    ld      (_player + PLAYER_SPRITE_L), hl

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; 状態別の処理
;
playerProc:
    
    .dw     PlayerNull
    .dw     PlayerPlay

; プレイヤの初期値
;
playerDefault:

    .db     PLAYER_STATE_NULL
    .db     PLAYER_FLAG_NULL
    .dw     0x4000 ; PLAYER_POSITION_NULL
    .dw     0x9700 ; PLAYER_POSITION_NULL
    .dw     PLAYER_SPEED_NULL
    .dw     PLAYER_SPEED_NULL
    .db     PLAYER_DIRECTION_RIGHT
    .db     PLAYER_ANIMATION_NULL
    .dw     PLAYER_SPRITE_NULL

; スプライト
;
playerSprite:

    .db     -0x1f - 0x01, -0x10, 0x2c, VDP_COLOR_LIGHT_YELLOW   ; LEFT
    .db     -0x1f - 0x01, -0x10, 0x4c, VDP_COLOR_BLACK
    .db     -0x1f - 0x01, -0x10, 0x28, VDP_COLOR_LIGHT_YELLOW
    .db     -0x1f - 0x01, -0x10, 0x48, VDP_COLOR_BLACK
    .db     -0x1f - 0x01, -0x10, 0x2c, VDP_COLOR_LIGHT_YELLOW
    .db     -0x1f - 0x01, -0x10, 0x4c, VDP_COLOR_BLACK
    .db     -0x1f - 0x01, -0x10, 0x30, VDP_COLOR_LIGHT_YELLOW
    .db     -0x1f - 0x01, -0x10, 0x50, VDP_COLOR_BLACK
    .db     -0x1f - 0x01, -0x10, 0x38, VDP_COLOR_LIGHT_YELLOW   ; RIGHT
    .db     -0x1f - 0x01, -0x10, 0x58, VDP_COLOR_BLACK
    .db     -0x1f - 0x01, -0x10, 0x34, VDP_COLOR_LIGHT_YELLOW
    .db     -0x1f - 0x01, -0x10, 0x54, VDP_COLOR_BLACK
    .db     -0x1f - 0x01, -0x10, 0x38, VDP_COLOR_LIGHT_YELLOW
    .db     -0x1f - 0x01, -0x10, 0x58, VDP_COLOR_BLACK
    .db     -0x1f - 0x01, -0x10, 0x3c, VDP_COLOR_LIGHT_YELLOW
    .db     -0x1f - 0x01, -0x10, 0x5c, VDP_COLOR_BLACK


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; プレイヤ
;
_player::
    
    .ds     PLAYER_LENGTH

