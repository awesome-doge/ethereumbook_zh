# 第 11 章（Oracles）翻譯筆記

譯稿：`zh-tw/chapter_11.md`；原稿：`upstream/chapter_11.md`（上游 5907a8c）。

筆記中的「第 N 行」都指原稿 `upstream/chapter_11.md` 的行號。

## TODO-term

每個詞只在本章第一次出現處標記；其餘出現處保留英文，不再重複標記。出現次數只算正文（不含標記本身與圖片替代文字；含標題括號與圖說）。

| 英文 | 建議譯名 | 出現次數 | 備註 |
|------|----------|----------|------|
| attestation | 證明文件／認證 | 5 | **不是**術語表的「見證投票」（那是驗證者對區塊的投票）。本章的意思有兩種：護照、成就紀錄這類證明文件（第 21 行），以及 TEE、Wormhole guardian 所出具的證明（第 141、149、189 行）。動詞 attest 依語境譯成「證實」「提供證明」，未標記 |
| immediate-read | 即時讀取 | 4 | 預言機設計模式名稱；標記在第 69 行正文 |
| publish-subscribe | 發布—訂閱 | 6 | 同上 |
| request-response | 請求—回應 | 8 | 同上 |
| self-sovereign ID | 自主身分 | 1 | 第 79 行 |
| salt | 鹽值 | 1 | 「Merkle trees with salts」譯成「加了 salt 的默克爾樹」；第 9 章已有相同建議 |
| daemon | 常駐程式 | 2 | 「off-chain daemon」，第 87、95 行 |
| price feed | 價格資料源 | 1 | 第 97 行 |
| data feed | 資料源 | 2 | 第 151、195 行；與 price feed 同一系列，建議一起決定 |
| authenticity proof | 真實性證明 | 4 | 原文斜體（第 139 行） |
| attestor | 認證方 | 1 | 第 141 行；避免用「證明方」，那是 prover 的譯名 |
| enclave | 安全隔離區 | 6 | 「hardware enclave」「secure enclave」 |
| ZK coprocessor | ZK 協同處理器 | 1 | 原文斜體（第 163 行） |
| challenge window | 挑戰期 | 1 | 與第 16 章的建議一致 |
| commit-reveal scheme | 承諾—揭示機制 | 1 | 其他章已有兩種不同建議（「承諾-揭示」與「承諾—揭露機制」），定案時請統一 |
| Schelling point | 謝林點 | 1 | 原文斜體（第 173 行）；賽局理論的通用譯名 |
| relayer | 中繼者 | 4 | LayerZero 的元件名稱，原文大寫 Relayer；與第 9 章的建議一致 |
| guardian | 守護者 | 5 | Wormhole 的 guardian；與第 5 章的建議一致（但第 5 章指社交恢復的 guardian，意思不同） |
| parachain | 平行鏈 | 3 | Polkadot |
| hub | 樞紐鏈 | 1 | Cosmos |

共 20 個 TODO-term 標記。

### 沒有標 TODO-term、直接處理的詞（請審閱時確認）

- **三個設計模式的小節標題**：依交辦要求，每個小節標題都要有中文，因此寫成「### 即時讀取（Immediate-Read）」「### 發布—訂閱（Publish-Subscribe）」「### 請求—回應（Request-Response）」，用的是 TODO-term 的建議譯名；正文與圖說仍保留英文。這三個詞定案後，標題要一併回填。
- **LayerZero 的 Oracle**：LayerZero 的元件名稱（原文大寫），保留英文，第一次出現寫成「Oracle（預言機）」，以免與一般的預言機混淆。
- **SchellingCoin、Relay Chain、Inter-Blockchain Communication（IBC）、Cross-Chain Interoperability Protocol（CCIP）、Cross-Chain Transfer Protocol（CCTP）**：協議或元件的專有名稱，保留英文。
- **cross-chain messaging protocol → 跨鏈訊息協議**（標題）；正文的 cross-chain protocol 譯「跨鏈協議」。與第 13 章「全鏈協議就是第 11 章所討論的跨鏈訊息協議」一致。
- **[並列] 術語的第一次出現**：以太幣（ether）、去中心化應用（DApp）、點對點（P2P）、外部擁有帳戶（EOA）、可信執行環境（trusted execution environment，TEE）、零知識證明（zero-knowledge proof）、資料可用性（data availability）、幣安智能鏈（Binance Smart Chain，BSC）、非同質化代幣（NFT）。
- **VRF**：原文只出現產品名稱 Chainlink VRF；為了符合 [並列] 規則，第一次出現寫成「Chainlink VRF 就是一個實際的例子，它是 Chainlink 的可驗證隨機函數（VRF）服務」，多了一個說明子句。
- **一般用語，直接翻譯**：polling → 輪詢、push service →「推播」服務、multicast → 群播、client-server architecture → 主從式架構、service-level agreement → 服務水準協議、reputation / order-matching / aggregation contract → 信譽合約／訂單撮合合約／聚合合約、catastrophe bond → 巨災債券、prediction market → 預測市場、fantasy sports → 夢幻運動、smart will → 智能遺囑、smart bond → 智能債券、moving average → 移動平均、spot price → 現貨價格、trust minimization → 信任最小化、multioperator system → 多營運者系統、root hash → 根雜湊值、data payload → 交易所攜帶的資料（data payload）。
- **country codes / currency codes / airport identifiers**：寫成「國家代號、貨幣代號、機場代號」。「代碼」是檢查腳本擋的中國大陸用語（應為「程式碼」），但這裡不是程式碼，所以改用「代號」。
- **fully centralized verifiers**（第 151 行）：依術語表譯成「驗證方」，不用「驗證者」。
- **What is the address for ethereumbook.info?**（第 73 行）：依術語表譯成「地址」；原文這裡可能指網域的 IP 位址，也可能指 ENS 名稱對應的以太坊地址，無法判斷。

## 譯註

1. `[^tn1]`（第 55 行）：原文說接下來幾節會介紹「oracle client implementations in Solidity」，但本章第二版沒有這樣的小節：其後各節只有設計模式、資料認證、計算預言機、去中心化預言機、跨鏈訊息協議與結論，也沒有任何程式碼區塊。對照本專案第一版譯稿 `ch12.asciidoc`（預言機一章），第一版第 114 行有「Solidity中的Oracle客戶端接口」一節，可見這句是第一版遺留的。**建議回報上游。**

## 可能過時或需查證（未寫進譯文）

- 第 15 行「Mostly, they are used to pass information between different blockchains, such as token prices」：說預言機「大多」用於在不同區塊鏈之間傳遞資訊，與本章其餘把預言機定義為把鏈外資料帶上鏈的說法不太一致，可能是原文筆誤或論點跳躍。照原文翻譯。
- 第 169–171 行 Chainlink 的「信譽合約、訂單撮合合約、聚合合約」三合約架構，出自 Chainlink 早期（2017 年）白皮書，現行的 Chainlink 架構可能已不同。
- 第 157 行警告框「TEEs are relatively new」：可能需要依現況調整語氣。
- 第 189 行 Wormhole 支援的鏈（BSC、Hyperliquid、Avalanche）與第 199 行「CCTP has been integrated by Chainlink into CCIP」：都是會隨時間變動的外部事實，未查證。
- 第 181–187 行 LayerZero 的 Oracle／Relayer 模型是 LayerZero v1 的設計；v2 據譯者所知已改為 DVN（去中心化驗證者網路）與 Executor。屬憑記憶的外部資訊，未寫進譯文，請審閱時查證。
- 第 163 行對 Brevis「樂觀發布、挑戰時才產生零知識證明」的描述，未查證是否符合 Brevis 現行設計。

## 翻譯時的疑問

- attestation 在術語表定為「見證投票」，但術語表說明欄限定是驗證者對區塊的投票；本章的 attestation 全都是「資料證明／認證」的意思，若套用「見證投票」會錯。因此當作術語表沒有的詞，標 TODO-term。建議術語表把兩種意思分開列。
- 交辦說明提到本章有 4 個註腳；原稿實際是 2 個註腳（`[^1]`、`[^2]`，各有標記與定義，合計 4 行），譯稿保持 2 個，另加 1 個譯註註腳。
- 交辦說明列出的 Chronicle、UMA、Pyth 在本章原稿中沒有出現。
- 「Data Authentication」（第 137 行標題，以及第 139、151 行的 data authentication）譯成「資料認證」，與本節大量出現的 verify／validate（驗證）區分。
- 建議譯名中「發布—訂閱」「請求—回應」用的是單一破折號，不是風格指南的「——」；定案回填時請一併決定連接符號（例如改用「／」或直接寫成「發布／訂閱」）。
- 第 147 行「providing a hint that the oracle cannot predict」的 hint 指的是請求方提供的種子值，譯成「提示值」，照原文用詞。

## check-translation.rb 輸出

```
OK   chapter_11.md
  ! 還有 20 個 TODO-term 標記
譯稿檢查通過：1 個檔案
```
