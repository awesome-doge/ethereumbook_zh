# 第 15 章（Consensus）翻譯筆記

譯稿：`zh-tw/chapter_15.md`；原稿：`upstream/chapter_15.md`（上游 5907a8c）。

筆記中的「第 N 行」都指原稿 `upstream/chapter_15.md` 的行號。

## TODO-term

每個詞只在本章內文第一次出現處標記；其餘出現處保留英文，不再重複標記。出現次數是譯稿正文（含標題，不含圖片替代文字與 TODO 標記本身）中該英文字串的次數。

| 英文 | 建議譯名 | 出現次數 | 備註 |
|------|----------|----------|------|
| double spend | 雙重支付 | 1 | 第 21 行「double-spending」；比照 `zh-tw/chapter_4.md` 已有的同一個 TODO-term |
| safety | 安全性 | 11 | 共識理論的 safety；不含 accountable safety。含標題「Safety」。一般意義的 security 照譯「安全」 |
| liveness | 活性 | 12 | 不含 plausible liveness。含標題「Liveness」 |
| block tree | 區塊樹 | 5 | 含標題「Block Tree 與分叉」與圖 15-1 圖說 |
| canonical chain | 正統鏈 | 3 | |
| reversion | 回復 | 1 | 「reorg or reversion」；reorg 依術語表譯「鏈重組」。建議譯名比照術語表 revert →「回復」 |
| practical Byzantine fault tolerance | 實用拜占庭容錯 | 1 | 寫成「*practical Byzantine fault tolerance*（PBFT）」；之後 PBFT 縮寫保留 |
| Byzantine fault tolerance | 拜占庭容錯 | 1 | 第 276 行「Byzantine fault tolerant（BFT）」；之後 BFT 縮寫保留 |
| difficulty bomb | 難度炸彈 | 1 | |
| equivocating block | 重複提議的區塊 | 1 | 第 77 行「equivocating blocks」，寫成「equivocating 區塊」 |
| deposit contract | 存款合約 | 1 | |
| finality gadget | 最終性元件 | 6 | 含標題「Casper FFG：Finality Gadget」、交互參照 1 次、「Friendly Finality Gadget」的全名 1 次與「friendly finality gadget」1 次（後兩者照原文保留英文） |
| head of the chain | 鏈頭 | 12 | 另有變體「head block」寫成「head 區塊」，共 23 次（未另外標記），回填時請一併處理 |
| metaconsensus | 元共識 | 1 | |
| economic finality | 經濟最終性 | 3 | 含小節標題「Accountable safety 與 economic finality」 |
| supermajority link | 絕對多數連結 | 10 | 含小節標題「Supermajority link」與交互參照 |
| supermajority | 絕對多數 | 9 | 單獨出現的 supermajority（不含 supermajority link），在第 324 行第一次單獨出現處標記；含標題「Supermajority 的中心化」與「supermajority 客戶端風險」 |
| surround vote | 環繞投票 | 3 | 含圖 15-21 圖說 |
| double vote | 雙重投票 | 3 | 原文「double-voting」「double-voted」；含圖 15-20 圖說 |
| accountable safety | 可究責的安全性 | 5 | 含標題與交互參照；標記放在第 342 行定義處，而不是更早的第 276 行章節名稱引用處 |
| plausible liveness | 合理的活性 | 5 | 同上 |
| attester | 見證投票者 | 2 | 「committee of attesters」 |
| timing games | 時機賽局 | 9 | 含標題「Timing Games」、交互參照與圖 15-40、15-41 圖說；標記放在第 606 行定義處（*Timing games*），而不是更早的第 101 行章節名稱引用處 |
| proposer boost | 提議者加權 | 2 | |
| single-slot finality | 單一 slot 最終性 | 1 | |
| max effective balance | 最大有效餘額 | 1 | |

共 26 個 TODO-term 標記。

### 沒有標 TODO-term、直接處理的詞（請審閱時確認）

- **justification / finalization（名詞）、justify / finalize（動詞）**：依術語表 justified「已合理化」、finalized「已最終確定」推得「合理化」「最終確定」。小節標題「Justification and Finalization」譯「合理化與最終確定」。
- **directed acyclic graph → 有向無環圖**、**ASIC → 特定應用積體電路（ASIC）**：臺灣資訊界通用的標準譯名。
- **branch → 分支**（區塊之間的連結，原文另有定義）、**score → 分數**、**source / target → 來源／目標**（第一次寫成「來源（source）」「目標（target）」）、**checkpoint tree → 檢查點樹**、**validator set → 驗證者集合**、**pipelined design → 管線化設計**。
- **majority / minority client → 多數客戶端／少數客戶端**、**consensus bug → 共識錯誤**、**client diversity（diversifying clients）→ 客戶端的多樣化**。
- **collateral → 擔保**（第 107、238 行，指驗證者的質押）：術語表的 collateral 是 DeFi 的「抵押品」，而 stake 條目又規定不用「抵押」，所以這裡用「擔保」。
- **The Casper Commandments → Casper 戒律**。
- **latest message driven / greediest heaviest observed subtree**：協議名稱的展開，保留英文，第一次出現時括號附上說明「最新訊息驅動」「最貪婪的最重觀察子樹」；兩個小節標題保留英文。
- **orphan block 1 → 讓區塊 1 成為孤立的區塊**（第 460 行）。
- **two-way commit**（第 460 行）譯為「雙向提交（two-way commit）」；原文的意思應該是分散式系統的「兩階段提交」（two-phase commit），但照原文翻譯並附英文。
- 章節的交互參照寫成「『某某』一節」，引號內是譯後的標題文字（例如「Timing Games」一節、「共識的原則」一節）。
- 圖片替代文字比照第 8、13 章保留英文，只翻譯圖說。

## 譯註

1. `[^tn1]`（第 302 行，「Justification」小節）：原文說節點看到從一個檢查點到另一個檢查點的轉移時，「justifies the old checkpoint」。但本書的圖 15-18 註腳（第 308 行：看到 link CN → CN + 1，就把 CN + 1 標記為已合理化）、第 312 行的 finalization 說明（從已合理化的檢查點到直接子檢查點的 link 會讓父檢查點最終確定），以及第 436 行四驗證者的例子（A 有 0 → 1 的 supermajority link，所以把 0 最終確定、把 1 合理化）都顯示：link s→t 合理化的是目標 t。譯註也提醒讀者，第 554、584 行 Gasper 範例與圖 15-37、15-39 的圖說採用與第 302 行相同、比上述定義晚一格的說法。**建議回報上游。**
2. `[^tn2]`（第 320 行，「Slashing」小節）：原文說 surround vote 請見「Fork Choice Rule」一節，但該節（第 324 行）完全沒有提到 surround vote；說明 surround vote 的是第 334 行「The Casper Commandments」一節與圖 15-21。**建議回報上游。**

## 可能過時或需查證

- 第 626 行備註說「proposer boost」是 Dencun 硬分叉加入的，而且會「為區塊提議者的見證投票增加權重」、「懲罰延遲提議區塊的提議者」。依譯者印象，proposer boost 是合併之前就已加入共識層規格的分叉選擇規則調整，加權的對象是當前 slot 的提議區塊（在分叉選擇中暫時加上一定比例的權重），本身並不是對提議者的懲罰。無法從本書驗證，未加譯註，**請審閱時查證**。
- 第 668 行把「提高驗證者的最大有效餘額」列為進行中的提案；依譯者印象，這項變更（EIP-7251）已在 2025 年的 Pectra 升級上線。第 107、238 行「至少 32 ETH」仍正確。
- 第 654 行的客戶端使用率（Geth 63%，之後為 Geth 41%、Nethermind 38%）與圖 15-44、15-45 都是時間敏感的數字。
- 第 394 行說 Algorand、Dfinity、Cosmos 這類 PBFT 式機制在這個階段會停擺；屬於原作者的概括說法，未查證各專案現況。

## 疑問與不確定之處

- **圖 15-18 的註腳與圖片不符**：註腳 `[^1]`（第 308 行）描述「CN、CN + 1 的檢查點樹，已最終確定的檢查點以交叉斜線標示並標上 F」，但實際的 `images/ch15/maet_1518.png` 是一張「Round 1: justification」的示意圖（一個人聽到很多「I like X!」），沒有檢查點樹。註腳可能是從其他圖片（或其他資料來源）搬過來的。照原文翻譯，未加譯註。**建議回報上游。**
- 第 380 行說檢查點 N 最終確定後「slot 32N-1 以及之前的每一個 slot」都已最終確定，而第 378 行備註說「直到該 slot 為止（包括該 slot）」都已確定；兩者不矛盾（前者只是沒提到 slot 32N 本身），照原文翻譯。
- 第 622 行「Most of the entries working as validators」的 entries 應為 entities 的筆誤，譯為「實體」。
- 第 640 行「switch back to the correct chain B」的 B 指圖 15-42、15-43 中的「Chain B」，不是被標成 B 的無效區塊；為避免混淆譯為「正確的鏈 B（Chain B）」。
- 第 133 行等處的「C′」保留原文的撇號字元。
- 延伸閱讀第三項是文章標題，保留英文、改用〈〉標示，所以檢查腳本報「疑似未翻譯」1 段。
- 「slot」「epoch」依術語表保留英文；第 61 行 Ethash 的「epoch」（30,000 個區塊）也照寫 epoch。

## 最後一次 `check-translation.rb` 輸出

```
$ ruby scripts/check-translation.rb chapter_15.md
OK   chapter_15.md
  ! 疑似未翻譯的段落 1 段（例如：〈Decentralization Is Good or Not? Defending Consensus in Eth…）
  ! 還有 26 個 TODO-term 標記
譯稿檢查通過：1 個檔案
```
