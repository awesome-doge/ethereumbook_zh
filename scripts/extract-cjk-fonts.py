#!/usr/bin/env python3
"""為 asciidoctor-pdf 準備繁體中文字型：取出 Noto Sans CJK TC，只留書中用到的字，再把 CFF 外框轉成 TrueType 外框。

asciidoctor-pdf 用的 prawn／ttfunk 不支援 CFF 外框的 OpenType 字型：直接嵌入 Noto Sans CJK 會得到
沒有任何文字的 PDF（閱讀器報 Mismatch between font type and embedded font file）。所以先依全書文字
子集化（幾千字，轉換只要幾秒），再用 cu2qu 把三次曲線轉成二次曲線，存成真正的 TrueType。

用法：extract-cjk-fonts.py <輸出目錄> <書稿目錄> [字型來源…]
  字型來源預設是 Ubuntu fonts-noto-cjk 的 TTC（取其中的 TC），也可以給 .otf（例如本機的 NotoSansCJKtc-Regular.otf）。
  輸出 notosanstc-regular.ttf、notosanstc-bold.ttf。
"""
import pathlib
import sys

from fontTools import subset
from fontTools.pens.cu2quPen import Cu2QuPen
from fontTools.pens.ttGlyphPen import TTGlyphPen
from fontTools.ttLib import TTCollection, TTFont, newTable

out_dir = pathlib.Path(sys.argv[1])
book_dir = pathlib.Path(sys.argv[2])
sources = sys.argv[3:] or [
    "/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc",
    "/usr/share/fonts/opentype/noto/NotoSansCJK-Bold.ttc",
]
names = ["notosanstc-regular.ttf", "notosanstc-bold.ttf"]

# 書中所有字元，加上 ASCII、常用全形標點，以及 Asciidoctor／主題在排版時才插入的字元：
# 清單符號 •◦▪、replacements 產生的彎引號與 © ™ ® — … →，-- 兩側的細空白（U+2009）
text = "".join(p.read_text(encoding="utf-8") for p in sorted(book_dir.glob("*.adoc")))
text += "".join(map(chr, range(0x20, 0x7F))) + "　、。，．：；？！「」『』（）〈〉《》—…・"
text += "•◦▪‘’“”©™®–→←⇒⇐\u2009\u00a0"


def load_tc(src):
    if src.endswith(".ttc"):
        for font in TTCollection(src):
            if " TC" in (font["name"].getDebugName(1) or ""):
                return font
        sys.exit(f"{src} 裡沒有 TC 字型")
    return TTFont(src)


def to_truetype(font):
    glyph_order = font.getGlyphOrder()
    glyph_set = font.getGlyphSet()
    glyphs = {}
    for name in glyph_order:
        pen = TTGlyphPen(glyph_set)
        glyph_set[name].draw(Cu2QuPen(pen, max_err=1.0, reverse_direction=True))
        glyphs[name] = pen.glyph()
    font["loca"] = newTable("loca")
    font["glyf"] = glyf = newTable("glyf")
    glyf.glyphOrder = glyph_order
    glyf.glyphs = glyphs
    for tag in ("CFF ", "VORG"):
        if tag in font:
            del font[tag]
    glyf.compile(font)
    hmtx = font["hmtx"]
    for name, glyph in glyphs.items():
        if hasattr(glyph, "xMin"):
            hmtx[name] = (hmtx[name][0], glyph.xMin)
    maxp = font["maxp"] = newTable("maxp")
    maxp.tableVersion = 0x00010000
    for attr in ("maxZones", "maxTwilightPoints", "maxStorage", "maxFunctionDefs", "maxInstructionDefs",
                 "maxStackElements", "maxSizeOfInstructions", "maxComponentElements"):
        setattr(maxp, attr, 1 if attr == "maxZones" else 0)
    maxp.compile(font)
    post = font["post"]
    post.formatType = 3.0
    font.sfntVersion = "\x00\x01\x00\x00"


options = subset.Options()
options.layout_features = ["*"]
options.name_IDs = ["*"]
options.notdef_outline = True
for src, name in zip(sources, names):
    font = load_tc(src)
    family = font["name"].getDebugName(4)
    subsetter = subset.Subsetter(options)
    subsetter.populate(text=text)
    subsetter.subset(font)
    if "CFF " in font:
        to_truetype(font)
    out = out_dir / name
    font.save(out)
    print(f"OK：{family} → {out}（{len(font.getGlyphOrder())} 個字形）")
