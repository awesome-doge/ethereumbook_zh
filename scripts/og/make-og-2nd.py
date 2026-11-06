#!/usr/bin/env python3
"""產生第二版的社群分享圖 web/assets/og-cover-2nd.png（1200×630）。

第二版沒有可用的封面圖，所以用文字版面：左邊是以太坊菱形標誌，右邊是書名、作者與網址。
用法：python3 scripts/og/make-og-2nd.py <Noto Sans CJK TC 字型目錄>   （需要 Regular、Medium、Black 三個 .otf）
"""
import pathlib
import sys

from PIL import Image, ImageDraw, ImageFont

fonts = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else pathlib.Path.home() / "Library/Fonts")
out = pathlib.Path(__file__).resolve().parents[2] / "web/assets/og-cover-2nd.png"


def font(weight, size):
    return ImageFont.truetype(str(fonts / f"NotoSansCJKtc-{weight}.otf"), size)


BG, INK, INK2, ACCENT, SOFT = "#f3f5fa", "#1d2033", "#535870", "#5468d4", "#e6e9fa"
W, H = 1200, 630
img = Image.new("RGB", (W, H), BG)
d = ImageDraw.Draw(img)
d.rectangle([0, 0, W, 10], fill=ACCENT)

# 左欄：以太坊菱形（上下兩個八面體的平面投影），放在淡色圓角方塊裡
d.rounded_rectangle([80, 95, 470, 535], radius=28, fill=SOFT)
cx, top, mid, low, bottom, half = 275, 150, 345, 390, 480, 120
d.polygon([(cx, top), (cx + half, mid), (cx, low), (cx - half, mid)], fill="#8c9ae6")
d.polygon([(cx, top), (cx + half, mid), (cx, low)], fill="#5468d4")
d.polygon([(cx, top), (cx - half, mid), (cx, mid - 60), ], fill="#a9b4ee")
d.polygon([(cx - half, mid + 22), (cx, low + 22), (cx, bottom)], fill="#a9b4ee")
d.polygon([(cx + half, mid + 22), (cx, low + 22), (cx, bottom)], fill="#5468d4")
d.text((cx, 512), "2nd Edition", font=font("Medium", 24), fill=ACCENT, anchor="ms")

x = 530
d.text((x, 160), "Mastering Ethereum, 2nd Edition ・ 繁體中文版", font=font("Regular", 28), fill=ACCENT, anchor="ls")
d.text((x, 290), "精通以太坊", font=font("Black", 104), fill=INK, anchor="ls")
d.rounded_rectangle([x, 318, x + 140, 372], radius=12, fill=ACCENT)
d.text((x + 70, 357), "第二版", font=font("Medium", 32), fill="#ffffff", anchor="ms")
d.text((x + 160, 357), "全書免費線上閱讀", font=font("Regular", 32), fill=INK2, anchor="ls")
d.text((x, 432), "Andreas M. Antonopoulos、Gavin Wood 等著", font=font("Regular", 28), fill=INK2, anchor="ls")
d.text((x, 474), "Dr. Awesome Doge 譯", font=font("Regular", 28), fill=INK2, anchor="ls")
d.text((x, 560), "PDF／EPUB 下載 ・ mastering-ethereum.doge.tg", font=font("Medium", 28), fill=ACCENT, anchor="ls")

img.save(out, optimize=True)
print(f"OK：{out}")
