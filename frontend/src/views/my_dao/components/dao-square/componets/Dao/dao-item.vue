<template>
  <div style="margin-bottom: 0.42rem;">
    <DaoInfo :info="item.detail" class="dao_info"/>
    <div class="flex flex-wrap nfts">
      <template v-if="item.medals.length>0">
        <template v-for="(item,index) in item.medals" :key="index">
          <NFTItem :info="item" class="nft_item"/>
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
  </div>
</template>

<script setup>
import NFTItem from '/src/components/nft-item/nft-item2.vue';
import DaoInfo from '/src/components/dao-item/info.vue';
import {toRef} from "vue";

const props = defineProps({
  item: {
    type: Object
  }
})
const item = toRef(props, 'item');

</script>

<style lang="scss" scoped>
.dao_info {
  padding: 0.83rem 10rem;

}

.nfts {
  background-color: #FFF;
  padding: 1.67rem 0 1.63rem 10rem;
}

.nft_item {
  margin-right: 1.67rem;
}
</style>
