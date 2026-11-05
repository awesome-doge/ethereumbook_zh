# 第 17 章（Zero-Knowledge Proofs）翻譯筆記

譯稿：`zh-tw/chapter_17.md`；原稿：`upstream/chapter_17.md`（上游 5907a8c）。

筆記中的「第 N 行」都指原稿 `upstream/chapter_17.md` 的行號（譯稿在原稿第 120、247、626、866 行之後各多了一個譯註定義與一個空行，共多 8 行，其餘行號依序順延）。

23 段 MathML 公式與 7 個程式碼區塊都與原稿逐位元組相同（另以腳本逐段比對確認）。行內 MathML 的段落（第 532–560、643–672、907–959 行）只改了公式前後的英文片段。

## TODO-term

每個詞只在本章第一次出現處標記；其餘出現處保留英文，不再重複標記。出現次數只算正文（含標記處那一次，不含程式碼區塊、行內程式碼、MathML 與譯註）。

| 英文 | 建議譯名 | 出現次數 | 備註 |
|------|----------|----------|------|
| succinct noninteractive argument of knowledge | 簡潔非互動式知識論證 | 1 | 第 8 行，SNARK 的全名；原文是複數 arguments |
| mixer | 混幣器 | 1 | 第 10 行（Tornado Cash）。其他章已有 mixing service（建議：混幣服務），請一併決定 |
| postquantum security | 後量子安全 | 1 | 第 12 行。第 1128、1131 行的 quantum resistant 改寫成「（無法）抵抗量子電腦的攻擊」，未另標 |
| statement | 陳述 | 16 | 第 22 行標記；第 26 行粗體標籤「**Statement**」保留英文。術語表的 statement＝陳述式是程式語境，這裡是零知識證明要證明的命題，所以另標；也可考慮「命題」 |
| completeness | 完備性 | 1 | 第 40 行粗體標籤 |
| soundness | 可靠性 | 1 | 第 44 行粗體標籤；建議譯名沿用第 4 章已標的「可靠性」 |
| solo staker | 獨立質押者 | 1 | 第 65 行 |
| decision problem | 判定問題 | 1 | 第 91 行（備註框） |
| computation trace | 計算軌跡 | 1 | 第 91 行（備註框） |
| execution trace | 執行軌跡 | 1 | 第 91 行（備註框），原文 execution-trace verification。可與 computation trace 合併決定 |
| satisfying assignment | 滿足賦值 | 10 | 第 102 行標記（斜體定義處）；第 733、812、866 行原文只寫 assignment／the assignment，譯稿第 733 行保留 satisfying assignment，第 812、866 行直接寫 `a` |
| dot product | 內積 | 6 | 第 106 行標記；第 118、120（兩次）、239、866 行。也可譯「點積」，請決定 |
| partial-sum list | 部分和串列 | 1 | 第 239 行；本章的 list 一律譯「串列」 |
| verification path | 驗證路徑 | 5 | 第 1020 行標記；第 1022、1029、1033、1041 行 |
| random oracle | 隨機預言機 | 1 | 第 1074 行。「預言機」與術語表 oracle 一致，但這裡是密碼學的隨機預言機模型，不是 DeFi 預言機 |
| transcript | 協議紀錄 | 1 | 第 1098 行 |
| proving key / verification key | 證明金鑰／驗證金鑰 | 各 2 | 第 1124、1126 行 |
| multiparty computation | 多方計算 | 1 | 第 1126 行；密碼學界也常說「安全多方計算」 |
| toxic waste | 有毒廢料 | 2 | 第 1126 行（兩次） |
| ceremony | 儀式 | 1 | 第 1128 行。第 4 章譯稿已直接寫「可信設定儀式」而未標 TODO，請一併確認 |
| scalable transparent argument of knowledge | 可擴展的透明知識論證 | 1 | 第 1131 行，STARK 的全名 |
| transparent | 透明 | 1 | 第 1131 行（另有一次在 STARK 全名中、一次在論文標題中） |
| collision-resistant | 抗碰撞 | 1 | 第 1131 行。第 4 章譯稿已直接寫「抗碰撞性」而未標 TODO，請一併確認 |

共 23 個 TODO-term 標記（`check-translation.rb` 的計數）。

## 直接採用、未標 TODO 的譯名

以下是一般數學／資訊用語或可由術語表組合出的詞，直接翻譯，列出供審閱：

- zero-knowledge cryptography → 零知識密碼學（第 3 行首次出現加英文）；zero knowledge（性質）→ 零知識、零知識性
- EVM state transition function → EVM 狀態轉換函數（第 58 行；EVM 首次出現依 [並列] 寫成「以太坊虛擬機（EVM）」）
- multiset → 多重集合；subset → 子集合；NP-complete → NP 完全；polynomial time → 多項式時間
- list → 串列（`s`、`a`、`w` 都是串列）
- circuit → 電路（術語表有 arithmetic circuit＝算術電路）；第 1144 行首次出現寫「*電路*（circuit）」
- challenge → 挑戰；query → 查詢；public inputs → 公開輸入；leaves（默克爾樹）→ 葉節點
- brute-force attack → 暴力破解攻擊（與第 5 章譯稿一致）
- aggregate zero-knowledge proof → 聚合的零知識證明；real-time proving → 即時證明；proving time → 證明時間；recursion → 遞迴
- throughput → 吞吐量；block space → 區塊空間；tip of the chain → 鏈的最前端
- public key cryptosystem → 公開金鑰密碼系統（第 1057 行；不是術語表的 public key cryptography，所以未並列）
- proposition → 命題（第 1142 行）；repository → 儲存庫（第 1146 行）
- Hash 8／Hash 15 → 雜湊 8／雜湊 15；hash* 8 → 雜湊* 8（指圖 17-2、17-3 中葉節點的雜湊值，圖中文字是英文）
- "one circuit to rule them all" → 「一個電路統御全部」（化用《魔戒》的 One Ring to rule them all）
- 論文標題（第 7、1053、1130、1168、1169 行）保留英文原題，外加〈〉；第 1167 行「A simple example」譯為「一個簡單的例子」，第 1170 行書名保留英文
- 圖片替代文字比照第 8、13 章保留英文

## 譯註

共 4 個，都能從本章內容本身驗證：

1. `[^tn1]`（第 120 行）：原文說長度為 `n` 的串列 `[s0, s1, s2, sn]`，而公式求和上限是 n。本章的索引從零開始（第 268 行：`w` 只有四個元素、索引從零開始，所以沒有 `w[4]`），長度為 n 時最後一個元素應是 s(n−1)，上限應為 n − 1。MathML 不能動，所以用譯註說明。
2. `[^tn2]`（第 247 行）：「the proof `p` we have built so far」——本章從未定義 `p`，上下文被修改的是 `w`（同一句接著把 `w` 的最後一項移到第一位）。
3. `[^tn3]`（第 626 行）：第 626 行說「計算 `w` 並加上 `r = 1`」，但下面的公式（第 628–641 行）顯示的是正負號不變的 `a`，它應接在第 624 行「這次是正面，不改變正負號」之後；而加上 r 之後的 w″ 沒有列出。由第 250 行的 `w = [0, 1, 2, 7]` 加 1 可得 w″ = [1, 2, 3, 8]，與第 643–671 行提供的 w″[2] = 3、w″[3] = 8 一致。結構規則不允許調換段落順序，所以只加譯註。
4. `[^tn4]`（第 866 行）：「compute `w` as the dot product between `a` and `s` (with a swap between the first and last elements)」——依第 239 行，`w` 是部分和串列，不是單一內積；而且第 242→250 行的 [1, 2, 7, 0]→[0, 1, 2, 7] 是把最後一項移到第一位（第 247 行原文自己就這樣說），首末對調會得到 [0, 2, 7, 1]。

## 可能過時或需查證

以下懷疑原文不精確或可能過時，但無法單從本書驗證，沒有寫進譯註，照原文翻譯：

- 第 96 行：「NP-complete, meaning that an algorithm doesn't exist that can solve it in polynomial time」。NP 完全的定義並不是「不存在多項式時間演算法」，而是「目前不知道有沒有」（取決於 P 是否等於 NP）；分割問題也有偽多項式時間的動態規劃解法。屬於計算理論的定義問題，本書沒有可對照的內容，請審閱者決定是否加譯註。
- 第 12 行：Monero 使用 Bulletproofs 隱藏交易金額、Starknet 以 STARK 為基礎——屬於專案現況，可能隨時間改變。
- 第 75 行：「today, it's quite hard to achieve」對以太坊區塊做即時證明，以及第 81 行 ZK rollup「大約每小時」發布一次聚合證明——這類效能描述時效性很強。
- 第 1148 行：「at the time of writing (June 2025), we have far more optimistic rollups than ZK rollups」——有明確日期，照譯。
- 第 1151 行：「The most famous zk-VMs right now are SP1 and RISC Zero」——時效性描述。
- 第 1124 行：「SNARK systems rely on … trusted setup」寫得像所有 SNARK 都需要可信設定；但本章第 12 行自己提到 Bulletproofs 不需要可信設定，現實中也有不需可信設定的 SNARK。屬於概括性的簡化，照譯。
- 第 1121 行：「the commitment `w`」——本章把 `w` 定義為見證（第 239 行），承諾是默克爾根（第 905 行）。用詞不精確，但不影響理解，照譯「承諾 `w`」，沒有加譯註；審閱者可決定是否補一個。
- 第 1161 行原文寫「Bit+11」，第 8、1122 行寫「BIT+11」，大小寫不一致，照原文保留。

## 翻譯時的疑問

- statement 是本章核心術語，出現 16 次，目前全部保留英文。若定案為「陳述」，要注意與術語表程式語境的「陳述式」區分；第 7 行「your statement is actually true」是一般用法，譯為「你的說法確實為真」，沒有使用術語。
- 第 26、40、44 行的粗體定義標籤：Statement、Completeness、Soundness 依 TODO-term 規則保留英文（後兩者在標籤後加標記）；Witness、Proof、Zero knowledge 依術語表譯為「見證」「證明」「零知識」。
- 原文寫 zk-VM（有連字號），術語表寫 zkVM；依原文拼法保留 zk-VM。第 1135 行標題「Zk-EVM and zk-VM」與第 1149 行句首的「Zk-VMs」改為小寫 zk-EVM／zk-VM。
- 第 77 行標題「L2s Also Benefit from ZK」譯為「第二層也能受惠於零知識技術」；L2 已在第 12 行依 [並列] 首次寫成「第二層（L2）」，L1 在第 83 行首次寫成「第一層（L1）」。
- 第 1049 行「(so much luck here, eh?)」譯為「（這裡的運氣也太好了吧？）」，保留原文調侃的口吻。
- 第 1071–1072 行原文是清單第 4 項後直接接一行正文（沒有空行），pandoc 會把它併入第 4 項；譯稿照原稿保留同樣的換行。
- verifier 的代名詞 they 多半改寫成「驗證方」或「對方」，避免「他們」指涉不清。

## 最後一次 check-translation.rb 輸出

```
$ ruby scripts/check-translation.rb chapter_17.md
OK   chapter_17.md
  ! 還有 23 個 TODO-term 標記
譯稿檢查通過：1 個檔案
```
