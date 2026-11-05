"""標記外漏檢查：在渲染後的 HTML 正文裡找原樣露出的 AsciiDoc／Markdown 標記。

用法：python3 scripts/md2adoc/leaks.py <html 檔或目錄>…
略過 pre、code、script、style 與公式（\\( … \\)、\\[ … \\]）。任何一頁有外漏就以非零狀態結束。
"""
import html
import pathlib
import re
import sys

H = r'[㐀-鿿　-〿＀-￯]'
PATTERNS = {
    '_x_ 緊貼中文': rf'(?:{H}_[^_\s]{{1,40}}?_|_[^_\s]{{1,40}}?_{H})',
    '*x* 緊貼中文': rf'(?:{H}\*[^*\s]{{1,40}}?\*|\*[^*\s]{{1,40}}?\*{H})',
    '`x`': r'`[^`\n]{1,60}`',
    '[[id]]': r'\[\[[\w-]+\]\]',
    '<<xref': r'<<[\w-]+',
    'pass:': r'\bpass:[a-z]*\[',
    'link:': r'\blink:\S',
    'xref:': r'\bxref:\S',
    'latexmath:': r'\blatexmath:',
    'footnote:': r'\bfootnote:',
    '++ 原樣標記': r'\+\+[\[\]]\+\+',
    'image:': r'\bimage::?\S',
    'TODO-term': r'TODO-term',
    'markdown 連結': r'\]\(https?://',
    'markdown 標題': r'(?m)^#{2,6} ',
    '中文 class': r'ROLE-LEAK:\S+',
    'url[text]': r'https?://[^\s\[\]]+\[[^\]\n]*\]',
}


def text_of(path):
    s = path.read_text(encoding='utf-8')
    # 「[…]++…++」被誤讀成角色時，中文會跑進 class 屬性；正文看不到，要在 HTML 原始碼裡找
    s += ' '.join(f'ROLE-LEAK:{c}' for c in re.findall(r'class="([^"]*[^\x00-\x7f][^"]*)"', s))
    s = re.sub(r'<(pre|code|script|style)[^>]*>.*?</\1>', '', s, flags=re.S)
    s = html.unescape(re.sub(r'<[^>]+>', '', s))
    s = re.sub(r'\\\((.*?)\\\)', '', s, flags=re.S)
    return re.sub(r'\\\[(.*?)\\\]', '', s, flags=re.S)


files = []
for arg in sys.argv[1:]:
    p = pathlib.Path(arg)
    files += sorted(p.rglob('*.html')) if p.is_dir() else [p]

bad = 0
for f in files:
    t = text_of(f)
    hits = {k: re.findall(p, t) for k, p in PATTERNS.items()}
    hits = {k: v for k, v in hits.items() if v}
    if hits:
        bad += 1
        print(f'{f}:')
        for k, v in hits.items():
            print(f'  {k} × {len(v)}：{v[:3]}')
print(f'標記外漏檢查：{len(files)} 個頁面，{bad} 頁有問題')
sys.exit(1 if bad else 0)
