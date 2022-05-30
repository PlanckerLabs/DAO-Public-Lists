<!--
 * @Description: 
 * @Version: 1.0
 * @Autor: z.cejay@gmail.com
 * @Date: 2022-05-29 13:01:32
 * @LastEditors: cejay
 * @LastEditTime: 2022-05-30 10:41:13
-->
<template>
  <div class="flex flex-column align-center nft_item">
    <div class="position-relative">
      <el-image v-if="item.status <= 2" class="avatar" fit="cover" :src="Tools.imgURL(item.uri)"></el-image>
      <el-image v-if="item.status > 2" class="avatar" style="cursor: pointer;" fit="cover" :src="Tools.imgURL(item.uri)" @click="viewNft(item)">
      </el-image>

      <div v-if="applying" class="applying flex align-center justify-center">
        <div class="applying-des">Pending</div>
      </div>
    </div>
    <div class="des">{{ item.name }}</div>
  </div>
</template>

<script setup>
// 我的NFT item
import { toRef } from "vue";
import Tools from '/src/utils/tools';

const props = defineProps({
  item: {
    type: Object,
    default: {
      name: '',
      uri: ''
    }
  },
  applying: {
    type: Boolean,
    default: false
  },
  contractAddress: {
    type: String,
    default: ''
  }
})
const item = toRef(props, 'item');
const applying = toRef(props, 'applying');
const contractAddress = props.contractAddress;//toRef(props, 'contractAddress');
 
const viewNft = (item) => {
  //console.log(item);
  // open new page
  window.open(Tools.blockchainScanUrl_tokenId(contractAddress, item.status), "_blank");
}
</script>
<!--//padding-right: 1.67rem;-->
<style lang="scss" scoped>
.nft_item {
  .avatar {
    width: 10.67rem;
    height: 10.67rem;
    vertical-align: bottom;
    border-radius: 0.33rem;
  }

  .applying {
    height: 2rem;
    background: #99999991;
    border-radius: 0rem 0rem 0.33rem 0.33rem;
    position: absolute;
    bottom: 0;
    width: 100%;

    .applying-des {
      font-size: 0.67rem;

      font-weight: 500;
      color: #FFFFFF;
    }
  }

  .des {
    margin-top: 0.42rem;
    font-size: 0.67rem;

    font-weight: 500;
    color: #000000;

  }
}
</style>
