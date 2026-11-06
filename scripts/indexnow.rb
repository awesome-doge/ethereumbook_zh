#!/usr/bin/env ruby
# frozen_string_literal: true

# 用 IndexNow 通知搜尋引擎（Bing、Yandex、Naver、Seznam 等共用同一個端點）有哪些網址新增或更新。
# 比對本次建置的 sitemap 與線上（部署前）的 sitemap，只送出 lastmod 改變或新出現的網址；加 --all 則送出全部。
#
# 用法：ruby scripts/indexnow.rb <本次建置的 sitemap.xml> [部署前的 sitemap.xml] [--all] [--dry-run]
#   金鑰檔 https://mastering-ethereum.doge.tg/<金鑰>.txt 由 build-site.rb 產生，必須已經上線，搜尋引擎才會接受。

Encoding.default_external = Encoding::UTF_8

require 'json'
require 'net/http'
require 'nokogiri'

HOST = 'mastering-ethereum.doge.tg'
KEY = File.read(File.expand_path('build-site.rb', __dir__))[/^INDEXNOW_KEY = '(\h+)'/, 1] or abort '找不到 INDEXNOW_KEY'

all = ARGV.delete('--all')
dry_run = ARGV.delete('--dry-run')
new_path, old_path = ARGV
abort '用法：ruby scripts/indexnow.rb <sitemap.xml> [舊 sitemap.xml] [--all] [--dry-run]' unless new_path

lastmods = lambda do |path|
  return {} unless path && File.exist?(path) && !File.zero?(path)

  doc = Nokogiri::XML(File.read(path)).remove_namespaces!
  doc.css('url').to_h { |u| [u.at_css('loc').text, u.at_css('lastmod')&.text] }
end

current = lastmods.call(new_path)
previous = lastmods.call(old_path)
urls = all || previous.empty? ? current.keys : current.select { |u, m| previous[u] != m }.keys

if urls.empty?
  puts 'IndexNow：沒有新增或更新的網址'
  exit
end
puts "IndexNow：送出 #{urls.size} 個網址"
urls.each { |u| puts "  #{u}" }
exit if dry_run

body = { host: HOST, key: KEY, keyLocation: "https://#{HOST}/#{KEY}.txt", urlList: urls }
uri = URI('https://api.indexnow.org/indexnow')
res = Net::HTTP.post(uri, JSON.generate(body), 'Content-Type' => 'application/json; charset=utf-8')
puts "IndexNow 回應：#{res.code} #{res.message}"
# 200：已收到；202：已收到、金鑰待驗證。其他狀態只警告，不讓部署失敗
warn "IndexNow 未接受：#{res.body}" unless %w[200 202].include?(res.code)
