<template>
  <div class="top">
    <div class="search">
      <el-input :input-style="searchInputStyle" v-model="searchContent"
                placeholder="Please enter address search" maxlength="50"></el-input>
      <el-button color="#6E3FF5" class="search-btn" @click="onHandleSearch" :disabled="btnDisable" :loading="loading">
        Search
      </el-button>
    </div>
    <div style="margin-top: 0.04rem;"></div>
  </div>
  <Dao :list="DaoList"/>
</template>

<script setup>
import {onMounted, reactive, ref, watch} from "vue";
import Dao from "./componets/Dao/index.vue";
import User from "./componets/User/index.vue";
import useContractTool from '@/utils/useContractTool';
import {useStore} from "/src/store";
import _ from 'lodash';

const store = useStore();
const {Bridge_getStrings, Bridge_listDAO} = useContractTool();
const DaoList = reactive([]);
// const {ContractCall, bridge} = useWeb3();
const searchInputStyle = {
  display: 'inline',
  width: '35.33rem',
  height: '1.67rem',
}
const searchContent = ref('');
const loading = ref(false);
const btnDisable = ref(true);


watch(searchContent, (newV, oV) => {
  // btnDisable.value = !store.web3.utils.isAddress(newV);
})
const DaoDetail = async (address) => {
  let values = await Bridge_getStrings(address, ['avatar', 'email', 'comgithub'])
  values[0] = values[0] !== '' ? values[0] : '/img/dapp_dao_tx%402x.png';
  return values;
}

onMounted(async () => {
  let ret = await Bridge_listDAO();
  // console.log(ret);
  for (let index in ret.medals) {
    let v = ret.medals[index];
    // remove item if it is empty
    if (v.medals.length === 0) {
      continue;
    }

    for (let a in v.medals) {
      let medal = v.medals[a];
      medal.name = atob(medal.name);
      medal.uri = atob(medal.uri);
      medal.applying = false;
      medal.canApply = true;
      medal.contract_address = ret.address[index];
      // 判断该NFT申请状态  持有 申请中 被拒绝
      await ContractCall(abi_bridge, bridge, 'getCliamRequest', [ret.address[index], 0, 9999]).then((res) => {
        let requestList = JSON.parse(res);
        requestList.forEach((v, index) => {
          if (v.address === store.account && v.medalindex === medal.index) {
            // 存在我的申请记录
            switch (v.status) {
              case 1:
                // 申请中
                medal.applying = true;
                medal.canApply = false;
                break;
              case 2:
                // 被拒绝
                medal.canApply = false;
                medal.canApply = false;
                break;
              default:
                // 其他值  已申请成功  >2 tokenid
                medal.applying = false;
                medal.canApply = false;
                break;
            }
          }
        })
        // console.log(medal);
      })
    }
    // console.log(v.medals);
    DaoList.push(_.cloneDeep({detail: {name: atob(v.name)}, medals: v.medals}))
  }
  ;
  ret.address.forEach(async (address, index) => {
    let detail = await DaoDetail(address)
    DaoList[index].detail.avatar = detail[0];
    DaoList[index].detail.email = detail[1];
    DaoList[index].detail.comgithub = detail[2];
  });
  // desc by nft holder
  DaoList.sort((a, b) => {
    //sum a.medals.request+a.medals.approved
    let a_sum = 0;
    let b_sum = 0;
    a.medals.forEach((v) => {
      a_sum += v.request + v.approved;
    });
    b.medals.forEach((v) => {
      b_sum += v.request + v.approved;
    });
    return b_sum - a_sum;
  })
})


const onHandleSearch = () => {
  loading.value = true;

}
</script>

<style lang="scss" scoped>

.top {
  display: flex;
  height: 3.33rem;
  background: #FFFFFF;
  padding: 0.83rem 10rem 0.83rem 10rem;

  .search {
    .search-btn {
      margin-left: 0.83rem;
      width: 4.17rem;
      height: 1.67rem;
      border-radius: 0.33rem;
    }
  }
}

</style>
