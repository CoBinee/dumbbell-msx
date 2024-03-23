; Title.s : タイトル
;


; モジュール宣言
;
    .module Title

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "App.inc"
    .include    "Sound.inc"
    .include	"Title.inc"

; 外部変数宣言
;
    .globl      _patternTable

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; タイトルを初期化する
;
_TitleInitialize::
    
    ; レジスタの保存
    
    ; スプライトのクリア
    call    _SystemClearSprite
    
    ; SCREEN 1 の設定
    ld      hl, #_videoScreen1
    ld      de, #_videoRegister
    ld      bc, #0x0008
    ldir

     ; パターンジェネレータの転送
    ld      hl, #(_patternTable + 0x0800)
    ld      de, #(APP_PATTERN_GENERATOR_TABLE + 0x0000)
    ld      bc, #0x0800
    call    LDIRVM
    
    ; カラーテーブルの転送
    ld      hl, #(titleColorTable)
    ld      de, #(APP_COLOR_TABLE + 0x0000)
    ld      bc, #0x0020
    call    LDIRVM

    ; パターンネームのクリア
    xor     a
    call    _SystemClearPatternName

    ; タイトルの初期化
    ld      hl, #titleDefault
    ld      de, #_title
    ld      bc, #TITLE_LENGTH
    ldir

    ; 描画の開始
    ld      hl, #(_videoRegister + VDP_R1)
    set     #VDP_R1_BL, (hl)

    ; 状態の設定
    ld      a, #TITLE_STATE_NULL
    ld      (_title + TITLE_STATE), a
    ld      a, #APP_STATE_TITLE_UPDATE
    ld      (_app + APP_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; タイトルを更新する
;
_TitleUpdate::
    
    ; レジスタの保存

    ; 初期化
    ld      a, (_title + TITLE_STATE)
    and     #0x0f
    jr      nz, 09$

    ; ロゴの描画
    call    TitlePrintLogo

    ; 状態の更新
    ld      hl, #(_title + TITLE_STATE)
    inc     (hl)
09$:

    ; 0x01: 待機
    ld      a, (_title + TITLE_STATE)
    and     #0x0f
10$:
    dec     a
    jr      nz, 20$

    ; 点滅の更新
    ld      hl, #(_title + TITLE_BLINK)
    inc     (hl)
    
    ; SPACE キーの押下
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 19$

    ; フレームの設定
    ld      a, #0x60
    ld      (_title + TITLE_FRAME), a

    ; SE の再生
    ld      a, #SOUND_SE_BOOT
    call    _SoundPlaySe

    ; 状態の更新
    ld      hl, #(_title + TITLE_STATE)
    inc     (hl)
19$:
    jr      90$

    ; 0x02: 開始
20$:
    dec     a
    jr      nz, 90$

    ; 点滅の更新
    ld      hl, #(_title + TITLE_BLINK)
    ld      a, (hl)
    add     a, #0x08
    ld      (hl), a

    ; フレームの更新
    ld      hl, #(_title + TITLE_FRAME)
    dec     (hl)
    jr      nz, 29$
    
    ; 描画の停止
    ld      hl, #(_videoRegister + VDP_R1)
    res     #VDP_R1_BL, (hl)

    ; 状態の更新
    ld      a, #APP_STATE_GAME_INITIALIZE
    ld      (_app + APP_STATE), a
29$:
;   jr      90$

    ; 更新の完了
90$:

    ; HIT SPACE BAR の描画
    call    TitlePrintHitSpaceBar

    ; レジスタの復帰
    
    ; 終了
    ret

; ロゴを描画する
;
TitlePrintLogo:

    ; レジスタの保存

    ; ロゴの描画
    ld      hl, #(_patternName + 0x010b)
    ld      de, #0x0016
    ld      a, #0x80
    ld      c, #0x06
10$:
    ld      b, #0x0a
11$:
    ld      (hl), a
    inc     hl
    inc     a
    djnz    11$
    add     hl, de
    add     a, #0x06
    dec     c
    jr      nz, 10$

    ; 文字列の描画
    ld      hl, #titleString_0
    ld      de, #(_patternName + 0x006a)
    call    20$
    ld      hl, #titleString_1
    ld      de, #(_patternName + 0x00a4)
    call    20$
    jr      29$
20$:
    ld      a, (hl)
    or      a
    ret     z
    sub     #0x20
    ld      (de), a
    inc     hl
    inc     de
    jr      20$
29$:

    ; スプライトの描画
    ld      hl, #titleSprite
    ld      de, #(_sprite + TITLE_SPRITE_LOGO)
    ld      bc, #0x0004
    ldir

    ; レジスタの復帰

    ; 終了
    ret

; HIT SPACE BAR を描画する
;
TitlePrintHitSpaceBar:

    ; レジスタの保存

    ; HIT SPACE BAR の描画
    ld      a, (_title + TITLE_BLINK)
    and     #0x20
    rrca
    add     a, #0xe0
    ld      hl, #(_patternName + 0x0268)
    ld      b, #0x10
10$:
    ld      (hl), a
    inc     hl
    inc     a
    djnz    10$

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; タイトルの初期値
;
titleDefault:

    .db     TITLE_STATE_NULL
    .db     TITLE_FLAG_NULL
    .db     TITLE_FRAME_NULL
    .db     TITLE_BLINK_NULL

; カラーテーブル
;
titleColorTable:

    .db     (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_BLUE,    (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_BLUE
    .db     (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_BLUE,    (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_BLUE
    .db     (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_BLUE,    (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_BLUE
    .db     (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_BLUE,    (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_BLUE
    .db     (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_BLUE,    (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_BLUE
    .db     (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_BLUE,    (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_BLUE
    .db     (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_BLUE,    (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_BLUE
    .db     (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_BLUE,    (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_BLUE
    .db     (VDP_COLOR_LIGHT_GREEN  << 4) | VDP_COLOR_DARK_BLUE,    (VDP_COLOR_LIGHT_GREEN  << 4) | VDP_COLOR_DARK_BLUE
    .db     (VDP_COLOR_LIGHT_GREEN  << 4) | VDP_COLOR_DARK_BLUE,    (VDP_COLOR_LIGHT_GREEN  << 4) | VDP_COLOR_DARK_BLUE
    .db     (VDP_COLOR_LIGHT_GREEN  << 4) | VDP_COLOR_DARK_BLUE,    (VDP_COLOR_LIGHT_GREEN  << 4) | VDP_COLOR_DARK_BLUE
    .db     (VDP_COLOR_LIGHT_GREEN  << 4) | VDP_COLOR_DARK_BLUE,    (VDP_COLOR_LIGHT_GREEN  << 4) | VDP_COLOR_DARK_BLUE
    .db     (VDP_COLOR_LIGHT_GREEN  << 4) | VDP_COLOR_DARK_BLUE,    (VDP_COLOR_LIGHT_GREEN  << 4) | VDP_COLOR_DARK_BLUE
    .db     (VDP_COLOR_LIGHT_GREEN  << 4) | VDP_COLOR_DARK_BLUE,    (VDP_COLOR_LIGHT_GREEN  << 4) | VDP_COLOR_DARK_BLUE
    .db     (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_BLUE,    (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_BLUE
    .db     (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_BLUE,    (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_BLUE

; スプライト
;
titleSprite:

    .db     0x50 - 0x01, 0x78, 0xa0, VDP_COLOR_WHITE

; 文字列
;
titleString_0:

    .ascii  "HOW MANY ARE"
    .db     0x00

titleString_1:

    .ascii  "THE DUMBBELLS YOU LIFT ?"
    .db     0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; タイトル
;
_title::
    
    .ds     TITLE_LENGTH
