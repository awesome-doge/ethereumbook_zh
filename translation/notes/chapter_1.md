# 第 1 章（What Is Ethereum?）翻譯筆記

譯稿：`zh-tw/chapter_1.md`；原稿：`upstream/chapter_1.md`（上游 5907a8c）。

筆記中的「第 N 行」都指原稿 `upstream/chapter_1.md` 的行號（譯稿在第 112 行之後多了兩行（譯註定義與其後的空行），因此原稿第 114 行（`**The Merge**`）以後的譯稿行號比原稿多 2）。

## TODO-term

每個詞只在本章第一次出現處標記；其餘出現處保留英文，不再重複標記。出現次數只算正文（含標記處那一次）。建議譯名沿用其他章已提出的建議，方便統一決定。

| 英文 | 建議譯名 | 出現次數 | 備註 |
|------|----------|----------|------|
| Byzantine fault tolerance | 拜占庭容錯 | 1 | 第 13 行，原文是「a Byzantine, fault-tolerant consensus algorithm」，寫成「具備 Byzantine fault tolerance 的共識演算法」。第 15 章也用同一個建議 |
| cryptographic primitive | 密碼學基本元件 | 1 | 第 13 行。與其他章的建議相同 |
| utility currency | 功能型貨幣 | 1 | 第 15 行，原文斜體，指用來支付以太坊平台使用費的貨幣 |
| difficulty bomb | 難度炸彈 | 2 | 第 98 行，先以引號出現（標記處），緊接著以斜體定義。與其他章的建議相同 |

共 4 個 TODO-term 標記。

### 沒有標 TODO-term、直接處理的詞（請審閱時確認）

- **permissioned → 需許可**：術語表 permissionless 譯「無需許可」，取其反義。
- **public / private blockchain → 公有／私有區塊鏈**：本章把 public blockchain 一律寫成「公有區塊鏈」（包括第 23 行「open, public blockchain」→「開放的公有區塊鏈」、第 42 行的修飾詞清單），以便和第 44–60 行的「公有／私有」分類成對。其他章若寫成「公開區塊鏈」，請統一。
- **distributed denial of service (DDoS) → 分散式阻斷服務（DDoS）**：由術語表 DoS「阻斷服務」推得。
- **Bitcoin Improvement Proposal (BIP) → 比特幣改進提案（BIP）**：比照 EIP。
- **state machine → 狀態機**、**singleton → 單例**（比照第 14 章「全球單例的狀態機」）、**halting problem → 停機問題**（比照第 14 章）、**universal Turing machine → 通用圖靈機**、**universal computability → 通用可計算性**、**infinite loop → 無窮迴圈**、**key-value tuple → 鍵值組**、**random-access memory → 隨機存取記憶體**、**stored-program computer → 儲存程式型電腦**、**reference implementation / specification → 參考實作／參考規格**、**Yellow Paper → 黃皮書**（比照第 14 章）、**whitepaper → 白皮書**、**mining rigs → 礦機**、**counterparty risk → 交易對手風險**、**data payload → 資料酬載**、**metering mechanism → 計量機制**、**overlay protocol → 疊加在比特幣之上的協議**：一般或領域通用譯法。斜體首次出現的詞寫成「中文（English）」。
- **bike-shedding → 腳踏車棚式爭論（bike-shedding）**：原文緊接著自己解釋了這個說法，因此直接意譯；「If you start bike-shedding」譯為「如果你開始爭論腳踏車棚」。
- **“move fast and break things” → 「快速行動，打破成規」（move fast and break things）**：保留英文原句。
- **Ethereum 2.0 / 1.0 → 以太坊 2.0／1.0**；第 110 行斜體處寫成「*以太坊 2.0*（Ethereum 2.0）」。
- **Genesis → 創世（Genesis，……）**：第 98 行。
- **「Book Title」／「Mastering Ethereum」**（第 142 行鍵值範例）譯為「書名」／「精通以太坊」。
- **Casper the Friendly Finality Gadget (FFG)、GHOST (Greedy Heaviest Observed Subtree)、Gasper、Ethash、ÐΞVp2p、LevelDB、go-ethereum (Geth)、Nethermind、Prysm、Lighthouse、Mastercoin、Whisper、Swarm、web3.js、AllCoreDevs**：名稱保留英文；latest message driven (LMD) 譯「最新訊息驅動（latest message driven，LMD）」。
- **Buterin 的文章標題**〈A Prehistory of the Ethereum Protocol〉保留英文，用〈〉標示（比照第 15 章的文章標題寫法）；第 74 行引文譯成中文。
- **開發階段與子階段名稱**：Frontier、Homestead、Metropolis、Serenity 與 The Surge、The Scourge、The Verge、The Purge、The Splurge 保留英文，沒有加括號說明。The Merge 依術語表在第一次出現（第 19 行）寫成「合併（The Merge）」，之後正文只寫「合併」；但第 92 行的代號清單與第 114 行的粗體標籤也寫成「合併（The Merge）」，因為這兩處的重點就是代號本身，而且與其他保留英文的子階段並列，只寫「合併」會不易對照。
- **第 42 行的強調標記**：原文 `*open,**public, global, decentralized, neutral,* and *censorship resistant*` 的星號位置有誤（看起來想逐字斜體），譯文改成逐詞斜體「*開放*、*公有*、*全球*、*去中心化*、*中立*與*抗審查*」。
- **圖說**：比照第 6、7、9 章保留粗體，寫成「**圖 1-1.** 區塊鏈的組成元件」；圖片替代文字保留英文。

### `[並列]` 術語在本章第一次出現的位置

以太幣（ether，第 7 行）、去中心化應用（decentralized application，第 9 行；縮寫 DApp 在第 98 行原文第一次出現，寫成「去中心化應用（DApp）」）、點對點（peer-to-peer，P2P，第 13 行）、合併（The Merge）／工作量證明（proof of work，PoW）／權益證明（proof of stake，PoS）（第 19 行）、去中心化金融（decentralized finance）／非同質化代幣（NFT）／去中心化自治組織（decentralized autonomous organization，DAO）（第 78 行；原文 decentralized finance 沒有縮寫）、第二層（layer 2，L2）與零知識（zero-knowledge）（第 106 行；原文是「zero-knowledge cryptographic proofs」，寫成「零知識（zero-knowledge）密碼學證明」）、信標鏈（Beacon Chain，第 116 行）、以太坊虛擬機（Ethereum Virtual Machine，EVM，第 164 行）、默克爾帕特里夏前綴樹（Merkle-Patricia trie，第 168 行；原文沒有 MPT 縮寫）、阻斷服務（denial-of-service，DoS，第 208 行）。EIP-2、EIP-7、EIP-8 這類編號照原樣，沒有套用 EIP 的並列寫法（比照第 9 章）。

## 譯註

1. `[^tn1]`（第 112 行，Serenity 子階段的數量）：原文說「the five Serenity substages are being developed at the same time」，但同一章第 92 行說 Serenity「has been further broken down into six substages」，第 114–136 行也確實列出六個子階段（The Merge、The Surge、The Scourge、The Verge、The Purge、The Splurge）。這是本章內部的矛盾，可直接由本章驗證，因此照原文譯出「五個」，再以譯註說明。**建議回報上游。**

## 可能過時或需查證

以下是根據書本以外的知識所生的疑慮，無法只靠本書驗證，所以沒有寫進譯註：

- 第 106 行（Metropolis）：說 Byzantium、Constantinople、Istanbul 這些分叉「introduced layer-2 (L2) scaling solutions」，又說 Istanbul「introduced zero-knowledge cryptographic proofs (zk-SNARKs and STARKs)」。L2 方案並不是由硬分叉「引入」的；這些分叉做的是降低相關預編譯合約或 calldata 的 gas 成本，讓 L2 與零知識證明更可行。另外，Constantinople、Istanbul 一般不被歸在「Metropolis」階段之下（Metropolis 通常指 Byzantium 與 Constantinople 兩次升級），表述可能不精確。
- 第 98 行（Frontier）：「difficulty bomb」是在 2015 年 9 月解除 gas 上限時引入的說法，與一般記載（難度炸彈的時程與 Frontier 之後的升級有關）可能不完全一致；「gas limit of five thousand」也建議查證。
- 第 116 行：把信標鏈形容為「the sidechain handling the PoS consensus」。信標鏈通常不被稱為側鏈（sidechain），這個說法可能不精確。
- 第 112 行：「made possible because the foundational work … was necessary for …」這句的邏輯（「之所以可行，是因為……是必要的」）原文就有點彆扭，照原文譯出。
- 第 120 行（The Surge）：說 The Surge「introduces sharding」。以太坊目前的路線圖已改為以 rollup 為中心、搭配 Danksharding（blob），不再是早期的執行分片，描述可能過時。
- 第 168 行：「usually Google's LevelDB」。部分主流客戶端（例如 Geth）已改用其他資料庫，可能過時。
- 第 152 行：P2P 協議寫成 ÐΞVp2p（devp2p），而共識層客戶端使用 libp2p；原文只描述執行層，可能需要補充。
- 第 228 行：說 web3.js 函式庫「originally included」Swarm 與 Whisper。web3.js 過去提供的是 `shh`（Whisper）、`bzz`（Swarm）的 API 介面，而不是包含這兩個網路本身，表述可能不精確。
- 第 202 行：「已知最簡單的圖靈完備狀態機有四個狀態、六個符號、22 條指令」的數字需查證連結內容。

## 翻譯時的疑問或不確定之處

- **utility currency** 的建議譯名「功能型貨幣」是參考 utility token「功能型代幣」的常見譯法；也可考慮「實用型貨幣」。
- **public blockchain** 譯「公有區塊鏈」或「公開區塊鏈」需要全書統一（見上）。
- **Byzantine fault tolerance** 在第 13 行原文是形容詞片語（Byzantine, fault-tolerant），標記時用名詞形式，以便與第 15 章的標記合併。
- 第 74 行的 Buterin 引文是中譯，沒有保留英文原文；如果全書決定引文要附原文，需要回頭補上。
- 「Web3」在第 76 行原文是「the "Web3" ensemble」，譯為「『Web3』這個組合」。

## 最後一次 `check-translation.rb` 輸出

```
OK   chapter_1.md
  ! 還有 4 個 TODO-term 標記
譯稿檢查通過：1 個檔案
```
