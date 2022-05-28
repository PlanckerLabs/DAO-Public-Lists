<template>
  <template v-if="route_path==='/'">
    <div class="flex header-home">
      <img class="logo" :src="logo" @click="pushRouter('/')" style="cursor: pointer;"/>
      <div class="flex align-center" style="float:right;position:absolute;right:0;height: 100%">
        <el-button @click="enterApp()" color="#6E3FF5" class="connect_btn">Enter DAPP
        </el-button>
      </div>
    </div>
  </template>
  <template v-else>
    <div class="flex header-other">
      <img class="logo" :src="logo" @click="pushRouter('/')" style="cursor: pointer;"/>
      <div class="flex flex-1 align-center" style="float:right;">
        <div class="flex ml-auto align-center" style="margin-right: 2.13rem;">
          <div class="flex align-center icon-font" @click="onHandleSettings">
            <img class="icon" :src="icon.settings"/>
            <span class="font_">Settings</span>
          </div>
          <div class="flex align-center icon-font" style="margin-left: 2.71rem;" @click="onHandleCreateDao">
            <img class="icon" :src="icon.add"/>
            <span class="font_">Create Dao</span>
          </div>
        </div>
        <div class="header-my" ref="buttonRef" v-click-outside="onClickOutside">
          <img class="tx" :src="tx"/>
          <div class="divider"></div>
          <div class="font_ text-ellipsis">{{ store.Account }}</div>
        </div>
      </div>
    </div>
    <CreateDao ref="createDaoDlg"/>
    <!--    下popover-->
    <el-popover
        ref="popoverRef"
        :virtual-ref="buttonRef"
        trigger="click"
        :show-arrow="false"
        :teleported="false"
        popper-style="width:10rem;padding:0"
        virtual-triggering
    >
      <div class="menu" @click="goPersonalCenter">
        <div class="item">Personal Center</div>
      </div>
      <div class="menu">
        <div class="item" @click="pushRouter('/')">
          Exit
        </div>
      </div>
    </el-popover>
    <Settings ref="settingsDlg"/>
  </template>
</template>

<script lang="ts" setup>
import {useRoute, useRouter} from "vue-router";
import useWeb3 from "../utils/useWeb3";
import {onMounted, ref, unref} from "vue";
import {ClickOutside as vClickOutside} from 'element-plus'
// import Settings from "./Setting.vue";

import CreateDao from "./CreateDao.vue";
import Settings from './Setting.vue';
import {useStore} from "@/store";

const buttonRef = ref()
const createDaoDlg = ref();
const settingsDlg = ref();
const popoverRef = ref()
const store = useStore();
const onClickOutside = () => {
  unref(popoverRef).popperRef?.delayHide?.();
}
const goPersonalCenter = () => {
  if (route_path.value !== '/personal_center') {
    pushRouter('/personal_center');
  }
}

const onHandleSettings = () => {
  // console.log("设置dialog")
  unref(settingsDlg).showdrawer();
}

const onHandleCreateDao = () => {
  // console.log("创建Dao dialog")
  unref(createDaoDlg).showdialog();
}

const route_path = ref('');
const logo = 'https://muyu-pub.oss-cn-beijing.aliyuncs.com/dao2dao/dapp_logo%20%402x.png';
const tx = 'https://muyu-pub.oss-cn-beijing.aliyuncs.com/dao2dao/dapp_tx.png';
const icon = {
  settings: 'https://muyu-pub.oss-cn-beijing.aliyuncs.com/dao2dao/dapp_Settings.png',
  add: 'https://muyu-pub.oss-cn-beijing.aliyuncs.com/dao2dao/dapp_add.png'
}
const router = useRouter()
const route = useRoute()


onMounted(() => {
  route_path.value = route.path;
})
// 跳转路由
const pushRouter = (path: string) => {
  router.push({
    path
  })
}
// 进入DAPP
const enterApp = () => {
  store.login().then((res) => {
    pushRouter('/myDao');
  }).catch(() => {
    console.log("err");
  })
}
</script>

<style lang="scss" scoped>
.menu {
  width: 10rem;
  height: 2.5rem;
  background: #FFFFFF;
  border-radius: 0.33rem;

  .item {
    padding: 0.67rem 0 0.67rem 1.33rem;
    font-size: 0.83rem;
    
    font-weight: 400;
    color: #000000;
    line-height: 1.17rem;
  }
}

.menu:hover {
  cursor: pointer;
  background-color: rgba(159, 159, 154, 0.1);
}

.header-home {
  position: relative;
  height: 3.33rem;
  background: linear-gradient(180deg, #000000 0%, rgba(0, 0, 0, 0) 100%);
}

.header-other {
  height: 3.33rem;
  position: absolute;
  left: 0;
  right: 0;
}

.logo {
  width: 1.83rem;
  height: 1.83rem;
  margin-top: 0.79rem;
  margin-left: 3.3rem;
}

.icon-font {
  cursor: pointer;

  .icon {
    width: 0.83rem;
    height: 0.83rem;
  }

  .font_ {
    margin-left: 0.42rem;

    height: 0.92rem;
    font-size: 0.67rem;
    
    font-weight: 500;
    color: #FFFFFF;
    line-height: 0.92rem;
  }
}

.connect_btn {
  width: 6.67rem;
  height: 1.33rem;
  background: #6E3FF5;
  border-radius: 0.17rem;
  margin-right: 3.33rem;
  font-size: 0.67rem;
  font-weight: 400;
  color: #FFFFFF;
  line-height: 0.79rem;
}

.header-my {
  display: flex;
  align-items: center;
  width: 7.25rem;
  height: 1.33rem;
  background: #6E3FF5;
  border-radius: 0.17rem;
  margin-right: 3.33rem;
  cursor: pointer;

  .divider {
    width: 0.04rem;
    height: 0.67rem;
    margin: 0 0.5rem;
    background: #FFFFFF;
    border-radius: 0.02rem;
    opacity: 0.2;
  }

  .tx {
    margin: 0.25rem 0 0.25rem 0.5rem;
    width: 0.83rem;
    height: 0.83rem;
  }

  .font_ {
    width: 4.38rem;
    height: 0.88rem;
    font-size: 0.67rem;
    font-weight: 500;
    color: #FFFFFF;
    line-height: 0.88rem;
  }
}
</style>
