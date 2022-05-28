<template>
  <div class="header">
    <div class="item" :class="activeName==='first'? 'active':''" @click="handleClick('first')">All</div>
    <div class="item" :class="activeName==='second'? 'active':''" @click="handleClick('second')">Currently Applying
    </div>
  </div>
  <div style="margin-top: 0.04rem;"></div>
  <template v-if="activeName==='first'">
    <template v-if="allList.length>0">
      <template v-for="(item,index) in allList" :key="index">
        <NFTCollection :collection="item"/>
      </template>
    </template>
    <template v-else>
      <EmptyNFT/>
    </template>
  </template>
  <template v-if="activeName==='second'">
    <template v-if="applyingList.length>0">
      <template v-for="(item,index) in applyingList" :key="index">
        <NFTCollection :collection="item"/>
      </template>
    </template>
    <template v-else>
      <EmptyNFT/>
    </template>
  </template>
</template>

<script setup>
import {onMounted, reactive, ref, toRefs} from 'vue';
import NFTCollection from './nft/index.vue';
import abi_bridge from '/src/assets/abi/soulBoundBridge.json';
import {ElLoading} from "element-plus";
import EmptyNFT from '/src/components/empty-nft/index.vue';
import {useStore} from "/src/store";


import useContractTool from '@/utils/useContractTool';

const {Bridge_userDetail, Bridge_listDAOMedals, Bridge_getStrings} = useContractTool();

const activeName = ref('first')
const allList = reactive([]); //全部列表
const applyingList = reactive([]); //申请中列表
const store = useStore();

const handleClick = (flag) => {
  activeName.value = flag;
}
// const read = async (method, params) => {
//   const loading = ElLoading.service({
//     lock: true,
//     text: 'Loading',
//     background: 'rgba(0, 0, 0, 0.7)',
//   })
//   return await ContractCall(abi_bridge, bridge, method, params).then((res) => {
//     loading.close();
//     return res;
//   }).catch(() => {
//     loading.close();
//   })
// }

onMounted(async () => {
//  read('userDetail', [store.account]).then(async (res) => {
  Bridge_userDetail(store.Account).then(async (values) => {
    let daos = values.dao
    for (let index in daos) {
      let daoInfo = {};
      let listDAOMedals = await Bridge_listDAOMedals(daos[index].address);
      let info = await Bridge_getStrings(daos[index].address, ['avatar', 'email', 'url']);
      daoInfo.name = listDAOMedals.name;
      daoInfo.avatar = info.avatar;
      daoInfo.email = info.email;
      daoInfo.url = info.url;
      // 全部列表
      let medals = [];
      daos[index].medals.forEach((v) => {
        let obj = JSON.parse(JSON.stringify(v))
        obj.name = atob(obj.name);
        obj.uri = atob(obj.uri);
        // console.log(obj);
        medals.push(obj);
      })
      allList.push({daoInfo, medals: ref(medals)})
      // 申请中列表
      medals = [];
      daos[index].medals.forEach((v) => {
        let obj = JSON.parse(JSON.stringify(v))
        obj.name = atob(obj.name);
        obj.uri = atob(obj.uri);
        if (obj.status === 1) {
          medals.push(obj);
        }
      })
      if (medals.length > 0) {
        applyingList.push({daoInfo, medals: ref(medals)})
      }
    }
  })
  // ContractCall(abi_bridge, bridge, 'userDetail', [account.value]).then((res) => {
  //   let ret = JSON.parse(res);
  //   console.log(ret)
  //   console.log(ret.dao)
  // })
})

</script>

<style lang="scss" scoped>
.header {
  display: flex;
  height: 2.5rem;
  line-height: 2.5rem;
  background: #FFFFFF;
  padding: 0 10rem;

  .item {
    cursor: pointer;
    font-size: 0.5rem;

    font-weight: 500;
    color: #999999;
    height: 2.5rem;
    line-height: 2.5rem;
    padding-right: 1.67rem;
  }

  .active {
    color: #6E3FF5;
  }
}
</style>
