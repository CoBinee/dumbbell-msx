// 参照ファイルのインクルード
//
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <png.h>



// メインプログラムのエントリ
//
int main(int argc, const char *argv[])
{
    // 入力ファイル名の初期化
    const char *pngname = NULL;
    
    // 出力ファイル名の初期化
    const char *outname = NULL;
    
    // 名前の初期化
    const char *name = NULL;
    
    // 引数の取得
    while (--argc > 0) {
        ++argv;
        if (strcasecmp(*argv, "-o") == 0) {
            outname = *++argv;
            --argc;
        } else if (strcasecmp(*argv, "-n") == 0) {
            name = *++argv;
            --argc;
        } else {
            pngname = *argv;
        }
    }
    
    // .png ファイルがない
    if (pngname == NULL) {
        fprintf(stderr, "error - no .png file name.\n");
        return -1;
    }

    // .png を開く
    FILE *pngfile = fopen(pngname, "rb");
    if  (pngfile == NULL) {
        fprintf(stderr, "error - %s is not opened.\n", pngname);
        return -1;
    }

    // .png ヘッダの読み込み
    png_byte pngheader[8];
    if (fread(pngheader, sizeof (pngheader), 1, pngfile) != 1) {
        fprintf(stderr, "error - .png header is not read.\n");
        return -1;
    }
    if (png_sig_cmp(pngheader, 0, sizeof (pngheader))) {
        fprintf(stderr, "error - png_sig_cmp().\n");
        return -1;
    }
    
    // .png read の作成
    png_structp pngread = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
    if (pngread == NULL) {
        fprintf(stderr, "error - png_create_read_struct().\n");
        return -1;
    }

    // .png info の作成
    png_infop pnginfo = png_create_info_struct(pngread);
    if (pnginfo == NULL) {
        fprintf(stderr, "error - png_create_info_struct().\n");
        return -1;
    }

    // ファイルポインタの設定
    png_init_io(pngread, pngfile);

    // 読み込み済みサイズの設定
    png_set_sig_bytes(pngread, sizeof (pngheader));

    // .png の読み込み
    png_read_png(pngread, pnginfo, PNG_TRANSFORM_PACKING | PNG_TRANSFORM_STRIP_16, NULL);

    // 大きさの取得
    png_uint_32 pngwidth = png_get_image_width(pngread, pnginfo);
    png_uint_32 pngheight = png_get_image_height(pngread, pnginfo);

    // カラータイプの取得
    png_byte pngbitdepth = png_get_bit_depth(pngread, pnginfo);
    png_byte pngcolortype = png_get_color_type(pngread, pnginfo);

    // パレットのみ対応
    if (pngcolortype != PNG_COLOR_TYPE_PALETTE) {
        if (pngcolortype == PNG_COLOR_TYPE_GRAY) {
            fprintf(stderr, "error - .png color type is not palette(%d x %d pixels, %d bits, gray).\n", pngwidth, pngheight, pngbitdepth);
        } else if (pngcolortype == PNG_COLOR_TYPE_GRAY_ALPHA) {
            fprintf(stderr, "error - .png color type is not palette(%d x %d pixels, %d bits, gray alpha).\n", pngwidth, pngheight, pngbitdepth);
        } else if (pngcolortype == PNG_COLOR_TYPE_RGB) {
            fprintf(stderr, "error - .png color type is not palette(%d x %d pixels, %d bits, rgb).\n", pngwidth, pngheight, pngbitdepth);
        } else if (pngcolortype == PNG_COLOR_TYPE_GRAY_ALPHA) {
            fprintf(stderr, "error - .png color type is not palette(%d x %d pixels, %d bits, rgba).\n", pngwidth, pngheight, pngbitdepth);
        } else {
            fprintf(stderr, "error - .png color type is not palette(%d x %d pixels, %d bits).\n", pngwidth, pngheight, pngbitdepth);
        }
        return -1;
    }

    // パレットの取得
    /*
    png_colorp pngpalette;
    int pngpalettelength;
    png_get_PLTE(pngread, pnginfo, &pngpalette, &pngpalettelength);
    */

    // 行と列の取得
    int column = (pngwidth + 7) / 8;
    int row = (pngheight + 7) / 8;

    // ピクセル領域の確保
    png_bytep pixels = new png_byte[column * row * 8];

    // カラー領域の確保
    png_bytep colors = new png_byte[column * row * 8];
    
    // イメージの取得
    png_bytepp pngrows = png_get_rows(pngread, pnginfo);
    {
        int index = 0;
        for (int r = 0; r < row; r++) {
            for (int c = 0; c < column; c++) {
                for (int v = 0; v < 8; v++) {
                    png_byte pixel = 0x00;
                    png_byte forecolor = 0x00;
                    png_byte backcolor = 0x00;
                    int y = r * 8 + v;
                    if (y < pngheight) {
                        png_bytep row = pngrows[y] + (c * 8);
                        forecolor = *row++;
                        pixel = 0x01;
                        for (int u = 1; u < 8; u++) {
                            int x = c * 8 + u;
                            pixel <<= 1;
                            if (x < pngwidth) {
                                if (*row == forecolor) {
                                    pixel |= 0x01;
                                } else {
                                    backcolor = *row;
                                }
                            }
                            ++row;
                        }
                    }
                    pixels[index] = pixel;
                    colors[index] = ((forecolor & 0x0f) << 4) | (backcolor & 0x0f);
                    ++index;
                }
            }
        }
    }

    // 出力ファイルを開く
    FILE *outfile = outname != NULL ? fopen(outname, "w") : stdout;
    
    // ヘッダの出力
    fprintf(outfile, "; %s : %d x %d pixels, %d bits, palette\n;\n\n", pngname, pngwidth, pngheight, pngbitdepth);
    if (name != NULL) {
        fprintf(outfile, "    .module %s\n", name);
        fprintf(outfile, "    .area   _CODE\n\n");
    }
    
    // キャラクタジェネレータの出力
    if (name != NULL) {
        fprintf(outfile, "_%s_PatternGenerator::\n\n", name);
    }
    {
        png_bytep p = pixels;
        for (int i = 0; i < column * row; i++) {
            fprintf(outfile, "    .db     ");
            for (int j = 0; j < 8; j++) {
                fprintf(outfile, "0x%02x", *p++);
                if (j < 8 - 1) {
                    fprintf(outfile, ", ");
                }
            }
            fprintf(outfile, "\n");
        }
    }
    fprintf(outfile, "\n");

    // カラーテーブルの出力
    if (name != NULL) {
        fprintf(outfile, "_%s_ColorTable::\n\n", name);
    }
    {
        png_bytep c = colors;
        for (int i = 0; i < column * row; i++) {
            fprintf(outfile, "    .db     ");
            for (int j = 0; j < 8; j++) {
                fprintf(outfile, "0x%02x", *c++);
                if (j < 8 - 1) {
                    fprintf(outfile, ", ");
                }
            }
            fprintf(outfile, "\n");
        }
    }

    // 出力ファイルを閉じる
    fclose(outfile);

    // カラー領域の解放
    delete[] colors;

    // ピクセル領域の解放
    delete[] pixels;

    // .png の解放
    png_destroy_read_struct(&pngread, &pnginfo, NULL);

    // .png ファイルを閉じる
    fclose(pngfile);
    
    // 終了
    return 0;
}


