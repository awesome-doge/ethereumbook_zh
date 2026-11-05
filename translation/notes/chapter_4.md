# 第 4 章（Cryptography）翻譯筆記

譯稿：`zh-tw/chapter_4.md`；原稿：`upstream/chapter_4.md`（上游 5907a8c）。

筆記中的「第 N 行」都指原稿 `upstream/chapter_4.md` 的行號。

## TODO-term

每個詞只在本章第一次出現處標記；其餘出現處保留英文，不再重複標記。出現次數只算正文（不含程式碼區塊與圖片替代文字），包含第一次標記的那一次。

| 英文 | 建議譯名 | 出現次數 | 備註 |
|------|----------|----------|------|
| homomorphic encryption | 同態加密 | 1 | 第 5 行 |
| asymmetric cryptography | 非對稱密碼學 | 2 | 第 30、113 行 |
| key exchange protocol | 金鑰交換協議 | 1 | 第 30 行 |
| trapdoor function | 陷門函數 | 2 | 第 36 行；另一次是第 44 行備註框的連結文字（保留英文）。第 38 行「no known trapdoors」直接譯為「已知的陷門」 |
| cryptographic primitive | 密碼學基本元件 | 3 | 第 258、262、727 行。術語表的 DeFi primitive 譯「基本元件」，建議一致 |
| preimage | 原像 | 1 | 第 270 行 |
| hash collision | 雜湊碰撞 | 4 | 第 272 行 3 次、第 296 行 1 次；第 292 行性質名稱「Collision protection」直接譯為「抗碰撞性」 |
| key stretching | 金鑰延展 | 1 | 第 303 行 |
| commit-reveal | 承諾-揭示 | 1 | 第 305 行，「commit-reveal 機制」 |
| test vector | 測試向量 | 1 | 第 324 行 |
| checksum | 校驗和 | 15 | ERC-55 兩節，含第 391 行的小節標題 |
| double spend | 雙重支付 | 1 | 第 473 行；請對照《精通比特幣》譯本的譯法 |
| heaviest chain rule | 最重鏈規則 | 1 | 第 477 行 |
| longest chain rule | 最長鏈規則 | 1 | 第 477 行 |
| double-signing | 雙重簽署 | 2 | 第 491、627 行 |
| bilinear pairing | 雙線性配對 | 2 | 第 556、564 行。之後單獨出現的「pairing」（13 次，含「pairing 群」「pairing 運算」）一併保留英文，回填時請一起處理 |
| soundness | 可靠性 | 2 | 第一次出現在第 819 行的小節標題（標記放在標題裡），另一次是第 912 行的小節標題。第 888 行的「**Sound**」標籤也保留英文。零知識證明領域另有「健全性」的譯法 |
| computational binding | 計算綁定性 | 1 | 第 831 行 |
| multiproof | 多點證明 | 1 | 第 957 行小節標題（標記放在標題裡） |
| zerofier | 零化多項式 | 1 | 第 1007 行；這不是標準教科書用語，出自研究文章 |

共 20 個 TODO-term 標記。

### 沒有標 TODO-term、直接處理的詞（請審閱時確認）

判斷原則：標準的數學用語，以及在臺灣只有一種通行譯法的一般資訊用語，直接翻譯；密碼學或協議中有多種譯法、需要全書統一的概念，才標 TODO-term。

- **數學用語**：prime factorization → 質因數分解；discrete logarithm (problem) → 離散對數（問題）；point at infinity → 無窮遠點；elliptic curve multiplication / addition → 橢圓曲線乘法／加法；scalar multiplication → 純量乘法；coefficient → 係數；degree（多項式）→ 次數；zero（多項式的根）→ 零點；quotient polynomial → 商多項式；interpolation polynomial → 插值多項式；group / group element / generator（群的）→ 群／群元素／生成元；multiplicative subgroup → 乘法子群；finite field extension → 有限體擴張；associative → 結合律；tangent / slope → 切線／斜率；evaluate / evaluation → 求值（「opened」譯「打開」）；brute-force search → 暴力搜尋；if and only if → 若且唯若。
- **密碼學與資訊用語**：encryption → 加密；one-way function / one-way hash function → 單向函數／單向雜湊函數（一度標了 TODO-term，後來因為譯法沒有爭議而改為直接翻譯）；random number generator (RNG) → 隨機數產生器（RNG），第一次寫成「隨機數產生器（random number generator，RNG）」；pseudorandom number generator → 偽隨機數產生器（依術語表 pseudorandom → 偽隨機）；digital fingerprint / data fingerprinting → 數位指紋／資料指紋；serialization → 序列化；compressed / uncompressed point → 壓縮點／未壓縮的點；padding → 填充；backdoor → 後門；case insensitive → 不區分大小寫；signature scheme / commitment scheme → 簽章方案／承諾方案；trusted setup ceremony → 可信設定儀式；1-of-N trust model → 1-of-N 的信任模型；aggregate signature → 聚合簽章；signed vote → 已簽署的選票。
- **Determinism / Verifiability / Noncorrelation / Irreversibility / Collision protection**（雜湊函數性質）→ 確定性／可驗證性／不相關性／不可逆性／抗碰撞性；**Correct / Correctness** → 正確／正確性。
- **機構名稱**：NIST → 美國國家標準暨技術研究院（National Institute of Standards and Technology，NIST）；National Security Agency → 美國國家安全局；Federal Information Processing Standard → 聯邦資訊處理標準（FIPS）。SECG、Standards for Efficient Cryptography（SEC1）保留英文。
- **secret key（第 546–554 行，BLS 一節的 `sk`）**：譯為「私鑰」，與全章的 private key 一致；第 17 行「private (secret) key」譯為「私鑰（祕密金鑰）」。
- **ERC／EIP**：本章只以 ERC-55、ERC-59、EIP-55、EIP-1011、EIP-4844 這類標準編號出現，沒有單獨出現 ERC 或 EIP，因此沒有寫出「以太坊徵求意見（ERC）」「以太坊改進提案（EIP）」的並列形式。
- **[並列] 術語第一次出現**：零知識證明（zero-knowledge proof，第 5 行）、公開金鑰密碼學（public key cryptography，PKC，第 7 行）、外部擁有帳戶（EOA）與以太幣（ether，第 11 行）、橢圓曲線密碼學（elliptic curve cryptography，第 38 行）、熵（entropy，第 71 行）、工作量證明（proof of work，PoW，第 302 行清單）、以太坊域名服務（Ethereum Name Service，ENS，第 389 行）、權益證明（PoS，第 468 行）、罰沒（slashing，第 483 行）、點對點（P2P，第 501 行）、見證投票（attestation，第 552 行）、第二層（layer 2，L2，第 647 行）、資料可用性抽樣（data availability sampling，DAS，第 655 行）。之後使用縮寫 PKC、PoW、PoS、L2、DAS，比照第 13 章的做法。
- 「Wallet Best Practices」（第 13 行，第 5 章的節名）譯為「錢包最佳實踐」；第 5 章譯稿完成後請核對節名是否一致。

## 譯註

1. `[^tn1]`（第 829 行）：原文「If `n = 228` and `p = 2^256`, the probability … is `2 × 10^-69`」。依同一句的數字驗算：228 ÷ 2^256 ≈ 1.97 × 10^-75；2^28 ÷ 2^256 = 2^-228 ≈ 2.32 × 10^-69，才與原文的 2 × 10^-69 相符。原文的 `n = 228` 應是 `n = 2^28` 漏了次方符號（行內程式碼依規定不改）。**建議回報上游。**
2. `[^tn2]`（第 916 行）：第 916、918、920 行三處寫「the verifier」，從上下文判斷應為「the prover」：第 914 行問的是「Can the prover fake it?」，第 918 行結尾說「The prover is not able to compute such a `y′`」，第 935 行說計算這個證明「is computationally impossible for the prover」。譯文依原文譯為「驗證方」，以譯註說明。**建議回報上游。**

## 可能過時或需查證

以下是懷疑原文有誤或不精確，但無法只靠本書內容驗證、或屬於排版小瑕疵的地方，沒有寫進譯註：

- 第 123 行說 `secp256k1` 標準由 NIST 制定；但第 229 行把 SEC 標準歸給 SECG。依譯者所知，`secp256k1` 是 SECG 的 SEC 2 所定義的曲線，不是 NIST 的曲線。屬外部事實，未加譯註。
- 第 393 行「detect errors with a 99.986% accuracy」：依譯者所知，EIP-55 文件寫的是錯誤地址意外通過檢查的機率約 0.0247%（即約 99.975%）。數字來源請核對。
- 第 477 行「After more or less 12 seconds, a different miner produces a new block」：12 秒是 PoS 的 slot 長度；PoW 時期以太坊的平均出塊時間大約是 13–15 秒。影響不大，照譯。
- 第 335 行「FIP-202」應為「FIPS-202」（漏字）；譯文照原文保留「FIP-202」。
- 第 447 行寫「EIP-55 compliant」，同一節其他地方都寫「ERC-55」；照原文保留。
- 第 528 行關於 EIP-1011 的數字（最多九百個驗證者、最低 1,500 ETH）、第 776 行「超過 140,000 名參與者」、第 526 行「每秒約 2,600 則訊息」，都是外部事實，未查證。
- 第 786、827 行把多項式的 degree（次數）寫成「order」（階），照原文譯為「多項式的階」；第 697 行起本章都用 degree（次數）。
- 第 943 行寫「BLS12_381」，第 536 行寫「BLS12-381」；照原文保留。
- 第 900 行「is a a multiplicative subgroup」重複了「a」，譯文不受影響。
- 第 814 行程式碼區塊中 `p₁s₁ + p₂s²₁` 的下標位置錯位（應為 `p₁[s]₁` 之類），第 931–932 行用反引號「`」代替 prime 符號「′」，第 601 行 `H(M)` 大小寫不一致；程式碼區塊依規定不改。
- 第 823 行「lines (polynomials of degree 1) have one zero」：水平線以外的直線才恰有一個零點，屬簡化說法，照譯。

## 疑問與不確定之處

- 第 1071 行原稿的「Chapter 5」中間是不換行空格（U+00A0），Edit 比對時需注意；譯文寫成「第 5 章」。
- 第 472–473 行、第 733–734 行原稿是兩行連在一起的同一段（中間沒有空行），譯文照樣保持同一段、兩行。
- 第 579 行 Vitalik Buterin 的引文是一般引用框（不是提示框），已翻譯，行內程式碼全部保留。
- 第 3 行「digital fingerprints, also known as *hashes*」：hash 在這裡指雜湊函數的輸出，譯為「雜湊值」；第 270 行「The output is called the *hash*」也譯為「雜湊值」。
- 第 552 行「the actual validator's attestation」：attestation 依術語表譯「見證投票」，並在此第一次並列。
- 第 613–633 行把 vote 譯為「投票」（動作）與「選票」（被簽署、被聚合的訊息）。
- 第 916–920 行依指引照原文譯「驗證方」，讀者可能困惑，已加譯註；審閱時也可考慮直接改譯「證明方」。
- 第 1061 行圖說「of the polynomials」為複數，譯為「多項式各個求值結果」。
- 第 641 行與第 470 行的「### Introduction」都譯為「簡介」；第 609 行與第 1035 行的「In Summary」都譯為「小結」。
- 圖片替代文字（`![…]`）比照已審閱的第 8、13 章保留英文，只翻譯圖說。

## 最後一次 `check-translation.rb` 輸出

```
$ ruby scripts/check-translation.rb chapter_4.md
OK   chapter_4.md
  ! 還有 20 個 TODO-term 標記
譯稿檢查通過：1 個檔案
```
