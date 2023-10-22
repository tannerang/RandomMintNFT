## README

### 執行說明

```
git clone https://github.com/tannerang/RandomMintNFT.git

cd RandomMintNFT

forge test 
```

### 測試個案說明

```
testRandomMint
    說明：
        測試 RandomMint 方法是否如預期
    流程：
        user1 使用 RandomMint 兩次
        檢查 tokenID 是否隨機且不重複

testReveal
    說明：
        測試解盲前的 tokenURI 及解盲後的 tokenURI 是否不同
    流程：
        user1 RandomMint 一個 Token 並取得對應 unrevealTokenURI
        owner 設定 setReveal(true)
        user1 取得 revealTokenURI 並比較與 unrevealTokenURI 是否不一樣
```
