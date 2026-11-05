# 第 14 章（The Ethereum Virtual Machine）翻譯筆記

譯稿：`zh-tw/chapter_14.md`；原稿：`upstream/chapter_14.md`（上游 5907a8c）。

筆記中的「第 N 行」都指原稿 `upstream/chapter_14.md` 的行號。

## TODO-term

每個詞只在本章第一次出現處標記；其餘出現處保留英文，不再重複標記。出現次數只算正文（不含程式碼區塊與圖片替代文字），以不分大小寫的字串比對計算。

| 英文 | 建議譯名 | 出現次數 | 備註 |
|------|----------|----------|------|
| hypervisor | 虛擬機器監視器 | 1 | 第 26 行，VirtualBox、QEMU |
| searcher | 搜尋者 | 2 | 第 228、234 行（MEV 的 searcher）；與「建構者」（原文 builders，依術語表 block builder 的譯法）並列出現 |
| push data | 推入資料 | 7 | 第 921 行首次；之後在 JUMPDEST 分析、程式碼與資料分離、EOF 改進等節出現 |
| jumpdest map | JUMPDEST 對照表 | 2 | 第 1141 行提示框、第 1215 行圖 14-26 圖說；第 1187、1211 行的「map of valid jump destinations」「creates a map」譯為一般的「對照表」 |
| gas observability | gas 可觀測性 | 3 | 第 1257 行首次（與術語表的「程式碼自省」並列）；第 1371 行 |
| stack-scheduling algorithm | 堆疊排程演算法 | 1 | 第 1367 行 |
| magic bytes | 魔術位元組 | 1 | 第 1387 行；程式碼區塊中的「Magic bytes」不動 |
| subcontainer | 子容器 | 9 | 第 1407 行首次；EOF 一節 |
| factory contract | 工廠合約 | 1 | 第 1450 行 |

共 9 個 TODO-term 標記。

### 沒有標 TODO-term、直接處理的詞（請審閱時確認）

一般資訊科學用語，採台灣慣用譯法直接使用：

- **halting problem → 停機問題**（第 9 行第一次出現寫成「停機問題（halting problem）」，共 5 處）
- **sandbox → 沙盒**（「沙盒副本」「沙盒化的 EVM 環境」，共 7 處）
- **word / word size → 字組／字組大小**；**immediate value → 立即值**；**operand → 運算元**；**offset → 偏移量**
- **interpreter → 直譯器**；**scheduler / scheduling → 排程器／排程**；**single threaded → 單執行緒**
- **volatile memory → 揮發性記憶體**；**byte-addressable → 以位元組為單位定址**；**addressable → 可以定址**（刻意避開「位址」，術語表把它列為 address 的「不用」寫法）
- **header / header terminator → 標頭／標頭結束符號**（EOF）；**container format → 容器格式**；**output buffer → 輸出緩衝區**；**subcall → 子呼叫**；**message call → 訊息呼叫**
- **logical right shift → 邏輯右移**（標題「Logical Bit Shift Example」依術語表的「位移」譯為「邏輯位移的例子」）
- **dynamic jumps / static relative jumps → 動態跳躍／靜態相對跳躍**
- **static analysis / formal verification → 靜態分析／形式化驗證**
- **hashpower → 算力**；**Yellow Paper → 黃皮書**；**block's beneficiary → 區塊受益人**
- **namespaced storage layout → 命名空間儲存配置**（ERC-7201）
- **panic**（第 1135、1185 行）：客戶端實作的術語，保留英文「panic」，未標 TODO-term。
- **program code ROM → 程式碼 ROM**：ROM 保留英文。
- **temporary variable / intermediate result → 暫存變數／中間結果**

其他處理方式：

- 章標題依指示寫成「第 14 章　以太坊虛擬機」；第一次出現寫成「以太坊虛擬機（Ethereum Virtual Machine，*EVM*）」，依風格指南「中文（英文全名，縮寫）」的順序。
- 本章第一次出現的 `[並列]` 術語：外部擁有帳戶（EOA）、第一層（L1）、第二層（L2）、以太幣（ether）、以太坊改進提案（EIP）、以太坊徵求意見（ERC）、內建的提議者與建構者分離（ePBS）、點對點（P2P）、默克爾帕特里夏前綴樹（MPT）、前綴樹（trie）、工作量證明（PoW）、後進先出（LIFO）、預先編譯（AOT）、即時編譯（JIT）、控制流程圖（CFG）、阻斷服務（DoS）、提議者與建構者分離（PBS）、最大可提取價值（MEV）、EVM 物件格式（EOF）、零知識證明。
  - 默克爾帕特里夏前綴樹第一次出現在第 238 行（Verkle 樹條目），寫成「默克爾帕特里夏前綴樹（Merkle-Patricia trie，MPT）」；第 254 行「we'll call it MPT」譯為「以下簡稱 MPT」。
  - EIP、ERC 的並列：第 218 行改寫句子，寫成「以太坊改進提案（EIP）[EIP-7702](…)」與「以太坊徵求意見（ERC）[ERC-7201](…)」，連結文字不變。
- 指令分類標題依術語表：算術運算、堆疊操作、流程控制操作、系統操作、邏輯運算、環境操作、區塊操作。
- 「initiation code」（第 650 行）依術語表譯為「初始化程式碼」；「jumpdest analysis」寫成「JUMPDEST 分析」（標題「Jumpdest Analysis」亦同）。
- 標題「Ethereum Stateless」譯為「無狀態以太坊」；第 1065 行的交互參照寫成：見「無狀態以太坊」一節。第 220、628 行的小節參照同樣寫成「……」一節，文字與譯稿標題一致。
- 標題「Stack Too Deep」譯為「stack too deep 錯誤」（術語表：stack too deep 保留英文）；標題「Calldata」寫成「calldata」（術語表：保留）。
- 「Concrete Implementations」各條目的粗體標籤（Go-ethereum EVM、Revm……）是名稱，保留英文。
- storage 的 slot 依術語表保留英文；「storage address」（第 1029 行）譯為「儲存地址」。
- 圖說「EVM after PUSH0」之類譯為「執行 PUSH0 之後的 EVM」。圖片替代文字比照第 8、13 章保留英文，因此檢查腳本顯示 3 段「疑似未翻譯」，都是較長的替代文字（圖 14-3、14-22、14-23），不是正文。
- 第 640 行原文的 `example.opcode`（小寫）是行內程式碼，依規定照抄，與其他地方的 `Example.opcode` 不一致。

## 譯註

1. `[^tn1]`（第 1043 行，區塊 gas 上限可容納的轉帳筆數）：原文說區塊 gas 上限是 3,600 萬 gas，「大約可以容納 1,428 筆」21,000 gas 的轉帳。依同一句的數字計算，36,000,000 ÷ 21,000 ≈ 1,714；1,428 對應的是 3,000 萬（30,000,000 ÷ 21,000 ≈ 1,428.6），也就是本章第 1053、1065 行所說「幾乎固定在 3,000 萬」的數值。原文應是 gas 上限更新為 3,600 萬時漏改了筆數。**建議回報上游。**
2. `[^tn2]`（第 1172 行，「they differ only by one bit」）：兩段位元組碼 `…6101015b…` 與 `…6201015b…` 只有一個位元組不同（`61` PUSH2 與 `62` PUSH3），但 0x61 = 0110 0001、0x62 = 0110 0010，相差兩個位元，原意應是「差一個位元組」。可直接從第 1168–1169 行的程式碼驗證。**建議回報上游。**

## 可能過時或需查證

以下是我懷疑過時或有誤、但無法只靠本書內容驗證，因此沒有寫進譯註的地方：

- 第 1043 行「3,600 萬 gas（2025 年 6 月）」與第 1053、1065 行「幾乎固定在 3,000 萬」「已經『固定』在 3,000 萬超過三年」互相矛盾（同一章內的不一致；後兩處大概是改版前留下的文字）。區塊 gas 上限之後可能已再調整，數值需查證。
- 第 1049 行說 EIP-1559 之後「驗證者對 gas 目標投票，gas 上限定義為目標的兩倍」。據我所知，EIP-1559 之後提議者仍是直接調整 gas 上限（每個區塊最多 1/1024），gas 目標是上限的一半；原文的說法順序顛倒，需查證。
- 第 1047 行「1/1024（0.0976%）」：1/1024 = 0.09765625%，四捨五入應為 0.0977%。小瑕疵，未加譯註。
- 第 258 行說 Ralph Merkle 在 1988 年發明默克爾樹。據我所知，Merkle 的相關專利申請於 1979 年、論文發表於 1987 年，年份需查證。
- 第 1114 行：EOF 升級「無限期延後」，第 240–242 行：Verkle 樹可能被其他以雜湊為基礎的二元樹取代。這兩點都是 2025 年 6 月的狀態，之後可能有變化。
- 第 218 行：EIP-7702 於 2025 年 5 月的 Pectra 升級啟用；第 226 行「撰寫時（2025 年 6 月）」。時效性內容。
- 第 721–738 行：Heimdall 的安裝方式（`bifrost`）與版本 0.8.4 可能已過時；第 704 行 Ethersplay 需要購買完整版 Binary Ninja 的說法也可能改變。
- 第 1395 行把 EOF 標頭中識別碼 `01` 的區段稱為「Stack validation data」。在 EIP-3540 的規格中，這個區段一般稱為 type section。未改動，僅照原文翻譯。
- 第 1434–1440 行：程式碼區段是 8 個位元組 `5F5FD1005FEC0000`，但原文解讀為 `PUSH0 PUSH0 DATALOADN 0 PUSH0 EOFCREATE 0 STOP`。據我所知 DATALOADN 的立即值是 2 個位元組（EIP-7480），照這樣解讀需要 9 個位元組；這段位元組碼與解讀可能有一處不一致。這需要對照 EOF 規格，無法只靠本書驗證。
- 第 1031 行：`SELFDESTRUCT` 退款 24,000 gas 是「過去」的情況（London 升級已移除），原文已用過去式，照譯。

## 疑問與不確定之處

- 第 813 行說「因為 `Faucet.sol` 實作了 fallback 函式，calldata 長度小於 4 個位元組時，EVM 會跳到這個函式」。但第 656–675 行的 `Faucet.sol` 同時有 `receive()`，程式碼註解也寫明 msg.data 為空時呼叫 `receive()`；所以 calldata 為空時進入的應是 receive 函式，1 到 3 個位元組時才是 fallback。原文是簡化的說法，照譯，未加譯註。
- 第 807 行說把「函式名稱與它接受的所有引數」放進 `keccak256` 求函式識別碼，實際是函式名稱加上參數**型別**（從第 810 行的 `"withdraw(uint256,address)"` 可以看出）。原文用語不精確，照譯為「函式名稱與它接受的所有引數」，未加譯註；審閱時可考慮改成「參數型別」。
- 第 871 行「all the bits move before the first one are discarded」語意不通，依上下文譯為「被移出最右端的所有位元都會被丟棄，左邊補進來的新位元則設為 0」。
- 第 1029 行「There is only operation」漏了「one」，照意思譯為「只有一個操作」。
- 第 1470 行「fix different flows of legacy EVM」的 flows 應是 flaws，譯為「缺陷」。
- 第 254 行原文一處寫成「Merkle-Patricia tree」，其餘都是 trie；統一譯為「默克爾帕特里夏前綴樹」。第 254 行的「Verkle tries」譯為「Verkle 樹」（術語表）。
- 第 315 行「take the sixth child … the third child」照字面譯為「第 6 個子節點」「第 3 個子節點」；嚴格來說是索引 6、3 的子節點（從 0 起算），未改動。
- 第 305 行 Patricia 的全名照原文附上英文，並加中文意譯「擷取以英數字編碼之資訊的實用演算法」。
- 第 1135、1185 行的「panic」保留英文（客戶端實作的行為），審閱時可決定是否改譯。
- 第 1215 行圖 14-26 圖說原文「Figure 14-26.」後有兩個空格，譯稿寫成一個空格（「圖 14-26. 」）。

## 最後一次 `check-translation.rb` 輸出

```
$ ruby scripts/check-translation.rb chapter_14.md
OK   chapter_14.md
  ! 疑似未翻譯的段落 3 段（例如：The Merkle proof to verify that data_1 is contained in the t…）
  ! 還有 9 個 TODO-term 標記
譯稿檢查通過：1 個檔案
```
