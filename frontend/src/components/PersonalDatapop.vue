<template>
<div class="personalpop">
  <div class="headrow">Personal Data Settings</div>
  <div class="datarow">
    <span class="leftdata">Name(Dao)</span><span class="rightdata">{{ uinfo.name ? uinfo.name : 'Unset' }}</span>
  </div>
  <div class="datarow">
    <span class="leftdata">Url</span><span class="rightdata">{{ uinfo.url ? uinfo.url : 'Unset' }}</span>
  </div>
  <div class="datarow">
    <span class="leftdata">Avater</span><span class="rightdata">{{ uinfo.avater ? uinfo.avater : 'Unset' }}</span>
  </div>
  <div class="datarow">
    <span class="leftdata">Description</span><span
      class="rightdata">{{ uinfo.description ? uinfo.description : 'Unset' }}</span>
  </div>
  <div class="datarow">
    <span class="leftdata">Discord</span><span
      class="rightdata">{{ uinfo.comdiscord ? uinfo.comdiscord : 'Unset' }}</span>
  </div>
  <div class="datarow">
    <span class="leftdata">Github</span><span
      class="rightdata">{{ uinfo.comgithub ? uinfo.comgithub : 'Unset' }}</span>
  </div>
  <div class="datarow">
    <span class="leftdata">Reddit</span><span
      class="rightdata">{{ uinfo.comreddit ? uinfo.comreddit : 'Unset' }}</span>
  </div>
  <div class="datarow">
    <span class="leftdata">Twitter</span><span
      class="rightdata">{{ uinfo.comtwitter ? uinfo.comtwitter : 'Unset' }}</span>
  </div>
  <div class="datarow lasdatarow">
    <span class="leftdata">Telegram</span><span
      class="rightdata">{{ uinfo.comtelegram ? uinfo.comtelegram : 'Unset' }}</span>
  </div>
</div>
</template>
<script setup>
import {toRef} from "vue";

const props=defineProps({
  uinfo: {
    type: Object,
    default: {
      name: 'xxx',
      url: 'xxx',
      avater: 'xxx',
      description: 'xxx',
      comdiscord: 'xxx',
      comgithub: 'xxx',
      comreddit: 'xxx',
      comtwitter: 'xxx',
      comtelegram: 'xxx'
    }
  }
})
const uinfo = toRef(props, 'uinfo');
let inidata = async function () {  
console.log('-----------');
}
defineExpose({
  inidata
})
</script> 
<style lang="scss" scoped>
.headrow {
  height: 1.75rem;
  font-size: 1.25rem;
  //font-family: PingFangSC-Regular, PingFang SC;
  font-weight: 400;
  color: #000000;
  line-height: 1.75rem;
  margin: 1.67rem 0 1.67rem 2.5rem;
}

.datarow {
  height: 1.6rem;
  line-height: 1.6rem;
}

.leftdata {
  width: 7.91rem;
  margin-right: 1.67rem;
  font-size: 0.93rem;
  //font-family: PingFangSC-Medium, PingFang SC;
  font-weight: 400;
  color: #999999;
  display: inline-block;
  text-align: right;
}

.rightdata {
  font-size: 0.93rem;
  //font-family: PingFangSC-Medium, PingFang SC;
  font-weight: 500;
  color: #000000;
}

.lasdatarow {
  margin-bottom: 1.62rem;
}
</style>
