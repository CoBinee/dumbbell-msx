; Back.s : 背景
;


; モジュール宣言
;
    .module Back

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "App.inc"
    .include    "Game.inc"
    .include	"Back.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; 背景を初期化する
;
_BackInitialize::
    
    ; レジスタの保存
    
    ; 背景の初期化
    ld      hl, #backDefault
    ld      de, #_back
    ld      bc, #BACK_LENGTH
    ldir

    ; パターンネームの転送
    ld      hl, #backPatternName
    ld      de, #_patternName
    ld      bc, #0x0300
    ldir

    ; 状態の設定
    ld      a, #BACK_STATE_NULL
    ld      (_back + BACK_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 背景を更新する
;
_BackUpdate::
    
    ; レジスタの保存

    ; レジスタの復帰
    
    ; 終了
    ret

; 背景を描画する
;
_BackRender::

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; 背景の初期値
;
backDefault:

    .db     BACK_STATE_NULL
    .db     BACK_FLAG_NULL

; パターンネーム
;
backPatternName:

    .db     0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x49, 0x49, 0x49, 0x49, 0x49, 0x49, 0x49, 0x49, 0x49
    .db     0x49, 0x49, 0x49, 0x49, 0x49, 0x49, 0x49, 0x49, 0x49, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50
    .db     0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x49, 0x49, 0x49, 0x49, 0x49, 0x49, 0x49, 0x49, 0x49
    .db     0x49, 0x49, 0x49, 0x49, 0x49, 0x49, 0x49, 0x49, 0x49, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50
    .db     0x50, 0x61, 0x59, 0x5a, 0x51, 0x50, 0x50, 0x50, 0x50, 0x50, 0x4a, 0x42, 0x50, 0x42, 0x4b, 0x4b
    .db     0x4b, 0x4b, 0x42, 0x50, 0x4a, 0x42, 0x50, 0x50, 0x50, 0x50, 0x50, 0x69, 0x59, 0x5a, 0x51, 0x50
    .db     0x50, 0x62, 0x5f, 0x5f, 0x52, 0x50, 0x50, 0x50, 0x50, 0x50, 0x4a, 0x42, 0x50, 0x42, 0x4b, 0x4b
    .db     0x4b, 0x4b, 0x42, 0x50, 0x4a, 0x42, 0x50, 0x50, 0x50, 0x50, 0x69, 0x6a, 0x5f, 0x5f, 0x52, 0x50
    .db     0x63, 0x67, 0x5f, 0x5f, 0x57, 0x53, 0x50, 0x50, 0x50, 0x49, 0x4a, 0x42, 0x49, 0x49, 0x49, 0x49
    .db     0x49, 0x49, 0x49, 0x49, 0x4a, 0x42, 0x49, 0x50, 0x50, 0x50, 0x6b, 0x67, 0x5f, 0x5f, 0x57, 0x53
    .db     0x64, 0x67, 0x5f, 0x5f, 0x57, 0x54, 0x50, 0x50, 0x50, 0x49, 0x4a, 0x42, 0x49, 0x49, 0x49, 0x49
    .db     0x49, 0x49, 0x49, 0x49, 0x4a, 0x42, 0x49, 0x50, 0x50, 0x50, 0x6c, 0x67, 0x5f, 0x5f, 0x57, 0x55
    .db     0x65, 0x67, 0x5f, 0x5f, 0x57, 0x57, 0x53, 0x50, 0x50, 0x50, 0x4a, 0x42, 0x50, 0x50, 0x50, 0x50
    .db     0x50, 0x50, 0x50, 0x50, 0x4a, 0x42, 0x50, 0x50, 0x50, 0x6d, 0x67, 0x67, 0x5f, 0x5f, 0x57, 0x53
    .db     0x66, 0x67, 0x5f, 0x5f, 0x57, 0x57, 0x55, 0x50, 0x50, 0x50, 0x4a, 0x42, 0x50, 0x50, 0x50, 0x50
    .db     0x50, 0x50, 0x50, 0x50, 0x4a, 0x42, 0x50, 0x50, 0x50, 0x6e, 0x67, 0x67, 0x5f, 0x5f, 0x57, 0x55
    .db     0x64, 0x67, 0x5f, 0x5f, 0x57, 0x57, 0x53, 0x50, 0x50, 0x50, 0x4a, 0x42, 0x50, 0x50, 0x50, 0x50
    .db     0x50, 0x50, 0x50, 0x50, 0x4a, 0x42, 0x50, 0x50, 0x50, 0x50, 0x64, 0x67, 0x5f, 0x5f, 0x57, 0x53
    .db     0x64, 0x67, 0x5f, 0x5f, 0x57, 0x57, 0x55, 0x50, 0x50, 0x50, 0x4a, 0x42, 0x50, 0x50, 0x50, 0x50
    .db     0x50, 0x50, 0x50, 0x50, 0x4a, 0x42, 0x50, 0x50, 0x50, 0x50, 0x64, 0x67, 0x5f, 0x5f, 0x57, 0x55
    .db     0x50, 0x64, 0x4a, 0x42, 0x57, 0x56, 0x50, 0x50, 0x50, 0x50, 0x4a, 0x42, 0x50, 0x50, 0x50, 0x50
    .db     0x50, 0x50, 0x50, 0x50, 0x4a, 0x42, 0x50, 0x50, 0x50, 0x50, 0x50, 0x64, 0x4a, 0x42, 0x56, 0x50
    .db     0x50, 0x50, 0x4a, 0x42, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x4a, 0x42, 0x50, 0x50, 0x50, 0x50
    .db     0x50, 0x50, 0x50, 0x50, 0x4a, 0x42, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x4a, 0x42, 0x50, 0x50
    .db     0x50, 0x50, 0x4a, 0x42, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x4a, 0x42, 0x50, 0x50, 0x78, 0x78
    .db     0x78, 0x78, 0x50, 0x50, 0x4a, 0x42, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x4a, 0x42, 0x50, 0x50
    .db     0x50, 0x50, 0x4a, 0x42, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x4a, 0x42, 0x78, 0x78, 0x78, 0x78
    .db     0x78, 0x78, 0x78, 0x78, 0x4a, 0x42, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x4a, 0x42, 0x50, 0x50
    .db     0x6f, 0x6f, 0x67, 0x67, 0x6f, 0x6f, 0x6f, 0x6f, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79
    .db     0x79, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79, 0x6f, 0x6f, 0x6f, 0x6f, 0x67, 0x67, 0x6f, 0x6f
    .db     0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79
    .db     0x79, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67
    .db     0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67
    .db     0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67
    .db     0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67
    .db     0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67
    .db     0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67
    .db     0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67
    .db     0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67
    .db     0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67, 0x67
    .db     0x71, 0x72, 0x71, 0x72, 0x71, 0x72, 0x71, 0x72, 0x71, 0x72, 0x71, 0x72, 0x71, 0x72, 0x71, 0x72
    .db     0x71, 0x72, 0x71, 0x72, 0x71, 0x72, 0x71, 0x72, 0x71, 0x72, 0x71, 0x72, 0x71, 0x72, 0x71, 0x72
    .db     0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57
    .db     0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57
    .db     0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57
    .db     0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57
    .db     0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57
    .db     0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57

; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; 背景
;
_back::
    
    .ds     BACK_LENGTH

