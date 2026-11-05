# 第 2 章（Ethereum Basics）翻譯筆記

譯稿：`zh-tw/chapter_2.md`；原稿：`upstream/chapter_2.md`（上游 5907a8c）。

筆記中的「第 N 行」都指原稿 `upstream/chapter_2.md` 的行號（譯稿在第 334、497 行之後各多了兩行（譯註定義與其後的空行），因此第 335 行以後的譯稿行號比原稿多 2，第 498 行以後多 4）。

## TODO-term

每個詞只在本章第一次出現處標記；其餘出現處保留英文，不再重複標記。出現次數只算正文（含標記處那一次，不含程式碼區塊、行內程式碼與圖片替代文字）。

| 英文 | 建議譯名 | 出現次數 | 備註 |
|------|----------|----------|------|
| seed phrase | 種子短語 | 5 | 第 39 行標記；第 113 行（提示框，2 次）、第 123 行、第 133 行。與第 5 章的 TODO-term 建議一致。術語表的 seed「種子」、mnemonic「助記詞」都有，但複合詞 seed phrase 沒有，所以照規則標記 |
| address poisoning | 地址投毒 | 1 | 第 245 行（警告框） |
| global singleton | 全域單例 | 1 | 第 253 行 |
| internal transaction | 內部交易 | 5 | 第 519 行標記；第 521、527（圖說）、529、535 行。Etherscan 的分頁名稱「Internal Transactions」是介面文字，照規則保留英文，未計入 |

共 4 個 TODO-term 標記。

## 譯註

共 2 則。

1. `[^tn1]`（第 334 行）：原文寫「If the `withdraw` function is called with a `withdraw_amount` …」，但範例 2-1 的程式碼與本段前文的參數名稱都是 `_withdrawAmount`。行內程式碼照原稿保留 `withdraw_amount`，譯註說明兩者指同一個參數。可由範例 2-1 第 283、286 行的程式碼驗證。
2. `[^tn2]`（第 497 行，提示框）：提示框說「Remix 無法處理像 10^17^ 這麼大的數字」，但本例實際輸入的金額是 1,000,000,000,000 wei，也就是 10^12^（第 491 行「a 1 followed by 12 zeros」、第 499 行的 `"1000000000000"`）。譯註只指出書中數字前後不一致，沒有加入 JavaScript 數值上限之類的外部說明。這段看起來是第一版（當時提領 0.1 ether = 10^17^ wei）留下的文字。

另外考慮過、但**沒有**加譯註的地方：第 334 行「1,000,000,000,000 wei, which is the base unit of ether (see Table 2-1)」。這裡的 which 修飾的是 wei（wei 是基本單位），並不是說 10^12^ wei 是基本單位，所以不算錯誤；譯文寫成「1,000,000,000,000 wei（wei 是以太幣的基本單位，見表 2-1），也就是 0.000001 ETH」，避免歧義。

## 可能過時或需查證

以下無法從本書內容驗證，沒有寫進譯文或譯註：

- 第 97、99 行：MetaMask 擴充功能「超過 5,400 則評論」「超過 1,500 萬名使用者」，數字會隨時間變動。
- 第 151–153 行：Holesky 測試網路的介紹。Holesky 的現況（是否仍在運作、是否已有後繼測試網路）需要查證；MetaMask 目前的網路清單也可能不同。
- 第 149 行：Sepolia 於 2021 年 10 月以權威證明網路推出、後來改用權益證明，屬外部史實，未查證。
- 第 171、177 行：MetaMask 的操作路徑（左上角以太坊圖示、「Show test networks」、點擊 Buy 再前往水龍頭清單）可能已隨版本改變。
- 第 419 行：Remix 的「Run」分頁與「Injected Web3」環境名稱，在較新版的 Remix 中可能已改名（例如 Deploy & run transactions、Injected Provider）。
- 第 427、505 行：MetaMask 的核准按鈕寫成「Submit」，新版介面可能是其他名稱。
- 第 433 行：「大約需要 15 到 30 秒」，在權益證明之後的區塊間隔下可能不同。
- 第 483 行：Remix 中 withdraw 按鈕是「紅色方框」，新版顏色可能不同。
- 第 269 行：「Solidity 由 Gavin Wood 創造」，屬外部史實，未查證。
- 第 350 行：「多次合約呼叫很可能會超過」2,300 gas 上限的說法較籠統（實際上即使單次呼叫，接收方合約若執行稍多邏輯就可能超過），照原文翻譯。

## 翻譯時的疑問或不確定之處

- **介面文字**：MetaMask 的網路名稱（**Main Ethereum Network**、**Sepolia Test Network**、**Holesky Test Network**、**Localhost 8545**、**Custom RPC**）是選單項目，照規則保留英文作為粗體小標；其他按鈕、分頁、欄位（Add to Chrome、Show test networks、Buy、View on block explorer、Reject、Settings → Security and Privacy、View account on Etherscan、Compile *Faucet.sol*、Compiler、Run、Environment、Injected Web3、Account、Deploy、Submit、transact、withdraw、Internal Transactions、Account 1、Main Network）也都保留英文。
- **金額寫法**：術語表說以太幣金額寫成「0.1 ETH」，所以原文的「0.01 ether」「0.000001 ether」等金額都改寫成「0.01 ETH」「0.000001 ETH」（含圖說 2-9、2-21）。唯一例外是第 7 行列舉寫法的「1 ether、1 ETH、Ξ1 或 ♦1」，那裡是在說明符號，照原文保留。
- **表 2-1**：單位名稱（俗稱與 SI 名稱）保留英文，只把表頭與「or」譯成中文（「Kilowei 或 femtoether」）。表頭「Value (in wei)」譯為「數值（以 wei 計）」。
- **以太幣的並列**：第 5 行是標題，第一次在正文出現於第 7 行，寫成「*以太幣*（ether）」。
- **EVM 的並列**：本章第一次出現在第 53 行（Phantom 的介紹「other EVM and non-EVM networks」），因此在那裡寫成「以太坊虛擬機（EVM）」；第 251 行的 *EVM* 就只寫 EVM。
- **權威證明**：第 149 行原文只有全名「proof-of-authority」、沒有縮寫，所以寫成「權威證明（proof of authority）」；同句的 PoS 只有縮寫，寫成「權益證明（PoS）」。
- **message**：第 519 行「internal transaction (also called a *message*)」的 message 譯為一般詞「訊息」，沒有標 TODO-term。其他章有 message call 的 TODO-term（建議：訊息呼叫），如果全書要統一 message 的譯法，這裡要一起回填。
- **withdraw / withdrawal**：水龍頭合約的提領一律譯「提領」，與術語表 withdrawal「提領」一致（術語表的說明是驗證者質押提領，但一般提款語境沿用同一個詞）。
- **mnemonic backup**：譯為「助記詞備份」（術語表 mnemonic「助記詞」）。
- **quintillion**：譯為「一百京」（10^18^ 的台灣中文數詞），括號中的阿拉伯數字照原文保留。
- **「Ether Currency Units」的交互參照**：第 219 行的「as we discussed in "Ether Currency Units"」寫成「我們在『以太幣的貨幣單位』一節討論過」，與第 5 行的標題譯文一致（譯文實際用「」）。
- **pragma directive / statement**：第 302 行的「`pragma` statement」譯「`pragma` 陳述式」（術語表 statement「陳述式」）；第 395 行的「`pragma` directive」譯「`pragma` 指示詞」。

## 最後一次 `check-translation.rb` 的輸出

```
$ ruby scripts/check-translation.rb chapter_2.md
OK   chapter_2.md
  ! 疑似未翻譯的段落 10 段（例如：The detail page of the MetaMask Chrome extension…）
  ! 還有 4 個 TODO-term 標記
譯稿檢查通過：1 個檔案
```

「疑似未翻譯的段落」10 段全部是圖片的英文替代文字（依指引比照第 8、13 章保留英文），不是漏譯的正文。
