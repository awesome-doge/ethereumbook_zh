# 第 3 章　以太坊節點

以太坊節點是一個軟體應用程式，它實作以太坊規格，並透過點對點（P2P）網路與其他以太坊節點通訊。

起初，一個節點只要執行單一客戶端，就能完整實作成為以太坊生態系一員的所有要求。2022 年 9 月 15 日，合併（The Merge）硬分叉發生，把共識協議從基於工作量證明（proof of work，PoW）的機制，改成 Gasper 這個新的、基於權益證明（proof of stake，PoS）的共識協議。這也帶來了關注點的分離，讓共識與執行各自獨立，並催生了一種新的以太坊客戶端：共識層客戶端。

因此，在本書寫作時，一個以太坊節點必須同時執行兩套軟體，才能與最新的規格相容，如圖 3-1 所示。兩者的定義如下：

**共識層客戶端**

這套新軟體現在負責共識協議，讓所有節點對區塊鏈的單一歷史達成一致。

**執行層客戶端**

這套軟體專注於接收網路上發生的所有區塊與交易，在以太坊虛擬機（EVM）中執行它們，並驗證其正確性。

![圖 3-1. 以太坊節點的架構](./images/ch3/maet_0301.png)

不同的以太坊客戶端，無論是執行層還是共識層客戶端，只要遵循參考規格與標準化的通訊協議，就能互相協作。雖然這些客戶端由不同的團隊、用不同的程式語言實作，但它們都「說」同一種協議、遵守同一套規則。因此，它們都可以用來運作同一個以太坊網路，並與之互動。

以太坊是一個開源專案，所有主要客戶端的原始碼都以開源授權（例如 LGPL v3.0）釋出，可以免費下載，並用於任何用途。不過，開源的意義不只是免費使用。它也代表以太坊是由開放的志願者社群開發，任何人都可以修改。看的人越多，程式碼就越值得信任。

以太坊最初是由一份稱為「黃皮書」（Yellow Paper）的正式規格所定義，作者是本書原始的共同作者之一 Gavin Wood。雖然隨著以太坊的重大變更，這份規格也會定期更新，但現在已經清楚地朝向兩套不同的參考實作發展：一套給執行層客戶端，一套給共識層客戶端。這些參考實作以 Python 撰寫，優先考量的是可讀性與簡潔。

> **備註**  
>
> 這些規格並不是要作為完整節點的實作。它們的角色是可執行的虛擬碼規格。

這與比特幣形成對比；例如，比特幣並沒有以任何正式的方式定義。比特幣的「規格」就是參考實作 Bitcoin Core，而以太坊的執行規格則記載於一份論文中，這份論文結合了英文的規格與數學的（正式）規格。這份正式規格，加上各種以太坊改進提案（Ethereum Improvement Proposal，EIP），以及以 Python 撰寫的新共識規格，共同定義了以太坊節點的標準行為。

由於以太坊有清楚的正式規格，以太坊客戶端有許多獨立開發、卻能互相協作的軟體實作。以太坊網路上運作的實作，比其他任何區塊鏈都更多樣，一般認為這是件好事。事實上，這已經證明是抵禦網路攻擊的絕佳方式：例如，針對某個客戶端實作策略的漏洞利用，只會讓該客戶端的開發者忙著修補漏洞，其他客戶端則讓網路繼續運作，幾乎不受影響。

## 以太坊網路

現有各式各樣基於以太坊的網路，它們大致符合最初的以太坊「黃皮書」所定義的正式規格，但彼此之間不一定能互相協作。

有幾條與 EVM 相容的鏈，例如 Ethereum Classic、BNB Chain 與 Polygon，共用大部分的執行規格，不過其中許多在共識與參數上有所不同。雖然它們在協議層級大多相容，但這些網路常有一些功能或特性，需要以太坊客戶端軟體的維護者做些小修改，才能支援各個網路。正因如此，並不是每個版本的以太坊客戶端軟體，都能執行每一條基於以太坊的區塊鏈。

截至 2025 年 6 月，以太坊執行協議有五個主要實作，以四種不同的語言撰寫；以太坊共識協議則有五個實作，以五種不同的語言撰寫：

執行層客戶端有：

- Geth，以 Go 撰寫
- Nethermind，以 C# 撰寫
- Besu，以 Java 撰寫
- Erigon，以 Go 撰寫
- Reth，以 Rust 撰寫

共識層客戶端有：

- Lighthouse，以 Rust 撰寫
- Lodestar，以 TypeScript 撰寫
- Nimbus，以 Nim 撰寫
- Prysm，以 Go 撰寫
- Teku，以 Java 撰寫

在本節中，我們會介紹下列兩個執行層客戶端：

**Geth**

歷史最久、使用最廣的執行層客戶端，由以太坊基金會維護

**Reth**

在 Parity/OpenEthereum 停止開發後，由 Paradigm 打造、以 Rust 撰寫的新執行層客戶端

我們也會介紹下列兩個共識層客戶端：

**Prysm**

第一個共識層客戶端，現在由 Offchain Labs 維護

**Lighthouse**

使用最多的共識層客戶端，由 Sigma Prime 維護

我們會示範如何用每個客戶端架設節點。具體來說，我們會使用 Geth-Prysm 與 Reth-Lighthouse 這兩種組合，並探索它們的一些命令列選項與 API。

> **備註**  
>
> 這兩種組合只是範例；你可以任意組合自己最喜歡的執行層客戶端與共識層客戶端，來執行以太坊節點。

## 我該執行完整節點嗎？

區塊鏈的健全、韌性與抗審查性，取決於是否有許多獨立運作、在地理上分散的完整節點；所謂完整節點，就是下載整條區塊鏈、並無限期保存資料的節點。每個完整節點都能幫助其他新節點取得區塊資料，讓它們開始運作；也能讓節點的營運者對所有交易與合約進行權威、獨立的驗證。

> **備註**
>
> 嚴格來說，這些節點之間是有區別的：  
>
> **封存節點**  
> 無限期保存所有資料的以太坊節點  
>
> **完整節點**  
> 會丟棄歷史狀態與交易收據的以太坊節點，通常是你啟動節點時的預設選項

不過，執行完整節點需要付出硬體資源與頻寬的成本。完整節點至少必須下載 2 TB 的資料（截至 2025 年 6 月，依客戶端的組態而定），並儲存在本機硬碟上。隨著新交易與新區塊不斷加入，這份資料負擔每天都增加得相當快。我們會在稍後的「完整節點的硬體需求」一節更詳細地討論這個主題。

以太坊開發並不需要在實際運作的主網上執行完整節點。你需要做的事情，幾乎都可以透過測試網路節點（讓你連上其中一條規模較小的公開測試區塊鏈）、像 Anvil 這樣的本機私有區塊鏈，或是 Infura、Alchemy 這類服務供應商代管的節點 API 來完成。

你也可以選擇執行遠端客戶端（remote client），它不會在本機儲存區塊鏈的副本，也不會驗證區塊與交易。這類客戶端提供錢包的功能，可以建立並廣播交易。遠端客戶端可以用來連上現有的網路，例如你自己的完整節點、公開區塊鏈、公開的或需許可的權威證明（proof of authority）測試網路，或是本機的私有區塊鏈。實務上，你很可能會使用 MetaMask、Rabby Wallet 或 Coinbase Wallet 這類遠端客戶端，以便在各種節點選項之間輕鬆切換。

遠端客戶端與錢包這兩個詞經常混用，不過兩者還是有些差異。通常，遠端客戶端除了提供錢包的交易功能外，還會提供 API（例如 web3.js API）。

不要把以太坊中遠端客戶端的概念與輕客戶端混為一談（輕客戶端類似比特幣的簡化支付驗證（Simplified Payment Verification，SPV）客戶端）。輕客戶端會驗證區塊頭，並使用默克爾證明來驗證交易是否已包含在區塊鏈中、判斷交易的效果，因此能達到與完整節點相近的安全等級。相反地，以太坊的遠端客戶端不會驗證區塊頭或交易。它們完全信任某個完整節點來存取區塊鏈，因此喪失了相當程度的安全性與匿名性保障。你可以使用自己執行的完整節點，來減輕這些問題。

### 完整節點的優點與缺點

選擇執行完整節點，對你所連接的網路的運作有幫助，但你也得付出一些輕微到中等的成本。我們來看看它的一些優點與缺點。

**優點**：

- 支持基於以太坊的網路的韌性與抗審查性
- 以權威的方式驗證所有交易
- 可以不經過中介，與公開區塊鏈上的任何合約互動
- 可以不經過中介，直接把合約部署到公開區塊鏈上
- 可以離線查詢（唯讀）區塊鏈的狀態（帳戶、合約等）
- 可以查詢區塊鏈，而不讓第三方知道你在讀取哪些資訊

**缺點**：

- 需要大量而且持續增加的硬體與頻寬資源
- 第一次啟動時，可能需要好幾天才能完整同步
- 必須持續維護、升級並保持上線，才能維持同步

### 公開測試網路的優點與缺點

無論你是否選擇執行完整節點，你大概都會想執行一個公開測試網路節點。我們來看看使用公開測試網路的一些優點與缺點。

**優點：**

- 測試網路節點需要同步與儲存的資料少得多，依網路而定，大約 100 到 300 GB（截至 2025 年 6 月）。
- 測試網路節點只要幾個小時就能完整同步。
- 部署合約或發送交易需要測試用的以太幣（ether），它沒有價值，可以從好幾個「水龍頭」免費取得。
- 測試網路是公開區塊鏈，上面有許多其他使用者與合約，處於「實際」運作中。

**缺點：**

- 你不能在測試網路上使用「真正的」錢；它使用的是測試用的以太幣。因此，你無法針對真正的對手測試安全性，因為沒有任何利害關係。
- 公開區塊鏈的某些面向，無法在測試網路上真實地測試。例如，交易手續費雖然是發送交易所必需，但在測試網路上並不是需要考量的因素，因為 gas 是免費的（也就是說，測試網路的 ETH 沒有任何真正的經濟價值）。此外，測試網路也不會像公開主網有時那樣遇到網路壅塞。
- 有些測試網路是為特定目的而設計的，可能與以太坊主網略有不同。

### 本機區塊鏈模擬的優點與缺點

就許多測試目的而言，最好的選擇是啟動一個單一實例的私有區塊鏈。Anvil 是最受歡迎的本機區塊鏈模擬工具之一，你可以在沒有任何其他參與者的情況下執行它並與它互動。

**優點：**

- 不需要同步，磁碟上幾乎沒有資料；第一個區塊由你自己產生。
- 不需要取得測試用的以太幣；你可以把區塊獎勵「頒發」給自己，拿來做測試。
- 沒有其他使用者，只有你。
- 沒有其他合約，只有你啟動後自己部署的合約。

**缺點：**

- 沒有其他使用者，代表你的本機鏈的行為與公開區塊鏈不同。不會有人競爭交易空間，也沒有交易排序的問題。
- 除了你之外沒有其他區塊產生者，代表區塊的產生更容易預測；因此，有些在公開區塊鏈上會發生的情境，你沒辦法測試。不過，Anvil（以及 Hardhat 等其他工具）讓你設定區塊產生模式，盡量重現類似主網的行為，但這終究和身處以太坊主網上不一樣。
- 沒有其他合約，代表你必須部署所有想要測試的東西，包括相依套件與合約函式庫。幸好，Anvil 這類工具讓你可以在任意區塊分叉以太坊主網，在類似主網的狀態下試驗你的智能合約。

## 執行以太坊節點

如果你有時間和資源，應該試著執行一個完整節點，即使只是為了更了解整個過程也好。本節會介紹如何下載、編譯並執行 Geth-Prysm 與 Reth-Lighthouse 這兩組以太坊客戶端。這需要你對作業系統的命令列介面（CLI）有些熟悉。無論你選擇把這些客戶端當作完整節點、測試網路節點，還是本機私有區塊鏈的客戶端來執行，都值得安裝它們。

### 完整節點的硬體需求

開始之前，你應該先確定自己的電腦有足夠的資源來執行以太坊完整節點。你需要至少 2 TB 的磁碟空間，來儲存以太坊區塊鏈的完整副本。如果你也想在以太坊測試網路上執行完整節點，還需要至少額外的 100 到 400 GB。下載 2 TB 的區塊鏈資料可能要花很長的時間，所以建議你使用高速的網際網路連線。

同步以太坊區塊鏈需要非常大量的輸入／輸出（I/O）。最好使用固態硬碟（SSD）。如果你使用的是傳統機械硬碟（HDD），至少需要 8 GB 的 RAM 作為快取。否則，你可能會發現系統速度太慢，跟不上進度，無法完整同步。

以下是同步一份基於以太坊的區塊鏈完整副本的最低需求摘要：

- 2 核心以上的 CPU
- 至少 2 TB 的可用儲存空間
- 使用 SSD 時至少 8 GB RAM，使用 HDD 時則需 8 GB 以上（強烈建議使用 SSD）
- 7 Mbps 以上的網路下載速度

如果你想在合理的時間內完成同步，並儲存本書討論的所有開發工具、函式庫、客戶端與區塊鏈，你會需要一臺效能更好的電腦。以下是我們建議的規格：

- 4 核心以上的高速 CPU（時脈比核心數更重要）
- 16 GB 以上的 RAM
- 至少有 2 TB 可用空間的高速 NVMe SSD
- 24 Mbps 以上的網路下載速度
	
我們很難預測區塊鏈的大小會成長得多快、什麼時候會需要更多磁碟空間，所以建議你在開始同步之前，先查一下區塊鏈最新的大小。

> **備註**
>
> 這裡列出的磁碟大小需求，是假設你以預設設定執行節點，也就是會從區塊鏈中「修剪」（prune）掉舊的狀態資料。如果你改為執行完整的「封存」節點，把所有狀態都保留在磁碟上，依客戶端而定，很可能需要超過 2 TB（最多可達 12 至 15 TB）的磁碟空間。執行節點之前，務必到客戶端的官方網站查閱最新的硬體需求。

### 建置與執行客戶端的軟體需求

本節涵蓋 Geth-Prysm 與 Reth-Lighthouse 客戶端軟體，並假設你使用的是類 Unix 的命令列環境。範例顯示的指令與輸出，是在 macOS 上執行 Bash shell（命令列執行環境）時的樣子。這些步驟在大多數 Linux 發行版上不需修改就能使用。Windows 使用者可以使用 Windows Subsystem for Linux（WSL2）。

> **提示**
>
> 本章的許多範例都會使用作業系統的 CLI（也稱為 shell），透過終端機應用程式來操作。shell 會顯示一個提示字元；你輸入指令後，shell 會回應一些文字，並顯示新的提示字元，等待你輸入下一個指令。你系統上的提示字元可能長得不一樣，但在以下的範例中，它以 $ 符號表示。在範例中，當你看到 $ 符號後面的文字時，不要輸入 $ 符號，而是輸入緊接在它後面的指令（以粗體顯示），然後按下 Enter 執行指令。在範例中，每個指令下方的幾行，是作業系統對該指令的回應。當你看到下一個 $ 前綴時，就知道這是一個新的指令，應該重複同樣的步驟。

開始之前，你可能需要安裝一些軟體。如果你從沒在目前使用的電腦上做過任何軟體開發，大概需要安裝一些基本工具。在接下來的範例中，你需要安裝原始碼管理系統 git；Go 程式語言與其標準函式庫 golang；以及系統程式語言 Rust。

以下是本範例會用到的四個客戶端的文件頁面：

- [Geth](https://oreil.ly/zYviP)
- [Prysm](https://oreil.ly/9-2FC)
- [Reth](https://oreil.ly/KDmMt)
- [Lighthouse](https://oreil.ly/RRpAs)

歡迎參考這些網站，進一步了解各客戶端的架構細節，或在安裝時排除問題。

### 準備階段

從你的家目錄開始，在電腦上建立一個名為 *ethereum-node1* 的資料夾，再在其中建立兩個子資料夾，分別名為 *execution* 與 *consensus*：

```bash
$ mkdir ethereum-node1
$ cd ethereum-node1
$ mkdir execution
$ mkdir consensus
```

現在你的資料夾結構應該像這樣：

```bash
ethereum-node1
├── consensus
└── execution
```

用一個名為 *ethereum-node2* 的新資料夾，重複上一個步驟：

```bash
$ cd .. # this command is used to go back to your home directory
$ mkdir ethereum-node2
$ cd ethereum-node2
$ mkdir execution
$ mkdir consensus
```

最後，你應該會有 *ethereum-node1* 與 *ethereum-node2* 兩個根資料夾，每個根資料夾裡各有兩個子資料夾：*execution* 與 *consensus*。

你也需要安裝 [Go](https://golang.org/) 與 [Rust](https://www.rust-lang.org/)。可以到它們的官方網站查看安裝指南。

### Geth-Prysm

進入剛建立的 *ethereum-node1* 資料夾：

```bash
$ cd ethereum-node1
```

#### Geth

首先，我們要從原始碼建置並安裝 Geth。Geth 是以 Go 語言實作的執行規格，由以太坊基金會積極開發，因此被視為以太坊客戶端的「官方」實作。一般來說，每條基於以太坊的區塊鏈都會有自己的 Geth 實作。如果你要執行 Geth，請務必透過下列其中一個儲存庫連結，取得適合你的區塊鏈的正確版本：

- [以太坊](https://oreil.ly/qzK-O)
- [BNB Chain](https://oreil.ly/tGtL3)
- [Polygon PoS](https://oreil.ly/ZWhh3)

> **備註**
>
> 你可以跳過這些步驟，直接安裝適用於你所選平台的預先編譯執行檔。預先編譯的版本安裝起來容易得多，可以在上面列出的任何一個儲存庫的「releases」區段找到。不過，自己下載並編譯軟體，或許能學到更多。

**複製儲存庫**。第一步是複製（clone）Git 儲存庫，取得一份原始碼。要在本機複製你選擇的儲存庫，請在 execution 子資料夾中，如下使用 git 指令：

```bash
$ cd execution
$ git clone https://github.com/ethereum/go-ethereum.git
```

在儲存庫複製到你的本機系統時，你應該會看到進度報告：

```bash
Cloning into 'go-ethereum'...
remote: Enumerating objects: 130745, done.
remote: Counting objects: 100% (11/11), done.
remote: Compressing objects: 100% (11/11), done.
remote: Total 130745 (delta 1), reused 6 (delta 0), pack-reused 130734
Receiving objects: 100% (130745/130745), 204.15 MiB | 6.13 MiB/s, done.
Resolving deltas: 100% (80729/80729), done.
```

太好了！現在你在本機有了一份 Geth，可以為你的平台編譯出執行檔了。

**從原始碼建置 Geth**。要建置 Geth，請切換到原始碼下載所在的目錄，選定最新的版本後，使用 make 指令。目前最新的版本是 v1.14.3，不過你隨時可以查看最新的版本：

```bash
$ cd go-ethereum
$ git checkout v1.14.3
$ make geth
```

如果一切順利，你會看到 Go 編譯器逐一建置每個元件，最後產生 Geth 執行檔：

```bash
go run build/ci.go install ./cmd/geth
go: downloading golang.org/x/crypto v0.22.0
go: downloading golang.org/x/net v0.24.0
[...]
github.com/ethereum/go-ethereum/cmd/utils
github.com/ethereum/go-ethereum/beacon/blsync
github.com/ethereum/go-ethereum/cmd/geth
Done building.
Run "./build/bin/geth" to launch geth.
```

我們先在不實際啟動 Geth 的情況下，確認它能正常運作：

```bash
$ ./build/bin/geth version

GethVersion: 1.14.3-stable
Git Commit: ab48ba42f4f34873d65fd1737fabac5c680baff6
Architecture: arm64
Go Version: go1.22.2
Operating System: darwin
[...]
```

你的 `geth version` 指令顯示的資訊可能略有不同，但應該會看到和這裡很像的版本報告。

先不要執行 Geth，因為我們還需要安裝共識層客戶端，才能讓以太坊節點同步到鏈的最前端。

#### Prysm

現在輪到共識層客戶端了。Prysm 是以 Go 語言實作的共識規格，由 Offchain Labs 積極開發。合併之後，它起初是遙遙領先、使用最多的共識層客戶端。如今，多虧社群為了提升客戶端多樣性（client diversity）所付出的大量努力，它的市占率已經大幅下降，目前為 37%。

**安裝執行檔**。Prysm 可以像 Geth 那樣從原始碼建置，但會稍微複雜一些。建議的安裝方式如下。首先，進入 *consensus* 資料夾：

```bash
$ cd ../.. # this command is used to go back in the ethereum-node1 folder
$ cd consensus
```

接著，執行下列指令：

```bash
$ curl https://raw.githubusercontent.com/prysmaticlabs/prysm/master/prysm.sh --output prysm.sh && chmod +x prysm.sh
```

**產生 JWT 共用祕密**（JWT secret）。組成以太坊節點的執行層客戶端與共識層客戶端是兩套不同的軟體，但它們必須隨時互相溝通。為了做到這一點，執行層客戶端與共識層客戶端會共用一種類似密碼的東西，用來驗證彼此之間的連線。現在我們要把它產生出來：

```bash
$ ./prysm.sh beacon-chain generate-auth-secret
```

這時應該會出現一個 *jwt.hex* 檔案。我們把它移到上一層資料夾：

```bash
$ mv jwt.hex ../jwt.hex
```

#### 執行節點

現在你已經有了執行層客戶端與共識層客戶端，也正確產生了 JWT 共用祕密，就可以啟動這兩個客戶端，讓以太坊完整節點運作起來。

**執行執行層客戶端**。首先，你需要執行執行層客戶端 Geth。回到 *execution* 資料夾，執行這個指令：

```bash
$ cd .. # this command is used to go back in the ethereum-node1 folder
$ cd execution
$ ./go-ethereum/build/bin/geth --mainnet \
	--http \
	--http.api eth,net,engine,admin,web3 \
	--authrpc.jwtsecret=../jwt.hex
```

如果你看到類似這樣的輸出，就表示一切運作正常：

```bash
INFO [06-08|17:56:38.738] Starting Geth on Ethereum mainnet...
INFO [06-08|17:56:38.738] Bumping default cache on mainnet         provided=1024 updated=4096
INFO [06-08|17:56:38.740] Maximum peer count                       ETH=50 total=50
INFO [06-08|17:56:38.745] Set global gas cap                       cap=50,000,000
INFO [06-08|17:56:38.752] Initializing the KZG library             backend=gokzg
INFO [06-08|17:56:38.771] Allocated trie memory caches             clean=614.00MiB dirty=1024.00MiB
INFO [06-08|17:56:38.772] Using pebble as the backing database…
```

**執行共識層客戶端**。現在你應該執行共識層客戶端 Prysm。不要關閉執行層客戶端所在的終端機分頁。只要開啟新的終端機視窗或分頁，切換到 *consensus* 資料夾：

```bash
$ cd ethereum-node1
$ cd consensus
$ ./prysm.sh beacon-chain \
	--execution-endpoint=http://localhost:8551 \
	--mainnet \
	--jwt-secret=../jwt.hex \
	--checkpoint-sync-url=https://beaconstate.info \
	--genesis-beacon-api-url=https://beaconstate.info
```

你可能會被要求接受 Prysm 的使用條款。如果是這樣，請輸入 **accept**，就完成了：

```bash
Prysm Terms of Use
By downloading, accessing or using the Prysm implementation (“Prysm”), you (referenced
herein as “you” or the “user”) certify that you have read and agreed to the terms and
conditions below.
TERMS AND CONDITIONS: https://github.com/prysmaticlabs/prysm/blob/develop/TERMS_OF_SERVICE.md
Type “accept” to accept this terms and conditions [accept/decline]: (default: decline):
```

這樣就完成了！你應該會看到執行層客戶端與共識層客戶端都開始在終端機上記錄大量資料。

執行層客戶端：

```bash
INFO [06-08|18:08:49.039] Forkchoice requested sync to new head    number=20,048,206 hash=8df21a..4afb49 finalized=unknown
INFO [06-08|18:08:52.507] Syncing beacon headers                   downloaded=322,560 left=19,725,577 eta=42m4.183s
INFO [06-08|18:08:57.515] Looking for peers                        peercount=1 tried=42 static=0
INFO [06-08|18:09:00.508] Syncing beacon headers                   downloaded=370,688 left=19,677,449 eta=43m35.827s
INFO [06-08|18:09:01.637] Forkchoice requested sync to new head    number=20,048,207 hash=d99dab..0293c9 finalized=unknown
```

共識層客戶端：

```bash
[2024-06-08 18:09:24]  INFO blockchain: Called new payload with optimistic block payloadBlockHash=0xd44520a09a7a slot=9253245
[2024-06-08 18:09:24]  INFO blockchain: Called fork choice updated with optimistic block finalizedPayloadBlockHash=0x38916be8a559 headPayloadBlockHash=0xd44520a09a7a headSlot=9253245
[2024-06-08 18:09:24]  INFO blockchain: Synced new block block=0xec930e7c... epoch=289163finalizedEpoch=289161 finalizedRoot=0xb8065a78... slot=9253245
[2024-06-08 18:09:24]  INFO blockchain: Finished applying state transition attestations=123 payloadHash=0xd44520a09a7a slot=9253245 syncBitsCount=510 txCount=212
[2024-06-08 18:09:24]  INFO p2p: Peer summary activePeers=64 inbound=0 outbound=63
[2024-06-08 18:09:28]  INFO sync: Subscribed to topic=/eth2/6a95a1a9/beacon_attestation_35/ssz_snappy[2024-06-08 18:09:36]  INFO blockchain: Called new payload with optimistic block payloadBlockHash=0xff879102f29e slot=9253246
```

現在你有了一個以太坊完整節點，正在同步到鏈的最前端。請注意，同步可能要花很多時間（依你的硬體與網路連線而定，可能需要幾個小時或幾天）。

> **備註**
>
> 如果你想進一步了解本範例中使用的指令與 CLI 旗標，[Geth](https://oreil.ly/zYviP) 與 [Prysm](https://oreil.ly/4sn6-) 的官方文件是最好的參考資料。

### Reth-Lighthouse

我們用兩個不同的客戶端再做一次同樣的事：以 Reth 作為執行層客戶端，以 Lighthouse 作為共識層客戶端。

#### Reth

首先，你需要安裝 Reth。進入 *ethereum-node2* 資料夾，再進入 execution 資料夾。

**複製儲存庫**。第一步是複製 Git 儲存庫，取得一份原始碼。回到你的家目錄，輸入下列指令：

```bash
$ cd ethereum-node2
$ cd execution
$ git clone https://github.com/paradigmxyz/reth
```

太好了！現在你在本機有了一份 Reth，可以為你的平台編譯出執行檔了。

**從原始碼建置 Reth**。要建置 Reth，你需要執行下列指令：

```bash
$ cd reth
$ cargo install --locked --path bin/reth --bin reth
```

安裝可能要花超過 10 分鐘才能完成。完成後，你可以執行下列指令，檢查 Reth 是否已正確安裝：

```bash
$ reth --version
```

你應該會看到類似下面的內容（版本可能不同）：

```bash
reth Version: 0.2.0-beta.6-dev
Commit SHA: ac29b4b73
Build Timestamp: 2024-04-22T17:29:01.000000000Z
Build Features: jemallocBuild Profile: maxperf+
```

#### Lighthouse

現在你需要安裝共識層客戶端 Lighthouse。回到 *ethereum-node2* 資料夾，再進入 *consensus* 資料夾：[^tn1]

[^tn1]: 譯註：前面建置 Reth 時執行過 `cd reth`，此時所在的目錄是 *ethereum-node2/execution/reth*。下面的 `cd ..` 只會回到 *ethereum-node2/execution*，而不是註解所說的 *ethereum-node2*，接著的 `cd consensus` 會找不到資料夾。要回到 *ethereum-node2*，應該執行 `cd ../..`（如同 Geth-Prysm 一節安裝 Prysm 前的做法）。

```bash
$ cd .. # this command is used to go back in the ethereum-node2 folder
$ cd consensus
```

你必須先安裝一些相依套件。如果你使用的是 macOS，需要執行：

```bash
$ brew install cmake
```

如果你使用的是其他作業系統，可以參考 [Lighthouse 官方文件](https://oreil.ly/vEghS)。

**複製儲存庫**。第一步是複製 Git 儲存庫，取得一份原始碼：

```bash
$ git clone https://github.com/sigp/lighthouse.git
```

太好了！現在你在本機有了一份 Lighthouse，可以為你的平台編譯出執行檔了。

**從原始碼建置 Lighthouse**。要建置 Lighthouse，你需要執行下列指令：

```bash
$ cd lighthouse
$ git checkout stable
$ make
```

這可能要花超過 10 分鐘才能完成。

#### 執行節點

同樣地，你需要先執行執行層客戶端 Reth。

**執行執行層客戶端**。回到 *execution* 資料夾，執行這個指令：

```bash
$ cd ../.. # this command is used to go back to the ethereum-node2 folder
$ cp ../ethereum-node1/jwt.hex ./jwt.hex # we use the same jwt.hex file we generated before
$ cd execution
$ reth node --full --http --http.api all --authrpc.jwtsecret=../jwt.hex
```

如果你看到類似這樣的輸出，就表示一切運作正常：

```bash
2024-06-08T16:58:43.498297Z  INFO Starting reth version="0.2.0-beta.6-dev (ac29b4b73)"
2024-06-08T16:58:43.498434Z  INFO Opening database path="/Users/alessandromazza/Library/Application Support/reth/mainnet/db"
2024-06-08T16:58:43.514141Z  INFO Configuration loaded path="/Users/alessandromazza/Library/Application Support/reth/mainnet/reth.toml"
2024-06-08T16:58:43.514778Z  INFO Database opened
2024-06-08T16:58:43.514917Z  INFO Pre-merge hard forks (block based):…
```

**執行共識層客戶端**。現在你應該執行共識層客戶端 Lighthouse。不要關閉執行層客戶端所在的終端機分頁。只要開啟新的終端機視窗或分頁，切換到 *consensus* 資料夾：

```bash
$ cd ethereum-node2
$ cd consensus
$ lighthouse bn \
    --network mainnet \
	--checkpoint-sync-url https://mainnet.checkpoint.sigp.io \
	--execution-endpoint http://localhost:8551 \
	--execution-jwt ../jwt.hex \
	--http
```

這樣就完成了！你應該會看到執行層客戶端與共識層客戶端都開始在終端機上記錄大量資料。

執行層客戶端：

```bash
2024-06-08T17:03:03.355648Z  INFO Received headers total=10000 from_block=18458372 to_block=18448373
2024-06-08T17:03:04.792262Z  INFO Received headers total=10000 from_block=18448372 to_block=18438373
2024-06-08T17:03:04.800043Z  INFO Received headers total=10000 from_block=18438372 to_block=18428373
2024-06-08T17:03:04.913377Z  INFO Received headers total=10000 from_block=18428372 to_block=18418373
```

共識層客戶端：

```bash
Jun 08 17:03:24.929 INFO New block received                      root: 0xa49c057026cea3190df38548d49963e271ebdc4d6f93d2301adc4034d6563113, slot: 9253515
Jun 08 17:03:29.001 WARN Head is optimistic                      execution_block_hash: 0x5a14bfcb9e74c5b3a5121f99ef461ae066262200c269b5d11475274eb78aa7a5, info: chain not fully verified, block and attestation production disabled untilexecution engine syncs, service: slot_notifier
Jun 08 17:03:29.001 INFO Synced                                  slot: 9253515, block: 0xa49c…3113, epoch: 289172, finalized_epoch: 289170, finalized_root: 0xca35…2b06, exec_hash: 0x5a14…a7a5 (unverified), peers: 31, service: slot_notifier
```

現在你有了一個以太坊完整節點，正在同步到鏈的最前端。請注意，同步可能要花很多時間（依你的硬體與網路連線而定，可能需要幾個小時或幾天）。

> **備註**
>
> 如果你想進一步了解本範例中使用的指令與 CLI 旗標，[Reth](https://reth.rs) 與 [Lighthouse](https://oreil.ly/vEghS) 的官方文件是最好的參考資料。

下一節會說明以太坊區塊鏈初次同步時會遇到的挑戰。

> **提示**
>
> 這些步驟是不是讓你覺得既複雜又困惑？但你還是想為網路貢獻一份心力，執行自己的以太坊完整節點，真正不依賴任何可信第三方？
>
> 有個完美的解決方案適合你：BuidlGuidl Client。這個專案做出了一行指令，就能讓你執行以太坊節點。不相信嗎？[親眼看看吧](https://oreil.ly/9FKZd)。
>
> 另一個選擇是使用 [Dappnode](https://dappnode.com)。你可以從兩種解決方案中選擇：
>
> - 購買內建以太坊完整節點、隨插即用的裝置。
>
> - 安裝 Dappnode Core 軟體，它讓啟動以太坊完整節點變得非常容易。

## 基於以太坊的區塊鏈的初次同步

一般來說，同步以太坊區塊鏈時，你的客戶端會下載並驗證從最開始（也就是創世區塊）以來的每一個區塊與每一筆交易。雖然以這種方式完整同步區塊鏈是可行的，但同步會花非常久的時間，而且資源需求很高（它會需要多得多的 RAM；如果你沒有高速的儲存裝置，更是會花上非常久的時間）。

2016 年底，許多基於以太坊的區塊鏈都遭受了阻斷服務（denial of service，DoS）攻擊。受影響的區塊鏈在進行完整同步時，往往會同步得很慢。例如，在以太坊上，新的客戶端會快速推進，直到抵達第 2,283,397 號區塊。這個區塊是在 2016 年 9 月 18 日挖出的，標誌著 DoS 攻擊的開始。從這個區塊到第 2,700,031 號區塊（2016 年 11 月 26 日），交易的驗證會變得極度緩慢，而且非常耗用記憶體與 I/O。結果是，在 2016 年當時的硬體上，每個區塊的驗證時間超過一分鐘。以太坊透過硬分叉實施了一系列升級，修補 DoS 攻擊所利用的底層漏洞。這些升級也清理了區塊鏈，移除了由垃圾交易建立的大約 2,000 萬個空帳戶。

如果你以完整驗證的方式同步，客戶端會變慢，可能需要好幾天、甚至更久，才能驗證完受 DoS 攻擊影響的區塊。幸好，大多數以太坊客戶端都提供執行「快速」同步的選項：它會跳過交易的完整驗證，直到同步到區塊鏈的最前端，再從鏈的新最前端開始恢復完整驗證。對執行層客戶端來說，啟用快速同步的選項通常是快照同步（snap sync）。對共識層客戶端來說，快速同步的選項則是檢查點同步（checkpoint sync）。

在本教學中，我們預設都使用快速同步：執行層客戶端使用快照同步，共識層客戶端使用檢查點同步；唯一的例外是 Reth，它還不支援快照同步（截至 2025 年 6 月）。

## JSON-RPC 介面

以太坊客戶端提供一個 API 與一組 RPC 指令，這些指令以 JSON 編碼。你會看到它被稱為 JSON-RPC API。基本上，JSON-RPC API 是一個介面，讓我們可以撰寫程式，把以太坊客戶端當作通往以太坊網路與區塊鏈的閘道。

通常，RPC 介面會以 HTTP 服務的形式，在 8545 連接埠上提供。基於安全考量，它預設只接受來自 localhost（你自己電腦的 IP 位址，也就是 127.0.0.1）的連線。

要存取 JSON-RPC API，你可以使用專門的函式庫（以你選擇的程式語言撰寫），它會為每個可用的 RPC 指令提供對應的存根（stub）函式呼叫；你也可以手動建構 HTTP 請求，傳送與接收以 JSON 編碼的請求。你甚至可以使用 curl 這類通用的命令列 HTTP 客戶端來呼叫 RPC 介面。我們來試試看。首先，確定你已經設定好執行層客戶端，並讓它運作中。接著，切換到新的終端機視窗，輸入下列指令：

```bash
$ curl -X POST -H "Content-Type: application/json" --data \
	'{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":1}' \
	http://localhost:8545

{"jsonrpc":"2.0","id":1,"result":"Geth/1.14.3-stable/darwin-arm64/go1.22.2"}
```

在這個例子中，我們使用 curl 建立一條連到 *http://localhost:8545* 這個位址的 HTTP 連線。我們已經在執行執行層客戶端，它會以 HTTP 服務的形式，在 8545 連接埠上提供 JSON-RPC API。我們指示 curl 使用 HTTP POST 方法，並把內容類型標示為 **application/json**。最後，我們把一個以 JSON 編碼的請求，作為 HTTP 請求的資料部分傳送出去。這行命令大部分只是在設定 curl，讓它正確地建立 HTTP 連線。有趣的部分是我們實際發出的 JSON-RPC 指令：

```bash
{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":1}
```

JSON-RPC 請求的格式依照 [JSON-RPC 2.0 規格](https://oreil.ly/m0HLL)。每個請求物件都包含四個成員：

**jsonrpc**

JSON-RPC 協議的版本。這個值必須剛好是 "2.0"。

**method**

要呼叫的方法名稱。

**params**

一個結構化的值，存放呼叫方法時要使用的參數值。這個成員可以省略。

**id**

由客戶端訂定的識別碼；如果有提供，必須是字串、數字或 NULL 值。如果有提供，伺服器必須在回應物件中回覆相同的值。這個成員用來關聯兩個物件之間的脈絡。

> **提示**
>
> **id** 成員主要用在你於單一 JSON-RPC 呼叫中發出多個請求的時候，這種做法稱為批次處理（batching）。批次處理是為了避免每個請求都要建立新的 HTTP 與 TCP 連線所帶來的額外負擔。例如，在以太坊的情境中，如果我們想透過一條 HTTP 連線取得數千筆交易，就會使用批次處理。進行批次處理時，你要為每個請求設定不同的 id，再與 JSON-RPC 伺服器每個回應中的 id 互相比對。最簡單的實作方式，是維護一個計數器，每發出一個請求就把它的值加一。

我們收到的回應是：

```bash
{"jsonrpc":"2.0","id":1,"result":"Geth/1.14.3-stable/darwin-arm64/go1.22.2"}
```

這告訴我們，提供 JSON-RPC API 服務的是 1.14.3-stable 版的 Geth 客戶端。

我們來試試更有趣一點的東西。在下一個例子中，我們向 JSON-RPC API 詢問目前以 wei 計價的 gas 價格：

```bash
$ curl -X POST -H "Content-Type: application/json" --data \
	'{"jsonrpc":"2.0","method":"eth_gasPrice","params":[],"id":4213}' \
	http://localhost:8545
	
{"jsonrpc":"2.0","id":4213,"result":"0x1B1717FC7"}
```


回應 0x1B1717FC7 告訴我們，目前的 gas 價格是 7.27 gwei（gigawei，也就是十億 wei）。如果你和我們一樣，不習慣用十六進位思考，可以在命令列上用一點 Bash 功夫，把它轉換成十進位：

```bash
$ echo $((0x1B1717FC7))
7271972807
```

完整的 JSON-RPC API 可以在[以太坊 wiki](https://oreil.ly/lO2Z0) 上查閱。

> **提示**
>
> 在本節中，我們使用原始的 curl 請求來展示以太坊的 JSON-RPC 介面。在實際應用中，你大概會想透過更好、更程式化的方式來存取它。這就是函式庫派上用場的地方。歡迎探索下面這三個最知名、最多人使用的函式庫：
>
> - [ethers.js](https://oreil.ly/JKvSJ)
>
> - [web3.py](https://oreil.ly/dHSF4)
>
> - [alloy](https://alloy.rs)

## 以太坊遠端客戶端

遠端客戶端提供完整客戶端的部分功能。它們不儲存完整的以太坊區塊鏈，因此架設起來更快，需要的資料儲存空間也少得多。

這類客戶端通常提供下列一項或多項能力：

- 在錢包中管理私鑰與以太坊地址
- 建立、簽署並廣播交易
- 使用資料酬載（data payload）與智能合約互動
- 瀏覽去中心化應用（DApp）並與之互動
- 提供外部服務的連結，例如區塊瀏覽器
- 換算以太幣單位，並從外部來源取得匯率
- 把 Web3 實例當作 JavaScript 物件注入網頁瀏覽器
- 使用由其他客戶端提供或注入瀏覽器的 Web3 實例
- 存取本機或遠端以太坊節點上的 RPC 服務

遠端客戶端通常會連上在別處執行的完整節點，藉此提供完整節點以太坊客戶端的部分功能，而不需要在本機同步一份以太坊區塊鏈的副本。這個完整節點可能是你自己在本機電腦或網頁伺服器上執行的，也可能是第三方在其伺服器上執行的。

我們來看看幾個最熱門的遠端客戶端，以及它們提供的功能。

### 行動（智慧型手機）錢包

大多數正式上線的行動錢包都以遠端客戶端的方式運作，因為智慧型手機沒有足夠的資源來執行完整的以太坊客戶端。輕客戶端仍在開發中，在以太坊上尚未普遍使用。其中最知名的是 [Helios](https://oreil.ly/4joTo)，它仍然是實驗性的軟體。

熱門的行動錢包包括下列幾個（我們列出它們只是作為範例，並不代表我們推薦這些錢包，也不代表它們的安全性或功能）：

**Coinbase Wallet**

一款支援許多不同鏈的行動錢包，例如以太坊與它所有的第二層（layer 2，L2）網路、與 EVM 相容的第一層（layer 1，L1）區塊鏈、比特幣、Solana、Litecoin 與 Dogecoin。它也可以連結 Coinbase 帳戶。

**Phantom**

Phantom 是另一款多鏈錢包，相容於以太坊、Solana、比特幣與 Polygon。

**Trust Wallet**

一款支援超過一百條區塊鏈的行動多鏈錢包。Trust Wallet 有 iOS 與 Android 版本。

**Uniswap Wallet**

一款只支援以太坊，以及與 EVM 相容的 L2 和 L1 的行動錢包，由 Uniswap 團隊打造。它相當新，有 iOS 與 Android 版本。

### 瀏覽器錢包

有各式各樣的錢包與 DApp 瀏覽器，以 Chrome、Firefox 等網頁瀏覽器的外掛或擴充功能形式提供。這些是在你的瀏覽器中執行的遠端客戶端。其中較熱門的包括：

**MetaMask**

[MetaMask](https://metamask.io) 在[第 2 章](https://masteringethereum.xyz/chapter_2.html#getting-started-with-metamask)介紹過，它是一個多功能的瀏覽器錢包、RPC 客戶端，也是基本的合約瀏覽器，可以在 Chrome、Firefox、Opera 與 Brave 瀏覽器上使用。

**Phantom**

Phantom 也有網頁瀏覽器錢包，它的使用者介面（UI）非常美觀、簡潔。

**Rabby Wallet**

Rabby 是一款新的多鏈網頁瀏覽器錢包，支援超過一百條不同的區塊鏈（與 EVM 相容的鏈）。

**Coinbase Wallet**

Coinbase Wallet 也有網頁瀏覽器錢包，功能與行動版相同。

### 硬體錢包

大多數行動錢包與瀏覽器錢包，都可以搭配安全性更高的硬體錢包使用。硬體錢包是離線裝置，設計上永遠不連上網際網路，並且能抵抗竄改與其他形式的實體攻擊，提供更高等級的安全性。有好幾家公司在打造這類裝置，其中使用最廣泛的兩家是 Ledger 與 Trezor。

## 結語

本章探討了以太坊客戶端。你下載、安裝並同步了一個客戶端，成為以太坊網路的參與者，並透過在自己的電腦上複製區塊鏈，為系統的健全與穩定做出貢獻。

由於圍繞以太坊的研究與開發規模非常龐大，未來還會出現新型態的以太坊客戶端。值得關注的領域包括：

**歷史資料修剪**（history pruning）

修剪歷史資料，降低完整節點的儲存需求

**Verkle 樹與無狀態性**

不需要擁有完整的以太坊狀態，就能驗證區塊

**zk-EVM**

透過驗證零知識證明（zero-knowledge proof）來驗證區塊的正確性，而不需要重新執行區塊中的所有交易

我們會在接下來的章節中探討這些概念，但首先，我們需要揭開讓這一切成為可能的真正魔法：密碼學。
