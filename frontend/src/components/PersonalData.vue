// 我的Dao
<template>
  <div class="contentbox">
    <el-row class="datarow">
      <el-col :span="12" class="datal"><span class="labelname">Eth Address</span></el-col>
      <el-col :span="12" class="datar">{{ uinfo.ethaddress }}</el-col>
    </el-row>
    <!-- <el-row class="datarow">
      <el-col :span="12" class="datal"><span class="labelname">Name(Dao)</span></el-col>
      <el-col :span="12" class="datar">{{ uinfo.name }}</el-col>
    </el-row> -->
    <el-row class="datarow">
      <el-col :span="12" class="datal"><span class="labelname">Url</span></el-col>
      <el-col :span="12" class="datar">{{ uinfo.url }}</el-col>
    </el-row>
    <el-row class="datarow avaterrow">
      <el-col :span="12" class="datal"><span class="labelname">Avater</span></el-col>
      <el-col :span="12" class="datar">
      <el-image class="nftimg" :src="Tools.imgURL(uinfo.avater)" fit="cover" />
      </el-col>
    </el-row>
    <el-row class="datarow">
      <el-col :span="12" class="datal"><span class="labelname">Description</span></el-col>
      <el-col :span="12" class="datar">{{ uinfo.description }}</el-col>
    </el-row>
    <el-row class="datarow">
      <el-col :span="12" class="datal"><span class="labelname">Discord</span></el-col>
      <el-col :span="12" class="datar">{{ uinfo.comdiscord }}</el-col>
    </el-row>
    <el-row class="datarow">
      <el-col :span="12" class="datal"><span class="labelname">Github</span></el-col>
      <el-col :span="12" class="datar">{{ uinfo.comgithub }}</el-col>
    </el-row>
    <el-row class="datarow">
      <el-col :span="12" class="datal"><span class="labelname">Reddit</span></el-col>
      <el-col :span="12" class="datar">{{ uinfo.comreddit }}</el-col>
    </el-row>
    <el-row class="datarow">
      <el-col :span="12" class="datal"><span class="labelname">Twitter</span></el-col>
      <el-col :span="12" class="datar">{{ uinfo.comtwitter }}</el-col>
    </el-row>
    <el-row class="datarow">
      <el-col :span="12" class="datal"><span class="labelname">Telegram</span></el-col>
      <el-col :span="12" class="datar">{{ uinfo.comtelegram }}</el-col>
    </el-row>
  </div>
</template>

<script setup>
import {reactive, toRefs, onMounted, watch } from "vue";
import useWeb3 from "/src/utils/useWeb3";
import abi from '/src/assets/abi/soulBoundBridge.json';
import {ElLoading} from 'element-plus';
import Tools from '/src/utils/tools';
let defaultavater = 'https://muyu-pub.oss-cn-beijing.aliyuncs.com/dao2dao/dapp_user_tx%402x.png';
const {account, web3, ContractCall, bridge} = useWeb3();
 
const uinfo = reactive({
    ethaddress: '',
    // name: '',
    url: '',
    avater: '',
    description: '',
    comdiscord: '',
    comgithub: '',
    comreddit: '',
    comtwitter: '',
    comtelegram: ''
});
 
const read = async () => {
  let arr = []; 
  Object.keys(toRefs(uinfo)).forEach((k) => {
    arr.push( web3.eth.abi.encodeFunctionSignature(k));
  }) 
  const loading = ElLoading.service({
    lock: true,
    text: 'Loading',
    background: 'rgba(0, 0, 0, 0.7)',
  }) 
  return await ContractCall(abi, bridge, 'getStrings', [account.value, arr]).then((res) => {
    loading.close();
    return res;
  }).catch(() => {
    loading.close();
  })
} 
let inidata = async function () {  
    let values = await read();
    Object.keys(toRefs(uinfo)).forEach((k, v) => {
        uinfo[k] = values[v];
    });
    uinfo[ 'ethaddress' ] = account.value;
    uinfo[ 'avater' ] =  uinfo[ 'avater' ]? uinfo[ 'avater' ]: defaultavater;
}
let inistatus = false;
watch(account, (account, prevaccount) => {
    if( account && !prevaccount && !inistatus )
    {
        inidata();
        inistatus = true;
    }
})
if( account.value && !inistatus )
{
    inidata();
    inistatus = true;
}
defineExpose({
  inidata
})
</script>

<style>

</style>
<style lang="scss" scoped>
.contentbox {
  background: #FFFFFF 20%;
  padding: 3.33rem 0;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 0.33rem;
  border: 0.08rem solid rgba(255, 255, 255, 0.2);
}
.datarow.avaterrow
{
    line-height: unset;
}
.datarow {
  min-height: 2.59rem;
  line-height: 2.59rem;
}
.nftimg
{
    height: 4rem;
    width:4rem;
}

.datal {
  text-align: right;
  font-size: 1rem;
  //font-family: PingFangSC-Regular, PingFang SC;
  font-weight: 400;
  color: RGBA(151, 147, 161, 1);
}

.datal .labelname {
  margin-right: 1rem;
}

.datar {
  text-align: left;
  font-size: 1rem;
  color: #FFFFFF;
}
</style>

