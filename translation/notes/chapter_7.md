# 第 7 章（Smart Contracts and Solidity）翻譯筆記

譯稿：`zh-tw/chapter_7.md`；原稿：`upstream/chapter_7.md`（上游 5907a8c）。

筆記中的「第 N 行」都指原稿 `upstream/chapter_7.md` 的行號。

## TODO-term

每個詞只在本章第一次出現處標記；其餘出現處保留英文，不再重複標記。出現次數只算正文（不含程式碼區塊與行內程式碼）。

| 英文 | 建議譯名 | 出現次數 | 備註 |
|------|----------|----------|------|
| atomic | 原子性 | 2 | 第 41 行（斜體，標記處）、第 841 行。譯成「交易是 *atomic* 的」 |
| message call | 訊息呼叫 | 3 | 第一次出現在第 344 行的小節標題「Transaction/message call context」，譯為「交易／message call 環境」；標記放在緊接著的第 346 行正文。第 444 行「arbitrary message call」 |
| override（動詞）／function overriding | 覆寫 | 8 | 第 577 行第一次出現（receive 函式「can override」）。第 721 行「function overriding」譯為「函式 override」。關鍵字 `override` 與編譯器錯誤訊息裡的 override 不計。第 796 行「might override things that earlier constructors set up」是一般用法，譯為「覆蓋」。已審閱的第 8 章（`zh-tw/chapter_8.md` 第 155 行）已直接把 overridden 譯為「覆寫」，與建議譯名一致 |
| function signature | 函式簽章 | 1 | 第 581 行。若定案「函式簽章」，請確認檢查腳本不會因「簽章」限於密碼學而有疑慮（術語表只規定 signature 譯「簽章」） |
| base contract | 基礎合約 | 4 | 第 642、664、681、765 行。與術語表的 derived contract「衍生合約」成對 |
| mutability（state mutability） | 狀態可變性 | 1 | 第 761 行備註 |
| invariant | 不變條件 | 1 | 第 843 行。原想建議「不變量」，但「不變量」含有被擋的「變量」，檢查腳本會報錯，所以改建議「不變條件」（也可考慮「不變式」） |
| custom error | 自訂錯誤 | 3 | 第 857 行（一段內出現 3 次） |
| provider（WebSocket provider） | 節點服務供應商 | 7 | 第 1011 行 4 次（含標記處，譯文為了通順多用了一次）、第 1040 行 3 次。另有 ethers 的類別名稱 WebSocketProvider（1 次）保留原樣。注意雙重語意：第 1011 行指提供節點服務的業者，第 1040 行「這個 provider 會把我們連上網路」指 ethers 的 Provider 物件，定案時可能需要分開處理 |

共 9 個 TODO-term 標記。

### 沒有標 TODO-term、直接處理的詞（請審閱時確認）

- **getter function → getter 函式**：保留英文 getter。
- **event listener → 事件監聽器**、**callback function → 回呼函式**、**console → 主控台**、**RPC endpoint → RPC 端點**、**rate limited → 有流量限制**：一般資訊用語。
- **placeholder → 佔位符號**（修飾符的 `_;`）。
- **single-threaded → 單執行緒**、**paradigm → 程式設計典範**、**cyclic inheritance → 循環繼承**、**sibling class / direct parent → 兄弟類別／直接父類別**、**flattened inheritance hierarchy → 攤平後的繼承階層**、**most derived → 衍生程度最高**、**parent contract → 父合約**、**child → 子合約**。
- **minor revision / major revision → 次要修訂版本／主要修訂版本**；semantic versioning 的 MAJOR／MINOR／PATCH 說明譯為「主要／次要／修補」版本號。
- **precondition → 前置條件**（第 638、843 行）：與術語表 gate condition 的固定譯名「前置條件」（第 851 行）同字，語意不衝突。
- **pragma directive → pragma 指令**、**compiler directive → 編譯器指令**（術語表只有「版本 pragma」）。
- **randomness beacon → 隨機性信標**（由術語表的 randomness「隨機性」與 Beacon Chain「信標鏈」組合）。
- **raw transaction → 原始交易**、**blind call → 盲目呼叫**（術語表有 raw call「原始呼叫」）。
- **context**：依語境譯為「環境」（EVM context → EVM 環境；Transaction context → 交易環境；execution context → 執行環境，依術語表）。
- **data payload**：沒有另立譯名，譯為「附帶的資料（內容）」；程式碼 `address.call(payload)` 不動。
- **withdrawal（水龍頭的提款）→ 提領**：術語表的 withdrawal「提領」原指驗證者提領，水龍頭的提款也統一用「提領」。
- **incentivize → 提供誘因**（依術語表 incentive／incentivize）。
- **the `view` modifier**（第 567 行）：原文把 `view` 稱為 modifier，但它並不是本章所說的函式修飾符，為避免混淆譯為「使用 `view` 修飾」，沒有用「修飾符」。
- 資料型別清單的粗體標題：「Boolean (bool)」→「布林值（bool）」、「Integer (int, uint)」→「整數（int、uint）」、「Struct」→「結構」、「Mapping」→「mapping」（術語表規定保留英文）；可見性的粗體標題（**public** 等）與 `msg.sender` 等全域變數標題保留英文。函式語法的 **FunctionName**、**parameters** 是語法中的佔位名稱，保留英文。
- 第 784 行的編譯器錯誤訊息保留英文原文，沒有另附中文翻譯（附譯會讓行內程式碼 `foo` 多出一次，檢查腳本不通過）。

## 譯註

共 12 個，全部都可以從本章的程式碼或其他段落直接驗證（譯註編號依出現順序排列）。

1. `[^tn1]`（第 197 行）：ABI 輸出（第 192–194 行）只列出一個輸入 `withdrawAmount`，但範例 7-1 的 `withdraw(uint _withdrawAmount, address payable _to)` 有兩個參數；輸出看起來是依照較早版本的範例產生的。**建議回報上游。**
2. `[^tn2]`（第 306 行）：原文說範例中的變數叫 `withdrawAmount`、`address` 變數「用 `msg.sender` 設定」；範例 7-1 實際上是參數 `_withdrawAmount` 與 `address payable _to`，`msg.sender` 要到範例 7-3 才當作接收者。
3. `[^tn3]`（第 438 行）：原文說 `Faucet` 範例用過 `msg.sender.transfer`；範例 7-1／7-2 是 `_to.transfer(...)`，範例 7-3 是 `payable(msg.sender).transfer(...)`，本章沒有 `msg.sender.transfer`。
4. `[^tn4]`（第 533 行）：原文說 `uint withdrawAmount` 是 `withdraw` 唯一的引數；範例 7-1 有兩個參數，只有一個參數的是範例 7-3。
5. `[^tn5]`（第 539 行）：原文說「Public is the default」，與同節第 557 行備註「function visibility must be explicitly defined」矛盾；同句說兩個函式都是 public，但 `receive` 宣告為 `external`。**建議回報上游。**
6. `[^tn6]`（第 591 行）：第 594 行建構子範例的 `pragma 0.8.26` 少了 `solidity` 與分號，對照第 208 行的 `pragma solidity 0.8.26;`。
7. `[^tn7]`（第 612 行）：原文說「our `destroy` function」已經有存取控制陳述式，但本章所有 `Faucet` 範例都沒有 `destroy` 函式。譯註提到這句沿用自第一版：本 repo 的第一版譯稿 `ch08.asciidoc` 與 `code/Solidity/Faucet3.sol` 等檔案確實有 `function destroy`（已用 grep 確認；`ch08.asciidoc` 第 470–480 行有同一句）。同一則譯註也說明第 662 行「我們在 `Faucet` 中引進了針對擁有者、在建構時指定的存取控制」同樣是第一版殘留：範例 7-1／7-2 的 `Faucet` 沒有擁有者也沒有建構子。**建議回報上游。**
8. `[^tn8]`（第 703 行）：原文說「further extend the `Owned` contract, inheriting its capabilities in `Faucet`」，但下方程式碼是 `contract Faucet is Pausable`，下一段（第 719 行）也這樣說明。
9. `[^tn9]`（第 721 行）：「can be overridden by a contract higher in the inheritance chain」照字面譯為「較上層的合約」，但這裡指衍生程度較高、繼承該函式的合約（下方範例是 `Faucet` override `Pausable` 的 `unpause`），與第 658 行「higher up in the inheritance chain」（指父合約）的用法相反，加譯註說明。
10. `[^tn10]`（第 871 行）：第 874 行程式碼用 `this.balance`；本章第 426 行說目前合約的餘額是 `address(this).balance`，第 482 行也說 `this` 要明確轉換成 address 才能取得地址。
11. `[^tn11]`（第 1128 行）：正文說要呼叫 `Faucet` 的 `changeOwner`，但範例 7-3 的 `Faucet`／`Pausable`／`Owned` 都沒有定義 `changeOwner`，第 1138 行的 `_faucet.changeOwner(newOwner)` 無法編譯；第 1137 行 `Token` 的 `changeOwner` 也沒有寫可見性（違反第 557 行備註）。
12. `[^tn12]`（第 1229 行）：內文說事件叫 `calledEvent`，範例 7-4 程式碼中是 `callEvent`；內文說記錄 `this`，程式碼記錄的是 `address(this)`、參數名為 `from`（第 1271 行內文也提到 `from`）。

## 可能過時或需查證（沒有寫進譯文）

- 第 97、101 行：「在撰寫本書時，Solidity 的版本是 0.8.26」。出版後應已有更新的版本。
- 第 258 行：定點數的小數位數 *N*「最多 18 位」。印象中 Solidity 文件寫的是 0 到 80，需查證。
- 第 418 行：`block.timestamp` 是「礦工放進目前區塊的時間戳記」。合併之後應是區塊提議者（本章第 406 行自己也說 Paris 之後改用權益證明），用語可能過時。
- 第 458 行：「隨著 EIP-7702 上線，已經不建議使用 `send`／`transfer`」。兩者的因果關係需查證（2,300 gas 的問題早在 EIP-1884 之後就已被討論）。
- 第 879 行：「EIP-4844 的引進已經大幅降低了（主網的）gas 成本」。EIP-4844 降低的主要是 rollup 發布資料的成本，對主網一般執行的 gas 成本影響存疑，需查證。
- 第 1024 行：程式碼使用 `ethers.providers.WebSocketProvider`，輸出中的 `"type": "BigNumber"` 也是 ethers v5 的格式；第 1002 行 `npm i ethers` 現在安裝的是 v6（API 為 `ethers.WebSocketProvider`、數值為 bigint），照做可能無法執行。
- 第 1323 行：「ethers 的 `maxFeePerGas()`」：ethers 似乎沒有這個函式（應是 `provider.getFeeData()` 回傳的 `maxFeePerGas` 欄位），需查證連結內容。
- 第 1281 行：「用來支付 gas 的所有以太幣都會被當作交易手續費收走」。EIP-1559 之後基本費用會被銷毀，嚴格說並非全部成為手續費。
- 第 79 行：Fe「自 2021 年 1 月推出 alpha 版以來仍處於早期階段」，現況需查證。
- 第 43 行：「隨著以太坊路線圖上即將到來的升級，這項操作將不再可行」，時程需查證。

## 疑問與不確定之處

- 程式碼區塊內的錯誤（依規定未改，也沒有加譯註，供回報上游參考）：
  - 第 750 行 `revert("Disabled feature”);` 的結尾引號是彎引號 `”`，無法編譯。
  - 第 1155 行 `_faucet.withdraw(0.1 ether)` 少了分號。
  - 第 311、317 行的片段用 `withdrawAmount`，與當時的範例 7-1（`_withdrawAmount`）不一致。
- 第 1253 行說 `tx.origin` 是 `web3.eth.accounts[0]`，但本章的事件範例改用 ethers.js；照原文翻譯。
- 第 37 行引用第 6 章的小節「Special Transaction: Contract Creation」，譯為〈特殊交易：建立合約〉；請與第 6 章譯稿的實際標題對齊。
- 第 296 行原文「Unix Epoch (January 1. 70)」應是「January 1, 1970」的筆誤，譯為「Unix epoch（1970 年 1 月 1 日）」。術語表把「紀元」列為 epoch 的不用寫法，所以 Unix epoch 保留英文。
- 第 290 行 `mapping(KEY_TYPE` `⇒` `VALUE_TYPE)` 用的是 ⇒ 而不是 Solidity 實際的 `=>`；行內程式碼依規定未改。
- 圖片替代文字（`![…]`）比照第 8、13 章保留英文，只翻譯圖說。

## 最後一次 `check-translation.rb` 輸出

```
$ ruby scripts/check-translation.rb chapter_7.md
OK   chapter_7.md
  ! 還有 9 個 TODO-term 標記
譯稿檢查通過：1 個檔案
```
