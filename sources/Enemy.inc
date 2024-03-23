; Enemy.inc : エネミー
;


; マクロの定義
;

; エネミー
ENEMY_TYPE                      =   0x00
ENEMY_STATE                     =   0x01
ENEMY_FLAG                      =   0x02
ENEMY_POSITION_X_L              =   0x03
ENEMY_POSITION_X_H              =   0x04
ENEMY_POSITION_Y_L              =   0x05
ENEMY_POSITION_Y_H              =   0x06
ENEMY_SPEED_X_L                 =   0x07
ENEMY_SPEED_X_H                 =   0x08
ENEMY_SPEED_Y_L                 =   0x09
ENEMY_SPEED_Y_H                 =   0x0a
ENEMY_LENGTH                    =   0x0b

; 種類
ENEMY_TYPE_NULL                 =   0x00
ENEMY_TYPE_DUMBBELL             =   0x01
ENEMY_TYPE_CHIKUWA              =   0x02

; 状態
ENEMY_STATE_NULL                =   0x00

; フラグ
ENEMY_FLAG_NULL                 =   0x00
ENEMY_FLAG_RIGHT                =   0x00
ENEMY_FLAG_RIGHT_BIT            =   (1 << ENEMY_FLAG_RIGHT)

; 位置
ENEMY_POSITION_NULL             =   0x00

; 速度
ENEMY_SPEED_NULL                =   0x00

; 登録
ENEMY_ENTRY                     =   0x10

; 外部関数宣言
;

    .globl  _EnemyInitialize
    .globl  _EnemyUpdate
    .globl  _EnemyRender

; 外部変数宣言
;

    .globl  _enemy
