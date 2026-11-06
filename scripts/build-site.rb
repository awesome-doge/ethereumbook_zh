#!/usr/bin/env ruby
# frozen_string_literal: true

# 建置線上閱讀網站：每章一個獨立頁面，加上首頁、404、sitemap 與全書搜尋索引。
#
# 用法：ruby scripts/build-site.rb [輸出目錄，預設 public]
#         一次建出整個網站：第二版在輸出目錄根部，2018 草稿譯本在 <輸出目錄>/2018/，
#         根部另有舊網址（/ch08.html、/all.html…）的轉址頁，sitemap 合併兩本書
#       BOOK=2nd ruby scripts/build-site.rb build/2nd            # 只建第二版
#       BOOK=2018 BASE= ruby scripts/build-site.rb build/2018    # 只建 2018 版，網址不加 /2018
#       PREVIEW=1 BOOK=2nd ruby scripts/build-site.rb build/2nd  # 不公開預覽：全站 noindex、不載入 GA
#
# 兩本書：
#   2nd：主站，網址基底為空（/、/chapters/<slug>.html）。先以 scripts/md2adoc.rb 把 zh-tw/
#        （還沒翻譯的章節用 upstream/ 英文原稿）轉成 AsciiDoc
#   2018：封存的 2018 草稿譯本，原稿在 2018/，網址基底 /2018（/2018/、/2018/<slug>.html）
#
# 網址基底（BASE）加在所有站內絕對路徑前：頁面、/assets/、圖片、favicon、manifest、搜尋索引、ids.json、
# sitemap 與 canonical；site.js 從 <html data-base> 讀取。
#
# 流程：
#   1. 以 Asciidoctor 載入整本 book.asciidoc（交叉引用因此能在全書範圍解析）
#   2. 逐章轉成 HTML 片段，記錄每章用到的註腳
#   3. 收集每頁的所有 id，將跨章的 #錨點 連結改寫為 /<slug>.html#錨點
#   4. 套用 web/templates 的版型輸出頁面，並產生 sitemap、搜尋索引與靜態檔
#
# 2018 版的網址與錨點沿用舊版分頁網站（/ch08.html#_xxx → /2018/ch08.html#_xxx），id 也保留 Asciidoctor
# 預設的 _ 前綴；舊網址由根部的轉址頁帶著 #錨點 轉過去，既有連結不會失效。

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require 'asciidoctor'
require 'nokogiri'
require 'erb'
require 'json'
require 'yaml'
require 'fileutils'
require 'digest'
require 'time'
require 'cgi'
require 'set'

require 'tmpdir'

ROOT = File.expand_path('..', __dir__)
OUT = File.expand_path(ARGV[0] || 'public', ROOT)
WEB = File.join(ROOT, 'web')

SITE_URL = 'https://mastering-ethereum.doge.tg'
REPO_URL = 'https://github.com/awesome-doge/ethereumbook_zh'
# 2018 版電子書凍結在最後一次 release；不能用 releases/latest，第二版發布後 latest 就不再是 2018 版
RELEASES_2018_URL = "#{REPO_URL}/releases/download/v2.0.0"
ORIGINAL_URL = 'https://github.com/ethereumbook/ethereumbook'
SECOND_EDITION_URL = 'https://masteringethereum.xyz'
# IndexNow（Bing、Yandex、Naver、Seznam 等共用的即時收錄通知）的金鑰。金鑰本來就要公開放在網站根部，不是密碼；
# scripts/indexnow.rb 用同一把金鑰送出網址
INDEXNOW_KEY = 'f754010eab71705805b3e144bbdef1dd'

BOOKS = {
  '2018' => {
    site_name: '精通以太坊繁體中文版', book_title: '精通以太坊', book_full_title: '精通以太坊：打造智能合約與 DApp',
    authors: ['Andreas M. Antonopoulos', 'Gavin Wood'],
    credit: '原著《Mastering Ethereum》由 Andreas M. Antonopoulos 與 Gavin Wood 撰寫，O\'Reilly Media 出版。',
    license_name: 'CC BY-NC-ND 4.0', license_url: 'https://creativecommons.org/licenses/by-nc-nd/4.0/',
    epub: "#{RELEASES_2018_URL}/Mastering-Ethereum-Traditional-Chinese.epub",
    pdf: "#{RELEASES_2018_URL}/Mastering-Ethereum-Traditional-Chinese.pdf",
    og_image: '/assets/og-cover.png',
    chapters: 'chapters.yml', home: 'home', path_prefix: '/', images_root: File.join(ROOT, '2018'),
    base: '/2018', legacy: true, ga: 'G-ZVVQYEKMPF',
    original_name: 'Mastering Ethereum: Building Smart Contracts and DApps',
    alternate_names: ['Mastering Ethereum: Building Smart Contracts and DApps', '精通以太坊 Mastering Ethereum'],
    # 首頁標題標明是 2018 草稿譯本，讓「精通以太坊」這類搜尋落在第二版首頁，而不是這裡
    home_title: '精通以太坊 2018 草稿譯本（第一版）繁體中文版',
    description: '《精通以太坊》（Mastering Ethereum）2018 年草稿的繁體中文全文，內容已過時，第二版譯本見本站首頁。' \
                 '從密鑰、地址、錢包與交易，到智能合約、Solidity、Vyper、代幣、DApp、預言機、EVM 與共識，完整解說以太坊的技術原理。'
  },
  '2nd' => {
    site_name: '精通以太坊第二版繁體中文版', book_title: '精通以太坊（第二版）', book_full_title: '精通以太坊（第二版）',
    authors: ['Andreas M. Antonopoulos', 'Gavin Wood', 'Carlo Parisi', 'Alessandro Mazza', 'Niccolò Pozzolini'],
    credit: '原著《Mastering Ethereum》第二版由 Andreas M. Antonopoulos、Gavin Wood、Carlo Parisi、Alessandro Mazza 與 ' \
            'Niccolò Pozzolini 撰寫，O\'Reilly Media 出版。',
    # 上游條款：出版後 12 個月內為 CC BY-NC-ND 4.0，期滿轉為 CC BY-SA 4.0。上游正式公告轉換之前，譯本照原書現行條款標示
    license_name: 'CC BY-NC-ND 4.0', license_url: 'https://creativecommons.org/licenses/by-nc-nd/4.0/',
    license_note: '（原書出版 12 個月後轉為 CC BY-SA 4.0，本譯本屆時隨之更新）',
    # 第二版電子書由 ebook.yml 在推送 v* tag 時發布；第二版是最新的版本，用 releases/latest 跟著最新一次 release
    epub: "#{REPO_URL}/releases/latest/download/Mastering-Ethereum-2nd-Traditional-Chinese.epub",
    pdf: "#{REPO_URL}/releases/latest/download/Mastering-Ethereum-2nd-Traditional-Chinese.pdf",
    og_image: '/assets/og-cover-2nd.png',   # 第二版沒有封面圖，用 scripts/og/make-og-2nd.py 產生的文字版面
    chapters: 'chapters-2nd.yml', home: 'home-2nd', path_prefix: '/chapters/', images_root: File.join(ROOT, 'upstream'),
    base: '', legacy: false, ga: 'G-ZVVQYEKMPF',
    original_name: 'Mastering Ethereum, 2nd Edition',
    alternate_names: ['Mastering Ethereum, 2nd Edition', '精通以太坊第二版'],
    # 首頁標題與描述帶上「PDF／EPUB 下載」：「精通以太坊 pdf」是這本書最常見的搜尋之一
    home_title: '精通以太坊（第二版）繁體中文版｜免費線上閱讀與 PDF、EPUB 下載',
    description: '《精通以太坊》（Mastering Ethereum）第二版繁體中文譯本，免費線上閱讀，也提供 PDF 與 EPUB 電子書下載。' \
                 '從密碼學、錢包與交易，到智能合約（Solidity、Vyper）與安全、代幣、DeFi、EVM、權益證明、擴容與零知識證明。'
  }
}.freeze

ARCHIVE_2018 = "#{BOOKS['2018'][:base]}/"   # 2018 草稿譯本封存處，第二版首頁與 llms.txt 會連過去

BOOK = ENV['BOOK'] || 'all'

def h(str) = CGI.escapeHTML(str.to_s)
def plain(html) = Nokogiri::HTML5.fragment(html.to_s).text.gsub(/\s+/, ' ').strip

# ---------------------------------------------------------------------------
# 0. 整個網站：第二版建在根部（它會先清空輸出目錄），再把 2018 版建到 2018/，最後加上舊網址轉址頁與合併的 sitemap
# ---------------------------------------------------------------------------

if BOOK == 'all'
  build = lambda do |book, base, out, extra = {}|
    env = ENV.to_h.merge('BOOK' => book, 'BASE' => base, 'WRITE_CNAME' => nil).merge(extra)
    system(env, RbConfig.ruby, __FILE__, out, exception: true)
  end
  build.call('2nd', '', OUT, 'LINK_2018' => '1')
  build.call('2018', BOOKS['2018'][:base], File.join(OUT, BOOKS['2018'][:base]))

  # 舊網址轉址頁：/ch08.html#錨點 → /2018/ch08.html#錨點。GitHub Pages 沒有伺服器端轉址，
  # 用 canonical、meta refresh（不支援 JS 時）加上保留 #錨點 的 JS。不加 noindex：Google 把立即的 meta refresh
  # 當成永久轉址，noindex 與 canonical 同時出現反而是互相矛盾的訊號。
  # /all.html 是舊站曝光最多的網址（搜尋「精通以太坊」），轉到第二版首頁；canonical 與 meta refresh 必須指向同一頁，
  # 否則 Google 會無所適從。只有帶 #錨點 的舊連結才轉到 /2018/all.html#錨點，再由 site.js 依 2018 版的 ids.json 轉到對應章節。
  redirect = ERB.new(File.read(File.join(WEB, 'templates', 'redirect.html.erb')), trim_mode: '-')
  hash_target = nil
  YAML.load_file(File.join(WEB, BOOKS['2018'][:chapters])).each do |c|
    target = "#{BOOKS['2018'][:base]}/#{c['slug']}.html"
    canonical = SITE_URL + target
    File.write(File.join(OUT, "#{c['slug']}.html"), redirect.result(binding))
  end
  target = '/'
  hash_target = "#{BOOKS['2018'][:base]}/all.html"
  canonical = "#{SITE_URL}/"
  File.write(File.join(OUT, 'all.html'), redirect.result(binding))

  # 社群平台快取裡的舊分享圖網址
  FileUtils.mkdir_p(File.join(OUT, 'images'))
  FileUtils.cp(File.join(ROOT, '2018', 'images', 'cover.png'), File.join(OUT, 'images', 'cover.png'))

  # 合併 sitemap：第二版在前，2018 版在後（2018/sitemap.xml 也保留）
  urls = [OUT, File.join(OUT, BOOKS['2018'][:base])].flat_map do |dir|
    File.read(File.join(dir, 'sitemap.xml')).scan(%r{^\s*<url>.*</url>$})
  end
  File.write(File.join(OUT, 'sitemap.xml'),
             %(<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n) +
             urls.map { |u| "  #{u.strip}\n" }.join + "</urlset>\n")
  File.write(File.join(OUT, 'CNAME'), "mastering-ethereum.doge.tg\n") if ENV['WRITE_CNAME']
  puts "完成：整個網站（第二版在根部、2018 版在 #{ARCHIVE_2018}、#{YAML.load_file(File.join(WEB, BOOKS['2018'][:chapters])).size + 1} 個舊網址轉址頁、sitemap #{urls.size} 個網址）→ #{OUT}"
  exit
end

PROFILE = BOOKS.fetch(BOOK) { abort "BOOK 只能是 all、#{BOOKS.keys.join(' 或 ')}" }
BASE = ENV.fetch('BASE', PROFILE[:base])
abort "BASE 必須是空字串或以 / 開頭、不以 / 結尾，例如 /2018（目前是 #{BASE.inspect}）" unless BASE.empty? || BASE.match?(%r{\A/[^/].*[^/]\z|\A/[^/]\z})
HOME_PATH = "#{BASE}/"
HOME_URL = SITE_URL + HOME_PATH
SITE_NAME = PROFILE[:site_name]
BOOK_TITLE = PROFILE[:book_title]
BOOK_FULL_TITLE = PROFILE[:book_full_title]
OG_IMAGE = PROFILE[:og_image]
AUTHORS = PROFILE[:authors]
CREDIT = PROFILE[:credit]
EPUB_URL = PROFILE[:epub]
PDF_URL = PROFILE[:pdf]
LICENSE_NAME = PROFILE[:license_name]
LICENSE_URL = PROFILE[:license_url]
LICENSE_NOTE = PROFILE[:license_note].to_s
PREVIEW = ENV['PREVIEW'] == '1'  # 不公開預覽：全站 noindex、robots 拒絕索引、sitemap 不列網址、不載入 GA
GA_ID = PREVIEW ? nil : PROFILE[:ga]
PATH_PREFIX = PROFILE[:path_prefix]
IMAGES_ROOT = PROFILE[:images_root]
LEGACY_2018 = PROFILE[:legacy]   # 2018 草稿譯本專用：過時提示、/all.html、舊分享圖
# 2018 版封存在 /2018/ 時，過時提示連到根部的第二版首頁
SECOND_EDITION_HOME = LEGACY_2018 && !BASE.empty? ? '/' : nil
# 整站建置時第二版首頁連到 2018 版封存處，舊單頁網站的 /#錨點 也改查 2018 版的 ids.json
LINK_2018 = !LEGACY_2018 && ENV['LINK_2018'] == '1'

# 最後一次 commit 的時間。2018 版原稿搬到 2018/ 的那次改名不算（--follow 往前找搬移前的紀錄），lastmod 因此不變
def git_date(path)
  log = `git -C #{ROOT} log -2 --follow --format=%x00%cI --name-status -- '#{path}' 2>/dev/null`
  entry = log.split("\0").reject(&:empty?).find { |e| e !~ %r{^R100\t(\S+)\t2018/\1$} }
  entry ? entry.lines.first.strip : Time.now.iso8601
end

# 粗估閱讀時間：中文每分鐘約 400 字，英文每分鐘約 200 詞
def reading_minutes(text)
  cjk = text.scan(/\p{Han}/).size
  words = text.gsub(/\p{Han}/, ' ').scan(/[A-Za-z0-9]+/).size
  [(cjk / 400.0 + words / 200.0).ceil, 1].max
end

def png_size(path)
  data = File.binread(path, 24)
  return nil unless data && data[0, 8] == "\x89PNG\r\n\x1a\n".b

  data[16, 8].unpack('NN')
end

# ---------------------------------------------------------------------------
# 1. 載入全書
# ---------------------------------------------------------------------------

book_file =
  if BOOK == '2nd'
    tmp = Dir.mktmpdir('md2adoc')
    at_exit { FileUtils.rm_rf(tmp) }
    # 一律用譯稿模式（中文的圖表標題與章節標籤）；zh-tw/ 還沒有的章節，md2adoc 會改用英文原稿
    system('ruby', File.join(ROOT, 'scripts', 'md2adoc.rb'), File.join(ROOT, 'zh-tw'), tmp,
           '--ref', File.join(ROOT, 'upstream'), exception: true)
    File.join(tmp, 'book.adoc')
  else
    File.join(ROOT, '2018', 'book.asciidoc')
  end

doc = Asciidoctor.load_file(
  book_file,
  safe: :unsafe,
  standalone: false,
  sourcemap: true,
  attributes: {
    'imagesdir' => HOME_PATH,   # 圖片網址為 <基底>/images/…
    'source-highlighter' => 'rouge',
    'rouge-css' => 'class',
    'sectanchors' => '',
    'experimental' => '',
    'lang' => 'zh-TW'
  }
)

config = YAML.load_file(File.join(WEB, PROFILE[:chapters]))
config_by_id = config.to_h { |c| [c['id'], c] }
sections = doc.sections.reject { |s| s.sectname == 'index' }

unknown = sections.map(&:id) - config_by_id.keys
missing = config_by_id.keys - sections.map(&:id)
abort "#{PROFILE[:chapters]} 缺少章節 ID：#{unknown.join(', ')}" unless unknown.empty?
abort "#{PROFILE[:chapters]} 有不存在的章節 ID：#{missing.join(', ')}" unless missing.empty?

Page = Struct.new(:id, :slug, :label, :title, :title_html, :description, :source, :html,
                  :toc, :footnotes, :ids, :minutes, :search, :lastmod, :prev, :next, :has_math, :translated,
                  :second_edition,
                  keyword_init: true) do
  def file = "#{PATH_PREFIX}#{slug}.html"   # 相對於輸出目錄
  def path = BASE + file
  def url = SITE_URL + path
  def full_title = label == title ? title : "#{label}　#{title}"
end

chapter_no = 0
pages = sections.map do |sec|
  cfg = config_by_id.fetch(sec.id)
  label =
    case sec.sectname
    when 'preface' then '前言'
    when 'appendix' then "附錄 #{sec.numeral}"
    else "第 #{chapter_no += 1} 章"
    end

  before = doc.footnotes.size
  html = sec.convert
  footnotes = doc.footnotes[before..] || []

  source = sec.source_location&.file && File.basename(sec.source_location.file)
  translated = true
  if BOOK == '2nd' && source
    # 產生的 .adoc 在暫存目錄；對應回譯稿（或尚未翻譯時的英文原稿），供編輯連結與 lastmod 使用
    md = source.sub(/\.adoc\z/, '.md')
    translated = File.exist?(File.join(ROOT, 'zh-tw', md))
    source = translated ? "zh-tw/#{md}" : "upstream/#{md}"
  elsif source
    source = "2018/#{source}"
  end
  Page.new(
    id: sec.id, slug: cfg['slug'], label: cfg['label'] || label,
    title: cfg['title'] || plain(sec.title), title_html: cfg['title'] || sec.title,
    description: cfg['description'], source: source, translated: translated,
    html: html, footnotes: footnotes, second_edition: cfg['second_edition']
  )
end
pages.each_cons(2) { |a, b| a.next = b; b.prev = a }

# ---------------------------------------------------------------------------
# 2. 解析每章片段：移除章標題、調整標題層級、收集 id
# ---------------------------------------------------------------------------

frags = {}
id_to_page = {}

pages.each do |page|
  frag = Nokogiri::HTML5.fragment(page.html)
  sect1 = frag.at_css('div.sect1') or abort "#{page.id}: 找不到 div.sect1"
  sect1.at_css('> h2')&.remove

  # 每頁只保留一個 h1（章標題由版型輸出），內文標題整體升一級
  frag.css('h3, h4, h5, h6').each { |hd| hd.name = "h#{hd.name[1].to_i - 1}" }

  frag.css('[id]').each do |el|
    id = el['id']

    warn "重複的 id：#{id}（#{page.slug} 與 #{id_to_page[id].slug}）" if id_to_page[id] && id_to_page[id] != page
    id_to_page[id] = page
  end
  id_to_page[page.id] = page

  # 註腳放在各章結尾（Asciidoctor 預設集中在整本書最後）
  unless page.footnotes.empty?
    items = page.footnotes.map do |fn|
      id_to_page["_footnotedef_#{fn.index}"] = page
      %(<li id="_footnotedef_#{fn.index}" value="#{fn.index}">#{fn.text} ) +
        %(<a class="fn-back" href="#_footnoteref_#{fn.index}" aria-label="返回內文">↩</a></li>)
    end
    frag.add_child(%(<section class="footnotes" aria-labelledby="footnotes-title">) +
                   %(<h2 id="footnotes-title">註腳</h2><ol>#{items.join}</ol></section>))
  end
  frags[page] = frag
end

# ---------------------------------------------------------------------------
# 3. 改寫連結、圖片與表格，產生本章目錄與搜尋資料
# ---------------------------------------------------------------------------

FileUtils.rm_rf(OUT)
FileUtils.mkdir_p(File.join(OUT, 'images'))
FileUtils.mkdir_p(File.join(OUT, 'assets'))
FileUtils.mkdir_p(File.join(OUT, PATH_PREFIX))

webp = system('command -v cwebp >/dev/null 2>&1')
warn '找不到 cwebp，圖片將只輸出 PNG' unless webp
used_images = {}
broken_links = []

pages.each do |page|
  frag = frags[page]

  frag.css('a[href^="#"]').each do |a|
    target = CGI.unescape(a['href'][1..])
    next if target.empty?

    dest = id_to_page[target]
    if dest.nil?
      broken_links << "#{page.slug} → ##{target}"
    elsif dest != page
      a['href'] = dest.id == target ? dest.path : "#{dest.path}##{target}"
    end
  end

  frag.css('a.anchor').each { |a| a['aria-label'] = '本節連結' }
  frag.css('a.footnote').each { |a| a['title'] = '查看註腳' }

  frag.css('a[href^="http"]').each do |a|
    next if a['href'].start_with?(SITE_URL)

    a['rel'] = 'noopener'
    a['target'] = '_blank'
  end

  frag.css('img').each do |img|
    src = img['src'].to_s
    next unless src.start_with?("#{BASE}/images/")

    rel = src.delete_prefix(BASE)   # 相對於輸出目錄與 IMAGES_ROOT 的路徑
    file = File.join(IMAGES_ROOT, rel)
    abort "#{page.slug}: 圖片不存在 #{src}" unless File.exist?(file)
    used_images[rel] = file
    if (dims = png_size(file))
      img['width'], img['height'] = dims.map(&:to_s)
    end
    img['loading'] = 'lazy'
    img['decoding'] = 'async'
    next unless webp && src.end_with?('.png')

    picture = Nokogiri::XML::Node.new('picture', frag.document)
    source = Nokogiri::XML::Node.new('source', frag.document)
    source['type'] = 'image/webp'
    source['srcset'] = src.sub(/\.png\z/, '.webp')
    img.replace(picture)
    picture.add_child(source)
    picture.add_child(img)
  end

  frag.css('table').each do |table|
    next if table.parent['class'].to_s.include?('admonitionblock')

    # 含長串英數字（十六進位、地址、金鑰）的儲存格在手機上可任意斷行，其餘照單字換行
    table.css('td').each do |td|
      td['class'] = [td['class'], 'long-token'].compact.join(' ') if td.text =~ /[\x21-\x7e]{20,}/
    end

    wrap = Nokogiri::XML::Node.new('div', frag.document)
    wrap['class'] = 'table-wrap'
    wrap['tabindex'] = '0'
    table.replace(wrap)
    wrap.add_child(table)
  end

  frag.css('math[display="block"]').each do |math|
    wrap = Nokogiri::XML::Node.new('div', frag.document)
    wrap['class'] = 'math-wrap'
    math.replace(wrap)
    wrap.add_child(math)
  end

  # 圖、表、範例改為各章獨立編號（例如「圖 4-1」），與印刷版一致；內文的交叉引用使用標題文字，不受影響
  if (num = page.label[/\A第 (\d+) 章\z/, 1] || page.label[/\A附錄 (\w+)\z/, 1])
    counters = Hash.new(0)
    frag.css('.imageblock > .title, .exampleblock > .title, table.tableblock > caption.title').each do |t|
      t.inner_html = t.inner_html.sub(/\A(圖|表|範例) \d+\./) { "#{$1} #{num}-#{counters[$1] += 1}." }
    end
  end

  page.has_math = frag.at_css('.stemblock') || frag.to_html.include?('\\(')

  # 本章目錄（第二層標題）
  page.toc = frag.css('div.sect2 > h2').map do |hd|
    { id: hd['id'], title: hd.children.reject { |c| c['class'] == 'anchor' }.map(&:text).join.strip }
  end

  # 搜尋索引：章首段落、每個小節的開頭，以及每個次小節各一筆，搜尋結果可直接跳到最接近的標題
  own_text = lambda do |node, skip|
    node.children.reject { |c| c.element? && c['class'].to_s.split.include?(skip) }
        .map(&:text).join(' ').gsub(/\s+/, ' ').strip
  end
  heading_text = ->(hd) { hd.children.reject { |c| c['class'] == 'anchor' }.map(&:text).join.strip }
  entries = []
  body = frag.at_css('div.sectionbody')
  entries << { t: page.title, u: page.path, x: body ? own_text.call(body, 'sect2') : '' }
  frag.css('div.sect2').each do |s2|
    hd = s2.at_css('> h2') or next
    s2_title = heading_text.call(hd)
    entries << { t: s2_title, u: "#{page.path}##{hd['id']}", x: own_text.call(s2, 'sect3').sub(s2_title, '').strip }
    s2.css('> div.sect3').each do |s3|
      h3 = s3.at_css('> h3') or next
      s3_title = heading_text.call(h3)
      entries << { t: "#{s2_title} › #{s3_title}", u: "#{page.path}##{h3['id']}",
                   x: s3.text.gsub(/\s+/, ' ').strip.sub(s3_title, '').strip }
    end
  end
  page.search = entries

  text = frag.text
  page.minutes = reading_minutes(text)
  page.ids = frag.css('[id]').map { |e| e['id'] }
  page.lastmod = page.source ? git_date(page.source) : Time.now.iso8601
  page.html = frag.to_html
end

unless broken_links.empty?
  warn "找不到目標的內部連結 #{broken_links.size} 個："
  broken_links.each { |l| warn "  #{l}" }
  abort '內部連結有誤，停止建置' if ENV['STRICT_LINKS']
end

# ---------------------------------------------------------------------------
# 4. 靜態資源
# ---------------------------------------------------------------------------

asset_version = {}
%w[site.css site.js].each do |name|
  src = File.join(WEB, 'assets', name)
  FileUtils.cp(src, File.join(OUT, 'assets', name))
  asset_version[name] = Digest::MD5.file(src).hexdigest[0, 10]
end
Dir.glob(File.join(WEB, 'assets', '*.{png,svg,webp}')).each { |f| FileUtils.cp(f, File.join(OUT, 'assets')) }

ASSET = ->(name) { "#{BASE}/assets/#{name}?v=#{asset_version.fetch(name)}" }

# 程式碼語法高亮配色（亮色與暗色主題）
require 'rouge'
light = Rouge::Themes::Github.mode(:light).render(scope: '.highlight')
dark = Rouge::Themes::Github.mode(:dark).render(scope: ':root[data-theme="dark"] .highlight')
dark_auto = Rouge::Themes::Github.mode(:dark).render(scope: ':root:not([data-theme]) .highlight')
File.write(File.join(OUT, 'assets', 'code.css'),
           "#{light}\n#{dark}\n@media (prefers-color-scheme: dark) {\n#{dark_auto}\n}\n")
asset_version['code.css'] = Digest::MD5.hexdigest(File.read(File.join(OUT, 'assets', 'code.css')))[0, 10]

used_images.each do |src, file|
  dest = File.join(OUT, src)
  FileUtils.mkdir_p(File.dirname(dest))   # 第二版的圖片分章放在 images/chN/
  FileUtils.cp(file, dest)
  system('cwebp', '-quiet', '-q', '85', '-m', '6', file, '-o', dest.sub(/\.png\z/, '.webp')) if webp && src.end_with?('.png')
end

# 舊版網站的分享圖片網址，社群平台的快取可能仍會引用
FileUtils.cp(File.join(ROOT, '2018', 'images', 'cover.png'), File.join(OUT, 'images', 'cover.png')) if LEGACY_2018

Dir.glob(File.join(WEB, 'static', '*'), File::FNM_DOTMATCH).each do |f|
  next if File.directory?(f) || File.basename(f) == 'manifest.webmanifest'

  FileUtils.cp(f, File.join(OUT, File.basename(f)))
  FileUtils.chmod(0o644, File.join(OUT, File.basename(f)))
end

# manifest 的起始網址、範圍與圖示都加上基底：封存在 /2018/ 的 2018 版是獨立的 app，不會開到第二版
manifest = JSON.parse(File.read(File.join(WEB, 'static', 'manifest.webmanifest')))
manifest['name'] = SITE_NAME
manifest['description'] = "《#{BOOK_FULL_TITLE}》繁體中文版，免費線上閱讀。"
manifest['start_url'] = manifest['scope'] = HOME_PATH
manifest['icons'].each { |icon| icon['src'] = BASE + icon['src'] }
File.write(File.join(OUT, 'manifest.webmanifest'), "#{JSON.pretty_generate(manifest)}\n")

# robots.txt 只在網站根部有效
if BASE.empty?
  File.write(File.join(OUT, "#{INDEXNOW_KEY}.txt"), INDEXNOW_KEY)
  File.write(File.join(OUT, 'robots.txt'),
             "# #{SITE_NAME}\n# 全站開放索引（內容以 #{LICENSE_NAME} 授權，轉載請註明出處）。\n\n" \
             "User-agent: *\nAllow: /\n\nSitemap: #{SITE_URL}/sitemap.xml\n")
end

# ---------------------------------------------------------------------------
# 5. 輸出頁面
# ---------------------------------------------------------------------------

def template(name) = ERB.new(File.read(File.join(WEB, 'templates', "#{name}.html.erb")), trim_mode: '-')

LAYOUT = template('layout')
CHAPTER = template('chapter')
HOME = template(PROFILE[:home])
NOT_FOUND = template('404')
EDITION_NOTICE = template('edition-notice')

# 本譯本翻自 2018 年草稿，首頁與各章都標示內容已過時，並指向原書第二版
def edition_notice(compact: false, page: nil) = EDITION_NOTICE.result(binding)

BOOK_LD = {
  '@type' => 'Book',
  '@id' => "#{HOME_URL}#book",
  'name' => BOOK_FULL_TITLE,
  'alternateName' => PROFILE[:alternate_names],
  'author' => AUTHORS.map do |name|
    { '@type' => 'Person', 'name' => name, 'url' => ('https://aantonop.com' if name == 'Andreas M. Antonopoulos') }.compact
  end,
  'translator' => { '@type' => 'Person', 'name' => 'Dr. Awesome Doge' },
  'inLanguage' => 'zh-TW',
  'publisher' => { '@type' => 'Organization', 'name' => "O'Reilly Media" },
  'license' => LICENSE_URL,
  'isAccessibleForFree' => true,
  'url' => HOME_URL,
  'image' => SITE_URL + BASE + OG_IMAGE,
  'translationOfWork' => {
    '@type' => 'Book', 'name' => PROFILE[:original_name], 'inLanguage' => 'en',
    'url' => ORIGINAL_URL
  }
}.compact

def jsonld(obj) = JSON.generate({ '@context' => 'https://schema.org' }.merge(obj)).gsub('</', '<\/')

def render_page(content:, title:, description:, canonical:, og_type: 'article', jsonld: nil,
                current: nil, pages:, body_class: '', noindex: false, has_math: false, toc: [])
  noindex ||= PREVIEW
  LAYOUT.result(binding)
end

home_description = PROFILE[:description]
first_chapter = pages.find { |p| p.label.start_with?('第') }

pages.each do |page|
  content = CHAPTER.result(binding)
  ld = {
    '@graph' => [
      {
        '@type' => 'Chapter',
        '@id' => "#{page.url}#chapter",
        'name' => page.full_title,
        'headline' => "#{page.full_title}｜#{BOOK_TITLE}",
        'description' => page.description,
        'url' => page.url,
        'inLanguage' => 'zh-TW',
        'position' => pages.index(page) + 1,
        'dateModified' => page.lastmod,
        'isPartOf' => { '@id' => "#{HOME_URL}#book" },
        'author' => BOOK_LD['author'],
        'translator' => BOOK_LD['translator'],
        'license' => BOOK_LD['license'],
        'isAccessibleForFree' => true
      },
      BOOK_LD,
      {
        '@type' => 'BreadcrumbList',
        'itemListElement' => [
          { '@type' => 'ListItem', 'position' => 1, 'name' => BOOK_TITLE, 'item' => HOME_URL },
          { '@type' => 'ListItem', 'position' => 2, 'name' => page.full_title, 'item' => page.url }
        ]
      }
    ]
  }
  html = render_page(
    content: content, title: "#{page.full_title}｜#{BOOK_TITLE}繁體中文版", description: page.description,
    canonical: page.url, jsonld: ld, current: page, pages: pages, body_class: 'is-chapter',
    has_math: page.has_math, toc: page.toc
  )
  File.write(File.join(OUT, page.file), html)
end

total_minutes = pages.sum(&:minutes)
home_ld = {
  '@graph' => [
    BOOK_LD.merge('description' => home_description,
                  'hasPart' => pages.map { |p| { '@id' => "#{p.url}#chapter" } }),
    {
      '@type' => 'WebSite', '@id' => "#{HOME_URL}#website", 'url' => HOME_URL, 'name' => SITE_NAME,
      'inLanguage' => 'zh-TW'
    }
  ]
}
File.write(File.join(OUT, 'index.html'), render_page(
  content: HOME.result(binding), title: PROFILE[:home_title], description: home_description,
  canonical: HOME_URL, og_type: 'book', jsonld: home_ld, pages: pages, body_class: 'is-home'
))

File.write(File.join(OUT, '404.html'), render_page(
  content: NOT_FOUND.result(binding), title: "找不到頁面｜#{BOOK_TITLE}", description: home_description,
  canonical: nil, pages: pages, body_class: 'is-404', noindex: true
))

# 舊版的單頁全書 /all.html：保留網址，/all.html#錨點 由 site.js 依 ids.json 轉到對應章節
if LEGACY_2018
  File.write(File.join(OUT, 'all.html'), render_page(
    content: template('legacy').result(binding), title: "單頁版已改為分章閱讀｜#{BOOK_TITLE}", description: home_description,
    canonical: nil, pages: pages, body_class: 'is-legacy', noindex: true
  ))
end

# ---------------------------------------------------------------------------
# 6. sitemap、搜尋索引、舊網址錨點對照、llms-full.txt
# ---------------------------------------------------------------------------

home_lastmod = pages.map(&:lastmod).max
sitemap = +%(<?xml version="1.0" encoding="UTF-8"?>\n)
sitemap << %(<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n)
unless PREVIEW   # 預覽全站 noindex，sitemap 不列網址
  sitemap << "  <url><loc>#{HOME_URL}</loc><lastmod>#{home_lastmod}</lastmod></url>\n"
  pages.each { |p| sitemap << "  <url><loc>#{p.url}</loc><lastmod>#{p.lastmod}</lastmod></url>\n" }
end
sitemap << "</urlset>\n"
File.write(File.join(OUT, 'sitemap.xml'), sitemap)

search = pages.flat_map do |p|
  p.search.map { |e| e.merge(c: p.label == p.title ? p.label : "#{p.label}　#{p.title}") }
end
# 搜尋時把查詢與內文都逐字轉成簡體再比對（一字對一字、長度不變，標示位置仍對得上），簡體字查詢因此也找得到。
# 對照表取自 OpenCC（Apache-2.0，見 web/data/），只輸出書中與同義詞表實際用到的字。
synonyms = YAML.load_file(File.join(WEB, 'search-synonyms.yml'))
used_chars = (JSON.generate(search) + JSON.generate(synonyms)).scan(/\p{Han}/).to_set
t2s = File.foreach(File.join(WEB, 'data', 'opencc-TSCharacters.txt')).filter_map do |line|
  next if line.start_with?('#')
  trad, simp = line.chomp.split("\t")
  simp = simp.to_s.split(' ').first
  "#{trad}#{simp}" if simp && trad != simp && used_chars.include?(trad)
end.join
File.write(File.join(OUT, 'search-index.json'), JSON.generate({ entries: search, t2s: t2s, synonyms: synonyms }))

# 舊版單頁網站的 /#錨點、/all.html#錨點 連結由首頁與單頁版說明頁依此表轉址（值為含基底的完整路徑）
ids = {}
pages.each { |p| p.ids.each { |id| ids[id] = p.path unless id.start_with?('_footnote') } }
pages.each { |p| ids[p.id] = p.path }
File.write(File.join(OUT, 'ids.json'), JSON.generate(ids))

if PREVIEW
  File.write(File.join(OUT, 'robots.txt'), "# 第二版譯稿預覽，尚未公開\nUser-agent: *\nDisallow: /\n")
  puts "完成（預覽）：#{pages.size} 個章節頁面（已翻譯 #{pages.count(&:translated)}）、#{used_images.size} 張圖片 → #{OUT}"
  exit
end

translated_count = pages.count(&:translated)
llms_title = LEGACY_2018 ? "# #{BOOK_FULL_TITLE}（繁體中文版）\n\n" : "# #{BOOK_FULL_TITLE}繁體中文版\n\n"
llms_full = llms_title.dup
llms_full << "> 原著：#{AUTHORS.join('、')}｜翻譯：Dr. Awesome Doge｜授權：#{LICENSE_NAME}\n"
llms_full << "> 線上閱讀：#{HOME_URL}\n"
if LEGACY_2018
  llms_full << "> 注意：本譯本翻自 2018 年的草稿，部分內容已經過時；原書第二版（2025）見 #{SECOND_EDITION_URL}\n\n"
elsif translated_count < pages.size
  llms_full << "> 翻譯進行中：已翻譯 #{translated_count} / #{pages.size} 章，其餘章節暫時是英文原稿\n\n"
else
  llms_full << "\n"
end
pages.each do |p|
  llms_full << "\n## #{p.full_title}\n\n來源：#{p.url}\n\n"
  p.search.each_with_index do |e, i|
    llms_full << "### #{e[:t]}\n\n" if i.positive?
    llms_full << "#{e[:x]}\n\n"
  end
end
File.write(File.join(OUT, 'llms-full.txt'), llms_full)


llms = llms_title.dup
if LEGACY_2018
  llms << "> 《精通以太坊》（Mastering Ethereum: Building Smart Contracts and DApps）的繁體中文全文譯本，" \
          "由 Andreas M. Antonopoulos 與 Gavin Wood 撰寫，O'Reilly Media 出版，Dr. Awesome Doge 翻譯，以 #{LICENSE_NAME} 授權。\n\n"
  llms << "注意：本譯本翻自 2018 年的草稿，測試網、客戶端、開發工具與共識機制等內容已經過時（以太坊已在 2022 年改為權益證明）。" \
          "原書第二版已於 2025 年出版，英文版見 #{SECOND_EDITION_URL} 。\n\n"
  llms << "第二版的繁體中文譯本見 #{SITE_URL}#{SECOND_EDITION_HOME} 。\n\n" if SECOND_EDITION_HOME
else
  llms << "> 《精通以太坊》第二版（#{PROFILE[:original_name]}）的繁體中文譯本，" \
          "由 #{AUTHORS.join('、')} 撰寫，O'Reilly Media 於 2025 年出版，Dr. Awesome Doge 翻譯，以 #{LICENSE_NAME} 授權。\n\n"
  if translated_count < pages.size
    llms << "翻譯進行中：目前已翻譯 #{translated_count} / #{pages.size} 章，其餘章節暫時是英文原稿。\n\n"
  end
  llms << "2018 年草稿（第一版）的舊譯本封存於 #{SITE_URL}#{ARCHIVE_2018} ，內容已過時。\n\n" if LINK_2018
end
llms << "每一章都是獨立頁面；全書純文字版請見 #{HOME_URL}llms-full.txt 。\n\n## 章節\n\n"
pages.each { |p| llms << "- [#{p.full_title}](#{p.url})：#{p.description}\n" }
llms << "\n## 其他\n\n"
llms << "- [PDF 電子書下載](#{PDF_URL})\n" if PDF_URL
llms << "- [EPUB 電子書下載](#{EPUB_URL})\n" if EPUB_URL
llms << "- [翻譯專案原始碼](#{REPO_URL})\n- [英文原著](#{ORIGINAL_URL})\n"
File.write(File.join(OUT, 'llms.txt'), llms)

File.write(File.join(OUT, 'CNAME'), "mastering-ethereum.doge.tg\n") if ENV['WRITE_CNAME']

puts "完成（#{BOOK}，網址基底 #{HOME_PATH}）：#{pages.size} 個章節頁面（已翻譯 #{translated_count}）、" \
     "#{used_images.size} 張圖片、#{search.size} 筆搜尋資料 → #{OUT}"
