<template>
  <div style="background-color: #FFF">
    <div class="flex dao-item justify-between align-center">
      <div class="flex">
        <el-image :src="daoInfo.avatar" class="avatar"></el-image>
        <div class="right-panel">
          <div class="name">{{ daoInfo.name }}</div>
          <div class="normal">{{ daoInfo.contract_address }}</div>
          <!--          <div class="normal">Creation Time:{{ daoInfo.create_time }}</div>-->
          <div class="flex normal">
            <div class="flex">
              <div>Apply For Medal:</div>
              <div class="value">0</div>
            </div>
            <div class="flex" style="margin-left: 0.83rem;">
              <div>Reject Application：</div>
              <div class="value">0</div>
            </div>
            <div class="flex" style="margin-left: 0.83rem;">
              <div>Application Approved:</div>
              <div class="value">0</div>
            </div>
          </div>
        </div>
      </div>
      <div class="flex">
        <el-button color="#EEEEEE" class="edit-btn" @click="emit('edit',daoInfo.contract_address)">Editor</el-button>
        <el-button color="#6E3FF5" class="add-btn" @click="emit('add',daoInfo.contract_address)">
          <img class="add-btn-icon"
               src="https://muyu-pub.oss-cn-beijing.aliyuncs.com/dao2dao/dapp_add2%402x.png"/>
          Add
        </el-button>
      </div>
    </div>
  </div>

</template>

<script setup>
import {toRef, ref, onBeforeUpdate} from "vue";
import useWeb3 from '/src/utils/useWeb3';


const {ContractCall, bridge, mounted} = useWeb3();

const props = defineProps({
  daoInfo: {
    type: Object,
    default: {
      avatar:'https://muyu-pub.oss-cn-beijing.aliyuncs.com/dao2dao/dapp_dao_tx%402x.png',
      name: 'Kyle Dao',
      owner: '0x0C81Dc3f36Ed9f8c30B62b7e4E5362Dac02fE221',
      contract_address: ''
    }
  }
})
const daoInfo = toRef(props, 'daoInfo');

const emit = defineEmits(['edit', 'add'])


// onMounted(async () => {
//   // await mounted();
//   // console.log(daoInfo.contract_address);
//   // ContractCall(abi, bridge, 'getString', [daoInfo.contract_address, encodeParam()]).then((res) => {
//   //
//   //
//   // }).catch(() => {
//   //
//   // })
// })

</script>

<style lang="scss" scoped>
$font-family: PingFangSC-Medium, PingFang SC;
.dao-item {
  margin: 0 10rem;
  padding: 1.67em 0;

  .avatar {
    width: 4.17rem;
    height: 4.17rem;
    border-radius: 100rem;
    background: #F5F5F5;
  }

  .right-panel {
    display: flex;
    flex-direction: column;
    margin-left: 0.83rem;

    .name {
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;

      width: 5rem;
      height: 1.17rem;
      font-size: 0.83rem;
      font-family: $font-family;
      font-weight: 500;
      color: #000000;
      line-height: 1.17rem;
    }

    .normal {
      margin-top: 0.17rem;
      height: 0.71rem;
      font-size: 0.5rem;
      font-family: $font-family;
      font-weight: 500;
      color: #999999;
      line-height: 0.71rem;

      .value {
        margin-left: 0.17rem;
        height: 0.71rem;
        font-size: 0.5rem;
        font-family: $font-family;
        font-weight: 500;
        color: #000;
      }
    }
  }
}

.edit-btn {
  width: 3.33rem;
  height: 1.67rem;
  background: #EEEEEE;
  border-radius: 0.33rem;

  span {
    width: 1.92rem;
    height: 0.92rem;
    font-size: 0.67rem;
    font-family: PingFangSC-Medium, PingFang SC;
    font-weight: 500;
    color: #000000;
    line-height: 0.92rem;
  }
}

.add-btn {
  width: 3.33rem;
  height: 1.67rem;
  background: #6E3FF5;
  border-radius: 0.33rem;

  span {
    width: 1.25rem;
    height: 0.92rem;
    font-size: 0.67rem;
    font-family: PingFangSC-Medium, PingFang SC;
    font-weight: 500;
    color: #FFFFFF;
    line-height: 0.92rem;

    .add-btn-icon {
      width: 1rem;
      height: 1rem;
    }
  }
}
</style>
