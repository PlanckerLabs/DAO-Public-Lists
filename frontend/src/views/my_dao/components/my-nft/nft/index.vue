<!--
 * @Description: 
 * @Version: 1.0
 * @Autor: z.cejay@gmail.com
 * @Date: 2022-05-29 02:39:57
 * @LastEditors: cejay
 * @LastEditTime: 2022-05-30 10:39:03
-->
<template>
  <div class="flex flex-wrap bg">
    <template v-for="(item,index) in collection.medals" :key="index">
      <NFTItem :item="item" :contractAddress="collection.daoInfo.address" :applying="item.status===1" class="nft_item"/>
    </template>
  </div>
  <div style="margin-top: 0.04rem;"></div>
  <!--  <PersonalInfo class="personal_info" :personal_info="personal_info"/>-->
  <DaoInfo :info="collection.daoInfo" class="dao_info"/>
</template>

<script setup>
// 我的NFT collection
import NFTItem from '/src/components/nft-item/index.vue';
import DaoInfo from '/src/components/dao-item/info.vue';
import {toRef} from "vue";


const props = defineProps({
  collection: {
    type: Object,
    default: {}
  }
})
const collection = toRef(props, 'collection'); 

</script>

<style lang="scss" scoped>
.bg {
  background-color: #FFF;
  padding: 1.67rem 0 1.63rem 10rem;
  height: 100%;
}

.personal_info {
  padding: 0.83rem 10rem;
  margin-bottom: 0.42rem;
}

.nft_item {
  margin: 0 1.67rem 1.67rem 0;
}

</style>
