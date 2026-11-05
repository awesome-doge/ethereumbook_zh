# 第 12 章　去中心化應用

在這一章，我們要揭開去中心化應用（DApp）的神祕面紗，說明它是什麼、如何運作，以及它的核心架構如何組成。介紹完基礎之後，我們會帶你走過一個實際動手做的範例，讓你從零開始打造你的第一個 DApp，包括部署所需的智能合約、整合前端，並讓整套技術堆疊準備好接近正式環境的部署。讀完本章，你不但會有一個能運作的 DApp，也會扎實理解支撐這類創新應用的核心概念。

## 什麼是 DApp？

*DApp* 是*去中心化應用*（decentralized application）的縮寫。和傳統應用相比，它是一次全新的典範轉移。傳統應用通常採用下面這樣的架構，如圖 12-1 所示：

- 一套不公開原始碼的程式，負責應用的邏輯部分
- 一個中心化的資料庫，用來儲存應用的資料
- 一個唯一的前端，讓使用者存取應用

![General architecture of a legacy application](images/ch12/maet_1201.png)

圖 12-1. 傳統應用的一般架構

想想 Instagram、TikTok、你的銀行，或是你現在手機裡的任何應用程式，它們大概都採用非常類似的架構。只有在背後的團隊願意讓你存取時，你才能使用這個應用；如果官方網站停擺了，並沒有其他網站可以讓你登入自己的 Instagram 帳戶。

DApp 有兩個明確的目標：不要有單點故障，以及成為一個即使整個團隊消失、人們仍然可以使用的產品。它的架構可以簡化成下面這樣，如圖 12-2 所示：

- 由數個以太坊智能合約構成 DApp 邏輯部分的基礎。大多數時候，這些 Solidity（或 Vyper）程式碼也是開源的。
- 智能合約也可以存放資料，作為真正的資料庫，收集所有必要的使用者資訊。
- 人們可以透過官方前端存取應用；如果主要的前端因為任何原因無法運作，也很容易換成另一個替代前端（甚至是社群製作的）。

![General architecture of a DApp](images/ch12/maet_1202.png)

圖 12-2. DApp 的一般架構

> **備註**  
>
> DApp 也可能有一些帶有某種程度中心化的鏈外元件，但這些元件通常不是應用核心邏輯的根本。在一般情況下，它們或許有助於加快應用的速度，但在最壞的情況下，應該永遠可以完全依靠鏈上資料。實際上並非總是如此，確實有些 DApp 的核心邏輯依賴中心化元件。它們不是真正的去中心化應用，比較像是介於傳統應用與完全去中心化應用之間的混合形式。

在接下來幾節，我們會進一步探討 DApp 技術堆疊中的每個元件，更了解它們如何運作，以及它們彼此之間、與以太坊協議之間的關係。

## 後端（智能合約）

在 DApp 中，核心的業務邏輯與資料儲存被寫進智能合約，在以太坊區塊鏈上執行，而不是放在中心化的伺服器上。區塊鏈扮演去中心化後端的角色：交易的執行、狀態的變化與紀錄的保存，都由網路以免信任的方式強制執行，而不是由單一實體負責。

使用者不需要信任任何中心化團隊就能存取 DApp，因為他們可以預期以太坊網路永遠正常運作，不論哪一天、哪個時刻，都會處理他們所有的交易，並正確更新智能合約的狀態。

此外，這種架構帶來一項非常強大的特性：*抗審查性*（censorship resistance）。傳統應用常常有一份禁止存取的國家清單，原因可能是政府的法律或其他任何理由。例如，截至 2025 年，Facebook 在巴西、中國、伊朗、北韓、緬甸、俄羅斯、土庫曼與烏干達遭到封鎖。這些國家的人無法建立個人檔案，也無法登入這個平台。

對於建立在以太坊上的 DApp，這種審查再也無法達成。雖然仍然可以封鎖某個 DApp 的官方網站，但沒有人能阻止一個地址與鏈上的任意智能合約互動。任何人都可以加入，為這個 DApp 建立替代前端，而每個人都可以再次透過它與這個 DApp 互動。

### Tornado Cash 事件始末

這裡值得一提 Tornado Cash 的故事。Tornado Cash 是一個去中心化的 mixing service TODO-term: mixing service（建議：混幣服務），讓任何人在任何地方，都能把可追蹤或「受污染」的加密貨幣與其他人的加密貨幣混在一起，切斷資金真正的發送者與接收者之間的所有關聯，藉此模糊回溯到原始來源的軌跡。

2022 年 8 月 8 日，美國財政部海外資產控制辦公室（Office of Foreign Assets Control）將 Tornado Cash 列入制裁名單，實際上等於禁止美國公民與公司使用它。這個平台被控洗錢的加密貨幣超過 70 億美元。兩天後的 8 月 10 日，Tornado Cash 的開發者之一 Alexey Pertsev 在阿姆斯特丹被捕，而他唯一的罪名就是打造了這個平台本身。官方的 GitHub 儲存庫被移除，開發者的帳號也被停權。截至 2024 年 12 月，官方網站仍然無法存取。

看到這裡，你可能以為 Tornado Cash 這個 DApp 已經停止運作了，但事實完全相反。雖然在這些事件之後，這項服務得到的關注（以及流動性）變少了，但這個協議仍然完全正常運作，並且可以透過各種託管在 IPFS 上的閘道存取。換句話說，即使沒有原本的官方網站，世界上任何人仍然可以像以前一樣使用 Tornado Cash。

## 資料儲存

資料儲存指的是用來保存使用者資料的方案。把資料寫進智能合約、從智能合約讀出資料是可行的，但這種操作很昂貴，而且擴展性不好；再說，並不是所有東西都需要存在鏈上。

通常，智能合約儲存關鍵的狀態資訊，並強制執行 DApp 的邏輯。帳戶餘額、所有權紀錄或運算結果這類關鍵資訊，會直接儲存在智能合約裡。這確保了敏感且具有價值的資料保持完全透明、防竄改，而且任何擁有以太坊節點的人都能存取。

其他所有資訊，都可以存放在去中心化程度較低的資料儲存方案裡，例如傳統的資料庫。例如，DApp 開發者常使用 indexer TODO-term: indexer（建議：索引器）來快速查詢資料，或用中心化資料庫儲存使用者資料，這樣前端就完全不需要與以太坊鏈互動。

> **備註**  
>
> *blockchain indexer* TODO-term: blockchain indexer（建議：區塊鏈索引器）是一種工具，讓開發者能快速而有效率地查詢與分析儲存在區塊鏈上的資料。它取得交易資料，轉換成機器與人類都能讀懂的資料，再載入資料庫，方便查詢。
>
> 事實上，你無法直接在區塊鏈中「搜尋」資料。舉例來說，假設你想知道某個帳戶在區塊 15364050 時持有多少 USDC 代幣。你不能直接到 USDC 智能合約裡找，因為它不儲存歷史資料。你可以取出從那個區塊到現在發生的所有交易，加以篩選，萃取出與該帳戶相關的所有 USDC 轉帳資訊，最後才終於得到答案。你可以想像，這不是理想的做法。這正是 indexer 派上用場的地方。它們維護一個類似資料庫的結構，讓你能針對任何需要的資訊（包括歷史資訊）立即執行查詢，並迅速得到答案。

這裡的概念是：你只需要把必要的資料與應用邏輯存在鏈上，讓任何人都能驗證 DApp 正確運作；其他的一切都可以、也應該留在鏈外。

### IPFS

*IPFS* 是一個去中心化、content-addressable TODO-term: content-addressable（建議：內容定址）的儲存系統，它把儲存的物件分散到點對點（P2P）網路中的各個對等節點上。*content addressable* 的意思是，每一份內容（檔案）都會經過雜湊，並以這個雜湊值來識別該檔案。接著，你就可以用雜湊值向任何 IPFS 節點請求，取回任何檔案。

IPFS 的目標是取代 HTTP，成為傳遞網頁應用的首選協議。網頁應用的檔案不再存放在單一伺服器上，而是存放在 IPFS 上，可以從任何 IPFS 節點取回。想了解更多，請閱讀 IPFS 的文件。

### 默克爾樹

一種有趣而常用的解決方案，是把資料以默克爾樹的結構存放在鏈外，只把默克爾根存在鏈上。如此一來，你不必把所有資料都存在智能合約裡（那會讓你花上大筆 gas 費用），卻仍然能在鏈上進行某種程度的驗證。

> **備註**  
>
> 編者註：以下的程式碼範例在非常特定的技術語境下使用了「whitelist」（白名單）一詞。雖然這個詞帶有不妥的含義，但它也廣泛用於整個產業與相關文件中。儘管我們非常重視包容性，作者仍選擇在此保留這個詞，以便清楚地呈現這些技術概念。

最常見的使用情境，是你建立了一個非同質化代幣（NFT）系列，想把不同的地址加入白名單，讓它們能在公開發售對所有人開放之前，以較低的價格鑄造這些 NFT。你有兩種做法。

第一種是在智能合約裡建立一個儲存空間變數，把每個地址映射到一個布林值，所有在白名單上的地址都對應到 true。接著，你就可以用這個映射來驗證某個地址是否確實在白名單上。使用者送出鑄造交易時不需要提供任何東西；合約只要檢查 `msg.sender` 是否在白名單的映射中即可，如下所示：[^tn3]

[^tn3]: 譯註：下面這段程式碼有誤：它先以 `nextTokenId` 呼叫一次 `_safeMint`，接著又把同一個值指定給 `tokenId`、再呼叫一次 `_safeMint`，等於對同一個代幣 ID 鑄造兩次，第二次鑄造會讓交易回復。正確的寫法應刪除第一次的 `_safeMint` 呼叫，與第二個範例相同。

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

// import OpenZeppelin contracts.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// A simplified NFT contract with a whitelist mint function that uses a mapping to 
// store whitelisted addresses.
contract MyWhitelistNFT is ERC721, Ownable {
    // ... rest of the contract
    
    // mapping for whitelisted addresses
    mapping(address => bool) public isWhitelisted;
    
    /**
     * @notice Whitelist mint function.
     */
    function whitelistMint() external payable {
        // ... rest of the function
        
        // check if the user is whitelisted.
        require(isWhitelisted[msg.sender], "You are not whitelisted");
        
        // mint the NFT.
        _safeMint(msg.sender, nextTokenId);
       // reserve the token ID before calling the recipient contract.
       uint256 tokenId = nextTokenId++;
       // mint the NFT.
       _safeMint(msg.sender, tokenId);
    }
}
```

第二種是在鏈外建立一棵默克爾樹，把默克爾根存在鏈上的合約裡。接著，你把各自的默克爾證明交給每一位白名單上的使用者。使用者把默克爾證明提交給合約，由合約在鏈上驗證這個證明的有效性（通常透過某些函式庫），如下所示：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

// import OpenZeppelin contracts.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

// A simplified NFT contract with a whitelist mint function that uses a merkle tree to 
// store whitelisted addresses.
contract MyWhitelistNFT is ERC721, Ownable {
    // ... rest of the contract
    
    // the merkle root of the off-chain generated Merkle Tree.
    bytes32 public merkleRoot;
    
    /**
     * @notice Whitelist mint function.
     * @dev User must provide a merkle proof to prove they are whitelisted.
     * @param _merkleProof The proof that msg.sender is whitelisted.
     */
    function whitelistMint(bytes32[] calldata _merkleProof) external payable {
        // ... rest of the function
        
        // verify that (msg.sender) is in the merkle tree using the provided proof.
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        bool isValidLeaf = MerkleProof.verify(_merkleProof, merkleRoot, leaf);
        require(isValidLeaf, "Invalid Merkle Proof: Not whitelisted");
               
       // reserve the token ID before calling the recipient contract.
       uint256 tokenId = nextTokenId++;
       // mint the NFT.
       _safeMint(msg.sender, tokenId);
    }  
}
```

第二種做法比第一種便宜得多、也有效率得多，對大型白名單尤其如此。

> **備註**  
>
> 這種方法大幅降低了 gas 成本，但除非這棵樹與各個證明都可以審計，否則會帶來白名單建立者不誠實的潛在風險。理想上，用來產生這棵樹的原始名單應該公開且可取得，讓任何人都能驗證產生出來的默克爾根是否正確。

## 前端（網頁使用者介面）

DApp 的前端可以用任何知名的 Web2 框架打造，例如 React、Angular 或 Vue。如果需要與以太坊鏈互動，則透過 `viem` 或 `ethers.js` 這類函式庫加以抽象化。

打造 DApp 前端的一種天真做法，是只直接從鏈上讀取資料來更新所有元件。例如，如果你需要顯示某個帳戶持有的一些代幣餘額，你可以查詢區塊鏈取得答案，並在每個新區塊重複這個步驟。

這種天真做法的主要問題是，你的網站會變得非常慢，使用者與這樣的前端互動可能會非常挫折。這就是為什麼如前所述，開發者常在 DApp 架構中使用中心化的資料儲存元件，盡量減少與鏈的互動：這會讓整體的使用者體驗更好。所以，你最後通常會得到一個依賴某些中心化元件的前端，但你永遠可以到區塊鏈上再次核對，驗證所有資訊。最終，如果你不信任某個 DApp 的官方前端，或單純就是不喜歡它，你也可以為它打造自己的替代前端。

圖 12-3 呈現了一個完整（簡化過）的 DApp 架構。

![Complete DApp architecture](images/ch12/maet_1203.png)

圖 12-3. 完整的 DApp 架構

## 一個基本的 DApp 範例

到目前為止，我們已經探討了 DApp 背後的基本概念。現在，該捲起袖子，自己動手打造一個 DApp 了。

網路上有很多教學可以幫助你從零開始在以太坊上打造第一個 DApp，但我們非常推薦 [Speedrun Ethereum](https://oreil.ly/Onygc)。這是快速學習、立刻開始打造酷東西最有效的方法。想增進在以太坊上打造 DApp 的知識，我們建議你完成 Speedrun Ethereum 上的所有挑戰，並加入 [BuidlGuidl 社群](https://buidlguidl.com)。

在這一節，我們要打造一個非常基本的去中心化應用，算是某種「Hello World」DApp。你不需要任何經驗，只需要一台電腦和網路連線。

### 安裝需求

要跟著這份教學做，你需要在電腦上安裝 [node.js](http://node.js)[^tn4] 與 [yarn](https://oreil.ly/dq_hw)。請參考它們的官方網站下載並安裝。我們會使用 [Scaffold-ETH 2](https://scaffoldeth.io)，這是一個非常酷的工具，能讓你非常快速地建立開發環境。

[^tn4]: 譯註：原書這個連結的網址（`http://node.js`）並不是有效的網站；Node.js 的官方網站是 <https://nodejs.org>。

### 建立 DApp

我們打開終端機，執行下面的指令：

```bash
$ npx create-eth@latest
```

它會詢問專案名稱。在這個示範中，我們選擇「mastering-ethereum」：

```
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 | Create Scaffold-ETH 2 app | 
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+

? Your project name: mastering-ethereum
```

接著，它會詢問我們想使用哪一個 Solidity 框架。這裡我們使用 Hardhat，但你可以自由選擇自己比較熟悉的框架：

```
? What solidity framework do you want to use?
❯ hardhat
   foundry
  none
```

幾秒鐘之後，你應該會看到一句「Congratulations」，以及類似下面這樣的「Next steps」（後續步驟）：

```
  Congratulations! Your project has been scaffolded! 🎉

  Next steps:

  cd mastering-ethereum
  
        Start the local development node
  
        yarn chain
  
        In a new terminal window, deploy your contracts
  
        yarn deploy
  
    In a new terminal window, start the frontend
  
    yarn start
  
 Thanks for using Scaffold-ETH 2 🙏 , Happy Building!
```

### 啟動區塊鏈

現在，開始打造 DApp 所需的一切都已就緒。進入專案資料夾：

```bash
$ cd mastering-ethereum
```

在這裡，如果你進入 `packages/hardhat/contracts`，會看到一個名為 `YourContract.sol` 的範例智能合約。你的 DApp 專案需要的每一個智能合約，都應該放在 `contracts` 資料夾裡。

在 `packages/nextjs` 裡，你會看到 DApp 前端所用的 nextjs 框架結構已經準備好了。

由於這是一份非常基本的教學，我們不會從零開始撰寫任何合約，也不會修改前端，而是沿用預設內容，快速展示一般的工作流程。

首先，你需要啟動一條供本機開發使用的區塊鏈。事實上，即使最終產品會使用部署在以太坊主網上的智能合約，你也不應該用真正的區塊鏈來打造與測試 DApp。那樣會非常慢，也會浪費很多錢。Scaffold-ETH 內建一個非常實用又簡單的指令，能立即啟動一條供本機開發使用的新區塊鏈。你只需要執行：

```bash
$ yarn chain
```

### 部署你的合約

現在，你需要把合約部署到上一步建立的本機區塊鏈上。同樣地，Scaffold-ETH 也為此準備了一個簡單的指令。打開一個新的終端機，輸入：

```bash
$ yarn deploy
```

你應該會看到類似這樣的輸出：

```
Generating typings for: 2 artifacts in dir: typechain-types for target: ethers-v6
Successfully generated 6 typings!
Compiled 2 Solidity files successfully (evm target: paris).
deploying "YourContract" (tx: 0x8ec9ba16869588c2826118a0043f63bc679a4e947f739e8032e911475e77dcb4)...: deployed at 0x5FbDB2315678afecb367f032d93F642f64180aa3 with 532743 gas
👋  Initial greeting: Building Unstoppable Apps!!!
📝  Updated TypeScript contract definition file on ../nextjs/contracts/deployedContracts.ts
```

如你所見，這個指令把名為 `YourContract` 的合約（也就是那個範例智能合約）部署到本機區塊鏈上。日後當你打造新的 DApp 時，你需要到 `packages/hardhat/deploy` 修改 `00_deploy_your_contract.ts` 檔案，才能部署你實際需要的所有合約。

如果你回到先前執行 `yarn chain` 指令的那個終端機，應該會看到一些新的日誌，其中一筆類似這樣：

```
eth_sendTransaction
  Contract deployment: <UnrecognizedContract>
  Contract address:    0x5fbdb2315678afecb367f032d93f642f64180aa3
  Transaction:         0x8ec9ba16869588c2826118a0043f63bc679a4e947f739e8032e911475e77dcb4
  From:                0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
  Value:               0 ETH
  Gas used:            532743 of 532743
  Block #1:            0xa7b8e3b6f82eccb3542279573dbf8efa2b876ff00807a8619feef191007e06d9
```

注意 `Contract deployment` 與 `Contract address` 這兩行。它們證明你已經成功把合約部署到本機區塊鏈上的那個合約地址。

### 啟動前端

Scaffold-ETH 範例內建一個基本的前端，讓你可以立即透過圖形介面開始與合約互動。打開一個新的終端機視窗，輸入：

```bash
$ yarn start
```

它應該會回傳類似這樣的內容：

```
yarn start
  ▲ Next.js 14.2.21
  - Local:        http://localhost:3000
 
 ✓ Starting...
 ✓ Ready in 1767ms
```

現在複製 localhost 的網址，打開瀏覽器，貼上連結。你應該會看到前端畫面，如圖 12-4 所示。

![Scaffold-ETH frontend](images/ch12/maet_1204.png)

圖 12-4. Scaffold-ETH 的前端

### 與你的合約互動

恭喜，一切都設定好了。現在你可以實驗並與你的 DApp 互動。有兩個非常實用的功能，你會發現它們是開發工作流程中不可或缺的：

- burner wallet TODO-term: burner wallet（建議：拋棄式錢包）
- Debug Contracts 頁面

如圖 12-4 所示，在右上角，我們已經用一個看起來很隨機、對我們來說很陌生的錢包連上了網站。這是因為它是一個 *burner wallet*：一個自動產生的地址，它的私鑰暫時儲存在你的網頁瀏覽器裡。事實上，如果你試著重新整理頁面，會發現你的 burner wallet 地址並沒有改變。

burner wallet 是開發工作流程中的殺手級功能，因為你不必每次都打開你的 Web3 錢包、把它連上網站。等你準備好了，仍然可以這麼做：只要點選下拉選單，選擇 Disconnect；接著點選 Connect Wallet，再從清單中選擇你偏好的錢包，如圖 12-5、圖 12-6 與圖 12-7 所示。

![Disconnect burner wallet](images/ch12/maet_1205.png)

圖 12-5. 中斷 burner wallet 的連線

![Connect Wallet button](images/ch12/maet_1206.png)

圖 12-6. Connect Wallet 按鈕

![Choose wallet](images/ch12/maet_1207.png)

圖 12-7. 選擇錢包

第二個殺手級功能是 Debug Contracts 頁面。要打開它，只要點選頁面中央的 Debug Contracts 連結。使用預設範例時，你現在應該會看到類似圖 12-8 的畫面。

![Debug Contracts section](images/ch12/maet_1208.png)

圖 12-8. Debug Contracts 頁面

在這裡，你可以輕鬆地與所有合約互動，不必在合約之上打造任何前端。這在開發期間非常實用，可以隨時檢查合約是否如你預期地運作。

我們來做個小示範。首先，我們需要為 burner wallet 注入資金，之後才能送出一些交易，與已部署的合約互動。要做到這一點，你只需要點選最右邊的按鈕，如圖 12-9 所示。你幾乎會立刻收到一些 ETH，並看到你的 ETH 餘額增加。

![Grab funds button](images/ch12/maet_1209.png)

圖 12-9. Grab funds 按鈕

現在到 `setGreeting` 區塊，在「_newGreeting」欄位輸入 `hello world`，在「payable value」欄位輸入 `0.1`。接著，點選「payable value」欄位右邊的星號：它會把這個 ETH 數值換算成以 wei 表示的同等金額（1 ETH = 10<sup>18</sup> wei）。最後，你可以點選 Send 送出交易，看看它如何改變合約的狀態。

圖 12-10 呈現了按下 Send 按鈕之前的合約狀態。你可以看到合約持有 0 ETH，greeting 是「Building Unstoppable Apps!!!」，premium 是 false，而 totalCounter 等於 0。

![Contract state before transaction](images/ch12/maet_1210.png)

圖 12-10. 交易之前的合約狀態

圖 12-11 呈現了送出交易之後的合約狀態。你馬上可以看到，合約現在持有 0.1 ETH，greeting 是「hello world」，premium 是 true，而 totalCounter 等於 1。

![Contract state after transaction](images/ch12/maet_1211.png)

圖 12-11. 交易之後的合約狀態

你可以多玩玩看，觀察合約如何依照你的輸入與動作而有不同的行為。

### 把合約部署到正式運作的區塊鏈

既然你已經實驗過你的合約，在向全世界發布 DApp 之前，該把合約部署到真正的區塊鏈上了。到目前為止，執行 `yarn deploy` 只會把合約部署到你的本機測試網路，而其他人都無法存取這個網路，這表示你的 DApp 除了你之外，對任何人都無法運作。

第一步是產生一個部署者帳戶，也就是負責送出部署合約交易的鏈上帳戶。

```bash
$ yarn generate
```

系統會提示你輸入一組選填的密碼。如果一切順利，你應該會看到類似這樣的輸出：

```bash
👛 Generating new Wallet

✔ Enter a password to encrypt your private key:
✔ Confirm password:

📄 Encrypted Private Key saved to packages/hardhat/.env file
🪄 Generated wallet address: 0x3a08bC7AF33bfED880C41A90FeE0D2776C98e3BF

⚠️ Make sure to remember your password! You'll need it to decrypt the private key.
```

接下來，你需要在目標區塊鏈上，為新產生的帳戶存入一些 ETH。要查看帳戶的詳細資料與目前餘額，請執行：

```bash
$ yarn account
```

現在，你可以執行下面的指令，把合約部署到以太坊：

```bash
$ yarn deploy --network mainnet
```

最後，為了完成設定，請修改 `scaffold.config.ts` 檔案，讓它指向合約部署所在的網路（在我們的例子中是以太坊）。把：

```bash
targetNetworks: [chains.hardhat],
```

改成：

```bash
targetNetworks: [chains.mainnet],
```

現在，你的前端會連接到你部署在以太坊主網上的合約。

你也可以選擇用下面的指令，在 Etherscan 上驗證你的合約：

```bash
$ yarn verify --network mainnet
```

> **備註**  
>
> 在 Etherscan 上驗證合約，可以讓任何人在這個以太坊最熱門的區塊瀏覽器上檢視、閱讀你合約的原始碼，並確認它與實際部署的位元組碼相符。

### 部署到 Vercel

當你對自己的去中心化應用感到滿意，就可以把它發布到 Vercel 這類正式環境。Vercel 是一個非常實用的 frontend-as-a-service TODO-term: frontend-as-a-service（建議：前端即服務）工具，讓你能輕鬆地把應用部署到網際網路上。你也可以綁定自己購買的自訂網域，讓人們只要輸入網域名稱就能連上你的 DApp。

Scaffold-ETH 再次助你一臂之力，只需要一個指令就能立即把 DApp 部署到 Vercel。打開終端機，輸入：

```bash
$ yarn vercel:yolo
```

你需要連結你的 Vercel 帳戶（如果還沒有，就建立一個新的），並替專案取個名字，就這樣。幾分鐘之後，你的整個 DApp 就會部署到 Vercel 上，世界上任何人都可以去試用。

如果你到自己的 Vercel 個人頁面，現在就能看到剛建立的專案。如圖 12-12 所示，那裡有一個 Domains 欄位，你可以在其中找到 Vercel 自動為你產生的網站網域。

![Vercel project page](images/ch12/maet_1212.png)

圖 12-12. Vercel 的專案頁面

## 讓 DApp 更加去中心化

在上一節，我們把 DApp 部署到了 Vercel。雖然 Vercel 是託管 DApp 最熱門的方案之一，它卻不是去中心化的服務。所有東西都放在它自有的伺服器上，這表示 Vercel 可能依照它的政策審查任何使用者，也能追蹤每個與你的 DApp 互動的人的 IP 地址。

為了讓 DApp 更加去中心化，我們可以把前端託管在 IPFS 這類方案上；IPFS 是一個由節點組成的全球點對點網路。有一項新興的服務值得一提：`eth.limo`。它的目標是讓網站既有主流網站（通常透過中心化平台提供）的使用者體驗，又有 IPFS 等技術提供的穩健性與去中心化。

### 去中心化網站

[Eth.limo](https://eth.limo/) 是拼圖中缺少的那一塊，能用來打造更好的去中心化網站（也稱為 *DWebsite*），讓人能像平常使用傳統應用一樣存取它們。它以以太坊域名服務（ENS）的技術為基礎；ENS 用 `.eth` 名稱讓以太坊地址變得容易使用。以太坊的共同創辦人之一 Vitalik Buterin 就用 ENS 把他的錢包地址 `0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045` 連結到好記的名稱 `vitalik.eth`。

ENS 不只能把名稱連結到以太坊地址，也能解析到一個 IPFS 網站（實際上是 content hash TODO-term: content hash（建議：內容雜湊）），類似 `bafybeif3dy…ga4zu` 這樣的字串。IPFS 網站的主要問題是，大多數熱門的網頁瀏覽器都無法正確解析它們，也無法把內容顯示給使用者。這就是 `eth.limo` 派上用場的地方：它為 ENS 名稱與 IPFS 內容營運一個反向代理。它攔截所有對 `*.eth.limo`（基本上就是所有以 `.eth.limo` 結尾的網站）的請求，自動解析所請求 ENS 紀錄的 IPFS contenthash，再透過 HTTPS 回傳對應的靜態內容。例如，當你造訪 [Vitalik Buterin 的官方部落格](https://vitalik.eth.limo)時，背後發生的事情是這樣的：

1. Eth.limo 看到對 `vitalik.eth` 這個 ENS 名稱的請求。
2. 它把這個名稱解析成（Buterin 先前設定好的）IPFS contenthash，其中包含他網站的首頁。
3. 它透過 HTTPS 回傳對應的靜態內容。

如此一來，世界上任何擁有網頁瀏覽器的人，都能輕鬆存取儲存在 IPFS 上的內容，完全不需要任何組態或設定。

### 限制

雖然 DWebsite 整體而言（尤其是 `eth.limo`）是一項持續演進、而且進步得相當快的技術，但在撰寫本章的此刻（2025 年 6 月），仍然有一些限制。首先，IPFS 只能處理靜態檔案，所以無法進行任何伺服器端的運算。此外，要使用 `eth.limo`，你需要購買一個 ENS 名稱，並把它連結到前端的 IPFS contenthash。而且你必須一直使用 `*.eth.limo` 這個自訂網域；你不能省略結尾的 `.limo`，否則你的網頁瀏覽器將無法把你的 ENS 名稱解析到 DApp 的 IPFS 前端。這大概就是大多數 DApp 不使用 `eth.limo` 的原因。

> **提示**  
>
> 雖然大多數網頁瀏覽器確實還不相容 ENS 與 IPFS，但有些瀏覽器已經開始支援它們，[Brave](https://oreil.ly/LlJT7) 就是一個例子。

必須一提的是，`eth.limo` 是另一個可能中心化的第三方，可能在沒有任何預警的情況下停止運作。萬一發生這種情況，你的 DApp 仍然可以透過 IPFS 連上，但 `.eth.limo` 網址將不再把使用者導向它們。

如果你有興趣，想深入了解這個打造完全去中心化網站的方案，可以在它的[官方網站](https://eth.limo)找到更多細節。

### 部署到 IPFS

Scaffold-ETH 2 還有另一個簡單的指令，讓你能快速把 DApp 推送到 IPFS。你只需要打開一個新的終端機，輸入：

```bash
$ yarn ipfs
```

這樣就完成了！你應該會看到類似這樣的輸出：

```
   Creating an optimized production build ...
 
 ✓ Compiled successfully
 ✓ Linting and checking validity of types
    
 ✓ Collecting page data
    
 ✓ Generating static pages (8/8)
 ✓ Collecting build traces
    
 ✓ Finalizing page optimization

…

🚀  Upload complete! Your site is now available at: https://community.bgipfs.com/ipfs/bafybei…
```

如果你前往畫面上顯示的網站，應該會看到你的 DApp 在託管於 IPFS 的前端上正常運作。字串「bafy…」就是 IPFS contenthash。如果你有自己的 ENS 名稱，想把它導向這個託管在 IPFS 上的網站，仍然需要設定 `eth.limo`。

這個 `yarn ipfs` 指令背後實際發生的事情如下：

1. 建置前端，準備好要上傳到 IPFS 的靜態檔案。
2. 透過 BuidlGuidl（Scaffold-ETH 2 的維護者）的 IPFS 社群節點，把靜態檔案上傳到 IPFS。
3. 回傳一個導向這些靜態檔案的網址，作為 IPFS 內容的反向代理（`community.bgipfs.com/<ipfs-content-hash>`）。

如果你想學習如何執行自己的 IPFS 節點，並 pin TODO-term: pin（建議：釘選）一個叢集，請參考 [BuidlGuidl IPFS](https://www.bgipfs.com)。

## 從應用到 DApp

在前面幾節，我們一步步打造了一個去中心化應用。我們使用名為 Scaffold-ETH 的工具來簡化開發工作流程：啟動本機區塊鏈、部署合約，並啟動本機前端，立即開始與 DApp 互動並加以測試。接著，我們把 DApp 的前端發布到 Vercel，展示在可供正式使用的環境中部署 DApp 有多簡單。最後，我們探討了如何把前端發布到 IPFS，並使用 ENS 與 `eth.limo` 等方案，讓 DApp 更加去中心化，任何人都不必安裝特殊的應用程式就能存取它。

圖 12-13 簡要地呈現了打造一個完全去中心化應用所需的工程技術堆疊。

![DApp engineering stack](images/ch12/maet_1213.png)

圖 12-13. DApp 完整工程技術堆疊的簡要概覽

## 結語

在這一章，我們探討了如何運用現代工具簡化開發工作流程，從零開始打造一個基本的 DApp。在下一章，我們會深入探討以太坊上一些最重要的 DApp 與 DApp 類別，它們共同構成了所謂的去中心化金融（DeFi）。
