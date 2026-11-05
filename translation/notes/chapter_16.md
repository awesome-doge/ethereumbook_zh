# 第 16 章（Scaling Ethereum）翻譯筆記

譯稿：`zh-tw/chapter_16.md`；原稿：`upstream/chapter_16.md`（上游 5907a8c）。

筆記中的行號指**譯稿** `zh-tw/chapter_16.md` 的行號。第 387 行之前與原稿行號相同；第 389 行插入了譯註定義 `[^tn1]`（連同空行共多 2 行），所以第 389 行之後的譯稿行號＝原稿行號＋2；檔案最後另加了 `[^tn2]` 定義。

## TODO-term

每個詞只在本章第一次出現處標記；其餘出現處保留英文，不再重複標記。出現次數只算正文（不含 `TODO-term: …（建議：…）` 標記本身裡的那一次；複數形一併計入）。

| 英文 | 建議譯名 | 出現次數 | 標記位置與備註 |
|------|----------|----------|------|
| settlement layer | 結算層 | 3 | 第 7 行（備註框）；第 151、239 行。第 419 行的「final settlement」譯為一般用語「最終結算」，未計 |
| scalability trilemma | 擴容三難 | 3 | 第 11 行；第 13 行標題保留英文「Scalability Trilemma」 |
| block space | 區塊空間 | 3 | 第 43 行；booster rollup 一節 2 次 |
| gas war | gas 競價戰 | 1 | 第 57 行 |
| storage slot | 儲存 slot | 1 | 第 69 行（第 9 章也標過，建議兩種寫法「儲存 slot／儲存槽」一併決定） |
| state bloat | 狀態膨脹 | 1 | 第 75 行 |
| history expiry | 歷史過期 | 4 | 第 75 行；第 133–137 行（術語表已有 state expiry「狀態過期」，兩者宜成對） |
| state rent | 狀態租金 | 1 | 第 75 行；第 133 行「pay rent」譯為一般用語「支付租金」 |
| client diversity | 客戶端多樣性 | 1 | 第 77 行 |
| searcher | 搜尋者 | 3 | 第 89 行（第 14 章也標過同一建議） |
| optimistic concurrency | 樂觀並行控制 | 1 | 第 123 行 |
| order-flow auction | 訂單流拍賣 | 1 | 第 145 行 |
| encrypted mempool | 加密記憶池 | 1 | 第 145 行 |
| operator | 營運者 | 13 | 第 157 行（備註框）；rollup 各節。指 L2 的營運方 |
| cryptoeconomic | 密碼經濟 | 2 | 第 159 行；第 231 行（側鏈） |
| canonical state | 正統狀態 | 2 | 第 161、163 行（其他章標過 canonical chain「正統鏈」） |
| aggregator | 聚合者 | 1 | 第 161 行 |
| bond | 保證金 | 2 | 第 163 行；第 191 行 |
| total value locked | 總鎖倉價值 | 1 | 第 163 行（第 9 章也標過，縮寫 TVL；本章原文沒有縮寫） |
| challenge window | 挑戰期 | 4 | 第 165 行；第 191、195、243 行。第 165 行句末的同義詞「challenge period」也保留英文，未計 |
| training wheels | 輔助輪 | 2 | 第 169 行 |
| exit window | 退出期 | 1 | 第 179 行 |
| Security Council | 安全委員會 | 4 | 第 179 行（含引號）；第 183 行；第 255、257 行的小寫 security council(s) 2 次 |
| allowlist | 允許清單 | 1 | 第 183 行（第 9 章也標過） |
| soundness | 可靠性 | 1 | 第 183 行（第 4 章也標過） |
| watcher | 監看者 | 1 | 第 195 行 |
| double spend | 雙重支付 | 1 | 第 201 行「double-spend attack」 |
| transpiler | 轉譯器 | 1 | 第 211 行 |
| validium | 保留英文 validium | 7 | 第 217 行標題標記（標題寫成「Validium」）；第 219、223（圖說）、225 行 |
| data availability committee | 資料可用性委員會 | 1 | 第 225 行 |
| based rollup | 保留英文 based rollup | 10 | 第 233 行標題標記；另有「based sequencing」1 次（第 239 行）保留英文，未計 |
| liveness | 活性 | 1 | 第 235 行（第 15 章也標過） |
| booster rollup | 保留英文 booster rollup | 4 | 第 245 行標題標記 |
| native rollup | 原生 rollup | 3 | 第 253 行標題標記 |
| fee market | 手續費市場 | 4 | 第 287 行（merged fee market、gas／blob fee market）；第 321 行「multidimensional fee market」譯為「多維的 fee market」 |
| vector commitment | 向量承諾 | 7 | 第 357 行；第 361–383 行 |
| opening | 開啟證明 | 1 | 第 367 行 |
| sibling | 兄弟節點 | 4 | 第 375 行；第 387、395 行 |
| stem | 主幹 | 3 | 第 397 行；第 405 行 |
| suffix | 後綴 | 3 | 第 397 行；第 405 行 |
| extension node | 延伸節點 | 2 | 第 405、406 行 |
| inner node | 內部節點 | 1 | 第 406 行 |
| pairing-based cryptography | 基於配對的密碼學 | 1 | 第 432 行（延伸閱讀清單） |

共 43 個 TODO-term 標記。

### 沒有標 TODO-term、直接處理的詞（請審閱時確認）

- **zero-knowledge rollup → 零知識 rollup**；**ZK rollup／ZK-rollup → ZK rollup**（術語表 [保留]）。原文兩種寫法混用，譯文照原文分別寫，「零知識 rollup」由術語表的「零知識證明」與 rollup [保留] 組成。標題「Zero-knowledge rollups」譯「零知識 rollup」。
- **stage 0／1／2**（rollup 成熟度框架）：第一次寫成「*stage 0*（第 0 階段）」，之後保留「stage 0」。這是 L2BEAT 框架的分級名稱，若要統一譯名請一併決定。小節標題「Rollup stages」譯「rollup 的發展階段」。
- **blob-carrying transaction → 攜帶 blob 的交易**：沿用第 6 章第 149 行的寫法，第一次加「（blob-carrying transaction）」。
- **block propagation → 區塊傳播**、**chain split → 鏈分裂**、**throughput → 吞吐量**、**transactions per second（TPS）→ 每秒交易數（transactions per second，TPS）**、**main chain → 主鏈**、**two-way bridge → 雙向的跨鏈橋**、**global state machine → 全域狀態機**、**stateless execution → 無狀態執行**、**parallel execution → 平行執行**、**shared-state model → 共享狀態模型**、**root commitment → 根承諾**、**block producer → 區塊生產者**、**storage key → 儲存鍵**、**leaf → 葉節點**、**empty node → 空節點**、**RPC endpoint → RPC 端點**、**average load／worst-case load → 平均負載／最壞情況負載**、**high-frequency trading bot → 高頻交易機器人**：一般或由術語表組合而成。
- **weak／strong statelessness → 弱無狀態性／強無狀態性**：由術語表的「無狀態性」組成。
- **miner extractable value → 「礦工可提取價值」（miner extractable value）**：原文在說明舊名稱，故並列英文。
- **fraud-proof game → 詐欺證明賽局**（術語表「詐欺證明」＋「賽局理論」）；**EVM-equivalent → 與 EVM 等價**（第 9、14 章已直接用「EVM 等價」）；**trustless rollup → 免信任 rollup**。
- **KZG ceremony → KZG 儀式**：沿用第 4 章「可信設定儀式」的寫法。
- **atomic transactions → 原子交易**（第 243 行）：沒有標記；其他章對 atomic 有「原子性」的 TODO-term，請一併決定。
- **Layer 1／base layer → 第一層／基礎層**；L1、L2 在第 3 行以「第一層（L1）」「第二層（L2）」並列後，照第 9、14 章的做法沿用縮寫 L1、L2。
- **verifier**（第 255 行，`EXECUTE` 預編譯合約「serve as a verifier」）譯為「驗證方」，依術語表 verifier 的譯法。
- **prover(s)**（第 283、285、311 行）依術語表譯「證明方」。不過依上下文，這幾處的 prover 做的其實是「驗證」承諾或資料（見下方「翻譯時的疑問」）。
- **rolled back／reverted／reversed** 依語境譯「回復」或「撤銷」（術語表 revert＝回復，不用「回滾」）。
- **延伸閱讀清單**（第 423–433 行）：原稿沒有連結，只有標題文字；譯文翻譯說明性的部分，EIP 編號與 Danksharding、Proto-danksharding、Verkle 等名稱照原樣。
- 提示框標籤：`> **Note**  ` 等改成 `> **備註**`、`> **提示**`、`> **警告**`，並去掉行尾的兩個空白（與第 8 章譯稿相同）。
- `[並列]` 術語在本章第一次出現的位置：合併（The Merge）、工作量證明（PoW）、權益證明（PoS）、第一層（L1）、第二層（L2）（第 3 行）；資料可用性（data availability，DA）（第 7 行；原文沒有縮寫，依術語表的並列格式補上 DA）；最大可提取價值（MEV）（第 11 行）；去中心化金融（DeFi）（第 53 行；第 51 行的粗體標題「DeFi Summer」是事件名稱，照原樣）；非同質化代幣（NFT）（第 57 行）；見證投票（attestation）（第 73 行）；去中心化交易所（DEX）（第 91 行）；提議者與建構者分離（proposer-builder separation，PBS）（第 93 行）；以太坊虛擬機（EVM）（第 125 行）；零知識證明（zero-knowledge proof）（第 153 行）；罰沒（slashing）（第 165 行）；兌換（swap）、去中心化應用（DApp）（第 209 行）；共識層（consensus layer）、執行層（execution layer）（第 239 行）；資料可用性抽樣（DAS）（第 289 行，比第 299 行的註腳全名早出現）；點對點（P2P）（第 335 行）；狀態前綴樹（state trie）（第 353 行，註腳 8）。EIP-1559、EIP-4844 這類編號照原樣，沒有套用 EIP 的並列寫法（與其他章一致）。

## 譯註

1. `[^tn1]`（第 385 行，標記在「根據圖 16-5 與圖 16-6 計算的」之後，定義在第 389 行，緊接在第 387 行的清單項目之後）：原文說默克爾樹與 Verkle 樹的證明大小「are calculated based on Figures 16-5 and 16-6」。但本章的圖 16-5 是「Danksharding architecture」，圖 16-6 是「Merkle tree versus Verkle tree」；畫出「7x depth」「4x depth」、與這段計算（七層深度、四層深度）對應的，是圖 16-7「Merkle tree proof size」與圖 16-8「Verkle tree proof size」（已開圖片 `images/ch16/maet_1607.png`、`maet_1608.png` 核對）。可由本章的圖說與圖片本身驗證。**建議回報上游。**
2. `[^tn2]`（第 433 行，延伸閱讀清單最後一項，定義在檔案最後）：原文兩處寫「BLS12-318」，但第 4 章（原稿第 536 行）寫的是以太坊使用的曲線 *BLS12-381*，第 4 章第 943 行也寫 BLS12_381。可由第 4 章驗證，應為筆誤。**建議回報上游。**

## 可能過時或需查證

- **證明大小的算式**（第 387、393 行）：照文字直算，15 個 sibling × 32 位元組 × 7 層 × 1,000 個葉節點 ≈ 3.36 MB（加上葉節點資料仍不到 3.58 MB）；(32＋32＋1) 位元組 × 4 層 × 1,000 ≈ 260 KB，比原文的 150 KB 大。原文的數字可能另有沒寫出的假設（例如多個葉節點共用上層節點的證明），無法只從書本身判斷對錯，所以沒有加譯註。
- **blob 大小「approximately 125 KB」**（第 301 行）：第 6 章（原稿第 149 行）寫每個 blob「about 131,000 bytes」。4,096 × 32 = 131,072 位元組（＝128 KiB），兩章的說法有出入，但都是約略值，沒有加譯註。
- **「1 MB per slot」**（第 305、315 行）與 **「36 million gas」**（第 317 行）：都是撰寫時的參數，可能已隨後續升級改變。第 17 章（原稿第 1065 行）說區塊 gas 上限「fixed at 30 million」，與本章的 3,600 萬不同，屬於不同撰寫時點的數字。
- **4,096 個 epoch 約 18 天**（第 301 行）：4,096 × 32 × 12 秒 ≈ 18.2 天，正確。**36M gas 全用於 calldata 約 2 MB**：以每位元組 16 gas 計約 2.25 MB，約略正確。
- **時效性的數據**：狀態約 1.2 TB、封存節點超過 21 TB、Erigon／Reth 封存節點約 2 TB（第 131 行）；64.85% 的交易可平行化、Monad 每秒超過 10,000 筆交易、Polygon PoS 的 1.6 倍（第 125 行）；「截至 2025 年 3 月」的平行執行計畫（第 125 行）；Arbitrum 的 stage 狀態（2025 年 2 月，第 177 行）；Security Council「八名以上簽署者中至少 50%」（第 179 行，原文註腳 1 也承認規定已修改）；Dankrad Feist 與 Protolambda 的任職單位（第 293 行）；EIP-4488「stagnant」（第 325 行）。
- **Verkle 樹**：第 14 章（原稿第 242 行）提到其他以雜湊為基礎的二元樹正在測試、可能取代 Verkle 樹；本章則把 Verkle 樹當作既定方向。
- **第 361 行**說 vector commitment「scale much better and have a faster computation than hashes」：計算速度比雜湊快的說法值得查證（一般認為 KZG 承諾的計算比雜湊昂貴，優勢在證明大小），但無法從書本身驗證，照原文翻譯。

## 翻譯時的疑問或不確定之處

- **第 283、285 行的 KZG 說明是簡化版**：原文說承諾是「在 KZG 儀式產生的隨機數所決定的點上對多項式求值」，並說「Provers independently evaluate the polynomial at these same points」。但第 4 章（原稿第 817 行）說明承諾是在「沒有人知道的祕密點 s」上求值、結果是橢圓曲線點，所以其他人其實無法直接在同一點上求值比對。原文第 285 行最後一句已說明「實務上更複雜」，屬於刻意的簡化，因此沒有加譯註，只在這裡記錄。同樣地，這兩段（以及第 311 行）的「prover」做的是驗證的工作，依術語表仍譯「證明方」。
- **第 123 行**說「stateless execution」與「optimistic concurrency」兩個概念會在本章後半部詳細說明；後半部確實說明了無狀態性，但沒有再談 optimistic concurrency。照原文翻譯。
- **註腳 6 與註腳 7** 都在解釋 calldata，內容略有不同，照原文分別翻譯。
- 第 3 行「The Merge (the 2022 hard fork …)」的括號說明與「合併（The Merge）」的並列寫法連在一起，寫成「合併（The Merge，2022 年把共識協議從工作量證明（PoW）改為權益證明（PoS）的硬分叉）」，括號有巢狀，審閱時可考慮改寫。
- **TODO-term 出現在標題**：validium、based rollup、booster rollup、native rollup 第一次出現就在小節標題，依第 4 章的先例直接在標題標記；scalability trilemma 第一次出現在第 11 行正文，第 13 行的標題保留英文「Scalability Trilemma」。

## 最後一次 check-translation.rb 輸出

```
OK   chapter_16.md
  ! 還有 43 個 TODO-term 標記
譯稿檢查通過：1 個檔案
```
