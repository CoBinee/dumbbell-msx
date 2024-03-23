; Game.inc : ゲーム
;


; マクロの定義
;

; スプライト
GAME_SPRITE_NULL                =   0x00
GAME_SPRITE_PLAYER_CORE         =   0x00
GAME_SPRITE_PLAYER_EDGE         =   0x78
GAME_SPRITE_MASTER_CORE         =   0x14
GAME_SPRITE_MASTER_EDGE         =   0x7c
GAME_SPRITE_MASTER_MASK_0       =   0x04
GAME_SPRITE_MASTER_MASK_1       =   0x08
GAME_SPRITE_MASTER_MASK_2       =   0x0c
GAME_SPRITE_MASTER_MASK_3       =   0x10
GAME_SPRITE_ENEMY               =   0x20
GAME_SPRITE_CLOCK               =   0x74
GAME_SPRITE_RESULT              =   0x00

; ゲーム
GAME_STATE                      =   0x00
GAME_FLAG                       =   0x01
GAME_TIMER_L                    =   0x02
GAME_TIMER_H                    =   0x03
GAME_DUMBBELL_COUNT             =   0x04
GAME_DUMBBELL_SCORE             =   0x05
GAME_CHIKUWA_COUNT              =   0x06
GAME_CHIKUWA_SCORE              =   0x07
GAME_SCORE_L                    =   0x08
GAME_SCORE_H                    =   0x09
GAME_FRAME                      =   0x0a
GAME_LENGTH                     =   0x0b

; 状態
GAME_STATE_NULL                 =   0x00
GAME_STATE_PLAY                 =   0x10
GAME_STATE_RESULT               =   0x20

; フラグ
GAME_FLAG_NULL                  =   0x00
GAME_FLAG_COUNTDOWN             =   0x00
GAME_FLAG_COUNTDOWN_BIT         =   (1 << GAME_FLAG_COUNTDOWN)

; タイマ
GAME_TIMER_NULL                 =   0x00
GAME_TIMER_LENGTH               =   (8 * 240)

; ダンベル
GAME_DUMBBELL_NULL              =   0x00

; ちくわ
GAME_CHIKUWA_NULL               =   0x00

; スコア
GAME_SCORE_NULL                 =   0x00

; フレーム
GAME_FRAME_NULL                 =   0x00

; 外部関数宣言
;

    .globl  _GameInitialize
    .globl  _GameUpdate

; 外部変数宣言
;

    .globl  _game
