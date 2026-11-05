# 第 7 章　智能合約與 Solidity

我們在第 2 章討論過，以太坊有兩種不同類型的帳戶：外部擁有帳戶（EOA）與合約帳戶。EOA 由使用者控制，通常是透過以太坊平台之外的軟體，例如錢包應用程式。相較之下，合約帳戶則由以太坊虛擬機（EVM）執行的程式碼控制，這些程式碼也常被稱為*智能合約*。

簡單地說，EOA 是單純的帳戶，沒有任何相關聯的程式碼或資料儲存空間；合約帳戶則同時具有相關聯的程式碼與資料儲存空間。EOA 由交易控制，這些交易是在協議之外、獨立於協議的「真實世界」中建立，並以私鑰進行密碼學簽署；合約帳戶則沒有私鑰，因此會依照智能合約程式碼預先規定的方式「自己控制自己」。這兩種帳戶都以一個以太坊地址來識別。本章要討論的是合約帳戶，以及控制合約帳戶的程式碼。

## 什麼是智能合約？

這些年來，*智能合約*一詞被用來描述各式各樣的東西。1990 年代，密碼學家 Nick Szabo 創造了這個詞，並把它定義為「一組以數位形式規定的承諾，包括各方據以履行這些承諾的協議」。從那時起，智能合約的概念不斷演進，尤其是在 2009 年比特幣上線、去中心化的區塊鏈平台問世之後。

在以太坊的脈絡中，這個詞其實有點名不副實，因為以太坊的智能合約既不「智能」，也不是法律上的合約，但這個名稱已經約定俗成了。在本書中，我們用*智能合約*一詞來指稱不可變更的電腦程式；這些程式作為以太坊網路協議的一部分，在 EVM 的環境中以確定性的方式執行，也就是在去中心化的以太坊世界電腦上執行。

我們來拆解這個定義：

**電腦程式**

智能合約就只是電腦程式。在這裡，*合約*一詞沒有任何法律上的意義。

**不可變更**

智能合約的程式碼一旦部署，就不能再更改。和傳統軟體不同，修改智能合約的唯一方法，就是部署一個新的實例。

**確定性**

在給定觸發執行的交易環境，以及執行當下以太坊區塊鏈狀態的情況下，智能合約的執行結果對每個執行它的人來說都相同。

**EVM 環境**

智能合約在非常有限的執行環境中運作。它們可以存取自己的狀態、呼叫它們的交易的環境，以及最近幾個區塊的部分資訊。

**去中心化的世界電腦**

每個以太坊節點上都有一個在本機執行的 EVM 實例；但因為所有 EVM 實例都從相同的初始狀態出發、產生相同的最終狀態，整個系統就像一台單一的「世界電腦」在運作。

## 智能合約的生命週期

智能合約通常以 Solidity 之類的高階語言撰寫。但要能執行，它們必須先編譯成在 EVM 中執行的低階位元組碼。編譯之後，再透過一種特殊的建立合約交易部署到以太坊平台上；這種交易的特徵是 `to` 欄位為空（見第 6 章〈特殊交易：建立合約〉）。每個合約都以一個以太坊地址來識別，這個地址由建立合約的交易推導而來，是發起帳戶與 nonce 的函數。合約的以太坊地址可以作為交易的接收者，用來把資金傳送到合約，或呼叫合約的某個函式。請注意，和 EOA 不同，為新的智能合約所建立的帳戶沒有任何相關聯的金鑰。身為合約的建立者，你在協議層級並不會得到任何特殊權限（不過你可以明確地把這些權限寫進智能合約裡）。你當然也不會拿到合約帳戶的私鑰，因為這把私鑰根本不存在——我們可以說，智能合約帳戶擁有它們自己。

重要的是，合約*只有在被交易呼叫時才會執行*。以太坊上的所有智能合約，歸根究柢都是因為某筆由 EOA 發起的交易而執行的。一個合約可以呼叫另一個合約，而後者又可以再呼叫另一個合約，依此類推；但這條執行鏈上的第一個合約，一定是被 EOA 發出的交易所呼叫的。合約絕不會「自己」執行，也不會「在背景」執行。在交易直接觸發，或作為合約呼叫鏈的一部分間接觸發執行之前，合約實際上一直處於休眠狀態。另外值得一提的是，智能合約在任何意義上都不是「平行」執行的——以太坊世界電腦可以視為一台單執行緒的機器。

不論交易呼叫了多少合約，也不論這些合約被呼叫時做了什麼，交易都是 *原子性*（atomic）的。交易會完整地執行，而且只有在所有執行都成功終止時，全域狀態（合約、帳戶等）的任何變更才會被記錄下來。*成功終止*的意思是：程式在沒有錯誤的情況下執行，並且執行到了結尾。如果執行因為錯誤而失敗，它的所有效果（狀態的變更）都會被「復原」，就像這筆交易從未執行過一樣。失敗的交易仍然會被記錄為曾經嘗試過，而執行時花在 gas 上的以太幣（ether）也會從發起帳戶中扣除，但除此之外，它對合約或帳戶的狀態沒有任何影響。

前面提過，合約的程式碼一旦部署就不能再更改。過去，合約可以被刪除：從它的地址移除程式碼與內部狀態（儲存空間），留下一個空白帳戶。刪除之後，任何送到該地址的交易都不會執行任何程式碼，因為已經沒有程式碼了。這種刪除是透過一個名為 `SELFDESTRUCT` 的 EVM 操作碼完成的；它會提供 gas 退款，藉此提供誘因，讓大家刪除已儲存的狀態、釋放網路資源。不過，由於 `SELFDESTRUCT` 操作需要對帳戶狀態做出重大的變更，尤其是移除所有的程式碼與儲存空間，2023 年的以太坊改進提案（EIP）[EIP-6780](https://oreil.ly/5LcZo) 棄用了這項操作。隨著以太坊路線圖上即將到來的升級，這項操作將不再可行。

## 以太坊高階語言簡介

EVM 是一台虛擬機，執行一種稱為 *EVM 位元組碼*的特殊程式碼，就像你電腦的 CPU 執行 x86_64 之類的機器碼一樣。我們會在第 14 章更詳細地探討 EVM 的運作與語言。本節要看的是，如何撰寫在 EVM 上執行的智能合約。

雖然可以直接用位元組碼撰寫智能合約，但 EVM 位元組碼相當難以駕馭，程式設計師也很難閱讀與理解。因此，大多數以太坊開發者會使用高階語言撰寫程式，再用編譯器把程式轉換成位元組碼。

雖然任何高階語言都可以改造來撰寫智能合約，但要讓任意一種語言能編譯成 EVM 位元組碼，是相當麻煩的工作，而且一般來說也會造成某種程度的混淆。智能合約在一個限制非常多、極度精簡的執行環境（EVM）中運作。此外，還必須提供一組 EVM 特有的系統變數與函式。因此，從頭打造一種智能合約語言，會比讓一種通用語言適合撰寫智能合約來得容易。於是，出現了好幾種專門用來撰寫智能合約的語言。以太坊有好幾種這樣的語言，以及產生 EVM 可執行位元組碼所需的編譯器。

一般來說，程式語言可以分成兩大程式設計典範：*宣告式*與*命令式*，也分別稱為*函數式*與*程序式*。在宣告式程式設計中，我們撰寫的函式表達的是程式的*邏輯*，而不是程式的*流程*。宣告式程式設計用來建立沒有*副作用*的程式，也就是說，函式之外的狀態不會有任何變更。宣告式程式語言包括 Haskell 與 SQL。相對地，在命令式程式設計中，程式設計師撰寫一組結合了程式邏輯與流程的程序。命令式程式語言包括 C++ 與 Java。有些語言是「混合式」的，也就是說，它們鼓勵宣告式程式設計，但也可以用來表達命令式的程式設計典範。這類混合式語言包括 Lisp、JavaScript 與 Python。一般來說，任何命令式語言都可以用來以宣告式典範寫程式，但寫出來的程式碼往往不夠優雅。相較之下，純粹的宣告式語言無法用來以命令式典範寫程式。在純粹的宣告式語言中，沒有所謂的「變數」。

雖然程式設計師比較常使用命令式程式設計，但要寫出完全照預期執行的程式可能非常困難。程式的任何部分都能改變其他任何部分的狀態，這讓人很難推論程式的執行，也帶來許多產生錯誤的機會。相較之下，宣告式程式設計讓人更容易理解程式會有什麼行為：因為它沒有副作用，程式的任何部分都可以單獨理解。

在智能合約中，錯誤真的會讓人賠錢。因此，撰寫不會產生非預期效果的智能合約極為重要。要做到這一點，你必須能夠清楚地推論程式的預期行為。所以，宣告式語言在智能合約中扮演的角色，比在通用軟體中重要得多。然而，你將會看到，最廣泛使用的智能合約語言（Solidity）是命令式的。程式設計師就像大多數人一樣，抗拒改變！

目前支援的智能合約高階程式語言包括下列幾種（依受歡迎程度排序）：

**Solidity**

一種程序式（命令式）程式語言，語法類似 JavaScript、C++ 或 Java。它是以太坊智能合約最受歡迎、最常使用的語言。

**Yul**

一種中介語言，可以獨立使用，也可以以行內的方式寫在 Solidity 中，非常適合跨平台的高階最佳化。初學者應該先從 Solidity 或 Vyper 入門，再來探索 Yul，因為 Yul 需要智能合約安全與 EVM 的進階知識。

**Vyper**

一種合約導向的程式語言，語法類似 Python，把使用者的安全放在第一位，並透過語言設計與高效率的執行，鼓勵清楚的程式寫法。

**Huff**

一種低階程式語言，主要由需要高效率、極度精簡的合約程式碼的開發者使用，能做到超越 Solidity 等較高階語言的進階最佳化。和 Yul 一樣，不建議初學者使用。

**Fe**

一種用於 EVM 的靜態型別智能合約語言，靈感來自 Python 與 Rust。它的目標是容易學習，即使是剛接觸以太坊的開發者也能上手；自 2021 年 1 月推出 alpha 版以來，它的開發仍處於早期階段。

過去也曾開發過其他語言，例如 LLL、Serpent 與 Bamboo，但已經不再維護。

如你所見，可以選擇的語言有很多。不過，在所有這些語言中，Solidity 是目前最受歡迎的，甚至已經成為以太坊，乃至其他類 EVM 區塊鏈事實上的標準高階語言。

## 用 Solidity 打造智能合約

Solidity 由 Gavin Wood（本書第一版的共同作者）創造，是一種專門用來撰寫智能合約的語言，它的功能直接支援在以太坊世界電腦的去中心化環境中執行。由此產生的特性相當通用，因此它最後也被用來為其他好幾個區塊鏈平台撰寫智能合約。Solidity 先由 Christian Reitwiessner 開發，之後由 Alex Beregszaszi、Liana Husikyan、Yoichi Hirai 以及幾位前以太坊核心貢獻者接手。現在，Solidity 是 [GitHub](https://oreil.ly/ik9kH) 上一個獨立開發與維護的專案。

Solidity 專案的主要「產品」是 Solidity 編譯器 solc，它把用 Solidity 語言寫成的程式轉換成 EVM 位元組碼。這個專案也負責管理以太坊智能合約重要的 ABI 標準，我們會在本章詳細探討。每個版本的 Solidity 編譯器都對應並編譯特定版本的 Solidity 語言。

一開始，我們會下載 Solidity 編譯器的二進位執行檔。接著，我們會延續第 2 章開始的範例，開發並編譯一個簡單的合約。

### 選擇 Solidity 版本

Solidity 遵循一種稱為[*語意化版本*](https://semver.org)的版本模型，版本號由三個以點分隔的數字組成：MAJOR.MINOR.PATCH。有重大且不向下相容的變更時，「主要」版本號就會遞增；在兩個主要版本之間加入向下相容的功能時，「次要」版本號會遞增；修正向下相容的錯誤時，「修補」版本號會遞增。

在撰寫本書時，Solidity 的版本是 0.8.26。主要版本 0 是專案的初期開發階段，規則不太一樣：任何東西都可能隨時改變。實務上，Solidity 把「次要」版本號當成主要版本，把「修補」版本號當成次要版本。因此，在 0.8.26 中，8 被視為主要版本，26 則是次要版本。你在第 2 章看過，Solidity 程式可以包含一個 pragma 指令，指定與程式相容、可以用來編譯合約的 Solidity 最低與最高版本。由於 Solidity 演進得很快，通常最好安裝最新的版本。

> **備註**
>
> Solidity 快速演進的另一個後果，是文件過時的速度很快。我們目前使用的是 Solidity 0.8.26 版，本書的所有內容都以這個版本為準。雖然本書始終能為你學習 Solidity 打下扎實的基礎，但未來的版本可能會改變部分語法與功能。所以，每當你有疑問或遇到新東西時，最好查閱 [Solidity 官方文件](https://oreil.ly/LzV7L)，掌握最新的資訊。

### 下載並安裝 Solidity

依照你的作業系統與需求，有好幾種方法可以下載並安裝 Solidity：下載二進位發行版，或從原始碼編譯。你可以在 [Solidity 文件](https://oreil.ly/JW--z)中找到詳細且最新的說明。

以下示範如何在 Ubuntu／Debian 作業系統上，使用 apt 套件管理工具安裝最新的 Solidity 二進位發行版：

```bash
$ sudo add-apt-repository ppa:ethereum/ethereum
$ sudo apt update
$ sudo apt install solc
```

安裝 solc 之後，執行下列指令確認版本：

```bash
$ solc --version
solc, the solidity compiler commandline interface
Version: 0.8.26+commit.8a97fa7a.Linux.g++
```

### 開發環境

雖然完全可以只用簡單的文字編輯器開發 Solidity 智能合約，但善用 [Hardhat](https://hardhat.org) 或 [Foundry](https://oreil.ly/-7Qvy) 之類的開發框架，能大幅提升你身為開發者的效率與成效。這些框架提供了一整套工具，能簡化並改善開發流程。例如，它們提供完善的測試環境，讓你撰寫並執行單元測試，驗證合約的行為；它們也提供分叉功能，在本機建立主網的實例，模擬真實的測試情境。透過進階的除錯與追蹤功能，你可以輕鬆地逐步追蹤程式碼的執行，快速找出並解決問題，節省時間、減少錯誤。此外，這些框架還支援腳本與自動化部署、能擴充功能的外掛生態系，以及在不同環境之間無縫切換的網路管理。把這些功能整合進你的工作流程，就能確保更高的程式碼品質與安全性，這是只用簡單的文字編輯器很難達到的。

除了框架之外，採用 VS Code 這類現代的 IDE 也能進一步提升生產力。VS Code 提供各式各樣的 Solidity 擴充套件，包括讓程式碼更容易閱讀的語法突顯；幫助你組織與瀏覽複雜專案的進階註解與書籤工具；以及能讓你深入了解程式碼結構與潛在問題的視覺化分析工具。此外也有網頁版的開發環境，例如 [Remix IDE](https://oreil.ly/Fz0jJ)。

這些工具結合起來，不僅能提升程式碼品質，也能加快開發流程，讓我們更快速、更安全地打造並部署智能合約。

### 撰寫簡單的 Solidity 程式

我們在第 2 章寫了第一個 Solidity 程式。當時第一次建立 `Faucet` 合約時，我們用 Remix IDE 編譯並部署合約。本節會重新檢視 `Faucet`，並加以改善、充實。

我們第一次嘗試寫出的合約如範例 7-1 所示。

**範例 7-1. Faucet.sol：實作水龍頭的 Solidity 合約**

```solidity
// SPDX-License-Identifier: GPL-3.0
// Our first contract is a faucet!
contract Faucet {
    // Give out ether to anyone who asks
    function withdraw(uint _withdrawAmount, address payable _to) public {
        // Limit withdrawal amount
        require(_withdrawAmount <= 100000000000000000);
        // Send the amount to the address that requested it
        _to.transfer(_withdrawAmount);
    }
    // Accept any incoming amount
    receive() external payable {}
}
```

我們在第 2 章看過，註解中的 SPDX 授權識別碼表示這個智能合約採用 GPL-3.0 授權，告知使用者與開發者在使用與散布這份程式碼時的法律權利與義務。

### 使用 Solidity 編譯器（solc）編譯

現在，我們要在命令列上使用 Solidity 編譯器，直接編譯我們的合約。Solidity 編譯器 solc 提供了各種選項，傳入 `--help` 引數就能看到。

我們使用 solc 的 `--bin` 與 `--optimize` 引數，為範例合約產生最佳化的二進位檔：

```bash
$ solc --optimize --bin Faucet.sol
======= Faucet.sol:Faucet =======
Binary:
6080604052348015600e575f5ffd5b5060fa8061001b5f395ff3fe608060405260043610601d575f3560e01c806
2f714ce146027575f5ffd5b36602357005b5f5ffd5b3480156031575f5ffd5b506041603d366004608d565b6043
565b005b67016345785d8a00008211156056575f5ffd5b6040516001600160a01b0382169083156108fc0290849
05f818181858888f193505050501580156088573d5f5f3e3d5ffd5b505050565b5f5f60408385031215609d575f
5ffd5b8235915060208301356001600160a01b038116811460b9575f5ffd5b80915050925092905056fea264697
06673582212208935b6cf5d9070b7609ad59ac4b727e512522c674cacf09a2eff88dafa3242ee64736f6c634300
081b0033
```

solc 產生的結果是一段以十六進位序列化的二進位資料，可以提交到以太坊區塊鏈上。

## 以太坊合約 ABI

在電腦軟體中，*應用程式二進位介面*（application binary interface，ABI）是兩個程式模組之間的介面，通常是作業系統與使用者程式之間的介面。ABI 定義了如何在*機器碼*中存取資料結構與函式；請不要把它和 API 混淆，API 是以高階、通常人類可讀的格式，在*原始碼*中定義這種存取方式。因此，ABI 是把資料編碼成機器碼、從機器碼解碼出資料的主要方式。

在以太坊中，ABI 用來為 EVM 編碼合約呼叫，以及從交易中讀出資料。ABI 的目的是定義合約中可以被呼叫的函式，並描述每個函式如何接受引數、如何回傳結果。

合約的 ABI 以 JSON 陣列的形式指定，內容是函式描述（見「函式」一節）與事件描述（見「事件」一節）。函式描述是一個 JSON 物件，具有 `type`、`name`、`inputs`、`outputs`、`constant` 與 `payable` 等欄位。事件描述物件則具有 `type`、`name`、`inputs` 與 `anonymous` 等欄位。

我們用命令列的 Solidity 編譯器 solc，為範例合約 *Faucet.sol* 產生 ABI：

```bash
$ solc --abi Faucet.sol
======= Faucet.sol:Faucet =======
Contract JSON ABI
[{"inputs":[{"internalType":"uint256","name":"withdrawAmount","type":"uint256"}],
"name":"withdraw","outputs":[],"stateMutability":"nonpayable","type":"function"},
{"stateMutability":"payable","type":"receive"}]
```

如你所見，編譯器產生了一個 JSON 陣列，描述 *Faucet.sol* 定義的兩個函式。合約部署之後，任何想要存取 `Faucet` 合約的應用程式都可以使用這份 JSON。透過 ABI，錢包或去中心化應用（DApp）瀏覽器之類的應用程式，就能以正確的引數與引數型別，建構呼叫 `Faucet` 函式的交易。例如，錢包會知道，要呼叫 `withdraw` 函式，就必須提供一個名為 `withdrawAmount`、型別為 `uint256` 的引數。[^tn1]錢包可以提示使用者提供這個值，再建立一筆交易，把這個值編碼進去並執行 `withdraw` 函式。

[^tn1]: 譯註：範例 7-1 的 `withdraw` 函式其實有兩個參數：`uint _withdrawAmount` 與 `address payable _to`。上面的 ABI 輸出只列出一個名為 `withdrawAmount` 的輸入，與範例 7-1 的程式碼不一致，看起來是依照較早版本的範例產生的；照範例 7-1 編譯，`inputs` 應該會列出 `_withdrawAmount`（`uint256`）與 `_to`（`address`）兩個引數。

應用程式要與合約互動，只需要 ABI，以及合約部署所在的地址。

## 選擇 Solidity 編譯器與語言版本

從前面的程式碼可以看到，我們的 `Faucet` 合約能以 Solidity 0.8.26 版順利編譯。但如果我們使用的是不同版本的 Solidity 編譯器呢？這個語言仍在不斷變動，事情可能會以意想不到的方式改變。我們的合約相當簡單，但如果程式使用了 Solidity 0.8.26 版才加入的功能，而我們卻試著用 0.8.25 版編譯，會怎麼樣呢？

為了解決這類問題，Solidity 提供了一種稱為*版本 pragma* 的編譯器指令，告訴編譯器這個程式預期使用特定版本的編譯器（與語言）。我們來看一個例子：

```solidity
pragma solidity 0.8.26;
```

Solidity 編譯器會讀取版本 pragma，如果編譯器的版本與版本 pragma 不相容，就會產生錯誤。在這個例子中，我們的版本 pragma 表示這個程式可以用 0.8.26 版的 Solidity 編譯器編譯。pragma 指令不會被編譯成 EVM 位元組碼；它們是編譯期的指令，只供編譯器用來檢查相容性。

> **備註**
>
> 在 pragma 指令中，符號 ^ 表示我們允許用等於或高於指定版本的任何*次要修訂版本*來編譯。例如，pragma 指令 `pragma solidity ^0.7.1;` 表示這個合約可以用 0.7.1、0.7.2 與 0.7.3 版的 solc 編譯，但不能用 0.8.0 版編譯（那是主要修訂版本，而不是次要修訂版本）。

我們在 `Faucet` 合約中加入一個 pragma 指令。為了在進行這些範例的過程中追蹤修改，我們把新檔案命名為 *Faucet2.sol*，從範例 7-2 開始。

**範例 7-2. Faucet2.sol：在 Faucet 中加入版本 pragma**

```solidity
pragma solidity 0.8.26;
// SPDX-License-Identifier: GPL-3.0
// Our first contract is a faucet!
contract Faucet {
    // Give out ether to anyone who asks
    function withdraw(uint _withdrawAmount, address payable _to) public {
        // Limit withdrawal amount
        require(_withdrawAmount <= 100000000000000000);
        // Send the amount to the address that requested it
        _to.transfer(_withdrawAmount);
    }
    // Accept any incoming amount
    receive() external payable {}
}
```

加入版本 pragma 是一種最佳實踐，因為它能避免編譯器與語言版本不符所造成的問題。在本章中，我們會探討其他最佳實踐，並繼續改善 `Faucet` 合約。

## 用 Solidity 寫程式

本節要介紹 Solidity 語言的一些功能。我們在第 2 章提過，我們的第一個合約範例非常簡單，而且在許多方面都有缺陷。我們會在這裡一邊探索 Solidity 的用法，一邊逐步改善它。不過，這不會是一份完整的 Solidity 教學，因為 Solidity 相當複雜，而且演進得很快。我們會介紹基礎知識，讓你有足夠的基礎自行探索其餘的部分。

### 資料型別

首先，我們來看看 Solidity 提供的一些基本資料型別：

**布林值（bool）**

布林值，也就是 `true` 或 `false`，可以使用邏輯運算子 !（not）、&&（and）、||（or）、==（等於）與 !=（不等於）。

**整數（int、uint）**

有號（`int`）與無號（`uint`）整數，從 `int8` 到 `uint256`，以 8 位元為間隔宣告。沒有加上大小後綴時，會使用 256 位元的數值，以配合 EVM 的字組大小。

**定點數（fixed、ufixed）**

定點數，以 `(u)fixedMxN` 宣告，其中 *M* 是以位元為單位的大小（以 8 為間隔，最大 256），*N* 是小數點後的位數（最多 18 位），例如 `ufixed32x2`。

> **備註**
>
> Solidity 目前還沒有完整支援定點數。定點數可以宣告，但不能指派給其他變數，也不能被指派值。

**地址**

20 位元組的以太坊地址。`address` 物件有許多實用的成員函式，主要的有 `balance`（回傳帳戶餘額）與 `transfer`（把以太幣轉到這個帳戶）。

**位元組陣列（固定大小）**

固定大小的位元組陣列，以 `bytes1` 到 `bytes32` 宣告。

**位元組陣列（動態大小）**

大小可變的位元組陣列，以 `bytes` 或 `string` 宣告。

**列舉**

使用者定義的型別，用來列舉離散的值：`enum NAME {LABEL1, LABEL 2, ...}`。列舉的底層型別是 `uint8`，因此成員不能超過 256 個，而且可以明確地轉換成所有整數型別。

**陣列**

任何型別的陣列，可以是固定大小或動態大小：`uint32[][5]` 是一個固定大小的陣列，包含五個動態陣列，每個動態陣列的元素都是無號整數。

**結構**

使用者定義的資料容器，用來把多個變數歸為一組：`struct NAME {TYPE1 VARIABLE1; TYPE2 VARIABLE2; ...}`。

**mapping**

由*鍵* ⇒ *值*配對構成的雜湊查詢表：`mapping(KEY_TYPE` `⇒` `VALUE_TYPE) NAME`。

除了這些資料型別之外，Solidity 也提供各種數值常值，可以用來計算不同的單位：

**時間單位**

全域變數 `block.timestamp` 表示區塊發布並加入區塊鏈的時間，以秒為單位，從 Unix epoch（1970 年 1 月 1 日）起算。`seconds`、`minutes`、`hours` 與 `days` 等單位可以作為後綴使用，換算成基本單位 `seconds` 的倍數。

> **備註**
>
> 由於一個區塊可以包含多筆交易，同一個區塊中的所有交易都共用同一個 `block.timestamp`；它反映的是區塊發布的時間，而不是每筆交易發起的確切時刻。

**以太幣單位**

`wei` 與 `ether` 等單位可以作為後綴使用，換算成基本單位 `wei` 的倍數。以前還可以使用 `finney` 與 `szabo` 這兩種面額，但 Solidity 0.7.0 版已經移除了。

在我們的 `Faucet` 合約範例中，`withdrawAmount` 變數使用的是 `uint`（也就是 `uint256` 的別名）。我們也間接使用了一個 `address` 變數，並用 `msg.sender` 設定它的值。[^tn2]在本章其餘的範例中，我們會用到更多這類資料型別。

[^tn2]: 譯註：範例 7-1 中的變數其實是參數 `_withdrawAmount`；接收以太幣的地址是由呼叫者傳入的參數 `address payable _to`，並沒有用 `msg.sender` 設定。改用 `msg.sender` 作為接收者的寫法，要到本章稍後的範例 7-3 才出現。

我們用其中一種單位乘數，來改善範例合約的可讀性。在 `withdraw` 函式中，我們限制了最大的提領金額，並以以太幣的基本單位 wei 來表示這個上限：

```solidity
require(withdrawAmount <= 100000000000000000);
```

這不太容易閱讀。我們可以使用單位乘數 `ether` 來改善程式碼，改以以太幣而不是 wei 來表示這個值：

```solidity
require(withdrawAmount <= 0.1 ether);
```

### 變數：定義與作用域

在 Solidity 中，定義變數與函式的語法和其他靜態型別語言類似：我們為每個變數指定型別、名稱，以及可選的初始值。對於狀態變數，我們還可以指定它們的可見性。預設的可見性是 `internal`，表示只有在合約本身及其衍生合約中才能存取這個變數。要讓其他智能合約也能存取，就必須使用 `public` 可見性。

Solidity 智能合約的變數有三種作用域：

**狀態變數**

狀態變數把值記錄在區塊鏈上，藉此在智能合約中儲存永久的資料，也就是所謂的*持久狀態*。狀態變數定義在智能合約之內、任何函式之外。例如：`uint public count;`

**區域變數**

區域變數是計算過程中使用的暫時資料，只會短暫地保存資訊。區域變數不會儲存在區塊鏈上；它們存在於函式之中，在定義它們的作用域之外無法存取。例如：`uint count = 1;`

**全域變數**

全域變數由 Solidity 自動提供，不需要明確宣告或匯入就能使用。它們提供區塊鏈環境的相關資訊，也包括可以在程式中使用的工具函式。下一節會完整列出所有預先定義的全域變數。

前面簡單提過，宣告狀態變數時可以指定它們的可見性。Solidity 提供三種不同的可見性層級：*公開變數*會自動產生 getter 函式，讓外部合約可以讀取它們的值，但不能修改；*內部變數*只能在合約本身及其衍生合約中存取；*私有變數*和內部變數類似，但連衍生合約也無法存取。

### 預先定義的全域變數與函式

合約在 EVM 中執行時，可以存取一小組全域物件，包括 `block`、`msg` 與 `tx` 物件。此外，Solidity 也把一些 EVM 操作碼以預先定義的函式形式提供出來。本節要探討在 Solidity 智能合約中可以存取的變數與函式。

#### 交易／訊息呼叫環境

`msg` 物件是啟動這次合約執行的交易呼叫（由 EOA 發起）或訊息呼叫（message call）（由合約發起）。它包含許多實用的屬性：

**msg.sender**

我們已經用過這個屬性了。它代表發起這次合約呼叫的地址，不一定是送出交易的那個原始 EOA。如果我們的合約是直接被 EOA 的交易呼叫，那麼它就是簽署這筆交易的地址；否則，它會是一個合約地址。

**msg.value**

這次呼叫所附帶的以太幣數量（以 wei 為單位）。

**msg.data**

這次呼叫我們合約時附帶的資料內容。

**msg.sig**

資料內容的前四個位元組，也就是函式選擇器。

> **備註**
>
> 每當一個合約呼叫另一個合約時，`msg` 所有屬性的值都會改變，以反映新呼叫者的資訊。唯一的例外是 `delegatecall` 函式，它會在原本的 `msg` 環境中執行另一個合約或函式庫的程式碼。

#### 交易環境

`tx` 物件提供了存取交易相關資訊的方法：

**tx.gasprice**

呼叫交易中的 gas 價格

**tx.origin**

這筆交易的原始發起 EOA 的地址

#### 區塊環境

`block` 物件包含目前區塊的下列資訊：

**block.basefee**

目前區塊的基本費用，這是一個動態調整的值，代表交易要被納入區塊所需的最低 gas 費用。

**block.blobbasefee**

blob 交易的基本費用，會動態調整。這是 EIP-4844 為了有效率地處理大量資料而引進的，是以太坊可擴展性改進的一部分。

**block.chainid**

目前正在建構這個區塊的區塊鏈的唯一識別碼。

**block.prevrandao**

由信標鏈（Beacon Chain）提供、從前一個區塊的隨機性信標推導出來的偽隨機值。對需要隨機數的智能合約來說，這個值可能很有用，但只適用於不敏感的操作，因為它在某種程度上可以被操縱。

**block.coinbase**

目前區塊的手續費與區塊獎勵的接收者地址。

**block.difficulty**

在 Paris 升級，也就是合併（The Merge）之前的 EVM 版本中，這是目前區塊的工作量證明（PoW）難度。在之後採用權益證明（PoS）共識模型的 EVM 版本中，它是 `block.prevrandao` 已棄用的別名。

**block.gaslimit**

目前區塊所包含的所有交易總共可以花費的 gas 上限。

**block.number**

目前的區塊編號（區塊鏈高度）。

**block.timestamp**

礦工放進目前區塊的時間戳記（自 Unix epoch 起算的秒數）。

#### 地址物件

任何地址，不論是作為輸入傳入的，還是從合約物件轉型而來的，都具有許多屬性與方法。

**address.balance**

這個地址的餘額，以 wei 為單位。例如，目前合約的餘額是 `address(this).balance`。

**address.code**

儲存在這個地址的合約位元組碼。如果是 EOA 的地址，會回傳空的位元組陣列。

**address.codehash**

儲存在這個地址的合約位元組碼的 Keccak-256 雜湊值。

**address.transfer(amount)**

把指定的金額（以 wei 為單位）轉到這個地址，發生任何錯誤時都會拋出例外。我們在 `Faucet` 範例中，把這個函式當作 `msg.sender` 地址的方法來使用，也就是 `msg.sender.transfer`。[^tn3]

[^tn3]: 譯註：範例 7-1 與範例 7-2 寫的是 `_to.transfer(_withdrawAmount)`，以參數 `_to` 作為接收者；範例 7-3 寫的則是 `payable(msg.sender).transfer(withdrawAmount)`。本章的程式碼中並沒有 `msg.sender.transfer` 這種寫法。

**address.send(amount)**

和 `transfer` 類似，差別在於發生錯誤時不會拋出例外，而是回傳 `false`。請務必檢查 `send` 的回傳值。

**address.call(payload)**

低階的 `CALL` 函式，可以建構帶有資料內容的任意訊息呼叫。發生錯誤時回傳 `false`。請小心：接收者可能（意外或惡意地）用光你所有的 gas，讓你的合約因為 gas 耗盡（out of gas，OOG）例外而停止；請務必檢查 `call` 的回傳值。

**address.delegatecall(payload)**

低階的 `DELEGATECALL` 函式，類似 `address(this).call(...)`，但會把這個合約的程式碼換成 `address` 的程式碼。特別適合用來實作代理模式。發生錯誤時回傳 `false`。警告：僅限進階使用！

**address.staticcall(payload)**

低階的 `STATICCALL` 函式，類似 `address(this).call(...)`，但處於唯讀模式，也就是說，被呼叫的函式不能修改任何狀態，也不能傳送以太幣。發生錯誤時回傳 `false`。

> **備註**
>
> `address.send()` 與 `address.transfer()` 都只會轉交固定 2,300 單位的 gas，可能不足以執行 fallback 邏輯。隨著 EIP-7702 上線，已經不建議使用這兩個函式，而改用更有彈性的 `address.call()`。我們會在第 9 章進一步說明。

#### 內建函式

其他值得注意的函式包括：

**addmod, mulmod**

用於取模的加法與乘法。例如，`addmod(x,y,k)` 會計算 (x + y) % k。

**keccak256, sha256, ripemd160**

以各種標準雜湊演算法計算雜湊值的函式。

**ecrecover**

從簽章還原出簽署訊息所用的地址。

**selfdestruct(recipient_address)**

已棄用。用來刪除目前的合約，並把帳戶中剩餘的以太幣傳送到接收者地址。EIP-6780 之後，只有在自我銷毀指令與建立合約在同一筆交易中被呼叫時，才會這樣做。在其他所有情況下，資金會被轉走，但合約與它的狀態不會被清除。

**this**

目前的合約，可以明確地轉換成 `Address` 型別，以取得目前正在執行的合約帳戶的地址：`address(this)`。

**super**

在繼承階層中高一層的合約。

**gasleft**

目前執行環境剩餘的 gas 數量。

**blockhash(block_number)**

以區塊編號指定的某個區塊的雜湊值；只適用於最近的 256 個區塊。

**blobhash(index)**

與目前交易相關聯的第 `index-th` 個 blob 的雜湊值。

### 合約定義

Solidity 最主要的資料型別是 `contract`；我們的 `Faucet` 範例就只是定義了一個 `contract` 物件。就像物件導向語言中的任何物件一樣，*合約*是一個包含資料與方法的容器。

Solidity 還提供了另外兩種與合約類似的物件型別：

**interface**

介面定義的結構和合約完全一樣，只是其中的函式都沒有定義，只有宣告。這種宣告通常稱為*存根*（stub）；它告訴你函式的引數與回傳型別，但沒有任何實作。介面規定了合約的「形狀」；當介面被繼承時，子合約必須定義介面所宣告的每一個函式。

**library**

函式庫合約是指只部署一次、供其他合約透過 `delegatecall` 方法使用的合約（見「地址物件」一節）。

### 函式

我們在合約中定義可以被 EOA 交易或其他合約呼叫的函式。在 `Faucet` 範例中，我們有兩個函式：`withdraw` 與 `receive`。

在 Solidity 中宣告函式的語法如下：

```solidity
function FunctionName([parameters]) {public|private|internal|external} [virtual|override]
[pure|view|payable] [modifiers] [returns (return types)]
```

我們逐一來看這些組成部分：

**FunctionName**

函式的名稱，用來在來自 EOA 的交易中、從另一個合約，甚至在同一個合約內呼叫這個函式。

**parameters**

在名稱之後，我們指定必須傳給函式的引數，包括它們的名稱與型別。在 `Faucet` 範例中，我們把 `uint withdrawAmount` 定義為 `withdraw` 函式唯一的引數。[^tn4]

[^tn4]: 譯註：範例 7-1 的 `withdraw` 函式其實有兩個參數：`uint _withdrawAmount` 與 `address payable _to`。只有一個參數 `uint withdrawAmount` 的版本，是本章稍後的範例 7-3。

接下來這組關鍵字（`public`、`private`、`internal`、`external`）指定函式的可見性：

**public**

public 是預設值；這類函式可以被其他合約或 EOA 交易呼叫，也可以在合約內部呼叫。在 `Faucet` 範例中，兩個函式都定義為 public。[^tn5]

[^tn5]: 譯註：這段說明與本節稍後的備註不一致：備註指出函式的可見性必須明確定義，因此函式並沒有預設的可見性。此外，`Faucet` 範例中只有 `withdraw` 宣告為 `public`，`receive` 宣告的是 `external`（`receive() external payable {}`）。

**private**

私有函式和內部函式類似，但不能被衍生合約呼叫。

**internal**

內部函式只能在合約內部存取——它們不能被其他合約或 EOA 交易呼叫。衍生合約（也就是繼承這個合約的合約）可以呼叫它們。

**external**

外部函式和公開函式類似，差別在於除非明確地加上關鍵字 `this` 作為前綴，否則不能在合約內部呼叫。

請記住，*內部*與*私有*這兩個詞有點誤導人。合約裡的任何函式或資料，在公開的區塊鏈上永遠都是*看得見*的，也就是說，任何人都能看到這些程式碼或資料。這裡介紹的關鍵字只會影響函式可以如何、以及何時被*呼叫*。

> **備註**
>
> 不要把函式的可見性和狀態變數的可見性混為一談！它們使用相同的關鍵字與語意，卻是兩回事。狀態變數的可見性可以不指定，但函式的可見性必須明確定義。

第二組關鍵字（`pure`、`view`、`payable`）會影響函式的行為：

**pure**

pure 函式既不讀取、也不寫入儲存空間中的任何變數。它只能對引數進行運算並回傳資料，不參照任何已儲存的資料或區塊鏈狀態。pure 函式的用意，是鼓勵沒有副作用、沒有狀態的宣告式程式設計風格。

**view**

標示為 view 的函式不會修改任何狀態。編譯器並不強制使用 `view` 修飾；它只會在可以使用時產生一個警告。

**payable**

payable 函式是可以接受轉入款項的函式。沒有宣告為 `payable` 的函式會拒絕轉入的款項。由於 EVM 的設計決策，有兩個例外：即使 fallback 函式沒有宣告為 `payable`，coinbase 支付與 `SELFDESTRUCT` 的遺留款項仍然會轉入；不過這很合理，因為這些支付本來就不涉及程式碼的執行。

現在我們來探討兩個特殊函式 `receive` 與 `fallback` 的行為：

**receive()**

`receive` 函式讓我們的合約能夠接收以太幣。當合約收到一個 calldata 為空的呼叫時，它就會被觸發，通常是在單純轉帳以太幣的時候（例如使用 `.send()` 或 `.transfer()` 轉帳）。它以 `receive() external payable { ... }` 宣告；雖然它不能有任何引數，也不能回傳值，但它可以是 virtual、可以覆寫（override）其他函式，也可以有修飾符。

**fallback()**

當合約被呼叫時所帶的資料不符合任何其他函式簽章（function signature）時，就會執行 `fallback` 函式。我們可以用 `fallback() external [payable]` 或 `fallback(bytes calldata input) external [payable] returns (bytes memory output)` 宣告它。如果 `fallback` 函式包含輸入參數，這個參數會包含送到合約的全部資料（相當於 `msg.data`）。和 `receive` 函式一樣，`fallback` 函式可以是 payable、可以是 virtual、可以 override 其他函式，也可以有修飾符。現在，它主要用來實作*代理模式*：一種讓智能合約可以升級的設計模式。

> **備註**
>
> 如果合約沒有 `receive` 函式，但有 payable 的 `fallback` 函式，在這類轉帳時就會執行 `fallback` 函式。如果合約既沒有 `receive` 函式，也沒有 payable 的 `fallback` 函式，它就無法接受以太幣，交易會因為例外而回復。

### 合約建構子

有一種特殊的函式只會使用一次。合約被建立時，如果有*建構子函式*，就會一併執行它，以初始化合約的狀態。建構子與建立合約在同一筆交易中執行。建構子函式不是必要的；你會注意到，我們的 `Faucet` 範例就沒有建構子。

建構子可以透過 `constructor` 關鍵字指定，寫法如下：[^tn6]

[^tn6]: 譯註：下面這段程式碼的第一行 `pragma 0.8.26` 少了 `solidity` 與結尾的分號，無法編譯；正確的寫法應與本章前面的版本 pragma 相同：`pragma solidity 0.8.26;`。

```solidity
pragma 0.8.26
// SPDX-License-Identifier: GPL-3.0
contract MEContract {
 address owner;
 constructor () { // This is the constructor
  owner = msg.sender;
 }
}
```

合約的生命週期從 EOA 或合約帳戶發出的建立交易開始。如果有建構子，它會作為建立合約的一部分執行，在合約建立的同時初始化合約的狀態，之後就被捨棄。

> **備註**
>
> 建構子也可以標示為 payable。如果你想在建立合約的交易中一併傳送 ETH，就必須這樣做。如果建構子不是 payable，部署時傳送的任何 ETH 都會讓交易回復。

### 函式修飾符

Solidity 提供一種特殊的函式，稱為*函式修飾符*。只要在函式宣告中加上修飾符的名稱，就能把修飾符套用到函式上。修飾符最常用來建立適用於合約中許多函式的條件。我們的 `destroy` 函式裡已經有一個存取控制的陳述式。[^tn7]我們來建立一個表達這個條件的函式修飾符：

[^tn7]: 譯註：本版各個 `Faucet` 範例中並沒有 `destroy` 函式（範例 7-1 到 7-3 都只有 `withdraw` 與 `receive`），在這之前的範例中也還沒出現任何存取控制的陳述式；這句話沿用自本書第一版，當時的 `Faucet` 範例有一個只限擁有者呼叫、會執行 `selfdestruct` 的 `destroy` 函式。同樣地，「合約繼承」一節開頭說 `Faucet` 合約已經引進了擁有者的存取控制，但範例 7-1 與 7-2 的 `Faucet` 並沒有擁有者，也沒有建構子，這種存取控制要到該節的 `Owned` 合約才出現。

```solidity
modifier onlyOwner {
 require(msg.sender == owner);
 _;
}
```

這個名為 `onlyOwner` 的函式修飾符，會對它所修飾的任何函式設下一個條件：儲存為合約 `owner` 的地址，必須與交易的 `msg.sender` 地址相同。這是存取控制的基本設計模式，只允許合約的擁有者執行任何帶有 `onlyOwner` 修飾符的函式。

你可能已經注意到，我們的函式修飾符裡有一個奇特的語法「佔位符號」：一個底線後面接著一個分號（`_;`）。這個佔位符號會被替換成被修飾的函式的程式碼。基本上，修飾符就像「包」在被修飾的函式外面，把函式的程式碼放進底線字元所標示的位置。

要套用修飾符，就把它的名稱加到函式宣告中。一個函式可以套用多個修飾符；這些修飾符以空白分隔列出，會依照宣告的順序套用。

我們來定義一個使用 `onlyOwner` 修飾符的 `changeOwner` 函式：

```solidity
function changeOwner(address newOwner) public onlyOwner {
 require(newOwner != address(0), "New owner address not set");
 owner = newOwner;
}
```

函式修飾符的名稱（`onlyOwner`）寫在關鍵字 `public` 之後，告訴我們 `changeOwner` 函式受到 `onlyOwner` 修飾符的修飾。基本上，你可以把它讀成「只有擁有者才能設定新的擁有者地址」。實際上，產生的程式碼就相當於把 `onlyOwner` 的程式碼「包」在 `changeOwner` 外面。

函式修飾符是極為實用的工具，因為它讓我們能為函式撰寫前置條件，並一致地套用，讓程式碼更容易閱讀，也因此更容易進行安全審計。修飾符最常用於存取控制，但用途相當廣泛，也可以用於其他各種目的。

### 合約繼承

Solidity 的 `contract` 物件支援*繼承*，這是一種為基礎合約（base contract）擴充額外功能的機制。要使用繼承，就用關鍵字 `is` 指定父合約：

```solidity
contract Child is Parent {
 ...
}
```

透過這種寫法，`Child` 合約會繼承 `Parent` 的所有方法、功能與變數。Solidity 也支援多重繼承，只要在關鍵字 `is` 之後列出以逗號分隔的合約名稱即可：

```solidity
contract Child is Parent1, Parent2 {
 ...
}
```

要呼叫繼承鏈中較上層的函式，可以像 `Parent1.functionName()` 這樣明確指定合約；如果只想呼叫在攤平後的繼承階層中高一層的函式，則可以使用 `super.functionName()`。

合約繼承讓我們撰寫合約的方式能達到模組化、可擴充性與重複使用。我們先從簡單、實作最通用功能的合約開始，再透過在更專門的合約中繼承這些功能來加以擴充。

在 `Faucet` 合約中，我們引進了針對擁有者的存取控制，擁有者在建構時指定。這項功能相當通用：許多合約都會有。我們可以把它定義成一個通用的合約，再用繼承把它擴充到 `Faucet` 合約。為了讓範例更豐富，我們在存取控制之外，再加上可暫停的功能。

我們先定義一個基礎合約 `Owned`，它有一個 `owner` 變數，並在合約的建構子中設定這個變數：

```solidity
contract Owned {
    address owner;
    // Contract constructor: set owner
    constructor() {
        owner = msg.sender;
    }
    // Access control modifier
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
}
```

接著，我們定義一個繼承 `Owned` 的基礎合約 `Pausable`：

```solidity
contract Pausable is Owned {
    bool paused;
    // Status check modifier
    modifier whenNotPaused {
        require(paused == false);
        _;
    }
    // Functions to pause/unpause user operations
    function pause() public onlyOwner {
        paused = true;
    }
    function unpause() public onlyOwner {
        paused = false;
    }
}
```

如你所見，`Pausable` 合約可以使用定義在 `Owned` 中的 `onlyOwner` 函式修飾符。它也間接使用了定義在 `Owned` 中的 `owner` 地址變數與建構子。繼承讓每個合約都更簡單，專注於各自特定的功能，讓我們能以模組化的方式管理細節。

現在，我們可以進一步擴充 `Owned` 合約，在 `Faucet` 中繼承它的功能：[^tn8]

[^tn8]: 譯註：從下面的程式碼可以看到，`Faucet` 直接繼承的是 `Pausable`（`contract Faucet is Pausable`），再透過 `Pausable` 間接繼承 `Owned`；下一段的說明也是如此。

```solidity
contract Faucet is Pausable {
    // Give out ether to anyone who asks
    function withdraw(uint _withdrawAmount, address payable _to) public whenNotPaused {
        // Limit withdrawal amount
        require(_withdrawAmount <= 0.1 ether);
        // Send the amount to the address that requested it
        _to.transfer(_withdrawAmount);
    }
    // Accept any incoming amount
    receive() external payable {}
}
```

`Faucet` 合約繼承了 `Pausable`，而後者又繼承了 `Owned`，因此它現在可以使用 `whenNotPaused` 修飾符，而這個修飾符的結果，可以由透過 `Owned` 合約建構子定義的擁有者控制。這些功能就和把那些函式直接寫在 `Faucet` 裡一樣，但多虧了這種模組化的架構，我們可以在其他合約中重複使用這些函式與修飾符，不必重寫。程式碼重複使用與模組化讓我們的程式碼更簡潔、更容易閱讀，也更容易審計。

有時候，我們可能需要改變所繼承合約的某些功能。幸好，Solidity 正好提供了合適的功能：函式 override。宣告為 `virtual` 的函式，可以被繼承鏈中較上層的合約 override，讓繼承的做法保有高度的彈性。[^tn9]

[^tn9]: 譯註：這裡的「較上層」指的是衍生程度較高、繼承了該函式的合約（例如下面範例中 override `unpause` 的 `Faucet`），與前面「呼叫繼承鏈中較上層的函式」（指父合約）的用法正好相反。

我們來看一個例子。假設我們想讓暫停功能變成單向的：一旦暫停，合約就再也無法解除暫停。要做到這一點，我們需要把 `Pausable` 合約中的 `unpause` 函式標示為 `virtual`，並在 `Faucet` 合約中以 `override` 屬性重新宣告 `unpause` 函式，定義我們想要的新行為，也就是回復：

```solidity
contract Pausable is Owned {
    bool paused;
    // Status check modifier
    modifier whenNotPaused {
        require(paused == false);
        _;
    }
    // Functions to pause/unpause user operations
    function pause() public virtual onlyOwner {
        paused = true;
    }
    function unpause() public virtual onlyOwner {
        paused = false;
    }
}
contract Faucet is Pausable {
    // Give out ether to anyone who asks
    function withdraw(uint _withdrawAmount, address payable _to) public whenNotPaused {
        // Limit withdrawal amount
        require(_withdrawAmount <= 0.1 ether);
        // Send the amount to the address that requested it
        _to.transfer(_withdrawAmount);
    }
    function unpause() public view override onlyOwner {
        revert("Disabled feature”);
    }
    // Accept any incoming amount
    receive() external payable {}
}
```

如你所見，`Faucet` 中的 `unpause()` 函式必須以 `override` 關鍵字宣告。在 `Pausable` 合約中，為了一致起見，我們把 `pause` 與 `unpause` 兩個函式都標示為 virtual，雖然在我們的例子中只需要改變 `unpause`。

> **備註**
>
> 在 Solidity 中 override 函式時，我們只能讓可見性變得更開放——具體來說，我們可以把它從 external 改成 public，但不能反過來。至於狀態可變性（mutability），我們可以把限制收緊，例如從 nonpayable 改成 view 或 pure（就像我們對 `unpause` 所做的），或從 view 改成 pure。但有一個重大的例外：如果函式標示為 payable，就必須維持 payable——我們不能把它改成其他任何設定。

### 多重繼承

在 Solidity 中使用多重繼承時，Solidity 會依靠一種稱為 C3 線性化的演算法，來決定合約被繼承的順序。這個演算法確保繼承順序嚴格且可預測，有助於避免循環繼承之類的問題。用最簡單的方式來說，它決定的是尋找函式時檢查基礎合約的順序，而這個順序是由右到左。也就是說，最右邊的合約被視為「衍生程度最高」的合約。例如，在合約宣告 `contract C is A, B { }` 中，合約 B 的衍生程度比合約 A 高。

除了使用 C3 線性化之外，Solidity 還設有其他的防護措施。其中一條關鍵的規則是：如果多個合約有相同的函式，我們就必須明確指出要 override 哪些合約。我們來看一個例子：

```solidity
contract A {
    function foo() public virtual returns(string memory){
        return "A";
    }
}
contract B {
    function foo() public virtual returns(string memory){
        return "B";
    }
}
contract C is A, B {
}
```

乍看之下，這段程式碼似乎應該能正常運作，因為 C3 線性化應該會處理好一切。但實際上，它無法編譯。Solidity 會拋出一個錯誤，內容是：「TypeError: Derived contract must override function `foo`. Two or more base classes define a function with the same name and parameter types.」要修正這個問題，我們必須像下面這樣，明確地 override A 與 B 兩者的 `foo()` 函式：

```solidity
contract C is A, B {
    function foo() public override(A, B) returns(string memory){
        return "C";
    }
}
```

所以，即使 Solidity 使用 C3 線性化，我們在寫程式時大多不必擔心它，因為 Solidity 會強制我們明確地處理函式的 override。

不過，有一個地方 C3 線性化很重要，那就是 Solidity 決定建構子執行順序的時候。建構子會依照 C3 線性化的順序執行，但有個轉折：它們是以相反的順序執行的。仔細想想，這很合理：衍生程度最高的合約，它的建構子應該最後執行，因為它可能會覆蓋先前的建構子所設定的東西。我們來看一個例子：

```solidity
contract Base{
    uint x;
}
contract Derived1 is Base{
    constructor(){
        x = 1;
    }
}
contract Derived2 is Base{
    constructor(){
        x = 2;
    }
}
contract Derived3 is Derived1, Derived2 {
    uint public y;
    constructor() Derived1() Derived2() {
        y = x;
    }
}
```

在這個例子中，`y` 的值最後會如預期是 2，因為 `Derived2` 的建構子最後執行，把 `x` 設為 2。

有一件重要的事要記住：你提供建構子引數的順序，並不會影響執行順序。例如，我們可以像這樣把建構子的呼叫順序對調：

```solidity
contract Derived3 is Derived1, Derived2 {
    uint public y;
    constructor() Derived2() Derived1() { // we switched the order here
        y = x;
    }
}
```

即使我們改變了建構子中的順序，結果仍然相同。`y` 的值會是 2，因為建構子的執行順序是由 C3 線性化決定的，而不是由我們呼叫建構子的順序決定。

最後提醒一點：Solidity 用 C3 線性化處理多重繼承，可能會讓 `super` 關鍵字的行為出乎你的意料。有時候，呼叫 `super` 觸發的可能是兄弟類別的函式，而不是直接父類別的函式。這可能導致一些令人意外的結果：被呼叫的方法，來自一個你甚至沒有列在繼承鏈中的類別。這算是一種邊緣情況，所以我們不會深入探討，但在繼承結構複雜的合約中使用 `super` 關鍵字時，務必記住這一點。

### 錯誤處理

合約呼叫可能會終止並回傳錯誤。Solidity 的錯誤處理由三個函式負責：`assert`、`require` 與 `revert`。

當合約因為錯誤而終止時，所有的狀態變更（變數、餘額等的變更）都會被回復；如果呼叫了不只一個合約，這種回復會沿著合約呼叫鏈一路往上進行。這確保了交易是 *atomic* 的，也就是說，交易不是成功完成，就是對狀態沒有任何影響、被完全回復。

`assert` 與 `require` 函式的運作方式相同：它們會評估一個條件，如果條件為假，就以錯誤停止執行。依照慣例，`assert` 用在預期結果為真的時候，也就是說，我們用 `assert` 測試內部的條件。相較之下，`require` 用來測試輸入（例如函式的引數或交易的欄位），設定我們對這些條件的預期。失敗的 assert 會以 Panic(0x01) 回復，並保留未使用的 gas。請用 assert 檢查內部的不變條件（invariant），用 require 驗證輸入與前置條件。

我們在函式修飾符 `onlyOwner` 中使用了 `require`，用來測試訊息的發送者是否為合約的擁有者：

```solidity
require(msg.sender == owner);
```

`require` 函式扮演*前置條件*的角色：如果條件不滿足，它就會阻止函式其餘部分的執行，並產生錯誤。它也可以包含一段有用的文字訊息，用來顯示錯誤的原因。這段錯誤訊息會記錄在交易日誌中；建議加上錯誤訊息，讓使用者知道錯誤是什麼、該如何修正，藉此改善使用者體驗。所以，我們可以在 `require` 函式中加上錯誤訊息，來改善程式碼：

```solidity
require(msg.sender == owner, "Only the contract owner can call this function");
```

`revert` 函式會停止合約的執行，並回復所有的狀態變更。它有兩種用法：一種是當作陳述式，直接傳入自訂錯誤（custom error），不加括號；另一種是當作函式，加上括號並接受一個字串引數。就 gas 成本而言，自訂錯誤便宜得多；而錯誤字串與自訂錯誤都會記錄在交易日誌中：

```solidity
revert();
revert("Error string");
revert CustomError(arg1, arg2);
```

合約中的某些情況，不論我們是否明確檢查，都會產生錯誤。例如，在 `Faucet` 合約中，我們並沒有檢查是否有足夠的以太幣來滿足提領請求。這是因為如果餘額不足以完成轉帳，`transfer` 函式就會以錯誤失敗，並回復交易：

```solidity
payable(msg.sender).transfer(withdrawAmount);
```

不過，明確地檢查，並在失敗時提供清楚的錯誤訊息，或許會更好。我們可以在轉帳之前加上一個 `require` 陳述式來做到這一點：[^tn10]

[^tn10]: 譯註：下面程式碼中的 `this.balance` 應寫成 `address(this).balance`。本章「地址物件」一節說明過，目前合約的餘額要以 `address(this).balance` 取得；`balance` 是 `address` 的成員，而 `this` 是合約型別，必須先明確轉換成 `address`（見「內建函式」一節的 `this`）。

```solidity
require(this.balance >= withdrawAmount,
 "Insufficient balance in faucet for withdrawal request");
payable(msg.sender).transfer(withdrawAmount);
```

像這樣額外的錯誤檢查程式碼會稍微增加 gas 的消耗，但比起省略它，能提供更好的錯誤回報。過去，由於以太坊主網的成本很高，把 gas 消耗降到最低是必做的功課；但 EIP-4844 的引進已經大幅降低了這項成本，讓 gas 消耗在今天不再是那麼迫切的問題。儘管如此，在 gas 效率與周全的錯誤檢查之間取得適當的平衡，仍然很重要。

Solidity 透過 try/catch 功能，讓我們對錯誤處理有更多的控制。這是一個非常方便的功能，讓我們在呼叫外部合約時，能更從容地處理錯誤。出問題時，我們不必讓整筆交易失敗並回復，而是可以捕捉錯誤，再決定接下來要怎麼做。使用 try/catch 時，基本上就是把外部呼叫包在一個 `try` 區塊中。如果呼叫成功，`try` 區塊內的程式碼就會照常執行。但如果出了問題——例如被呼叫的合約 gas 耗盡、未通過 `require` 檢查，或拋出例外——程式就會跳到 `catch` 區塊，讓我們在那裡處理錯誤。

下面是一個簡單的例子：

```solidity
function sampleExternalCall(address target, uint amount) public {
    try ITargetContract(target).someFunction(amount) {
        // This runs if the call is successful
        emit Success("Call succeeded!");
    } catch {
        // This runs if the call fails
        emit Error("Call failed!");
    }
}
```

我們可以依照錯誤的類型，用不同的方式捕捉錯誤。基本的 `catch` 區塊會捕捉所有錯誤，但我們也可以捕捉特定的錯誤。例如，我們可以用 `catch Error(string memory reason)` 捕捉會回傳錯誤字串的錯誤，或用 `catch (bytes memory lowLevelData)` 處理不回傳任何資料的低階錯誤。此外，我們也可以用 `catch Panic(uint errorCode)` 捕捉更嚴重的 panic 錯誤，例如溢位或除以零。

try/catch 只適用於外部呼叫。它對同一個合約內的內部函式呼叫沒有幫助。如果同一個合約中的函式失敗，它仍然會照常回復，我們無法用 try/catch 捕捉。

### 事件

交易完成時（不論成功與否），會產生一份交易收據。交易收據包含日誌項目，提供交易執行期間所發生動作的相關資訊。*事件*是 Solidity 用來建構這些日誌的高階物件。

事件對輕客戶端與 DApp 服務特別有用：它們可以「監看」特定的事件，並回報給使用者介面，或改變應用程式的狀態，以反映底層合約中發生的事件。

事件物件接受引數，這些引數會被序列化並記錄在區塊鏈上的交易日誌中。你可以在引數前加上關鍵字 `indexed`，讓這個值成為索引表（雜湊表）的一部分，讓應用程式可以搜尋或篩選。

#### 加入事件

到目前為止，我們還沒有在 `Faucet` 範例中加入任何事件，現在就來加吧。我們會加入兩個事件：一個記錄每一筆提領，另一個記錄每一筆存入。我們分別把這兩個事件命名為 `Withdrawal` 與 `Deposit`。首先，我們在 `Faucet` 合約中定義這些事件：

```solidity
contract Faucet is Pausable {
 event Withdrawal(address indexed to, uint amount);
 event Deposit(address indexed from, uint amount);
 [...]
}
```

我們選擇讓地址成為 `indexed`，讓任何為了存取 `Faucet` 而打造的使用者介面都能搜尋與篩選。

接著，我們使用 `emit` 關鍵字，把事件資料納入交易日誌中：

```solidity
// Give out ether to anyone who asks
function withdraw(uint withdrawAmount) public {
 [...]
 payable(msg.sender).transfer(withdrawAmount);
 emit Withdrawal(msg.sender, withdrawAmount);
}
// Accept any incoming amount
receive() external payable {
 emit Deposit(msg.sender, msg.value);
}
```

最後得到的 *Faucet.sol* 合約如範例 7-3 所示。

**範例 7-3. Faucet.sol：加入事件的修訂版 Faucet 合約**

```solidity
// Version of Solidity compiler this program was written for
pragma solidity 0.8.26;
// SPDX-License-Identifier: GPL-3.0
contract Owned {
    address owner;
    // Contract constructor: set owner
    constructor() {
        owner = msg.sender;
    }
    // Access control modifier
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
}
contract Pausable is Owned {
    event Paused();
    event Unpaused();
    bool paused;
    // Status check modifier
    modifier whenNotPaused {
        require(paused == false);
        _;
    }
    // Functions to pause/unpause user operations
    function pause() public onlyOwner {
        paused = true;
        emit Paused();
    }
    function unpause() public onlyOwner {
        paused = false;
        emit Unpaused();
    }
}
contract Faucet is Pausable {
    event Withdrawal(address indexed to, uint amount);
    event Deposit(address indexed from, uint amount);
    // Give out ether to anyone who asks
    function withdraw(uint withdrawAmount) public whenNotPaused {
        // Limit withdrawal amount
        require(withdrawAmount <= 0.1 ether);
        // Send the amount to the address that requested it
        payable(msg.sender).transfer(withdrawAmount);
        emit Withdrawal(msg.sender, withdrawAmount);
    }
    // Accept any incoming amount
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
}
```

#### 捕捉事件

我們用一些程式碼，逐步說明如何捕捉鏈上事件。具體來說，我們要寫一個腳本，監控以太坊主網上的 USDT 代幣轉帳。為此，我們需要一個 Web3 函式庫；雖然最先流行起來的是 web3.js，但近年來 ethers.js 已經後來居上。身為開發者，我們偏好 ethers.js，所以這裡就用它。

首先，我們來設定專案。先建立一個新的專案資料夾，再執行下列指令安裝 ethers 函式庫：

```bash
npm i ethers
```

接著，我們需要 USDT 合約的 ABI。你可以從 [Etherscan](https://oreil.ly/LoWH4) 上合約原始碼的正下方取得（見圖 7-1），並把它存到專案資料夾中。

![Etherscan’s USDT ABI section](images/ch7/maet_0701.png)

**圖 7-1.** Etherscan 上的 USDT ABI 區段

現在，我們來談談要如何連上以太坊網路。我們需要一個 WebSocket 節點服務供應商（provider），因為我們要監聽事件，而這需要持續的連線。你可以選擇付費的 provider（比較可靠、速度也比較快），也可以選擇在 [ChainList](https://chainlist.org) 之類的網站上找到的免費公開 provider。以我們的範例來說，公開的 provider 就夠用了，雖然它們可能有流量限制。

> **備註**
>
> 要監聽事件，我們需要的是 WebSocket，而不是 RPC 端點。RPC 端點很適合單次的請求，例如呼叫函式或取得資料；但要捕捉事件，就需要 WebSocket 連線，讓客戶端與伺服器之間保持一條暢通的通訊管道。

現在，我們來深入看看程式碼：

```javascript
const ethers = require("ethers");
const ABI = require("./USDTabi.json"); // the ABI we fetched from etherscan
const usdtAddress = "0xdac17f958d2ee523a2206206994597c13d831ec7"; // USDT Contract
const wssProviderURL = "wss://ethereum-rpc.publicnode.com"; // a public websocket provider
const wssProvider = new ethers.providers.WebSocketProvider(wssProviderURL);
const usdtContract = new ethers.Contract(usdtAddress, ABI, wssProvider);
async function getTransfer(){
    usdtContract.on("Transfer", (from, to, value, event)=>{
        let transferEvent ={
            from: from,
            to: to,
            value: value,
            eventData: event,
        }
        console.log(JSON.stringify(transferEvent, null, 2))
    })
}
getTransfer()
```

宣告 USDT 地址與 WebSocket provider 的網址之後，腳本一開始會用 ethers 函式庫建立一個新的 WebSocketProvider 實例。這個 provider 會透過我們指定的 WebSocket 網址，把我們連上以太坊網路。接著，我們用 `ethers.Contract` 類別建立 USDT 智能合約的實例，傳入 USDT 地址、ABI 與我們的 WebSocket provider。

現在來到腳本的核心。我們在合約實例上設定一個事件監聽器，捕捉 USDT 合約發出的 `Transfer` 事件。每當發生 `Transfer` 事件，這個監聽器就會觸發一個回呼函式，這個函式會收到四個與這筆轉帳相關的參數。在回呼函式中，我們取出轉帳的細節，把它們包成一個物件，再把這個物件格式化成 JSON 字串。最後，我們用 `console.log` 把這個 JSON 字串印到主控台上，這樣就能即時看到每一筆轉帳的確切情況。

下面是腳本的一個輸出範例：

```json
{
  "from": "0xc169e35abb35f8e712eCF9F6d9465C96962CA383",
  "to": "0x7E73F680243A93a9D98C5Ce4b349451805fc37ca",
  "value": {
    "type": "BigNumber",
    "hex": "0x55b27b90"
  },
  "eventData": {
    "blockNumber": 20687220,
    "blockHash": "0xa5c3c518d7246e516e076ef8d43c387dcb54d06702e9e059c583ce28a7a271b8",
    "transactionIndex": 166,
    "removed": false,
    "address": "0xdAC17F958D2ee523a2206206994597C13D831ec7",
    "data": "0x0000000000000000000000000000000000000000000000000000000055b27b90",
    "topics": [
      "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
      "0x000000000000000000000000c169e35abb35f8e712ecf9f6d9465c96962ca383",
      "0x0000000000000000000000007e73f680243a93a9d98c5ce4b349451805fc37ca"
    ],
    "transactionHash":
      "0xb527a5a18f10ed9b65dda7a914715a0b0bbfd6db053d8f6b35805ad49a588cfd",
    "logIndex": 300,
    "event": "Transfer",
    "eventSignature": "Transfer(address,address,uint256)",
    "args": [
      "0xc169e35abb35f8e712eCF9F6d9465C96962CA383",
      "0x7E73F680243A93a9D98C5Ce4b349451805fc37ca",
      {
        "type": "BigNumber",
        "hex": "0x55b27b90"
      }
    ]
  }
}
```

像這樣的事件非常有用，不僅能用於鏈外的通訊，也能用於除錯。在開發時，你可以在交易收據的「logs」項目下找到這些事件；當程式不如預期運作時，這可能會是你的救星。

### 呼叫其他合約

在合約中呼叫其他合約，是一種非常有用、但可能很危險的操作。我們會探討達成這件事的各種方式，並評估每種方式的風險。簡單地說，風險來自於你對自己呼叫的合約，或呼叫你的合約的那個合約，可能所知不多。撰寫智能合約時，你必須記住：雖然你大多預期要打交道的是 EOA，但沒有任何東西能阻止任意複雜、甚至可能惡意的合約呼叫你的程式碼，或被你的程式碼呼叫。

#### 建立新實例

呼叫另一個合約最安全的方式，是由你自己建立那個合約。這樣一來，你就能確定它的介面與行為。要做到這一點，你可以像在其他物件導向語言中一樣，直接用關鍵字 `new` 將它實例化。在 Solidity 中，關鍵字 `new` 會在區塊鏈上建立合約，並回傳一個你可以用來參照它的物件。假設你想在另一個名為 `Token` 的合約中，建立並呼叫一個 `Faucet` 合約：

```solidity
contract Token is Pausable {
    Faucet _faucet;
    constructor() {
        _faucet = new Faucet();
    }
}
```

這種建構合約的機制，能確保你知道合約的確切型別與它的介面。`Faucet` 合約必須定義在 `Token` 的作用域內；如果定義寫在另一個檔案裡，可以用 `import` 陳述式做到這一點：

```solidity
import "Faucet.sol";
contract Token is Pausable {
    Faucet _faucet;
    constructor() {
        _faucet = new Faucet();
    }
}
```

你也可以選擇在建立時指定要轉移的以太幣數量，並把引數傳給新合約的建構子：

```solidity
import "Faucet.sol";
contract Token is Pausable {
    Faucet _faucet;
    constructor() {
        _faucet = new Faucet{value: 0.5 ether}();
    }
}
```

請注意，這需要 `Faucet` 的建構子是 payable！

接著，你也可以呼叫 `Faucet` 的函式。在這個例子中，我們在 `Token` 的 `changeOwner` 函式中，呼叫 `Faucet` 的 `changeOwner` 函式：[^tn11]

[^tn11]: 譯註：範例 7-3 的 `Faucet`（以及它繼承的 `Pausable`、`Owned`）並沒有定義 `changeOwner` 函式，所以下面的 `_faucet.changeOwner(newOwner)` 無法編譯；此外，`Token` 的 `changeOwner` 沒有寫可見性，依本章「函式」一節的備註，函式的可見性必須明確定義。

```solidity
import "Faucet.sol";
contract Token is Pausable {
    Faucet _faucet;
    constructor() {
         _faucet = new Faucet{value: 0.5 ether}();
    }
    function changeOwner(address newOwner) onlyOwner {
        _faucet.changeOwner(newOwner);
    }
}
```

重要的是要了解：雖然你是 `Token` 合約的擁有者，但擁有新 `Faucet` 合約的是 `Token` 合約本身，而不是你！我們在本章前面看過，進行外部呼叫時，`msg.sender` 會改變；在我們的例子中，在 `Faucet` 的執行環境裡，它會是 `Token` 的地址。

#### 使用既有的實例

呼叫合約的另一種方式，是把某個既有合約實例的地址轉型。使用這種方法時，你是把一個已知的介面套用到既有的實例上。因此，你必須百分之百確定，你所使用的實例確實是你所假設的型別，這一點極為重要。我們來看一個例子：

```solidity
import "Faucet.sol";
contract Token is Pausable {
    Faucet _faucet;
    constructor(address _f) {
        _faucet = Faucet(_f);
        _faucet.withdraw(0.1 ether)
    }
}
```

在這裡，我們取得作為引數傳給建構子的地址 `_f`，並把它轉型為 `Faucet` 物件。這比前一種機制危險得多，因為我們無法確定這個地址實際上是不是 `Faucet` 物件。呼叫 `withdraw` 時，我們假設它接受與我們的 `Faucet` 宣告相同的引數、執行相同的程式碼，但我們無法確定。說不定這個地址上的 `withdraw` 函式即使名稱相同，執行的卻是與我們預期完全不同的東西。因此，使用作為輸入傳入的地址，並把它們轉型為特定的物件，比自己建立合約危險得多。

#### 原始呼叫、delegatecall 與 staticcall

Solidity 還提供了一些更「低階」的函式來呼叫其他合約。這些函式直接對應到同名的 EVM 操作碼，讓我們能手動建構合約對合約的呼叫。因此，它們是呼叫其他合約最有彈性，*也*最危險的機制。它們會回傳兩個值：表示操作是否成功的 `bool success`，以及包含回傳資料的 `bytes memory data`。

下面是用 `call` 方法改寫的同一個例子：

```solidity
contract Token is Pausable {
    constructor(address _faucet) {
        _faucet.call(abi.encodeWithSignature("withdraw(uint256)", 0.1 ether));
    }
}
```

如你所見，這種 `call` 是對函式的*盲目*呼叫，非常像是建構一筆原始交易，只不過是在合約的環境中進行。發生問題時，`call` 函式會回傳 `false`，所以你可以檢查回傳值來處理錯誤：

```solidity
contract Token2 is Pausable {
    constructor(address _faucet) {
        (bool res, ) = _faucet.call(
            abi.encodeWithSignature("withdraw(uint256)", 0.1 ether)
        );
        if (!res) {
            revert("Withdrawal from faucet failed");
        }
    }
}
```

`call` 的變體有 `staticcall` 與 `delegatecall`。如「地址物件」一節所述，`staticcall` 會以保證不改變狀態的方式，呼叫另一個合約的函式。也就是說，被呼叫的函式不能修改任何狀態變數、不能與區塊鏈的狀態互動，也不能傳送以太幣。

`delegatecall` 與 `call` 的不同之處在於，`msg` 環境不會改變。例如，`call` 會把 `msg.sender` 的值改成發出呼叫的合約，而 `delegatecall` 則會保留與發出呼叫的合約相同的 `msg.sender`。基本上，`delegatecall` 是在目前合約的執行環境中，執行另一個合約的程式碼。它最常用來呼叫函式庫中的程式碼。它也讓你能採用一種模式：使用儲存在別處的函式庫函式，卻讓這些程式碼操作你自己合約的儲存資料；代理模式就是一個明顯的例子。使用 `delegatecall` 必須非常謹慎。它可能會產生一些意想不到的效果，尤其是當你呼叫的合約並不是設計成函式庫的時候。

我們用一個範例合約，示範 `call` 與 `delegatecall` 在呼叫函式庫與合約時所使用的各種呼叫語意。在範例 7-4 中，我們用一個事件記錄每次呼叫的細節，觀察呼叫環境如何隨著呼叫類型而改變。

**範例 7-4. CallExamples.sol：不同呼叫語意的範例**

```solidity
pragma solidity 0.8.26;
contract CalledContract {
    event callEvent(address sender, address origin, address from);
    function calledFunction() public {
        emit callEvent(msg.sender, tx.origin, address(this));
    }
}
library CalledLibrary {
    event callEvent(address sender, address origin, address from);
    function calledFunction() public {
        emit callEvent(msg.sender, tx.origin, address(this));
    }
}
contract Caller {
    function makeCalls(CalledContract _calledContract) public {
        // Calling CalledContract and CalledLibrary directly
        _calledContract.calledFunction();
        CalledLibrary.calledFunction();
        // Low-level calls using the address object for CalledContract
        (bool res, ) = address(_calledContract).
            call(abi.encodeWithSignature("calledFunction()"));
        require(res);
        (res, ) = address(_calledContract).
            delegatecall(abi.encodeWithSignature("calledFunction()"));
        require(res);
    }
}
```

從這個範例可以看到，我們的主合約是 `Caller`，它會呼叫函式庫 `CalledLibrary` 與合約 `CalledContract`。被呼叫的函式庫與合約都有一模一樣的 `calledFunction` 函式，會發出事件 `calledEvent`。事件 `calledEvent` 記錄三項資料：`msg.sender`、`tx.origin` 與 `this`。[^tn12]每次呼叫 `calledFunction` 時，依照它是被直接呼叫還是透過 `delegatecall` 呼叫，都可能有不同的執行環境（所有環境變數的值都可能不同）。

[^tn12]: 譯註：範例 7-4 程式碼中的事件名稱是 `callEvent`，不是 `calledEvent`；第三項資料記錄的是 `address(this)`，在事件中的參數名稱為 `from`。

在 `Caller` 中，我們先直接呼叫合約與函式庫各自的 `calledFunction`。接著，我們明確地使用低階函式 `call` 與 `delegatecall` 來呼叫 `CalledContract.calledFunction`。這樣，我們就能看到各種呼叫機制的行為。

我們來部署這些合約、執行 `makeCalls` 函式，並捕捉事件。為了清楚起見，我們會把地址換成它們的標籤（例如 `CALLER_CONTRACT_ADDRESS`）。

我們呼叫了 `makeCalls` 函式，傳入 `CalledContract` 的地址，然後捕捉到各次呼叫分別發出的四個事件。我們來看看 `makeCalls` 函式，逐步說明每個步驟。

第一個呼叫是：

```solidity
_calledContract.calledFunction();
```

在這裡，我們使用 `calledFunction` 的高階 ABI，直接呼叫 `CalledContract.calledFunction`。發出的事件引數如下：

```json
{
    sender: 'CALLER_CONTRACT_ADDRESS',
    origin: 'EOA_ADDRESS',
    from: 'CALLED_CONTRACT_ADDRESS'
}
```

如你所見，`msg.sender` 是 `Caller` 合約的地址。`tx.origin` 則是我們把交易送給 `Caller` 的帳戶 `web3.eth.accounts[0]` 的地址。從事件的最後一個引數可以看出，這個事件是由 `CalledContract` 發出的。

`makeCalls` 中的下一個呼叫，是呼叫函式庫：

```solidity
CalledLibrary.calledFunction();
```

它看起來和我們呼叫合約的方式一模一樣，行為卻大不相同。我們來看看發出的第二個事件：

```json
{
    sender: 'EOA_ADDRESS',
    origin: 'EOA_ADDRESS',
    from: 'CALLER_CONTRACT_ADDRESS'
}
```

這一次，`msg.sender` 不是 `Caller` 的地址，而是我們帳戶的地址，與交易的發起者相同。這是因為呼叫函式庫時，呼叫一律是 `delegatecall`，並在呼叫者的環境中執行。所以，`CalledLibrary` 的程式碼在執行時，繼承了 `Caller` 的執行環境，就好像它的程式碼是在 `Caller` 裡面執行一樣。即使變數 `this`（在發出的事件中顯示為 `from`）是在 `CalledLibrary` 中存取的，它的值仍是 `Caller` 的地址。

接下來兩個呼叫使用低階的 `call` 與 `delegatecall`，發出的事件與我們剛才看到的如出一轍，證實了我們的預期。

## gas 的考量

gas 在第 14 章有更詳細的說明，它是智能合約程式設計中極為重要的考量。gas 是一種資源，用來限制以太坊允許一筆交易消耗的最大計算量。如果在計算過程中超過了 gas 上限，就會依序發生下列事情：

- 拋出「gas 耗盡」例外。
- 合約的狀態恢復（回復）到執行之前的樣子。
- 用來支付 gas 的所有以太幣都會被當作交易手續費收走，*不會*退還。

### 最佳實踐

由於 gas 是由發起交易的使用者支付，使用者會避免呼叫 gas 成本高的函式。因此，把合約函式的 gas 成本降到最低，最符合程式設計師的利益。為此，撰寫智能合約時有一些建議的做法，可以把函式呼叫的 gas 成本降到最低：

**避免動態大小陣列**

任何走訪動態大小陣列的迴圈，只要函式會對每個元素執行操作，或搜尋某個特定元素，就有使用過多 gas 的風險。事實上，合約可能在找到想要的結果之前，或在處理完每個元素之前，就耗盡 gas，白白浪費時間與以太幣，卻得不到任何結果。

**避免呼叫其他合約**

呼叫其他合約，尤其是在不知道它們的函式 gas 成本的情況下，會帶來耗盡 gas 的風險。避免使用沒有經過充分測試、沒有被廣泛使用的函式庫。一個函式庫受到其他程式設計師檢驗的程度越低，使用它的風險就越高。

**避免多餘的儲存空間存取**

存取儲存空間變數，不論是讀取還是寫入，花費的 gas 都比使用記憶體變數多得多。所以只要可以，最好避免直接使用儲存空間。例如，如果我們在某些計算過程中需要多次讀取某個儲存空間變數，最好先把它的值複製到一個記憶體變數中。這樣，我們就能重複存取較便宜的記憶體變數，而不必每次都去存取儲存空間，藉此節省 gas 成本。

> **備註**
>
> 補充一下背景：Solidity 用好幾個地方來存放資料：儲存空間，它是持久而昂貴的；記憶體，它是暫時的，在執行期間比較便宜；calldata，這是一個唯讀的區域，主要用於外部函式的輸入；以及堆疊，用來存放壽命非常短的值，存取成本最低。要選擇哪一種，取決於資料的使用方式：它是否需要持久保存、是否可變，以及是否從外部傳入。我們會在第 14 章深入探討這些差異，但及早開始思考它們如何影響效能與成本，會很有幫助。

### 估算 gas 成本

以太坊剛推出時，估算 gas 成本有點像是在猜拍賣的得標價。這和比特幣處理交易手續費的方式類似：我們自己設定 gas 價格，礦工則會優先處理出價最高的交易。這表示在網路繁忙的時候，我們常常得出更高的價格，才能確保交易很快完成。這個方法行得通，但也代表 gas 價格可能波動得很厲害——網路壅塞時，有時候會高得嚇人。

接著，2021 年出現了改變遊戲規則的 EIP-1559。以太坊不再要我們猜測合適的 gas 價格，而是引進了一種會依照網路活動自動調整的基本費用。這讓 gas 費用變得更容易預測。而且，如果我們趕時間，仍然可以加上一筆小費（稱為*優先費用*）來加快速度。現在估算 gas 成本變得更直接，我們也比較不會只為了讓交易被處理而多付錢。

我們來詳細探討如何估算交易的 gas 成本。首先，每筆交易的 gas 成本都有兩個主要組成部分：基本費用與優先費用：

**基本費用**

這是讓交易被納入區塊所需支付的最低 gas 金額。基本費用由網路自動決定，並依照網路的繁忙程度動態調整。如果區塊是滿的，基本費用就會上升；如果區塊沒有被充分使用，基本費用就會下降。

**優先費用（小費）**

這是我們額外加上的費用，目的是提供誘因，讓礦工（或在權益證明的情境下，讓驗證者）優先處理我們的交易。它就像是為了讓交易更快被處理而給的小費。我們可以自己設定這筆費用，但錢包應用程式會依照我們希望交易被納入的速度，建議適當的數值。

我們交易的 gas 總成本，是以使用的 gas 量（取決於交易的複雜度）乘以實際的 gas 價格計算出來的。實際的 gas 價格就是基本費用與優先費用的總和。

所以，要估算 gas 成本，我們可以依照下列步驟：

1. 查看目前的基本費用。我們可以用 [Etherscan Gas Tracker](https://oreil.ly/ZIqcq) 之類的 gas 追蹤工具，或透過 Web3 函式庫（例如 [ethers 的 `maxFeePerGas()`](https://oreil.ly/YuBC0)）查到。
2. 依照我們希望交易多快完成，選擇一個優先費用（也就是小費）。如果我們趕時間，就可以提高小費。gas 追蹤工具可以根據目前的網路狀況，以及我們需要事情多快完成，幫助我們決定適當的小費金額。
3. 把總 gas 價格（基本費用 + 小費）乘以估計的 gas 用量。如果我們是開發者，可以用 Web3 函式庫（例如 [ethers 的 `estimateGas()`](https://oreil.ly/sfqZP)）計算估計的 gas 用量。但如果我們只是一般使用者，也不用擔心——送出交易時，任何錢包應用程式都會自動幫我們處理。

例如，如果基本費用是 20 gwei，我們設定的小費是 2 gwei，而交易用了 50,000 gas，那麼估計的 gas 成本就是：

(20 gwei + 2 gwei) × 50,000 = 1,100,000 gwei

所以，也就是 110 萬 gwei，或 0.0011 ETH。

建議你把評估函式的 gas 成本納入開發流程，以免把合約部署到主網時出現任何意外。

## 結語

本章開始詳細介紹智能合約，並探討了 Solidity 這種合約程式語言。我們以一個簡單的範例合約 *Faucet.sol* 為例，逐步加以改善、讓它變得更複雜，並藉此探索 Solidity 語言的各個面向。在第 8 章，我們會介紹另一種合約導向程式語言 Vyper。我們會把 Vyper 與 Solidity 做比較，說明這兩種語言在設計上的一些差異，加深我們對智能合約程式設計的理解。
