; Judge.s : 判定
;


; モジュール宣言
;
    .module Judge

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "App.inc"
    .include    "Sound.inc"
    .include	"Judge.inc"

; 外部変数宣言
;
    .globl      _patternTable
    .globl      _judge_0_PatternGenerator
    .globl      _judge_0_ColorTable
    .globl      _judge_1_PatternGenerator
    .globl      _judge_1_ColorTable

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; 判定を初期化する
;
_JudgeInitialize::
    
    ; レジスタの保存
    
    ; スプライトのクリア
    call    _SystemClearSprite
    
    ; SCREEN 2 の設定
    ld      hl, #_videoScreen2
    ld      de, #_videoRegister
    ld      bc, #0x0008
    ldir

     ; パターンジェネレータの転送
    ld      hl, #(_patternTable + 0x0800)
    ld      de, #(APP_PATTERN_GENERATOR_TABLE + 0x0000)
    ld      bc, #0x0800
    call    LDIRVM
;   ld      hl, #(_patternTable + 0x0800)
;   ld      de, #(APP_PATTERN_GENERATOR_TABLE + 0x0800)
;   ld      bc, #0x0800
;   call    LDIRVM
    ld      hl, #(_patternTable + 0x0800)
    ld      de, #(APP_PATTERN_GENERATOR_TABLE + 0x1000)
    ld      bc, #0x0800
    call    LDIRVM
    
    ; カラーテーブルの転送
    ld      hl, #(APP_COLOR_TABLE + 0x0000)
    ld      a, #0xfc
    ld      bc, #0x0800
    call    FILVRM
;   ld      hl, #(APP_COLOR_TABLE + 0x0800)
;   ld      a, #0xfc
;   ld      bc, #0x0800
;   call    FILVRM
    ld      hl, #(APP_COLOR_TABLE + 0x1000)
    ld      a, #0xfc
    ld      bc, #0x0800
    call    FILVRM

    ; 判定別の転送
    ld      a, (_app + APP_JUDGE)
    or      a
    jr      z, 11$
10$:
    ld      hl, #(_judge_0_PatternGenerator)
    ld      de, #(APP_PATTERN_GENERATOR_TABLE + 0x0800)
    ld      bc, #0x0400
    call    LDIRVM
    ld      hl, #(_judge_0_ColorTable)
    ld      de, #(APP_COLOR_TABLE + 0x0800)
    ld      bc, #0x0400
    call    LDIRVM
    jr      19$
11$:
    ld      hl, #(_judge_1_PatternGenerator)
    ld      de, #(APP_PATTERN_GENERATOR_TABLE + 0x0800)
    ld      bc, #0x0400
    call    LDIRVM
    ld      hl, #(_judge_1_ColorTable)
    ld      de, #(APP_COLOR_TABLE + 0x0800)
    ld      bc, #0x0400
    call    LDIRVM
;   jr      19$
19$:

    ; パターンネームのクリア
    xor     a
    call    _SystemClearPatternName

    ; 判定の初期化
    ld      hl, #judgeDefault
    ld      de, #_judge
    ld      bc, #JUDGE_LENGTH
    ldir

    ; 描画の開始
    ld      hl, #(_videoRegister + VDP_R1)
    set     #VDP_R1_BL, (hl)

    ; 状態の設定
    ld      a, #JUDGE_STATE_NULL
    ld      (_judge + JUDGE_STATE), a
    ld      a, #APP_STATE_JUDGE_UPDATE
    ld      (_app + APP_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 判定を更新する
;
_JudgeUpdate::
    
    ; レジスタの保存

    ; 初期化
    ld      a, (_judge + JUDGE_STATE)
    and     #0x0f
    jr      nz, 09$

    ; 画面の描画
    call    JudgePrint

    ; 状態の更新
    ld      hl, #(_judge + JUDGE_STATE)
    inc     (hl)
09$:
    
    ; スプライトのクリア
    call    _SystemClearSprite

    ; SPACE キーの押下
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 19$

    ; SE の再生
    ld      a, #SOUND_SE_CLICK
    call    _SoundPlaySe

    ; 描画の停止
    ld      hl, #(_videoRegister + VDP_R1)
    res     #VDP_R1_BL, (hl)

    ; 状態の更新
    ld      a, #APP_STATE_TITLE_INITIALIZE
    ld      (_app + APP_STATE), a
19$:

    ; レジスタの復帰
    
    ; 終了
    ret

; 判定画面を描画する
;
JudgePrint:

    ; レジスタの保存

    ; パターンネームの設定
    ld      hl, #(_patternName + 0x0108)
    ld      de, #0x0010
    xor     a
    ld      c, #0x08
10$:
    ld      b, #0x10
11$:
    ld      (hl), a
    inc     hl
    inc     a
    djnz    11$
    add     hl, de
    dec     c
    jr      nz, 10$

    ; 文字列の描画
    ld      a, (_app + APP_JUDGE)
    add     a, a
    add     a, a
    add     a, a
    add     a, a
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      hl, #judgeString
    add     hl, de
    ld      de, #(_patternName + 0x0012 * 0x0020)
    ld      b, #0x20
20$:
    ld      a, (hl)
    sub     #0x20
    ld      (de), a
    inc     hl
    inc     de
    djnz    20$

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; 判定の初期値
;
judgeDefault:

    .db     JUDGE_STATE_NULL
    .db     JUDGE_FLAG_NULL
    .db     JUDGE_FRAME_NULL

; 文字列
;
judgeString:

    .ascii  "       YOU GOTTA WORK OUT       "
    .ascii  "          NICE MUSCLE!          "


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; 判定
;
_judge::
    
    .ds     JUDGE_LENGTH
