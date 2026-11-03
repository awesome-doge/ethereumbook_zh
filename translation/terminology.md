# 《精通以太坊》第二版 術語對照表

本表規定第二版繁體中文譯本的術語譯法，翻譯時優先查閱本表。
與《精通比特幣》第三版譯本共通的術語（金鑰、簽章、雜湊、記憶池、默克爾樹、完整節點、測試網路……）沿用同樣的譯法，兩本書讀起來才一致。

> 狀態：**平行翻譯前定案**（2026-11-03）。全書起草 254 條，兩章試譯新增 93 條，再從第 7、9、14 章抽取 98 條，現共 446 條。候選詞取自上游全部 18 個檔案的縮寫、首次以斜體或粗體出現的術語與各級標題；2018 草稿譯本的用詞只當參考。
> 2026-11-03 已決定：slot、epoch 保留英文；attestation 譯「見證投票」；prover／verifier 譯「證明方／驗證方」；原文的 you 譯「你」；revert 譯「回復」；gossip protocol 譯「gossip 協議」；justified 譯「已合理化」。
> 標為 `[待定]` 的條目請在試譯階段決定，定案後改成 `[固定]`、`[並列]` 或 `[保留]`。平行翻譯開始前，本表不應再有 `[待定]`。

## 使用說明

- **狀態**
  - `[固定]`：全書統一使用該譯名
  - `[並列]`：每章第一次出現時寫成「中文（English）」或「中文（縮寫）」，之後只用中文
  - `[保留]`：保留英文原文，不翻譯
  - `[待定]`：還沒定案，譯者遇到時保留英文並標 `TODO-term:`
- **不用**：這一欄的寫法不得出現在譯稿正文，`scripts/check-translation.rb` 會檢查（以頓號分隔）。
- 本表沒有的術語：一律保留英文並在該處標 `TODO-term: 英文術語`，不要自行決定譯名；全書譯完後統一決定、回填。

## 基礎概念

| 英文 | 譯名 | 不用 | 說明 | 狀態 |
|------|------|------|------|------|
| Ethereum | 以太坊 | 乙太坊 | | [固定] |
| ether | 以太幣 | 乙太幣 | 貨幣；金額寫成「0.1 ETH」 | [並列] |
| ETH | ETH | | 以太幣的代號 | [保留] |
| wei / gwei | wei / gwei | | 以太幣的單位 | [保留] |
| blockchain | 區塊鏈 | | | [固定] |
| block | 區塊 | | | [固定] |
| block header | 區塊頭 | | 與比特幣書一致 | [固定] |
| genesis block | 創世區塊 | | | [固定] |
| block explorer | 區塊瀏覽器 | | | [固定] |
| reorg / reorganization | 鏈重組 | | | [固定] |
| decentralized | 去中心化 | | | [固定] |
| decentralization | 去中心化 | | | [固定] |
| censorship resistance | 抗審查性 | | | [固定] |
| permissionless | 無需許可 | | | [固定] |
| world computer | 世界電腦 | 世界計算機 | | [固定] |
| Turing complete | 圖靈完備 | 圖靈完整 | | [固定] |
| onchain / offchain | 鏈上／鏈外 | | 與比特幣書一致 | [固定] |
| mainnet | 主網 | | | [固定] |
| testnet | 測試網路 | | 網路名稱（Sepolia、Holešky）保留英文 | [固定] |
| faucet | 水龍頭 | | 發放測試以太幣的服務 | [固定] |
| protocol | 協議 | | 與比特幣書一致 | [固定] |
| network upgrade | 網路升級 | | 升級名稱（Shanghai、Dencun、Pectra）保留英文 | [固定] |
| The Merge | 合併（The Merge） | | 2022 年改為權益證明的升級 | [並列] |
| EIP | 以太坊改進提案（EIP） | | | [並列] |
| ERC | 以太坊徵求意見（ERC） | | 標準名稱寫成 ERC-20、ERC-721 | [並列] |

## 帳戶、地址與狀態

| 英文 | 譯名 | 不用 | 說明 | 狀態 |
|------|------|------|------|------|
| account | 帳戶 | 賬戶、賬號 | | [固定] |
| externally owned account (EOA) | 外部擁有帳戶（EOA） | | | [並列] |
| contract account | 合約帳戶 | | | [固定] |
| smart account | 智能帳戶 | | 帳戶抽象 | [固定] |
| account abstraction (AA) | 帳戶抽象（AA） | | | [並列] |
| address | 地址 | 位址 | | [固定] |
| balance | 餘額 | | | [固定] |
| nonce | nonce | | 帳戶的交易計數，不要譯成「隨機數」 | [保留] |
| state | 狀態 | | | [固定] |
| world state | 世界狀態 | | | [固定] |
| state transition | 狀態轉換 | 狀態轉移 | | [固定] |
| state root | 狀態根 | | | [固定] |
| statelessness | 無狀態性 | | | [固定] |
| state expiry | 狀態過期 | | | [固定] |

## 密碼學

| 英文 | 譯名 | 不用 | 說明 | 狀態 |
|------|------|------|------|------|
| cryptography | 密碼學 | | | [固定] |
| public key cryptography (PKC) | 公開金鑰密碼學 | | | [並列] |
| key | 金鑰 | 密鑰、秘鑰 | 與比特幣書一致 | [固定] |
| private key | 私鑰 | | | [固定] |
| public key | 公鑰 | | | [固定] |
| key pair | 金鑰對 | | | [固定] |
| signature | 簽章 | 簽名 | 與比特幣書一致 | [固定] |
| digital signature | 數位簽章 | 數字簽名 | | [固定] |
| hash | 雜湊 | 哈希、散列 | 與比特幣書一致 | [固定] |
| hash function | 雜湊函數 | | 數學上的「函數」；程式的 function 用「函式」 | [固定] |
| hash value / digest | 雜湊值 | | | [固定] |
| elliptic curve | 橢圓曲線 | | | [固定] |
| elliptic curve cryptography (ECC) | 橢圓曲線密碼學 | | | [並列] |
| finite field | 有限體 | 有限域 | 臺灣數學用語 | [固定] |
| prime order | 質數階 | 素數階 | | [固定] |
| generator point | 生成點 | | | [固定] |
| modulo | 取模 | | | [固定] |
| commitment | 承諾 | | 與比特幣書一致 | [固定] |
| polynomial commitment | 多項式承諾 | | | [固定] |
| KZG commitment | KZG 承諾 | | | [固定] |
| trusted setup | 可信設定 | 可信設置 | | [固定] |
| BLS signature | BLS 簽章 | | | [固定] |
| signature aggregation | 簽章聚合 | | | [固定] |
| entropy | 熵 | | 與比特幣書一致 | [並列] |
| randomness | 隨機性 | | | [固定] |
| VRF | 可驗證隨機函數（VRF） | | | [並列] |
| TEE | 可信執行環境（TEE） | | | [並列] |
| Keccak-256 / SHA-256 / ECDSA / secp256k1 | 保留英文 | | | [保留] |

## 錢包

| 英文 | 譯名 | 不用 | 說明 | 狀態 |
|------|------|------|------|------|
| wallet | 錢包 | | | [固定] |
| hardware wallet | 硬體錢包 | | | [固定] |
| seed | 種子 | | | [固定] |
| mnemonic | 助記詞 | 助記符、助記碼 | | [固定] |
| passphrase | 密碼短語 | | 與比特幣書一致 | [固定] |
| HD wallet | HD 錢包 | | 階層確定性錢包 | [保留] |
| hierarchical deterministic | 階層確定性 | 分層確定性 | | [並列] |
| derivation path | 衍生路徑 | 派生路徑 | | [固定] |
| extended key | 擴展金鑰 | | | [固定] |
| keystore | keystore 檔案 | | | [保留] |
| multisig | 多重簽章 | 多簽 | | [固定] |

## 交易與 gas

| 英文 | 譯名 | 不用 | 說明 | 狀態 |
|------|------|------|------|------|
| transaction | 交易 | | | [固定] |
| transaction fee | 交易手續費 | | | [固定] |
| gas | gas | 燃料、燃氣 | 保留英文 | [保留] |
| gas limit | gas 上限 | | | [固定] |
| gas price | gas 價格 | | | [固定] |
| gas fee | gas 費用 | | | [固定] |
| base fee | 基本費用 | | EIP-1559 | [固定] |
| priority fee / tip | 優先費用／小費 | | | [固定] |
| block gas limit | 區塊 gas 上限 | | | [固定] |
| gas refund | gas 退款 | | | [固定] |
| mempool | 記憶池 | 內存池、記憶體池、交易池 | 與比特幣書一致 | [固定] |
| receipt | 交易收據 | | | [固定] |
| log | 日誌 | | 事件日誌 | [固定] |
| access list | 存取清單 | 訪問列表 | EIP-2930 | [固定] |
| blob | blob | | EIP-4844 的資料區塊，保留英文 | [保留] |
| blob transaction | blob 交易 | | | [固定] |
| calldata | calldata | | | [保留] |
| RLP / SSZ | RLP / SSZ | | 編碼格式 | [保留] |
| sign / signing | 簽署 | | 動詞；名詞用「簽章」 | [固定] |
| broadcast | 廣播 | | | [固定] |
| front-running | 搶先交易 | 搶跑 | | [固定] |
| sandwich attack | 三明治攻擊 | | | [固定] |
| MEV | 最大可提取價值（MEV） | | maximal extractable value | [並列] |

## 節點與網路

| 英文 | 譯名 | 不用 | 說明 | 狀態 |
|------|------|------|------|------|
| node | 節點 | | | [固定] |
| full node | 完整節點 | 全節點 | 與比特幣書一致 | [固定] |
| archive node | 封存節點 | 歸檔節點 | | [固定] |
| light client | 輕客戶端 | | | [固定] |
| client | 客戶端 | 用戶端 | | [固定] |
| execution client | 執行層客戶端 | | | [固定] |
| consensus client | 共識層客戶端 | | | [固定] |
| execution layer (EL) | 執行層 | | | [並列] |
| consensus layer (CL) | 共識層 | | | [並列] |
| peer | 對等節點 | | 與比特幣書一致 | [固定] |
| peer-to-peer (P2P) | 點對點（P2P） | | | [並列] |
| gossip protocol | gossip 協議 | 八卦協議、流言協議 | 節點之間逐一轉傳訊息的方式 | [固定] |
| sync / synchronization | 同步 | | | [固定] |
| JSON-RPC / RPC / API | 保留英文 | | | [保留] |
| Geth / Reth / Nethermind / Lighthouse / Prysm 等客戶端名稱 | 保留英文 | | | [保留] |

## 共識

| 英文 | 譯名 | 不用 | 說明 | 狀態 |
|------|------|------|------|------|
| consensus | 共識 | | | [固定] |
| proof of work (PoW) | 工作量證明（PoW） | | | [並列] |
| proof of stake (PoS) | 權益證明（PoS） | 股權證明 | | [並列] |
| proof of authority (PoA) | 權威證明（PoA） | | | [並列] |
| mining / miner | 挖礦／礦工 | | | [固定] |
| validator | 驗證者 | 驗證人 | 權益證明的驗證者；零知識證明的 verifier 見下方 | [固定] |
| stake / staking | 質押 | | 不要譯成「抵押」；「抵押品」是 DeFi 的 collateral | [固定] |
| restaking | 再質押 | | | [固定] |
| liquid staking | 流動性質押 | | | [固定] |
| slashing | 罰沒 | | | [並列] |
| withdrawal | 提領 | | 驗證者的質押提領 | [固定] |
| Beacon Chain | 信標鏈 | | | [並列] |
| slot | slot | 時隙 | 12 秒的時段，保留英文 | [保留] |
| epoch | epoch | 紀元 | 32 個 slot，保留英文 | [保留] |
| attestation | 見證投票 | | 驗證者對區塊的投票；不用「證明」以免與 proof 混淆 | [並列] |
| committee | 委員會 | | | [固定] |
| proposer | 提議者 | 出塊者 | | [固定] |
| block builder | 區塊建構者 | | | [固定] |
| proposer-builder separation (PBS) | 提議者與建構者分離（PBS） | | | [並列] |
| relay | 中繼 | | MEV-Boost 的中繼 | [固定] |
| fork | 分叉 | | | [固定] |
| hard fork / soft fork | 硬分叉／軟分叉 | | | [固定] |
| fork choice rule | 分叉選擇規則 | | | [固定] |
| checkpoint | 檢查點 | | | [固定] |
| finality | 最終性 | 終局性 | | [固定] |
| finalized | 已最終確定 | | | [固定] |
| justified | 已合理化 | | Casper FFG；與「已最終確定」成對 | [並列] |
| LMD GHOST / Casper FFG / Gasper | 保留英文 | | | [保留] |
| RANDAO | RANDAO | | | [保留] |
| Ethash | Ethash | | | [保留] |

## 智能合約與程式語言

| 英文 | 譯名 | 不用 | 說明 | 狀態 |
|------|------|------|------|------|
| smart contract | 智能合約 | 智慧合約、智能合同 | | [固定] |
| Solidity / Vyper / Yul | 保留英文 | | | [保留] |
| compiler / compile | 編譯器／編譯 | | | [固定] |
| deploy / deployment | 部署 | | | [固定] |
| function | 函式 | | 程式的 function；數學上的「函數」照用 | [固定] |
| modifier | 修飾符 | 修飾器 | | [固定] |
| constructor | 建構子 | 構造函數、構造器 | | [固定] |
| fallback function | fallback 函式 | | | [固定] |
| receive function | receive 函式 | | | [固定] |
| visibility | 可見性 | | | [固定] |
| inheritance | 繼承 | | | [固定] |
| interface | 介面 | 接口 | | [固定] |
| library | 函式庫 | | Solidity 的 library 關鍵字保留英文 | [固定] |
| event | 事件 | | | [固定] |
| emit | 發出 | | | [固定] |
| revert | 回復 | 回滾 | 交易回復；2026-11-03 確認沿用 | [固定] |
| exception | 例外 | | 不要譯成「異常」 | [固定] |
| overflow / underflow | 溢位／下溢 | 溢出 | | [固定] |
| variable | 變數 | 變量 | | [固定] |
| storage | 儲存空間 | | 合約的永久儲存 | [固定] |
| memory | 記憶體 | 內存 | | [固定] |
| stack | 堆疊 | | | [固定] |
| bytecode | 位元組碼 | 字節碼 | | [固定] |
| runtime bytecode | 執行期位元組碼 | | | [固定] |
| opcode | 操作碼 | | 與比特幣書一致 | [固定] |
| ABI | ABI | | 應用程式二進位介面 | [保留] |
| precompiled contract | 預編譯合約 | | | [固定] |
| proxy contract | 代理合約 | | | [固定] |
| upgradeable contract | 可升級合約 | | | [固定] |
| delegatecall / selfdestruct 等指令 | 保留英文 | | | [保留] |
| EOF | EVM 物件格式（EOF） | | | [並列] |

## 程式設計通用詞（試譯第 8 章新增，2026-11-03 隨試譯審閱定案）

| 英文 | 譯名 | 不用 | 說明 | 狀態 |
|------|------|------|------|------|
| decorator | 裝飾器 | | Python 官方中文文件的譯法 | [固定] |
| inline assembly | 行內組合語言 | 內聯 | | [固定] |
| function overloading | 函式多載 | 重載 | | [固定] |
| type conversion / typecasting | 型別轉換 | 類型轉換 | | [固定] |
| type | 型別 | | 程式語言的資料型別；一般語境的「類型」照用 | [固定] |
| argument / parameter | 引數／參數 | | | [固定] |
| module | 模組 | 模塊 | | [固定] |
| scope | 作用域 | | | [固定] |
| state variable | 狀態變數 | | | [固定] |
| local variable | 區域變數 | 局部變量 | | [固定] |
| constant | 常數 | 常量 | | [固定] |
| immutable variable | 不可變變數 | | | [固定] |
| literal | 常值 | 字面量 | | [固定] |
| multiple inheritance | 多重繼承 | | | [固定] |
| polymorphism | 多型 | 多態 | | [固定] |
| object-oriented | 物件導向 | 面向對象 | | [固定] |
| composition | 組合 | | 相對於繼承 | [固定] |
| struct | 結構 | | Solidity／Vyper 的 struct 關鍵字保留英文 | [固定] |
| forward declaration | 前置宣告 | | | [固定] |
| shadow (a name) | 遮蔽 | | | [固定] |
| assertion / assert | 斷言 | | | [固定] |
| statement | 陳述式 | 語句 | | [固定] |
| clamp | 值域限制（clamp） | | Vyper 對數值上下限的強制檢查 | [並列] |
| bounds checking | 邊界檢查 | | | [固定] |
| auditability | 可審計性 | | | [固定] |
| reentrancy lock | 重入鎖 | | | [固定] |
| plug-in | 外掛 | 插件 | | [固定] |
| command line | 命令列 | 命令行 | | [固定] |
| optimization | 最佳化 | | | [固定] |
| framework | 框架 | | | [固定] |
| configuration | 組態 | | | [固定] |
| topic | topic | | 事件日誌的可搜尋欄位，保留英文 | [保留] |

## 安全

| 英文 | 譯名 | 不用 | 說明 | 狀態 |
|------|------|------|------|------|
| vulnerability | 漏洞 | | | [固定] |
| exploit | 漏洞利用 | | 名詞；動詞依語境 | [固定] |
| attack vector | 攻擊途徑 | | | [固定] |
| reentrancy | 重入 | | 重入攻擊 | [固定] |
| audit | 審計 | | 智能合約審計 | [固定] |
| access control | 存取控制 | 訪問控制 | | [固定] |
| denial of service (DoS) | 阻斷服務（DoS） | 拒絕服務 | | [並列] |
| price manipulation | 價格操縱 | | | [固定] |
| phishing | 網路釣魚 | | | [固定] |

## EVM

| 英文 | 譯名 | 不用 | 說明 | 狀態 |
|------|------|------|------|------|
| Ethereum Virtual Machine (EVM) | 以太坊虛擬機（EVM） | | | [並列] |
| program counter | 程式計數器 | | | [固定] |
| execution context | 執行環境 | | | [固定] |
| jump destination | 跳躍目的地 | | | [固定] |
| disassemble | 反組譯 | 反匯編 | | [固定] |

## 代幣與 DeFi

| 英文 | 譯名 | 不用 | 說明 | 狀態 |
|------|------|------|------|------|
| token | 代幣 | 令牌、通證 | | [固定] |
| fungible | 同質化 | | | [固定] |
| non-fungible token (NFT) | 非同質化代幣（NFT） | | | [並列] |
| token standard | 代幣標準 | | | [固定] |
| allowance / approve | 授權額度／授權 | | ERC-20 | [固定] |
| stablecoin | 穩定幣 | | | [固定] |
| decentralized finance (DeFi) | 去中心化金融（DeFi） | | | [並列] |
| decentralized exchange (DEX) | 去中心化交易所（DEX） | | | [並列] |
| automated market maker (AMM) | 自動造市商（AMM） | 自動做市商 | | [並列] |
| liquidity | 流動性 | | | [固定] |
| liquidity pool | 流動性池 | | | [固定] |
| liquidity provider (LP) | 流動性提供者（LP） | | | [並列] |
| lending protocol / lending market | 借貸協議／借貸市場 | | | [固定] |
| collateral | 抵押品 | | | [固定] |
| liquidation | 清算 | | | [固定] |
| flash loan | 閃電貸 | | | [固定] |
| yield | 收益 | | | [固定] |
| oracle | 預言機 | | | [固定] |
| governance token | 治理代幣 | | | [固定] |
| DAO | 去中心化自治組織（DAO） | | | [並列] |
| real-world asset (RWA) | 真實世界資產（RWA） | | | [並列] |
| TWAP | 時間加權平均價格（TWAP） | | | [並列] |

## Solidity 與程式設計（第 7 章抽取，2026-11-03 定案）

| 英文 | 譯名 | 不用 | 說明 | 狀態 |
|------|------|------|------|------|
| high-level language | 高階語言 | | | [固定] |
| life cycle | 生命週期 | | | [固定] |
| declarative / imperative programming | 宣告式／命令式程式設計 | | | [固定] |
| functional / procedural programming | 函數式／程序式程式設計 | | | [固定] |
| side effect | 副作用 | | | [固定] |
| source code | 原始碼 | 源代碼、源碼 | | [固定] |
| machine code | 機器碼 | | | [固定] |
| semantic versioning | 語意化版本 | | | [固定] |
| version pragma | 版本 pragma | | | [固定] |
| data type | 資料型別 | | | [固定] |
| boolean | 布林值 | | | [固定] |
| integer / fixed point | 整數／定點數 | | | [固定] |
| floating point | 浮點數 | | | [固定] |
| byte array | 位元組陣列 | | | [固定] |
| array | 陣列 | 數組 | | [固定] |
| dynamically sized array | 動態大小陣列 | | | [固定] |
| enum | 列舉 | 枚舉 | | [固定] |
| mapping | mapping | | Solidity 的 mapping 型別，保留英文；一般語境的 map 用「映射」 | [保留] |
| key / value | 鍵／值 | | | [固定] |
| global variable | 全域變數 | 全局變量 | | [固定] |
| persistent state | 持久狀態 | | | [固定] |
| public / internal / private / external | 公開／內部／私有／外部 | | 指可見性；程式碼中的關鍵字保留英文 | [固定] |
| payable / view / pure | 保留英文 | | Solidity 關鍵字 | [保留] |
| built-in function | 內建函式 | | | [固定] |
| return value | 回傳值 | 返回值 | | [固定] |
| function selector | 函式選擇器 | | | [固定] |
| function identifier | 函式識別碼 | | | [固定] |
| instance | 實例 | | | [固定] |
| derived contract | 衍生合約 | 派生合約 | 繼承其他合約的合約 | [固定] |
| C3 linearization | C3 線性化 | | | [固定] |
| proxy pattern | 代理模式 | | | [固定] |
| stub | 存根（stub） | | | [並列] |
| gate condition | 前置條件 | | 修飾符檢查的條件 | [固定] |
| error handling | 錯誤處理 | | | [固定] |
| raw call / delegatecall / staticcall | 原始呼叫／delegatecall／staticcall | | | [固定] |
| gas cost | gas 成本 | | | [固定] |
| best practices | 最佳實踐 | | | [固定] |
| zero address | 零地址 | | | [固定] |
| human-readable | 人類可讀 | | | [固定] |
| Yul / Huff / Fe | 保留英文 | | 程式語言名稱 | [保留] |

## 智能合約安全（第 9 章抽取，2026-11-03 定案）

| 英文 | 譯名 | 不用 | 說明 | 狀態 |
|------|------|------|------|------|
| antipattern | 反模式 | | | [固定] |
| defensive programming | 防禦式程式設計 | | | [固定] |
| code reuse | 程式碼重複使用 | 代碼復用 | | [固定] |
| code quality | 程式碼品質 | | | [固定] |
| test coverage | 測試覆蓋率 | | | [固定] |
| preventative technique | 預防技術 | | | [固定] |
| real-world example | 真實案例 | | 小節標題「Real-world example: …」譯「真實案例：……」 | [固定] |
| read-only reentrancy | 唯讀重入 | | | [固定] |
| entropy illusion | 熵的假象 | | | [固定] |
| unchecked return value | 未檢查的回傳值 | | | [固定] |
| race condition | 競爭條件 | 競態條件 | | [固定] |
| precision | 精度 | | | [固定] |
| inflation attack | 通膨攻擊 | | ERC-4626 | [固定] |
| input validation | 輸入驗證 | | | [固定] |
| arbitrary call | 任意呼叫 | | | [固定] |
| signature replay attack | 簽章重放攻擊 | | | [固定] |
| misconfiguration | 設定錯誤 | | | [固定] |
| malicious contract | 惡意合約 | | | [固定] |
| attacker / exploiter | 攻擊者 | | | [固定] |
| hack | 駭客攻擊 | 黑客 | 「被駭」也可 | [固定] |
| wad / ray | wad／ray | | 定點數的精度單位，保留英文 | [保留] |
| CTF | CTF | | Capture the Flag 資安競賽 | [保留] |

## EVM（第 14 章抽取，2026-11-03 定案）

| 英文 | 譯名 | 不用 | 說明 | 狀態 |
|------|------|------|------|------|
| virtual machine | 虛擬機 | | | [固定] |
| instruction set | 指令集 | | | [固定] |
| arithmetic / logic operations | 算術運算／邏輯運算 | | | [固定] |
| stack / process-flow / system / environmental / block operations | 堆疊／流程控制／系統／環境／區塊操作 | | 指令分類 | [固定] |
| quasi-Turing-complete | 準圖靈完備 | | | [固定] |
| stack-based architecture | 堆疊式架構 | | | [固定] |
| last in, first out (LIFO) | 後進先出（LIFO） | | | [並列] |
| parallelization | 平行化 | | | [固定] |
| ahead-of-time / just-in-time compilation | 預先編譯（AOT）／即時編譯（JIT） | | | [並列] |
| transaction-based state machine | 基於交易的狀態機 | | | [固定] |
| out of gas | gas 耗盡 | | | [固定] |
| gas accounting | gas 計算 | | | [固定] |
| gas target | gas 目標 | | EIP-1559 | [固定] |
| available gas / gas supply | 可用 gas | | 執行時剩餘的 gas | [固定] |
| state trie / transaction trie / receipt trie / storage trie | 狀態前綴樹／交易前綴樹／收據前綴樹／儲存前綴樹 | | | [固定] |
| transient storage | 暫時儲存空間 | | EIP-1153 | [固定] |
| call frame | 呼叫框架 | | | [固定] |
| initialization code / deployment code | 初始化程式碼／部署程式碼 | | | [固定] |
| deployment bytecode | 部署位元組碼 | | | [固定] |
| control flow / control flow graph | 控制流程／控制流程圖 | | | [固定] |
| dispatcher | 分派器 | | 依函式選擇器分派呼叫的程式碼 | [固定] |
| push / pop | 推入／彈出 | 壓入 | 堆疊操作；指令名稱 PUSH、POP 保留英文 | [固定] |
| leading zeros | 前導零 | | | [固定] |
| bit shift | 位移 | | | [固定] |
| JUMPDEST analysis | JUMPDEST 分析 | | | [固定] |
| code introspection | 程式碼自省 | | | [固定] |
| code section / data section | 程式碼區段／資料區段 | | EOF | [固定] |
| return stack | 回傳堆疊 | | EOF | [固定] |
| legacy EVM | 舊版 EVM | | 相對於 EOF | [固定] |
| stack too deep | stack too deep | | Solidity 編譯錯誤訊息，保留英文 | [保留] |
| deprecate | 棄用 | | | [固定] |
| concrete implementation | 具體實作 | | | [固定] |
| delegation designation | 委託指定 | | EIP-7702 | [固定] |
| enshrined PBS (ePBS) | 內建的提議者與建構者分離（ePBS） | | | [並列] |
| cryptographic witness | 密碼學見證 | | 無狀態以太坊 | [固定] |
| Heimdall / Ethersplay / revm / evmone 等工具 | 保留英文 | | | [保留] |

## 金融與 DeFi 用語（試譯第 13 章新增，2026-11-03 隨試譯審閱定案）

| 英文 | 譯名 | 不用 | 說明 | 狀態 |
|------|------|------|------|------|
| cryptocurrency | 加密貨幣 | | | [固定] |
| crypto asset | 加密資產 | | | [固定] |
| traditional finance (TradFi) | 傳統金融（TradFi） | | | [並列] |
| fiat currency | 法定貨幣 | | 複合詞可用「法幣」，例如法幣抵押型穩定幣 | [固定] |
| financial inclusion | 普惠金融 | | | [固定] |
| underbanked / unbanked | 銀行服務不足／沒有銀行帳戶 | | | [固定] |
| overcollateralize / overcollateralization | 超額抵押 | | | [固定] |
| collateralization ratio | 抵押率 | | | [固定] |
| creditworthiness | 信用 | | 評估信用 | [固定] |
| arbitrage / arbitrageur | 套利／套利者 | | | [固定] |
| collateral swap | 抵押品置換 | | | [固定] |
| DeFi primitive | 基本元件 | | | [固定] |
| acceptability | 接受度 | | | [固定] |
| peg / depeg | 掛鉤／脫鉤 | 錨定 | 穩定幣與標的價格的連動 | [固定] |
| order book | 訂單簿 | | | [固定] |
| market depth | 市場深度 | | | [固定] |
| market maker | 造市商 | 做市商 | | [固定] |
| impermanent loss | 無常損失 | | | [並列] |
| slippage | 滑價 | 滑點 | | [並列] |
| swap | 兌換 | | 代幣兌換 | [並列] |
| constant product formula | 恆定乘積公式 | | | [固定] |
| reserves | 儲備 | | 池中的代幣存量 | [固定] |
| lending pool | 借貸池 | | | [固定] |
| lender / borrower | 出借人／借款人 | | | [固定] |
| default | 違約 | | | [固定] |
| bad debt | 呆帳 | 壞賬 | | [固定] |
| solvency / solvent | 償付能力 | | | [固定] |
| incentive / incentivize | 誘因／提供誘因 | | | [固定] |
| game theory | 賽局理論 | 博弈論 | | [固定] |
| composability | 可組合性 | | | [固定] |
| shorting / short position | 放空／空頭部位 | 做空、頭寸 | | [並列] |
| longing | 做多 | | | [固定] |
| leverage | 槓桿 | | | [固定] |
| position | 部位 | 頭寸 | | [固定] |
| taxable event | 應稅事件 | | | [固定] |
| capital efficiency | 資本效率 | | | [固定] |
| flash-loan attack | 閃電貸攻擊 | | | [固定] |
| pseudorandom | 偽隨機 | | | [固定] |
| deterministic | 確定性 | | | [固定] |
| single point of failure | 單點故障 | | | [固定] |
| reserve asset | 準備資產 | | | [固定] |
| fiat-collateralized / crypto-collateralized stablecoin | 法幣抵押型／加密資產抵押型穩定幣 | | | [固定] |
| algorithmic stablecoin | 演算法穩定幣 | | | [固定] |
| custodian / custody | 託管機構／託管 | | | [固定] |
| mint / burn | 鑄造／銷毀 | | | [固定] |
| market cap | 市值 | | | [並列] |
| product-market fit | 產品市場契合 | | | [固定] |
| derivative / derivative token | 衍生品／衍生代幣 | | | [固定] |
| systemic risk | 系統性風險 | | | [固定] |
| tokenization | 代幣化 | | | [固定] |
| fractionalization | 分割持有 | | | [固定] |
| risk-free rate | 無風險利率 | | | [固定] |
| trustless | 免信任 | | | [固定] |
| immutable | 不可竄改／不可變更 | | 資料與紀錄用「不可竄改」；已部署的合約、程式碼用「不可變更」 | [固定] |
| omnichain protocol | 全鏈協議 | | 也就是跨鏈訊息協議 | [並列] |
| interoperability | 互通性 | 互操作性 | | [固定] |
| wrapped token | 包裝代幣 | | | [固定] |
| lock and mint | 鎖定與鑄造 | | | [固定] |
| vampire attack | 吸血鬼攻擊 | | | [固定] |
| regulator / regulation | 監管機關／監管 | | | [固定] |
| cypherpunk / cryptopunk | 密碼龐克 | | | [固定] |
| Binance Smart Chain (BSC) | 幣安智能鏈（BSC） | | | [並列] |

## 去中心化應用

| 英文 | 譯名 | 不用 | 說明 | 狀態 |
|------|------|------|------|------|
| decentralized application (DApp) | 去中心化應用（DApp） | | | [並列] |
| frontend / backend | 前端／後端 | | | [固定] |
| IPFS / ENS | IPFS／以太坊域名服務（ENS） | | | [並列] |
| Web3 | Web3 | | | [保留] |
| Foundry / Hardhat / Remix / ethers.js / viem 等工具 | 保留英文 | | | [保留] |

## 擴容

| 英文 | 譯名 | 不用 | 說明 | 狀態 |
|------|------|------|------|------|
| scaling | 擴容 | | | [固定] |
| scalability | 可擴展性 | | | [固定] |
| layer 1 (L1) | 第一層（L1） | | | [並列] |
| layer 2 (L2) | 第二層（L2） | | | [並列] |
| rollup | rollup | | | [保留] |
| optimistic rollup | 樂觀 rollup | | | [固定] |
| ZK rollup | ZK rollup | | | [保留] |
| sequencer | 排序器 | | | [固定] |
| fraud proof | 詐欺證明 | 欺詐證明 | | [固定] |
| validity proof | 有效性證明 | | | [固定] |
| data availability (DA) | 資料可用性（DA） | 數據可用性 | | [並列] |
| data availability sampling (DAS) | 資料可用性抽樣（DAS） | | | [並列] |
| sharding | 分片 | | | [固定] |
| Danksharding / proto-danksharding | 保留英文 | | | [保留] |
| state channel | 狀態通道 | | | [固定] |
| sidechain | 側鏈 | | | [固定] |
| Plasma | Plasma | | | [保留] |
| bridge | 跨鏈橋 | | | [固定] |
| cross-chain | 跨鏈 | | | [固定] |
| Verkle tree | Verkle 樹 | | | [固定] |

## 零知識證明

| 英文 | 譯名 | 不用 | 說明 | 狀態 |
|------|------|------|------|------|
| zero-knowledge proof (ZKP) | 零知識證明 | | | [並列] |
| prover | 證明方 | 證明者 | 與 verifier 成對；不用「證明者」以免與 validator 的「驗證者」混淆 | [固定] |
| verifier | 驗證方 | | 不要譯成「驗證者」（那是 validator） | [固定] |
| witness | 見證 | | 與比特幣書一致 | [固定] |
| interactive / noninteractive | 互動式／非互動式 | 交互式 | | [固定] |
| SNARK / STARK / zk-SNARK | 保留英文 | | | [保留] |
| zk-EVM / zkVM | 保留英文 | | | [保留] |
| Fiat-Shamir heuristic | Fiat-Shamir 啟發法 | | | [固定] |
| partition problem | 分割問題 | | | [固定] |
| arithmetic circuit | 算術電路 | | | [固定] |
| constraint | 約束 | | | [固定] |

## 資料結構

| 英文 | 譯名 | 不用 | 說明 | 狀態 |
|------|------|------|------|------|
| Merkle tree | 默克爾樹 | 梅克爾樹 | 與比特幣書一致 | [固定] |
| Merkle root | 默克爾根 | | | [固定] |
| Merkle proof | 默克爾證明 | | | [固定] |
| trie | 前綴樹 | | | [並列] |
| Merkle Patricia trie (MPT) | 默克爾帕特里夏前綴樹（MPT） | | | [並列] |
