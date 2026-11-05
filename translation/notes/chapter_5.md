# chapter_5.md 翻譯筆記

（行號說明：「`[並列]` 術語第一次出現的位置」一段的行號指譯稿 `zh-tw/chapter_5.md`；其餘各節的行號都指原稿 `upstream/chapter_5.md`。）

## TODO-term

共 31 個。「出現次數」是該英文術語在譯稿正文中保留英文的次數（含標記的那一次，不含圖片替代文字）。

| 英文 | 建議譯名 | 出現次數 | 備註 |
|---|---|---|---|
| key derivation function | 金鑰衍生函數 | 1 | 原文縮寫 KDF 並列 |
| password-stretching algorithm | 密碼延展演算法 | 1 | |
| rainbow table | 彩虹表 | 1 | |
| chain code | 鏈碼 | 11 | |
| watch-only | 僅供觀察 | 1 | 同句的 receive-only 直接譯「只能收款」 |
| brainwallet | 腦錢包 | 3 | |
| checksum | 校驗和 | 6 | 與其他章已用的建議譯名一致；含表 5-1 表頭 2 次 |
| key stretching | 金鑰延展 | 6 | 寫成「key stretching 函數」 |
| salt | 鹽值 | 9 | |
| plausible deniability | 合理推諉 | 1 | |
| duress wallet | 脅迫錢包 | 1 | |
| seed phrase | 種子短語 | 3 | 意思與助記詞相同，可考慮直接併入「助記詞」 |
| hardened | 強化 | 18 | 只標單字 hardened，寫成「hardened 衍生」「hardened 子金鑰」「hardened 金鑰」；含小節標題 2 個 |
| cold storage | 冷儲存 | 1 | |
| change address | 找零地址 | 3 | 第 85 行「receive change from outgoing payments」是一般敘述，直接譯「找回的零錢」 |
| self-custody | 自我託管 | 1 | |
| operational security | 操作安全 | 1 | 另有縮寫 OpSec 2 次 |
| Rollup Improvement Proposal | rollup 改進提案 | 1 | 縮寫 RIP 照原文使用；術語表只有 EIP／ERC |
| bundler | 打包者 | 5 | |
| paymaster | 代付者 | 4 | 另有合約名 Paymaster Contract 1 次（專有名詞，未計入） |
| social recovery | 社交恢復 | 9 | 小節標題「### Social Recovery」保留英文另計 1 次；見「疑問」第 1 點 |
| sponsorship | 代付 | 5 | 與其他章已用的建議譯名一致；含「gas sponsorship」「交易的 sponsorship」 |
| multicall | 多重呼叫 | 3 | 另有圖片替代文字 1 次 |
| invoker | 代呼叫合約 | 12 | 避開「調用」（檢查腳本禁用） |
| set code transaction | 設定程式碼交易 | 1 | |
| typed transaction envelope | 型別化交易封裝 | 1 | 與其他章已用的建議譯名一致 |
| invariant | 不變條件 | 3 | 一般譯法「不變量」含禁用詞「變量」，所以建議「不變條件」 |
| atomic | 原子性 | 3 | 與其他章已用的建議譯名一致；寫成「atomic 交易」「atomic 三明治攻擊」 |
| privilege deescalation | 權限降級 | 2 | |
| storage slot | 儲存槽 | 1 | 與其他章已用的建議譯名一致 |
| guardian | 守護者 | 7 | |

另外，下列詞語術語表沒有，但我視為一般用語或由表上術語直接組合，**沒有標 TODO-term**，統一回填時可以一併檢視：

- 由表上術語組合：主金鑰／主私鑰／主公鑰（master key）、父金鑰／子金鑰／孫金鑰（parent／child／grandchild key）、根種子（root seed）、擴展私鑰／擴展公鑰（extended private／public key，依「擴展金鑰」）、非確定性錢包／確定性錢包（依「確定性」）、UserOperation 記憶池、智能錢包／智能合約錢包、重放保護（依「簽章重放攻擊」）、簽署金鑰（signing key）
- 一般資安或電腦用語：暴力破解（brute-force）、字典攻擊、私鑰碰撞、雙重支付（double-spending）、批次處理（batching）、金鑰輪替（key rotation）、子金鑰（subkey）、索引編號（index number）、命名空間、防火牆
- 專有名詞保留英文：JBOK、UserOperation、EntryPoint、Nonce Manager Contract、Deployer Contract、Account Contract、Paymaster Contract、Execution Frame、Electrum、Trezor、Ledger、Rabby Wallet、MetaMask、Phantom、SatoshiLabs、Ethereum Classic、Litecoin、Mnemonic Code Converter（連結文字是工具名，保留英文）、SLIP-0044、PBKDF2、HMAC-SHA512

`[並列]` 術語在本章第一次出現的位置：以太幣（ether）第 15 行、去中心化應用（DApp）第 5 行、階層確定性（hierarchical deterministic）第 69 行提示框（正文第一次出現；第 27 行是引用小節名，照標題寫）、熵（entropy）第 140 行、帳戶抽象（account abstraction，AA）第 411 行、外部擁有帳戶（EOA）第 411 行、以太坊改進提案（EIP）與以太坊徵求意見（Ethereum Requests for Comments，ERC）第 417 行、以太坊虛擬機（EVM）第 441 行、執行層（execution layer）第 465 行、兌換（swap）第 479 行、以太坊域名服務（Ethereum Name Service，ENS）第 571 行。

## 譯註

共 3 個。

1. `[^tn1]`（「從助記詞到種子」第一段）：原文說「The entropy is then used to derive a longer (512-bit) seed through … PBKDF2」，但同一小節的步驟 7 明寫 PBKDF2 的第一個參數是「the mnemonic produced in step 6」，步驟 9 也說 PBKDF2 延展的是「the mnemonic and salt parameters」。譯註說明實際輸入是助記詞與 salt，不是熵。可以直接從書中步驟 7～9 驗證。
2. `[^tn2]`（ERC-4337 第二段末）：原文說「ERC-4337 overcomes this by enabling EOAs to function as smart contracts」。但本章 ERC-4337 小節自己描述的機制是使用者送出 UserOperation、由 bundler 包進一般交易，而本章「EIP-5003」一節更明說這些好處「mostly limited to users who actively adopt new standards through smart contract wallets and app-layer solutions, such as those proposed by ERC-4337」，長期使用 EOA 的既有使用者「limited security and usability improvements」。兩處互相矛盾，譯註依書中 EIP-5003 一節說明 ERC-4337 是讓使用者改用智能合約帳戶，不是讓既有 EOA 變成智能合約。

3. `[^tn3]`（EIP-7702 一節的備註框第一段）：這個提示框講的是 EIP-2718，但「This EIP also adjusts EIP-3607's restrictions, allowing transactions from EOAs flagged with a delegation designation」說的其實是 EIP-7702。委託指定是 EIP-7702 引入的機制，本章 EIP-7702 一節與其後的提示框都可以驗證。正文照原文譯成「這項 EIP」，用譯註說明指的是 EIP-7702。定義行放在整個備註框結束之後。

（審閱時如果認為第 1 個譯註太細，可以刪掉；它只是書中前後不一致，不影響讀者理解流程。）

## 可能過時或需查證

以下都沒有寫進譯文：

1. **Pectra 時程**（第 413、505 行）：原文寫「which will be implemented in the Pectra upgrade」「expected to be implemented in Pectra by early 2025」，並自註本章寫於 2024 年 9～10 月。出版時應已過時；譯文照原文使用未來式。
2. **ERC-4337 現況**（第 423 行）：「As of September 2024, the primary on-chain implementation of AA is ERC-4337」，有明確時間點，照譯。
3. **keystore 的「262,144 輪雜湊」**（第 65 行）：範例 JSON 的 `kdf` 是 `scrypt`，`n` 是 scrypt 的成本參數，把它說成「雜湊函數重複 262,144 輪」可能不精確。這需要書外的 scrypt 知識才能判斷，所以沒加譯註。
4. **「seed in hexadecimal」範例**（第 95～99 行程式碼區塊）：`FCCF1AB3329FD5DA3DA9577511F8F137` 是 128 位元、對應 12 個單字，依本章表 5-1 與「從助記詞到種子」的說法，這比較像是「熵」而不是 512 位元的種子；但第 275 行又說根種子可以是 128、256 或 512 位元，書中用語本身不一致，無法斷定，所以沒加譯註。程式碼區塊不可修改。
5. **「atomic sandwich attacks, such as flash loans」**（第 517 行）：閃電貸本身不是三明治攻擊，原文的舉例方式可能不精確；同一點提到「bypassed by miners」，以太坊改為權益證明後應是提議者／區塊建構者。照原文翻譯。
6. **錢包市占**（第 405 行）：「the most popular browser wallet at the time of writing is MetaMask … a close second, Rabby」是寫作當時的狀況。
7. **EIP-3074 與 EIP-5003 的狀態**（第 471～501 行）：原文把它們當成進行中的提案介紹；印象中 EIP-3074 後來由 EIP-7702 取代，EIP-5003 依附於 EIP-3074。這是書外資訊，未寫入譯文，建議出版前查證。
8. **EIP-2429**（第 553 行）：原文稱它是與 social recovery 相關的「primary EIP」，其提案狀態未查證。
9. **BIP-32 獨立產生器**（第 285～289 行）：原文沒有給網址，無法確認「不是 HTTPS 網站」的說法是否仍成立。Mnemonic Code Converter 的網址（iancoleman.io）也未檢查是否仍可使用。

## 翻譯時的疑問或不確定之處

1. **social recovery 不在術語表**：派工說明把「社交恢復」與帳戶抽象、ENS 並列為本章重點術語，但 `translation/terminology.md` 的「錢包」一節只有 11 條，沒有 social recovery。依工作指引，我在正文第一次出現處（EIP-2938 一節）標了 `TODO-term: social recovery（建議：社交恢復）`，之後保留英文；小節標題 `### Social Recovery` 也保留英文（標題只比對層級）。請主代理決定是否直接定為「社交恢復」，屆時要一併回填標題、圖 5-10 的圖說與 Vitalik 的引言。
2. **hardened**：只標單字，造成「hardened 子金鑰衍生」「一般衍生與 hardened 衍生的索引編號」這類中英混雜的標題；定案後（例如「強化」）回填即可。
3. **mnemonic 系列**：mnemonic、mnemonic code、mnemonic code words、mnemonic words 一律譯「助記詞」；「recovery word list」是一般描述，譯「復原單字清單」。seed phrase 另外標了 TODO-term，若決定與助記詞同義可直接改成「助記詞」。
4. **表 5-2～5-4**：熵、助記詞單字、種子的十六進位值與結尾的 `...` 都原樣保留；第一欄的粗體標籤譯成「熵／助記詞／密碼短語／種子」，`(none)` 視為說明文字譯成「（無）」。如果希望 `(none)` 也保留原樣，改回即可。表 5-5、5-6 的路徑（含 ASCII `'` 與 `′` 的混用）也照原稿。
5. **表 5-5 最後一列**：「great-great-grandchild … great-grandchild … grandchild … child」譯成「第 24 把子金鑰的第 18 把孫金鑰的第一把曾孫金鑰的第一把玄孫公鑰」，順序改成由上往下，與路徑 M/23/17/0/0 的讀法一致。
6. **execution layer**：第 461 行的「Ethereum Execution Layer」是協議的執行層，依術語表並列；第 513、515 行的「topmost execution layer」「execution-layer depth」指的是呼叫深度，改譯「執行層級」以免與執行層混淆。
7. **inheritance**：第 397、401 行是遺產繼承，不是程式的「繼承」，譯成「遺產繼承」。
8. **Vitalik 的引言**（第 561 行）：譯成中文放在「」內，其中 social recovery 依 TODO-term 規則保留英文。
9. **paymaster 與 sponsorship 的建議譯名**都用到「代付」，定案時可能要區分（例如 paymaster 譯「付款代理」）。
10. **「疑似未翻譯的段落」警告 10 段**：全部是圖 5-1 的替代文字（依指引保留英文），以及表 5-2～5-4 的熵、助記詞、種子儲存格（資料本身就是英文與十六進位），不是漏譯。
11. 原稿第 297、301、349 行是 4 個空格縮排的程式碼區塊，以及 `2^512^`、`10^154^`、`2^31^–1` 等寫法，都照原樣保留。

## 最後一次 check-translation.rb 輸出

```
OK   chapter_5.md
  ! 疑似未翻譯的段落 10 段（例如：HD wallet: a tree of keys generated from a single seed…）
  ! 還有 31 個 TODO-term 標記
譯稿檢查通過：1 個檔案
```
