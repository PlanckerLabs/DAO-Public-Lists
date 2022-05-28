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
import useWeb3 from "/src/utils/useWeb3";
import abi_bridge from '/src/assets/abi/soulBoundBridge.json';
import {ElLoading} from "element-plus";
import EmptyNFT from '/src/components/empty-nft/index.vue';

const activeName = ref('first')
const {ContractCall, web3, mounted, account, bridge} = useWeb3();
const allList = reactive([]); //全部列表
const applyingList = reactive([]); //申请中列表
const handleClick = (flag) => {
  activeName.value = flag;
}
const read = async (method, params) => {
  const loading = ElLoading.service({
    lock: true,
    text: 'Loading',
    background: 'rgba(0, 0, 0, 0.7)',
  })
  return await ContractCall(abi_bridge, bridge, method, params).then((res) => {
    loading.close();
    return res;
  }).catch(() => {
    loading.close();
  })
}
// 编码参数
const encodeParam = () => {
  let params = [];
  ['avatar', 'email', 'comgithub'].forEach((k) => {
    // params[k] = ;
    params.push(web3.eth.abi.encodeFunctionSignature(k));
  })
  return params;
}
onMounted(async () => {
  await mounted();
  read('userDetail', [account.value]).then(async (res) => {
    let values = JSON.parse(res);
    let daos = values.dao
    // console.log(daos);
    for (let index in daos) {
      // read('listDAOMedals',[])
      let daoInfo = {};
      let listDAOMedals = JSON.parse(await read('listDAOMedals', [daos[index].address, 0, 9999]));

      let info = await read('getStrings', [daos[index].address, encodeParam()]);
      daoInfo.name = atob(listDAOMedals.name);
      daoInfo.avatar = info[0];
      daoInfo.email = info[1];
      daoInfo.url = info[2];
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
    font-family: PingFangSC-Medium, PingFang SC;
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
