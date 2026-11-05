# 精通以太坊 — Mastering Ethereum 繁體中文版

<p align="center">
  <img src="2018/images/cover.png" width="320" alt="Mastering Ethereum Cover" />
</p>

<p align="center">
  <a href="https://mastering-ethereum.doge.tg/"><strong>線上閱讀</strong></a> ·
  <a href="https://github.com/awesome-doge/ethereumbook_zh/releases/latest">電子書下載</a> ·
  <a href="https://github.com/awesome-doge/ethereumbook_zh">GitHub</a>
</p>

---

由 **Andreas M. Antonopoulos** 和 **Dr. Gavin Wood** 著作，**Dr. Awesome Doge** 翻譯。

本書是 [Mastering Ethereum](https://github.com/ethereumbook/ethereumbook) 的繁體中文翻譯，涵蓋以太坊的完整技術細節。

## 閱讀方式

| 格式 | 說明 |
|------|------|
| [線上閱讀](https://mastering-ethereum.doge.tg/) | 每章一頁的線上閱讀器：全書目錄、全文搜尋、字級與主題切換、記住閱讀進度，支援桌面和手機 |
| [PDF 下載](https://github.com/awesome-doge/ethereumbook_zh/releases/latest) | A4 排版，適合電腦、平板和列印 |
| [EPUB 下載](https://github.com/awesome-doge/ethereumbook_zh/releases/latest) | 適合 Kindle、Apple Books、Kobo 等電子書閱讀器 |

## 目錄

| 章節 | 主題 |
|------|------|
| [前言](2018/preface.asciidoc) | 封面上的蜜蜂有什麼含義？ |
| [術語](2018/glossary.asciidoc) | 快速術語表 |
| [第 1 章](2018/ch01.asciidoc) | 什麼是以太坊 |
| [第 2 章](2018/ch02.asciidoc) | 以太坊基礎 |
| [第 3 章](2018/ch03.asciidoc) | 以太坊客戶端 |
| [第 4 章](2018/ch04.asciidoc) | 以太坊測試網 |
| [第 5 章](2018/ch05.asciidoc) | 密鑰和地址 |
| [第 6 章](2018/ch06.asciidoc) | 錢包 |
| [第 7 章](2018/ch07.asciidoc) | 交易 |
| [第 8 章](2018/ch08.asciidoc) | 智能合約 |
| [第 9 章](2018/ch09.asciidoc) | 開發工具、框架和庫 |
| [第 10 章](2018/ch10.asciidoc) | 代幣 (Tokens) |
| [第 11 章](2018/ch11.asciidoc) | 去中心化應用 (DApps) |
| [第 12 章](2018/ch12.asciidoc) | 預言機 (Oracles) |
| [第 13 章](2018/ch13.asciidoc) | 燃氣 (Gas) |
| [第 14 章](2018/ch14.asciidoc) | 以太坊虛擬機 (EVM) |
| [第 15 章](2018/ch15.asciidoc) | 共識 |
| [第 16 章](2018/ch16.asciidoc) | Vyper |
| [第 17 章](2018/ch17.asciidoc) | DevP2P 協議 |
| [附錄 A](2018/ch18.asciidoc) | 以太坊標準 |
| [附錄 B](2018/ch19.asciidoc) | 以太坊分叉歷史 |

## 構建

本書使用 [AsciiDoc](https://asciidoc.org/) 格式撰寫，以 [Asciidoctor](https://asciidoctor.org/) 構建。

```bash
# 安裝
gem install asciidoctor rouge nokogiri
brew install webp            # 選用：圖片另外輸出 WebP（Linux：apt install webp）

# 構建線上閱讀網站到 output/，並檢查連結、錨點與 sitemap
ruby scripts/build-site.rb output
ruby scripts/check-site.rb output
python3 -m http.server 8000 --directory output   # 本機預覽 http://localhost:8000

# 構建 PDF（需要額外安裝）
gem install asciidoctor-pdf
asciidoctor-pdf -a pdf-theme=pdf-theme.yml 2018/book.asciidoc   # 2018 草稿譯本
```

網站的版型、樣式與互動在 `web/`：`web/chapters.yml` 設定各章網址代稱與 SEO 描述，`web/templates/` 是頁面版型，`web/assets/` 是樣式與腳本，`web/search-synonyms.yml` 是全書搜尋的同義詞。

推送到 `master` 分支會自動透過 GitHub Actions 部署網頁版。推送 `v*` tag 會自動構建 PDF/EPUB 並發布到 GitHub Releases。

## 授權

本書以 [Creative Commons CC-BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/) 授權釋出。

[![Creative Commons License](https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png)](https://creativecommons.org/licenses/by-nc-nd/4.0/)
