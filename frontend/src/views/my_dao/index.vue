<template>
  <Header/>
  <div :class="header_">
  </div>
  <div class="my_dao">
    <el-tabs v-model="activeName" class="tabs" @tab-click="handleClick">
      <el-tab-pane :label="tabs[0]" name="first">
        <MyDAo/>
      </el-tab-pane>
      <el-tab-pane :label="tabs[1]" name="second">
        <MyNFT/>
      </el-tab-pane>
      <el-tab-pane :label="tabs[2]" name="third">
        <DaoSquare/>
      </el-tab-pane>
    </el-tabs>
  </div>

</template>

<script lang="ts" setup>

import Header from "../../components/Header.vue";
import MyDAo from "./components/my-dao/index.vue";
import MyNFT from './components/my-nft/index.vue';
import DaoSquare from './components/dao-square/index.vue';

import {onMounted, ref} from 'vue'
import type {TabsPaneContext} from 'element-plus'
import dapp_top_bg_2x from "@/assets/img/dapp_top_bg_2x.png";


const activeName = ref('first')
const tabs = ['MY DAO', 'MY NFT', 'DAO SQUARE'];


const handleClick = (tab: TabsPaneContext, event: Event) => {
  console.log(tab.paneName)
}
onMounted(() => {

})
const header_ = {
  height: '16.67rem',
  backgroundImage: dapp_top_bg_2x,
  backgroundRepeat: 'no-repeat',
  backgroundSize: 'cover'
}
</script>

<style lang="scss">
$tab-font-active: #000000;
$tab-font: #999999;
$tabs-header-color: #FFF;


//.header_ {
//  height: 16.67rem;
//  background: url("./src/assets/img/dapp_top_bg_2x.png") no-repeat;
//  background-size: cover;
//}

.my_dao .tabs {
  background-color: $tabs-header-color;

  .el-tabs__header {
    margin: 0;
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

  .el-tabs__nav {
    margin: 0 10rem;
  }


  .el-tabs__active-bar {
    width: 5rem !important;
    height: 0.08rem !important;
    background: #000000 !important;
  }

  > .el-tabs__content {
    background-color: #F5F5F5;
    min-height: 50rem;
  }
}

</style>
