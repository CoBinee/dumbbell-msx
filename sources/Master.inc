; Master.inc : マスター
;


; マクロの定義
;

; マスター
MASTER_STATE                    =   0x00
MASTER_FLAG                     =   0x01
MASTER_POSITION_X               =   0x02
MASTER_POSITION_Y               =   0x03
MASTER_FRAME                    =   0x04
MASTER_ANIMATION                =   0x05
MASTER_SPRITE_L                 =   0x06
MASTER_SPRITE_H                 =   0x07
MASTER_LENGTH                   =   0x08

; 状態
MASTER_STATE_NULL               =   0x00
MASTER_STATE_IN                 =   0x10
MASTER_STATE_POSE               =   0x20
MASTER_STATE_STAY               =   0x30

; フラグ
MASTER_FLAG_NULL                =   0x00
MASTER_FLAG_MASK                =   0x00
MASTER_FLAG_MASK_BIT            =   (1 << MASTER_FLAG_MASK)

; 位置
MASTER_POSITION_NULL            =   0x00

; フレーム
MASTER_FRAME_NULL               =   0x00

; アニメーション
MASTER_ANIMATION_NULL           =   0x00

; スプライト
MASTER_SPRITE_NULL              =   0x00

; 外部関数宣言
;

    .globl  _MasterInitialize
    .globl  _MasterUpdate
    .globl  _MasterRender

; 外部変数宣言
;

    .globl  _master
