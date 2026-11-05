#!/usr/bin/env ruby
# frozen_string_literal: true

# 第二版譯稿檢查：逐章比對 zh-tw/ 與 upstream/ 的 Markdown 結構，並檢查用語。
#
# 用法：ruby scripts/check-translation.rb [章節檔名…]   （預設檢查 zh-tw/ 裡所有已存在的章節）
#       --strict：TODO-term 標記與疑似未翻譯的段落也算錯誤（合併前使用）
#
# 譯稿必須和原稿一致的部分（任何一項不符就失敗）：
#   - 各標題的層級與順序（標題 ID 依位置取自原稿，見 scripts/md2adoc.rb）
#   - 程式碼區塊：語言與內容逐字相同（程式碼與其中的英文註解都不翻譯）
#   - 行內程式碼、連結網址、圖片路徑、MathML 公式：逐字相同（行內程式碼與連結只比對集合，語序可以調整）
#   - 段落數（一段對一段）、表格數與每個表格的欄列數、註腳數、Note/Tip/Warning 提示數、圖說數
# 用語：translation/terminology.md 中標為「不用」的譯法，以及中國大陸用語，不得出現在正文。

Encoding.default_external = Encoding::UTF_8

require 'json'
require 'open3'

ROOT = File.expand_path('..', __dir__)
UP = File.join(ROOT, 'upstream')
ZH = ENV['ZH_DIR'] || File.join(ROOT, 'zh-tw')
STRICT = ARGV.delete('--strict')

# 中國大陸用語 → 台灣用語（只檢查正文文字，不檢查程式碼與網址）
MAINLAND = {
  '代碼' => '程式碼', '網絡' => '網路', '數據' => '資料', '軟件' => '軟體', '硬件' => '硬體',
  '默認' => '預設', '接口' => '介面', '信息' => '資訊', '視頻' => '影片', '服務器' => '伺服器',
  '程序員' => '程式設計師', '文件夾' => '資料夾', '屏幕' => '螢幕', '菜單' => '選單', '字節' => '位元組',
  '博客' => '部落格', '鏈接' => '連結', '調用' => '呼叫', '變量' => '變數', '數據庫' => '資料庫',
  '內存' => '記憶體', '線程' => '執行緒', '激活' => '啟用', '登錄' => '登入'
}.freeze

# 風格決定（translation/style-guide.md）
STYLE = { '您' => '你' }.freeze

def ast(path)
  out, err, st = Open3.capture3('pandoc', '-f', 'gfm-tex_math_dollars', '-t', 'json', path)
  abort "#{path}: #{err}" unless st.success?
  JSON.parse(out)
end

def text_of(node)
  case node
  when Array then node.map { |n| text_of(n) }.join
  when Hash
    case node['t']
    when 'Str' then node['c']
    when 'Space', 'SoftBreak', 'LineBreak' then ' '
    when 'Code' then ''
    else text_of(node['c'])
    end
  else ''
  end
end

# 從 AST 取出需要比對的結構
def structure(path)
  s = { headings: [], codes: [], inline_codes: [], links: [], images: [], tables: [], footnotes: 0, paragraphs: 0,
        admonitions: Hash.new(0), figcaps: 0, prose: [], todo_terms: 0 }
  walk = lambda do |node, ctx = {}|
    case node
    when Array then node.each { |n| walk.call(n, ctx) }
    when Hash
      c = node['c']
      case node['t']
      when 'Header' then s[:headings] << c[0]; s[:prose] << text_of(c[2]); walk.call(c[2], ctx)
      when 'CodeBlock' then s[:codes] << [c[0][1].join(','), c[1]]
      when 'Code' then s[:inline_codes] << c[1]
      when 'Link' then s[:links] << c[2][0]; walk.call(c[1], ctx)
      when 'Image' then s[:images] << c[2][0]
      when 'Note'
        # 「譯註：」開頭的註腳是譯者加的，不列入與原稿的比對（裡面的段落也不算）
        unless text_of(c).strip.start_with?('譯註')
          s[:footnotes] += 1
          walk.call(c, ctx)
        end
      when 'Table'
        body_rows = c[4].sum { |tb| tb[3].size }
        cols = c[2].size
        s[:tables] << [cols, c[3][1].size + body_rows]
        walk.call(c, ctx.merge(table: true))
      when 'BlockQuote'
        first = c.first
        if first && first['t'] == 'Para' && first['c'].first&.dig('t') == 'Strong'
          kind = text_of(first['c'].first)
          s[:admonitions][{ '備註' => 'Note', '提示' => 'Tip', '警告' => 'Warning' }.fetch(kind, kind)] += 1 if
            %w[Note Tip Warning 備註 提示 警告].include?(kind)
        end
        walk.call(c, ctx)
      when 'Para', 'Plain'
        s[:paragraphs] += 1
        t = text_of(c)
        s[:figcaps] += 1 if t.match?(/\A(Figure \d+-\d+\. |圖 ?\d+-\d+(\. |．))/)
        # 未翻譯檢查不看：表格儲存格（助記詞、雜湊等資料）、只有圖片的段落（替代文字保留英文）、以〈〉標示的英文篇名
        image_only = c.size == 1 && c[0]['t'] == 'Image'
        s[:prose] << t unless ctx[:table] || image_only || t.strip.match?(/\A〈.*〉[。．.]?\z/)
        walk.call(c, ctx)
      else walk.call(c, ctx)
      end
    end
  end
  walk.call(ast(path)['blocks'])
  raw = File.read(path)
  s[:math] = raw.scan(%r{<math\b.*?</math>}m).map { |m| m.gsub(/\s+/, ' ') }
  s[:todo_terms] = raw.scan(/TODO-term:/).size
  s
end

def terminology_banned
  path = File.join(ROOT, 'translation', 'terminology.md')
  return {} unless File.exist?(path)

  banned = {}
  File.foreach(path) do |line|
    cells = line.split('|').map(&:strip)
    next unless cells.size >= 5 && !cells[1].empty? && cells[1] !~ /\A(英文|-+)\z/

    cells[3].split(/[、,，]/).map(&:strip).reject(&:empty?).each { |w| banned[w] = cells[2] }
  end
  banned
end

abort "還沒有譯稿目錄 #{ZH}" unless Dir.exist?(ZH)
files = ARGV.empty? ? Dir.children(ZH).grep(/\.md\z/).sort_by { |f| f[/\d+/].to_i } - %w[SUMMARY.md] : ARGV
abort "zh-tw/ 還沒有任何譯稿" if files.empty?

banned = MAINLAND.merge(STYLE).merge(terminology_banned)
failed = 0
files.each do |file|
  zh_path = File.join(ZH, file)
  up_path = File.join(UP, file)
  next warn("略過 #{file}：upstream/ 沒有這個檔案") unless File.exist?(up_path)

  up = structure(up_path)
  zh = structure(zh_path)
  errors = []
  warns = []

  if up[:headings] != zh[:headings]
    i = up[:headings].zip(zh[:headings]).index { |a, b| a != b } || [up[:headings].size, zh[:headings].size].min
    errors << "標題結構不符：原稿 #{up[:headings].size} 個、譯稿 #{zh[:headings].size} 個，第 #{i + 1} 個開始不同"
  end
  if up[:codes] != zh[:codes]
    i = up[:codes].zip(zh[:codes]).index { |a, b| a != b } || up[:codes].size
    errors << "程式碼區塊不符：原稿 #{up[:codes].size} 個、譯稿 #{zh[:codes].size} 個，第 #{i + 1} 個開始不同" \
              "（#{(up[:codes][i] || [nil, ''])[1].lines.first.to_s.strip[0, 60]}）"
  end
  { inline_codes: '行內程式碼', links: '連結網址' }.each do |k, name|
    a = up[k].tally
    b = zh[k].tally
    next if a == b

    missing = a.flat_map { |v, n| [v] * [n - b.fetch(v, 0), 0].max }
    extra = b.flat_map { |v, n| [v] * [n - a.fetch(v, 0), 0].max }
    errors << "#{name}不符：缺少 #{missing.first(3).inspect}#{"、多出 #{extra.first(3).inspect}" unless extra.empty?}"
  end
  errors << "圖片不符：原稿 #{up[:images].size} 張、譯稿 #{zh[:images].size} 張" if up[:images] != zh[:images]
  errors << "表格不符：原稿 #{up[:tables].inspect}、譯稿 #{zh[:tables].inspect}" if up[:tables] != zh[:tables]
  errors << "註腳數不符：#{up[:footnotes]} / #{zh[:footnotes]}" if up[:footnotes] != zh[:footnotes]
  # 一段對一段：同步上游時，原稿的修改才能直接對應到譯稿的同一段
  errors << "段落數不符：原稿 #{up[:paragraphs]} 段、譯稿 #{zh[:paragraphs]} 段" if up[:paragraphs] != zh[:paragraphs]
  errors << "提示區塊不符：#{up[:admonitions]} / #{zh[:admonitions]}" if up[:admonitions] != zh[:admonitions]
  errors << "圖說數不符：#{up[:figcaps]} / #{zh[:figcaps]}" if up[:figcaps] != zh[:figcaps]
  errors << 'MathML 公式必須與原稿逐字相同' if up[:math] != zh[:math]

  prose = zh[:prose].join("\n")
  banned.each do |bad, good|
    n = prose.scan(bad).size
    errors << "用語「#{bad}」出現 #{n} 次，應為「#{good}」" if n.positive?
  end

  untranslated = zh[:prose].select { |t| t.scan(/\p{Han}/).empty? && t.scan(/[A-Za-z]+/).size >= 8 }
  (STRICT ? errors : warns) << "疑似未翻譯的段落 #{untranslated.size} 段（例如：#{untranslated.first[0, 60]}…）" unless untranslated.empty?
  (STRICT ? errors : warns) << "還有 #{zh[:todo_terms]} 個 TODO-term 標記" if zh[:todo_terms].positive?

  status = errors.empty? ? 'OK  ' : 'FAIL'
  failed += 1 unless errors.empty?
  puts "#{status} #{file}"
  errors.each { |e| puts "  ✗ #{e}" }
  warns.each { |w| puts "  ! #{w}" }
end

abort "譯稿檢查失敗：#{failed} 個檔案" if failed.positive?
puts "譯稿檢查通過：#{files.size} 個檔案"
