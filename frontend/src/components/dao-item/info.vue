<template>
  <div class="flex justify-between personal_info align-center">
    <div class="flex">
      <el-image class="avatar" :src="info.avatar"></el-image>
      <div class="flex flex-column des">
        <div class="name">{{ info.name }}</div>
        <div class="normal">Email: {{ info.email }}</div>
        <div class="normal">Url: {{ info.comgithub }}</div>
        <div class="flex">
          <!--          <div class="normal">Already Applied:-->
          <!--            <div class="value">-->
          <!--              {{ info.alreadyApplied }}-->
          <!--            </div>-->
          <!--          </div>-->
          <!--          <div class="normal" style="margin-left: 0.83rem;">Passed:-->
          <!--            <div class="value">-->
          <!--              {{ info.passed }}-->
          <!--            </div>-->
          <!--          </div>-->
        </div>
      </div>
    </div>
<!--    <el-popover placement="left" :width="400" trigger="click">-->
<!--      <template #reference>-->
<!--        <div class="menu-btn">-->
<!--          <div class="font">-->
<!--            ···-->
<!--          </div>-->
<!--        </div>-->
<!--      </template>-->
<!--      <PersonalDataPop/>-->
<!--    </el-popover>-->
  </div>


</template>

<script setup>

import {toRef, unref} from "vue";
import PersonalDataPop from '/src/components/PersonalDatapop.vue';

const props = defineProps({
  info: {
    type: Object,
    default: {
      avatar: 'https://muyu-pub.oss-cn-beijing.aliyuncs.com/dao2dao/demo/a4765b6b6f385375f0fd09b3bb7059d.jpg',
      name: '',
      email: '',
      url: '',
      alreadyApplied: 5,
      passed: 4
    }
  }
})
const info = toRef(props, 'info');
// console.log(info)
</script>

<style lang="scss" scoped>
.personal_info {
  background-color: #FFF;

  .menu-btn {
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 1.67rem;
    height: 1.33rem;
    background: #FFFFFF;
    border-radius: 0.17rem;
    border: 0.04rem solid #EEEEEE;

    .font {
      font-weight: 510;
    }
  }

  .avatar {
    width: 3.33rem;
    height: 3.33rem;
    border-radius: 100rem;
  }

  .des {
    margin-left: 0.83rem;

    .name {
      height: 0.92rem;
      font-size: 0.67rem;
      //font-family: PingFangSC-Medium, PingFang SC;
      font-weight: 500;
      color: #000000;
      line-height: 0.92rem;
    }

    .normal {
      display: flex;
      height: 0.71rem;
      font-size: 0.5rem;
      //font-family: PingFangSC-Medium, PingFang SC;
      font-weight: 500;
      color: #999999;
      line-height: 0.71rem;
      margin-top: 0.13rem;

      .value {
        margin-left: 0.15rem;
        color: #000;
      }
    }
  }
}
</style>
