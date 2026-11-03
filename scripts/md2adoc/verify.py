"""md2adoc 驗收：逐章比對上游 Markdown 與轉換、渲染後的 HTML。

用法：
  ruby scripts/md2adoc.rb upstream build/2nd-en
  (cd build/2nd-en && asciidoctor --failure-level WARN -o ../2nd-en.html book.adoc)
  python3 scripts/md2adoc/verify.py upstream build/2nd-en build/2nd-en.html

比對項目：各層級標題、程式碼區塊（內容逐字，忽略行尾空白）、表格與表格標題、圖片、圖說、範例、
Note/Tip/Warning 提示、註腳、公式；並確認 md2adoc 指定的每個標題 ID 都出現在 HTML 中。
任何一項不符就以非零狀態結束。"""
import re, sys, html, json, subprocess, collections

up, build, page = sys.argv[1], sys.argv[2], sys.argv[3]
files = re.findall(r'\]\(\./(\w+\.md)\)', open(f'{up}/SUMMARY.md').read())
files = [f for f in files if f != 'intro.md']
H = open(page, encoding='utf-8').read()

def md_counts(path):
    ast = json.loads(subprocess.run(['pandoc', '-f', 'gfm-tex_math_dollars', '-t', 'json', path], capture_output=True, text=True).stdout)
    c = collections.Counter(); codes = []
    def text(x):
        if isinstance(x, dict):
            t = x.get('t')
            if t == 'Str': return x['c']
            if t in ('Space', 'SoftBreak'): return ' '
            return text(x.get('c'))
        if isinstance(x, list): return ''.join(text(y) for y in x)
        return ''
    def walk(blocks, quote=False):
        prev = None
        for b in blocks:
            t = b['t']
            if t == 'Header':
                lvl = b['c'][0]; tx = text(b['c'][2])
                if re.match(r'(Example) \d+-\d+\.', tx): c['example'] += 1
                else: c[f'h{lvl}'] += 1
            elif t == 'CodeBlock': c['code'] += 1; codes.append(b['c'][1].rstrip('\n'))
            elif t == 'Table': c['table'] += 1
            elif t == 'BlockQuote':
                first = b['c'][0] if b['c'] else None
                if first and first['t'] == 'Para' and first['c'] and first['c'][0]['t'] == 'Strong' and text(first['c'][0]) in ('Note', 'Tip', 'Warning'):
                    c['adm_' + text(first['c'][0]).lower()] += 1
                walk(b['c'], True)
            elif t in ('Para', 'Plain'):
                tx = text(b['c'])
                if re.match(r'Figure \d+-\d+\. ', tx) and prev and prev['t'] in ('Para', 'Plain') and len(prev['c']) == 1 and prev['c'][0]['t'] == 'Image':
                    c['figcap'] += 1
                if len(b['c']) == 1 and b['c'][0]['t'] == 'Strong' and re.match(r'Example \d+-\d+\.', tx): c['example'] += 1
                if len(b['c']) == 1 and b['c'][0]['t'] == 'Strong' and re.match(r'Table \d+-\d+\.', tx): c['tabcap'] += 1
            elif t == 'BulletList' or t == 'OrderedList':
                items = b['c'] if t == 'BulletList' else b['c'][1]
                for it in items: walk(it, quote)
            prev = b
    walk(ast['blocks'])
    s = json.dumps(ast)
    c['image'] = s.count('"t": "Image"')
    c['footnote'] = s.count('"t": "Note"')
    raw = open(path, encoding='utf-8').read()
    c['math'] = len(re.findall(r'<math\b', raw))
    return c, codes

def html_counts(frag):
    c = collections.Counter()
    for lvl in range(2, 7):
        c[f'h{lvl - 1}'] = len(re.findall(rf'<h{lvl}[ >]', frag))
    c['code'] = len(re.findall(r'<div class="(?:listingblock|literalblock)', frag))
    c['table'] = len(re.findall(r'<table class="tableblock', frag))
    c['tabcap'] = len(re.findall(r'<caption class="title">', frag))
    for k in ('note', 'tip', 'warning'):
        c['adm_' + k] = len(re.findall(rf'<div class="admonitionblock {k}">', frag))
    c['image'] = len(re.findall(r'<img ', frag))
    c['figcap'] = len(re.findall(r'<div class="imageblock">\s*<div class="content">.*?</div>\s*<div class="title">', frag, re.S))
    c['example'] = len(re.findall(r'<div class="exampleblock">', frag))
    c['footnote'] = len(re.findall(r'<sup class="footnote"', frag))
    c['math'] = len(re.findall(r'\\\(|\\\[', frag))
    codes = [html.unescape(re.sub(r'<[^>]+>', '', m)).rstrip('\n')
             for m in re.findall(r'<pre[^>]*>(?:<code[^>]*>)?(.*?)(?:</code>)?</pre>', frag, re.S)]
    return c, codes

# split rendered book by chapter section
starts = [(m.start(), m.group(1)) for m in re.finditer(r'<div class="sect1">\s*<h2 id="([^"]+)"', H)]
frags = {}
for i, (pos, cid) in enumerate(starts):
    end = starts[i + 1][0] if i + 1 < len(starts) else H.find('<div id="footer"')
    frags[cid] = H[pos:end]
# footnotes render at end of book; count refs only (already in frag)

keys = ['h1', 'h2', 'h3', 'h4', 'h5', 'code', 'table', 'tabcap', 'image', 'figcap', 'example', 'adm_note', 'adm_tip', 'adm_warning', 'footnote', 'math']
bad = 0; totals = collections.Counter(); code_bad = 0
for f in files:
    cid = 'preface-chap' if f == 'preface.md' else 'ch%02d' % int(re.search(r'\d+', f).group())
    mc, mcode = md_counts(f'{up}/{f}')
    hc, hcode = html_counts(frags.get(cid, ''))
    diffs = [f'{k}:{mc[k]}/{hc[k]}' for k in keys if mc[k] != hc[k]]
    totals.update(mc)
    norm = lambda t: '\n'.join(l.rstrip() for l in t.split('\n'))
    hset = {norm(c) for c in hcode}
    missing = [c for c in mcode if norm(c) not in hset]
    code_bad += len(missing)
    if diffs or missing:
        bad += 1
        print(f'{f:15} DIFF md/html  ' + ' '.join(diffs) + (f'  code-mismatch:{len(missing)}' if missing else ''))
        for m in missing[:2]: print('   missing code:', repr(m[:120]))
import glob, os
ids_dir = os.path.join(build, 'ids')
want = [e['id'] for p in glob.glob(ids_dir + '/*.md.json') for e in json.load(open(p))]
have = set(re.findall(r' id="([^"]+)"', H))
lost = [i for i in want if i not in have]
print('heading ids assigned:', len(want), ' missing in html:', len(lost), lost[:5])
print('TOTAL md:', {k: totals[k] for k in keys})
print('chapters with diffs:', bad, ' code blocks not byte-identical:', code_bad)
if bad or code_bad or lost:
    sys.exit(1)
