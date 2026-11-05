#!/usr/bin/env ruby
# frozen_string_literal: true

# 第二版：把 mdBook 的 Markdown（上游英文原稿，或與其逐段對齊的譯稿）轉成 AsciiDoc，組成一本 book.adoc。
#
# 用法：
#   ruby scripts/md2adoc.rb upstream build/2nd-en              # 英文原稿
#   ruby scripts/md2adoc.rb zh-tw build/2nd-zh --ref upstream  # 譯稿：標題 ID 依位置取自英文原稿
#
# 需要 pandoc 3.x（以 3.9.0.2 與 3.13 驗證；CI 固定 3.13，見 .github/workflows/gh-pages.yml）。實際的轉換規則在 scripts/md2adoc/filter.lua。
# 章節 ID：前言 preface-chap，第 N 章 chNN；小節 ID 為「章節 ID-英文標題的 pandoc 自動 ID」，
# 譯稿沿用英文原稿同一位置標題的 ID，網址與交互參照因此不受翻譯影響。

Encoding.default_external = Encoding::UTF_8

require 'json'
require 'fileutils'
require 'open3'
require 'tmpdir'

ROOT = File.expand_path('..', __dir__)
FILTER = File.join(__dir__, 'md2adoc', 'filter.lua')
MATH_OVERRIDES = File.join(ROOT, 'translation', 'math-overrides.json')
# 英文原稿各標題的 ID。譯稿的 ID 依位置取自英文原稿，而英文 ID 來自 pandoc 的自動 ID；
# pandoc 換版本可能改變自動 ID 的規則，所以每次都和這份快照比對，有差異就停止（--update-ids 重新產生）
IDS_SNAPSHOT = File.join(ROOT, 'translation', 'ids-snapshot.json')

args = ARGV.dup
update_ids = args.delete('--update-ids')
ref = (i = args.index('--ref')) ? File.expand_path(args.delete_at(i + 1), ROOT).tap { args.delete_at(i) } : nil
src, out = args.map { |a| File.expand_path(a, ROOT) }
abort 'usage: md2adoc.rb SRC_DIR OUT_DIR [--ref UPSTREAM_DIR]' unless src && out

version = `pandoc --version`[/pandoc ([\d.]+)/, 1] or abort '找不到 pandoc'
abort "需要 pandoc 3.x，目前是 #{version}" if version.to_i < 3

# 章節順序取自 SUMMARY.md（譯稿沒有自己的 SUMMARY.md 時用原稿的）；intro.md 是上游 README，不屬於正文
summary = [src, ref].compact.map { |d| File.join(d, 'SUMMARY.md') }.find { |p| File.exist?(p) }
files = File.read(summary).scan(/\]\(\.\/([\w]+\.md)\)/).flatten - ['intro.md']
abort "#{src}/SUMMARY.md 沒有列出任何章節" if files.empty?

# 前言不用 preface：pandoc 的 AsciiDoc writer 遇到「ID 等於它自動產生的 ID」就不輸出錨點，Asciidoctor 會改給 _preface
chapter_id = ->(file) { file == 'preface.md' ? 'preface-chap' : format('ch%02d', file[/\d+/].to_i) }
lang = ref ? 'zh' : 'en'

FileUtils.mkdir_p(File.join(out, 'ids'))
chapter_ids_file = File.join(out, 'ids', '_chapters.json')
File.write(chapter_ids_file, JSON.generate(files.to_h { |f| [f, chapter_id.call(f)] }))

def pandoc(input, output, meta)
  # 關掉 $…$ 公式：正文的「$10–$20」會被當成數學式；上游的公式一律是 MathML
  cmd = ['pandoc', '-f', 'gfm-tex_math_dollars', '-t', 'asciidoc', '--wrap=none', '--lua-filter', FILTER, input, '-o', output]
  meta.each { |k, v| cmd.push('-M', "#{k}=#{v}") if v }
  _, err, status = Open3.capture3(*cmd)
  abort "#{File.basename(input)}：#{err.lines.grep_v(/^MATHCOUNT/).join}" unless status.success?
  err.lines.grep(/^MATH /).each { |l| warn "#{File.basename(input)} #{l}" }
  err[/MATHCOUNT (\d+)/, 1].to_i
end

total_math = 0
fallback = []
english_ids = {}
Dir.mktmpdir do |tmp|
  files.each do |file|
    id = chapter_id.call(file)
    ids_in = nil
    if ref
      ids_in = File.join(tmp, "#{file}.json")
      pandoc(File.join(ref, file), File.join(tmp, "#{file}.adoc"),
             chapter_id: id, chapter_ids: chapter_ids_file, ids_out: ids_in)
      english_ids[file] = JSON.parse(File.read(ids_in)).map { |h| h['id'] }
    end
    adoc = File.join(out, file.sub(/\.md\z/, '.adoc'))
    input = File.join(src, file)
    # 還沒翻譯的章節先用英文原稿，試譯期間也能建出整本書預覽
    if ref && !File.exist?(input)
      fallback << file
      input = File.join(ref, file)
    end
    total_math += pandoc(input, adoc,
                         chapter_id: id, chapter_ids: chapter_ids_file, ids_in: ids_in,
                         ids_out: File.join(out, 'ids', "#{file}.json"),
                         math_overrides: File.exist?(MATH_OVERRIDES) ? MATH_OVERRIDES : nil)
    File.write(adoc, "[preface]\n" + File.read(adoc)) if file == 'preface.md'
    english_ids[file] ||= JSON.parse(File.read(File.join(out, 'ids', "#{file}.json"))).map { |h| h['id'] } unless ref
  end
end

if update_ids
  File.write(IDS_SNAPSHOT, JSON.pretty_generate(english_ids) + "\n")
  puts "已更新 #{IDS_SNAPSHOT}"
elsif File.exist?(IDS_SNAPSHOT)
  snapshot = JSON.parse(File.read(IDS_SNAPSHOT))
  drift = english_ids.filter_map do |file, ids|
    old = snapshot.fetch(file, [])
    next if old == ids

    i = old.zip(ids).index { |a, b| a != b } || [old.size, ids.size].min
    "#{file}：第 #{i + 1} 個標題 ID 由 #{old[i].inspect} 變成 #{ids[i].inspect}"
  end
  abort "英文標題 ID 與快照不符（pandoc 版本或上游原稿改變了？確認後以 --update-ids 更新）：\n  #{drift.join("\n  ")}" unless drift.empty?
end

captions =
  if lang == 'zh'
    <<~ADOC
      :lang: zh-Hant
      :chapter-signifier!:
      :toc-title: 目錄
      :caution-caption: 小心
      :important-caption: 重要
      :note-caption: 備註
      :tip-caption: 提示
      :warning-caption: 警告
      :appendix-caption: 附錄
      :example-caption: 範例
      :figure-caption: 圖
      :table-caption: 表
    ADOC
  else
    ":lang: en\n"
  end

title = lang == 'zh' ? '精通以太坊（第二版）' : 'Mastering Ethereum (2nd Edition)'
book = +<<~ADOC
  = #{title}
  :doctype: book
  :sectnums:
  :toc: left
  :toclevels: 2
  :stem: latexmath
  :source-highlighter: rouge
  :imagesdir: #{ref || src}
  #{captions}
ADOC
files.each { |f| book << "\ninclude::#{f.sub(/\.md\z/, '.adoc')}[]\n" }
File.write(File.join(out, 'book.adoc'), book)

puts "完成：#{files.size} 個檔案、#{total_math} 條公式 → #{out}"
puts "尚未翻譯、改用英文原稿：#{fallback.join(' ')}" unless fallback.empty?
