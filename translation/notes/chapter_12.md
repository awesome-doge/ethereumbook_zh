# 第 12 章（Decentralized Applications）翻譯筆記

譯稿：`zh-tw/chapter_12.md`；原稿：`upstream/chapter_12.md`（上游 5907a8c）。

筆記中的「第 N 行」都指原稿 `upstream/chapter_12.md` 的行號。

## TODO-term

每個詞只在本章第一次出現處標記；其餘出現處保留英文，不再重複標記。出現次數只算正文（不含程式碼區塊與圖片替代文字）。

| 英文 | 建議譯名 | 出現次數 | 備註 |
|------|----------|----------|------|
| mixing service | 混幣服務 | 1 | Tornado Cash 的描述 |
| indexer | 索引器 | 2 | 「indexers」，第 59、65 行 |
| blockchain indexer | 區塊鏈索引器 | 1 | 備註框中的定義（斜體） |
| content-addressable / content addressable | 內容定址 | 2 | IPFS 一節，第二次是斜體的定義 |
| burner wallet | 拋棄式錢包 | 6 | Scaffold-ETH 的功能名稱；另有圖 12-5 圖說 1 次（未標記）。第 333 行「burner address」譯為「burner wallet 地址」 |
| frontend-as-a-service | 前端即服務 | 1 | 描述 Vercel |
| content hash | 內容雜湊 | 1 | 第 467 行；同段之後及第 470、477、515 行的 `contenthash`（ENS 的紀錄欄位名稱，共 4 次）保留英文、未標記 |
| pin（IPFS） | 釘選 | 1 | 「pin a cluster」 |

共 8 個 TODO-term 標記。

### 沒有標 TODO-term、直接處理的詞（請審閱時確認）

- **whitelist → 白名單**：一般用語，譯名沒有爭議，因此直接使用；編者註討論這個英文詞本身，寫成「whitelist」（白名單）。原稿正文共 8 處。
- **reverse proxy → 反向代理**：臺灣資訊界的通用譯法。
- **DWebsite**：原文自創的縮寫（對應 DApp），保留英文；第一次出現寫成「去中心化網站（也稱為 *DWebsite*）」。
- **deployer account → 部署者帳戶**、**production environment → 正式環境**、**gateway → 閘道**、**custom domain → 自訂網域**：一般用語。
- **Office of Foreign Assets Control → 美國財政部海外資產控制辦公室**：臺灣媒體常用名稱，後面附英文全名。
- 「ENS domain」「`.eth` domain names」譯為「ENS 名稱」「`.eth` 名稱」；一般網站的 domain 譯為「網域」。術語表的「以太坊域名服務（ENS）」只用在第一次出現處。
- IP address 寫成「IP 地址」：臺灣慣用「IP 位址」，但術語表把「位址」列在 address 的「不用」欄，檢查腳本會擋。建議日後在術語表說明 IP address 的例外，或維持「IP 地址」。

## 譯註

1. `[^tn1]`（第 41 行，Facebook 遭封鎖的國家）：原文把巴西列入封鎖 Facebook 的國家，疑似有誤。巴西在 2024 年 8 月至 10 月封鎖的是 X（Twitter），不是 Facebook。**建議回報上游。**
2. `[^tn2]`（第 49 行，Tornado Cash）：原文的時間點停在 2024 年 12 月，補充後續發展：Pertsev 於 2024 年 5 月被荷蘭法院以洗錢罪判處 64 個月徒刑（上訴中）；美國第五巡迴上訴法院 2024 年 11 月裁定財政部不得制裁不可變更的智能合約；財政部於 2025 年 3 月將 Tornado Cash 移出制裁名單。以上依譯者所知撰寫，**審閱時請再核對日期與刑期**。
3. `[^tn3]`（第 85 行，第一個程式碼範例）：上游程式碼錯誤。`whitelistMint()` 先 `_safeMint(msg.sender, nextTokenId)`，接著 `tokenId = nextTokenId++` 再 `_safeMint(msg.sender, tokenId)`，同一個代幣 ID 鑄造兩次，第二次會回復。程式碼依規定不改，以譯註說明。**建議回報上游。**
4. `[^tn4]`（第 192 行，node.js 連結）：原文連結網址是 `http://node.js`，不是有效網站；網址依規定不改，譯註補上 <https://nodejs.org>。**建議回報上游。**

## 疑問與不確定之處

- 原文第 381 行兩處寫成小寫的「dApp」，與全章的「DApp」不一致；譯稿統一寫成 DApp。
- 第 417–425 行兩個程式碼區塊標示為 `bash`，內容其實是 TypeScript（`scaffold.config.ts` 的設定）。依規定未改。
- 第 521 行說回傳的網址格式是 `community.bgipfs.com/<ipfs-content-hash>`，但第 512 行的實際輸出是 `https://community.bgipfs.com/ipfs/bafybei…`（多一層 `/ipfs/`）。原文小瑕疵，未加譯註。
- 第 523 行「run your own IPFS node and pin a cluster」語意不太通順（一般是「pin 內容」或「架設 cluster」），照字面譯為「pin 一個叢集」。
- 第 363 行「click the asterisk」：Scaffold-ETH 介面上把 ETH 換算成 wei 的按鈕是「∗」符號，譯為「星號」。
- 介面上的名稱（Debug Contracts、Disconnect、Connect Wallet、Send、Domains、「_newGreeting」「payable value」欄位、greeting／premium／totalCounter）依指示保留英文；「Debug Contracts section」譯為「Debug Contracts 頁面」。
- 圖片替代文字（`![…]`）比照已審閱的第 8、13 章保留英文，只翻譯圖說。
- 圖 12-9「Grab funds button」譯為「Grab funds 按鈕」，與圖 12-6「Connect Wallet 按鈕」一致（Scaffold-ETH 2 水龍頭按鈕的提示文字應為「Grab funds from faucet」，未實際核對介面）。

## 最後一次 `check-translation.rb` 輸出

```
$ ruby scripts/check-translation.rb chapter_12.md
OK   chapter_12.md
  ! 還有 8 個 TODO-term 標記
譯稿檢查通過：1 個檔案
```


## 可能過時或需查證（由主控從譯文移出，2026-11-06）

依修訂後的指引，譯註不加入憑記憶得知的外部事實；以下兩則原為譯註，已從譯文移出，待查證後決定是否回報上游或補回：

- 原 tn1：譯註：巴西列在這裡可能有誤。巴西在 2024 年 8 月至 10 月間封鎖的是 X（前身為 Twitter），並不是 Facebook；就譯者所知，Facebook 在巴西並未遭到全面封鎖。
- 原 tn2：譯註：補充原文沒有提到的相關發展：Alexey Pertsev 於 2024 年 5 月被荷蘭法院以洗錢罪判處 64 個月徒刑（他已提起上訴）；美國聯邦第五巡迴上訴法院於 2024 年 11 月裁定，財政部不得制裁 Tornado Cash 不可變更的智能合約，美國財政部隨後在 2025 年 3 月將 Tornado Cash 從制裁名單上移除。
