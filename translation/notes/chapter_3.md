# 第 3 章（Ethereum Nodes）翻譯筆記

譯稿：`zh-tw/chapter_3.md`；原稿：`upstream/chapter_3.md`（上游 5907a8c）。

筆記中的「第 N 行」都指原稿 `upstream/chapter_3.md` 的行號。

## TODO-term

每個詞只在本章第一次出現處標記；其餘出現處保留英文，不再重複標記。出現次數只算正文（不含程式碼區塊與圖片替代文字），包含第一次標記的那一次。

| 英文 | 建議譯名 | 出現次數 | 備註 |
|------|----------|----------|------|
| remote client | 遠端客戶端 | 13 | 第一次在第 101 行；含第 673 行的節標題「Remote Ethereum Clients」（譯為「以太坊 remote client」）。本章核心概念之一，與 light client（輕客戶端）對照，建議儘早定案 |
| prune | 修剪 | 2 | 第 188 行（原文「pruned」）；第 747 行定義句「Prune historical data」也保留 prune |
| client diversity | 客戶端多樣性 | 1 | 第 324 行 |
| JWT secret | JWT 共用祕密 | 2 | 第一次出現在第 339 行的粗體導語「Generating a JWT Secret」（標記放在導語後）；另一次在第 353 行。不建議用「密鑰」（術語表的「不用」詞） |
| snap sync | 快照同步 | 3 | 第 587、589 行 |
| checkpoint sync | 檢查點同步 | 2 | 第 587、589 行。checkpoint、sync 在術語表都有譯名，但這是客戶端的功能名稱，與 snap sync 成對，所以一併標記 |
| data payload | 資料酬載 | 1 | 第 681 行 |
| history pruning | 歷史資料修剪 | 1 | 第 745 行的粗體條目（EIP-4444 的概念）；應與 prune 一起決定 |

共 8 個 TODO-term 標記。

### 沒有標 TODO-term、直接處理的詞（請審閱時確認）

- **reference implementation / reference specification** → 參考實作／參考規格（第 5 章已有「參考實作」）。
- **executable pseudocode specifications** → 可執行的虛擬碼規格。
- **Yellow Paper** → 「黃皮書」（Yellow Paper），比照第 6、14 章的「黃皮書」寫法，第一次加註英文。
- **Simplified Payment Verification (SPV)** → 簡化支付驗證（Simplified Payment Verification，SPV），比照《精通比特幣》譯本。
- **batching** → 批次處理（batching），第 633 行。
- **full sync / fast synchronization / full validation** → 完整同步／快速同步／完整驗證。
- **tip of the chain** → 鏈的最前端。
- **hosted node API** → 服務供應商代管的節點 API（避免用「託管」，術語表的 custody 譯「託管」）。
- **permissioned** → 需許可的（與 permissionless「無需許可」對照）。
- **block producers / block production** → 區塊產生者／區塊產生。
- **command-line interface (CLI)** → 命令列介面（CLI）；CLI flags → CLI 旗標。
- **repository / clone** → 儲存庫／複製（第一次寫「複製（clone）」）；precompiled binary → 預先編譯執行檔。
- **solid-state drive (SSD) / hard-disk drive (HDD)** → 固態硬碟（SSD）／傳統機械硬碟（HDD）；input/output (I/O) → 輸入／輸出（I/O）。
- **port 8545** → 8545 連接埠；IP address → IP 位址（依術語表 address 的說明）。
- **stub** → 存根（stub），依術語表 [並列]。
- **multichain wallet** → 多鏈錢包；plug-n-play → 隨插即用；Bash-fu → 「一點 Bash 功夫」。
- **UI** → 使用者介面（UI）。
- **[並列] 術語第一次出現**：點對點（P2P，第 3 行，比照第 4 章只寫縮寫）、合併（The Merge）、工作量證明（proof of work，PoW）、權益證明（proof of stake，PoS）（第 5 行）、以太坊虛擬機（EVM，第 15 行）、以太坊改進提案（Ethereum Improvement Proposal，EIP，第 29 行）、權威證明（proof of authority，第 101 行）、以太幣（ether，第 134 行）、阻斷服務（denial of service，DoS，第 585 行）、去中心化應用（DApp，第 682 行）、第二層（layer 2，L2）與第一層（layer 1，L1）（第 701 行）、零知識證明（zero-knowledge proof，第 755 行）。
- **客戶端名稱**（Geth、Reth、Nethermind、Besu、Erigon、Lighthouse、Prysm、Teku、Nimbus、Lodestar）、錢包與公司名稱（MetaMask、Rabby Wallet、Coinbase Wallet、Phantom、Trust Wallet、Uniswap Wallet、Ledger、Trezor、Helios、Dappnode、BuidlGuidl Client、Anvil、Infura、Alchemy）保留英文。第 254 行連結文字「Ethereum」譯為「以太坊」，BNB Chain、Polygon PoS 保留英文。

## 譯註

1. `[^tn1]`（第 473 行，Lighthouse 一節）：原文說「Go back to the *ethereum-node2* folder」，接著的程式碼是 `cd .. # this command is used to go back in the ethereum-node2 folder` 與 `cd consensus`。但從同章的指令可以驗證：第 442–453 行依序執行了 `cd ethereum-node2`、`cd execution`、`git clone …reth`、`cd reth`，所以此時的目錄是 *ethereum-node2/execution/reth*，`cd ..` 只會回到 *ethereum-node2/execution*，接著的 `cd consensus` 會失敗。應為 `cd ../..`（Geth-Prysm 一節第 329 行在同樣情況下用的就是 `cd ../..`）。程式碼區塊依規定不改，以譯註說明。**建議回報上游。**

其他 `cd` 步驟已逐一核對（第 231、329、358、381、513 行），都與註解相符。

## 可能過時或需查證

- 第 132 行說測試網路節點約需 100–300 GB，第 166 行說在測試網路上執行完整節點需要額外 100–400 GB。兩處數字不同，可能是語境不同（資料量 vs. 磁碟需求），照譯，未加譯註。
- 第 283 行說 Geth 最新版「right now」是 v1.14.3，日誌時間是 2024-06-08；但本章其他地方以「截至 2025 年 6 月」為準。版本號可能過時。
- 第 324 行 Prysm 市占率「37%」沒有註明時間點，需查證。
- 第 589 行說 Reth 截至 2025 年 6 月還不支援 snap sync，需查證。
- 第 661 行說完整的 JSON-RPC API 可以在「Ethereum wiki」查閱；以太坊的 JSON-RPC 文件可能已移到其他位置，連結需查證。
- 第 713 行說 Uniswap Wallet「quite new」，可能過時。
- 第 196 行提示框說指令「shown in bold」，但 Markdown 程式碼區塊中的指令並沒有粗體，這是沿用紙本排版的說法。照譯。
- 第 654 行 0x1B1717FC7 = 7,271,972,807 wei ≈ 7.27 gwei，已驗算無誤。

## 翻譯時的疑問或不確定之處

- 「Consensus client」「Execution client」依術語表譯為「共識層客戶端」「執行層客戶端」，連列表導語「The execution clients are:」也照用。
- 第 5 行「separation of concerns」譯為「關注點的分離」，並保留原文破折號的補充「共識與執行分開」。
- 第 85 行「keep data indefinitely」譯為「無限期保存資料」；第 95 行把 full node 定義為「discard historical state and receipts」，與第 85 行略有矛盾，但這是原文本身的寫法（第 89 行「To be really precise」就是在修正前面的說法），照譯。
- 第 101 行「a public or permissioned (proof-of-authority) testnet」譯為「公開的或需許可的權威證明（proof of authority）測試網路」，括號的位置稍作調整。
- 原稿第 25、79、89–94 行提示框帶有行尾雙空白（Markdown 換行），譯稿保留了相同的行尾空白；第 7、721 行原稿含不換行空白（U+00A0），譯文改為一般寫法。

## 最後一次 check-translation.rb 輸出

```
OK   chapter_3.md
  ! 還有 8 個 TODO-term 標記
譯稿檢查通過：1 個檔案
```
