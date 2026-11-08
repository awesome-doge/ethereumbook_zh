# 第 14 章　以太坊虛擬機

以太坊協議與運作的核心，是*以太坊虛擬機*（Ethereum Virtual Machine，*EVM*）。從名字大概就猜得到，它是一個計算引擎，和 Microsoft .NET 框架的虛擬機，或 Java 這類編譯成位元組碼的程式語言所使用的直譯器，並沒有太大的不同。本章會在以太坊狀態更新的脈絡下，詳細介紹 EVM，包括它的指令集、結構與運作方式。

## EVM 是什麼？

EVM 是以太坊中負責部署與執行智能合約的部分。實務上，從一個外部擁有帳戶（EOA）轉帳到另一個 EOA 的單純轉帳交易不需要動用它，但其他所有交易都會牽涉到由 EVM 計算出來的狀態更新。從高層次來看，在以太坊區塊鏈上運作的 EVM 可以想成一臺全球性的去中心化電腦，裡面有數以百萬計的可執行物件，每個物件都有自己的永久資料儲存區。

EVM 是一個*準圖靈完備*的狀態機。之所以說「準」，是因為每一次智能合約執行可用的 gas 數量有限，所有執行過程因此都只能進行有限的計算步驟。這樣一來，*停機問題*（halting problem）就「解決」了（所有程式的執行都會停止），也就避免了執行過程（不論是意外還是惡意）永遠跑下去、讓整個以太坊平臺停擺的情況。後面幾節會更詳細地探討停機問題。

EVM 採用*堆疊式架構*，把所有記憶體中的值都存放在堆疊上。它的字組大小是 256 位元，主要是為了方便原生的雜湊與橢圓曲線運算。它有幾個可以定址的資料元件：

- 不可變更的程式碼 ROM，載入要執行的智能合約位元組碼
- 揮發性的記憶體，每個位置都明確初始化為零
- 暫時儲存空間，只在單一交易執行期間存在（不屬於以太坊狀態）
- 永久儲存空間，屬於以太坊狀態的一部分，同樣初始化為零

執行期間還可以取用一組環境變數與資料。本章稍後會更詳細地介紹它們。

![EVM 的架構與執行環境](images/ch14/maet_1401.png)

圖 14-1. EVM 的架構與執行環境

## 與現有技術的比較

*虛擬機*這個詞通常指的是把一臺真實的電腦虛擬化，一般是透過 VirtualBox 或 QEMU 這類虛擬機器監視器（hypervisor）來做；或是把整個作業系統實例虛擬化，例如 Linux 的 KVM。這兩者分別必須以軟體抽象化實際的硬體，以及系統呼叫與其他核心功能。

EVM 運作的範圍則有限得多：它只是一個計算引擎，因此只提供計算與儲存的抽象，例如和 Java 虛擬機（JVM）規格類似。從高層次來看，JVM 的設計是要提供一個與底層主機作業系統或硬體無關的執行環境，讓程式能在各式各樣的系統上相容執行。Java、Scala（使用 JVM）或 C#（使用 .NET）這類高階程式語言，會被編譯成各自虛擬機的位元組碼指令集。同樣地，EVM 也執行自己的位元組碼指令集（下一節會介紹），Solidity、Vyper 與 Yul 這類較高階的智能合約程式語言，都會編譯成這套指令集。

因此，EVM 沒有排程能力，因為執行順序是在它外部安排的：以太坊客戶端會逐一處理已驗證區塊中的交易，決定哪些智能合約需要執行，以及執行的順序。從這個角度來看，以太坊世界電腦和 JavaScript 一樣是單執行緒的。EVM 也沒有任何「系統介面」處理或「硬體支援」，因為根本沒有實體機器可以對接。以太坊世界電腦完全是虛擬的。

## 其他區塊鏈怎麼做？

EVM 無疑是加密貨幣領域中使用最廣泛的虛擬機。大多數其他的第一層（L1）與第二層（L2）區塊鏈都使用 EVM，以便與所有現有的工具和框架保持相容，並直接從以太坊社群吸引專案與開發者。

儘管如此，近幾年還是出現了好幾種不同的虛擬機：Solana VM、Wasm VM、Cairo VM 與 Move VM 大概是其中最有名、也最有意思的幾種，各有優缺點。它們在智能合約開發上採取了不同的做法：

**自訂語言**

有些平臺（例如 Cairo 與 Move）建立了專門用來撰寫智能合約的程式語言。這和以太坊為它的虛擬機 EVM 使用 Solidity 與 Vyper 的情況類似。

**標準語言**

另一些平臺（例如 Solana，以及使用 WebAssembly（Wasm）的平臺）則讓開發者用廣泛使用的程式語言撰寫智能合約。例如，這些平臺通常支援以 Rust 開發智能合約。

這些替代虛擬機與 EVM 不同的另一個地方，是交易的*平行化*。前面說過，EVM 是循序處理交易的，沒有任何平行化。有些專案看到這個缺點，試著加以改進。例如，Solana VM 與 Move VM 都能平行執行交易，不過並不是每次都做得到：當兩筆交易與同一個合約互動、修改同一塊儲存空間時，就不能平行執行。

必須一提的是，改進虛擬機效能的努力並不只發生在以太坊之外。事實上，許多團隊正在設法突破 EVM 目前的限制，嘗試加入平行化，以及把 EVM 位元組碼*預先編譯*（ahead-of-time，AOT）或*即時編譯*（just-in-time，JIT）成原生機器碼等很酷的功能。

## EVM 指令集（位元組碼操作）

EVM 指令集提供了大部分你預期會有的操作，包括：

- 算術運算與位元邏輯運算
- 查詢執行環境
- 存取堆疊、記憶體與儲存空間
- 控制流程操作
- 日誌、呼叫與其他運算子

除了一般的位元組碼操作，EVM 還能取得帳戶資訊（例如地址與餘額）與區塊資訊（例如區塊編號與目前的 gas 價格）。

讓我們先從可用的*操作碼*與它們的作用開始，更詳細地探索 EVM。如你所料，所有運算元都取自堆疊，而結果（如果有的話）通常會放回堆疊頂端。

可用的操作碼可以分成以下幾類：

### 算術運算

算術操作碼指令包括：

```
ADD        //Add the top two stack items
MUL        //Multiply the top two stack items
SUB        //Subtract the top two stack items
DIV        //Integer division
SDIV       //Signed integer division
MOD        //Modulo (remainder) operation
SMOD       //Signed modulo operation
ADDMOD     //Addition modulo any number
MULMOD     //Multiplication modulo any number
EXP        //Exponential operation
SIGNEXTEND //Extend the length of a two's complement signed integer
SHA3       //Compute the Keccak-256 hash of a block of memory
```

注意，所有算術運算（除非另有說明）都是對 2^256 取模進行的，而零的零次方 0^0 視為 1。

### 堆疊操作

管理堆疊、記憶體與儲存空間的指令包括：

```
POP     //Remove the top item from the stack
MLOAD   //Load a word from memory
MSTORE  //Save a word to memory
MSTORE8 //Save a byte to memory
SLOAD   //Load a word from storage
SSTORE  //Save a word to storage
TLOAD   //Load a word from transient storage
TSTORE  //Save a word to transient storage
MSIZE   //Get the size of the active memory in bytes
PUSH0   //Place value 0 on the stack
PUSHx   //Place x byte item on the stack, where x can be any integer from
        // 1 to 32 (full word) inclusive
DUPx    //Duplicate the x-th stack item, where x can be any integer from
        // 1 to 16 inclusive
SWAPx   //Exchange 1st and (x+1)-th stack items, where x can be any
        // integer from 1 to 16 inclusive
```

### 流程控制操作

控制流程的指令包括：

```
STOP      //Halt execution
JUMP      //Set the program counter to any value
JUMPI     //Conditionally alter the program counter
PC        //Get the value of the program counter (prior to the increment
          //corresponding to this instruction)
JUMPDEST  //Mark a valid destination for jumps
```

### 系統操作

與執行程式的系統有關的操作碼包括：

```
LOGx          //Append a log record with x topics, where x is any integer
              //from 0 to 4 inclusive
CREATE        //Create a new account with associated code
CALL          //Message-call into another account, i.e., run another
              //account's code
CALLCODE      //Message-call into this account with another
              //account's code
RETURN        //Halt execution and return output data
DELEGATECALL  //Message-call into this account with an alternative
              //account's code, but persisting the current values for
              //sender and value
STATICCALL    //Static message-call into an account, i.e., it cannot change
              //the state of any account
REVERT        //Halt execution, reverting state changes but returning
              //data and remaining gas
INVALID       //The designated invalid instruction
SELFDESTRUCT  //Halt execution and, if executed in the same transaction a
              //contract was created, register account for deletion. Note
              //that its usage is highly discouraged and the opcode is
              //considered deprecated
```

### 邏輯運算

用於比較與位元邏輯的操作碼包括：

```
LT     //Less-than comparison
GT     //Greater-than comparison
SLT    //Signed less-than comparison
SGT    //Signed greater-than comparison
EQ     //Equality comparison
ISZERO //Simple NOT operator
AND    //Bitwise AND operation
OR     //Bitwise OR operation
XOR    //Bitwise XOR operation
NOT    //Bitwise NOT operation
BYTE   //Retrieve a single byte from a full-width 256-bit word
```

### 環境操作

處理執行環境資訊的操作碼包括：

```
GAS            //Get the amount of available gas (after the reduction for
               //this instruction)
ADDRESS        //Get the address of the currently executing account
BALANCE        //Get the account balance of any given account
ORIGIN         //Get the address of the EOA that initiated this EVM
               //execution
CALLER         //Get the address of the caller immediately responsible
               //for this execution
CALLVALUE      //Get the ether amount deposited by the caller responsible
               //for this execution
CALLDATALOAD   //Get the input data sent by the caller responsible for
               //this execution
CALLDATASIZE   //Get the size of the input data
CALLDATACOPY   //Copy the input data to memory
CODESIZE       //Get the size of code running in the current environment
CODECOPY       //Copy the code running in the current environment to
               //memory
GASPRICE       //Get the gas price specified by the originating
               //transaction
EXTCODESIZE    //Get the size of an account's code
EXTCODECOPY    //Copy an account's code to memory
RETURNDATASIZE //Get the size of the output data from the previous call
               //in the current environment
RETURNDATACOPY //Copy data output from the previous call to memory
```

### 區塊操作

存取目前區塊資訊的操作碼包括：

```
BLOCKHASH  //Get the hash of one of the 256 most recently completed
           //blocks
COINBASE   //Get the block's beneficiary address for the block reward
TIMESTAMP  //Get the block's timestamp
NUMBER     //Get the block's number
PREVRANDAO //Get the previous block's RANDAO mix. This opcode replaces the
           //DIFFICULTY one since The Merge hard fork.
GASLIMIT   //Get the block's gas limit
```

## 以太坊狀態

EVM 的工作，是依照以太坊協議的定義，計算智能合約程式碼執行所產生的有效狀態轉換，藉此更新以太坊狀態。因為這一點，以太坊被描述為*基於交易的狀態機*，反映出外部參與者（也就是帳戶持有人與驗證者）是透過建立、接受與排序交易來發起狀態轉換的。在這裡，值得先想一想以太坊狀態是由什麼組成的。

最上層是以太坊的*世界狀態*。世界狀態是以太坊地址（160 位元的值）到帳戶的映射。往下一層，每個以太坊地址代表一個帳戶，帳戶包含以太幣（ether）餘額（以帳戶擁有的 wei 數量儲存）、nonce（如果是 EOA，代表從這個帳戶成功送出的交易數；如果是合約帳戶，代表它建立的合約數）、帳戶的儲存空間（只有智能合約使用的永久資料儲存區），以及帳戶的程式碼（同樣只有智能合約帳戶才有）。傳統上，EOA 一定沒有程式碼，儲存空間也是空的。然而，在 2025 年 5 月的 Pectra 升級中啟用的以太坊改進提案（EIP）[EIP-7702](https://eips.ethereum.org/EIPS/eip-7702)，允許 EOA 把程式碼的執行委託給智能合約，改變了這個前提。EOA 選擇委託時，它的程式碼欄位會被設成 23 位元組的*委託指定*，格式是 `0xef0100 || address`，其中 `address` 是目標合約的 20 位元組地址。依照 [EIP-3541](https://eips.ethereum.org/EIPS/eip-3541)，`0xef` 這個位元組是禁用的操作碼，因此這個指定不會和可部署的合約程式碼混淆。EVM 遇到對已委託 EOA 的呼叫時，會載入目標地址的程式碼，在該 EOA 的環境中執行。這表示對已委託的 EOA 執行 `EXTCODESIZE` 會回傳 23（委託指定的大小），而在委託的程式碼中執行 `CODESIZE` 則會回傳目標合約程式碼的大小。EOA 執行委託的程式碼時也可以使用儲存空間，不過協議建議採用以太坊徵求意見（ERC）[ERC-7201](https://eips.ethereum.org/EIPS/eip-7201) 定義的命名空間儲存配置，以免在不同的委託合約之間遷移時發生衝突。已委託的 EOA 仍然可以發起交易，這一點很重要。它們依然是能簽署與送出交易的 EOA，只是現在多了智能合約的能力。只要委託給零地址（`0x0000000000000000000000000000000000000000`），就能清除委託。

當一筆交易需要執行智能合約程式碼時，系統會建立一個 EVM 實例，並帶入與目前正在建立的區塊、正在處理的這筆交易有關的所有必要資訊。具體來說，EVM 的程式碼 ROM 會載入被呼叫的合約帳戶的程式碼，程式計數器設為零，儲存空間從合約帳戶的儲存空間載入，記憶體全部設為零，所有區塊與環境變數也都會設定好。其中一個關鍵變數是這次執行的可用 gas，它會設為發送者在交易一開始支付的 gas 數量（詳見「執行期間的 gas 計算」一節）。隨著程式碼執行，可用 gas 會依照已執行操作的 gas 成本遞減。如果可用 gas 在任何時候小於零，就會發生 *gas 耗盡*（out-of-gas，OOG）例外：執行立即停止，交易也隨之作廢。以太坊狀態不會有任何變更，唯一的例外是發送者的 nonce 會遞增，而且他的以太幣餘額會減少，用來支付給區塊受益人，作為執行程式碼直到停止點所耗用資源的費用。在這個階段，你可以把 EVM 想成在以太坊世界狀態的沙盒副本上執行；如果執行因為任何原因無法完成，這個沙盒版本就會被完全丟棄。不過，如果執行順利完成，真正的世界狀態就會更新成與沙盒版本一致，包括被呼叫合約的儲存資料的任何變更、新建立的任何合約，以及發起的任何以太幣餘額轉移。

程式碼的執行是一個遞迴的過程。合約可以呼叫其他合約，每一次呼叫都會以新的呼叫目標為中心，再建立一個 EVM 實例。每個實例的沙盒世界狀態，都以上一層 EVM 的沙盒來初始化。每個實例（環境）也會被分配指定數量的可用 gas（當然不會超過上一層剩餘的 gas），因此它本身也可能因為分配到的 gas 太少、無法完成執行而以例外停止。同樣地，在這種情況下，沙盒狀態會被丟棄，執行回到上一層的 EVM。

## 無狀態以太坊

在本書撰寫時（2025 年 6 月），所有以太坊節點都必須計算並維護最新的狀態（也就是前面所說的世界狀態），才能透過重新執行每個新區塊所包含的所有交易，檢查區塊是否正確。不過，目前已經有計畫要擺脫這一點，至少是部分擺脫。

構想是只讓一小群參與者（例如搜尋者（searcher）與建構者）仍需存取狀態，以便建立與發布新區塊；其他所有節點則不需要狀態，就能以密碼學的方式驗證這些區塊。這就是所謂的*無狀態性*。

無狀態性在以太坊路線圖上還是很遙遠的事，因為它需要修改核心協議的一些地方：

**內建的提議者與建構者分離（enshrined proposer-builder separation，ePBS）**

把「用交易填滿區塊以建立區塊」的工作，和「把區塊提議到點對點（P2P）網路」的工作分開。前者由稱為搜尋者與建構者、高度專業化的實體負責，它們能打造出極度最佳化的區塊；後者則由以太坊的驗證者節點負責。這在主網上已經是現實，只是還沒有內建在協議中。事實上，大多數以太坊區塊已經是由極少數的大型建構者所建構的。

**Verkle 樹**

取代以太坊目前用來儲存狀態的資料結構：默克爾帕特里夏前綴樹（Merkle-Patricia trie，MPT）。這能大幅縮小驗證狀態正確性所需的密碼學證明，驗證起來也比舊的默克爾帕特里夏前綴樹更快。

> **備註**  
>
> 其他以雜湊為基礎的二元樹也正在測試中，可能會取代 Verkle 樹。核心概念只是要為狀態找到一種資料結構，讓人能產生既小、又能快速而輕鬆驗證的證明。

這兩項升級結合起來，可以達成這樣的情境：只有想要建立區塊、擁有更強大硬體的大型實體，才需要儲存與存取完整的狀態。它們在產生新區塊的同時，也會產生*密碼學見證*：一組最小的資料，用來證明新狀態是根據它們放進區塊的交易正確計算出來的。

其他所有節點（包括驗證者節點）只儲存*狀態根*，也就是整個狀態的雜湊值。它們收到新區塊時，會用相關的見證來驗證區塊是否正確。

這讓執行以太坊節點變得非常輕量，因為你不必儲存完整的狀態，甚至不需要（在 EVM 中）重新執行所有交易，卻仍然能驗證一切是否正確，不需要信任第三方。你甚至可以在智慧型手機上執行節點……

雖然研究進展很快，但距離主網實現無狀態性，大概還有好幾年。

## 默克爾帕特里夏前綴樹

目前，以太坊狀態是用一種非常特殊的資料結構儲存的，稱為*修改版的默克爾帕特里夏前綴樹*（modified Merkle-Patricia trie）。上一節簡單提過默克爾帕特里夏前綴樹（以下簡稱 MPT），但了解它如何運作、為什麼這樣設計，以及以太坊如何用它來儲存狀態（而且不只是狀態……），是非常重要的，因為同樣的道理也適用於 Verkle 樹。深入 MPT 之前，你需要先認識默克爾樹，因為它是 MPT 的基礎。

### 默克爾樹

默克爾樹是一種非常古老的資料結構，由 Ralph Merkle 在 1988 年發明，原本是為了打造更好的數位簽章。當你需要驗證某筆資料存在於資料庫中、而且沒有被竄改，又不想為了證明這一點而送出整個資料庫時，默克爾樹非常有效率。

從一組資料建立默克爾樹相當容易。你要先把資料分成好幾個資料塊，接著把這些資料塊合併起來計算雜湊，再以遞迴的方式重複這最後一步，直到只剩下最後一塊為止。這一塊就是*默克爾根*：可以說是建立這棵樹的所有資料的數位指紋。

讓我們從零開始建立一棵二元默克爾樹（最簡單的默克爾樹形式），讓你更熟悉它。我們從八塊資料開始，你可以把它們想成八個不同的英文單字。我們用特定的雜湊函數計算每一塊資料的雜湊值（如第 4 章所述，以太坊使用 Keccak-256 雜湊函數），得到默克爾樹的葉節點，在圖 14-2 中標示為 hash_1、hash_2 等等。接著，我們把每一對葉節點串接起來，再計算一次雜湊，得到 hash_12、hash_34 等等。我們把串接與計算雜湊的過程再重複兩次，直到得到單一的最終結果，也就是我們的默克爾根：hash_12345678。

![二元默克爾樹](images/ch14/maet_1402.png)

圖 14-2. 二元默克爾樹

你現在可能會問：為什麼需要用默克爾樹來儲存資料？這不是比直接把每一塊資料存進傳統資料庫還複雜嗎？

答案是肯定的，這比把每一塊資料存進鍵值資料庫或 SQL 資料庫複雜得多。我們使用這類資料結構的唯一理由，是它們能非常有效率地提供低成本的密碼學證明，證明某一塊資料確實存在於整個資料集合中，而且沒有被竄改。事實上，如果我們用一般的資料庫儲存資料，而有人要求我們證明自己擁有某一塊特定的資料，我們就得公開整個資料集，讀者才能確定我們沒有說謊。

讓我們用前面的例子實際看看。假設我們想證明 data_1 包含在資料集中。最單純的做法是提供整個資料集，從 data_1 到 data_8，總共八項。如果用默克爾樹，我們只需要提供 hash_2、hash_34 與 hash_5678。這樣一來，任何人都能自己算出默克爾根，再與我們一開始算出的（公開分享的）默克爾根比較。如果兩者相符，你就能完全確定 data_1 屬於最初的資料集，如圖 14-3 所示。

![驗證 data_1 包含在樹中的默克爾證明](images/ch14/maet_1403.png)

圖 14-3. 驗證 data_1 包含在樹中的默克爾證明

> **提示**  
>
> 要重建默克爾樹，可以依照以下步驟：
>
> 1. 計算 data_1 的雜湊，得到 hash_1。
> 2. 把 hash_1 與提供的 hash_2 串接後計算雜湊，得到 hash_12。
> 3. 把 hash_12 與提供的 hash_34 串接後計算雜湊，得到 hash_1234。
> 4. 把 hash_1234 與提供的 hash_5678 串接後計算雜湊，得到最終的默克爾根。

注意，我們只用了三項資料；如果不用默克爾樹、採取最單純的做法，就需要八項。而這只是個玩具範例，資料量很大時，節省的幅度會大得多。

用數學的說法，默克爾樹的複雜度是 O(log(n))，而單純做法則是線性的 O(n)，如圖 14-4 所示。

![O(n) 線性複雜度（上）與 O(log(n)) 複雜度（下）的比較](images/ch14/maet_1404.png)

圖 14-4. O(n) 線性複雜度（上）與 O(log(n)) 複雜度（下）的比較

在以太坊的世界裡，這表示要證明某個地址的餘額、某筆交易的結果，或某個智能合約的位元組碼，都更便宜、更容易。

### 比特幣中的默克爾樹

比特幣率先在區塊鏈技術中使用默克爾樹。事實上，每個比特幣區塊都包含該區塊中所有交易的默克爾根，因此任何一筆交易都無法在不修改整個區塊頭的情況下被修改，而修改區塊頭也會讓工作量證明（PoW）失效。

### 以太坊中的默克爾帕特里夏前綴樹

以太坊採用了同樣的概念，並針對自身的特定需求做了一些修改。默克爾樹非常適合永遠不會改變的永久資料，例如比特幣的交易。然而，以太坊狀態不斷在變，因此我們需要調整默克爾樹，讓它在保有原本那些實用特性的同時，也能讓底層的資料頻繁變動。

這時就輪到默克爾帕特里夏前綴樹登場了。這個名字結合了默克爾樹、Patricia（Practical Algorithm to Retrieve Information Coded in Alphanumeric，擷取以英數字編碼之資訊的實用演算法），以及源自 *retrieval*（擷取）一詞的*前綴樹*（trie），提醒我們它是為了什麼而最佳化的。

簡單來說，默克爾帕特里夏前綴樹就是每個節點有 16 個子節點的修改版默克爾樹。它們很適合以太坊狀態這類有大量鍵值項目的資料（鍵是地址，值是每個地址的帳戶資訊，例如餘額、nonce，以及程式碼（如果有的話）），因為鍵本身就編碼在你要抵達樹中正確位置所必須走的路徑上。

假設我們要儲存以下這個鍵值項目：

```
car → Schumacher
```

car 的十六進位編碼是 (0x) 6 3 6 1 7 2，因此你要從默克爾根開始走到第 6 個子節點，再往下走到第 3 個子節點，一直重複這個過程，直到抵達最終的值，讀出與這個鍵對應的值（在這個例子中是 Schumacher），如圖 14-5 所示。

![把鍵值項目 car → Schumacher 編碼進默克爾帕特里夏前綴樹](images/ch14/maet_1405.png)

圖 14-5. 把鍵值項目 car → Schumacher 編碼進默克爾帕特里夏前綴樹

具體來說，以太坊使用四棵默克爾帕特里夏前綴樹：

**狀態前綴樹**

儲存整個狀態

**交易前綴樹**

儲存區塊中包含的所有交易

**收據前綴樹**

儲存區塊中包含的所有交易的結果

**儲存前綴樹**

儲存智能合約的資料

每個以太坊區塊頭都包含狀態前綴樹、交易前綴樹與收據前綴樹的默克爾根，而每個帳戶（包含在狀態前綴樹中）則儲存自己的儲存前綴樹的默克爾根。

## 深入 EVM 的各個元件

本節會更仔細地看看 EVM 的每個元件如何運作。最後，我們會檢視一個真實的例子，看看所有元件如何實際運作。

### 堆疊

堆疊是一種非常簡單的資料結構，依照*後進先出*（last in, first out，LIFO）的順序進行操作，其中每個項目都是 32 位元組的物件。它最多可以同時容納 1,024 個項目。

EVM 可以透過不同種類的操作碼，把項目推入堆疊或從堆疊彈出，也可以調整堆疊中元素的順序，如圖 14-6 所示。

![EVM 堆疊依照後進先出的順序進行操作](images/ch14/maet_1406.png)

圖 14-6. EVM 堆疊依照後進先出的順序進行操作

### 記憶體

EVM 記憶體是一種以位元組為單位定址的資料結構：也就是一個非常長的位元組陣列。事實上，記憶體中的每個位元組都可以用 32 位元組（256 位元）的鍵來存取，這表示它最多可以容納 2^256 個位元組。它是揮發性的（也就是在執行結束後就會被刪除），而且一律初始化為 0。

雖然可以對記憶體讀寫單一位元組，但大多數操作都需要讀寫更大塊的資料，通常是 32 位元組一塊，如圖 14-7 所示。

![EVM 記憶體是揮發性、以位元組為單位定址的資料結構](images/ch14/maet_1407.png)

圖 14-7. EVM 記憶體是揮發性、以位元組為單位定址的資料結構

> **備註**  
>
> 技術上，你無法從 EVM 讀取單一位元組，只能讀取完整的 32 位元組字組。為了達到讀取單一位元組的效果，EVM 需要載入包含該位元組的整個字組，再把它「切開」，只回傳選定的那個位元組。

### 儲存空間

EVM 儲存空間是一種鍵值資料結構，其中的鍵（通常稱為 *slot*）與值都是 32 位元組長。這是每個智能合約的持久記憶：存在裡面的所有值，都會跨越不同的交易與區塊無限期地保留下來。每個智能合約都只能存取與修改自己的儲存空間；如果你存取一個沒有任何值的 slot，它一律會回傳 0，而不會丟出任何錯誤。圖 14-8 非常簡略地呈現了兩個合約的儲存空間。

![EVM 儲存空間是採用鍵值資料結構的永久記憶](images/ch14/maet_1408.png)

圖 14-8. EVM 儲存空間是採用鍵值資料結構的永久記憶

另外還有隨 [EIP-1153](https://oreil.ly/fRvKl) 加入的*暫時儲存空間*，它的行為和一般的儲存空間相同，唯一的差別是交易執行結束後就會被完全丟棄。因此，它的使用成本比一般儲存空間便宜得多。

### calldata

calldata 是一種不可變更的資料結構，內容一律是送給下一個*呼叫框架*（也就是一個沙盒化的 EVM 環境）作為輸入的位元組。例如，在建立合約的交易中，calldata 包含即將部署的合約的位元組碼。calldata 也可以是空的，例如單純的 ETH 轉帳。

## 用具體的例子把一切串起來

你正在執行一筆與合約 A 互動的交易，並有以下的 EVM 位元組碼：`60425F525F3560AB145F515500`。

你還有一份初始的 calldata：

```
00000000000000000000000000000000000000000000000000000000000000ab
```

讓我們把這段 EVM 位元組碼以人類可讀的格式表示：

```
[00]            PUSH1            42
[02]            PUSH0
[03]            MSTORE
[04]            PUSH0
[05]            CALLDATALOAD
[06]            PUSH1            AB
[08]            EQ
[09]            PUSH0
[0a]            MLOAD
[0b]            SSTORE
[0c]            STOP
```

> **備註**  
>
> 每個 EVM 操作碼都由一個獨一無二的 1 位元組值（範圍從 0x00 到 0xFF）來識別。例如，0x60 是 PUSH1 操作碼，0x5F 是 PUSH0，依此類推。所有操作碼及其十六進位表示法的完整清單，請參考 [EVM codes](https://www.evm.codes)。

讓我們看看 EVM 如何執行這些操作碼，以及堆疊、記憶體與儲存空間如何被操作。圖 14-9 是 EVM 的初始狀態。

![EVM 的初始狀態](images/ch14/maet_1409.png)

圖 14-9. EVM 的初始狀態

第一個操作碼把 0x42 推入堆疊（圖 14-10）。注意，所有 PUSH 操作碼都是從位元組碼本身接下來的位元組取得（要推入的）資料。

![執行 PUSH1 0x42 之後的 EVM](images/ch14/maet_1410.png)

圖 14-10. 執行 PUSH1 0x42 之後的 EVM

接著，PUSH0 把 0x00 推入堆疊（圖 14-11）。

![執行 PUSH0 之後的 EVM](images/ch14/maet_1411.png)

圖 14-11. 執行 PUSH0 之後的 EVM

MSTORE 從堆疊彈出兩個項目，把第一個解讀為偏移量（以位元組為單位），第二個解讀為要從該偏移量開始寫入記憶體的值。注意，記憶體中在位元組 0x42 之前有許多前導零（31 個等於零的位元組）。這是正確的，因為堆疊中的每個值都是 32 位元組的值。大多數時候，我們書寫時可以忽略前導零（在圖 14-12 中，你看到的項目是 0x42），但你應該隨時記得它們是 32 位元組的值。

![執行 MSTORE 之後的 EVM](images/ch14/maet_1412.png)

圖 14-12. 執行 MSTORE 之後的 EVM

然後，又有一個 PUSH0 把 0x00 推入堆疊（圖 14-13）。

![執行 PUSH0 之後的 EVM](images/ch14/maet_1413.png)

圖 14-13. 執行 PUSH0 之後的 EVM

CALLDATALOAD 從堆疊取出一個元素，解讀為偏移量，回傳 calldata 中從該偏移量開始的 32 位元組值，再把它推入堆疊。在這裡，它回傳的是 0xab（注意，所有前導零都不影響數值，可以忽略），如圖 14-14 所示。

![執行 CALLDATALOAD 之後的 EVM](images/ch14/maet_1414.png)

圖 14-14. 執行 CALLDATALOAD 之後的 EVM

PUSH1 把 0xab 推入堆疊（圖 14-15）。

![執行 PUSH1 0xab 之後的 EVM](images/ch14/maet_1415.png)

圖 14-15. 執行 PUSH1 0xab 之後的 EVM

EQ 從堆疊彈出兩個項目並加以比較，相等就回傳 1，否則回傳 0。在這個例子中，兩個值相等，因此回傳 0x01，如圖 14-16 所示。

![執行 EQ 之後的 EVM](images/ch14/maet_1416.png)

圖 14-16. 執行 EQ 之後的 EVM

再一次，PUSH0 把 0x00 推入堆疊（圖 14-17）。

![執行 PUSH0 之後的 EVM](images/ch14/maet_1417.png)

圖 14-17. 執行 PUSH0 之後的 EVM

MLOAD 從堆疊取出一個元素，解讀為偏移量，從記憶體中該偏移量開始讀取 32 個位元組，再把結果推入堆疊（圖 14-18）。

![執行 MLOAD 之後的 EVM](images/ch14/maet_1418.png)

圖 14-18. 執行 MLOAD 之後的 EVM

現在，SSTORE 從堆疊彈出兩個項目，把第一個解讀為 slot，第二個解讀為要存到合約儲存空間中該 slot 編號的值，如圖 14-19 所示。

![執行 SSTORE 之後的 EVM](images/ch14/maet_1419.png)

圖 14-19. 執行 SSTORE 之後的 EVM

最後是 STOP 操作碼，它會停止執行，EVM 也順利返回，如圖 14-20 所示。

![執行 STOP 之後的 EVM](images/ch14/maet_1420.png)

圖 14-20. 執行 STOP 之後的 EVM

> **提示**  
>
> 在前面的例子中，我們用了 PUSH0 操作碼。必須一提的是，並不是所有與 EVM 相容的區塊鏈都已經整合了這個操作碼，部署跨鏈合約時要留意這一點。[EVM Diff](https://www.evmdiff.com) 是一個很酷的網站，列出了各條 EVM 相容鏈之間所有這類細微的差異。

## 把 Solidity 編譯成 EVM 位元組碼

我們已經在第 7 章介紹過 Solidity。現在，我們要看看它如何被編譯成 EVM 能夠解讀的 EVM 位元組碼。

把 Solidity 原始碼檔案編譯成 EVM 位元組碼有好幾種方法。在第 2 章，我們用的是線上的 Remix 編譯器。本章則會使用命令列的 `solc` 執行檔。要在你的電腦上安裝 Solidity，請[依照這些步驟](https://oreil.ly/JW--z)。

要列出所有選項，請執行以下指令：

```bash
$ solc --help
```

用 `--opcodes` 命令列選項，就能輕鬆產生 Solidity 原始碼檔案的原始操作碼串流。這個操作碼串流省略了一些資訊（`--asm` 選項會產生完整的資訊），但對這裡的討論已經足夠。例如，要編譯範例 Solidity 檔案 `Example.sol`，並把操作碼輸出到名為 `BytecodeDir` 的目錄，可以使用以下指令：

```bash
$ solc -o BytecodeDir --opcodes Example.sol
```

你也可以用 `--asm` 產生更容易閱讀的輸出：

```bash
$ solc -o BytecodeDir --asm Example.sol
```

以下指令會產生範例程式的位元組碼二進位檔：

```bash
$ solc -o BytecodeDir --bin Example.sol
```

產生的操作碼輸出檔，取決於 Solidity 原始碼檔案中包含哪些合約。我們的簡單 Solidity 檔案 `Example.sol` 只有一個合約，名為 Example：

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.27;

contract Example {
  address contractOwner;
  
  function test() public {
    contractOwner = msg.sender;
  }
}
```

如你所見，這個合約做的事就只是保存一個持久的狀態變數，內容設為最後一個執行這個合約的帳戶的地址。

查看 `BytecodeDir` 目錄，你會看到操作碼檔案 `Example.opcode`，裡面是範例合約的 EVM 操作碼指令。用文字編輯器打開 `Example.opcode` 檔案，會看到以下內容：

```
PUSH1 0x80 PUSH1 0x40 MSTORE CALLVALUE DUP1 ISZERO PUSH1 0xE JUMPI PUSH0 PUSH0 REVERT JUMPDEST POP PUSH1 0xA9 DUP1 PUSH1 0x1A PUSH0 CODECOPY PUSH0 RETURN INVALID PUSH1 0x80 PUSH1 0x40 MSTORE CALLVALUE DUP1 ISZERO PUSH1 0xE JUMPI PUSH0 PUSH0 REVERT JUMPDEST POP PUSH1 0x4 CALLDATASIZE LT PUSH1 0x26 JUMPI PUSH0 CALLDATALOAD PUSH1 0xE0 SHR DUP1 PUSH4 0xF8A8FD6D EQ PUSH1 0x2A JUMPI JUMPDEST PUSH0 PUSH0 REVERT JUMPDEST PUSH1 0x30 PUSH1 0x32 JUMP JUMPDEST STOP JUMPDEST CALLER PUSH0 PUSH0 PUSH2 0x100 EXP DUP2 SLOAD DUP2 PUSH20 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF MUL NOT AND SWAP1 DUP4 PUSH200xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND MUL OR SWAP1 SSTORE POP JUMP INVALID LOG2 PUSH5 0x6970667358 0x22 SLT KECCAK256 JUMPI 0xBB RETURNDATACOPY SWAP15 CALLVALUE 0xB3 0xB1 SMOD BLOBHASH STATICCALL MCOPY PUSH10 0x856E7132D8FEED4D83B6 0xB2 0xBE PUSH30 0x8B43532C818BFD64736F6C634300081B0033000000000000000000000000
```

用 `--asm` 選項編譯這個範例，會在 `BytecodeDir` 目錄中產生名為 `Example.evm` 的檔案。裡面是稍微高階一點的 EVM 位元組碼指令描述，還附上一些有用的註解：

```
/* "Example.sol":61:171  contract Example {... */
  mstore(0x40, 0x80)
  callvalue
  dup1
  iszero
  tag_1
  jumpi
  revert(0x00, 0x00)
tag_1:
  pop
  dataSize(sub_0)
  dup1
  dataOffset(sub_0)
  0x00
  codecopy
  0x00
  return
stop

sub_0: assembly {
        /* "Example.sol":61:171  contract Example {... */
      mstore(0x40, 0x80)
      callvalue
      dup1
      iszero
      tag_1
      jumpi
      revert(0x00, 0x00)
    tag_1:
      pop
      jumpi(tag_2, lt(calldatasize, 0x04))
      shr(0xe0, calldataload(0x00))
      dup1
      0xf8a8fd6d
      eq
      tag_3
      jumpi
    tag_2:
      revert(0x00, 0x00)
        /* "Example.sol":109:169  function test() public {... */
    tag_3:
      tag_4
      tag_5
      jump    // in
    tag_4:
      stop
    tag_5:
        /* "Example.sol":154:164  msg.sender */
      caller
        /* "Example.sol":138:151  contractOwner */
      0x00
      0x00
        /* "Example.sol":138:164  contractOwner = msg.sender */
      0x0100
      exp
      dup2
      sload
      dup2
      0xffffffffffffffffffffffffffffffffffffffff
      mul
      not
      and
      swap1
      dup4
      0xffffffffffffffffffffffffffffffffffffffff
      and
      mul
      or
      swap1
      sstore
      pop
        /* "Example.sol":109:169  function test() public {... */
      jump    // out
    auxdata: 0xa264697066735822122057bb3e9e34b3b10749fa5e69856e7132d8feed4d83b6b2be7d8b43532c818bfd64736f6c634300081b0033
}
```

`--bin` 選項會產生機器可讀的十六進位位元組碼：

```
6080604052348015600e575f5ffd5b5060a980601a5f395ff3fe6080604052348015600e575f5ffd5b50600436106026575f3560e01c8063f8a8fd6d14602a575b5f5ffd5b60306032565b005b335f5f6101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555056fea264697066735822122057bb3e9e34b3b10749fa5e69856e7132d8feed4d83b6b2be7d8b43532c818bfd64736f6c634300081b0033
```

你可以用「EVM 指令集（位元組碼操作）」一節列出的操作碼清單，詳細研究這裡發生了什麼事。不過那可是個大工程，所以我們先只看前四個指令：

```
PUSH1 0x80 PUSH1 0x40 MSTORE CALLVALUE
```

這裡是 `PUSH1`，後面跟著一個值為 `0x80` 的原始位元組。這個 EVM 指令會取出程式碼中緊接在操作碼後面的那個位元組（作為常值），把它推入堆疊。推入堆疊的值最大可以到 32 位元組，例如：

```
PUSH32 0x436f6e67726174756c6174696f6e732120536f6f6e20746f206d617374657221
```

`example.opcode` 中的第二個 `PUSH1` 操作碼，把 `0x40` 放到堆疊頂端（把原本在那裡的 `0x80` 往下推一格）。

接下來是 `MSTORE`，這是一個記憶體儲存操作，會把一個值存進 EVM 的記憶體。它需要兩個引數，而且和大多數 EVM 操作一樣，都從堆疊取得。每取一個引數，堆疊就會被「彈出」一次：堆疊頂端的值被取走，堆疊上其他所有的值都往上移一個位置。`MSTORE` 的第一個引數，是要存放這個值的記憶體字組地址。在這個程式中，堆疊頂端是 `0x40`，因此它被移出堆疊，當作記憶體地址使用。第二個引數是要儲存的值，在這裡是 `0x80`。執行完 `MSTORE` 操作後，我們的堆疊又空了，但記憶體位置 `0x40` 上有了值 `0x80`（十進位的 128）。

下一個操作碼是 `CALLVALUE`，這是一個環境操作碼，會把隨著發起這次執行的訊息呼叫一起送來的以太幣數量（以 wei 計）推到堆疊頂端。

我們可以繼續這樣逐步走完這個程式，直到完全了解這段程式碼造成的底層狀態變化，但在這個階段幫助不大。本章稍後會再回來看它。

## 合約部署程式碼

在以太坊平臺上建立與部署新合約時所用的程式碼，和合約本身的程式碼之間，有一個重要但不太明顯的差別。要建立新合約，需要一筆特殊的交易，它的 `to` 欄位是空的（null），`data` 欄位則設為合約的*初始化程式碼*。處理這種建立合約的交易時，新合約帳戶的程式碼並不是交易 `data` 欄位中的程式碼。實際上，系統會建立一個 EVM 實例，把交易 `data` 欄位中的程式碼載入它的程式碼 ROM，再把這段部署程式碼的執行輸出，當作新合約帳戶的程式碼。這麼做是為了讓新合約能在部署時，利用當時的以太坊世界狀態，以程式化的方式進行初始化：設定合約儲存空間中的值，甚至送出以太幣或再建立其他新合約。

離線編譯合約時（例如在命令列使用 `solc`），你可以取得*部署位元組碼*或*執行期位元組碼*。部署位元組碼涵蓋新合約帳戶初始化的所有面向，包括交易呼叫這個新合約時實際會執行的位元組碼（也就是執行期位元組碼），以及依照合約建構子初始化一切的程式碼。相對地，執行期位元組碼就只是新合約被呼叫時最終會執行的那段位元組碼，不多也不少；它不包含部署期間初始化合約所需的位元組碼。

讓我們以前幾章建立的簡單 `Faucet.sol` 合約為例：

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.27;

contract Faucet {
  // Give out ether to anyone who asks
  function withdraw(uint256 _withdrawAmount, address payable _to) public {
    // Limit withdrawal amount
    require(_withdrawAmount <= 1000000000000);
    // Send the amount to the address that requested it
    _to.transfer(_withdrawAmount);
  }
  
  // Function to receive Ether. msg.data must be empty
  receive() external payable {}
  
  // Fallback function is called when msg.data is not empty
  fallback() external payable {}
}
```

要取得部署位元組碼，我們會執行 `solc --bin Faucet.sol`；如果只想要執行期位元組碼，則執行 `solc --bin-runtime Faucet.sol`。比較這兩個指令的輸出，你會發現執行期位元組碼是部署位元組碼的子集。換句話說，執行期位元組碼完整地包含在部署位元組碼之中。

### 用 CREATE 與 CREATE2 在鏈上部署合約

`CREATE` 與 `CREATE2` 是僅有的兩個能在鏈上部署新合約的操作碼。兩者的主要差別在於新建立合約的地址。使用 `CREATE` 時，目的地址的計算方式如下：

```
address = keccak256[rlp(sender_address ++ sender_nonce)][12:]
```

也就是把發送者地址及其後的 nonce 做 RLP 編碼，計算 Keccak-256 雜湊，取最右邊的 20 個位元組。

`CREATE2` 是在 2019 年的 Constantinople 硬分叉中加入的，讓開發者建立新合約時，產生的地址不取決於發送者的狀態（也就是 nonce）。事實上，它的行為和 `CREATE` 操作碼完全相同，只是目的地址改用以下方式計算：

```
address = keccak256(0xff ++ sender_address ++ salt ++ keccak256(init_code))[12:]
```

其中：

- `init_code` 是新合約的部署位元組碼。
- `salt` 是一個 32 位元組的值（從堆疊取得）

## 反組譯位元組碼

反組譯 EVM 位元組碼，是了解高階的 Solidity 在 EVM 中如何運作的好方法。你可以使用以下幾種反組譯器：

- [**Ethersplay**](https://oreil.ly/xW6fH) 是反組譯器 Binary Ninja 的 EVM 外掛。順帶一提，要使用外掛，你必須購買完整版的 Binary Ninja。
- [**Heimdall**](https://oreil.ly/klTJ3) 是一套進階的 EVM 智能合約工具組，專精於位元組碼分析，以及從未經驗證的合約中擷取資訊。

本節會使用 Heimdall 產生圖 14-21。取得 `Faucet.sol` 的執行期位元組碼後，我們可以把它交給 Heimdall，看看 EVM 指令長什麼樣子。

![反組譯 Faucet 的執行期位元組碼](images/ch14/maet_1421.png)

圖 14-21. 反組譯 Faucet 的執行期位元組碼

### 安裝 Heimdall

首先，你要確認電腦上已經安裝了 Rust。如果還沒有，請執行以下指令：

```bash
$ curl https://sh.rustup.rs -sSf | sh
```

然後依序執行以下兩個指令：

```bash
$ curl -L http://get.heimdall.rs | bash
$ bifrost
```

現在，Heimdall 應該已經正確安裝了。你可以執行以下指令確認：

```bash
$ heimdall --version
```

你應該會看到類似這樣的輸出：

```bash
$ heimdall --version
heimdall 0.8.4
```

> **備註**  
>
> 關於安裝 Heimdall 的最新資訊，請參考 [GitHub 儲存庫](https://oreil.ly/klTJ3)上的官方文件。

### 用 Heimdall 反組譯位元組碼

既然已經正確安裝了 Heimdall，我們就可以產生你在圖 14-21 看到的那張圖了。從 `Faucet.sol` 合約的執行期位元組碼開始，你可以執行以下指令：

```bash
$ heimdall cfg <insert the runtime bytecode here>
```

以下是這個指令實際的樣子：

```bash
$ heimdall cfg 608060405260043610610…
```

現在，你應該會看到一個名為 `output` 的新資料夾。進入這個資料夾，再進入產生出來的 `local` 資料夾，應該就能找到 `cfg.dot` 檔案：

```bash
$ cd output
$ cd local
$ ls # now you should see the file
```

因為這是 `.dot` 檔案，需要特別的程式才能正確開啟。在這個例子中，我們會使用一個網站，只要貼上 `.dot` 檔案的內容，它就會幫我們產生圖形。

首先，你要複製 `.dot` 檔案的內容：

```bash
$ cat cfg.dot
```

這個指令會把檔案的完整內容印在螢幕上。把它複製下來，打開一個[*控制流程圖*（control flow graph，CFG）線上產生器](https://oreil.ly/swOsK)，貼到網頁的左側，如圖 14-22 所示。

![Faucet.sol 合約的控制流程圖（CFG）](images/ch14/maet_1422.png)

圖 14-22. Faucet.sol 合約的控制流程圖（CFG）

圖 14-23 是 `Faucet.sol` 合約一開頭的位元組碼。如你所見，它的開頭和前面的 `Example.sol` 合約是同樣的模式：`PUSH1 0x80 PUSH1 0x40 MSTORE`。

![放大 CFG 圖的第一部分](images/ch14/maet_1423.png)

圖 14-23. 放大 CFG 圖的第一部分

當你送一筆交易給與 ABI 相容的智能合約（你可以假設所有合約都是）時，這筆交易會先和該智能合約的*分派器*互動。分派器會讀取交易的 `data` 欄位，把相關的部分送到對應的函式。在反組譯後的 `Faucet.sol` 執行期位元組碼開頭，就可以看到一個分派器的例子。在熟悉的 `MSTORE` 指令之後，我們看到以下指令：

```
PUSH1 0x04
CALLDATASIZE
LT
PUSH2 0x0020
JUMPI
```

如前所述，`PUSH1 0x04` 把 `0x04` 放到堆疊頂端，此時堆疊上沒有其他東西。`CALLDATASIZE` 取得隨交易送來的資料（也就是 calldata）的大小（以位元組計），並把這個數字推入堆疊。執行完這些操作後，堆疊會像這樣：

```
Stack
<length of calldata from tx>
0x4
```

下一個指令是 `LT`，是「less than」（小於）的縮寫。`LT` 指令會檢查堆疊頂端的項目是否小於堆疊上的下一個項目。在我們的例子中，它檢查的是 `CALLDATASIZE` 的結果是否小於 4 個位元組。

EVM 為什麼要檢查交易的 calldata 至少有 4 個位元組？這和*函式識別碼*的運作方式有關。每個 Solidity 函式都以它的 Keccak-256 雜湊值的前 4 個位元組來識別。把函式名稱與它接受的所有引數放進 `keccak256` 雜湊函數，就能推算出它的函式識別碼。在我們的例子中：

```
keccak256("withdraw(uint256,address)") = 0x00f714ce...
```

因此，`withdraw(uint256,address)` 函式的函式識別碼是 `0x00f714ce`，因為這是雜湊結果的前 4 個位元組。函式識別碼一律是 4 個位元組長，所以如果送給合約的交易，整個 data 欄位不到 4 個位元組，那麼除非定義了 fallback 函式，否則這筆交易不可能是在和任何函式溝通。因為我們在 `Faucet.sol` 中實作了 fallback 函式，所以當 calldata 的長度小於 4 個位元組時，EVM 就會跳到這個函式。

`LT` 從堆疊彈出最上面的兩個值；如果交易的 data 欄位小於 4 個位元組，就把 1 推入堆疊，否則推入 0。在我們的例子中，假設送給合約的交易，data 欄位小於 4 個位元組。

`PUSH2 0x0020` 指令把位元組 `0x0020` 推入堆疊。執行這個指令後，堆疊會像這樣：

```
Stack
0x0020
0x1
```

下一個指令是 `JUMPI`，代表「jump if」（條件成立就跳躍）。它的運作方式如下：

```
jumpi(label, cond) // Jump to "label" if "cond" is true
```

在我們的例子中，`label` 是 `0x0020`，也就是 fallback 函式在智能合約中的位置。`cond` 引數是 1，也就是前面 `LT` 指令的結果。把這整串指令用文字說明，就是：如果交易資料小於 4 個位元組，合約就跳到 fallback 函式。

在 `0x20` 處，兩個 `JUMPDEST` 指令之後就只剩一個 `STOP` 指令，因為我們雖然宣告了 fallback 函式，卻讓它保持空白。如圖 14-24 所示，如果我們沒有實作 fallback 函式，合約就會改成丟出例外。

![通往 fallback 函式的 JUMPI 指令](images/ch14/maet_1424.png)

圖 14-24. 通往 fallback 函式的 JUMPI 指令

> **備註**  
>
> Heimdall 呈現位元組碼時，偏移量是從 0x01 開始算的，但 EVM 實際上是從偏移量 0x00 開始解讀。在前面的例子中，JUMPI 指令告訴 EVM，條件成立時要跳到偏移量 0x20，但在圖中，偏移量 0x20 顯示為 0x21。經驗法則是：只要把 EVM 的每個偏移量加一，就能在圖上找到對應的位置。

讓我們來看看分派器的核心區塊。假設收到的 calldata 長度大於 4 個位元組，`JUMPI` 指令就不會跳到 fallback 函式，而是繼續執行以下指令：

```
PUSH0 0x0
CALLDATALOAD
PUSH1 0xe0
SHR
DUP1
PUSH3 0xf714ce
EQ
PUSH2 0X23
JUMPI
```

`PUSH0` 把 0 推入堆疊，此時堆疊上又沒有其他東西了。`CALLDATALOAD` 接受一個引數，也就是送給智能合約的 calldata 中的某個索引，並從該索引開始讀取 32 個位元組，如下所示：

```
calldataload(p) //load 32 bytes of calldata starting from byte position p
```

因為 `PUSH0` 指令傳給它的索引是 0，`CALLDATALOAD` 會從第 0 個位元組開始讀取 32 個位元組的 calldata，然後（在彈出原本的 `0x0` 之後）把它推到堆疊頂端。執行 `PUSH1 0xe0` 指令後，堆疊會變成：

```
Stack
0xe0
<32 bytes of calldata starting at byte 0>
```

`SHR` 把堆疊上那個 32 位元組的值，邏輯右移 `0xe0` 個位元（224 個位元，即 28 個位元組）。把 calldata 右移 28 個位元組，就能單獨取出 calldata 的前 4 個位元組。事實上，向右位移時，被移出最右端的所有位元都會被丟棄，左邊補進來的新位元則設為 0。記住，calldata 的前 4 個位元組，代表我們想要觸發的函式的函式識別碼。

### 邏輯位移的例子

用一個例子會更容易理解。假設堆疊是：

```
Stack
0x1234567890 // a 5 bytes element
```

我們只想取得前兩個位元組（也就是 `0x1234`）。只用 EVM 操作碼的話，可以這樣做：

```
PUSH1 0x18 // this represents the number 24 in hex, 24 bits = 3 bytes
SHR
```

事實上，把堆疊上的項目向右位移 3 個位元組（記住，這裡每個位元組用 2 個十六進位數字表示），就會得到以下項目：

```
0x0000001234 | 4567890
```

`4567890` 的部分被丟棄，剩下的只有：

```
Stack
0x1234
```

所有前導零都不影響數值，可以忽略。

---

新的堆疊是：

```
Stack
<function identifier sent in data>
```

下一個指令是 `DUP1`，它會複製堆疊中的第一個項目。現在堆疊變成：

```
Stack
<function identifier sent in data>
<function identifier sent in data>
```

接著是一個 `PUSH3` 指令，後面跟著推入資料（push data）`0xf714ce`。這個操作碼只是把這段推入資料推入堆疊。執行這個操作碼後，堆疊會像這樣：

```
Stack
0xf714ce
<function identifier sent in data>
<function identifier sent in data>
```

現在，`0xf714ce` 看起來眼熟嗎？還記得 `withdraw(uint256,address)` 函式的函式識別碼是什麼嗎？就是 `0x00f714ce`……注意，因為前導零可以忽略，所以它們是同一個數字。

下一個指令 `EQ` 會從堆疊彈出最上面的兩個項目並加以比較。分派器的主要工作就在這裡：它比較交易的 `msg.data` 欄位中送來的函式識別碼，是否與 `withdraw(uint256,address)` 的函式識別碼相符。如果相等，`EQ` 就把 1 推入堆疊，最後會用來跳到 withdraw 函式；否則，`EQ` 會把 0 推入堆疊。

假設送給合約的交易確實是以 `withdraw(uint256,address)` 的函式識別碼開頭，我們的堆疊就會變成：

```
Stack
1
<function identifier sent in data> (now known to be 0x00f714ce)
```

接下來是 `PUSH2 0x23`，0x23 就是 `withdraw(uint256,address)` 函式在合約中的位置。執行這個指令後，堆疊會像這樣：

```
Stack
0x23
1
<function identifier sent in msg.data>
```

接著是 `JUMPI` 指令，它同樣以堆疊最上面的兩個元素作為引數。在這個例子中是 `JUMPI(0x23, 1)`，告訴 EVM 跳到 `withdraw(uint256,address)` 函式的位置，接著就可以繼續執行該函式的程式碼。

## 圖靈完備與 gas

如前所述，簡單地說，一個系統或程式語言如果能執行任何程式，就是*圖靈完備*的。然而，這項能力伴隨著一個非常重要的但書：有些程式會永遠跑下去。其中一個重點是，我們無法只看程式本身，就判斷它會不會永遠執行下去，必須實際執行這個程式、等它結束，才能知道答案。當然，如果它會永遠執行下去，我們也就得永遠等下去才能知道。這就是所謂的*停機問題*，如果不加以處理，對以太坊來說會是一大問題。

因為停機問題，以太坊世界電腦有可能被要求執行一個永遠不會停止的程式，不論是出於意外還是惡意。我們已經說明過，以太坊就像一臺單執行緒的機器，沒有任何排程器；因此一旦它卡在無窮迴圈裡，以太坊就無法使用了。

不過，gas 提供了解決辦法：如果執行了預先指定的最大計算量之後，執行仍然沒有結束，EVM 就會停止這個程式的執行。這讓 EVM 成為一臺準圖靈完備的機器：它可以執行你交給它的任何程式，但前提是程式要在特定的計算量內終止。在以太坊中，這個上限並不是固定的，你可以付費把它提高到某個最大值（稱為*區塊 gas 上限*），而大家也可以隨著時間同意提高這個最大值。儘管如此，在任何時刻都存在一個上限，執行時消耗太多 gas 的交易就會被停止。

接下來幾節，我們會介紹 gas，詳細探討它如何運作。

### 什麼是 gas？

gas 是以太坊用來衡量在以太坊區塊鏈上執行動作所需的計算與儲存資源的單位。比特幣的交易手續費只考慮交易的大小（以 KB 計）；以太坊則不同，必須計算交易與智能合約程式碼執行時所進行的每一個計算步驟。

交易或合約執行的每個操作，都要花費固定數量的 gas。以太坊「黃皮書」中的一些例子包括：

- 兩個數字相加花費 3 gas
- 計算一次 Keccak-256 雜湊花費 30 gas，外加每 256 位元的待雜湊資料 6 gas
- 送出一筆交易花費 21,000 gas

gas 是以太坊的關鍵組成部分，有兩個作用：一是作為（波動劇烈的）以太幣價格與驗證者工作報酬之間的緩衝，二是用來防禦阻斷服務（DoS）攻擊。為了防止網路中出現意外或惡意的無窮迴圈或其他計算浪費，每筆交易的發起者都必須為自己願意付費的計算量設定上限。gas 系統因此讓攻擊者失去發送「垃圾」交易的誘因，因為他們必須為自己消耗的計算、頻寬與儲存資源按比例付費。

### 執行期間的 gas 計算

當需要 EVM 來完成一筆交易時，一開始會分配給它等同於交易中 gas 上限所指定數量的可用 gas。每個被執行的操作碼都有 gas 成本，因此 EVM 在逐步執行程式的過程中，可用 gas 會越來越少。在每個操作之前，EVM 都會檢查是否有足夠的 gas 支付這個操作的執行。如果 gas 不夠，執行就會停止，交易也會被回復。

如果 EVM 順利執行到最後、沒有耗盡 gas，所用掉的 gas 成本就會依照交易中指定的 gas 價格換算成以太幣，作為交易手續費支付給驗證者：

```
validator fee = gas cost × gas price
```

可用 gas 中剩下的 gas 會退還給發送者，同樣依照交易中指定的 gas 價格換算成以太幣：

```
remaining gas = gas limit – gas cost
refunded ether = remaining gas × gas price
```

如果交易在執行期間「gas 耗盡」，操作就會立即終止，並引發 OOG 例外。交易會被回復，對狀態的所有變更也都會被撤銷。雖然交易沒有成功，發送者仍然要支付交易手續費，因為驗證者已經完成了到那一刻為止的計算工作，必須獲得補償。

#### gas 計算的考量

EVM 能執行的各種操作，其相對的 gas 成本都經過仔細挑選，以盡可能保護以太坊區塊鏈免於攻擊。計算量越大的操作，花費的 gas 越多。例如，執行 `SHA3` 函式的成本（30 gas）是 `ADD` 操作（3 gas）的 10 倍。更重要的是，有些操作（例如 `EXP`）還需要依照運算元的大小額外付費。使用 EVM 記憶體，以及把資料存進合約的鏈上儲存空間，也都有 gas 成本。

讓 gas 成本與資源在現實世界中的成本相符有多重要，在 2016 年就得到了證明：當時有攻擊者發現並利用了成本上的不一致。這次攻擊產生了計算成本非常高的交易，讓以太坊主網幾乎陷入停頓。這個不一致後來透過一次硬分叉（代號「Tangerine Whistle」）調整相對的 gas 成本而解決。

#### 以太坊未來的 gas 計算

gas 計量過去是、現在仍然是以太坊處理網路中所有交易負載的一個極為重要的部分。必須了解的是，gas 成本是某些行為的關鍵誘因。未來，不同操作碼消耗的 gas 數量可能會有一些變化。

例如，在引進 EIP-4844 blob 交易的 Cancun 升級之前，所有 L2 都是把資料當作交易 calldata 的一部分發布到以太坊上。這些資料會永遠儲存在以太坊的所有節點上。既然 L2 現在有了更好的方式（blob 交易）把資料發布到以太坊上，未來 calldata 有可能變得比現在更貴，以鼓勵 rollup 使用 blob 交易，並減輕節點永遠儲存所有這些資料的負擔。

#### gas 成本與 gas 價格

*gas 成本*衡量的是交易在 EVM 中使用的計算與儲存量，而 gas 本身也有以以太幣計價的*價格*。進行交易時，發送者會指定自己願意為每單位 gas 支付的 gas 價格（以以太幣計），讓市場決定以太幣價格與計算操作成本（以 gas 衡量）之間的關係：

```
transaction fee = total gas used × gas price paid (in ether)
```

建構新區塊時，以太坊網路上的驗證者可以從待處理的交易中，挑選願意支付較高 gas 價格的交易。因此，出價較高的 gas 價格會讓驗證者更有誘因把你的交易放進區塊，讓它更快得到確認。

實務上，交易的發送者會把 gas 上限設得高於或等於預期會用掉的 gas 數量。如果 gas 上限設得比實際消耗的 gas 還高，發送者就會收到多出部分的退款，因為驗證者只會因自己實際完成的工作而得到補償。

清楚區分 gas 成本與 gas 價格非常重要。複習一下：

- *gas 成本*是執行某個特定操作所需的 gas 單位數。
- *gas 價格*是你把交易送到以太坊網路時，願意為每單位 gas 支付的以太幣數量。

> **提示**  
>
> 雖然 gas 有價格，但它無法被「擁有」或「花費」。gas 只存在於 EVM 內部，用來計算執行了多少計算工作。發送者被收取的是以以太幣計價的交易手續費；這筆費用為了 EVM 的計算而換算成 gas，最後再換算回以太幣，作為交易手續費支付給驗證者。

#### 負的 gas 成本

以太坊會退還合約執行期間用掉的部分 gas，藉此鼓勵刪除用過的儲存變數。EVM 中只有一個操作具有負的 gas 成本：把某個儲存地址從非零值改為零（`SSTORE[x] = 0`）可以獲得退款。退還的 gas 數量並不固定，取決於這個操作前後該儲存 slot 的值。為了避免退款機制遭到濫用，一筆交易的最高退款額設為 gas 成本總額的五分之一（無條件捨去）。

過去還有另一個具有負 gas 成本的操作：`SELFDESTRUCT`。（透過 `SELFDESTRUCT`）刪除合約可以獲得 24,000 gas 的退款。目前 `SELFDESTRUCT` 操作碼已經棄用，建議不要再使用。

> **提示**  
>
> gas 退款是在交易結束時才套用的。因此，如果交易沒有足夠的 gas 執行到最後，它就會失敗，也不會有任何退款。

### 區塊 gas 上限

區塊 gas 上限是一個區塊中所有交易總共可以消耗的最大 gas 數量。它限制了一個區塊能容納多少筆交易。

例如，假設我們有五筆交易，gas 上限分別設為 30,000、30,000、40,000、50,000 與 50,000。如果區塊 gas 上限是 180,000，那麼其中任意四筆交易都能放進一個區塊，而第五筆就必須等待之後的區塊。如前所述，由驗證者決定要把哪些交易放進區塊。不同的驗證者很可能會選擇不同的組合，主要是因為它們從網路接收到交易的順序不同。

如果驗證者試圖放進一筆所需 gas 超過目前區塊 gas 上限的交易，該區塊就會被網路拒絕。大多數以太坊客戶端會發出類似「transaction exceeds block gas limit」（交易超過區塊 gas 上限）的警告，阻止你發出這樣的交易。根據 [Etherscan](https://etherscan.io) 的資料，在本書撰寫時（2025 年 6 月），以太坊主網的區塊 gas 上限是 3,600 萬 gas，這表示一個區塊大約可以容納 1,428 筆基本交易（也就是 ETH 轉帳，每筆消耗 21,000 gas）。[^tn1]

[^tn1]: 譯註：依照同一句中的數字計算，36,000,000 ÷ 21,000 ≈ 1,714；1,428 筆對應的是 3,000 萬 gas 的區塊 gas 上限（30,000,000 ÷ 21,000 ≈ 1,428），也就是本章後面兩節提到的數值。

#### 誰決定區塊 gas 上限？

在 2021 年 8 月 5 日引進 EIP-1559 之前，礦工（當時以太坊使用以工作量證明為基礎的共識演算法）有一套內建機制，可以對區塊 gas 上限投票，因此後續區塊的容量可以增加或減少。區塊的礦工可以投票把區塊 gas 上限往任一方向調整 1/1024（0.0976%）。結果就是區塊大小可以依照網路的需求調整，並隨著礦工的算力而定。

現在，則是由驗證者對 *gas 目標*（也就是一個區塊平均應該消耗多少 gas）投票，而 gas 上限定義為目標的兩倍。每個驗證者都必須遵守的 1/1024 調整係數，則和以前一樣維持不變。

#### 區塊 gas 上限為什麼不提高？

你可能會想：既然驗證者可以對 gas 目標投票，而 gas 目標又直接決定了 gas 上限，那為什麼區塊 gas 上限不提高到十億，而是幾乎固定在 3,000 萬？更大的區塊 gas 上限，表示一個區塊能放進更多交易，交易對終端使用者來說也就會更便宜。

答案是，提高 gas 上限會帶來一些與網路去中心化有關的缺點。事實上，雖然更大的區塊可以包含更多交易，但這也表示區塊更難及時驗證完成，可能導致使用一般硬體的以太坊節點無以為繼，只剩下強大的伺服器能驗證完整的區塊。不只如此，更大的區塊也意味著狀態成長得更快。最後的結果和前面一樣：只有大型伺服器才能完整地執行節點。

從歷史上看，區塊 gas 上限都是在協議升級時一次提高的，如圖 14-25 所示。而它的值通常會設定在核心開發者建議的水準，在這個水準下，我們能確定所有客戶端都能應付交易負載，並及時處理區塊。

![以太坊平均 gas 上限圖表](images/ch14/maet_1425.png)

圖 14-25. 以太坊平均 gas 上限圖表

#### 為什麼不提高區塊 gas 上限？

雖然區塊 gas 上限看起來已經「固定」在 3,000 萬超過三年了，但在提議者與建構者分離（PBS）的機制下（見「無狀態以太坊」一節），由擁有精密硬體的參與者（建構者）建構區塊，再交給提議者（驗證者）發布到 P2P 網路上；在這種情況下，存在一種誘因：讓區塊 gas 上限無限提高，同時讓實際使用的 gas 幾乎維持不變。

事實上，依照 EIP-1559，如果區塊 gas 目標遠高於實際使用的 gas，基本費用就會不斷下降，最後幾乎所有的 gas 費用都會歸驗證者所有，而不是被銷毀（基本費用會被銷毀，也就是把那些 ETH 從供給中移除）。

因此，對驗證者來說有兩個好處：

- 他們可以把 gas 費用留給自己，而不是銷毀它們、減少 ETH 的供給。
- 必要時，他們可以建立更大的區塊，捕捉大量的最大可提取價值（MEV）活動，為自己賺取更多費用。

如果你對這個主題有興趣，可以閱讀 [James Prestwich 的文章](https://oreil.ly/EImcE)。

## 具體實作

每個以太坊節點都有本章所描述的 EVM 的具體實作。以下列出最有名、也最常用的幾個：

**Go-ethereum EVM**

Geth 是採用最廣、也最老牌的執行層客戶端，包含一套以 Go 撰寫的完整 EVM 實作。

**Execution-spec EVM**

以太坊基金會在 GitHub 上維護一個 Python 儲存庫，內容是與以太坊執行層客戶端有關的規格。其中有一套以 Python 撰寫的完整 EVM 實作。

**Revm**

Revm 有極佳的可自訂性與適應性，因此是一般以太坊客戶端以外最常用的 EVM 實作之一。

**Evmone**

Evmone 大概是最快的 EVM 實作。它以 C++ 撰寫，由以太坊基金會的 Ipsilon 團隊維護。

**Besu EVM**

Besu 是由 Consensys 維護的執行層客戶端，有一套以 Java 撰寫的完整 EVM 實作。

**Nethermind EVM**

Nethermind EVM 是以 C# 撰寫的執行層客戶端，維護著一套完整的 EVM 實作。

## EVM 最大的升級：EVM 物件格式

*EVM 物件格式*（EVM Object Format，EOF）是 EVM 自 2015 年誕生以來最大的一次升級。事實上，雖然 EVM 過去也經歷過一些修改，但主要集中在 gas 計量方面或新增操作碼，EVM 幾乎和 Gavin Wood 最初創造它時一模一樣。

EVM 仍然很出色。今天在以太坊（以及所有其他與 EVM 相容的區塊鏈）上發生的一切活動，都要歸功於它才得以實現。但它也並不完美，近幾年來，智能合約開發者不得不應付它的種種面向，並學會一些技巧來克服它的限制。

EOF 是一種可擴充、有版本編號的 EVM 容器格式，只在部署時進行一次性的驗證。本節會探討 EVM 所有主要的限制，以及 EOF 打算如何克服它們。

> **備註**  
>
> 截至本書最後一次修訂時（2025 年 6 月），EOF 升級已因以太坊社群內部的共識不足而無限期延後。目前沒有明確的實施時程，最後也可能永遠不會被採用。儘管如此，我們認為本節對於理解 EOF 可能如何影響 EVM 與更廣泛的以太坊生態系，仍然很有價值。

### JUMPDEST 分析

舊版 EVM 在合約建立時，不會驗證發布到鏈上的位元組碼。一方面，這看起來似乎不錯，因為你想發布什麼合約都可以：你可以部署包含不存在的操作碼的位元組碼、加入永遠不會執行到的程式碼，或是在 `PUSH` 操作的中間截斷，不提供它正確執行所必需的下一個立即值。但這其實帶來了許多低效率。事實上，EVM 必須在執行期檢查一切，這增加了複雜度，也拖慢了整體效能。以下是一個在 EVM 位元組碼中包含不存在的操作碼的例子：

```
600C600052602060000C
```

以下是把這段位元組碼轉換成人類可讀的操作碼：

```
[00]            PUSH1            0C
[02]            PUSH1            00
[04]            MSTORE
[05]            PUSH1            20
[07]            PUSH1            00
[09]            NOT-EXISTING
```

操作碼 `0C` 並不存在，當 EVM 執行到那裡時，就會發生 panic 並提早返回。注意，前面這段位元組碼的第二個位元組也是 `0C`，但 EVM 並沒有在那裡失敗。差別在於，最後那個 `0C` 位元組被解讀為操作碼，因為無效而失敗；另一個則因為是第一個 `PUSH1` 操作碼的立即值，而被解讀為推入資料。

這種執行期檢查的一個關鍵部分，就是 *JUMPDEST 分析*。每次執行合約時，每個客戶端都需要在執行期進行這項分析。讓我們花點時間了解 JUMPDEST 分析，以及舊版 EVM 為什麼需要它。

> **提示**  
>
> 為了不必在每次呼叫合約時都在執行期進行 JUMPDEST 分析，有些以太坊節點實作會為每個合約儲存一份 JUMPDEST 對照表（jumpdest map）。這份 JUMPDEST 對照表在合約部署時建立，並存放在節點的資料庫中。

舊版 EVM 只有動態跳躍（`JUMP` 與 `JUMPI` 操作碼）可以管理位元組碼的控制流程。這非常方便，因為只要兩個操作碼，就能改變一般的操作流程。缺點是動態跳躍非常昂貴，需要在執行期進行深入的驗證，即使大多數時候，跳躍根本不需要是動態的。事實上，要跳躍的目標值，往往就是在 `JUMP` 操作碼的前一個指令才推入堆疊的。以下是一個小例子：

```
…6009566006016101015b6001…
```

轉換成人類可讀的操作碼如下：

```
[00]            PUSH1            09
[02]            JUMP
[03]            PUSH1            06
[05]            ADD
[06]            PUSH2            0101
[09]            JUMPDEST
[0a]            PUSH1            01
```

如你所見，跳躍目的地（也就是要跳到的偏移量 `0x09`）只是在 `JUMP` 操作碼的前一個指令，透過 `PUSH1` 操作碼推入堆疊而已。EVM 把 `0x09` 推入堆疊，接著執行 `JUMP` 操作碼；這個操作碼以先前推入的 `0x09` 作為輸入，把執行移到該偏移量的指令。在 `0x09` 處有一個 `JUMPDEST` 操作碼，因此它被視為有效的跳躍目的地，執行可以正確地繼續下去。

為了避免跳到無效的目的地，必須在執行期進行驗證。有效的目的地只有不屬於推入資料的 `JUMPDEST` 指令。這一點非常重要：舊版 EVM 並沒有把程式碼與資料適當地分開。因此，每當你在某段位元組碼中遇到 `0x5b` 這個位元組（也就是 `JUMPDEST` 操作碼），如果不把整個合約分析一遍，就無法完全確定它是真正的 `JUMPDEST` 操作碼，還是推入資料的一部分。

看看以下這個呈現這種細微差異的例子：

```
…6009566006016101015b6001…
…6009566006016201015b6001…
```

這兩段位元組碼看起來幾乎一模一樣；事實上，它們只差了一個位元。[^tn2]但這就足以讓結果天差地遠。第一段位元組碼和前一個例子中的相同。第二段以人類可讀的格式表示如下：

[^tn2]: 譯註：兩段位元組碼不同的地方，是第一段的 `61`（PUSH2）與第二段的 `62`（PUSH3）。兩段位元組碼只有這一個位元組不同，但這兩個位元組以二進位表示分別是 0110 0001 與 0110 0010，其實相差兩個位元；原文的意思應該是「只差一個位元組」。

```
[00]            PUSH1            09
[02]            JUMP
[03]            PUSH1            06
[05]            ADD
[06]            PUSH3            01015b
[0a]            PUSH1            01
```

如果你試著執行第二段程式碼，它會因為無效的跳躍目的地而失敗。這看起來可能有點奇怪，因為在偏移量 `0x09` 處仍然是代表 `JUMPDEST` 操作碼的 `0x5b` 位元組。問題在於，在這個例子中，`0x5b` 位元組是推入資料的一部分，因此不能視為有效的跳躍目的地。這就是執行在那裡失敗的原因。

JUMPDEST 分析是分析合約、找出哪些跳躍目的地有效、哪些無效的過程，讓 EVM 執行合約時能偵測到無效的跳躍目的地並 panic。

假設你送出一筆與合約 A 互動的交易。EVM 載入合約 A 時，會立刻進行 JUMPDEST 分析，把有效跳躍目的地的對照表存起來，然後才開始真正執行這筆交易：

```
…6009566006016101015b60016015566006016201015b6001…
```

以人類可讀的格式表示如下：

```
[00]            PUSH1            09
[02]            JUMP
[03]            PUSH1            06
[05]            ADD
[06]            PUSH2            0101
[09]            JUMPDEST
[0a]            PUSH1            01
[0c]            PUSH1            15
[0e]            JUMP
[0f]            PUSH1            06
[11]            ADD
[12]            PUSH3            01015b
[16]            PUSH1            01
```

EVM 會快速掃過整段位元組碼，建立一份對照表，把每個 `0x5b` 位元組標記為有效或無效的跳躍目的地，如圖 14-26 所示。

![客戶端建立 JUMPDEST 對照表，區分有效與無效的跳躍目的地](images/ch14/maet_1426.png)

圖 14-26. 客戶端建立 JUMPDEST 對照表，區分有效與無效的跳躍目的地

### 新增與棄用功能

新增或棄用一個操作碼或某項功能，並不像看起來那麼容易。雖然確實已經新增過不少操作碼，例如 `BLOBHASH`、`BLOBBASEFEE`、`BASEFEE` 等等，但由於 EVM 的位元組碼沒有結構、也沒有經過驗證，這件事總是很複雜。

看看以下這個例子，其中包含一個無效的操作碼，也就是 `0x0C`。假設這是一個實際部署在以太坊主網上的合約：

```
600C600052602060000C
```

以人類可讀的格式表示如下：

```
[00]            PUSH1            0C
[02]            PUSH1            00
[04]            MSTORE
[05]            PUSH1            20
[07]            PUSH1            00
[09]            NOT-EXISTING
```

如果你試著在 EVM 中執行這一小段位元組碼，會看到執行到那個不存在的操作碼時就失敗了。

假設未來某次升級新增了一個操作碼 `MAX`，它從堆疊取出兩個項目，回傳其中值較大的那一個，分配給它的位元組是 `0x0C`。再看一次前面的位元組碼（記住，我們假設它是部署在主網上的真實合約）：

```
[00]            PUSH1            0C
[02]            PUSH1            00
[04]            MSTORE
[05]            PUSH1            20
[07]            PUSH1            00
[09]            MAX
```

現在，這段位元組碼的結果完全不同了。事實上，它不再失敗，而是順利返回。如果有其他合約依賴「這個合約因為（以前）不存在的操作碼而一定會失敗」這個假設，就可能出問題。

棄用功能更困難，因為 EVM 沒有版本系統可以依靠。所以，如果你移除某個操作碼或改變它的運作方式，原本使用它的舊合約就可能壞掉，而除了人工介入（建立新合約）之外，沒有任何辦法可以修復。

[EIP-2929](https://oreil.ly/_9kTv) 改變存取狀態的操作碼的 gas 計量方式時，有些合約因為把要使用或預期的 gas 數量寫死在程式碼中而壞掉了。讓它們恢復運作的解決辦法，是引進*存取清單*：你可以預先載入已知交易會用到的一些帳戶與儲存 slot，藉此降低 gas 成本。

舊版 EVM 讓升級更困難的其他重要因素，還有*程式碼自省*與 *gas 可觀測性*（gas observability）。gas 可觀測性來自 `GAS` 這類操作碼，甚至所有以 gas 作為輸入的 `*CALL` 操作碼；程式碼自省則是透過 `CODESIZE`、`CODECOPY`、`EXTCODESIZE`、`EXTCODECOPY` 與 `EXTCODEHASH` 等操作碼達成的。

問題在於，如果 EVM 能在執行的某個時間點取得剩餘的 gas，智能合約的邏輯就可能依賴這個值。而如果未來某些操作碼的 gas 計量方式改變了（這種事並不罕見），所有依賴舊 gas 計量方式的智能合約都可能出問題。程式碼自省也是同樣的道理。

> **備註**  
>
> 少了程式碼自省，未來版本的 EOF 就有可能把所有合約的程式碼自動轉換成新虛擬機上功能相同的程式碼，藉此把底層的虛擬機完全換成 Cairo VM、Wasm 或任何其他虛擬機。

### 程式碼與資料分離

舊版 EVM 不會對發布到鏈上的位元組碼強加任何結構。真正的程式碼和程式碼中使用的資料之間沒有區別。一切都只是位元組，由 EVM 在執行期間逐步解讀。

不看整個合約，就無法斷定位元組碼的某個部分是程式碼還是資料。看看以下這個例子：

```
…730102030405060708090a0b0c0d0e0f101112131431…
[00]            PUSH20    0102030405060708090a0b0c0d0e0f1011121314
[15]            BALANCE
```

不仔細研究程式碼，你無法馬上看出 `0102030405060708090a0b0c0d0e0f1011121314` 不應該被解讀成一連串的操作碼（`0x01`：`ADD`、`0x02`：`MUL`，依此類推），而是代表一個固定地址的推入資料，我們想查詢這個地址的餘額。這對靜態分析工具與形式化驗證都很不利，也讓智能合約更難直接在鏈上正確處理可執行的程式碼。

### stack too deep 錯誤

接下來，我們要看看 EVM 最讓人討厭的限制之一：「stack too deep」錯誤。如果你試著編譯以下這個智能合約，馬上就會遇到它：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

contract StackTooDeep {
    function add(
        uint256 a,uint256 b,uint256 c,uint256 d,uint256 e,uint256 f,uint256 g,uint256 h,uint256 i
    ) external pure returns(uint256) {
        return a+b+c+d+e+f+g+h+i;
    }
}
```

以下是試著編譯這個合約時的輸出：

```
solc StackTooDeep.sol --bin
Error: Stack too deep. Try compiling with `--via-ir` (cli) or the equivalent `viaIR: true` (standard JSON) while enabling the optimizer. Otherwise, try removing local variables.
 --> StackTooDeep.sol:8:16:
  |
8 |         return a+b+c+d+e+f+g+h+i;
  |                                ^
```

這個錯誤相當隱晦，因為它是 EVM 運作方式的直接結果。事實上，雖然可以推入堆疊的項目最多有 1,024 個，但 EVM 只能透過 `DUP1..16` 與 `SWAP1..16` 這類操作碼，輕鬆存取其中最上面的 16 個元素。

在我們的 `StackTooDeep` 例子中，`add` 函式接受九個不同的參數，每個參數都必須放到堆疊上。接著，它要進行八次加法才能得到最終結果。問題就出在這些細節上。雖然最後的運算看起來像是一次大的加法，但實際上，編譯器必須把每一次加法拆開，並建立一個暫存變數來保存需要存進堆疊的中間結果。所以最後我們會有九個參數加上八個中間結果，總共需要 17 個堆疊項目。當編譯器試圖引用堆疊中第 17 個或更深位置的變數時，就會失敗，因為它沒有任何能輕鬆存取那個位置的操作碼。

為了更清楚地呈現這個問題，你可以看看圖 14-27，圖中詳細列出了每一步的堆疊組成。你很容易就能看出，執行到最後時，變數 `i` 位於深度 17 的位置。編譯器不允許區域變數或參數在函式的作用域中無法輕鬆存取，因此會丟出「stack too deep」錯誤。

![每一步的堆疊組成](images/ch14/maet_1427.png)

圖 14-27. 每一步的堆疊組成

這只是一個非常簡單的例子，呈現了智能合約開發者在日常工作中必須克服的問題之一。雖然編譯器在自動分析與處理這類情況方面已經越來越進步，但 EVM 目前的運作方式仍然帶來了一些硬性的限制。

### EOF

EOF 引進了一種在部署時驗證的 EVM 位元組碼容器格式、一套版本系統，以及程式碼與資料的完全分離，藉此解決上述所有問題。以下是一段有效的 EOF 位元組碼範例：

```
EF00010100040200010008030001003004002000008000045F5FD1005FEC0000EF00010100040200010004030001001404000000008000025F5FEE00EF00010100040200010001040000000080000000000102030405060708090a0b0c0d0e0f10111213141516171819101a1b1c1d1e
```

轉換成人類可讀的格式如下：

```
Magic bytes                      EF00
EOF version                      01
Stack validation data            01 0004
Code sections                    02 0001 0008
Subcontainer section size        03 0001 0030
Data section size                04 0020
Header terminator                00
Stack: #ins, #outs, max stack    00 80 0004
Code                             5F5FD1005FEC0000
Subcontainers                    EF00010100040200010004030001001404000000008000025F5FEE00
                                 EF00010100040200010001040000000080000000
Data                             000102030405060708090a0b0c0d0e0f10111213141516171819101
                                 a1b1c1d1e
```

先別急，接下來幾節會解釋所有內容。

#### 改進之處

JUMPDEST 分析，以及所有與 gas 及程式碼自省有關的操作碼，都被完全移除，現在被視為未定義。程式碼區段中的所有操作碼都必須有效，立即值（例如推入資料）必須確實出現在程式碼中，而且不能有執行不到的指令。堆疊驗證也在建立合約時進行。這使得執行期間不可能發生堆疊下溢或溢位，也就不必在執行期進行所有這些檢查，因為合約在部署時已經通過驗證，EVM 可以假設它們已經遵守所有規則。

> **提示**  
>
> 這些驗證保證，讓把 EVM 位元組碼預先編譯或即時編譯成機器原生程式碼變得更加可行。

動態跳躍也被移除了，改為透過三個新的操作碼 `RJUMP`、`RJUMPI` 與 `RJUMPV` 引進靜態相對跳躍；這些操作碼和 `PUSH` 操作碼一樣接受立即值。注意，EOF 之所以能新增接受立即值的指令，是因為不再有 JUMPDEST 分析，一切都在建立時檢查，而不是在執行期檢查。

從上一節的 EOF 容器可以看到，EOF 引進了*函式*（也就是程式碼區段）的概念，並為每個函式隔離各自的堆疊。舊版 EVM 只能依靠動態跳躍來模擬這種行為：Solidity 或 Vyper 的函式只是一種內部的表示方式。

為此，EOF 新增了 `CALLF`、`RETF` 與 `JUMPF` 三個操作碼，以及一個*回傳堆疊*（與 EVM 平常的運算元堆疊完全分開）。具體來說，需要回傳堆疊，是為了在跳進函式之前保存執行資訊，這樣才能在不遺失資料的情況下返回呼叫者。圖 14-28 能幫助你更清楚地了解它的運作方式。

![EOF 引進了函式（程式碼區段）的概念](images/ch14/maet_1428.png)

圖 14-28. EOF 引進了函式（程式碼區段）的概念

「stack too deep」問題則透過新增三個操作碼來解決：`DUPN`、`SWAPN` 與 `EXCHANGE`。前兩個指令類似舊有的 `DUP1..16` 與 `SWAP1..16`，唯一的差別是它們接受一個立即值，代表要複製或交換的項目索引。這個索引最高可以到 256，遠高於以往 16 的硬性上限。

`EXCHANGE` 是一個新的操作碼，可以交換堆疊中兩個不同的項目（注意，`SWAPN` 一律是把第 n 個項目與第一個項目交換，而 `EXCHANGE` 可以讓任意兩個項目互相交換）。這對實作 *堆疊排程演算法*（stack-scheduling algorithm）的編譯器特別有用；這類演算法會根據一組變數與使用情形的分析，盡量減少堆疊上的資料搬移。

在 EOF 合約中，`CREATE` 與 `CREATE2` 已經被淘汰，改為引進 `EOFCREATE` 與 `RETURNCONTRACT`，作為建立新 EOF 合約的方式。

最後，新增了新的 `CALL` 指令，取代被移除的舊指令：`EXTCALL`、`EXTDELEGATECALL`、`EXTSTATICCALL` 與 `RETURNDATALOAD`。它們不允許指定 gas 上限（沒有 gas 可觀測性），也不需要讓 EVM 存放子呼叫回傳資料的輸出緩衝區。引進 `RETURNDATALOAD`，就是專門為了把最後一次執行的子呼叫的回傳資料，放到呼叫者的堆疊上。

#### EOF 實際運作

讓我們分析本節一開始展示的 EOF 合約：

```
EF00010100040200010008030001003004002000008000045F5FD1005FEC0000EF00010100040200010004030001001404000000008000025F5FEE00EF00010100040200010001040000000080000000000102030405060708090a0b0c0d0e0f10111213141516171819101a1b1c1d1e
```

首先是 EOF 標頭，由以下部分組成：

```
Magic bytes                    EF00
```

需要魔術位元組（magic bytes），是為了區分 EOF 合約與舊版合約（多虧了 EIP-3541，以太坊主網上沒有其他合約是以 `EF00` 開頭的）。

接著是 EOF 版本，讓 EOF 格式未來能以平順的方式升級：

```
EOF version                    01
```

堆疊驗證資料一律以識別碼 `01` 開頭，後面接著「Stack」部分的大小。在這個例子中，「Stack」區段長 4 個位元組：

```
Stack validation data            01 0004
```

程式碼區段以識別碼 `02` 開頭，後面接著程式碼區段（也就是函式）的數量，以及各自的大小。這裡有一個程式碼區段，長 8 個位元組：

```
Code sections                02 0001 0008
```

子容器（subcontainer）區段大小以識別碼 `03` 開頭，後面接著子容器的數量，以及各自的大小。這裡有一個子容器，長 48 個位元組（記住，這裡一律是十六進位格式）：

```
Subcontainer section size        03 0001 0030
```

資料區段大小以識別碼 `04` 開頭，後面接著資料區段的大小。這裡的資料區段有 32 個位元組：

```
Data section size                04 0020
```

最後是標頭結束符號 `00`，一律代表 EOF 標頭的結尾：

```
Header terminator                00
```

堆疊區段列出每個程式碼區段（這個例子中只有一個）的輸入數量、輸出數量與最大堆疊高度。這裡的輸入數量為零，而且是一個不會返回的函式（`80` 是代表不返回函式的特殊位元組），堆疊的最大高度等於 4：

```
Stack: #ins, #outs, max stack        00 80 0004
```

接下來是所有的程式碼區段，其中包含由 EVM 執行的 EVM 位元組碼：

```
Code                        5F5FD1005FEC0000
```

這裡只有一個函式（程式碼區段），包含以下操作碼：

```
PUSH0 PUSH0 DATALOADN 0 PUSH0 EOFCREATE 0 STOP
```

這段程式碼先透過前兩個 `PUSH0` 操作碼，把 `0-0` 推入堆疊。接著，它從資料區段的偏移量零（程式碼中的下一個立即值）開始讀取 32 個位元組，推入堆疊。然後，透過最後一個 `PUSH0` 再推入一個 `0`。最後，以 `0` 作為立即值引數呼叫 `EOFCREATE`，它會呼叫第一個子容器的第一個程式碼區段：

```
Subcontainers                EF00010100040200010004030001001404000000008000025F5FEE00EF0001
                             0100040200010001040000000080000000
```

子容器區段包含了這段 EOF 位元組碼中所有的 EOF 子容器。在這個例子中，只有一個子容器。子容器本身也是 EOF 格式的位元組碼：概念是你可以把 EOF 容器巢狀放進其他 EOF 容器中。這對工廠合約（factory contract）很有用。

最後是資料區段，包含合約執行所需的所有資料。這裡有 32 個位元組的資料：

```
Data                        000102030405060708090a0b0c0d0e0f10111213141516171819101a1b1c1d1e
```

這套分析也可以遞迴地套用到這段 EOF 位元組碼的子容器上，以完全了解它在做什麼；如果你有興趣更深入 EVM 這個無底洞，就留給你自己探索吧。

## EVM 的未來

除了 EOF 之外，EVM 的未來還不確定，將取決於開發者與各個專案如何使用 EVM。不過，EVM 仍有一些值得關注、可以擴展的方向，例如 *zk-EVM*：它會為每個區塊附上零知識證明（zero-knowledge proof），證明區塊的執行是正確的。此外，[*EVMMAX*](https://oreil.ly/ioqSx) 與 [*SIMD*](https://oreil.ly/7q0Dq) 能讓 EVM 更強大，大幅加快大量密碼學運算的速度，這對隱私協議或 L2 這類仰賴密碼學的應用特別有幫助。

## 結論

本章探討了 EVM，追蹤了各種智能合約的執行過程，並了解 EVM 如何執行位元組碼。我們也介紹了 EVM 的計算機制 gas，看到它如何解決停機問題，並保護以太坊免於阻斷服務攻擊。此外，我們分析了 EOF，看看它如何試圖修正舊版 EVM 的種種缺陷。

接下來，在第 15 章，我們會探討以太坊用來達成去中心化共識的機制。
