; Clock.inc : 時計
;


; マクロの定義
;

; 時計
CLOCK_STATE                     =   0x00
CLOCK_FLAG                      =   0x01
CLOCK_POSITION_X                =   0x02
CLOCK_POSITION_Y                =   0x03
CLOCK_ANIMATION                 =   0x04
CLOCK_SPRITE_L                  =   0x05
CLOCK_SPRITE_H                  =   0x06
CLOCK_LENGTH                    =   0x07

; 状態
CLOCK_STATE_NULL                =   0x00

; フラグ
CLOCK_FLAG_NULL                 =   0x00

; 位置
CLOCK_POSITION_NULL             =   0x00

; アニメーション
CLOCK_ANIMATION_NULL            =   0x00

; スプライト
CLOCK_SPRITE_NULL               =   0x00

; 外部関数宣言
;

    .globl  _ClockInitialize
    .globl  _ClockUpdate
    .globl  _ClockRender

; 外部変数宣言
;

    .globl  _clock
