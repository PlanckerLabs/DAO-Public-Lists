# *Anyone can create a DAO here and join a DAO here*
### SoulBound DAPP DEMO

---

## [`前端/frontend`]
- link:[frontend/](frontend/)

#### [演示/DEMO]
- [UI演示/UI layout demo](https://static-bd1f1f21-0a04-4091-96a3-ac8c61aa60d3.bspapp.com)

---

## [`后端/backend`]
- link: [contracts/](contracts/)
- contract/合约源码: [contracts/build/](contracts/build/)

   1. [soulBoundBridge.sol](contracts/build/soulBoundBridge.sol)
   2. [soulBoundMedal.sol](contracts/build/soulBoundMedal.sol)

#### [开发/DEV]

- Requirements
```shell
Node >= v14 #nvm use v14.19.3
remixd
```

```shell
1. npm install
2. make all
3. remixd -s ./ --remix-ide https://remix.ethereum.org
```

#### [文档/DOC]
[Decentralized Application interface](contracts/DAI.md)

*Note:The current contract is fully composable,any contract can use the current contract as a database or a query tool*