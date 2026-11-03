# 《精通以太坊》第二版 繁體中文翻譯規劃

> 狀態：規劃中（2026-11-03）。本文件是第二版翻譯的工作依據，各階段完成後在這裡更新。

## 已決定的事

| 項目 | 決定 |
|---|---|
| 網站位置 | 沿用 `mastering-ethereum.doge.tg`，第二版成為主站；2018 年草稿譯本封存到 `/2018/`，舊網址自動轉過去 |
| 譯稿格式 | 翻譯 Markdown，檔名與段落結構和上游一一對應；建置時再轉成 AsciiDoc，沿用現有的閱讀器與 EPUB／PDF 流程 |
| 翻譯方式 | 試譯 1–2 章、定案術語與風格後，其餘章節以多代理平行翻譯；正式啟動前先估算用量並取得同意 |
| 發布時機 | 全書譯完、校過一輪，且確認上游授權已轉為 CC BY-SA 4.0 後，才一次公開 |

## 上游現況

- 來源：[ethereumbook/ethereumbook](https://github.com/ethereumbook/ethereumbook) 的 `develop` 分支，mdBook 格式（`book.toml`、`src/*.md`）。
- 釘版基準：`5907a8c137135588a7d5dacd1c3bd6ff6c9c5151`（2026-10-12）。翻譯期間一律以這個版本為準，之後再統一同步。
- 作者：Andreas M. Antonopoulos、Gavin Wood、Carlo Parisi、Alessandro Mazza、Niccolò Pozzolini。O'Reilly 於 2025 年 10 月出版。
- 授權條款（上游 README 與官方線上版頁尾）：出版後 12 個月內為 CC BY-NC-ND 4.0，期滿後轉為 CC BY-SA 4.0。
  上游目前沒有 LICENSE 檔，條款文字也還沒更新成「已轉為 BY-SA」。**公開發布前必須先取得書面確認**（例如在上游開 issue 詢問），翻譯與私下建置可以先進行。

### 份量

英文字數不含程式碼區塊。共約 149,460 字，183 張圖片（12 MB）。

| 檔案 | 章節 | 英文字數 | 程式碼區塊 | 圖片 | 備註 |
|---|---|---:|---:|---:|---|
| `intro.md` | 簡介 | 92 | 0 | 0 | 很短，可併入首頁 |
| `preface.md` | 前言 | 2,251 | 0 | 0 | |
| `chapter_1.md` | 什麼是以太坊 | 4,936 | 0 | 1 | |
| `chapter_2.md` | 以太坊基礎 | 6,716 | 1 | 26 | 大量操作截圖 |
| `chapter_3.md` | 以太坊節點 | 5,828 | 37 | 1 | |
| `chapter_4.md` | 密碼學 | 12,572 | 58 | 17 | 部分程式碼在提示框內 |
| `chapter_5.md` | 錢包 | 10,528 | 2 | 10 | 表格多 |
| `chapter_6.md` | 交易 | 12,234 | 36 | 13 | |
| `chapter_7.md` | 智能合約與 Solidity | 11,485 | 47 | 1 | |
| `chapter_8.md` | 智能合約與 Vyper | 2,946 | 13 | 0 | 最短，適合試譯 |
| `chapter_9.md` | 智能合約安全 | 13,759 | 21 | 1 | 新章節 |
| `chapter_10.md` | 代幣 | 9,910 | 39 | 1 | |
| `chapter_11.md` | 預言機 | 4,692 | 0 | 5 | |
| `chapter_12.md` | 去中心化應用 | 4,465 | 23 | 13 | |
| `chapter_13.md` | 去中心化金融（DeFi） | 6,084 | 2 | 7 | 新章節 |
| `chapter_14.md` | 以太坊虛擬機 | 13,064 | 80 | 28 | 程式碼最多 |
| `chapter_15.md` | 共識 | 10,749 | 0 | 45 | 改為 The Merge 之後的權益證明 |
| `chapter_16.md` | 以太坊擴容 | 9,331 | 0 | 9 | 新章節 |
| `chapter_17.md` | 零知識證明 | 7,726 | 7 | 5 | 新章節；23 條 MathML 公式 |

### 與 2018 草稿譯本的關係

現有譯本始於 2018-06-26，翻的是第一版正式出版之前的草稿。第二版的章節大幅重組與改寫：測試網、開發工具、gas、DevP2P、以太坊標準、分叉歷史不再獨立成章；新增智能合約安全、DeFi、擴容、零知識證明。
因此**第二版重新翻譯**，不在舊譯稿上修改；舊譯稿只當作術語候選來源。

## 目錄結構

```
upstream/              上游 src/ 原樣（含 images/），釘在 UPSTREAM_COMMIT
  UPSTREAM_COMMIT
zh-tw/                 譯稿 Markdown，檔名、標題數量與段落順序和 upstream/ 一一對應
translation/
  terminology.md       術語表（英文 → 譯名 → 備註）
  style-guide.md       翻譯風格指南
  progress.md          各章進度：狀態、譯者、對應的上游 commit
2018/                  封存的 2018 草稿譯本（現在根目錄的 *.asciidoc 與 images/ 搬過來）
scripts/
  md2adoc.rb           譯稿 Markdown → AsciiDoc（建置時執行）
  check-translation.rb 逐章比對譯稿與上游的結構
  build-site.rb        現有閱讀器建置，改為支援第二版與 /2018/ 封存
  check-site.rb
web/                   現有閱讀器的版型、樣式與腳本，沿用
```

## 網址

- 第二版章節改用描述性網址 `/chapters/<slug>.html`，因為章號全部變了（例如第 8 章從「智能合約」變成「Vyper」），不能沿用 `/chNN.html`。
  預計 slug：`preface`、`what-is-ethereum`、`ethereum-basics`、`nodes`、`cryptography`、`wallets`、`transactions`、`solidity`、`vyper`、`smart-contract-security`、`tokens`、`oracles`、`dapps`、`defi`、`evm`、`consensus`、`scaling`、`zero-knowledge-proofs`。
- 2018 草稿譯本封存在 `/2018/<slug>.html`，每頁頂端標示「2018 年草稿譯本，內容已過時」並連到第二版。
- 舊網址 `/ch01.html`–`/ch19.html`、`/preface.html`、`/glossary.html`、`/all.html` 改為轉址頁，帶著 `#錨點` 轉到 `/2018/` 對應頁面，網址的內容不會突然變成另一章。GitHub Pages 沒有伺服器端轉址，所以用 canonical、meta refresh 加上 JS 保留錨點。

## 轉換器（`scripts/md2adoc.rb`）

先以 pandoc（`-f gfm -t asciidoc --wrap=none`）轉換，再做後處理。用上游英文原稿試轉全部 19 個檔案，已確認的問題：

| 問題 | 數量 | 處理方式 |
|---|---:|---|
| MathML 公式被 pandoc **靜默刪除** | 23（全在第 17 章） | 轉換前先抽出換成佔位符；手動改寫成 `latexmath`，比照第 5 章的 `ifdef` 雙版本，讓 EPUB／PDF 也能顯示 |
| 圖片變成行內 `image:` | 182 | 改為區塊 `image::`，並把下一行的「Figure N-M. 說明」當成圖說，閱讀器才會編成「圖 N-M」 |
| `> **Note**`／Tip／Warning 變成引言 | 162 | 改為 `NOTE`／`TIP`／`WARNING` 提示區塊，其中有幾個內含程式碼區塊 |
| 章標題帶「Chapter N.」 | 17 | 去掉前綴；章節 ID 依上游英文標題產生，中英文標題按位置一一配對，數量對不上就直接報錯 |
| 受限強調 `_x_`、`*x*` | 631 | 一律輸出非受限的 `__x__`、`**x**`。受限形式緊貼中文時不會渲染，這是這次修 2018 譯本學到的 |
| `w++[++i++]++` 之類的跳脫 | 若干 | 清成正常的行內程式碼 |
| 註腳 | 19 | pandoc 已正確轉為 `footnote:[]` |
| 內文的「Chapter 7」「Figure 4-1」「Example 4-1」 | 若干 | 能對應到 ID 的改成交互參照 |

驗收標準：先用上游英文原稿建出完整的英文網站（不公開），`check-site.rb` 通過、標記外漏為 0；圖片、圖說、提示區塊、註腳、公式數量都和原稿一致。

## 機械檢查（`scripts/check-translation.rb`）

每章譯稿都要通過才能合併：

1. 各層級標題數量與上游相同。
2. 圖片、表格列數、註腳、程式碼區塊數量相同。
3. 程式碼區塊內容與上游**逐位元組相同**：程式碼與其中的英文註解都不翻譯，只有這樣才能用腳本驗證。
4. 連結網址、MathML 與上游相同。
5. 沒有標記外漏（沿用這次做的 `check.py` 規則，並併入 `check-site.rb` 當 CI 步驟）。
6. 不含禁用詞：中國大陸用語（代碼、網絡、數據、軟件、默認、接口、信息、視頻……），以及術語表中標為「不用」的譯法。
7. 術語表的每個詞都用統一譯名；第一次出現時中英並列，例如「權益證明（proof of stake，PoS）」。

## 術語表與風格指南

- **術語表**：平行翻譯開始前就要涵蓋**全書**，不能只靠試譯的章節。先從全部 19 個上游檔案抽出候選詞（各級標題、首次以斜體或粗體出現的術語、大寫專有名詞、定義句），特別是 DeFi、擴容、零知識證明與權益證明等新內容（例如 rollup、blob、data availability、KZG、restaking、liquidity pool），逐條決定譯名。
  2018 譯本的術語表與內文只當候選參考，不直接沿用（舊譯稿用詞不一，也混有中國大陸用語）。試譯用來驗證術語表，不是用來產生術語表。
- **風格指南**：台灣用語與全形標點、中英文之間的空格規則、數字與單位寫法、圖片內的英文不改（替代文字與圖說要翻）、譯註格式（比照 bitcoinbook 的「譯註」）。

## 階段

### 第 0 階段：現站加過時提示（現在就能做）
現站首頁與各章頂端標示「本譯本翻自 2018 年草稿，部分內容已過時」，並連到官方第二版 masteringethereum.xyz。第二版上線前的這段時間，讀者不會誤把舊資訊當成現況。

### 第 1 階段：基礎建設
1. 匯入 `upstream/`，記錄 `UPSTREAM_COMMIT`。
2. 寫 `md2adoc.rb`，用英文原稿通過上面的驗收標準。
3. 寫 `check-translation.rb`。
4. 從全書抽出候選術語，起草涵蓋全書的 `terminology.md`，以及 `style-guide.md`。
5. 把 2018 譯本搬到 `2018/`：除了 `*.asciidoc` 與 `images/`，還有 `code/`（章節會 `include::` 其中的檔案）、`cover.jpg`、`pdf-theme.yml`、`epub-styles/`。2018 版的 PDF／EPUB 凍結在目前最後一次 release，不再重建。
6. 網站建置改為兩本書：第二版用新的章節設定（`web/chapters-2nd.yml`，上面列的 slug），2018 版沿用現在的 `web/chapters.yml`；`build-site.rb` 加上「書稿路徑、章節設定、網址前綴」三個參數，各建一次。
7. `ebook.yml` 改為產生第二版：先執行 `md2adoc.rb` 產生 `book.asciidoc`，再交給 asciidoctor-pdf 與 asciidoctor-epub3。

### 第 2 階段：試譯
依序翻譯第 8 章（Vyper，2,946 字）與第 13 章（DeFi，6,084 字），由你審閱。第 13 章用來在平行翻譯前先測試新領域的術語。依審閱結果修訂術語表與風格指南，然後定案。

### 第 3 階段：平行翻譯
其餘 17 個檔案（前言、簡介與 15 章）以多代理平行翻譯。每個代理都拿同一份術語表、風格指南與上游原稿，譯完必須通過 `check-translation.rb`。
硬性規則：遇到術語表沒有的詞，一律在譯稿標註 `TODO-term:` 並保留英文，不得自行決定譯名；全部完成後統一決定、回填，再跑一輪跨章的術語一致性檢查。
啟動前會先依試譯的實際用量估算總量，並請你親口指示啟動多代理翻譯後才開始。

### 第 4 階段：審校
你逐章審閱；技術錯誤加譯註（比照 bitcoinbook 修正原書錯誤的做法）。

### 第 5 階段：上線
1. 確認上游授權已轉為 CC BY-SA 4.0，並把網站、README、llms.txt 的授權標示改過來。
2. 切換網站：第二版上主網域，2018 譯本移到 `/2018/`，舊網址轉址，更新 sitemap、搜尋索引與同義詞。
3. 推送新版本 tag，產生第二版的 PDF 與 EPUB。

### 第 6 階段：持續同步上游
上游有新 commit 時：比對 `UPSTREAM_COMMIT` 與新版本的差異，逐章套用到譯稿，在 `progress.md` 記錄每章對應的上游 commit，最後更新 `UPSTREAM_COMMIT`。

## 風險

- **授權**：上游沒有正式公告已轉為 BY-SA。在得到確認之前，第二版譯本不公開。
- **用量**：平行翻譯約 15 萬英文字，token 消耗大；試譯後會有實際估算。
- **圖片文字**：圖表中的英文不翻譯，只翻譯圖說與替代文字。
- **PDF 數學式**：asciidoctor-pdf 不支援 MathML，所以 23 條公式都要改寫成 `latexmath`。
- **上游在翻譯期間持續更新**：一律以釘版基準翻譯，完成後再用第 6 階段的流程同步。
