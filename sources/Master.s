; Master.s : マスター
;


; モジュール宣言
;
    .module Master

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "App.inc"
    .include    "Sound.inc"
    .include    "Game.inc"
    .include	"Master.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; マスターを初期化する
;
_MasterInitialize::
    
    ; レジスタの保存
    
    ; マスターの初期化
    ld      hl, #masterDefault
    ld      de, #_master
    ld      bc, #MASTER_LENGTH
    ldir

    ; 状態の設定
    ld      a, #MASTER_STATE_IN
    ld      (_master + MASTER_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; マスターを更新する
;
_MasterUpdate::
    
    ; レジスタの保存

    ; 状態別の処理
    ld      hl, #10$
    push    hl
    ld      a, (_master + MASTER_STATE)
    and     #0xf0
    rrca
    rrca
    rrca
    ld      e, a
    ld      d, #0x00
    ld      hl, #masterProc
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ex      de, hl
    jp      (hl)
;   pop     hl
10$:

    ; スプライトの設定
    ld      a, (_master + MASTER_ANIMATION)
    and     #0xc0
    rrca
    rrca
    rrca
    ld      e, a
    ld      d, #0x00
    ld      hl, #masterSprite
    add     hl, de
    ld      (_master + MASTER_SPRITE_L), hl

    ; レジスタの復帰
    
    ; 終了
    ret

; マスターを描画する
;
_MasterRender::

    ; レジスタの保存

    ld      hl, (_master + MASTER_SPRITE_L)

    ; コアの描画
    ld      de, #(_sprite + GAME_SPRITE_MASTER_CORE)
    ld      a, (_master + MASTER_POSITION_Y)
    add     a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (_master + MASTER_POSITION_X)
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
    ld      de, #(_sprite + GAME_SPRITE_MASTER_EDGE)
    ld      a, (_master + MASTER_POSITION_Y)
    add     a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (_master + MASTER_POSITION_X)
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

    ; マスクの描画
    ld      a, (_master + MASTER_FLAG)
    bit     #MASTER_FLAG_MASK, a
    jr      z, 39$
    ld      hl, #masterSpriteMask
    ld      de, #(_sprite + GAME_SPRITE_MASTER_MASK_0)
    ld      bc, #0x0010
    ldir
39$:

    ; レジスタの復帰

    ; 終了
    ret

; 何もしない
;
MasterNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; マスターが登場する
;
MasterIn:

    ; レジスタの保存

    ; 初期化
    ld      a, (_master + MASTER_STATE)
    and     #0x0f
    jr      nz, 09$

    ; フラグの設定
    ld      hl, #(_master + MASTER_FLAG)
    set     #MASTER_FLAG_MASK, (hl)

    ; 初期化の完了
    ld      hl, #(_master + MASTER_STATE)
    inc     (hl)
09$:

    ; 移動
    ld      hl, #(_master + MASTER_FRAME)
    ld      a, (hl)
    or      a
    jr      z, 10$
    dec     (hl)
    jr      19$
10$:
    ld      (hl), #0x02
    ld      hl, #(_master + MASTER_POSITION_Y)
    dec     (hl)
    ld      a, (hl)
    cp      #(0x5f + 0x01)
    jr      nc, 19$

    ; 状態の更新
    ld      a, #MASTER_STATE_POSE
    ld      (_master + MASTER_STATE), a
19$:

    ; レジスタの復帰

    ; 終了
    ret

; マスターがポーズをとる
;
MasterPose:

    ; レジスタの保存

    ; 初期化
    ld      a, (_master + MASTER_STATE)
    and     #0x0f
    jr      nz, 09$

    ; フラグの設定
    ld      hl, #(_master + MASTER_FLAG)
    res     #MASTER_FLAG_MASK, (hl)

    ; ゲームの設定
    ld      hl, #(_game + GAME_FLAG)
    set     #GAME_FLAG_COUNTDOWN, (hl)

    ; 初期化の完了
    ld      hl, #(_master + MASTER_STATE)
    inc     (hl)
09$:

    ; アニメーションの更新
    ld      hl, #(_master + MASTER_ANIMATION)
    inc     (hl)

    ; タイムアップ
    ld      hl, (_game + GAME_TIMER_L)
    ld      a, h
    or      l
    jr      nz, 19$

    ; 状態の更新
    ld      a, #MASTER_STATE_STAY
    ld      (_master + MASTER_STATE), a
19$:

    ; レジスタの復帰

    ; 終了
    ret

; マスターが待機する
;
MasterStay:

    ; レジスタの保存

    ; 初期化
    ld      a, (_master + MASTER_STATE)
    and     #0x0f
    jr      nz, 09$

    ; アニメーションの設定
    xor     a
    ld      (_master + MASTER_ANIMATION), a

    ; 初期化の完了
    ld      hl, #(_master + MASTER_STATE)
    inc     (hl)
09$:

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; 状態別の処理
;
masterProc:
    
    .dw     MasterNull
    .dw     MasterIn
    .dw     MasterPose
    .dw     MasterStay

; マスターの初期値
;
masterDefault:

    .db     MASTER_STATE_NULL
    .db     MASTER_FLAG_NULL
    .db     0x80 ; MASTER_POSITION_NULL
    .db     0x7f ; MASTER_POSITION_NULL
    .db     MASTER_FRAME_NULL
    .db     MASTER_ANIMATION_NULL
    .dw     MASTER_SPRITE_NULL

; スプライト
;
masterSprite:

    .db     -0x1f - 0x01, -0x10, 0x60, VDP_COLOR_LIGHT_RED
    .db     -0x1f - 0x01, -0x10, 0x80, VDP_COLOR_BLACK
    .db     -0x1f - 0x01, -0x10, 0x64, VDP_COLOR_LIGHT_RED
    .db     -0x1f - 0x01, -0x10, 0x84, VDP_COLOR_BLACK
    .db     -0x1f - 0x01, -0x10, 0x68, VDP_COLOR_LIGHT_RED
    .db     -0x1f - 0x01, -0x10, 0x88, VDP_COLOR_BLACK
    .db     -0x1f - 0x01, -0x10, 0x6c, VDP_COLOR_LIGHT_RED
    .db     -0x1f - 0x01, -0x10, 0x8c, VDP_COLOR_BLACK

masterSpriteMask:

    .db     0x60 - 0x01, 0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db     0x60 - 0x01, 0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db     0x60 - 0x01, 0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db     0x60 - 0x01, 0x00, 0x00, VDP_COLOR_TRANSPARENT


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; マスター
;
_master::
    
    .ds     MASTER_LENGTH

