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
              <el-image src="/src/assets/img/dapp_nonft_img.png"></el-image>
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
import {onMounted, reactive, ref} from "vue";
import AddNFT from '/src/components/AddNft.vue';
import EditDao from '/src/components/EditDao.vue';
import NFTItem from '/src/components/nft-item/nft-item2.vue';
import DaoItem from '/src/components/dao-item/index.vue';
import EmptyDao from '/src/components/empty-dao/index.vue';
import NFTDetail from '/src/components/NftDetail.vue';
import useContractTool from "@/utils/useContractTool";


const addNftDlg = ref(null);
const editDaoDlg = ref(null);
const DaoList = reactive([]);
const nftDetailDlg = ref(null);

const {Bridge_userDetail, Bridge_listDAOMedals, Bridge_getString} = useContractTool();

const DaoDetail = (address) => {
  Bridge_listDAOMedals(address).then(async (obj) => {
    obj.contract_address = address;
    let avatar = await Bridge_getString(address, 'avatar');
    obj.avatar = avatar ? avatar : '/src/assets/img/dapp_dao_tx_2x.png';
    obj.approved = 0;
    obj.rejected = 0;
    obj.pending = 0;
    // console.log(obj);
    obj.medals.forEach((medal) => {
      obj.pending += medal.request;
      obj.approved += medal.approved;
      obj.rejected += medal.rejected;
    })
    DaoList.push(obj);
  })
}

onMounted(() => {
  Bridge_userDetail().then((res) => {
    // console.log("userDetail", res);
    const addr_arr = res.owned;   //拥有的dao 地址数组
    addr_arr.forEach((v) => {
      DaoDetail(v)
    })
  })
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
