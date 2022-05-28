<template>
  <template v-if="DaoList.length>0">
    <template v-for="(item,index) in DaoList" :key="index">
      <DaoItem :daoInfo="item" @edit="onHandleEdit" @add="onHandleAdd"/>
      <div class="flex flex-wrap" style="padding: 0 10rem;background-color: #FFF;margin-bottom: 0.42rem">
        <template v-if="item.medals.length>0">
          <template v-for="(item2,index) in item.medals" :key="index">
            <NFTItem :info="item2" class="nft-item" @nftDetail="nftDetail(item.contract_address,item2)"/>
          </template>
        </template>
        <template v-else>
          <div class="flex flex-1 box justify-center" style="margin-top: 1rem;margin-bottom: 3rem;">
            <div class="flex flex-column align-center">
              <el-image src="https://muyu-pub.oss-cn-beijing.aliyuncs.com/dao2dao/dapp_nonft_img.png"></el-image>
              <div class="des">No NFT</div>
            </div>
          </div>
        </template>
      </div>
    </template>
  </template>
  <template v-else>
    <EmptyDao/>
  </template>
  <AddNFT ref="addNftDlg"/>
  <EditDao ref="editDaoDlg"/>
  <NFTDetail ref="nftDetailDlg"/>
</template>

<script setup>
import {onMounted, reactive, ref, watch} from "vue";
import AddNFT from '/src/components/AddNft.vue';
import EditDao from '/src/components/EditDao.vue';
import NFTItem from '/src/components/nft-item/nft-item2.vue';
import DaoItem from '/src/components/dao-item/index.vue';
import EmptyDao from '/src/components/empty-dao/index.vue';
import NFTDetail from '/src/components/NftDetail.vue';
import useWeb3 from "/src/utils/useWeb3";
import abi_bridge from '/src/assets/abi/soulBoundBridge.json';


const addNftDlg = ref(null);
const editDaoDlg = ref(null);
const {ContractCall, bridge, account, web3} = useWeb3();
const DaoList = reactive([]);
const nftDetailDlg = ref(null);


const DaoDetail = (address) => {
  ContractCall(abi_bridge, bridge, 'listDAOMedals', [address, 0, 999]).then(async (res) => {
    let obj = JSON.parse(res);
    // NFT name 解码
    obj.medals.forEach((medal) => {
      medal.name = atob(medal.name);
      medal.uri = atob(medal.uri);
    })
    obj.contract_address = address;
    let avatar = await ContractCall(abi_bridge, bridge, 'getString', [address, web3.eth.abi.encodeFunctionSignature('avatar')]);
    obj.avatar = avatar ? avatar : 'https://muyu-pub.oss-cn-beijing.aliyuncs.com/dao2dao/dapp_dao_tx%402x.png';
    obj.name = atob(obj.name);
    DaoList.push(obj);
  })
}

onMounted(() => {
  if (account.value !== '') {
    ContractCall(abi_bridge, bridge, 'userDetail', [account.value]).then((res) => {
      const addr_arr = JSON.parse(res).owned
      addr_arr.forEach((v) => {
        DaoDetail(v)
      })
    })
  }
})
watch(account, (newV, oV) => {
  if (account.value !== '') {
    ContractCall(abi_bridge, bridge, 'userDetail', [account.value]).then((res) => {
      const addr_arr = JSON.parse(res).owned
      addr_arr.forEach((v) => {
        DaoDetail(v)
      })
    })
  }
})
// 编辑dao信息
const onHandleEdit = (contract_address) => {
  editDaoDlg.value.showdialog(contract_address);
}
// 添加NFT
const onHandleAdd = (contract_address) => {
  // console.log(contract_address)
  addNftDlg.value.showdialog(contract_address);
}
// nft详细信息
const nftDetail = (contract_address, nft) => {
  nftDetailDlg.value.showdrawer(contract_address, nft);
}
</script>

<style lang="scss" scoped>


.nft-item {
  margin: 0 1.67rem 1.67rem 0;
}
</style>
