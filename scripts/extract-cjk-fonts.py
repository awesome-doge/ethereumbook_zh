#!/usr/bin/env python3
"""Extract Traditional Chinese fonts from NotoSansCJK .ttc collections."""
import os
import sys
from fontTools.ttLib import TTCollection

font_dir = sys.argv[1]

pairs = [
    ("NotoSansCJK-Regular.ttc", "notosanstc-regular.ttf"),
    ("NotoSansCJK-Bold.ttc", "notosanstc-bold.ttf"),
]

for src_name, out_name in pairs:
    src = f"/usr/share/fonts/opentype/noto/{src_name}"
    tc = TTCollection(src)
    extracted = False
    for i, font in enumerate(tc):
        name = font["name"].getDebugName(1) or ""
        if "TC" in name:
            out = os.path.join(font_dir, out_name)
            font.save(out)
            print(f"OK: {name} (index {i}) -> {out_name}")
            extracted = True
            break
    if not extracted:
        idx = min(1, len(tc) - 1)
        out = os.path.join(font_dir, out_name)
        tc[idx].save(out)
        print(f"Fallback: index {idx} -> {out_name}")
