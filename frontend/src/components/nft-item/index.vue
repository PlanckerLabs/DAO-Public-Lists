<template>
  <div class="flex flex-column align-center nft_item">
    <div class="position-relative">
      <el-image class="avatar" fit="cover" :src="item.uri"></el-image>
      <div v-if="applying" class="applying flex align-center justify-center">
        <div class="applying-des">Pending</div>
      </div>
    </div>
    <div class="des">{{ item.name }}</div>
  </div>
</template>

<script setup>
// 我的NFT item
import {toRef} from "vue";

const props = defineProps({
  item: {
    type: Object,
    default: {
      name: '/img/demo/5aeef77b3fc25beb79f5d188fac90a0.jpg',
      uri: 'Kyle Medal of Honour'
    }
  },
  applying: {
    type: Boolean,
    default: false
  }
})
const item = toRef(props, 'item');
const applying = toRef(props, 'applying');
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
