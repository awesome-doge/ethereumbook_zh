# 第 10 章　代幣

*代幣*（token）一詞源自古英語的 *tācen*，意思是記號或符號。它通常用來指私人發行、具有特定用途、類似硬幣、本身價值微不足道的東西，例如交通代幣、洗衣代幣與遊樂場的遊戲代幣。如今，在區塊鏈上管理的代幣正在重新定義這個詞，讓它指稱一種以區塊鏈為基礎、可以被擁有、代表資產、貨幣或存取權的抽象概念。

*代幣*這個詞之所以和「價值微不足道」連在一起，很大程度是因為實體代幣的用途有限。實體代幣通常只能用在特定的商家、組織或地點，不容易交換，而且一般只有一種功能。區塊鏈代幣解除了這些限制，或者更精確地說，讓這些限制可以完全重新定義。許多區塊鏈代幣在全球範圍內身兼多種用途，可以在全球流動的市場上互相交易，或與其他貨幣交易。使用與擁有的限制消失之後，「價值微不足道」的印象也成了過去式。

本章會介紹代幣的各種用途，以及代幣是如何建立的。我們也會討論代幣的屬性，例如同質化與內在性。最後，我們會檢視代幣所依據的標準與技術，並動手建立我們自己的代幣來實驗。

## 代幣的用途

代幣最明顯的用途是當作數位的私人貨幣，但這只是其中一種可能。代幣可以透過程式設計來發揮許多不同的功能，而這些功能經常互相重疊。例如，一個代幣可以同時代表投票權、存取權，以及某項資源的所有權。如下列清單所示，貨幣只是第一個「應用」：

**貨幣**

代幣可以作為一種貨幣，價值由私人交易決定。

**資源**

代幣可以代表在共享經濟或資源共享環境中賺取或產出的資源，例如代表可以透過網路共享之資源的儲存空間代幣或 CPU 代幣。

**資產**

代幣可以代表內在或外在、有形或無形資產的所有權，例如黃金、不動產、汽車、石油、能源、MMOG（大型多人線上遊戲）道具等等。

**存取權**

代幣可以代表存取權，授予對數位或實體財產的存取，例如討論區、專屬網站、飯店房間或租賃汽車。

**股權**

代幣可以代表在數位組織（例如去中心化自治組織（DAO））或法律實體（例如公司）中的股東權益。

**投票權**

代幣可以代表數位或法律體系中的投票權。

**收藏品**

代幣可以代表數位收藏品（例如 CryptoPunks）或實體收藏品（例如一幅畫）。

**身分**

代幣可以代表數位身分（例如虛擬化身）或法律身分（例如國民身分證）。

**認證**

代幣可以代表由某個權威機構或去中心化信譽系統所做的認證，或對某項事實的證明（例如婚姻紀錄、出生證明或大學學位）。

**效用**

代幣可以用來存取或支付某項服務。

一個代幣經常同時涵蓋上述好幾種功能。有時候這些功能很難區分，因為它們在實體世界中的對應物一向密不可分。例如在實體世界裡，駕照（認證）同時也是身分證件（身分），兩者無法分開。在數位領域中，過去混在一起的功能可以分開、獨立發展（例如匿名的認證）。

## 代幣與同質化

[維基百科](https://oreil.ly/ge7zP)說：「在經濟學中，同質性是指一種商品或物品的各個單位在本質上可以互相替換的性質。」如果代幣的任何一個單位都可以用另一個單位替換，而價值或功能沒有任何差別，這種代幣就是*同質化*的。

*非同質化代幣*（nonfungible token，NFT）是每一個都代表一件獨一無二的有形或無形物品、因此無法互相替換的代幣。例如，代表某幅*特定*梵谷畫作所有權的代幣，和代表一幅畢卡索畫作的代幣並不相等，即使兩者可能屬於同一個「藝術品所有權代幣」系統。同樣地，代表某個*特定*數位收藏品（例如某一隻特定的 CryptoKitty）的代幣，也無法和其他任何 CryptoKitty 互換。每個 NFT 都對應一個唯一的識別碼，例如序號。

本章稍後會看到同質化代幣與非同質化代幣的例子。

> **備註**
>
> 請注意，*fungible* 經常被用來表示「可以直接換成錢」（例如賭場的籌碼可以「兌現」，洗衣代幣通常不行）。我們在這裡使用這個詞，*不是*這個意思。

## 交易對手風險

*交易對手風險*（counterparty risk）是指交易的*另一方*無法履行義務的風險。有些類型的交易因為牽涉兩方以上，而承擔額外的交易對手風險。例如，如果你持有某種貴金屬的存單，並把它賣給某人，這筆交易至少有三方：賣方、買方，以及貴金屬的託管機構。總要有人持有實體資產；這個人必然成為交易履行的一方，也為任何牽涉這項資產的交易增添了交易對手風險。一般來說，當資產是透過交換所有權代幣的方式間接交易時，就會多出來自資產託管機構的交易對手風險。他們真的持有這項資產嗎？他們會依據代幣（例如憑證、契據、產權證明或數位代幣）的轉移，承認（或允許）所有權的移轉嗎？在代表資產的數位代幣世界裡，就像在非數位世界中一樣，重要的是弄清楚是誰持有代幣所代表的資產，以及這項標的資產適用哪些規則。

## 代幣與內在性

*內在*（intrinsic）一詞源自拉丁文的 *intra*，意思是「來自內部」。有些代幣代表的是區塊鏈內在的數位物品。這些數位資產和代幣本身一樣，受共識規則管轄。這帶來一個重要的意涵：代表內在資產的代幣不會帶來額外的交易對手風險。如果你持有某隻 CryptoKitty 的金鑰，就沒有其他人替你保管那隻 CryptoKitty——你直接擁有它。區塊鏈的共識規則適用於此，你對私鑰的擁有（也就是控制權）就等同於對這項資產的擁有，中間沒有任何中介。

相反地，許多代幣被用來代表*外在*（extrinsic）的事物，例如不動產、公司的有表決權股份、商標、金條與債券。這些不在區塊鏈「之內」的物品，其所有權由法律、慣例與政策管轄，與管轄代幣的共識規則是分開的。換句話說，代幣的發行者與擁有者可能仍然仰賴現實世界中的非智能合約。因此，這些外在資產會帶來額外的交易對手風險，因為它們由託管機構持有、登記在外部的登記處，或受區塊鏈環境之外的法律與政策控制。

區塊鏈代幣最重要的影響之一，是能把外在資產轉換成內在資產，從而消除交易對手風險。一個很好的例子是從公司的股權（外在）轉向 DAO 或類似組織的股權代幣或投票代幣（內在）。穩定幣是另一個例子：它們是與法定貨幣掛鉤、由國庫券與現金儲備等外在資產支持的區塊鏈代幣。

## 效用、股權，還是撈錢？

幾乎每個以太坊專案上線時似乎都會推出某種代幣。但這些專案真的都需要代幣嗎？「把一切都代幣化」這句口號聽起來很響亮，現實卻複雜得多。代幣可以是組織社群、為社群提供誘因的強大工具，但它們也成了投機與炒作的代名詞。

理論上，代幣有兩種主要用途。第一種是 *效用型代幣*（utility token），設計用來在特定生態系中提供某項服務或資源的存取。例如，代幣可以代表去中心化網路上的儲存空間，或去中心化應用（DApp）中進階功能的使用權。在這種情況下，代幣的價值與它在平台中的功能綁在一起。第二種是*股權代幣*，它應該要像公司的股份一樣運作。這類代幣可以代表對某個專案的所有權或控制權，例如 DAO 中的投票權或利潤分配。

實務上，這兩類之間的界線經常很模糊。許多效用型代幣大體上仍然是投機標的，使用者持有它們比較像是持有資產，而不是存取憑證。類似股權的代幣也許授予治理權，卻往往缺乏確保有意義參與的機制。有些專案把代幣深深整合進自己的經濟模型，但這仍是例外，而不是常態。

這帶出了一個問題：代幣本質上就是壞東西嗎？完全不是。在建立社群、為社群提供誘因，或驅動 DAO 的去中心化治理上，代幣可以非常有效。但現實是，大多數代幣推出的主要動機是獲利，而不是效用。如果你正在考慮推出代幣或投資某個代幣，值得問自己一些尖銳的問題：這個代幣在協議中真的發揮了必要的作用，還是只是募資工具？沒有它，這個專案是不是也一樣能運作？誠實回答這些問題，可以幫助你分辨真正的創新與行銷驅動的炒作。

很明顯，代幣的版圖仍在演變，代幣本身無所謂好壞；它們的價值取決於如何設計與實作。挑戰在於把有意義的和沒有意義的區分開來，並抵擋下一個迷因幣（meme coin）的誘惑。

> **備註**
>
> 撰寫本章期間（2025 年 1 月），剛當選的總統川普推出了他自己的迷因幣，在短短一天內市值（market cap）就達到 150 億美元。許多人原本期待他的任期會帶來有利於加密貨幣的政策，結果我們等到的是一個迷因幣。這件事凸顯了主宰加密貨幣圈的投機狂熱，炒作往往勝過實質。

## 它就是一隻鴨子！

代幣長久以來一直是新創公司最愛的募資工具。它們承諾創新、去中心化，有時甚至直接承諾財務自由。但問題就在這裡：在大多數司法管轄區，向大眾發行證券是受監管的活動，而代幣很容易就越界進入證券的範疇。多年來，許多專案試圖把自己的代幣包裝成「效用型代幣」，聲稱這只是未來服務使用權的預售，藉此規避監管。他們的邏輯是：只要代幣不是股份，就不是證券。但正如那句老話所說：「如果它走路像鴨子、叫聲也像鴨子，它就是一隻鴨子。」而監管機關，尤其是美國證券交易委員會（SEC），正密切注意著這些鴨子。

過去幾年來，SEC 對代幣發行的立場越來越強硬，打擊那些想在效用與股權之間游走的專案。例如在 2020 年，SEC 就 XRP 代幣對 Ripple Labs 提起訴訟，主張 XRP 是未經註冊的證券。Ripple 則主張 XRP 是貨幣而不是證券，而法院的部分判決顯示了這類案件可以有多麼微妙。

就連以太坊本身也逃不過審視。早在 2018 年，前 SEC 官員就宣稱以太幣（ether）已經「充分去中心化」，因此不是證券。但最近到了 2024 年，SEC 暗示以太坊轉向權益證明（PoS）可能讓它重新受到檢視。為什麼？因為質押獎勵類似股利，而股利正是證券的特徵之一。這些發展顯示監管環境已經變得多麼多變且難以預測。

令人著迷，也令人沮喪的是，這些案件經常歸結為語意之爭。專案方聲稱自己的代幣是效用工具，就像某項服務的門票。但如果買家的主要動機是投機，在 SEC 眼中這就是證券，再簡單不過。挑戰在於，用來做出這些判定的法律框架，早在區塊鏈技術出現之前就已建立。Howey 測試在 1940 年代發展出來，用以界定投資契約，它並不是為去中心化網路或可程式化資產而設計的。因此，把它套用在加密貨幣專案上並不總是那麼直截了當。創新者想要募資、建立社群，監管機關則想保護投資人不受誤導。結果呢？一齣一再上演的法庭劇，數十億美元與整個生態系的命運都懸而未決。

## 以太坊上的代幣

區塊鏈代幣在以太坊之前就已存在。在某種意義上，第一個區塊鏈貨幣比特幣本身就是一種代幣。在以太坊出現之前，比特幣與其他加密貨幣上也已發展出許多代幣平台。然而，以太坊推出第一個代幣標準之後，代幣的數量便爆炸性成長。

Vitalik Buterin 曾提出，代幣是以太坊這類通用可程式化區塊鏈最明顯、也最有用的應用之一。事實上，在以太坊的第一年，常常可以看到 Buterin 等人穿著印有以太坊標誌、背面印著智能合約範例的 T 恤。這件 T 恤有好幾種版本，但最常見的那款印的是一個代幣的實作。

在深入探討如何在以太坊上建立代幣之前，必須先對代幣在以太坊上如何運作有個概觀。代幣和以太幣不同，因為以太坊協議對代幣一無所知。發送以太幣是以太坊平台內在的動作，發送甚至擁有代幣則不是。以太坊帳戶的以太幣餘額是在協議層處理的，而以太坊帳戶的代幣餘額則是在智能合約層處理的。要在以太坊上建立新的代幣，你必須建立一個新的智能合約。智能合約部署之後，就由它處理一切，包括所有權、轉帳與存取權。你可以用任何你想要的方式撰寫智能合約來執行所有必要的動作，但遵循現有的標準大概是最明智的做法。接下來我們就來看看這些標準。

## ERC-20 代幣標準

第一個標準由 Fabian Vogelsteller 在 2015 年 11 月以以太坊徵求意見（ERC）的形式提出。它被自動分配到 GitHub issue 編號 20，「ERC-20 代幣」這個名稱由此而來。目前絕大多數的代幣都以 ERC-20 標準為基礎。ERC-20 這份徵求意見後來成為 EIP-20，但大多數人仍沿用原本的名稱 ERC-20。

ERC-20 是同質化代幣的標準，也就是說，ERC-20 代幣的不同單位可以互相替換，沒有獨特的屬性。[ERC-20 標準](https://oreil.ly/Psw-O)為實作代幣的合約定義了一個共同的介面，讓任何相容的代幣都能以同樣的方式存取與使用。這個介面包含一些在每個標準實作中都必須具備的函式，以及一些開發者可以自行加入的選用函式與屬性。

### ERC-20 的必要函式與事件

符合 ERC-20 的代幣合約至少必須提供下列函式與事件：

`totalSupply`

回傳這個代幣目前存在的總單位數。ERC-20 代幣的供給量可以是固定的，也可以是變動的。

`balanceOf`

給定一個地址，回傳該地址的代幣餘額。

`transfer`

給定一個地址與數量，從執行轉帳的地址餘額中，把該數量的代幣轉給那個地址。

`transferFrom`

給定發送者、接收者與數量，把代幣從一個帳戶轉到另一個帳戶。與 `approve` 搭配使用。

`approve`

給定一個接收者地址與數量，授權該地址從發出授權的帳戶執行多筆轉帳，總額以該數量為上限。

`allowance`

給定一個擁有者地址與一個支用者（spender）地址，回傳支用者仍被授權從擁有者那裡提取的剩餘數量。

`transfer`

轉帳成功（呼叫 `transfer` 或 `transferFrom`）時觸發的事件，即使轉帳金額為零也會觸發。[^tn1]

`approval`

成功呼叫 `approve` 時記錄的事件。

[^tn1]: 譯註：這兩項指的是事件，在下方「以 Solidity 定義的 ERC-20 介面」程式碼中分別宣告為 `Transfer` 與 `Approval`（首字母大寫），與同名的 `transfer` 函式不同。

#### ERC-20 的選用函式

除了上一節列出的必要函式之外，標準也定義了下列選用函式：

**Name**

回傳代幣的人類可讀名稱（例如「US dollars」）。

**Symbol**

回傳代幣的人類可讀符號（例如「USD」）。

**decimals**

回傳用來切分代幣數量的小數位數。例如，如果小數位數是 2，代幣數量 1,000 實際上代表餘額 10。

#### 以 Solidity 定義的 ERC-20 介面

以下是 ERC-20 介面規格在 Solidity 中的樣子：

```solidity
contract ERC20 {
   function totalSupply() public view returns (uint256 theTotalSupply);
   function balanceOf(address _owner) public view returns (uint256 balance);
   function transfer(address _to, uint256 _value) public returns (bool success);
   function transferFrom(address _from, address _to, uint256 _value) public returns
      (bool success);
   function approve(address _spender, uint256 _value) public returns (bool success);
   function allowance(address _owner, address _spender) public view returns
      (uint256 remaining);
   event Transfer(address indexed _from, address indexed _to, uint256 _value);
   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
```

#### ERC-20 的資料結構

檢視任何一個 ERC-20 實作，你都會看到它包含兩個資料結構：一個追蹤餘額，一個追蹤授權額度。在 Solidity 中，它們是用 *mapping* 實作的。

第一個 mapping 實作了一張依擁有者記錄代幣餘額的內部表格，讓代幣合約可以追蹤誰擁有代幣。每一筆轉帳都是從一個餘額中扣除，再加到另一個餘額上：

```solidity
mapping(address account => uint256) _balances;
```

第二個資料結構是記錄授權額度的 mapping。我們在下一節會看到，ERC-20 代幣的擁有者可以把權限委託給支用者，讓對方從擁有者的餘額中花用特定的數量（授權額度）。ERC-20 合約用一個二維的 mapping 追蹤授權額度，主鍵是代幣擁有者的地址，對應到支用者地址與授權額度：

```solidity
mapping(address account => mapping(address spender => uint256)) public _allowances;
```

#### ERC-20 的流程：「transfer」與「approve 加 transferFrom」

ERC-20 代幣標準有兩個轉帳函式。你可能會好奇為什麼。

ERC-20 支援兩種不同的流程。第一種是直截了當、只需一筆交易的流程，使用 `transfer` 函式。錢包把代幣發送到其他錢包時，用的就是這個流程。絕大多數的代幣交易都是透過 `transfer` 流程進行的。

執行轉帳非常簡單。如果 Alice 想發送 10 個代幣給 Bob，她的錢包會向代幣合約的地址發送一筆交易，以 Bob 的地址和 `10` 為引數呼叫 `transfer` 函式。代幣合約會調整 Alice 的餘額（–10）與 Bob 的餘額（+10），並發出一個 `Transfer` 事件。

第二種是需要兩筆交易的流程，先用 `approve`，再用 `transferFrom`。這個流程讓代幣擁有者可以把控制權委託給另一個地址。它最常用來把控制權委託給某個合約以分發代幣，但交易所也可以使用。例如，如果一家公司正在為 首次代幣發行（initial coin offering，ICO）銷售代幣，它可以 `approve` 一個群眾募資（crowdsale）合約地址，讓它分發一定數量的代幣。接著，群眾募資合約就可以從代幣合約擁有者的餘額中，以 `transferFrom` 把代幣轉給每一位購買者，如圖 10-1 所示。

![The two-step approve and transferFrom workflow of ERC-20 tokens](images/ch10/maet_1001.png)

**圖 10-1.** ERC-20 代幣兩步驟的 `approve` 與 `transferFrom` 流程

> **備註**
>
> *initial coin offering*（ICO）是公司與組織透過銷售代幣來募集資金的一種群眾募資機制。這個名稱衍生自*首次公開發行*（initial public offering，IPO），也就是公開發行公司在證券交易所向投資人出售股份的程序。與受到高度監管的 IPO 市場不同，ICO 是開放、全球性而且混亂的。

`approve` 與 `transferFrom` 流程需要兩筆交易。假設 Alice 想讓 `AliceICO` 合約把全部 AliceCoin 代幣的 50% 賣給 Bob 和 Charlie 這樣的購買者。首先，Alice 推出 `AliceCoin` ERC-20 合約，把所有 AliceCoin 發行到她自己的地址。然後，Alice 推出可以用代幣換取以太幣的 `AliceICO` 合約。接下來，Alice 啟動 `approve` 與 `transferFrom` 流程：她向 `AliceCoin` 合約發送一筆交易，以 `AliceICO` 合約的地址和 `totalSupply` 的 50% 為引數呼叫 `approve`。這會觸發 `Approval` 事件。現在，`AliceICO` 合約就可以出售 AliceCoin 了。

`AliceICO` 合約收到 Bob 的以太幣時，需要回送一些 AliceCoin 給 Bob。`AliceICO` 合約內設有 AliceCoin 與以太幣之間的匯率。Alice 建立 `AliceICO` 合約時設定的匯率，決定了 Bob 發送到 `AliceICO` 合約的以太幣能換到多少代幣。`AliceICO` 合約呼叫 AliceCoin 的 `transferFrom` 函式時，會把 Alice 的地址設為發送者、Bob 的地址設為接收者，並依匯率決定要在 `value` 欄位中轉給 Bob 多少 AliceCoin 代幣。`AliceCoin` 合約會把餘額從 Alice 的地址轉到 Bob 的地址，並觸發一個 `Transfer` 事件。只要不超過 Alice 設定的授權上限，`AliceICO` 合約可以不限次數地呼叫 `transferFrom`。`AliceICO` 合約可以呼叫 `allowance` 函式，追蹤自己還能出售多少 AliceCoin 代幣。

#### ERC-2612：用「permit」實現免 gas 的轉帳

在第 9 章中，我們完整探討了 ERC-20 代幣傳統的 `transfer` 與 `transferFrom` 流程的來龍去脈。[^tn2]雖然這些方法一直是代幣轉帳的骨幹，但它們並非沒有限制。直接轉帳需要代幣擁有者提交一筆鏈上交易。在 approve 加 transferFrom 的流程中，擁有者提交第一筆 approve 交易，支用者或被授權的合約則提交後續的 transferFrom。因此，擁有者需要原生加密貨幣來支付授權的費用，對於沒有原生資金的新錢包來說，這可能是一大障礙。

[^tn2]: 譯註：`transfer` 與 `transferFrom` 流程的詳細說明，其實是本章前面的「ERC-20 的流程：『transfer』與『approve 加 transferFrom』」一節；第 9 章只在討論 SafeERC20 時順帶提到這些函式。

這正是 ERC-2612 派上用場的地方。它是 ERC-20 代幣標準的一項巧妙擴充，讓使用者不必親自碰觸區塊鏈，就能授權代幣轉帳。運作方式如下：你不需要發送一筆鏈上交易來授權轉帳，只要用錢包簽署必要的資料——例如接收者的地址、代幣數量、到期時間與 nonce。這會產生一個簽章，而需要執行轉帳的人（不論是接收者或其他人）可以把這個簽章提交給代幣合約的 `permit` 方法。合約會讀取簽章、驗證它並處理授權，整個過程中你都不需要為第一步支付 gas。這種方式既有效率又安全，也省去了流程中的許多麻煩。

要讓 ERC-2612 運作，代幣開發者需要擴充自己的 ERC-20 合約來加入這項功能。一旦加入，它會為使用者帶來兩個主要好處。第一，它簡化了整個流程：使用者不必為每一筆轉帳逐一授權，只要一個簽章就能授予權限。第二，因為減少了所需的交易數量，可以節省 gas 成本。

#### ERC-20 的實作

雖然大約 30 行 Solidity 程式碼就能實作一個與 ERC-20 相容的代幣，但大多數實作都更複雜，這是為了因應潛在的安全漏洞。EIP-20 標準提到了兩個實作，分別由 Consensys 與 OpenZeppelin 開發。Consensys 的 EIP-20 代幣自 2018 年以來就沒有再維護，而 [OpenZeppelin 的 ERC-20 代幣](https://oreil.ly/7d7RD)則成為開發者事實上的標準，並持續積極維護。OpenZeppelin 函式庫以這個實作為基礎，實作出更複雜、與 ERC-20 相容的代幣，具備募資上限、代幣化金庫（vault）、歸屬時程（vesting schedule）等功能。

### 推出我們自己的 ERC-20 代幣

讓我們建立並推出自己的代幣。這個例子會使用 Foundry 框架。範例假設你已經[安裝 Foundry](https://oreil.ly/dfDGh) 並完成組態，也熟悉它的基本操作。

我們把代幣命名為「Mastering Ethereum Token」，符號是 MET。首先，用下列指令建立並初始化一個 Foundry 專案目錄：

```bash
$ mkdir METoken
$ cd METoken
$ forge init
```

現在你應該會有下列目錄結構：

```
METoken/
├── foundry.toml
├── lib
│   └── forge-std
│       └── ...
├── README.md
├── script
│   └── Counter.s.sol
├── src
│   └── Counter.sol
└── test
    └── Counter.t.sol
```

`Counter` 是 Foundry 預設的範例合約，附帶自己的測試與部署腳本。我們會刪除所有相關檔案，騰出空間給我們的代幣合約。

在這個例子中，我們會匯入 OpenZeppelin 函式庫，它是以 Solidity 撰寫代幣的業界標準：

```bash
$ forge install OpenZeppelin/openzeppelin-contracts
[...]
Installed openzeppelin-contracts v5.2.0
```

現在在 *METoken/lib/openzeppelin-contracts/contracts* 裡，可以看到所有的 OpenZeppelin 合約。OpenZeppelin 函式庫包含的遠不只 ERC-20 代幣，但我們只會用到其中一小部分。

接下來，我們來撰寫代幣合約。建立一個新檔案 *METoken.sol*，並複製範例 10-1 的程式碼。我們的合約非常簡單，因為它的所有功能都繼承自 OpenZeppelin 函式庫。

**範例 10-1. METoken.sol：實作 ERC-20 代幣的 Solidity 合約**

```solidity
pragma solidity 0.8.28;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract METoken is ERC20 {
    constructor(uint256 initialSupply) ERC20("METoken", "MET") {
        _mint(msg.sender, initialSupply);
    }
}
```

這裡我們把 `"METoken"` 與 `"MET"` 當作名稱與符號，傳給 ERC-20 合約的建構子。代幣的初始供給量在部署時以建構子參數提供，並會發送給這個代幣合約的部署者（`msg.sender`）。小數位數我們使用預設值 18，這是 ERC-20 代幣廣泛採用的標準。

現在我們可以用 Foundry 編譯 `METoken` 合約：

```bash
$ forge build
[⠊] Compiling...
[⠒] Compiling 6 files with Solc 0.8.28
[⠢] Solc 0.8.28 finished in 36.18ms
Compiler run successful!
```

接著設定一個部署腳本，把 `METoken` 合約放上區塊鏈。在 *METoken/script* 資料夾中建立新檔案 *METokenDeploy.s.sol*，並複製下列程式碼：

```solidity
pragma solidity 0.8.28;
import {Script, console} from "forge-std/Script.sol";
import {METoken} from "../src/METoken.sol";
contract METokenDeployer is Script {
    METoken public _METoken;
    function run() public {
        vm.startBroadcast();
        _METoken = new METoken(50_000_000e18);
        vm.stopBroadcast();
    }
}
```

在這個例子中，我們傳入 5,000 萬作為初始供給量。你有沒有注意到我們乘上了 1e18？那就是代幣的小數位數。記住，要擁有 *X* 個代幣的餘額，代幣數量必須是 *X* × 10 ^ decimals。

> **備註**
>
> 腳本檔名的 *.s.sol* 後綴是 Foundry 的命名慣例，用來快速辨認檔案的用途。這不是必要條件——把腳本檔放在 script 資料夾裡就夠了——但這是非常好的做法，在開發過程中會派上用場。測試檔的 *.t.sol* 後綴也是同樣的道理。

在部署到以太坊的某個測試網路之前，我們先啟動一條本地區塊鏈來測試一切。我們會使用 Foundry 工具箱中的另一個工具：Anvil，一個本地的以太坊開發節點。要使用它，只要開啟一個新的終端機並輸入 `anvil`。主控台會顯示可用帳戶的清單、它們的私鑰、chain ID、RPC URL 等資訊。RPC URL 是讓 Foundry（或任何以太坊客戶端）與我們的本地區塊鏈節點通訊的端點，可以用來發送交易、部署合約與擷取資料。*http://127.0.0.1:8545* 是 Anvil 預設的 RPC。要讓部署腳本部署到本地區塊鏈，我們需要用 `--rpc-url "http://127.0.0.1:8545"` 旗標，把 Anvil 的 RPC URL 當作命令列參數提供給它。

最後還需要部署者帳戶的私鑰。由於這是一條本地區塊鏈，我們在以太坊主網或測試網路上使用的地址在這裡不會有任何資金，而且我們也不想沒必要地暴露真正的私鑰。因此，我們會使用 Anvil 啟動時產生的測試帳戶。這些帳戶在我們的本地鏈上預先存有 10,000 ETH，非常適合開發與測試。

現在可以執行下列指令來部署我們的代幣：

```bash
$ forge script script/METokenDeploy.s.sol --broadcast --rpc-url "http://127.0.0.1:8545"
--private-key <DEPLOYER_PRIVATE_KEY>
[⠊] Compiling...
No files changed, compilation skipped
Script ran successfully.
```

> **備註**
>
> 你可能會好奇 `--broadcast` 旗標的用途。它是用來告訴 Foundry 真的把交易廣播到區塊鏈上。沒有這個旗標，Foundry 只會模擬交易。

主控台的輸出告訴我們部署腳本已成功執行。如果查看正在執行 Anvil 的終端機，會發現許多活動，其中就包括我們的合約建立：

```
   Transaction: 0xd01e3a90e1f2ee60112658e92f4ebf04c24df67d2ec1315cfb79d145729d15ec
    Contract created: 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
    Gas used: 941861
    Block Number: 1
    Block Hash: 0x748b6058dea932317cacf45bb63be82f253554f359b97ace224e35979a92b00a
    Block Time: "Fri, 31 Jan 2025 19:10:42 +0000"
```

我們的 METoken 已成功部署在下列地址：

```
0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
```

另外，我們也可以用 forge 的 `create` 命令列指令來部署代幣：

```bash
$ forge create METoken --broadcast --rpc-url http://127.0.0.1:8545 --private-key
<DEPLOYER_PRIVATE_KEY> --constructor-args 50000000000000000000000000
```

這裡把總供給量當作建構子引數傳入，並已把小數位數考慮進去。

#### 與 METoken 互動

我們可以用好幾種方式與合約互動：可以用 Remix（如同第 2 章的做法）、像 Foundry 的 Chisel 這樣的 Solidity REPL，或是像 ethers.js 這樣的 JavaScript 函式庫。我們也可以用 Foundry 腳本執行交易，這正是我們在範例中要用的方式。

以太坊地址是 40 個字元的十六進位字串，不太容易閱讀。為了讓範例更清楚，我們會為使用的兩個地址取暱稱：部署 MET 合約的地址叫 Deployer，另一個次要地址叫 Alice。Alice 的地址也會使用 Anvil 預先注資的地址之一。

我們來建立一個 Foundry 腳本，查詢 Deployer 的 METoken 餘額，並發送一些 METoken 給 Alice。複製下列程式碼片段的內容，貼到新檔案 *METoken/script/METokenInteraction.s.sol* 中：

```solidity
pragma solidity 0.8.28;
import {Script, console} from "forge-std/Script.sol";
import {METoken} from "../src/METoken.sol";
contract METokenInteraction is Script {
    METoken public _METoken = METoken(0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512);
    address alice = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    function run() public {
        vm.startBroadcast();
        uint256 ourBalance = _METoken.balanceOf(msg.sender);
        console.log("Deployer initial balance:", ourBalance);
        uint256 aliceBalance = _METoken.balanceOf(alice);
        console.log("Alice initial balance:", aliceBalance);
        uint256 amountToTransfer = 50e18;
        bool success = _METoken.transfer(alice, amountToTransfer);
        if (success) {
            console.log("Transfer successful");
        } else {
            console.log("Transfer failed");
            revert();
        }
        ourBalance = _METoken.balanceOf(msg.sender);
        console.log("Deployer final balance:", ourBalance);
        aliceBalance = _METoken.balanceOf(alice);
        console.log("Alice final balance:", aliceBalance);
        vm.stopBroadcast();
    }
}
```

我們可以用下列命令列指令執行這個腳本：

```bash
$ forge script script/METokenInteraction.s.sol --private-key <DEPLOYER_PRIVATE_KEY>
--rpc-url "http://127.0.0.1:8545" -vv
```

重要的是要使用部署時用的同一把私鑰，這樣才能確保 `msg.sender` 對應到持有初始代幣供給量的部署者地址。

> **備註**
>
> Foundry 的 `-v` 旗標控制執行 `forge script` 或 `forge build` 等指令時輸出的詳細程度。`v` 的數量越多，輸出就越詳細，包含越多資訊。要顯示主控台日誌，至少需要 `-vv`，而最詳細的輸出由 `-vvvv` 提供。

執行腳本後，主控台會印出下列內容：

```bash
[⁘] Compiling...
[:] Compiling 1 files with Solc 0.8.28
[⁖] Solc 0.8.28 finished in 312.39ms
Compiler run successful!
Script ran successfully.
== Logs ==
  Deployer initial balance: 50000000000000000000000000
  Alice initial balance: 0
  Transfer successful
  Deployer final balance: 49999950000000000000000000
  Alice final balance: 50000000000000000000
```

在這個腳本中，我們先記錄部署者與 Alice 目前的代幣餘額。接著，從部署者轉 50 個代幣給 Alice，再記錄一次餘額。請記住，因為我們的代幣有 18 位小數，50 個代幣表示成 50e18，所以才會有那麼多個零。

#### 把 ERC-20 代幣發送到合約地址

到目前為止，我們已經設定好一個 ERC-20 代幣，並把一些代幣從一個帳戶轉到另一個帳戶。這些示範中使用的帳戶都是外部擁有帳戶（EOA），也就是由私鑰而不是合約控制的帳戶。如果我們把 MET 代幣發送到合約地址，會發生什麼事？我們來看看！

首先，在測試環境中部署另一個合約。這個例子會使用下列的 *NaiveFaucet.sol* 合約：

```solidity
pragma solidity 0.8.28;
contract NaiveFaucet {
    receive() external payable {}
    // Function to withdraw Ether from the contract
    function withdraw(uint256 amount) public {
        require(amount <= address(this).balance, "Insufficient balance in faucet");
        payable(msg.sender).transfer(amount);
    }
}
```

我們的目錄應該會像這樣：

```
METoken/
+---- src
|   +---- NaiveFaucet.sol
|   +---- METoken.sol
```

我們來編譯並部署 `NaiveFaucet` 合約：

```bash
$ forge create NaiveFaucet --broadcast --rpc-url http://localhost:8545
--private-key <DEPLOYER_PRIVATE_KEY>
[⁘] Compiling...
[:] Compiling 1 files with Solc 0.8.28
[⁖] Solc 0.8.28 finished in 8.69ms
Compiler run successful!
Deployer: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
Deployed to: 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
Transaction hash: 0x4d1947547e3cfec8db670f3c1b7ff309b41de8aacee42165578a3ddf8619f63f
```

太好了，我們的 `NaiveFaucet` 合約已部署到地址 `0x9fE46736679​d2D9a65F0992F2272dE9f3c7fa6e0`。現在，把下列腳本複製到 *METoken/script/METokenSend.s.sol*，發送一些 MET 給 `NaiveFaucet` 合約：

```solidity
pragma solidity 0.8.28;
import {Script, console} from "forge-std/Script.sol";
import {METoken} from "../src/METoken.sol";
contract METokenSend is Script {
    METoken public _METoken = METoken(0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512);
    address naiveFaucet = 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0;
    function run() public {
        vm.startBroadcast();
        uint256 amountToSend = 100e18;
        bool success = _METoken.transfer(naiveFaucet, amountToSend);
        if (success) {
            console.log("Transfer successful");
        } else {
            console.log("Transfer failed");
            revert();
        }
        uint256 faucetBalance = _METoken.balanceOf(naiveFaucet);
        console.log("Faucet balance:", faucetBalance);
        vm.stopBroadcast();
    }
}
```

我們可以這樣執行它：

```bash
$ forge script script/METokenSend.s.sol --private-key <DEPLOYER_PRIVATE_KEY>
--rpc-url "http://127.0.0.1:8545" -vv
[⁘] Compiling...
[:] Compiling 1 files with Solc 0.8.28
[⁖] Solc 0.8.28 finished in 413.41ms
Compiler run successful!
Script ran successfully.
== Logs ==
  Transfer successful
  Faucet balance: 100000000000000000000
```

同樣地，我們需要使用部署者的私鑰才能讓它運作，因為發起這筆轉帳的就是那個地址。

我們已經把 100 MET 轉給 `NaiveFaucet` 合約。現在，要怎麼把這些代幣提領出來？

別忘了，*NaiveFaucet.sol* 是一個相當簡單的合約。它只有一個函式 `withdraw`，用來提領*以太幣*。它沒有提領 MET 或任何其他 ERC-20 代幣的函式。如果我們使用 `withdraw`，它會嘗試發送以太幣，但因為 `NaiveFaucet` 還沒有任何以太幣餘額，所以會失敗。

`METoken` 合約知道 `NaiveFaucet` 有餘額，但它要轉出這筆餘額，唯一的方式是收到來自該合約地址的 `transfer` 呼叫。我們得想辦法讓 `NaiveFaucet` 合約呼叫 `METoken` 中的 `transfer` 函式。

如果你正在想下一步該怎麼做，不用想了。這個問題沒有解決辦法。發送到 `NaiveFaucet` 的 MET 被永遠卡住了。只有 `NaiveFaucet` 合約能轉出它，而 `NaiveFaucet` 合約沒有呼叫 ERC-20 代幣合約 `transfer` 函式的程式碼。

也許你早就預料到這個問題，但更可能的是你沒有。事實上，數以百計的以太坊使用者也沒有預料到，他們不小心把各種代幣轉給了完全不具備 ERC-20 處理能力的合約。多年來，總額高達數百萬美元、多得驚人的資金就這樣「卡住」，永遠遺失了。

#### 示範「approve 加 transferFrom」流程

我們的 `NaiveFaucet` 合約無法處理 ERC-20 代幣。用 `transfer` 函式把代幣發送給它，結果就是這些代幣遺失了。現在我們來改寫這個合約，讓它能處理 ERC-20 代幣。具體來說，我們會把它變成一個水龍頭，發放 MET 給任何提出請求的人。

我們新的水龍頭合約 *METFaucet.sol* 如範例 10-2 所示。

**範例 10-2. METFaucet.sol：METoken 的水龍頭**

```solidity
pragma solidity 0.8.28;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
contract METFaucet {
    IERC20 public _METoken;
    address public _METOwner;
    constructor(address _metokenAddress, address metOwner) {
        _METoken = IERC20(_metokenAddress);
        _METOwner = metOwner;
    }
    // Function to withdraw METoken from the contract
    function withdraw(uint256 amount) public {
        require(amount <= 10e18, "At most 10 MET");
        require(_METoken.transferFrom(_METOwner, msg.sender, amount), "Transfer failed");
    }
}
```

我們對基本的 `Faucet` 範例做了不少修改。因為 `METFaucet` 會使用 `METoken` 中的 `transferFrom` 函式，所以需要兩個額外的變數。一個存放 `METoken` 合約的地址，另一個存放 MET 擁有者的地址，由這位擁有者授權水龍頭的提領。在我們的例子中，擁有者就是部署者，因為初始供給量是發給他的。`METFaucet` 合約會呼叫 `METoken.transferFrom`，指示它把 MET 從擁有者轉到發出水龍頭提領請求的地址。

我們在這裡宣告這兩個變數：

```solidity
IERC20 public _METoken;
address public _METOwner;
```

由於水龍頭需要用 `METoken` 與 `METOwner` 的正確地址來初始化，我們需要宣告一個自訂的建構子：

```solidity
// METFaucet constructor - provide the address of the METoken contract and
// the owner address we will be approved to transferFrom
constructor(address _metokenAddress, address metOwner) {
    _METoken = IERC20(_metokenAddress);
    _METOwner = metOwner;
}
```

下一個修改是 `withdraw` 函式。`METFaucet` 不再呼叫 `transfer`，而是使用 `METoken` 中的 `transferFrom` 函式，請 `METoken` 把 MET 轉給水龍頭的領取者：

```solidity
// Use the transferFrom function of METoken
_METoken.transferFrom(metOwner, msg.sender, withdraw_amount);
```

最後，由於水龍頭不再發送以太幣，我們大概應該防止任何人把以太幣發送給 `METFaucet`，以免以太幣被卡住。要拒收傳入的以太幣，只要從合約中移除 `receive` 函式就夠了。

*METFaucet.sol* 的程式碼準備好之後，就可以提供 MET 代幣地址與其部署者作為地址參數，部署這個合約：

```bash
$ forge create METFaucet --broadcast --rpc-url http://localhost:8545 --private-key
<DEPLOYER_PRIVATE_KEY> --constructor-args
"0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512""0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
[⁘] Compiling...
No files changed, compilation skipped
Deployer: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
Deployed to: 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9
Transaction hash: 0xa8bfbde9489ee40d41328a80538d0d3e7778b7f3b896c1d51897bf85bb25cec2
```

`METFaucet` 合約已部署到 `0xCf7Ed3AccA5a467e9e704C703E​8D87F634fB0Fc9`，我們幾乎可以開始測試了。首先，撰寫一個 *METApprove.s.sol* 腳本，允許 `METFaucet` 合約花用擁有者的 MET 代幣：

```solidity
pragma solidity 0.8.28;
import {Script, console} from "forge-std/Script.sol";
import {METoken} from "../src/METoken.sol";
contract METApprove is Script {
    METoken public _METoken = METoken(0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512);
    address _METFaucet = 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9;
    function run() public {
        vm.startBroadcast();
        bool success = _METoken.approve(_METFaucet, type(uint256).max);
        if (success) {
            console.log("Approve successful");
        } else {
            console.log("Approve failed");
            revert();
        }
        vm.stopBroadcast();
    }
}
```

我們可以這樣執行它：

```bash
$ forge script script/METApprove.s.sol --broadcast --private-key <DEPLOYER_PRIVATE_KEY>
--rpc-url "http://127.0.0.1:8545" -vv
[⠊] Compiling...
[⠰] Compiling 2 files with Solc 0.8.28
[⠔] Solc 0.8.28 finished in 327.90ms
Compiler run successful!
Script ran successfully.
== Logs ==
  Approve successful
```

現在，我們可以撰寫一個腳本，讓次要地址與 `METFaucet` 合約互動，提領 10 個 MET 代幣，並記錄操作前後的餘額。我們依照範例 10-3 建立 *METFaucetWithdraw.s.sol* 腳本。

**範例 10-3. METFaucetWithdraw：水龍頭提領腳本**

```solidity
pragma solidity 0.8.28;
import {Script, console} from "forge-std/Script.sol";
import {METoken} from "../src/METoken.sol";
import {METFaucet} from "../src/METFaucet.sol";
contract METFaucetWithdraw is Script {
    METoken public _METoken = METoken(0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512);
    METFaucet public _METFaucet = METFaucet(0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9);
    function run() public {
        vm.startBroadcast();
       uint256 balanceBefore = _METoken.balanceOf(msg.sender);
       console.log("Alice balance before:", balanceBefore);
       _METFaucet.withdraw(10e18);
       uint256 balanceAfter = _METoken.balanceOf(msg.sender);
       console.log("Alice balance after:", balanceAfter);
        vm.stopBroadcast();
    }
}
```

現在，我們可以在執行腳本時提供 Alice 的私鑰，從 Alice 的地址執行這個腳本：

```bash
$ forge script script/METFaucetWithdraw.s.sol --broadcast --private-key <ALICE_PRIVATE_KEY>
--rpc-url "http://127.0.0.1:8545" -vv
[⠊] Compiling...
[⠰] Compiling 1 files with Solc 0.8.28
[⠔] Solc 0.8.28 finished in 330.97ms
Compiler run successful!
Script ran successfully.
== Logs ==
  Alice balance before: 0
  Alice balance after: 10000000000000000000
```

從結果可以看出，我們可以用 `approve` 與 `transferFrom` 流程，授權某個合約轉移另一個代幣合約所定義的代幣。只要使用得當，EOA 與其他合約都可以使用 ERC-20 代幣。然而，正確管理 ERC-20 代幣的負擔被推給了使用者介面。如果使用者誤把 ERC-20 代幣轉到某個合約地址，而該合約不具備接收 ERC-20 代幣的能力，這些代幣就會遺失。

### ERC-20 代幣的問題

ERC-20 代幣標準的普及可說是爆炸性的。數以千計的代幣已經推出，有的是為了實驗這些新能力，有的是為了在各種「群眾募資」拍賣與 ICO 中募集資金。然而，就像我們在把代幣轉到合約地址的問題中看到的，其中存在一些潛在的陷阱。

ERC-20 代幣有一個比較不明顯的問題：它們暴露了代幣與以太幣本身之間的細微差異。以太幣是透過以接收者地址為目的地的交易來轉移的，代幣的轉移則發生在*特定代幣合約的狀態*之內，目的地是代幣合約，而不是接收者的地址。代幣合約負責追蹤餘額並發出事件。在代幣轉帳中，實際上並沒有任何交易被發送給代幣的接收者，而是把接收者的地址加進代幣合約本身的 mapping 中。發送以太幣到某個地址的交易，會改變該地址的狀態；把代幣轉到某個地址的交易，只會改變代幣合約的狀態，而不會改變接收者地址的狀態。即使是支援 ERC-20 代幣的錢包，除非使用者明確加入某個代幣合約來「關注」，否則錢包也不會知道這筆代幣餘額。有些錢包會關注最熱門的代幣合約，偵測自己所控制的地址持有的餘額，但這只涵蓋現有 ERC-20 合約中的一小部分。

事實上，使用者也不太可能*想要*追蹤所有可能的 ERC-20 代幣合約中的所有餘額。許多 ERC-20 代幣與其說是可用的代幣，不如說更像垃圾郵件。它們會自動為有以太幣活動的帳戶建立餘額，藉此吸引使用者。如果你有一個活動歷史悠久的以太坊地址，特別是在預售期間建立的地址，你會發現裡面滿是憑空冒出來的「垃圾」代幣。當然，這個地址並不是真的塞滿了代幣，而是那些代幣合約裡記錄著你的地址。只有當你用來查看地址的區塊瀏覽器或錢包有在關注這些代幣合約時，你才會看到這些餘額。

代幣的行為和以太幣不同。以太幣是用 `send` 函式發送的，合約中的任何 payable 函式或任何外部擁有的地址都能接收。代幣則是用只存在於 ERC-20 合約中的 `transfer`，或 `approve` 與 `transferFrom` 函式發送的，而且（至少在 ERC-20 中）不會觸發接收合約中的任何 payable 函式。代幣本來是要像以太幣這樣的加密貨幣一樣運作，但它們有一些差異，打破了這個假象。

我們來仔細看看 `approve` 與 `transferFrom` 模式。對新手來說，`approve`-`transferFrom` 這套機制特別容易造成誤解。許多人以為轉移代幣是單一操作，所以遇到兩步驟的流程時，會覺得困惑又違反直覺。更糟的是，`approve` 這個動作看似無害，卻可能是個陷阱。使用者授權某個合約時，可能在不知情的情況下授予了無上限的權限，讓惡意人士日後得以把他們的代幣掏空。這種認知落差讓網路釣魚攻擊更容易得逞，也凸顯出這套機制的設計與新手預期的區塊鏈互動方式並不一致。

再來看另一個問題。要發送以太幣或使用任何以太坊合約，你需要以太幣來支付 gas。要發送代幣，你*也需要以太幣*。你不能用代幣支付交易的 gas，代幣合約也不能替你支付 gas。例如，假設你透過交易所把一些比特幣換成某種代幣。你在一個會追蹤該代幣合約、顯示你餘額的錢包裡「收到」了這個代幣。它看起來和錢包裡其他加密貨幣沒什麼兩樣。但試著發送這個代幣時，錢包就會告訴你需要以太幣才能這麼做。你可能會很困惑——畢竟，收到這個代幣時並不需要以太幣。也許你根本沒有以太幣。也許你甚至不知道這個代幣是以太坊上的 ERC-20 代幣，還以為它是擁有自己區塊鏈的加密貨幣。假象就此破滅。

我們可以利用 ERC-2612 的 `permit` 函式，以及 EIP-4337 與 EIP-7702 等智能錢包所提供的 gas 費用代付（sponsorship）功能，部分解決這個問題。ERC-2612 讓你透過簽署鏈外訊息來設定代幣的授權額度，省去鏈上的授權交易。EIP-4337 與其他智能錢包架構，則讓第三方替你支付 gas 費用，再由你以 ERC-20 代幣償還。挑戰在於，採用 ERC-2612 的代幣有限，而智能錢包也還沒有普及。

這些問題有些是 ERC-20 代幣特有的，有些則是與以太坊內部的抽象層與介面邊界有關的更普遍問題。有些可以透過修改代幣介面來解決，有些則可能需要修改以太坊內部的基本結構（例如 EOA 與合約之間、交易與訊息之間的區別）。有些問題也許無法真正「解決」，而需要靠使用者介面的設計來隱藏這些細微差異，讓使用者體驗不受底層區別的影響、保持一致。

在接下來的幾節中，我們會看看試圖解決其中一些問題的各種提案。

### ERC-223：一個提議中的代幣合約介面標準

ERC-223 提案試圖透過偵測目的地址是不是合約，來解決不小心把代幣轉給（不一定支援代幣的）合約的問題。ERC-223 要求設計用來接收代幣的合約實作一個名為 `tokenFallback` 的函式。如果轉帳的目的地是合約，而該合約不支援代幣（也就是沒有實作 `tokenFallback`），轉帳就會失敗。

為了偵測目的地址是不是合約，ERC-223 的參考實作以相當有創意的方式，使用了一小段行內位元組碼：

```solidity
function isContract(address _addr) private view returns (bool is_contract) {
  uint256 length;
    assembly {
       // retrieve the size of the code on target address; this needs assembly
       length := extcodesize(_addr)
    }
    return (length>0);
}
```

> **備註**
>
> `extcodesize` 回傳儲存在指定地址上的位元組碼大小。過去，這是 EOA 與智能合約的主要差別：EOA 沒有程式碼，合約則有。但這個假設已經不再成立。有了 EIP-7702，EOA 現在也可以附加程式碼，讓這條界線完全模糊了。
> 還有一個重要的邊界情況：在合約的建構子階段，它的程式碼還沒有儲存到鏈上。以太坊虛擬機（EVM）要等建構子執行完畢，才會把合約的位元組碼寫入該地址。所以，如果你在合約的建構子內對它自己的地址（或對另一個尚未完成部署的合約）呼叫 `extcodesize`，即使該地址最終會有程式碼，它也會回傳 `0`。因此，如果一個地址沒有程式碼，它可能是 EOA，也可能是仍在建構中的合約；如果它有程式碼，則可能是已部署的合約，也可能是使用自訂程式碼內容的 EOA。簡而言之，這項檢查已經無法可靠地告訴我們某個地址是不是合約。

ERC-223 的合約介面規格如下：

```solidity
interface ERC223Token {
  uint256 public totalSupply;
  function balanceOf(address who) public view returns (uint256);
  function name() public view returns (string _name);
  function symbol() public view returns (string _symbol);
  function decimals() public view returns (uint8 _decimals);
  function totalSupply() public view returns (uint256 _supply);
  function transfer(address to, uint256 value) public returns (bool success);
  function transfer(address to, uint256 value, bytes data) public returns (bool success);
  function transfer(address to, uint256 value, bytes data, string custom_fallback)
      public returns (bool success);
  event Transfer(address indexed from, address indexed to, uint256 value,
                 bytes indexed data);
}
```

ERC-223 並沒有被廣泛實作，在 [ERC 的討論串](https://oreil.ly/iguyT)中，對於向後相容性，以及應該在合約介面層級還是使用者介面上做出改變的取捨，也有一些爭論。這場爭論仍在持續。

### ERC-777：原本可能實現的未來

ERC-777 引入了 *鉤子*（hook）——在代幣轉帳期間觸發的函式——為代幣互動帶來全新的做法。這些 hook 與 ERC-20 完全相容，確保現有系統可以無縫地與 ERC-777 代幣互動。

發送者的 hook `tokensToSend` 會在代幣離開帳戶之前執行，讓發送者可以加入記錄日誌或條件檢查之類的邏輯。另一方面，接收者的 hook `tokensReceived` 則會在代幣進入帳戶時啟動。ERC-777 hook 架構的核心是 ERC-1820 註冊表（registry），它記錄哪些地址實作了所需的 hook：發送者的 `tokensToSend` 與接收者的 `tokensReceived`。這確保只有在雙方都準備好處理轉帳時，轉帳才會成功，從而避免代幣遺失之類的常見問題。

hook 也簡化了交易。使用 ERC-20 時，把代幣轉給合約往往需要繁瑣的兩步驟流程：先 `approve`，再 `transferFrom`。ERC-777 免除了這個流程，透過 hook 讓交易得以原子性（atomic）地完成。它有效率、直覺，而且坦白說，早就該出現了。

ERC-777 另一個有趣的特色是它的操作者（operator）機制，讓被授權的地址——通常是交易所或支付處理商這類智能合約——可以代替持有者發送與銷毀代幣。持有者可以隨時授予或撤銷 operator 的授權，完全掌控在任何時刻有哪些第三方可以代為管理自己的代幣。每一次授權或撤銷都會發出一個事件，讓授權的變動一目了然。

ERC-777 的合約介面規格如下：

```solidity
interface ERC777Token {
    function name() public view returns (string);
    function symbol() public view returns (string);
    function totalSupply() public view returns (uint256);
    function granularity() public view returns (uint256);
    function balanceOf(address owner) public view returns (uint256);
    function send(address to, uint256 amount, bytes userData) public;
    function authorizeOperator(address operator) public;
    function revokeOperator(address operator) public;
    function isOperatorFor(address operator, address tokenHolder)
        public constant returns (bool);
    function operatorSend(address from, address to, uint256 amount,
                          bytes userData,bytes operatorData) public;
    event Sent(address indexed operator, address indexed from,
               address indexed to, uint256 amount, bytes userData,
               bytes operatorData);
    event Minted(address indexed operator, address indexed to,
                 uint256 amount, bytes operatorData);
    event Burned(address indexed operator, address indexed from,
                 uint256 amount, bytes userData, bytes operatorData);
    event AuthorizedOperator(address indexed operator,
                             address indexed tokenHolder);
    event RevokedOperator(address indexed operator, address indexed tokenHolder);
}
```

#### ERC-777 代幣的問題

雖然 ERC-777 讓代幣互動更直覺，它的 hook 卻帶來一些重大挑戰，其中最明顯的就是重入攻擊的風險。這類攻擊利用合約在完全更新狀態之前就能重新進入自身邏輯的特性，往往造成嚴重的後果。ERC-777 hook 的本質就是在代幣轉帳期間把執行控制權交給發送者與接收者，這為這類漏洞利用創造了理想的情境。這樣的設計意味著開發者必須小心處理這些 hook，才能避免漏洞。

ERC-777 代幣整合所造成的重入事件中，最惡名昭彰的是 2020 年 4 月的 Uniswap v1 事件。去中心化交易所（DEX）協議 Uniswap 因為 ERC-777 的 hook，不慎讓自己的儲備暴露在漏洞利用之下。攻擊者可以在操作進行到一半時回頭呼叫 Uniswap 合約，利用代幣儲備與以太幣儲備之間的落差把資金抽走。雖然這個漏洞是 Uniswap 與 ERC-777 互動的方式所特有的，但它鮮明地提醒了我們這些 hook 帶來的風險。

另一個值得注意的問題是阻斷服務（DoS）攻擊的可能性。假設某個合約要把 ERC-777 代幣分發給多個帳戶。如果其中一個接收者是惡意合約，被設計成在 `tokensReceived` hook 中回復交易，整個分發過程就會被阻擋。

這些風險凸顯了為什麼整合 ERC-777 不像把 ERC-20 換掉那麼簡單。開發者需要採用最佳實踐，例如使用重入鎖來降低漏洞的風險。

#### 原本可能實現的未來

ERC-777 原本可能成為以太坊代幣標準的下一步演進。它解決了 ERC-20 的許多痛點，特別是在使用者體驗與代幣處理方面。避免代幣遺失、實現 atomic 交易、建立更豐富的合約互動，這些都是很有吸引力的進步。

然而，以太坊社群變得猶豫不決。潛在的阻斷服務與重入情境投下了長長的陰影。開發者害怕整合 ERC-777 的複雜度與風險，即使只要有適當的預防措施，這些風險是可以控制的。我們沒有迎接這個挑戰，而是固守熟悉卻有限的 ERC-20。我們錯過了一個機會，沒能擁抱一個讓代幣更貼近以太坊理念、同時提供更優越功能的標準。

說到底，ERC-777 的 hook 並不是罪魁禍首，不當的實作才是。只要多花一點心力、遵守安全的程式設計實踐，ERC-777 就能為更無縫的以太坊生態系鋪路。想深入研究這個議題，建議閱讀 OpenZeppelin 函式庫[關於棄用 ERC-777 的討論](https://oreil.ly/J4p9B)。

## ERC-721：NFT 標準

到目前為止，我們探討的是 ERC-20 這類同質化代幣的標準，其中每個單位都可以互相替換，系統只在乎帳戶餘額。現在，我們來深入一個截然不同、也獨特得多的東西：ERC-721，也就是非同質化代幣的標準，或者用現在大家都熟知的名字：NFT。你可能在 2021 年的狂熱期間聽說過 NFT，當時 CryptoPunks、Bored Ape Yacht Club 與 NBA Top Shot 等數位收藏品登上頭條，並以令人瞠目結舌的價格售出。OpenSea 與 Rarible 等交易平台也在加密貨幣圈中變得家喻戶曉。

但 NFT 究竟有什麼特別之處？與 ERC-20 代幣不同，NFT 的重點就在於獨一無二。每個代幣代表一件獨特物品的所有權，而這件物品可以是任何東西：數位收藏品、遊戲內資產、藝術品，甚至是不動產或汽車這類真實世界資產（real-world asset，RWA）。ERC-721 的美妙之處在於它的彈性。只要代幣是獨一無二、可以用一個數字識別的，它並不在乎代幣代表什麼。在底層，這是透過為每個 NFT 指定一個 `uint256` 識別碼來實現的。你可以把它想成區分不同代幣的序號。在 ERC-20 中，我們透過把帳戶對應到它持有的數量來追蹤餘額；在 ERC-721 中，除了餘額之外，我們還把每個獨一無二的代幣 ID 對應到它的擁有者：

```solidity
mapping (uint256 => address) private _owners;
```

這個結構上的細微轉變改變了一切。每個 NFT 都綁定一個特定的擁有者，它的歷史、來歷與獨特屬性都能直接追蹤。正因如此，ERC-721 非常適合個體性很重要的應用，例如證明對一件獨一無二的藝術品、一把稀有的遊戲寶劍，甚至元宇宙中一塊土地的所有權。

真正讓 ERC-721 強大又多才多藝的，是選用的 ERC-721 詮釋資料（metadata）擴充，它讓每個代幣 ID 都能綁定一個統一資源識別碼（uniform resource identifier，URI）。這個 URI 可以指向描述這個 NFT 的 metadata，例如它的名稱、說明與圖片。URI 可能是指向中心化伺服器的標準 HTTP 連結，也可能是用於去中心化儲存的 IPFS（Inter-Planetary File System）連結。中心化伺服器可能離線或完全消失，讓 NFT 依賴第三方基礎設施。相較之下，IPFS 有助於確保 metadata 保持可存取且防竄改，因此是儲存 NFT metadata 的首選。能夠把每個代幣與一個 metadata URI 關聯起來，正是 NFT 得以承載豐富的描述性資料與多媒體內容的原因，也進一步提升了它們的獨特性與可用性。

NFT 的投機用途，特別是作為數位收藏品，無疑主導了大眾的論述。這些代幣成了炒作的象徵，價值由稀缺性、名人背書與社群情緒推動。然而，在浮誇的頭條之外，還有一整個可能重新定義各行各業的實際應用世界。例如，NFT 可以用在供應鏈管理中追蹤商品的來歷，為消費者確保真實性與透明度。它們可以代表不動產權狀，透過自動化所有權移轉來簡化不動產交易、減少詐欺。NFT 也可以用在教育領域，發行學位與證書這類可驗證、防竄改、而且隨處都能取用的資格證明。

雖然是收藏品讓 NFT 成為眾所矚目的焦點，但它們真正的前景在於這些實際且具變革性的用途。結合獨特性、可追溯性與可程式性，ERC-721 代幣已準備好成為數位經濟的基礎構件。無論你是要鑄造一件古怪的藝術品，還是要把攸關性命的醫療紀錄代幣化，ERC-721 都能讓開發者打造遠遠超越投機的解決方案。

ERC-721 的合約介面規格如下：

```solidity
interface ERC721 /* is ERC165 */ {
    event Transfer(address indexed _from, address indexed _to, uint256 _deedId);
    event Approval(address indexed _owner, address indexed _approved,
                   uint256 _deedId);
    event ApprovalForAll(address indexed _owner, address indexed _operator,
                         bool _approved);
    function balanceOf(address _owner) external view returns (uint256 _balance);
    function ownerOf(uint256 _deedId) external view returns (address _owner);
    function transfer(address _to, uint256 _deedId) external payable;
    function transferFrom(address _from, address _to, uint256 _deedId)
        external payable;
    function approve(address _approved, uint256 _deedId) external payable;
    function setApprovalForAll(address _operator, boolean _approved) payable;
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}
```

## ERC-1155：多代幣標準

ERC-20 與 ERC-721 為同質化與非同質化代幣奠定了基礎，從那時起，以太坊已經走了很長一段路。多代幣標準 ERC-1155 結合了兩者的長處，讓代幣管理既有效率又多元。

想像你是一位遊戲開發者。你想建立一個系統，讓玩家可以收集金幣（同質化）、獨一無二的寶劍（非同質化），以及可以成堆消耗的藥水（半同質化）。使用 ERC-20 或 ERC-721，每一種代幣都需要一個獨立的智能合約。每多一個合約都會增加 gas 成本與複雜度，因為你還得管理這些合約之間的權限與互動。ERC-1155 解決了這個問題，讓我們只需部署一個合約，就能管理多種代幣類型。每種代幣類型都有一個唯一的 ID，合約可以為任何代幣類型組合處理所有操作，包括轉帳、餘額與 metadata 的擷取。這種精簡的做法減少了重複與交易成本，使 ERC-1155 成為廣泛採用的標準。

ERC-1155 的批次操作是一大特色，讓我們可以在單一交易中轉移或查詢多個代幣，既節省 gas，也讓這個標準更具可擴展性。此外，ERC-1155 也包含安全機制，以避免代幣被鎖住之類的問題。把代幣轉給智能合約時，接收合約必須實作 `IERC1155Receiver` 介面，否則交易就會回復。這些 hook 讓代幣轉帳期間可以進行進階的互動。例如，合約可以實作收到代幣時要執行的自訂邏輯，像是更新遊戲內的排行榜或觸發某個事件。然而，正如在 ERC-777 中看到的，如果沒有小心處理這些 hook，它們可能引入重入攻擊之類的漏洞。開發者在實作 ERC-1155 代幣時，必須確保有適當的防護措施，例如使用 檢查—生效—互動模式（checks-effects-interactions pattern）與重入鎖，來保護自己的合約。

ERC-1155 的合約介面規格如下：

```solidity
interface IERC1155 /* is IERC165 */ {
    event TransferSingle(address indexed operator, address indexed from, address indexed to,
uint256 id, uint256 value);
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );
    event ApprovalForAll(address indexed account, address indexed operator, bool approved);
    event URI(string value, uint256 indexed id);
    function balanceOf(address account, uint256 id) external view returns (uint256);
    function balanceOfBatch(
        address[] calldata accounts,
        uint256[] calldata ids
    ) external view returns (uint256[] memory);
    function setApprovalForAll(address operator, bool approved) external;
    function isApprovedForAll(
        address account,
        address operator
    ) external view returns (bool);
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external;
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external;
}
```

## 使用代幣標準

在前一節中，我們檢視了幾個提議中的代幣合約標準，以及幾個已廣泛部署的標準。這些標準究竟有什麼作用？你應該使用這些標準嗎？應該如何使用？應該在這些標準之外加入其他功能嗎？應該使用哪些標準？接下來我們會探討其中一些問題。

### 代幣標準是什麼？目的為何？

代幣標準是實作的*最低*規格。也就是說，要符合例如 ERC-20 的標準，你至少必須實作 ERC-20 標準所規定的函式與行為。你也可以自由地實作不屬於標準的函式，來*增加*功能。

這些標準的主要目的，是促進合約之間的*互通性*。如此一來，所有錢包、交易所、使用者介面與其他基礎設施元件，都能以可預測的方式與任何遵循這份規格的合約*介接*。換句話說，如果你部署了一個遵循 ERC-20 標準的合約，所有現有的錢包使用者都能無縫地開始交易你的代幣，不需要升級錢包，你也不必費任何心力。

這些標準的用意是*描述性*的，而不是*規範性*的。你要如何實作那些函式由你決定；合約的內部運作與標準無關。標準有一些功能上的要求，規範特定情況下的行為，但並不規定實作方式。例如，ERC-20 規定成功的轉帳要更新餘額並發出 Transfer 事件，但並不規定實作這些要求所用的內部資料結構或記帳邏輯。

### 你應該使用這些標準嗎？

面對這麼多標準，每個開發者都會遇到一個兩難：要使用現有的標準，還是突破標準的限制去創新？

這個兩難並不容易解決。標準必然會限制你的創新能力，因為它劃出一條你必須遵循的狹窄「車轍」。另一方面，這些基本標準是從數百個應用的經驗中發展出來的，往往很適合絕大多數的使用情境。

在這項考量之中，還有一個更大的問題：互通性與廣泛採用的價值。如果你選擇使用現有的標準，就能獲得所有為配合該標準而設計的系統所帶來的價值。如果你選擇偏離標準，就必須考慮自行建立所有支援基礎設施的成本，或是說服其他人把你的實作當作新標準來支援。這種自闢蹊徑、無視現有標準的傾向，被稱為「非我發明」症候群，與開源文化背道而馳。另一方面，進步與創新有時又仰賴打破傳統。這是個棘手的抉擇，請仔細考慮！

> **備註**
>
> 根據[維基百科](https://oreil.ly/TTA96)，「非我發明」（not invented here）是社會、企業或機構文化所採取的一種立場：因為外部來源與權利金之類的成本，而避免使用或購買已經存在的產品、研究、標準或知識。

### 偵測標準：EIP-165

如我們所見，ERC-20 這類標準簡化了代幣與錢包之間的互動。但我們要如何辨別一個智能合約支援哪些介面？這正是 EIP-165 派上用場的地方，它為合約提供了一種宣告與偵測介面的標準化方式。

EIP-165 定義了一種讓合約宣告自己所實作之介面的方法。合約使用 `supportsInterface` 函式，針對給定的介面 ID（把介面中所有函式選擇器做 XOR 運算得出的唯一識別碼）回傳 `true` 或 `false`。例如，如果某個介面包含 `foo()` 與 `bar(int256)`，它的 ID 就是這樣推導出來的：

```
foo.selector ^ bar.selector
```

這種做法讓其他合約與工具在互動之前就能驗證相容性。例如，交易市集可以在上架某個 NFT 合約的代幣之前，先確認它支援 ERC-721 介面。

要實作 EIP-165，合約會繼承一個基礎類別，例如 OpenZeppelin 的 ERC-165，並覆寫 `supportsInterface` 方法，把合約支援的介面納入其中：

```solidity
contract MyContract is IMyContract, ERC165 {
    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
        return interfaceId == type(IMyContract).interfaceId ||
super.supportsInterface(interfaceId);
    }
}
```

為了更清楚掌握 EIP-165 實際上如何運作，我們來看看 ERC-1155，一個多才多藝、廣泛使用的多代幣合約標準：

```solidity
abstract contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI,
    IERC1155Errors {
[...]
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165,
IERC165) returns (bool) {
        return
            interfaceId == type(IERC1155).interfaceId ||
            interfaceId == type(IERC1155MetadataURI).interfaceId ||
            super.supportsInterface(interfaceId);
    }
[...]
}
```

> **警告**
>
> EIP-165 仰賴合約誠實地回報自己的能力。惡意或實作不良的合約可能謊稱支援某個介面，進而引發問題。雖然 EIP-165 改善了開發者體驗、減少了摩擦，但不應把它當作安全保證。

在更進階的情境中，例如合約代替其他合約實作介面時，開發者可以研究 ERC-1820，它使用一個全域的 registry 來追蹤介面支援情況。雖然 ERC-1820 比 EIP-165 複雜，但它為去中心化系統提供了更大的彈性。

### 成熟帶來安全

除了選擇標準之外，還有一個平行的抉擇：*實作*的選擇。當你決定使用 ERC-20 這類標準時，接著就必須決定如何實作一個相容的設計。以太坊生態系中有許多廣泛使用的現成「參考」實作，你也可以從頭撰寫自己的實作。同樣地，這個選擇也是一個可能帶來嚴重安全影響的兩難。

現有的實作都「身經百戰」。雖然不可能證明它們是安全的，但其中許多實作支撐著價值數百萬美元的代幣，有些甚至高達數十億美元。它們一再遭受猛烈的攻擊，到目前為止都沒有發現重大的漏洞。自己撰寫實作並不容易，合約可能以許多細微的方式被攻破。使用經過充分測試、廣泛使用的實作要安全得多。在我們的範例中，我們使用 OpenZeppelin 的 ERC-20 標準實作，因為這個實作從一開始就以安全為核心。

如果你使用現有的實作，也可以擴充它。同樣地，對這股衝動要小心。複雜度是安全的敵人。你加入的每一行程式碼，都會擴大合約的攻擊面，都可能是一個潛伏的漏洞。你可能要等到在合約上放了大量價值、有人把它攻破之後，才會發現問題。

> **提示**
>
> 標準與實作的選擇是整體安全智能合約設計的重要部分，但它們並不是唯一的考量（見第 9 章）。

## 代幣介面標準的擴充

到目前為止討論的代幣標準，為建立與管理代幣提供了基本的功能。然而，它們刻意保持精簡，為專案留下擴充與調整的空間，以符合特定需求。隨著時間推移，許多專案以這些標準為基礎，加入了提升易用性、安全性與彈性的功能。以太坊智能合約的主要函式庫 OpenZeppelin，已經成為這類擴充的首選來源。我們來探索 ERC-20、ERC-721 與 ERC-1155 代幣幾個最值得注意的擴充。

以 ERC-20 為例，我們看到了銷毀機制的加入。銷毀讓代幣可以永久退出流通、減少供給量，這對通縮模型，或需要刻意控制供給量的代幣經濟學很有用。反過來說，有些專案會加入上限，為總供給量設下硬性限制，確保鑄造的代幣永遠不會超過預先定義的門檻。

ERC-20 另一個有趣的擴充是投票功能，讓代幣持有者可以直接透過自己的代幣參與治理決策。實作這項功能的專案，建立了去中心化的決策流程，讓利害關係人對協議的發展方向有發言權。

ERC-721 的擴充也展現了類似的創意。版稅支付之類的功能，讓創作者在自己的 NFT 每次被交易時，都能賺取一定比例的銷售額。URI 儲存是另一個常見的擴充，可以動態地儲存與擷取 metadata，對於屬性會隨時間演變的 NFT 特別有用。可列舉（enumerable）擴充則讓開發者可以有效率地列出某個地址持有的所有代幣，讓打造交易市集或錢包更容易。

多代幣標準 ERC-1155 也沒有落後。ERC-1155 的擴充包括可銷毀的代幣與可暫停的合約，在遊戲或代幣化供應鏈等使用情境中提供了更多彈性。有些實作也強化了 metadata 的處理，確保代幣的細節資訊保持可存取、容易更新。

除此之外，還有無數其他擴充，因應群眾募資、封鎖清單（blocklist）、允許清單（allowlist），以及轉帳收費等需求。開發者經常把這些功能與 OpenZeppelin 的 Ownable 或 Access Control 等其他標準函式庫結合，善用更多身經百戰的資源。

彈性越大，責任越大。擴充代幣標準需要在創新與互通性之間取得平衡。撰寫自訂功能看似很吸引人，卻經常引入不必要的複雜度與風險。相反地，善用 OpenZeppelin 這類成熟的函式庫與擴充，可以確保安全性與程式碼品質，並大幅降低開發成本。既然已經有穩健、經過測試的解決方案，就沒有必要重新發明輪子。

## 結語

代幣不只是數位貨幣；它們可以代表治理權、存取憑證、身分與真實世界資產。代幣之所以能如此多元，要歸功於 ERC-20、ERC-721 與 ERC-1155 這些標準，它們確保了錢包、交易所與 DApp 之間無縫的互通性，創造出更有效率、更緊密相連的區塊鏈生態系。在本章中，我們看了不同類型的代幣與代幣標準，你也建立了自己的第一個代幣與相關應用程式。
