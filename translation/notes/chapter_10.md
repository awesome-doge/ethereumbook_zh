# 第 10 章（Tokens）翻譯筆記

譯稿：`zh-tw/chapter_10.md`；原稿：`upstream/chapter_10.md`（上游 5907a8c）。

筆記中的「第 N 行」都指原稿 `upstream/chapter_10.md` 的行號。

## 結構概要

- 39 個程式碼區塊（Solidity 代幣合約、Foundry 指令與輸出、目錄樹），全部原樣保留；已用 `diff` 比對譯稿與原稿所有程式碼區塊的內容，完全相同。
- 1 張圖（圖 10-1），圖說寫成 `**圖 10-1.** …`（沿用第 6、9 章的粗體寫法），替代文字保留英文。
- **本章沒有表格**。任務說明提到「表格」，但原稿唯一出現 `|` 的地方是第 462–467 行程式碼區塊中的目錄樹，因此沒有「表 10-N」。
- 3 個範例標題（範例 10-1 至 10-3）、8 個 Note、1 個 Tip、1 個 Warning，數量與原稿相同。

## TODO-term

每個詞只在本章第一次出現處標記；其餘出現處保留英文，不再重複標記。出現次數只算正文（不含程式碼區塊、行內程式碼與圖片替代文字），包含標記處本身。

| 英文 | 建議譯名 | 出現次數 | 備註 |
|------|----------|----------|------|
| utility token | 效用型代幣 | 3 | 第 83、85、97 行。對照的 equity token 直接譯為「股權代幣」（見下方） |
| meme coin | 迷因幣 | 3 | 第 89 行與第 93 行備註框 |
| spender | 被授權支用者 | 5 | ERC-20 `allowance` 的另一方；第 145、200、230 行 |
| initial coin offering（ICO） | 首次代幣發行（ICO） | 2（全名）＋ 4（ICO） | 沿用第 9 章的標記寫法；第 214、222、684 行。合約名稱 `AliceICO` 不計 |
| crowdsale | 群眾募資銷售 | 2 | 第 214 行 |
| vault | 金庫 | 1 | 「tokenized vaults」，第 238 行；沿用第 9 章的建議 |
| vesting schedule | 歸屬時程 | 1 | 第 238 行 |
| sponsorship | 代付 | 1 | 「gas fee sponsorship」，第 696 行；沿用其他章的建議 |
| hook | 掛鉤 | 17 | ERC-777、ERC-1155 一節。沿用第 9 章的建議譯名，**但與術語表 peg「掛鉤」[固定] 撞名**，定案時建議改用「鉤子」或保留英文 |
| registry | 註冊表 | 2 | ERC-1820 registry，第 749、962 行 |
| atomic | 原子性 | 2 | 「atomic transactions」，第 751、796 行；沿用其他章的建議 |
| operator | 操作者 | 2 | ERC-777 的 operator 機制，第 753 行 |
| metadata | 詮釋資料 | 8 | ERC-721 與 ERC-1155 各節。**第 6 章已直接寫成「詮釋資料」而沒有標記**，請審閱時統一 |
| check-effect-interaction pattern | 檢查—生效—互動模式 | 1 | 原文寫成「checks-effects-interactions patterns」（第 846 行）；標記用第 9 章的寫法，方便統一 |
| blocklist | 封鎖清單 | 1 | 第 988 行 |
| allowlist | 允許清單 | 1 | 第 988 行；沿用其他章的建議 |

共 16 個 TODO-term 標記（檢查腳本計數）。

### 沒有標 TODO-term、直接處理的詞（請審閱時確認）

- **counterparty risk → 交易對手風險**：術語表沒有這個詞；依協調者指示直接使用，章內第一次出現寫成「*交易對手風險*（counterparty risk）」，協調者會補進術語表。
- **fungibility → 同質性／同質化**：維基百科引文中的名詞譯「同質性」，其餘依術語表 fungible「同質化」。小節標題「Tokens and Fungibility」譯為「代幣與同質化」。
- **intrinsic / extrinsic / intrinsicality → 內在／外在／內在性**：一般用語，第一次出現附英文。
- **equity token → 股權代幣**、**semifungible → 半同質化**、**multitoken standard → 多代幣標準**、**batch operations → 批次操作**、**interface ID → 介面 ID**、**token ID → 代幣 ID**：可由既有術語直接推得，未標記。
- **attestation（第 45–53 行「代幣的用途」清單）→ 認證**：這裡是「證書、事實證明」的意思，不是術語表中驗證者的 attestation（見證投票），因此不套用術語表譯名。
- **securities → 證券**、**dividends → 股利**、**Howey Test → Howey 測試**、**SEC → 美國證券交易委員會（SEC）**、**IPO → 首次公開發行（initial public offering，IPO）**、**royalty → 版稅**、**deflationary → 通縮**：一般金融與法律用語。
- **smart wallet → 智能錢包**：沿用第 5 章。
- **override（第 927 行，覆寫 `supportsInterface`）→ 覆寫**：直接使用。其他章曾標 `TODO-term: override（建議：覆寫）`，建議譯名相同，統一回填時請一併確認。
- **MMOG → MMOG（大型多人線上遊戲）**：第 23 行，原文只有縮寫，譯稿加了括號說明，方便讀者理解；屬刻意補充。
- **[並列] 術語在本章的第一次出現**：DAO（第 31 行）、NFT（第 59 行）、DApp（第 83 行）、市值（第 93 行）、以太幣（第 101 行）、權益證明（第 101 行）、ERC（第 115 行）、EOA（第 444 行）、EVM（第 722 行）、DEX（第 788 行，唯一一次）、DoS（第 790 行）、真實世界資產（RWA）（第 806 行，泛指不動產、汽車等，仍依規則寫成「真實世界資產（real-world asset，RWA）」）。
- **data mapping → mapping**：依術語表 mapping [保留]。
- **"not invented here" syndrome → 「非我發明」症候群**，備註框中附英文。
- **IPFS**：術語表將 IPFS 列為保留英文，因此寫成「IPFS（Inter-Planetary File System）」，沒有另取中文名。
- **URI → 統一資源識別碼（uniform resource identifier，URI）**：臺灣常用譯名。
- 小節標題：「Utility, Equity, or Cash Grab?」譯「效用、股權，還是撈錢？」；「It's a Duck!」譯「它就是一隻鴨子！」；「ERC-777: The future that could have been」譯「原本可能實現的未來」；「Security by Maturity」譯「成熟帶來安全」。
- 「代幣的用途」清單的小標題 **Name**、**Symbol**（ERC-20 選用函式）保留英文，因為它們是函式名稱。

## 譯註

1. `[^tn1]`（第 147–153 行，ERC-20 必要事件）：原文以小寫的 `transfer`、`approval` 作為事件名稱，但緊接著的「The ERC-20 interface defined in Solidity」程式碼（第 185–186 行）宣告的事件是 `Transfer` 與 `Approval`；而且小寫的 `transfer` 與上方同名函式重複，容易混淆。行內程式碼依規定不改，以譯註說明。**建議回報上游。**
2. `[^tn2]`（第 230 行）：原文說「In Chapter 9, we fully explored the ins and outs of the traditional `transfer` and `transferFrom` flows」，但第 9 章（`upstream/chapter_9.md`）只在第 556 行討論 SafeERC20 時順帶提到這些函式；詳細說明這兩個流程的是本章第 206–226 行的「ERC-20 workflows」一節。照原文譯為「第 9 章」，以譯註指出。**建議回報上游。**

## 可能過時或需查證（未寫進譯文）

- 第 93 行：川普於 2025 年 1 月推出的迷因幣「一天內市值達 150 億美元」，數字與時間需查證。
- 第 99 行：SEC 於 2020 年起訴 Ripple Labs、法院做出部分判決；此案之後的發展（和解或終結）原文未提，可能已過時。
- 第 101 行：「2018 年前 SEC 官員宣稱以太幣充分去中心化」與「2024 年 SEC 暗示轉向權益證明可能讓以太坊重新受檢視」，需查證說法是否精確（例如發言者當時是否為「前」官員）。
- 第 101–103 行整節的美國監管情勢可能已有變化。
- 第 788 行：Uniswap v1 的 ERC-777 重入事件時間（2020 年 4 月）需查證。
- 第 238 行：「Consensys 的 EIP-20 代幣自 2018 年以來沒有再維護」。
- 第 276 行：OpenZeppelin 版本 v5.2.0 與 Solc 0.8.28 為撰稿時的版本。

## 翻譯時的疑問或不確定之處

- 第 562 行說「We've made quite a few changes to the basic `Faucet` example」，但前面修改的是 `NaiveFaucet`；`Faucet` 是第 2 章的範例合約（`upstream/chapter_2.md` 第 280 行），兩者都說得通，照原文翻譯。
- 第 584–587 行的程式碼片段使用 `metOwner`、`withdraw_amount`，與範例 10-2 的 `_METOwner`、`amount` 不一致，第 574–579 行的建構子片段與範例 10-2 也有差異（多了註解）。程式碼依規定不改，也沒有加譯註，**建議回報上游**。
- 第 696 行把 EIP-4337 與 EIP-7702 稱為「smart wallets」，而且寫成 EIP-4337；第 5 章一律寫成 ERC-4337。兩種寫法指同一份提案，不算錯誤，照原文保留「EIP-4337」，但全書寫法不一致，可考慮回報上游。
- 第 835 行 ERC-721 介面中的 `boolean` 型別與 `setApprovalForAll` 缺少 `external`，以及 ERC-223／ERC-777 介面中的 `interface` 宣告了狀態變數、`public` 函式，都不是合法的 Solidity；程式碼依規定不改。
- 第 900–901 行原稿在一個段落中間換行（「internal data」與「structures」之間），譯稿把這兩行併成一行（同一段落，不影響段落數），以免中文中間出現多餘的空白。
- 第 329 行的網址 *http://127.0.0.1:8545* 原文以斜體寫在句中。譯稿若把它直接接在中文標點前，Markdown 的自動連結會把後面的中文也吃進網址，檢查腳本會報「連結網址不符」；因此改寫句子，讓網址後面接空格：「*http://127.0.0.1:8545* 是 Anvil 預設的 RPC。」
- hook 的建議譯名「掛鉤」與 peg 的「掛鉤」撞名，見上方 TODO-term 表。

## 最後一次 check-translation.rb 輸出

```
OK   chapter_10.md
  ! 疑似未翻譯的段落 1 段（例如：The two-step approve and transferFrom workflow of ERC-20 tok…）
  ! 還有 16 個 TODO-term 標記
譯稿檢查通過：1 個檔案
```

「疑似未翻譯的段落」是圖 10-1 的圖片替代文字，依指引保留英文。
