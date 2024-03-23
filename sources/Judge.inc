; Judge.inc : 判定
;


; マクロの定義
;

; スプライト
JUDGE_SPRITE_NULL               =   0x00

; 判定
JUDGE_STATE                     =   0x00
JUDGE_FLAG                      =   0x01
JUDGE_FRAME                     =   0x02
JUDGE_LENGTH                    =   0x03

; 状態
JUDGE_STATE_NULL                =   0x00

; フラグ
JUDGE_FLAG_NULL                 =   0x00

; フレーム
JUDGE_FRAME_NULL                =   0x00

; 外部関数宣言
;

    .globl  _JudgeInitialize
    .globl  _JudgeUpdate

; 外部変数宣言
;

    .globl  _judge
