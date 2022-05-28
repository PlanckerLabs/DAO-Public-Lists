<template>
  <div class="position-relative" style="background-color:#352F46;">
    <Header/>
    <div class="return-btn" @click="router.push('/myDao')">
      <img class="icon" src="/img/dapp_me_return_icon%402x.png">
      <div class="font">Return</div>
    </div>
    <div class="position-absolute" style="left: 50%;top:3.33rem;transform: translateX(-50%);">
      <img style="width: 41.67rem;height: 39.83rem;"
           src="/img/dapp_me_bg%402x.png"/>
    </div>
    <div style="padding-top: 3.33rem;background-color:#352F46;"></div>
    <el-tabs v-model="activeName" class="tabs" @tab-click="handleClick">
      <el-tab-pane :label="tabs[0]" name="first">
        <div class="box">
          <NFTItem/>
        </div>

      </el-tab-pane>
      <el-tab-pane :label="tabs[1]" name="second">
        <div class="flex justify-center">
          <PersonalData class="personal_data"/>
        </div>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script lang="ts" setup>
import Header from '/src/components/Header.vue';
import {ref} from "vue";
import {TabsPaneContext} from "element-plus";
import NFTItem from '/src/components/nft-item/nft-item4.vue';
import PersonalData from '/src/components/PersonalData.vue';
import {useRouter} from "vue-router";

const activeName = ref('first')
const tabs = ['My NFT', 'Personal Data'];
const router = useRouter();
const handleClick = (tab: TabsPaneContext, event: Event) => {
  console.log(tab, event)
}

</script>

<style lang="scss" scoped>
$tab-font-active: #FFF;
$tab-font: #999999;
body {
  background-color: #352F46;
}

.return-btn {
  display: flex;
  align-items: center;
  cursor: pointer;
  position: absolute;
  left: 9.75rem;
  top: 5rem;
  width: 4.17rem;
  height: 1.67rem;
  background: #6E3FF5;
  border-radius: 0.33rem;

  .icon {
    width: 1rem;
    height: 1rem;
    padding: 0.33rem 0.17rem 0.33rem 0.33rem;
  }

  .font {
    height: 0.92rem;
    font-size: 0.67rem;
    
    font-weight: 500;
    color: #FFFFFF;
    line-height: 0.92rem;
  }
}

.personal_data {
  margin: 3.25rem 0 7.08rem 0;
  width: 60rem;
  height: 25.08rem;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 0.33rem;
  border: 0.08rem solid rgba(255, 255, 255, 0.2);
}

.box {
  display: flex;
  flex-wrap: wrap;
  margin: 3.33rem 0rem 0 9.75rem;
}

:deep(.tabs) {
  margin-top: 10.79rem;
  background-color: transparent;

  .el-tabs__header {
    margin: 0;
  }

  .el-tabs__nav-wrap::after {
    background-color: #FFF !important;
    opacity: 0.2 !important;
    height: 0.04rem;
  }

  .el-tabs__item.is-active {
    width: 10rem !important;
    font-size: 0.67rem !important;
    
    font-weight: 500 !important;
    color: $tab-font-active;
  }

  .el-tabs__item {
    width: 10rem;
    font-size: 0.67rem;
    line-height: 2.5rem;
    height: 2.5rem;
    
    font-weight: 500;
    color: $tab-font;
  }

  .el-tabs__nav-scroll {
    display: flex;
    justify-content: center;
  }

  .el-tabs__active-bar {
    width: 5rem !important;
    height: 0.08rem !important;
    background: #FFF !important;
  }

  > .el-tabs__content {
    background-color: transparent;
    min-height: 50rem;
  }
}
</style>
