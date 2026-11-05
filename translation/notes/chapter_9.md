# 第 9 章（Smart Contract Security）翻譯筆記

譯稿：`zh-tw/chapter_9.md`；原稿：`upstream/chapter_9.md`（上游 5907a8c）。

筆記中的「第 N 行」都指原稿 `upstream/chapter_9.md` 的行號（譯稿在第 587、710 行之後各多了兩行（譯註定義與其後的空行），因此第 588 行以後的譯稿行號比原稿多 2，第 711 行以後多 4）。

## TODO-term

每個詞只在本章第一次出現處標記；其餘出現處保留英文，不再重複標記。出現次數只算正文（含標記處那一次，不含程式碼區塊與行內程式碼）。

| 英文 | 建議譯名 | 出現次數 | 備註 |
|------|----------|----------|------|
| bug bounty | 漏洞賞金 | 2 | 第 7 行（標記）、第 821 行（Mango 的 4,700 萬美元「某種 bug bounty」） |
| callback | 回呼 | 5 | 第 41 行標記；唯讀重入一節、MEV 機器人的「閃電貸 callback」 |
| hook | 掛鉤 | 2 | 第 41、131 行 |
| vault | 金庫 | 13 | 第 47 行（EtherStore 描述）標記；其餘都在 ERC-4626 一節，包括「代幣化 vault」「vault share」 |
| share | 份額 | 約 13 | ERC-4626 的 shares；第 243 行（Libertify）標記，其餘在 ERC-4626 一節。另有「dead share」1 次另行標記 |
| check-effect-interaction pattern | 檢查—生效—互動模式 | 1 | 第 151 行。常見寫法是 checks-effects-interactions，原文單數照抄 |
| storage slot | 儲存 slot | 5 | 第 323 行斜體 *slots* 處標記；之後寫成「slot」或「儲存 slot」。術語表的 slot [保留] 指權益證明的 12 秒時段（第 446 行就是這個意思），與儲存空間的 slot 是兩回事，請決定是否共用「slot」 |
| airdrop | 空投 | 1 | 第 452 行；第 479 行的 `airdrop` 是函式名稱（行內程式碼），未計 |
| bundle | 交易包 | 1 | 第 564 行，Flashbots 的交易 bundle |
| preimage | 原像 | 1 | 第 587 行 |
| commit-reveal scheme | 承諾—揭露機制 | 1 | 第 593 行；兩個階段直接譯為「承諾階段／揭露階段」（commitment 依術語表譯「承諾」） |
| initial coin offering (ICO) | 首次代幣發行（ICO） | 1 | 第 651 行 |
| withdrawal pattern | 提領模式 | 1 | 第 659 行 |
| pull-over-push pattern | 拉取優於推送模式 | 1 | 第 659 行 |
| virtual offset | 虛擬偏移量 | 2 | 第 787 行（備註框） |
| decimal offset | 小數位偏移量 | 2 | 第 787 行（備註框） |
| dead share | 無效份額 | 1 | 第 787 行「dead-share creation」 |
| total value locked (TVL) | 總鎖倉價值（TVL） | 1 | 第 809 行 |
| security through obscurity | 以隱匿求安全 | 2 | 第 809、835 行 |
| perpetual futures | 永續合約 | 1 | 第 817 行；同段的「perp position」譯為「perp 部位」 |
| allowlist | 允許清單 | 1 | 第 884 行（第 12 章把 whitelist 直接譯為白名單，allowlist 是不同的詞，故仍標記） |
| relayer | 中繼者 | 1 | 第 888 行。術語表的 relay「中繼」是 MEV-Boost 語境，這裡是代付 gas 的 relayer |
| signature malleability | 簽章延展性 | 3 | 第 929、959、967 行。第 929 行「Malleable signatures are the reason…」改寫成「正因為簽章可以被這樣竄改」以避開此詞 |
| white hat / black hat | 白帽／黑帽 | 5 | 第 983 行標記（white hat 1 次）；第 987 行備註框 white hat 2 次、black hat 2 次 |
| timelock | 時間鎖 | 5 | 第 993–995 行；另有產品名稱「OpenZeppelin Timelock」1 次（第 997 行）保留英文、未計 |
| wargame | 攻防闖關遊戲 | 1 | 第 1023 行（Ethernaut 的描述） |

共 26 個 TODO-term 標記。

### 沒有標 TODO-term、直接處理的詞（請審閱時確認）

- **Swiss cheese model → 瑞士起司模型**、**DRY principle → DRY 原則（不要重複你自己）**、**“not invented here” syndrome → 「非我所創」（not invented here）症候群**：一般用語或通用說法。
- **cross-function / cross-contract reentrancy → 跨函式重入／跨合約重入**：由術語表的「重入」組合而成。
- **replay attack / cross-chain replay attack → 重放攻擊／跨鏈重放攻擊**：由術語表的「簽章重放攻擊」推得。
- **reentrancy guard → 重入鎖**（第 179 行「reentrancy guards」）；OpenZeppelin 的 ReentrancyGuard、ReentrancyGuardTransient 是產品名稱，保留英文。
- **gasless transactions → 免 gas 交易**、**yield aggregator → 收益聚合器**、**role-based access control → 以角色為基礎的存取控制**、**static analysis tool → 靜態分析工具**、**pagination → 分頁**、**minimum amount out → 最低輸出數量**、**context-aware signatures → 具備情境感知的簽章**、**atomically / atomic → 以原子化的方式／原子操作**、**underlying asset → 標的資產**、**liquidity pair → 流動性交易對**、**attack surface → 攻擊面**、**precondition / postcondition → 前置條件／後置條件**、**postmortem → 事後檢討**、**setter function → setter 函式**、**Fibonacci → 費波那契**：一般或領域通用譯法。
- **rounding down → 無條件捨去**；**rounding errors → 捨入誤差**。
- **delegate call**（第 414 行，原文是兩個字的一般寫法）寫成「delegatecall」，依術語表保留英文。
- **The DAO**、**Ethereum Classic（ETC）**、**Randao**（照原文大小寫；術語表寫作 RANDAO）、**Fomo3D 的「key」**（遊戲道具，避免與「金鑰」混淆，保留英文並加引號）照原文保留。
- **ether 金額**：依術語表寫成「1 ETH」「10 ETH」；行內程式碼的 `1 ether` 不動。
- **minAmountOut**（第 595 行標題）：原文標題沒有反引號，照樣保留為純文字。
- 「Damn Vulnerable DeFi」等「其他資源」一節的課程與平台名稱（粗體行）保留英文。
- `[並列]` 術語在本章第一次出現的位置：以太幣（ether，第 41 行）、去中心化金融（DeFi，第 15 行）、去中心化應用（DApp，第 23 行）、外部擁有帳戶（EOA，第 181 行）、熵（entropy，第 426 行）、可驗證隨機函數（verifiable random function，VRF，第 438 行）、權益證明（PoS，第 442 行）、自動造市商（automated market maker，AMM）／兌換（swap）／滑價（slippage）（第 591 行）、時間加權平均價格（TWAP，第 599 行）、提議者與建構者分離（PBS，第 564 行）、阻斷服務（denial of service，DoS，第 607 行；第 601 行標題只寫「阻斷服務」）、第二層（L2）與以太坊虛擬機（EVM）（第 665 行）、去中心化自治組織（DAO，第 821 行；第 41、185、187 行的 The DAO 是專案名稱）、最大可提取價值（MEV，第 835 行）、非同質化代幣（NFT，第 1027 行）。EIP-1153、ERC-20 這類編號照原樣，沒有套用 EIP／ERC 的並列寫法。CTF 依術語表 [保留]，第一次寫成「CTF（capture the flag）」。

## 譯註

1. `[^tn1]`（第 587 行，FindThisHash）：原文說要找出「SHA-3 hash」的原像，但範例 9-6 的程式碼用的是 `keccak256`。第 4 章（原稿第 312–335 行）說明以太坊使用的是原始的 Keccak-256，與最終定案的 FIPS-202 SHA-3 輸出不同，以太坊文件中的「SHA-3」幾乎都指 Keccak-256。照原文譯出，再以譯註說明。可由第 4 章與本章程式碼驗證。
2. `[^tn2]`（第 710 行，`uint256` 的範圍）：原文說 `uint256` 的範圍「approximately 60 orders of magnitude」。2^256 − 1 ≈ 1.16 × 10^77，約 77 個數量級；扣除 18 位小數精度後約剩 59 個數量級，原文的 60 或許指這一部分。屬於可直接計算驗證的數字，因此加譯註。**建議回報上游。**

## 可能過時或需查證（未寫進譯註）

- 第 41 行：「(through a callback: either a fallback function or some hook, usually `transfer`)」語意不太清楚（hook 通常不是 `transfer`），照字面翻譯。
- 第 122 行：說「The fallback function calls…」，但範例 9-2 第 23 行是 `receive` 函式（第 22 行的註解也說 fallback 也可以），照原文譯為 fallback 函式。
- 第 131 行：ERC-721 標準的函式是 `safeTransferFrom`，原文寫 `safeTransfer`；本書程式碼無法驗證，行內程式碼依規定不改。
- 第 243 行：文字說重新進入 `deposit()`，但程式碼中的函式是 `_deposit`（`deposit()` 應是呼叫它的公開函式，程式碼片段未列出）。
- 第 341 行（程式碼區塊）：`this.balance` 在現行 Solidity 中無法編譯（應為 `address(this).balance`）；程式碼依規定不改。
- 第 358 行：「the exploit is seven years old」——Parity 第二次事件發生於 2017 年 11 月，「七年」取決於寫作時間。
- 第 564 行：「builder-proposer separation (which isn’t yet part of Ethereum natively)」——內建 PBS（ePBS）的進度可能已改變；術語表的寫法是「提議者與建構者分離」，原文詞序顛倒，直接採用術語表。
- 第 669 行：「As of this writing, v0.8.29 of Solidity」——版本號會過時。
- 第 712 行：「18 decimals common for ERC-20 tokens like ether」——以太幣本身不是 ERC-20 代幣，原文說法不夠精確，照譯。
- 第 795 行：閃電貸「must be repaid within the same transaction block」——精確地說是必須在同一筆交易內償還，照字面譯為「同一個交易區塊內」。
- 第 941–949 行：`abi.encodePacked` 對陣列元素實際上會補齊到 32 位元組，原文是刻意簡化的示意。另外，第一組參數 `_from = [0x001, 0x002]` 要求同一個簽章的 signer 同時等於 `0x001` 與 `0x002`（範例 9-10 第 17 行），這組原始參數本身其實無法通過驗證；示意性質，照譯。
- 外部事實與數字（未查證，照原文）：The DAO 1.5 億美元／流通量 15%（第 187 行）、Libertify 2023 年 7 月 40 萬美元（第 191 行）、Gemholic 921 ETH／約 170 萬美元（第 665 行）、Mobius Token 2025 年 5 月 210 萬美元（第 809 行）、Mango Markets 的金額、日期（10 月 15 日）、2025 年 5 月的判決與四年多的刑期（第 817–823 行）、TCH 2024 年 5 月（第 967 行）、yUSDT 2023 年 4 月 1,160 萬美元與「超過一千天」（第 979 行）、Ronin Bridge 2024 年 8 月 4,000 ETH（第 983 行）、Sonne Finance 2024 年 5 月 2,000 萬美元（第 991–995 行）、Cyfrin Updraft「24 小時、270 堂以上」與 Damn Vulnerable DeFi「18 道挑戰」（第 1015、1027 行）。

## 疑問與不確定之處

- 第 523 行引號內的「Predefined Global Variables and Functions」是第 7 章的小節標題（原稿 `upstream/chapter_7.md` 第 340 行）。第 7 章譯稿完成後，請把這裡的「預先定義的全域變數與函式」改成與第 7 章的標題一致。
- 第 706、708 行：行內程式碼 `weiPerTokens`、`tokenPerEth` 與範例 9-8 程式碼中的 `tokensPerEth` 不一致（`tokenPerEth` 少了 s）。行內程式碼依規定照抄，屬於原文的筆誤，沒有加譯註。**可回報上游。**
- 第 117、123 行的地址寫法 `0x0...123`（三點）與 `0x0..123`（兩點）不一致，照原文保留。
- 第 775、779 行是兩行公式（`(assets × supply) / totalAssets()` 與 `1,000e6 × 1 / (1,000e6 + 1) = 0.999`），沒有可翻譯的文字，照原文保留。
- 第 787 行「protecting the vault from dead-share creation」：dead share 通常是一種防禦手法（先鑄造一些永遠不贖回的 share），原文的說法有點費解，照字面譯為「保護 vault 不受 dead share 的產生所影響」。
- 第 820 行同一段出現兩次「these deals / negotiations are common」，第一次譯為「這種約定雖然常見」，第二次譯為「這類談判很常見」，避免與「協議」（protocol）混淆。
- 第 422 行的引言「I accidentally killed it.」譯為「我不小心把它殺掉了（I accidentally killed it）」，保留英文原句。
- 第 1045 行的格言「Don’t roll your own crypto」譯為「不要自己發明密碼學」並附原文。
- 第 27 行「highest common denominator of open source development」譯為「開放原始碼開發所能達到的最高共同水準」（意譯）。
- 「其他資源」一節的粗體課程／平台名稱沒有翻譯（第 1013–1037 行）；說明文字已翻譯。
- 圖片替代文字（`![Read-only reentrancy]`）比照第 8、13 章保留英文，只翻譯圖說「圖 9-1. 唯讀重入」。

## 最後一次 `check-translation.rb` 輸出

```
$ ruby scripts/check-translation.rb chapter_9.md
OK   chapter_9.md
  ! 還有 26 個 TODO-term 標記
譯稿檢查通過：1 個檔案
```
