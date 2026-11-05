# 第 6 章（Transactions）翻譯筆記

譯稿：`zh-tw/chapter_6.md`；原稿：`upstream/chapter_6.md`（上游 5907a8c）。

筆記中的「第 N 行」都指原稿 `upstream/chapter_6.md` 的行號。除了兩個譯註註腳各增加 2 行之外，譯稿與原稿行數相同（譯註註腳插在段落之後，因此第 465 行之後的譯稿行號會往後移 2 行，第 563 行之後再移 2 行）。

## TODO-term

每個詞只在本章第一次出現處標記；其餘出現處保留英文，不再重複標記。出現次數只算正文（不含程式碼區塊、行內程式碼與圖片替代文字），包含標記本身那一次。

| 英文 | 建議譯名 | 出現次數 | 備註 |
|------|----------|----------|------|
| typed transaction envelope | 型別化交易封裝 | 1 | 第 75 行，EIP-2718 的機制 |
| storage slot | 儲存槽 | 5 | 第 75、79、81 行。第 9 章的 TODO-term 建議是「儲存 slot」，兩章建議不同，請統一決定。不直接寫「slot」，以免與共識層的 slot（12 秒時段）混淆 |
| warm access / cold access | 暖存取／冷存取 | warm access 2、cold access 2 | 第 79 行備註框；另有「storage slot 是 warm 時」一處單獨使用 warm |
| fee market | 手續費市場 | 2 | 第 85、418 行 |
| sidecar | 附帶資料 | 1 | 第 149 行，blob 交易 |
| versioned hash | 版本化雜湊 | 2 | 第 159、161 行；標記放在粗體欄位標籤「blob 的 versioned hash」中（標籤是第一次出現處） |
| sponsorship | 代付 | 1 | 第 183 行，EIP-7702 的用途之一（粗體標籤） |
| unspent transaction output (UTXO) | 未花費交易輸出 | 1 | 第 215 行；縮寫 *UTXO* 保留在後面的括號中 |
| checksum | 校驗和 | 1 | 第 449 行，位於指向第 4 章「以大小寫表示 checksum 的十六進位編碼（ERC-55）」一節的交互參照中；第 4、5 章的建議同樣是「校驗和」 |
| payment channel | 支付通道 | 1 | 第 449 行 |
| recovery identifier | 復原識別碼 | 2 | 第 770 行（同段兩次） |
| private mempool | 私有記憶池 | 5 | 第 1197 行標題（保留英文 `### private mempool`，未標記）、第 1201 行標記處、第 1203、1207 行 |

共 12 個 TODO-term 標記。

### 沒有標 TODO-term、直接處理的詞（請審閱時確認）

- **value（交易欄位）→ 金額**：欄位標籤「**Value**」與內文的 value 都譯「金額」（例如「同時有金額與資料的交易」）；小節標題「Transmitting Value to EOAs and Contracts」譯「把價值傳送給 EOA 與合約」。程式碼與行內程式碼的 `value` 不動。
- **ether 的數量**：依術語表「金額寫成 0.1 ETH」，正文中「6 ether」「0.001 ether」等一律寫成「6 ETH」「0.001 ETH」；不帶數字的 ether 譯「以太幣」，第一次出現處（第 57 行）寫成「以太幣（ether）」。
- **Legacy transactions → Legacy 交易**、**nonlegacy transactions → 非 Legacy 交易**：依任務指示，交易類型名稱保留英文。
- **delegation designator → 委託指定**：原文用 designator（第 191 行），術語表的條目是 delegation designation（委託指定）。兩者指同一機制，因此直接使用「委託指定」。請確認術語表是否要補上 designator 的寫法。
- **block gas target → 區塊 gas 目標**：由術語表的「區塊 gas 上限」與「gas 目標」組合而成。
- **blob gas**：blob 與 gas 都保留英文，因此保留「blob gas」；「blob-carrying transactions」譯「攜帶 blob 的交易」。
- **block reorganization / block reorgs → 鏈重組**：依術語表 reorg 的譯法，寫成「*鏈重組*（block reorganization，簡稱 *block reorg*）」。
- **proposer and builder separation → 提議者與建構者分離（PBS）**：原文這裡沒有縮寫，依術語表 [並列] 規則加上（PBS）。**builders → 區塊建構者**（術語表 block builder）。**block producers → 區塊生產者**。
- **DeFi Summer**：本章 DeFi 只出現在這個名稱裡，寫成「DeFi 之夏」（DeFi Summer），沒有展開成「去中心化金融（DeFi）」。
- **concurrency → 並行**、**multithreading → 多執行緒**、**multiprocessing → 多處理程序**、**process → 處理程序**：一般電腦科學用語。concurrency 第一次出現寫成「*並行*（concurrency）」。
- **hot wallet / cold wallet → 熱錢包／冷錢包**：通用說法，直接使用。
- **offline signing → 離線簽署**、**air-gapped → 實體隔離**（第一次以斜體出現時附英文「air-gapped system」）。
- **raw transaction → 原始交易**、**public key recovery → 公鑰復原**、**ephemeral key → 臨時金鑰**（第一次附英文 ephemeral）。
- **nonrepudiation → 不可否認性**、**authentication → 身分驗證**、**integrity → 完整性**。
- **function prototype → 函式原型**、**multiplicative inverse → 乘法反元素**、**big-endian → 大端序（big-endian）**、**payload → 酬載**、**metadata → 詮釋資料**、**serialize → 序列化**、**chain ID → 鏈 ID**、**chain identifiers → 鏈識別碼**。
- **burn / burn address → 銷毀／銷毀地址**（術語表 mint / burn）；**ether burn → 以太幣銷毀**。
- **batching → 批次處理**、**privilege deescalation → 權限降級**、**subkeys → 子金鑰**。
- **Yellow Paper → 黃皮書**。
- **Gas is the fuel of Ethereum**：術語表把「燃料」列為 gas 的「不用」譯法（檢查腳本會擋），因此譯成「gas 是驅動以太坊運轉的動力」；油箱比喻中用「油箱」「汽油」「油耗」，避開「燃料」。
- 保留英文：mcguffin-widget（原文的戲謔商品名）、Ethereum Sepolia／Ethereum Holesky、London／Cancun／Pectra／Spurious Dragon（升級名稱）、Flashbots Protect、smart transactions（MetaMask 的功能名稱，連結文字保留英文）、Gnosis Safe／Safe、ZeroMQ、TCP socket。EIP-155 標準名稱寫成「Simple Replay Attack Protection」（簡易重放攻擊防護）。
- 介面文字：水龍頭按鈕「Receive 0.05 Sepolia ETH」、Etherscan 的「input data」保留英文。

## 譯註

1. `[^tn1]`（第 465 行）：原文說圖 6-4 中的資料酬載「是空的（`0x00`）」。空的資料酬載是長度為零的位元組序列，寫成 `0x`；`0x00` 是一個值為零的位元組，並不是空的。本章「Deserializing the Transaction」一節（第 1002–1004 行）解碼交易欄位時，就把 `0x` 列為「The empty data payload」，可以在書中直接驗證。**建議回報上游。**
2. `[^tn2]`（第 563 行）：原文說要計算「the argument `withdraw_amount` and `_to`」，第 570 行又寫 `withdraw_amount`；但本章第 536 行的函式宣告與第 541 行的清單（以及第 2 章範例 2-1）中，參數名稱都是 `_withdrawAmount`。譯註說明兩者指同一個參數，且參數名稱不影響選擇器與 calldata 編碼。**建議回報上游。**

## 可能過時或需查證

以下沒有寫進譯文或譯註：

- 第 17 行「At the time of writing (June 2025), five transaction types exist」：之後是否有新的交易類型，需查證。
- 第 91 行與圖 6-1：區塊 gas 上限的歷史值寫到 3,000 萬；之後是否再調整，需查證。
- 表 6-2 列出 Ethereum Holesky（chain ID 17000）：Holesky 測試網路目前的狀態需查證。
- 第 1217 行 Gnosis Safe 保護的資產金額（截至 2024 年 11 月）是時間點數據；Gnosis Safe 現在的名稱與數據需查證。
- 第 1203 行「MetaMask … has started to use private mempools by default」：功能名稱與預設行為可能已變更。
- 第 1195 行：「Flashbots v0.1 於 2021 年 1 月發布」等時間點，依原文翻譯，未查證。
- 第 159 行欄位名稱「Blob versioned hashed」疑為「Blob versioned hashes」的筆誤；譯文直接譯成「blob 的 versioned hash」，沒有加譯註。
- 第 770 行「the ECDSArecover function」：疑為 `ecrecover`（第 7 章第 472 行介紹的內建函式）或「ECDSA recover」少了空格；譯文照原文保留 ECDSArecover。
- 第 1079 行行內程式碼 `ethers.JsonRpcProvider("..."").broadcastTransaction` 多了一個引號，而且 ethers v6 的 `JsonRpcProvider` 需要用 `new` 建立實例（範例 6-1 寫的是 `new ethers.JsonRpcProvider(...)`）。行內程式碼依規定不動。**建議回報上游。**
- 「ECDSA Math」一節：簽章公式用 `p` 表示「橢圓曲線的質數階」，而第 1052 行公鑰復原一節改用 n 表示曲線的階，符號前後不一致（secp256k1 的有限體質數 p 與群的階 n 是不同的數）。另外第 1052 行「z 是訊息雜湊值最低的 n 個位元，其中 n 是橢圓曲線的階」不精確，應為「n 的位元長度」。程式碼區塊中的 `s-1`、`r–1` 原本應是上標的 −1（反元素），排版時遺失；程式碼區塊依規定不動。以上依原文翻譯，未加譯註。

## 翻譯時的疑問或不確定之處

- 交互參照第 4 章的小節名稱，用的是目前 `zh-tw/chapter_4.md` 的標題：「KZG 承諾」、「橢圓曲線密碼學解說」、「以大小寫表示 checksum 的十六進位編碼（ERC-55）」。如果第 4 章的標題之後修改，本章的三處引用（第 149、449、669 行）要一併更新。本章內部的交互參照（「交易的結構」「ECDSA 的數學」「建立與簽署原始交易」「使用 EIP-155 建立原始交易」「簽章前綴值（v）與公鑰復原」）已與本章譯後的標題一致。
- 圖說原稿是 `**Figure 6-1.** 說明` 的粗體格式（與第 13 章不同），譯稿保留粗體，寫成 `**圖 6-1.** 說明`。
- 欄位清單的粗體標籤（**Chain ID**、**Gas price** 等）譯成中文；**Nonce** 與 **v,r,s** 保留原樣。EIP-1559 的兩個費用欄位譯成「每單位 gas 的最高優先費用」「每單位 gas 的最高費用」，blob 欄位譯成「每單位 blob gas 的最高費用」。
- 第 201 行黃皮書引文保持一般引文（`>`），不是提示框；開頭寫成「nonce：」。
- 「### Private Mempools」標題寫成「### private mempool」（保留英文、未標記），TODO-term 標在下一段正文第一次出現處。
- 第 1024 行把原文的「The EIP-155 "Simple Replay Attack Protection" standard」譯成「EIP-155「Simple Replay Attack Protection」（簡易重放攻擊防護）標準」，保留標準的英文名稱並附中文說明。
- 「two of two or three of four signatures」寫成「2-of-2 或 3-of-4 的簽章」。

## 最後一次 check-translation.rb 輸出

```
$ ruby scripts/check-translation.rb chapter_6.md
OK   chapter_6.md
  ! 還有 12 個 TODO-term 標記
譯稿檢查通過：1 個檔案
```
