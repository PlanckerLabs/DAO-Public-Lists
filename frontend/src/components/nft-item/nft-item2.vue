<template>
  <div class="card" @click="emit('nftDetail')">
    <div class="position-relative">
      <el-image class="avatar" fit="fill" :src="info.uri"></el-image>
      <div v-if="info.applying" class="applying flex align-center justify-center">
        <div class="applying-des">Currently Applying</div>
      </div>
      <div v-if="info.canApply" class="apply-btn">
        <el-button color="#6E3FF5" @click="apply" :loading="loading">Apply</el-button>
      </div>
    </div>
    <div class="des">
      <div class="name">{{ info.name }}</div>
      <div class="normal">Holdings:
        <div class="value">{{ info.approved }}</div>
      </div>
      <div class="normal">Pending Applications:
        <div class="value"> {{ info.request }}</div>
      </div>
    </div>

  </div>

</template>

<script setup>
import {toRef, ref, unref} from 'vue';
import useWeb3 from "/src/utils/useWeb3";
import abi_dao from '/src/assets/abi/soulBoundMedal.json';

const {ContractSend} = useWeb3();

const emit = defineEmits(['nftDetail']);
const props = defineProps({
  info: {
    type: Object,
    default: {
      index: 0,
      contract_address: '',
      uri: 'https://muyu-pub.oss-cn-beijing.aliyuncs.com/dao2dao/demo/2063481ac4d0df1f44243100bce0ed8.jpg',
      name: 'kyle Medal of Honour',
      approved: 30,
      request: 40,
      applying: false,
      canApply: true
    }
  },
})
const info = toRef(props, 'info');
const loading = ref(false);
// console.log(info);
// 申请一个NFT
const apply = () => {
  let info_ = unref(info);
  loading.value = true;
  ContractSend(abi_dao, info_.contract_address, 'cliamRequest', [info_.index]).then((res) => {
    loading.value = false;
  }).catch(() => {
    loading.value = false;
  })
}
</script>

<style lang="scss" scoped>
.card {
  cursor: pointer;
  display: flex;
  flex-direction: column;
  width: 10.67rem;
  height: 14.83rem;
  background: #FFFFFF;
  border-radius: 0.33rem;
  border: 0.04rem solid #EEEEEE;

  .apply-btn {
    position: absolute; 
    bottom: 0.5rem;
    right: 0.42rem;
  }

  .applying {
    height: 2rem;
    background: #999999;
    position: absolute;
    bottom: 0;
    width: 100%;

    .applying-des {
      font-size: 0.67rem;
      
      font-weight: 500;
      color: #FFFFFF;
    }
  }

  .avatar {
    width: 10.67rem;
    height: 10.67rem;
    vertical-align: middle;
    border-radius: 0.33rem 0.33rem 0 0;
  }

  .des {
    margin: 0.42rem 0 0 0.67rem;

    .name {
      height: 0.92rem;
      font-size: 0.67rem;
      
      font-weight: 500;
      color: #000000;
      line-height: 0.92rem;
    }

    .normal {
      display: flex;
      margin-top: 0.17rem;
      height: 0.71rem;
      font-size: 0.5rem;
      
      font-weight: 400;
      color: #999999;
      line-height: 0.71rem;

      .value {
        color: #6E3FF5
      }
    }
  }
}
</style>
