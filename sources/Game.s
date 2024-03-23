; Game.s : ゲーム
;


; モジュール宣言
;
    .module Game

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "App.inc"
    .include    "Sound.inc"
    .include	"Game.inc"
    .include    "Back.inc"
    .include    "Player.inc"
    .include    "Master.inc"
    .include    "Enemy.inc"
    .include    "Clock.inc"

; 外部変数宣言
;
    .globl  _patternTable

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; ゲームを初期化する
;
_GameInitialize::
    
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
    ld      de, #APP_PATTERN_GENERATOR_TABLE
    ld      bc, #0x0800
    call    LDIRVM
    
    ; カラーテーブルの転送
    ld      hl, #gameColorTable
    ld      de, #APP_COLOR_TABLE
    ld      bc, #0x0020
    call    LDIRVM

    ; パターンネームのクリア
    xor     a
    call    _SystemClearPatternName
    
    ; ゲームの初期化
    ld      hl, #gameDefault
    ld      de, #_game
    ld      bc, #GAME_LENGTH
    ldir

    ; 背景の描画
    call    _BackInitialize

    ; プレイヤの初期化
    call    _PlayerInitialize

    ; マスターの初期化
    call    _MasterInitialize

    ; エネミーの初期化
    call    _EnemyInitialize

    ; 時計の初期化
    call    _ClockInitialize

    ; 描画の開始
    ld      hl, #(_videoRegister + VDP_R1)
    set     #VDP_R1_BL, (hl)

    ; 状態の設定
    ld      a, #GAME_STATE_PLAY
    ld      (_game + GAME_STATE), a
    ld      a, #APP_STATE_GAME_UPDATE
    ld      (_app + APP_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; ゲームを更新する
;
_GameUpdate::
    
    ; レジスタの保存
    
    ; スプライトのクリア
    call    _SystemClearSprite

    ; 状態別の処理
    ld      hl, #10$
    push    hl
    ld      a, (_game + GAME_STATE)
    and     #0xf0
    rrca
    rrca
    rrca
    ld      e, a
    ld      d, #0x00
    ld      hl, #gameProc
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ex      de, hl
    jp      (hl)
;   pop     hl
10$:

    ; レジスタの復帰
    
    ; 終了
    ret

; 何もしない
;
GameNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; ゲームをプレイする
;
GamePlay:

    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    and     #0x0f
    jr      nz, 09$

    ; スプライトの設定
    ld      hl, #(_videoRegister + VDP_R1)
    set     #VDP_R1_MAG, (hl)

    ; フレームの設定
    ld      a, #180
    ld      (_game + GAME_FRAME), a

    ; BGM の再生
    ld      a, #SOUND_BGM_MUSCLE
    call    _SoundPlayBgm

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; カウントダウン
10$:
    ld      a, (_game + GAME_FLAG)
    bit     #GAME_FLAG_COUNTDOWN, a
    jr      z, 19$
    ld      hl, (_game + GAME_TIMER_L)
    ld      a, h
    or      l
    jr      z, 11$
    dec     hl
    ld      (_game + GAME_TIMER_L), hl
    jr      19$
11$:
    ld      hl, #(_game + GAME_FRAME)
    dec     (hl)
    jr      nz, 19$

    ; 状態の更新
    ld      a, #GAME_STATE_RESULT
    ld      (_game + GAME_STATE), a
19$:

    ; 背景の更新
    call    _BackUpdate

    ; プレイヤの更新
    call    _PlayerUpdate

    ; マスターの更新
    call    _MasterUpdate

    ; エネミーの更新
    call    _EnemyUpdate

    ; 時計の更新
    call    _ClockUpdate

    ; 背景の描画
    call    _BackRender

    ; プレイヤの描画
    call    _PlayerRender

    ; マスターの描画
    call    _MasterRender

    ; エネミーの描画
    call    _EnemyRender

    ; 時計の描画
    call    _ClockRender

    ; レジスタの復帰

    ; 終了
    ret

; ゲームの結果を表示する
;
GameResult:

    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    and     #0x0f
    jr      nz, 09$

    ; フレームの設定
    ld      a, #0x20
    ld      (_game + GAME_FRAME), a

    ; 結果画面の描画
    call    GamePrintResultBack

    ; スプライトの設定
    ld      hl, #(_videoRegister + VDP_R1)
    set     #VDP_R1_MAG, (hl)

;   ; サウンドの停止
;   call    _SoundStop

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; フレームの更新
    ld      hl, #(_game + GAME_FRAME)
    ld      a, (hl)
    or      a
    jr      z, 10$
    dec     (hl)
    jr      90$

    ; 0x01: ダンベルの更新
10$:
    ld      a, (_game + GAME_STATE)
    and     #0x0f
    dec     a
    jr      nz, 20$
    ld      hl, #(_game + GAME_DUMBBELL_SCORE)
    ld      a, (_game + GAME_DUMBBELL_COUNT)
    cp      (hl)
    jr      z, 11$
    inc     (hl)
    ld      hl, (_game + GAME_SCORE_L)
    inc     hl
    ld      (_game + GAME_SCORE_L), hl
    jr      19$
11$:
    ld      a, #0x20
    ld      (_game + GAME_FRAME), a
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
;   jr      19$
19$:
    jr      90$

    ; 0x02: ちくわの更新
20$:
    dec     a
    jr      nz, 30$
    ld      hl, #(_game + GAME_CHIKUWA_SCORE)
    ld      a, (_game + GAME_CHIKUWA_COUNT)
    cp      (hl)
    jr      z, 21$
    inc     (hl)
    ld      hl, (_game + GAME_SCORE_L)
    dec     hl
    ld      (_game + GAME_SCORE_L), hl
    jr      29$
21$:
    ld      a, #0x60
    ld      (_game + GAME_FRAME), a
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
;   jr      29$
29$:
    jr      90$

    ; 0x03: 待機
30$:
    ld      a, (_game + GAME_CHIKUWA_COUNT)
    ld      e, a
    ld      a, (_game + GAME_DUMBBELL_COUNT)
    cp      e
    jr      c, 31$
    jr      z, 32$
    ld      a, #APP_JUDGE_GOOD
    ld      (_app + APP_JUDGE), a
    ld      a, #APP_STATE_JUDGE_INITIALIZE
    ld      (_app + APP_STATE), a
    jr      39$
31$:
    ld      a, #APP_JUDGE_BAD
    ld      (_app + APP_JUDGE), a
    ld      a, #APP_STATE_JUDGE_INITIALIZE
    ld      (_app + APP_STATE), a
    jr      39$
32$:
    ld      a, #APP_STATE_TITLE_INITIALIZE
    ld      (_app + APP_STATE), a
    jr      39$

    ; 描画の停止
39$:
    ld      hl, #(_videoRegister + VDP_R1)
    res     #VDP_R1_BL, (hl)
;   jr      90$

    ; 結果の完了
90$:

    ; スコアの描画
    call    GamePrintResultScore

    ; スプライトの描画
    call    GamePrintResultSprite

    ; レジスタの復帰

    ; 終了
    ret

; 結果画面を描画する
;
GamePrintResultBack:

    ; レジスタの保存

    ; 画面のクリア
    ld      hl, #(_patternName + 0x0000)
    ld      de, #(_patternName + 0x0001)
    ld      bc, #(0x0300 - 0x0001)
    ld      (hl), #0x00
    ldir

    ; CLEAR の描画
    ld      hl, #gameStringResultClear
    ld      de, #(_patternName + 0x0007 * 0x0020 + 0x0006)
    call    GamePrintString

    ; x 0 の描画
    ld      hl, #gameStringResultCount
    ld      de, #(_patternName + 0x000a * 0x0020 + 0x0010)
    call    GamePrintString
    ld      hl, #gameStringResultCount
    ld      de, #(_patternName + 0x000c * 0x0020 + 0x0010)
    call    GamePrintString

    ; SCORE の描画
    ld      hl, #gameStringResultScore
    ld      de, #(_patternName + 0x000f * 0x0020 + 0x000b)
    call    GamePrintString

    ; レジスタの復帰

    ; 終了
    ret

GamePrintResultScore:

    ; レジスタの保存

    ; ダンベルの描画
    ld      a, (_game + GAME_DUMBBELL_SCORE)
    ld      l, a
    ld      h, #0x00
    ld      de, #(_patternName + 0x000a * 0x0020 + 0x0011)
    call    GamePrintDecimal

    ; ちくわの描画
    ld      a, (_game + GAME_CHIKUWA_SCORE)
    ld      l, a
    ld      h, #0x00
    ld      de, #(_patternName + 0x000c * 0x0020 + 0x0011)
    call    GamePrintDecimal

    ; スコアの描画
    ld      hl, (_game + GAME_SCORE_L)
    ld      de, #(_patternName + 0x000f * 0x0020 + 0x0011)
    call    GamePrintDecimal

    ; レジスタの復帰

    ; 終了
    ret

GamePrintResultSprite:

    ; レジスタの保存

    ; スプライトの描画
    ld      hl, #gameSpriteResult
    ld      de, #(_sprite + GAME_SPRITE_RESULT)
    ld      bc, #0x0008
    ldir

    ; レジスタの復帰

    ; 終了
    ret

; 文字列を描画する
;
GamePrintString:

    ; レジスタの保存
    push    hl
    push    de

    ; hl < 文字列
    ; de < 描画位置

    ; 文字列の描画
10$:
    ld      a, (hl)
    or      a
    jr      z, 19$
    sub     #0x20
    ld      (de), a
    inc     hl
    inc     de
    jr      10$
19$:

    ; レジスタの復帰
    pop     de
    pop     hl

    ; 終了
    ret

; 符号つき 3 桁の数値の 10 進描画を行う
;
GamePrintDecimal:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; hl < 値
    ; de < 描画位置

    ; 符号の描画
    bit     #0x07, h
    jr      nz, 10$
    xor     a
    jr      19$
10$:
    ld      a, h
    cpl
    ld      h, a
    ld      a, l
    cpl
    ld      l, a
    inc     hl
    ld      a, #('- - 0x20)
;   jr      19$
19$:
    ld      (de), a
    inc     de

    ; 数値の変換
    push    de
    ld      bc, #100
    xor     a
200$:
    sbc     hl, bc
    jr      c, 201$
    inc     a
    jr      200$
201$:
    ld      d, a
    add     hl, bc
    ld      a, l
    ld      b, #10
    ld      c, #0x00
210$:
    sub     b
    jr      c, 211$
    inc     c
    jr      210$
211$:
    add     a, b
    ld      e, a
    ld      a, c
    add     a, a
    add     a, a
    add     a, a
    add     a, a
    add     a, e
    ld      e, a
    ex      de, hl
    pop     de

    ; 数値の描画
    ld      c, #0x00
    ld      a, h
    or      a
    jr      z, 30$
    ld      c, #('0 - 0x20)
30$:
    add     a, c
    ld      (de), a
    inc     de
    ld      a, l
    rrca
    rrca
    rrca
    rrca
    and     #0x0f
    jr      z, 31$
    ld      c, #('0 - 0x20)
31$:
    add     a, c
    ld      (de), a
    inc     de
    ld      a, l
    and     #0x0f
    add     a, #('0 - 0x20)
    ld      (de), a

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret


; 定数の定義
;

; 状態別の処理
;
gameProc:
    
    .dw     GameNull
    .dw     GamePlay
    .dw     GameResult

; ゲームの初期値
;
gameDefault:

    .db     GAME_STATE_NULL
    .db     GAME_FLAG_NULL
    .dw     GAME_TIMER_LENGTH
    .db     GAME_DUMBBELL_NULL
    .db     GAME_DUMBBELL_NULL
    .db     GAME_CHIKUWA_NULL
    .db     GAME_CHIKUWA_NULL
    .dw     GAME_SCORE_NULL
    .db     GAME_FRAME_NULL

; カラーテーブル
;
gameColorTable:

    .db     (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_GREEN,   (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_GREEN
    .db     (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_GREEN,   (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_GREEN
    .db     (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_GREEN,   (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_GREEN
    .db     (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_GREEN,   (VDP_COLOR_WHITE        << 4) | VDP_COLOR_DARK_GREEN
    .db     (VDP_COLOR_LIGHT_RED    << 4) | VDP_COLOR_DARK_RED,     (VDP_COLOR_DARK_RED     << 4) | VDP_COLOR_BLACK
    .db     (VDP_COLOR_LIGHT_GREEN  << 4) | VDP_COLOR_CYAN,         (VDP_COLOR_MEDIUM_GREEN << 4) | VDP_COLOR_CYAN
    .db     (VDP_COLOR_DARK_GREEN   << 4) | VDP_COLOR_CYAN,         (VDP_COLOR_DARK_GREEN   << 4) | VDP_COLOR_CYAN
    .db     (VDP_COLOR_LIGHT_GREEN  << 4) | VDP_COLOR_DARK_GREEN,   (VDP_COLOR_GRAY         << 4) | VDP_COLOR_BLACK
    .db     (VDP_COLOR_WHITE        << 4) | VDP_COLOR_BLACK,        (VDP_COLOR_WHITE        << 4) | VDP_COLOR_BLACK
    .db     (VDP_COLOR_WHITE        << 4) | VDP_COLOR_BLACK,        (VDP_COLOR_WHITE        << 4) | VDP_COLOR_BLACK
    .db     (VDP_COLOR_WHITE        << 4) | VDP_COLOR_BLACK,        (VDP_COLOR_WHITE        << 4) | VDP_COLOR_BLACK
    .db     (VDP_COLOR_WHITE        << 4) | VDP_COLOR_BLACK,        (VDP_COLOR_WHITE        << 4) | VDP_COLOR_BLACK
    .db     (VDP_COLOR_WHITE        << 4) | VDP_COLOR_BLACK,        (VDP_COLOR_WHITE        << 4) | VDP_COLOR_BLACK
    .db     (VDP_COLOR_WHITE        << 4) | VDP_COLOR_BLACK,        (VDP_COLOR_WHITE        << 4) | VDP_COLOR_BLACK
    .db     (VDP_COLOR_WHITE        << 4) | VDP_COLOR_BLACK,        (VDP_COLOR_WHITE        << 4) | VDP_COLOR_BLACK
    .db     (VDP_COLOR_WHITE        << 4) | VDP_COLOR_BLACK,        (VDP_COLOR_WHITE        << 4) | VDP_COLOR_BLACK

; スプライト
;
gameSpriteResult:

    .db     0x43 - 0x01, 0x5c, 0x08, VDP_COLOR_BLACK
    .db     0x53 - 0x01, 0x5c, 0x0c, VDP_COLOR_DARK_YELLOW

; 文字列
;
gameStringResultClear:

    .ascii  "YOU CLEAR WORKOUT !!"
    .db     0x00

gameStringResultCount:

    .ascii  "*   0"
    .db     0x00

gameStringResultScore:

    .ascii  "SCORE    0"
    .db     0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; ゲーム
;
_game::
    
    .ds     GAME_LENGTH
