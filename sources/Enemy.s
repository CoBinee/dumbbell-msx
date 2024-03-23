; Enemy.s : エネミー
;


; モジュール宣言
;
    .module Enemy

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "App.inc"
    .include    "Sound.inc"
    .include    "Game.inc"
    .include    "Player.inc"
    .include	"Enemy.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; エネミーを初期化する
;
_EnemyInitialize::
    
    ; レジスタの保存
    
    ; エネミーの初期化
    ld      hl, #(_enemy + 0x0000)
    ld      de, #(_enemy + 0x0001)
    ld      bc, #(ENEMY_ENTRY * ENEMY_LENGTH - 0x0001)
    ld      (hl), #0x00
    ldir

    ; スプライトの初期化
    ld      de, #0x0000
    ld      (enemySpriteRotate), de

    ; レジスタの復帰
    
    ; 終了
    ret

; エネミーを更新する
;
_EnemyUpdate::
    
    ; レジスタの保存

    ; エネミーの生成
10$:
    ld      a, (_game + GAME_FLAG)
    bit     #GAME_FLAG_COUNTDOWN, a
    jr      z, 19$
    ld      hl, (_game + GAME_TIMER_L)
    ld      a, h
    or      l
    jr      z, 19$
    ld      a, l
    and     #0x07
    jr      nz, 19$
    ld      ix, #_enemy
    ld      de, #ENEMY_LENGTH
    ld      b, #ENEMY_ENTRY
11$:
    ld      a, ENEMY_TYPE(ix)
    or      a
    jr      z, 12$
    add     ix, de
    djnz    11$
    jr      19$
12$:
    call    _SystemGetRandom
    and     #0x01
    inc     a
    ld      ENEMY_TYPE(ix), a
    ld      ENEMY_POSITION_X_L(ix), #0x00
    ld      ENEMY_POSITION_X_H(ix), #0x80
    ld      ENEMY_POSITION_Y_L(ix), #0x00
    ld      ENEMY_POSITION_Y_H(ix), #0x40
    call    _SystemGetRandom
    ld      h, #0x00
    add     a, a
    rl      h
    ld      ENEMY_SPEED_X_L(ix), a
    ld      ENEMY_SPEED_X_H(ix), h
    call    _SystemGetRandom
    and     #ENEMY_FLAG_RIGHT_BIT
    ld      ENEMY_FLAG(ix), a
    call    _SystemGetRandom
    ld      h, #0x00
    add     a, a
    rl      h
    inc     h
    inc     h
    cpl
    ld      l, a
    ld      a, h
    cpl
    ld      h, a
    inc     hl
    ld      ENEMY_SPEED_Y_L(ix), l
    ld      ENEMY_SPEED_Y_H(ix), h
19$:

    ; エネミーの行動

    ; エネミーの走査
    ld      ix, #_enemy
    ld      b, #ENEMY_ENTRY
200$:
    push    bc

    ; エネミーの存在
    ld      a, ENEMY_TYPE(ix)
    or      a
    jr      z, 290$

    ; X 移動
210$:
    ld      e, ENEMY_SPEED_X_L(ix)
    ld      d, ENEMY_SPEED_X_H(ix)
    ld      l, ENEMY_POSITION_X_L(ix)
    ld      h, ENEMY_POSITION_X_H(ix)
    bit     #ENEMY_FLAG_RIGHT, ENEMY_FLAG(ix)
    jr      nz, 211$
    or      a
    sbc     hl, de
    jr      c, 280$
    jr      219$
211$:
    or      a
    adc     hl, de
    jr      c, 280$
;   jr      219$
219$:
    ld      ENEMY_POSITION_X_L(ix), l
    ld      ENEMY_POSITION_X_H(ix), h

    ; Y 移動
220$:
    ld      l, ENEMY_SPEED_Y_L(ix)
    ld      h, ENEMY_SPEED_Y_H(ix)
    ld      de, #0x0020
    add     hl, de
    ld      ENEMY_SPEED_Y_L(ix), l
    ld      ENEMY_SPEED_Y_H(ix), h
    ld      e, ENEMY_POSITION_Y_L(ix)
    ld      d, ENEMY_POSITION_Y_H(ix)
    add     hl, de
    ld      ENEMY_POSITION_Y_L(ix), l
    ld      ENEMY_POSITION_Y_H(ix), h
    ld      a, h
    cp      #0xc0
    jr      nc, 280$

    ; 当たり判定
230$:
    ld      a, (_player + PLAYER_POSITION_X_H)
    sub     ENEMY_POSITION_X_H(ix)
    cp      #(0x10 + 0x01)
    jr      c, 231$
    cp      #-0x10
    jr      c, 290$
231$:
    ld      a, (_player + PLAYER_POSITION_Y_H)
    sub     ENEMY_POSITION_Y_H(ix)
    cp      #(0x08 + 0x01)
    jr      c, 232$
    cp      #-0x08
    jr      c, 290$
232$:
    ld      a, ENEMY_TYPE(ix)
    cp      #ENEMY_TYPE_DUMBBELL
    jr      nz, 233$
    ld      hl, #(_game + GAME_DUMBBELL_COUNT)
    inc     (hl)
    jr      239$
233$:
    ld      hl, #(_game + GAME_CHIKUWA_COUNT)
    inc     (hl)
;   jr      239$
239$:
;   jr      280$

    ; 画面外
280$:
    ld      ENEMY_TYPE(ix), #ENEMY_TYPE_NULL
;   jr      290$

    ; 次のエネミーへ
290$:
    ld      bc, #ENEMY_LENGTH
    add     ix, bc
    pop     bc
    dec     b
    jp      nz, 200$

    ; レジスタの復帰
    
    ; 終了
    ret

; エネミーを描画する
;
_EnemyRender::

    ; レジスタの保存

    ; エネミーの走査
    ld      ix, #_enemy
    ld      de, (enemySpriteRotate)
    ld      b, #ENEMY_ENTRY
10$:
    push    bc

    ; エネミーの存在
    ld      a, ENEMY_TYPE(ix)
    or      a
    jr      z, 19$

    ; スプライトの描画
    push    de
    ld      hl, #(_sprite + GAME_SPRITE_ENEMY)
    add     hl, de
    ex      de, hl
    add     a, a
    add     a, a
    ld      c, a
    ld      b, #0x00
    ld      hl, #enemySprite
    add     hl, bc
    ld      a, ENEMY_POSITION_Y_H(ix)
    add     a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, ENEMY_POSITION_X_H(ix)
    ld      c, #0x00
    cp      #0x80
    jr      nc, 11$
    add     a, #0x20
    ld      c, #0x80
11$:
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
    pop     de

    ; スプライトの更新
    ld      a, e
    add     a, #0x04
    cp      #(0x04 * ENEMY_ENTRY)
    jr      c, 18$
    xor     a
18$:
    ld      e, a

    ; 次のエネミーへ
19$:
    ld      bc, #ENEMY_LENGTH
    add     ix, bc
    pop     bc
    djnz    10$

    ;  スプライトの更新
    ld      hl, #(enemySpriteRotate)
    ld      a, (hl)
    add     a, #0x04
    cp      #(0x04 * ENEMY_ENTRY)
    jr      c, 20$
    xor     a
20$:
    ld      (hl), a

    ; レジスタの復帰

    ; 終了
    ret

; 何もしない
;
EnemyNull:

    ; レジスタの保存

    ; ix < エネミー

    ; レジスタの復帰

    ; 終了
    ret

; エネミーが投げられる
;
EnemyThrow:

    ; レジスタの保存

    ; ix < エネミー

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; 種類別の初期値
;
enemyDefault:

    .dw     enemyNullDefault

enemyNullDefault:

    .db     ENEMY_TYPE_NULL
    .db     ENEMY_STATE_NULL
    .db     ENEMY_FLAG_NULL
    .dw     ENEMY_POSITION_NULL
    .dw     ENEMY_POSITION_NULL
    .dw     ENEMY_SPEED_NULL
    .dw     ENEMY_SPEED_NULL

; スプライト
;
enemySprite:

    .db     -0x10 - 0x01, -0x10, 0x00, VDP_COLOR_TRANSPARENT
    .db     -0x10 - 0x01, -0x10, 0x08, VDP_COLOR_BLACK
    .db     -0x10 - 0x01, -0x10, 0x0c, VDP_COLOR_DARK_YELLOW


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; エネミー
;
_enemy::
    
    .ds     ENEMY_ENTRY * ENEMY_LENGTH

; スプライト
;
enemySpriteRotate:

    .ds     0x02

