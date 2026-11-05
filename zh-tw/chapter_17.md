# 第 17 章　零知識證明

在本章中，我們將探索*零知識密碼學*（zero-knowledge cryptography）這個迷人的世界，看看它如何完美地契合以太坊的路線圖，讓以太坊得以真正擴容，滿足大規模採用時對區塊空間的需求。零知識技術是非常複雜的主題，仰賴許多我們無法在這裡詳細解釋的數學規則。本章的目標，是讓你理解為什麼零知識密碼學為以太坊帶來獨特的機會，而且與擴容路線圖非常契合。讀完本章，你會在高層次上了解零知識密碼學如何運作、它有哪些有用的性質，以及以太坊打算如何用它來改進協議。

## 歷史

*零知識證明*（zero-knowledge proof）最早出現在 Shafi Goldwasser、Silvio Micali 與 Charles Rackoff 於 1985 年發表的論文〈[The Knowledge Complexity of Interactive Proof-Systems](https://oreil.ly/a6KH6)〉中。他們把零知識證明描述為一種方法：你可以向另一方證明你知道某件事為真，而除了「你的說法確實為真」這個事實之外，不透露任何其他資訊。
雖然零知識證明在 1980 年代就已被發現，實際的應用卻非常有限。一切在 2011 年改變：[BIT+11](https://oreil.ly/C6HvM) 論文提出了 *SNARK*（*succinct noninteractive arguments of knowledge*）TODO-term: succinct noninteractive argument of knowledge（建議：簡潔非互動式知識論證），作為替任意計算建立零知識證明的理論框架。兩年後的 2013 年，[Pinocchio PGHR13](https://oreil.ly/4uU6x) 論文提出了第一個實用的通用 SNARK 實作，讓 SNARK 得以用在真實世界的應用中。人們第一次能夠證明一個通用程式已經正確執行，而不必重新執行它，也不會透露實際的計算細節。

革命就此展開。從那一刻起，零知識證明領域以驚人的速度演進。2016 年，[Groth16 演算法](https://oreil.ly/rxlOL)縮小了證明大小、縮短了驗證時間，大幅提升了 zk-SNARK 的效率。由於極為簡潔，即使已有更新的系統可用，Groth16 至今仍被廣泛使用。例如，去中心化的 mixer TODO-term: mixer（建議：混幣器）應用 Tornado Cash 就用它在鏈上實作零知識證明。

2017 年，[Bulletproofs](https://oreil.ly/ZUeIe) 帶來突破性的進展，不再需要*可信設定*（後面的小節會深入說明可信設定到底是什麼），代價是證明比較大。接著在 2018 年出現了 [*zk-STARK*](https://oreil.ly/TCnTT)，它不但不需要可信設定，還提供了 postquantum security TODO-term: postquantum security（建議：後量子安全），也就是說，它的密碼學基礎能抵抗量子電腦的攻擊。前者如今用於加密貨幣專案 Monero，以隱藏交易金額；後者則是以太坊第二層（L2）Starknet 的密碼學基礎。

2019 年，[PLONK](https://oreil.ly/3453_) 與 [Sonic](https://oreil.ly/f6_Sq) 引入了通用且可更新的可信設定，做出重大貢獻，讓 SNARK 在通用應用上更有彈性、更實用。這些創新至今仍持續影響著現代的零知識系統。

零知識證明仍在積極發展中，近年的進展改善了證明時間、遞迴效率，以及 zk-EVM 和現代 zk-VM 等實際應用。新的構造與最佳化不斷出現，持續拓展零知識技術的可能邊界。

這一切能夠成真，主要歸功於加密貨幣領域帶來的資金。以太坊基金會本身也透過提供多項補助、設立專門團隊研究這個主題，做出了（而且仍在做出）貢獻。

## 定義與性質

現在，讓我們更具體一點，定義什麼是零知識證明，以及它必須具備哪些性質。我們已經說過，零知識證明是一種協議，讓一方（通常稱為*證明方*，P）向另一方（通常稱為*驗證方*，V）證明某個 statement TODO-term: statement（建議：陳述）為真，而除了這個特定 statement 為真的事實之外，不透露任何資訊。

讓我們把幾個重要的定義形式化：

**Statement**

要證明的主張。statement 是公開的，任何人都可以驗證，而且不包含私密資訊。

**見證**

證明 statement 為真的祕密資訊。只有證明方知道見證。

**證明**

一種密碼學物件，能讓驗證方相信 statement 為真，而不透露見證。

所有零知識證明系統都必須遵守以下三個性質：

**Completeness** TODO-term: completeness（建議：完備性）

如果證明方 P 持有一個為真的 statement，那麼只要遵循協議規則，它就必須能夠算出一個有效的零知識證明。不可能出現證明方正確遵循所有規則、卻無法產生有效證明的情況。

**Soundness** TODO-term: soundness（建議：可靠性）

任何惡意的證明方都必須無法為一個錯誤的 statement 偽造出有效的證明。如果驗證方接受了一個零知識證明，那麼證明方產生它的唯一方式，就是從一個為真的 statement 出發，依序遵循所有協議規則。

**零知識**

顧名思義，驗證方在遵循協議的過程中，除了初始 statement 的有效性之外，不應該得知任何其他資訊。

## 以太坊如何使用零知識證明

你可能會好奇，為什麼這種非常新的密碼學技術，對以太坊未來的發展與路線圖如此重要。答案其實相當直接。

在以太坊的脈絡下，零知識證明系統真正的威力在於：它讓我們能夠驗證一個 statement 的有效性，而不必執行得出這個最終 statement 所需的所有計算。首先，證明方算出某個 statement，並附上一個零知識證明；接著，所有驗證方只要使用零知識協議，就能免信任地把這個 statement 當成真的，而不必做證明方做過的相同計算。

細心的讀者可能已經發現它完美適用於以太坊的哪個地方了：區塊執行與狀態更新，換句話說，就是*以太坊虛擬機（EVM）的狀態轉換函數*。每個新區塊都會處理其中包含的所有交易，藉此更新當前的狀態。圖 17-1 很好地呈現了這一點。

![EVM state transition function](images/ch17/maet_1701.png)

圖 17-1. EVM 狀態轉換函數

你可以把 EVM 想成一個黑盒子：它的輸入是區塊鏈的當前狀態，以及剛收到、裝滿交易的新區塊，輸出則是鏈更新後的新狀態。目前，以太坊完整節點收到新區塊時，會重新執行該區塊中的所有交易，如此一來，它就能免信任地更新狀態，而不必依賴任何受信任的第三方。
這種做法的主要問題在於，區塊執行的負載非常重，因而可能成為瓶頸。你最後必須在兩者之間取得平衡：一邊是完整節點為了正常運作、跟上鏈的最前端所必須滿足的硬體需求，另一邊是你希望網路擁有的去中心化程度。你越想透過提高完整節點的需求來擴容，就越會犧牲去中心化，因為資源較少的參與者在經濟上再也負擔不起運行完整節點。反過來也一樣：你把硬體需求壓得越低、讓任何人都能運行節點，你的區塊鏈所能處理的最大吞吐量就越受限制。在這個取捨中，以太坊一向偏向去中心化的一側，把硬體需求維持得夠低，讓 solo staker TODO-term: solo staker（建議：獨立質押者）與完整節點的運行者得以存在。

這正是零知識證明系統登場的地方。如果有一種方法，能讓完整節點免信任地更新狀態，卻不必執行任何交易，基本上也就是不必進行 EVM 狀態轉換函數的繁重計算，那會怎麼樣？這個想法可以用下面的例子來概括：

1. 某些參與者執行實際的 EVM 計算：執行新區塊中包含的所有交易，產生鏈更新後的狀態。
2. 這些參與者建立一個證明該狀態有效的零知識證明，並把它連同更新後的新狀態一起分享給所有完整節點。
3. 其他完整節點收到鏈的新狀態與零知識證明後，只要驗證證明的有效性；如果證明有效，它們就能免信任地用剛收到的新狀態更新自己的鏈狀態。

如此一來，你仍然需要一些節點（大概由資金雄厚的公司維護）實際執行所有交易，但其他所有節點都可以很便宜，因為它們只需要驗證一個證明。你可以把第一種節點的硬體需求調得非常高，好處理大得多的吞吐量，同時又多虧零知識證明的「魔法」，依然保有高度的去中心化。

到目前為止，我們一直假設產生和驗證零知識證明既快速又簡單。事實上，只有在驗證零知識證明比重新執行一般以太坊區塊中的所有交易更快時，前面的步驟才有意義。而事實證明，如今要達到這樣的性質相當困難。不過這是一個最佳化問題：只是時間早晚，而不是能不能的問題。我們很快就會走到能夠即時為以太坊區塊產生並驗證零知識證明的那一天。如果你對這個主題的發展有興趣，Ethproofs 是一個非常值得關注的酷網站。

## 第二層也能受惠於零知識技術

受惠於零知識證明技術的，並不只有以太坊主網。事實上，你可能已經在第 16 章讀到，有一類 rollup 稱為 *ZK rollup*。顧名思義，它們使用零知識證明系統來證明 EVM 的執行，因此可以發布自己鏈上的狀態更新，並附上一個零知識證明，確保新狀態是正確算出來的。

你可能會好奇，既然我們先前說過，目前還無法對一般的以太坊區塊做到即時證明，ZK rollup 又是怎麼使用零知識技術的？答案是：它們並沒有做到，它們甚至不需要為第二層的每個區塊做即時證明。通常，它們大約每小時發布一次聚合的零知識證明，證明從上一個證明到最新一個證明之間發生的所有狀態更新都已正確執行。

兩個零知識證明之間相隔的時間，只會影響 rollup 本身達到最終性所需的時間。如果每小時發布一次證明，就表示你平均需要等 30 分鐘，才能認為你的交易已經在第一層（L1）上真正最終確定。

## 一個小例子

為了更熟悉零知識證明系統如何運作，讓我們從一個簡單的小例子開始：*分割問題*（partition problem）。這是一個知名的問題，任務是「判斷一個由正整數構成的多重集合 S，能否分割成兩個子集合 S1 與 S2，使得 S1 中各數的總和等於 S2 中各數的總和」。

> **備註**  
>
> 分割問題是一個 decision problem TODO-term: decision problem（建議：判定問題），而以太坊依靠零知識證明來驗證的是 computation trace TODO-term: computation trace（建議：計算軌跡）。雖然以太坊使用零知識證明的主要情境是 execution trace TODO-term: execution trace（建議：執行軌跡）的驗證，但動手解一遍分割問題，仍然是培養零知識證明系統直覺的絕佳方式。


如果 S = [1, 1, 5, 7]，我們可以把它分割成 S1 = [1, 1, 5] 與 S2 = [7] 來滿足這個問題。但這個問題並不一定有正確的解；事實上，如果 S = [1, 1, 5, 8]，就不可能把它分割成兩個總和相同的子集合。

分割問題是 NP 完全問題，意思是不存在能在多項式時間內解決它的演算法，也就是說，沒有演算法能在很短的時間內，在有解時找出解，或在無解時證明解不存在。

### 來證明它吧

分割問題的結構完美契合我們到目前為止看過的零知識證明系統性質。事實上，既然找出解很困難，那麼把找解的運算工作交給一個配備超級電腦的富有證明方，再用零知識技術證明它找到了有效的解，會是很有意思的做法：其他人不必進行同樣繁重的計算，而解本身也不會被揭露。

為了讓分割問題適用於零知識證明系統，我們需要稍微調整一下。假設我們有一個由正整數構成的串列 `s`。如果另一個串列 `a` 滿足下列條件，我們就稱它為一個 *satisfying assignment* TODO-term: satisfying assignment（建議：滿足賦值）：

1. `len(s) == len(a)`
2. `a` 的所有元素都是 1 或 –1
3. `s` 與 `a` 的 dot product TODO-term: dot product（建議：內積）為 0

請注意，這個構造與分割問題完全對應。如果我們拿先前的初始串列 S = [1, 1, 5, 7]，那麼 satisfying assignment `a` 就等於：

```
a = [1, 1, 1, –1]
```

你可以自己動手檢查這三個條件都成立：

1. `len(s) = 4 == len(a) = 4`
2. `a` 的所有元素都是 1 或 –1
3. dot product：1 × 1 + 1 × 1 + 1 × 5 + (–1) × 7 = 1 + 1 + 5 – 7 = 0

兩個等長串列的 *dot product*，是把第一個串列的每個元素與第二個串列中對應的元素相乘，再把所有結果加總。更技術性地說，如果我們有等長 `n` 的串列 `s = [s0, s1, s2, sn]` 與 `a = [a0, a1, a2, an]`，dot product 的計算方式如下：[^tn1]

[^tn1]: 譯註：本章的索引從零開始（例如只有四個元素的 w，最後一個元素是 w[3]），所以長度為 n 的串列，最後一個元素應該是 s(n−1) 與 a(n−1)，下面公式中求和的上限也應該是 n − 1；若要讓上限為 n，串列長度應為 n + 1。此外，原文寫的 [s0, s1, s2, sn] 省略了 s2 與 sn 之間的元素（a 也一樣）。

<math xmlns="http://www.w3.org/1998/Math/MathML">
  <mi mathcolor="#000000">s</mi>
  <mo mathcolor="#000000">⋅</mo>
  <mi mathcolor="#000000">a</mi>
  <mo mathcolor="#000000">=</mo>
  <mrow>
    <munderover>
      <mo stretchy="false">∑</mo>
      <mrow>
        <mi mathcolor="#000000">i</mi>
        <mo mathcolor="#000000">=</mo>
        <mn mathcolor="#000000">0</mn>
      </mrow>
      <mrow>
        <mi mathcolor="#000000">n</mi>
      </mrow>
    </munderover>
    <mrow>
      <mfenced separators="">
        <mrow>
          <msub>
            <mrow>
              <mi mathcolor="#000000">s</mi>
            </mrow>
            <mrow>
              <mi mathcolor="#000000">i</mi>
            </mrow>
          </msub>
          <mo mathcolor="#000000">×</mo>
          <msub>
            <mrow>
              <mi mathcolor="#000000">a</mi>
            </mrow>
            <mrow>
              <mi mathcolor="#000000">i</mi>
            </mrow>
          </msub>
        </mrow>
      </mfenced>
    </mrow>
  </mrow>
  <mo mathcolor="#000000">=</mo>
  <msub>
    <mrow>
      <mi mathcolor="#000000">a</mi>
    </mrow>
    <mrow>
      <mn mathcolor="#000000">0</mn>
    </mrow>
  </msub>
  <msub>
    <mrow>
      <mi mathcolor="#000000">s</mi>
    </mrow>
    <mrow>
      <mn mathcolor="#000000">0</mn>
    </mrow>
  </msub>
  <mo mathcolor="#000000">+</mo>
  <msub>
    <mrow>
      <mi mathcolor="#000000">a</mi>
    </mrow>
    <mrow>
      <mn mathcolor="#000000">1</mn>
    </mrow>
  </msub>
  <msub>
    <mrow>
      <mi mathcolor="#000000">s</mi>
    </mrow>
    <mrow>
      <mn mathcolor="#000000">1</mn>
    </mrow>
  </msub>
  <mo mathcolor="#000000">+</mo>
  <msub>
    <mrow>
      <mi mathcolor="#000000">a</mi>
    </mrow>
    <mrow>
      <mn mathcolor="#000000">2</mn>
    </mrow>
  </msub>
  <msub>
    <mrow>
      <mi mathcolor="#000000">s</mi>
    </mrow>
    <mrow>
      <mn mathcolor="#000000">2</mn>
    </mrow>
  </msub>
  <mo mathcolor="#000000">+</mo>
  <mo mathcolor="#000000">.</mo>
  <mo mathcolor="#000000">.</mo>
  <mo mathcolor="#000000">.</mo>
  <mo mathcolor="#000000">+</mo>
  <msub>
    <mrow>
      <mi mathcolor="#000000">a</mi>
    </mrow>
    <mrow>
      <mi mathcolor="#000000">n</mi>
    </mrow>
  </msub>
  <msub>
    <mrow>
      <mi mathcolor="#000000">s</mi>
    </mrow>
    <mrow>
      <mi mathcolor="#000000">n</mi>
    </mrow>
  </msub>
</math>

當然，我們可以直接把 `a` 交給驗證方，對方很容易就能檢查它是不是有效的解，但這會違反不揭露解的零知識假設。

我們先來產生另一個串列 `w`，方法是建立 *partial-sum list* TODO-term: partial-sum list（建議：部分和串列），也就是說，`w[i]` 等於 `s` 與 `a` 到 `i` 為止的部分 dot product。在零知識證明系統的脈絡下，`w` 也稱為*見證*。依照我們的例子，可以算出 `w`：

```
w = [1, 2, 7, 0]
```

請注意，如果 `a` 是有效的 satisfying assignment，那麼 `w` 一定以 0 結尾。

為了讓證明系統運作得更好，讓我們對目前為止建立的證明 `p` 做一點小修改。具體來說，我們要把串列 `w` 的最後一項移到第一個位置，因此先前的 `w` 現在變成：[^tn2]

[^tn2]: 譯註：本章前文並沒有定義 p；從上下文看，這裡修改的對象是見證 w。

```
w = [0, 1, 2, 7]
```

太棒了！這個串列 `w` 有一個非常酷的性質：

```
|s[i]| = |w[i + 1] – w[i]|
```

你可以自己檢查這個式子是否成立：

```
|s[0]| = |w[0 + 1] – w[0]| = |w[1] – w[0]| = |1 – 0| = |1| = 1
|s[1]| = |w[1 + 1] – w[1]| = |w[2] – w[1]| = |2 – 1| = |1| = 1
|s[2]| = |w[2 + 1] – w[2]| = |w[3] – w[2]| = |7 – 2| = |5| = 5
|s[3]| = |w[3 + 1] – w[3]| = |w[4] – w[3]| = |w[0] – w[3]| = |0 – 7| = |–7| = 7
```

請注意，要計算 `s[3]`，我們需要存取 `w[4]`，但它並不存在，因為 `w` 只有四個元素（而且索引從零開始）。不過有個非常簡單的解法：只要回到 `w` 的第一個元素就行了，就好像 `w` 是循環的一樣。

驗證方可以要求取得 `w` 中兩個相鄰的元素，並檢查前面的關係是否成立。記住，驗證方可以取得 `s`，因為它是公開的，代表這個問題的輸入；但驗證方無法取得代表解的 satisfying assignment `a`。如果等式成立，就表示證明方知道這個問題的一個 satisfying assignment `a`。

### 問題所在

到目前為止，我們建立的是一個非常天真的證明系統。事實上，它有三個大問題：

1. 先前我們說過，一旦驗證方要求取得 `w` 中兩個相鄰的元素，而且等式成立，就驗證了證明方知道這個問題的解。這並不正確。只查詢一次，驗證方無法完全確定；必須多次查詢 `w` 的相鄰元素，才能以非常高的機率確信這一點。
2. 雖然驗證方確實能夠驗證證明方擁有這個問題的解，但這個證明系統仰賴證明方的誠信。如果證明方心懷惡意、說謊呢？當驗證方要求取得 `w` 中兩個相鄰的元素時，證明方可以提供兩個隨機數字，而它們仍然滿足等式。
3. 此外，這個證明系統並不是零知識的。事實上，藉由要求取得 `w` 的相鄰元素，驗證方可以得知許多關於 satisfying assignment `a` 的資訊。驗證方知道 `w` 是如何建構的，所以對 `w` 知道得越多，對解 `a` 也就知道得越多。

現在讓我們解決這些問題，試著建立一個更好的證明系統。

### 零知識

讓我們為這個系統加上零知識性。到目前為止，我們建立的協議的主要問題在於，我們把 `w` 的真實值傳給驗證方，讓驗證方能夠了解許多關於 `a` 的資訊。為了實際看看這一點，讓我們在證明方與驗證方之間進行兩個簡單的互動步驟。

驗證方要求取得 `w[1]` 與 `w[2]`，並檢查 `|w[2] – w[1]| = |s[1]|` 是否成立，於是證明方提供 `w[1] = 1` 與 `w[2] = 2`，驗證方就能確認等式成立：

<math xmlns="http://www.w3.org/1998/Math/MathML">
  <mfenced open="|" close="" separators="|">
    <mrow>
      <mi mathcolor="#000000">s</mi>
      <mo stretchy="false" mathcolor="#000000">[</mo>
      <mn mathcolor="#000000">1</mn>
      <mo stretchy="false" mathcolor="#000000">]</mo>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">=</mo>
    </mrow>
    <mrow>
      <mi mathcolor="#000000">w</mi>
      <mo stretchy="false" mathcolor="#000000">[</mo>
      <mn mathcolor="#000000">2</mn>
      <mo stretchy="false" mathcolor="#000000">]</mo>
      <mo mathcolor="#000000">−</mo>
      <mi mathcolor="#000000">w</mi>
      <mo stretchy="false" mathcolor="#000000">[</mo>
      <mn mathcolor="#000000">1</mn>
      <mo stretchy="false" mathcolor="#000000">]</mo>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">=</mo>
    </mrow>
    <mrow>
      <mn mathcolor="#000000">2</mn>
      <mo mathcolor="#000000">−</mo>
      <mn mathcolor="#000000">1</mn>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">=</mo>
    </mrow>
    <mrow>
      <mn mathcolor="#000000">1</mn>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">=</mo>
      <mn mathcolor="#000000">1</mn>
    </mrow>
  </mfenced>
</math>

接著，驗證方再發出一次查詢：`w[2]` 與 `w[3]`。證明方提供 `w[2] = 2` 與 `w[3] = 7`，驗證方檢查等式：

<math xmlns="http://www.w3.org/1998/Math/MathML">
  <mfenced open="|" close="" separators="|">
    <mrow>
      <mi mathcolor="#000000">s</mi>
      <mo stretchy="false" mathcolor="#000000">[</mo>
      <mn mathcolor="#000000">2</mn>
      <mo stretchy="false" mathcolor="#000000">]</mo>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">=</mo>
    </mrow>
    <mrow>
      <mi mathcolor="#000000">w</mi>
      <mo stretchy="false" mathcolor="#000000">[</mo>
      <mn mathcolor="#000000">3</mn>
      <mo stretchy="false" mathcolor="#000000">]</mo>
      <mo mathcolor="#000000">−</mo>
      <mi mathcolor="#000000">w</mi>
      <mo stretchy="false" mathcolor="#000000">[</mo>
      <mn mathcolor="#000000">2</mn>
      <mo stretchy="false" mathcolor="#000000">]</mo>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">=</mo>
    </mrow>
    <mrow>
      <mn mathcolor="#000000">7</mn>
      <mo mathcolor="#000000">−</mo>
      <mn mathcolor="#000000">2</mn>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">=</mo>
    </mrow>
    <mrow>
      <mn mathcolor="#000000">5</mn>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">=</mo>
      <mn mathcolor="#000000">5</mn>
    </mrow>
  </mfenced>
</math>

經過這兩次互動，驗證方得知了 w 的三個元素：

<math xmlns="http://www.w3.org/1998/Math/MathML">
  <mtable>
    <mtr>
      <mtd/>
      <mtd>
        <mi mathcolor="#000000">w</mi>
        <mo stretchy="false" mathcolor="#000000">[</mo>
        <mn mathcolor="#000000">1</mn>
        <mo stretchy="false" mathcolor="#000000">]</mo>
        <mo mathcolor="#000000">=</mo>
        <mn mathcolor="#000000">1</mn>
      </mtd>
    </mtr>
    <mtr>
      <mtd/>
      <mtd>
        <mi mathcolor="#000000">w</mi>
        <mo stretchy="false" mathcolor="#000000">[</mo>
        <mn mathcolor="#000000">2</mn>
        <mo stretchy="false" mathcolor="#000000">]</mo>
        <mo mathcolor="#000000">=</mo>
        <mn mathcolor="#000000">2</mn>
      </mtd>
    </mtr>
    <mtr>
      <mtd/>
      <mtd>
        <mi mathcolor="#000000">w</mi>
        <mo stretchy="false" mathcolor="#000000">[</mo>
        <mn mathcolor="#000000">3</mn>
        <mo stretchy="false" mathcolor="#000000">]</mo>
        <mo mathcolor="#000000">=</mo>
        <mn mathcolor="#000000">7</mn>
      </mtd>
    </mtr>
  </mtable>
</math>

由於驗證方已經知道 `s = [1, 1, 5, 7]`，也知道 `w` 是如何算出來的，就能推導出解 `a` 的開頭部分等於 `[1, 1, 1]`，因為這是得到 `w[3] = 7`、`w[2] = 2` 與 `w[1] = 1` 的唯一方式。

我們需要找到一種方法，遮蔽 `w` 的真實值，但仍然讓新的 `w` 與輸入串列 `s` 之間的關係成立。為此，我們需要以一種非常特定的方式加入一些隨機性。

首先，我們不直接使用 `a`，而是先擲一枚硬幣：如果是正面，就保持原樣；否則就把所有元素的正負號反轉，所有的 1 變成 –1，反之亦然。請注意，這個改變不會破壞 satisfying assignment `a` 對這個問題的三個主要性質。

接著，我們取一個新的隨機整數值 `r`。我們用和先前相同的方式計算 `w`，但在它的每個元素上都加上 `r`。這個改變同樣不會破壞 `s` 與 `w` 之間的關鍵關係。

驗證方每次發出新的查詢，我們都要擲一次硬幣，並算出一個不同的隨機值 `r`。這樣一來，驗證方雖然仍能驗證等式成立，卻無法了解關於 `a` 的任何資訊，因為在驗證方看來，所有的 `w` 值都像是隨機的。

讓我們做個小示範。記住，證明方（在這個例子中就是我們）一開始同時擁有 `s` 與 `a`：

<math xmlns="http://www.w3.org/1998/Math/MathML">
  <mtable>
    <mtr>
      <mtd/>
      <mtd>
        <mi mathcolor="#000000">s</mi>
        <mo mathcolor="#000000">=</mo>
        <mo stretchy="false" mathcolor="#000000">[</mo>
        <mn mathcolor="#000000">1</mn>
        <mo mathcolor="#000000">,</mo>
        <mn mathcolor="#000000">1</mn>
        <mo mathcolor="#000000">,</mo>
        <mn mathcolor="#000000">5</mn>
        <mo mathcolor="#000000">,</mo>
        <mn mathcolor="#000000">7</mn>
        <mo stretchy="false" mathcolor="#000000">]</mo>
      </mtd>
    </mtr>
    <mtr>
      <mtd/>
      <mtd>
        <mi mathcolor="#000000">a</mi>
        <mo mathcolor="#000000">=</mo>
        <mo stretchy="false" mathcolor="#000000">[</mo>
        <mn mathcolor="#000000">1</mn>
        <mo mathcolor="#000000">,</mo>
        <mn mathcolor="#000000">1</mn>
        <mo mathcolor="#000000">,</mo>
        <mn mathcolor="#000000">1</mn>
        <mo mathcolor="#000000">,</mo>
        <mo mathcolor="#000000">−</mo>
        <mn mathcolor="#000000">1</mn>
        <mo stretchy="false" mathcolor="#000000">]</mo>
      </mtd>
    </mtr>
  </mtable>
</math>

現在，驗證方要求取得 `w[1]` 與 `w[2]`，以檢查 `|w[2] – w[1]| = |s[1]|` 是否成立。

首先，我們需要擲硬幣，決定是否要改變 `a` 的所有值。結果是反面，所以我們要反轉所有正負號，`a` 變成：

<math xmlns="http://www.w3.org/1998/Math/MathML">
  <mi mathcolor="#000000">a</mi>
  <mo mathcolor="#000000">′</mo>
  <mo mathcolor="#000000">=</mo>
  <mo stretchy="false" mathcolor="#000000">[</mo>
  <mo mathcolor="#000000">−</mo>
  <mn mathcolor="#000000">1</mn>
  <mo mathcolor="#000000">,</mo>
  <mo mathcolor="#000000">−</mo>
  <mn mathcolor="#000000">1</mn>
  <mo mathcolor="#000000">,</mo>
  <mo mathcolor="#000000">−</mo>
  <mn mathcolor="#000000">1</mn>
  <mo mathcolor="#000000">,</mo>
  <mn mathcolor="#000000">1</mn>
  <mo stretchy="false" mathcolor="#000000">]</mo>
</math>

接著，我們算出一個隨機值 `r = 4`。我們計算 `w`，並在每個元素上加上 `r`：

<math xmlns="http://www.w3.org/1998/Math/MathML">
  <mtable>
    <mtr>
      <mtd/>
      <mtd>
        <mi mathcolor="#000000">w</mi>
        <mo mathcolor="#000000">=</mo>
        <mo stretchy="false" mathcolor="#000000">[</mo>
        <mn mathcolor="#000000">0</mn>
        <mo mathcolor="#000000">,</mo>
        <mo mathcolor="#000000">−</mo>
        <mn mathcolor="#000000">1</mn>
        <mo mathcolor="#000000">,</mo>
        <mo mathcolor="#000000">−</mo>
        <mn mathcolor="#000000">2</mn>
        <mo mathcolor="#000000">,</mo>
        <mo mathcolor="#000000">−</mo>
        <mn mathcolor="#000000">7</mn>
        <mo stretchy="false" mathcolor="#000000">]</mo>
      </mtd>
    </mtr>
    <mtr>
      <mtd/>
      <mtd>
        <mi mathcolor="#000000">w</mi>
        <mo mathcolor="#000000">′</mo>
        <mo mathcolor="#000000">=</mo>
        <mo stretchy="false" mathcolor="#000000">[</mo>
        <mn mathcolor="#000000">4</mn>
        <mo mathcolor="#000000">,</mo>
        <mn mathcolor="#000000">3</mn>
        <mo mathcolor="#000000">,</mo>
        <mn mathcolor="#000000">2</mn>
        <mo mathcolor="#000000">,</mo>
        <mo mathcolor="#000000">−</mo>
        <mn mathcolor="#000000">3</mn>
        <mo stretchy="false" mathcolor="#000000">]</mo>
      </mtd>
    </mtr>
  </mtable>
</math>

我們提供 <math xmlns="http://www.w3.org/1998/Math/MathML">
  <msup>
    <mrow>
      <mi mathcolor="#000000">w</mi>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">′</mo>
    </mrow>
  </msup>
  <mo stretchy="false" mathcolor="#000000">[</mo>
  <mn mathcolor="#000000">1</mn>
  <mo stretchy="false" mathcolor="#000000">]</mo>
  <mo mathcolor="#000000">=</mo>
  <mn mathcolor="#000000">3</mn>
</math> 與 <math xmlns="http://www.w3.org/1998/Math/MathML">
  <msup>
    <mrow>
      <mi mathcolor="#000000">w</mi>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">′</mo>
    </mrow>
  </msup>
  <mo stretchy="false" mathcolor="#000000">[</mo>
  <mn mathcolor="#000000">2</mn>
  <mo stretchy="false" mathcolor="#000000">]</mo>
  <mo mathcolor="#000000">=</mo>
  <mn mathcolor="#000000">2</mn>
</math>。

驗證方仍然能確認等式成立：

<math xmlns="http://www.w3.org/1998/Math/MathML">
  <mfenced open="|" close="|" separators="|">
    <mrow>
      <mi mathcolor="#000000">s</mi>
      <mo stretchy="false" mathcolor="#000000">[</mo>
      <mn mathcolor="#000000">1</mn>
      <mo stretchy="false" mathcolor="#000000">]</mo>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">=</mo>
    </mrow>
  </mfenced>
  <msup>
    <mrow>
      <mi mathcolor="#000000">w</mi>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">′</mo>
    </mrow>
  </msup>
  <mo stretchy="false" mathcolor="#000000">[</mo>
  <mn mathcolor="#000000">2</mn>
  <mo stretchy="false" mathcolor="#000000">]</mo>
  <mo mathcolor="#000000">−</mo>
  <msup>
    <mrow>
      <mi mathcolor="#000000">w</mi>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">′</mo>
    </mrow>
  </msup>
  <mfenced open="" close="" separators="|">
    <mrow>
      <mo stretchy="false" mathcolor="#000000">[</mo>
      <mn mathcolor="#000000">1</mn>
      <mo stretchy="false" mathcolor="#000000">]</mo>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">=</mo>
    </mrow>
    <mrow>
      <mn mathcolor="#000000">2</mn>
      <mo mathcolor="#000000">−</mo>
      <mn mathcolor="#000000">3</mn>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">=</mo>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">−</mo>
      <mn mathcolor="#000000">1</mn>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">=</mo>
      <mn mathcolor="#000000">1</mn>
    </mrow>
  </mfenced>
</math>

現在，驗證方發出另一次查詢，要求取得 `w[2]` 與 `w[3]`。同樣地，我們需要擲硬幣，決定是否要改變 `a` 的所有值。這次是正面，所以我們不改變正負號：

接著，我們算出一個隨機值 `r = 1`。我們計算 `w`，並在每個元素上加上 `r`：[^tn3]

[^tn3]: 譯註：下面的公式顯示的是正負號維持不變的 a，應該接在上一段（擲出正面、不改變正負號）之後。依本段的說明，w = [0, 1, 2, 7] 的每個元素加上 r = 1 之後，得到的是 w″ = [1, 2, 3, 8]；下一段提供的 w″[2] = 3 與 w″[3] = 8 就是由此而來。

<math xmlns="http://www.w3.org/1998/Math/MathML">
  <mi mathcolor="#000000">a</mi>
  <mo mathcolor="#000000">=</mo>
  <mo stretchy="false" mathcolor="#000000">[</mo>
  <mn mathcolor="#000000">1</mn>
  <mo mathcolor="#000000">,</mo>
  <mn mathcolor="#000000">1</mn>
  <mo mathcolor="#000000">,</mo>
  <mn mathcolor="#000000">1</mn>
  <mo mathcolor="#000000">,</mo>
  <mo mathcolor="#000000">−</mo>
  <mn mathcolor="#000000">1</mn>
  <mo stretchy="false" mathcolor="#000000">]</mo>
</math>

我們提供 <math xmlns="http://www.w3.org/1998/Math/MathML">
  <msup>
    <mrow>
      <mi mathcolor="#000000">w</mi>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">″</mo>
    </mrow>
  </msup>
  <mo stretchy="false" mathcolor="#000000">[</mo>
  <mn mathcolor="#000000">2</mn>
  <mo stretchy="false" mathcolor="#000000">]</mo>
  <mo mathcolor="#000000">=</mo>
  <mn mathcolor="#000000">3</mn>
</math> 與 <math xmlns="http://www.w3.org/1998/Math/MathML">
  <msup>
    <mrow>
      <mi mathcolor="#000000">w</mi>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">″</mo>
    </mrow>
  </msup>
  <mo stretchy="false" mathcolor="#000000">[</mo>
  <mn mathcolor="#000000">3</mn>
  <mo stretchy="false" mathcolor="#000000">]</mo>
  <mo mathcolor="#000000">=</mo>
  <mn mathcolor="#000000">8</mn>
</math>。
驗證方仍然能確認等式成立：

<math xmlns="http://www.w3.org/1998/Math/MathML">
  <mfenced open="|" close="|" separators="|">
    <mrow>
      <mi mathcolor="#000000">s</mi>
      <mo stretchy="false" mathcolor="#000000">[</mo>
      <mn mathcolor="#000000">2</mn>
      <mo stretchy="false" mathcolor="#000000">]</mo>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">=</mo>
    </mrow>
  </mfenced>
  <msup>
    <mrow>
      <mi mathcolor="#000000">w</mi>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">″</mo>
    </mrow>
  </msup>
  <mo stretchy="false" mathcolor="#000000">[</mo>
  <mn mathcolor="#000000">3</mn>
  <mo stretchy="false" mathcolor="#000000">]</mo>
  <mo mathcolor="#000000">−</mo>
  <msup>
    <mrow>
      <mi mathcolor="#000000">w</mi>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">″</mo>
    </mrow>
  </msup>
  <mfenced open="" close="" separators="|">
    <mrow>
      <mo stretchy="false" mathcolor="#000000">[</mo>
      <mn mathcolor="#000000">2</mn>
      <mo stretchy="false" mathcolor="#000000">]</mo>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">=</mo>
    </mrow>
    <mrow>
      <mn mathcolor="#000000">8</mn>
      <mo mathcolor="#000000">−</mo>
      <mn mathcolor="#000000">3</mn>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">=</mo>
    </mrow>
    <mrow>
      <mn mathcolor="#000000">5</mn>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">=</mo>
      <mn mathcolor="#000000">5</mn>
    </mrow>
  </mfenced>
</math>

但現在，驗證方已經無法從中了解多少關於 satisfying assignment a 的資訊。事實上，驗證方現在擁有的資訊如下：

<math xmlns="http://www.w3.org/1998/Math/MathML">
  <mtable>
    <mtr>
      <mtd/>
      <mtd>
        <msup>
          <mrow>
            <mi mathcolor="#000000">w</mi>
          </mrow>
          <mrow>
            <mo mathcolor="#000000">′</mo>
          </mrow>
        </msup>
        <mo stretchy="false" mathcolor="#000000">[</mo>
        <mn mathcolor="#000000">1</mn>
        <mo stretchy="false" mathcolor="#000000">]</mo>
        <mo mathcolor="#000000">=</mo>
        <mn mathcolor="#000000">3</mn>
      </mtd>
    </mtr>
    <mtr>
      <mtd/>
      <mtd>
        <msup>
          <mrow>
            <mi mathcolor="#000000">w</mi>
          </mrow>
          <mrow>
            <mo mathcolor="#000000">′</mo>
          </mrow>
        </msup>
        <mo stretchy="false" mathcolor="#000000">[</mo>
        <mn mathcolor="#000000">2</mn>
        <mo stretchy="false" mathcolor="#000000">]</mo>
        <mo mathcolor="#000000">=</mo>
        <mn mathcolor="#000000">2</mn>
      </mtd>
    </mtr>
    <mtr>
      <mtd/>
      <mtd>
        <msup>
          <mrow>
            <mi mathcolor="#000000">w</mi>
          </mrow>
          <mrow>
            <mo mathcolor="#000000">″</mo>
          </mrow>
        </msup>
        <mo stretchy="false" mathcolor="#000000">[</mo>
        <mn mathcolor="#000000">2</mn>
        <mo stretchy="false" mathcolor="#000000">]</mo>
        <mo mathcolor="#000000">=</mo>
        <mn mathcolor="#000000">3</mn>
      </mtd>
    </mtr>
    <mtr>
      <mtd/>
      <mtd>
        <msup>
          <mrow>
            <mi mathcolor="#000000">w</mi>
          </mrow>
          <mrow>
            <mo mathcolor="#000000">″</mo>
          </mrow>
        </msup>
        <mo stretchy="false" mathcolor="#000000">[</mo>
        <mn mathcolor="#000000">3</mn>
        <mo stretchy="false" mathcolor="#000000">]</mo>
        <mo mathcolor="#000000">=</mo>
        <mn mathcolor="#000000">8</mn>
      </mtd>
    </mtr>
  </mtable>
</math>

在不同的查詢中，`w` 的值在驗證方看來都像是隨機的，驗證方無法重建出 `a`。

好極了！我們成功為證明系統加上了零知識性。現在來處理心懷惡意的證明方。

### 證明方的承諾

我們需要解決的問題是，證明方可以對驗證方說謊，提供完全捏造的數字，而不是計算出來的見證 `w` 的真實值。這非常糟糕，因為證明方將能夠為一個錯誤的 statement 提供有效的證明；也就是說，即使證明方實際上並沒有 satisfying assignment `a`，也可能騙過驗證方，讓對方相信它有。

我們需要找到一種方法，確保證明方一說謊就會被抓到。基本上，我們需要證明方在把所有 `w` 值提供給驗證方之前，先對它們做出*承諾*。

這時默克爾樹又派上用場了。我們在第 14 章介紹過默克爾樹，所以這裡不會詳細說明它的運作方式。

讓我們用一個新的例子，實際看看新的構造。我們（證明方）擁有：

<math xmlns="http://www.w3.org/1998/Math/MathML">
  <mtable>
    <mtr>
      <mtd>
        <mi mathcolor="#000000">s</mi>
      </mtd>
      <mtd>
        <mo mathcolor="#000000">=</mo>
        <mo stretchy="false" mathcolor="#000000">[</mo>
        <mn mathcolor="#000000">1</mn>
        <mo mathcolor="#000000">,</mo>
        <mn mathcolor="#000000">1</mn>
        <mo mathcolor="#000000">,</mo>
        <mn mathcolor="#000000">5</mn>
        <mo mathcolor="#000000">,</mo>
        <mn mathcolor="#000000">7</mn>
        <mo stretchy="false" mathcolor="#000000">]</mo>
      </mtd>
    </mtr>
    <mtr>
      <mtd>
        <mi mathcolor="#000000">a</mi>
      </mtd>
      <mtd>
        <mo mathcolor="#000000">=</mo>
        <mo stretchy="false" mathcolor="#000000">[</mo>
        <mn mathcolor="#000000">1</mn>
        <mo mathcolor="#000000">,</mo>
        <mn mathcolor="#000000">1</mn>
        <mo mathcolor="#000000">,</mo>
        <mn mathcolor="#000000">1</mn>
        <mo mathcolor="#000000">,</mo>
        <mo mathcolor="#000000">−</mo>
        <mn mathcolor="#000000">1</mn>
        <mo stretchy="false" mathcolor="#000000">]</mo>
      </mtd>
    </mtr>
  </mtable>
</math>

我們擲硬幣，結果是正面，所以不需要改變 `a` 的所有正負號。接著，我們把 `w` 算成 `a` 與 `s` 的 dot product（並把第一個與最後一個元素對調）：[^tn4]

[^tn4]: 譯註：依本章前面的定義，w 是 s 與 a 的部分和串列（逐項累加到各個位置的部分 dot product），而不是單一的 dot product；而且從 [1, 2, 7, 0] 變成 [0, 1, 2, 7]，是把最後一個元素移到第一個位置，而不是把第一個與最後一個元素對調（對調會得到 [0, 2, 7, 1]）。

<math xmlns="http://www.w3.org/1998/Math/MathML">
  <mi mathcolor="#000000">w</mi>
  <mo mathcolor="#000000">=</mo>
  <mo stretchy="false" mathcolor="#000000">[</mo>
  <mn mathcolor="#000000">0</mn>
  <mo mathcolor="#000000">,</mo>
  <mn mathcolor="#000000">1</mn>
  <mo mathcolor="#000000">,</mo>
  <mn mathcolor="#000000">2</mn>
  <mo mathcolor="#000000">,</mo>
  <mn mathcolor="#000000">7</mn>
  <mo stretchy="false" mathcolor="#000000">]</mo>
</math>

我們算出一個隨機值 `r = 8`，並把它加到 `w` 的每個元素上：

<math xmlns="http://www.w3.org/1998/Math/MathML">
  <mi mathcolor="#000000">w</mi>
  <mo mathcolor="#000000">′</mo>
  <mo mathcolor="#000000">=</mo>
  <mo stretchy="false" mathcolor="#000000">[</mo>
  <mn mathcolor="#000000">8</mn>
  <mo mathcolor="#000000">,</mo>
  <mn mathcolor="#000000">9</mn>
  <mo mathcolor="#000000">,</mo>
  <mn mathcolor="#000000">10</mn>
  <mo mathcolor="#000000">,</mo>
  <mn mathcolor="#000000">15</mn>
  <mo stretchy="false" mathcolor="#000000">]</mo>
</math>

現在，我們需要對所有 `w′` 值做出承諾，並把承諾傳給驗證方，確保萬一我們提供偽造的 `w′` 值作弊，就能輕易被發現。圖 17-2 顯示了以所有 `w′` 值作為葉節點所建立的默克爾樹。

![Merkle tree commitment](images/ch17/maet_1702.png)

圖 17-2. 以 `w′` 值建立的默克爾樹

默克爾根就是傳給驗證方的最終承諾。

這時，驗證方發出第一次查詢：<math xmlns="http://www.w3.org/1998/Math/MathML">
  <msup>
    <mrow>
      <mi mathcolor="#000000">w</mi>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">′</mo>
    </mrow>
  </msup>
  <mo stretchy="false" mathcolor="#000000">[</mo>
  <mn mathcolor="#000000">1</mn>
  <mo stretchy="false" mathcolor="#000000">]</mo>
</math> 與 <math xmlns="http://www.w3.org/1998/Math/MathML">
  <msup>
    <mrow>
      <mi mathcolor="#000000">w</mi>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">′</mo>
    </mrow>
  </msup>
  <mo stretchy="false" mathcolor="#000000">[</mo>
  <mn mathcolor="#000000">2</mn>
  <mo stretchy="false" mathcolor="#000000">]</mo>
</math>。我們可以把 <math xmlns="http://www.w3.org/1998/Math/MathML">
  <msup>
    <mrow>
      <mi mathcolor="#000000">w</mi>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">′</mo>
    </mrow>
  </msup>
  <mo stretchy="false" mathcolor="#000000">[</mo>
  <mn mathcolor="#000000">1</mn>
  <mo stretchy="false" mathcolor="#000000">]</mo>
  <mo mathcolor="#000000">=</mo>
  <mn mathcolor="#000000">9</mn>
</math> 與 <math xmlns="http://www.w3.org/1998/Math/MathML">
  <msup>
    <mrow>
      <mi mathcolor="#000000">w</mi>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">′</mo>
    </mrow>
  </msup>
  <mo stretchy="false" mathcolor="#000000">[</mo>
  <mn mathcolor="#000000">2</mn>
  <mo stretchy="false" mathcolor="#000000">]</mo>
  <mo mathcolor="#000000">=</mo>
  <mn mathcolor="#000000">10</mn>
</math> 提供給驗證方，對方就能檢查：

<math xmlns="http://www.w3.org/1998/Math/MathML">
  <mfenced open="|" close="|" separators="|">
    <mrow>
      <mi mathcolor="#000000">s</mi>
      <mo stretchy="false" mathcolor="#000000">[</mo>
      <mn mathcolor="#000000">1</mn>
      <mo stretchy="false" mathcolor="#000000">]</mo>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">=</mo>
    </mrow>
  </mfenced>
  <msup>
    <mrow>
      <mi mathcolor="#000000">w</mi>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">′</mo>
    </mrow>
  </msup>
  <mo stretchy="false" mathcolor="#000000">[</mo>
  <mn mathcolor="#000000">2</mn>
  <mo stretchy="false" mathcolor="#000000">]</mo>
  <mo mathcolor="#000000">−</mo>
  <msup>
    <mrow>
      <mi mathcolor="#000000">w</mi>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">′</mo>
    </mrow>
  </msup>
  <mfenced open="" close="" separators="|">
    <mrow>
      <mo stretchy="false" mathcolor="#000000">[</mo>
      <mn mathcolor="#000000">1</mn>
      <mo stretchy="false" mathcolor="#000000">]</mo>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">=</mo>
    </mrow>
    <mrow>
      <mn mathcolor="#000000">10</mn>
      <mo mathcolor="#000000">−</mo>
      <mn mathcolor="#000000">9</mn>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">=</mo>
    </mrow>
    <mrow>
      <mn mathcolor="#000000">1</mn>
    </mrow>
    <mrow>
      <mo mathcolor="#000000">=</mo>
      <mn mathcolor="#000000">1</mn>
    </mrow>
  </mfenced>
</math>

現在，驗證方需要確認我們沒有作弊，所以也會向證明方索取 *verification path* TODO-term: verification path（建議：驗證路徑），其中包含驗證方自行重建默克爾樹所需的所有資料，以便檢查默克爾根與我們傳送的承諾是否相同。如果相同，驗證方就能確定我們沒有作弊；否則，驗證方馬上就知道我們作弊了。

具體來說，這次查詢的 verification path 包含：

- 雜湊 8
- 雜湊 15

這樣一來，驗證方就能一路重建默克爾樹直到根，並驗證承諾。所以，我們把雜湊 8 與雜湊 15 傳給驗證方，驗證方檢查承諾的有效性，這次查詢終於結束了。

不過，你可能已經發現了一個新問題。事實上，由於 verification path 的要求，我們最後多傳了一些關於 `w′` 的資料：雜湊 8 與雜湊 15。雖然要反推雜湊函數（也就是從雜湊值得出實際的值 8 和 15）在計算上應該是不可行的，但心懷惡意的驗證方可能會嘗試暴力破解攻擊，而且有可能成功找出默克爾樹中我們原本不打算揭露的部分。幸好有一個簡單又漂亮的調整可以解決這個問題。

### 為承諾加入隨機性

這個想法與我們先前為證明系統加上零知識性質的做法類似。這次，我們需要在承諾中加入隨機性，好讓 verification path 不會透露任何關於 `w`（或 `w′`）的資訊。

建立默克爾樹時，我們不再只用 `w′` 每個元素確切值的雜湊作為樹的葉節點，而是再加上一個不會提供給驗證方的隨機字串。圖 17-3 顯示了用這種新方法建立的默克爾樹。

![Merkle tree with randomness](images/ch17/maet_1703.png)

圖 17-3. 為了零知識性質而加入隨機性的默克爾樹

在這個例子中，我們用字串「eth」來遮蔽見證 `w′` 的每個元素。請注意，如果沒有這個祕密字串，就不可能解出實際的值。現在，當我們在 verification path 中把雜湊* 8 與雜湊* 15 傳給驗證方時，驗證方完全無從得知雜湊背後具體的 `w′` 值。即使嘗試暴力破解攻擊，驗證方也不知道我們用來進一步隱藏 `w′` 各元素的祕密字串。

### 結論？或許還不是……

我們做到了！我們成功為最初的分割問題打造了一個（非常天真又基本的）零知識證明系統！

你可能還是會想：「這是個很棒的證明系統，但證明方與驗證方之間仍然需要大量互動。雙方必須同時在線，才能確保協議成功。有沒有辦法解決這一點，把這個互動式零知識證明系統轉變成非互動式零知識證明系統呢？」

你說得一點也沒錯。我們的系統確實需要證明方與驗證方互動才能正確運作，這對大多數使用情境來說真的很惱人。我們又走運了（這裡的運氣也太好了吧？）。有一篇科學論文可以幫上忙。

## Fiat-Shamir 啟發法

1986 年，兩位知名的密碼學家 Amos Fiat 與 Adi Shamir 發表了論文〈[How to Prove Yourself: Practical Solutions to Identification and Signature Problems](https://oreil.ly/TGfa-)〉，在其中發明了一種至今仍被廣泛使用、並以他們命名的轉換協議：*Fiat-Shamir 啟發法*（Fiat-Shamir heuristic），也稱為 Fiat-Shamir 轉換。

> **備註**  
>
> Adi Shamir 是密碼學界真正的傳奇人物：他就是 RSA 演算法裡的 S，而 RSA 是最早、也最廣泛使用的公開金鑰密碼系統之一。Amos Fiat 是他在以色列魏茨曼科學研究所（Weizmann Institute of Science）的同事。


Fiat-Shamir 啟發法是一種協議，能把互動式零知識證明系統轉換成非互動式的系統，做法是用密碼學雜湊函數取代驗證方的隨機挑戰。

仔細想想在我們目前建立的系統中驗證方必須做的事，你會發現，它基本上就是給證明方一些隨機數字（也就是查詢），讓證明方用來產生對應的證明。

記得嗎？我們先前常說「現在驗證方要求取得 `w[1]` 與 `w[2]`」。這可以轉譯成：驗證方給證明方數字 1 和 2，讓證明方為 `w[1]` 與 `w[2]` 建立證明。

我們可以把原本的互動式協議歸納如下（略過證明方建立見證 `w` 並把它調整成 `w′` 的部分）：

1. 證明方產生對 `w′` 的承諾，並把它傳給驗證方。
2. 驗證方傳送一個隨機挑戰，也就是一次查詢。
3. 證明方傳送對挑戰的回應，也就是一個證明。
4. 驗證方驗證證明的有效性。
驗證方提出的每一次不同查詢，都要重複這個過程。而這一切之所以行得通，是因為證明方事先不知道驗證方會提出哪些查詢——對證明方來說，查詢是隨機的。所以，如果我們能找到一種方法，讓證明方自己以隨機但可預測的方式產生所有查詢，就能把整個過程轉變成非互動式協議。

在 1986 年的論文中，Fiat 與 Shamir 提議用雜湊函數充當「random oracle」TODO-term: random oracle（建議：隨機預言機），模擬驗證方的隨機挑戰。讓我們用只有兩輪的協議做個簡單的例子。

第一輪：

1. 證明方產生一個承諾。
2. 證明方取出承諾與問題的公開輸入，把它們串接起來再做雜湊。得到的結果就是第一個挑戰：

    ```
    challenge = hash(commitment || public inputs)
    ```

3. 證明方算出對挑戰的回應，也就是一個證明。

第二輪：

1. 證明方產生一個新的承諾。
2. 證明方取出新的承諾，以及協議中到目前為止算出的所有東西（舊的承諾、證明與公開輸入），把它們串接起來再做雜湊。得到的結果就是新的挑戰：

    ```
    new challenge = hash(commitment || proof || new_commitment || public inputs)
    ```

3. 證明方算出對新挑戰的回應，也就是一個新的證明。

這時，證明方就能把協議的完整 transcript TODO-term: transcript（建議：協議紀錄）傳給驗證方。驗證方需要：

1. 使用雜湊函數與所有有效的輸入，確認所有挑戰都經過正確計算。這是為了確保證明方沒有試圖用捏造的挑戰作弊。
2. 用先前在互動式協議中的同樣方式，驗證所有證明的有效性。這是為了確保證明方確實知道初始問題的一個解。

圖 17-4 顯示了驗證方在驗證零知識證明的有效性之前，先確認挑戰經過正確計算的過程。

![Verifier verification process](images/ch17/maet_1704.png)

圖 17-4. Fiat-Shamir 啟發法讓協議變成非互動式

就是這樣！多虧了 Fiat-Shamir 啟發法，我們現在有了一個非互動式零知識證明系統。它還免費附帶一個很酷的特性：證明方現在能產生任何人都可以驗證的有效證明。因此，只要有一個誠實的一方驗證證明，就能察覺證明方是否試圖作弊。

### 結論？

在這一節中，我們為分割問題建立了第一個非互動式零知識證明系統。現代的零知識架構要複雜得多，本書絕對不會解釋所有細節（不過你可以在本章最後找到一些非常好的論文作為延伸閱讀）。儘管如此，我們到目前為止討論的內容，是所有新的零知識技術的基礎。只要理解了這些，你就可以掉進零知識的兔子洞，開始探索背後所有的細枝末節。

在下一節中，我們將看看兩個最廣泛用來建立零知識證明系統的實際框架：SNARK 與 STARK。

## SNARK 與 STARK 的比較

先前我們為最初的分割問題建立了一個零知識證明系統。這是個好的開始。那麼，如果我們想為一個完全不同的計算建立零知識證明系統呢？能不能重複使用先前為分割問題建立的同一套架構？

事實證明不行：承諾 `w` 與它的性質（例如 `|s[i]| = |w[i+1] – w[i]|`）太過針對分割問題，無法套用到其他問題上。不過這並不是什麼大缺點：我們可以運用建立這個零知識證明系統時學到的東西，發展出更通用的方法。
SNARK 就是在這時登場的。如同我們在「歷史」一節中討論過的，SNARK 在 2011 年由 BIT+11 論文提出，作為替任意計算建立零知識證明的通用框架。僅僅兩年後，Pinocchio 論文就做出了第一個可用於真實世界應用的實作。

SNARK 系統仰賴一個稱為*可信設定*的密碼學祕密，才能以非互動的方式運作。你可以把它看成一個與密碼學協議所有參與者共享的共同知識庫：一種初始化階段，你需要在這個階段產生一些祕密，並用它們算出另外一些值，也就是 proving key 與 verification key TODO-term: proving key / verification key（建議：證明金鑰／驗證金鑰），這些值是正確執行 SNARK 協議所必需的。

可信設定通常是透過 *multiparty computation* TODO-term: multiparty computation（建議：多方計算）取得的：許多參與者各自產生不同的祕密（也稱為 *toxic waste* TODO-term: toxic waste（建議：有毒廢料）），算出 proving key 與 verification key，然後刪除各自最初的祕密。接著，把這些金鑰加總，得到 SNARK 協議中會用到的兩把最終金鑰。這麼做的主要好處是，只要有一個善意的參與者刪除了它的 toxic waste，就能確保沒有任何人能夠作弊，而且可信設定是以防竄改的方式產生的。我們在第 4 章討論 KZG 承諾時談過這一點。

雖然 SNARK 協議運作得非常好，但可信設定的 1-of-N 信任假設，加上要打造一場非常有韌性的初始 ceremony TODO-term: ceremony（建議：儀式）來產生最終公鑰並不容易，一直引發許多討論，也促使不少研究人員與公司研究完全不需要可信設定、免信任的零知識證明系統。此外，SNARK 系統仰賴的橢圓曲線密碼學（elliptic curve cryptography）無法抵抗量子電腦的攻擊，這是人們指出的另一個關鍵問題。

2018 年，Eli Ben-Sasson、Iddo Bentov、Yinon Horesh 與 Michael Riabzev 合寫的論文〈[Scalable, Transparent, and Post-Quantum Secure Computational Integrity](https://oreil.ly/TCnTT)〉提出了一個新的免信任框架，用來建立通用的零知識證明系統：zk-STARK。
STARK 代表「*scalable transparent argument of knowledge*」TODO-term: scalable transparent argument of knowledge（建議：可擴展的透明知識論證）。其中，*transparent* TODO-term: transparent（建議：透明）指的是不需要可信設定這項突破性的性質。它也仰賴 collision-resistant TODO-term: collision-resistant（建議：抗碰撞）的雜湊函數，而不是橢圓曲線密碼學，因此甚至能抵抗量子電腦的攻擊。

這些優點說明了為什麼現在大多數人認為 STARK 是最現代的零知識證明系統。然而，SNARK 並不是過時的技術。它們在某些情境下確實有優勢，主要是證明大小，這在區塊鏈這類頻寬受限的環境中可能至關重要。此外，已經有好幾種混合方法被開發出來，試圖兼取兩者之長。

## zk-EVM 與 zk-VM

既然我們已經深入探討了零知識證明系統在技術上如何運作，終於可以回到以太坊，看看這項技術近年來如何演進。

我們已經說明過如何用零知識證明系統改進以太坊：證明一個區塊的 EVM 執行，讓完整節點不必重新執行該區塊中的所有交易，就能免信任地更新狀態。它們只要驗證一個零知識證明，如果證明有效，就知道新狀態是正確算出來的。我們也看了一個基本的例子，說明如何為一個非常特定的計算（分割問題）建立零知識證明系統，接著介紹了 SNARK 與 STARK 框架，它們讓我們能把這套架構通用化，套用到任意計算上。
所以我們馬上會想問：能不能用 SNARK 或 STARK 零知識證明系統，正確地證明 EVM 的區塊執行？當然可以，但我們必須做出幾個選擇。

在分割問題的例子中，我們必須把最初的命題（也就是能否把一組整數分成兩個子集合，使兩個子集合中各數的總和相等）稍微轉換成更容易用我們後來建立的系統來證明的形式，也就是加入 satisfying assignment `a`，以及它必須滿足才算有效的三個約束。這個轉換是必要的，這樣才能用數學的方式處理問題。SNARK 與 STARK 框架也是如此。

事實上，雖然確實可以用 SNARK 或 STARK 框架對任意計算做零知識證明，但你必須先把計算轉換成框架能夠正確消化、處理的形式，通常稱為*電路*（circuit）。事實證明，這是一項非常困難的任務。特別是，把 EVM 狀態轉換函數這種複雜的計算轉換成零知識電路，非常容易出錯，而且一旦有任何錯誤或問題，也很難除錯。如果電路不正確或有 bug，你就不能信任之後產生的零知識證明，因為它反映的並不是實際完成的計算，所以甚至有可能為一個偽造的 statement 產生有效的零知識證明，例如聲稱新的 EVM 狀態是「state1」，而正確的狀態應該是「state2」。

同時包含零知識證明產生系統的 EVM 實作，稱為 *zk-EVM*。你可以在 ZKsync 的儲存庫中找到一個具體的 zk-EVM。

起初，每個想打造 ZK rollup 的專案，都必須面對為 EVM 狀態轉換函數建立正確零知識電路的艱鉅工作。這就是為什麼在本書撰寫時（2025 年 6 月），樂觀 rollup 的數量遠多於 ZK rollup。但多虧了 zk-VM 的出現，情況正在快速改變。
*zk-VM* 大幅改變了打造 ZK rollup 的觀點，更廣泛地說，也改變了為 EVM 狀態轉換函數建立零知識證明系統的觀點。這個想法相當直接：與其為每一種不同的計算建立客製化的電路，再套用 SNARK 或 STARK 框架，何不建立一個能用於各種計算的通用電路？這就像是一台通用的零知識電腦，能處理任意計算。這一層抽象非常強大：「一個電路統御全部」。

這樣一來，你只需要專注在想證明的計算上，產生證明的所有艱鉅工作都交給 zk-VM 處理。目前最知名的 zk-VM 是 [SP1](https://oreil.ly/kgVYY) 與 [RISC Zero](https://oreil.ly/z6v2l)。

圖 17-5 以精簡的視覺化方式，呈現了 zk-EVM 與 zk-VM 框架的核心要素。

![zk-EVM and zk-VM comparison](images/ch17/maet_1705.png)

圖 17-5. zk-EVM 與 zk-VM 框架的比較

## 結論

在這最後一章中，我們探討了零知識技術的基礎：從它在 1985 年被發明，到 Bit+11 與 Pinocchio 論文的突破性創新真正把它帶進真實世界的應用，特別是在區塊鏈的世界裡。我們以小小的分割問題為例，培養對這些複雜系統底層運作方式的直覺，之後又檢視了更通用的方法，例如 SNARK 與 STARK 框架，它們讓我們能套用標準的方法論，為任意計算建立零知識證明系統。最後，我們介紹了一項非常新的發展：zk-VM。它們擁有單一電路就能處理任意計算的顯著優勢，讓開發者不必再花時間為想證明的特定計算打造客製化電路，因此正迅速為這個領域帶來革命。

以太坊的未來無疑會與零知識技術交會，不論是在第二層，還是直接在第一層。最終會勝出的具體方案仍是未知數；也許會是多種方法的結合，以確保對 bug 或故障有更強的韌性。只有時間能給出答案……

關於這個主題的延伸閱讀，請參考：

- [一個簡單的例子](https://oreil.ly/jVNdu)
- Ethan Buchman 的〈[You Could Have Invented SNARKs](https://oreil.ly/jiaOa)〉
- Maksym Petkus 的〈[Why and How zk-SNARK Works: Definitive Explanation](https://oreil.ly/EUUzt)〉
- [The RareSkills Book of Zero Knowledge](https://oreil.ly/tpHrl)
