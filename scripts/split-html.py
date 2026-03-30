#!/usr/bin/env python3
"""
Split single-page Asciidoctor HTML book into multiple chapter pages.
Uses regex to find chapter boundaries by section number pattern.
"""

import re
import os
import sys
from datetime import date

# Chapter metadata: (anchor_pattern, filename, seo_title)
CHAPTER_MAP = [
    ("preface_chap", "preface.html", "前言"),
    ("glossary", "glossary.html", "快速術語表"),
    ("whatis_chapter", "ch01.html", "什麼是以太坊"),
    ("intro_chapter", "ch02.html", "以太坊基礎"),
    ("ethereum_clients_chapter", "ch03.html", "以太坊客戶端"),
    ("testnets_chapter", "ch04.html", "以太坊測試網"),
    ("keys_addresses", "ch05.html", "密鑰和地址"),
    ("wallets_chapter", "ch06.html", "錢包"),
    ("tx_chapter", "ch07.html", "交易"),
    ("smart_contracts_chapter", "ch08.html", "智能合約"),
    ("dev_tools_chapter", "ch09.html", "開發工具、框架和庫"),
    ("Tokens_chapter", "ch10.html", "代幣 Tokens"),
    ("decentralized_applications_chap", "ch11.html", "去中心化應用 DApps"),
    ("oracles_chap", "ch12.html", "預言機 Oracles"),
    ("gas", "ch13.html", "燃氣 Gas"),
    ("evm_chapter", "ch14.html", "以太坊虛擬機 EVM"),
    ("_以太坊的共識", "ch15.html", "共識"),
    ("viper_chap", "ch16.html", "Vyper"),
    ("communications_between_nodes", "ch17.html", "DevP2P 協議"),
    ("ethereum_standards", "ch18.html", "以太坊標準"),
    ("ethereum_fork_history", "ch19.html", "以太坊分叉歷史"),
]


def find_anchor_positions(html):
    """Find byte positions of all chapter anchors in HTML."""
    positions = []
    for anchor, filename, title in CHAPTER_MAP:
        # Look for id="anchor" in any tag
        pattern = rf'id="{re.escape(anchor)}"'
        match = re.search(pattern, html)
        if not match:
            # Fallback: search by heading title text
            # Try to find <h2...>NUMBER. TITLE or <h2...>TITLE
            title_words = title.split()[0]  # first word
            for hpat in [rf'<h2[^>]*>[^<]*{re.escape(title_words)}', rf'<h3[^>]*>[^<]*{re.escape(title_words)}']:
                match = re.search(hpat, html)
                if match:
                    break
        if match:
            sect_start = html.rfind('<div class="sect', 0, match.start())
            if sect_start == -1:
                sect_start = match.start()
            positions.append((sect_start, anchor, filename, title))
        else:
            print(f"  SKIP: '{title}' ({anchor}) not found in HTML")
    positions.sort(key=lambda x: x[0])
    return positions


def extract_head(html):
    """Extract <head> content."""
    m = re.search(r"<head>(.*?)</head>", html, re.DOTALL)
    return m.group(1) if m else ""


def extract_footer(html):
    """Extract everything from <div id="footer"> onwards."""
    m = re.search(r'(<div id="footer">.*)', html, re.DOTALL)
    return m.group(1) if m else ""


def make_nav(prev_ch, next_ch):
    """Generate chapter navigation HTML."""
    nav = '<nav class="chapter-nav">'
    if prev_ch:
        nav += f'<a href="{prev_ch[2]}" class="nav-prev">&larr; {prev_ch[3]}</a>'
    else:
        nav += '<span></span>'
    nav += '<a href="index.html" class="nav-home">首頁</a>'
    if next_ch:
        nav += f'<a href="{next_ch[2]}" class="nav-next">{next_ch[3]} &rarr;</a>'
    else:
        nav += '<span></span>'
    nav += '</nav>'
    return nav


NAV_CSS = """<style>
.chapter-nav{display:flex;justify-content:space-between;align-items:center;padding:1rem 0;border-top:1px solid #e1e4e8;border-bottom:1px solid #e1e4e8;margin:2rem 0;gap:0.8rem;flex-wrap:wrap}
.chapter-nav a{color:#2980b9;text-decoration:none;font-size:0.9rem;padding:0.4rem 0.8rem;border-radius:4px;transition:background 0.2s}
.chapter-nav a:hover{background:#f0f3f6}
.chapter-nav .nav-prev{text-align:left;max-width:40%}
.chapter-nav .nav-next{text-align:right;max-width:40%}
.chapter-nav .nav-home{font-weight:600}
@media(max-width:768px){.chapter-nav{font-size:0.82rem}.chapter-nav a{padding:0.3rem 0.5rem}}
</style>"""


def main():
    if len(sys.argv) < 2:
        print("Usage: split-html.py <output-dir>")
        sys.exit(1)

    output_dir = sys.argv[1]
    book_path = os.path.join(output_dir, "book.html")

    with open(book_path, "r", encoding="utf-8") as f:
        html = f.read()

    head = extract_head(html)
    footer = extract_footer(html)
    footer_pos = html.find('<div id="footer">')

    # Find all chapter positions
    positions = find_anchor_positions(html)
    print(f"Found {len(positions)} chapters")

    base_url = "https://mastering-ethereum.doge.tg"

    # Build anchor-to-file mapping for cross-reference fixing
    anchor_to_file = {}
    for i, (start, anchor, filename, title) in enumerate(positions):
        end = positions[i + 1][0] if i + 1 < len(positions) else footer_pos
        chunk = html[start:end]
        for aid in re.findall(r'id="([^"]*)"', chunk):
            anchor_to_file[aid] = filename

    # Generate each chapter page
    for i, (start, anchor, filename, title) in enumerate(positions):
        end = positions[i + 1][0] if i + 1 < len(positions) else footer_pos
        content = html[start:end]

        # Fix cross-references
        for aid, fname in anchor_to_file.items():
            if fname != filename:
                content = content.replace(f'href="#{aid}"', f'href="{fname}#{aid}"')

        prev_ch = positions[i - 1] if i > 0 else None
        next_ch = positions[i + 1] if i + 1 < len(positions) else None
        nav = make_nav(prev_ch, next_ch)

        ch_title = f"{title} — 精通以太坊 Mastering Ethereum 繁體中文版"
        ch_desc = f"精通以太坊：{title}。以太坊完整技術指南繁體中文版，免費線上閱讀。"
        ch_url = f"{base_url}/{filename}"

        ch_head = head
        ch_head = re.sub(r"<title>[^<]*</title>", f"<title>{ch_title}</title>", ch_head)
        # Remove existing canonical (will add chapter-specific one)
        ch_head = re.sub(r'<link rel="canonical"[^>]*>', '', ch_head)
        ch_head += f'\n<link rel="canonical" href="{ch_url}">'
        ch_head += f'\n<meta name="description" content="{ch_desc}">'

        page = f"""<!DOCTYPE html>
<html lang="zh-Hant">
<head>
{ch_head}
{NAV_CSS}
</head>
<body class="book">
<div id="header">
<h1><a href="index.html" style="color:inherit;text-decoration:none">精通以太坊 Mastering Ethereum 繁體中文版</a></h1>
</div>
<div id="content">
{nav}
{content}
{nav}
</div>
{footer}
</body>
</html>"""

        with open(os.path.join(output_dir, filename), "w", encoding="utf-8") as f:
            f.write(page)
        print(f"  {filename}: {title}")

    # Rename original to all.html
    os.rename(book_path, os.path.join(output_dir, "all.html"))
    print("  all.html: Single-page version")

    # Generate index.html
    toc_items = "\n".join(
        f'    <li><a href="{fn}">{title}</a></li>'
        for _, _, fn, title in positions
    )

    index_html = f"""<!DOCTYPE html>
<html lang="zh-Hant">
<head>
{head}
<style>
.landing{{max-width:880px;margin:0 auto;padding:2rem 1.5rem}}
.landing-header{{text-align:center;margin-bottom:2rem}}
.landing-header h1{{font-size:2.2rem;color:#1a252f;margin-bottom:0.3rem}}
.landing-header .subtitle{{color:#555;font-size:1.15rem}}
.landing-header .author{{color:#888;margin-top:0.5rem;font-size:0.95rem}}
.landing-cover{{text-align:center;margin:2rem 0}}
.landing-cover img{{max-width:280px;border-radius:8px;box-shadow:0 4px 20px rgba(0,0,0,0.12)}}
.landing-dl{{display:flex;justify-content:center;gap:1rem;margin:2rem 0;flex-wrap:wrap}}
.landing-dl a{{display:inline-block;padding:0.7rem 1.5rem;border-radius:6px;text-decoration:none;font-weight:600;font-size:0.95rem;transition:opacity 0.2s}}
.landing-dl a:hover{{opacity:0.85}}
.btn-p{{background:#2980b9;color:#fff}}
.btn-s{{background:#f0f3f6;color:#2c3e50;border:1px solid #e1e4e8}}
.landing-toc{{margin:2.5rem 0}}
.landing-toc h2{{font-size:1.4rem;color:#1a252f;border-bottom:2px solid #e1e4e8;padding-bottom:0.4rem}}
.landing-toc ol{{padding-left:1.5rem;line-height:2.2}}
.landing-toc a{{color:#2980b9;text-decoration:none;font-size:1.05rem}}
.landing-toc a:hover{{text-decoration:underline}}
.landing-ft{{color:#888;font-size:0.85rem;text-align:center;margin-top:2rem;padding-top:1rem;border-top:1px solid #e1e4e8}}
.landing-all{{text-align:center;margin:1.5rem 0}}
.landing-all a{{color:#888;font-size:0.9rem}}
</style>
</head>
<body>
<div class="landing">
  <div class="landing-header">
    <h1>精通以太坊</h1>
    <div class="subtitle">Mastering Ethereum — 繁體中文完整版</div>
    <p class="author">Andreas M. Antonopoulos &amp; Dr. Gavin Wood 著 · Dr. Awesome Doge 譯</p>
  </div>
  <div class="landing-cover">
    <img src="images/cover.png" alt="Mastering Ethereum 封面" width="280" height="368" />
  </div>
  <div class="landing-dl">
    <a href="https://github.com/awesome-doge/ethereumbook_zh/releases/latest/download/Mastering-Ethereum-Traditional-Chinese.pdf" class="btn-p">下載 PDF</a>
    <a href="https://github.com/awesome-doge/ethereumbook_zh/releases/latest/download/Mastering-Ethereum-Traditional-Chinese.epub" class="btn-p">下載 EPUB</a>
    <a href="https://github.com/awesome-doge/ethereumbook_zh" class="btn-s">GitHub</a>
  </div>
  <div class="landing-toc">
    <h2>目錄</h2>
    <ol>
{toc_items}
    </ol>
  </div>
  <div class="landing-all">
    <a href="all.html">單頁完整版（適合搜尋和列印）</a>
  </div>
  <div class="landing-ft">
    以 <a href="https://creativecommons.org/licenses/by-nc-nd/4.0/">CC BY-NC-ND 4.0</a> 授權釋出
  </div>
</div>
{footer}
</body>
</html>"""

    with open(os.path.join(output_dir, "index.html"), "w", encoding="utf-8") as f:
        f.write(index_html)
    print("  index.html: Landing page")

    # Generate sitemap.xml
    today = date.today().isoformat()
    urls = [f'  <url><loc>{base_url}/</loc><lastmod>{today}</lastmod><priority>1.0</priority></url>']
    urls.append(f'  <url><loc>{base_url}/all.html</loc><lastmod>{today}</lastmod><priority>0.5</priority></url>')
    for _, _, fn, _ in positions:
        urls.append(f'  <url><loc>{base_url}/{fn}</loc><lastmod>{today}</lastmod><priority>0.8</priority></url>')

    sitemap = '<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'
    sitemap += "\n".join(urls)
    sitemap += "\n</urlset>\n"

    with open(os.path.join(output_dir, "sitemap.xml"), "w", encoding="utf-8") as f:
        f.write(sitemap)
    print(f"  sitemap.xml: {len(urls)} URLs")


if __name__ == "__main__":
    main()
