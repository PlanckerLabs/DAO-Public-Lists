// replace nft
<template>
  <el-drawer
      custom-class="settingdrawer"
      v-model="showDlg"
      :with-header="false"
      :close-on-click-modal="false"
      direction="btt">
    <el-scrollbar>
      <div class="drawerhead">
        <span class="headclose" @click="showDlg=false">close</span>
      </div>
      <!--      <div class="headrow">-->
      <!--        <span class="headtitle">Settings</span>-->
      <!--      </div>-->
      <!--      <div class="row">-->
      <!--        <span class="label">Application timeout(Day)</span>-->
      <!--        <el-input class="dlginput" v-model="info.timeout"></el-input>-->
      <!--        <el-button color="#6E3FF5" :loading="btn1_loading" :disabled="btn1_disable" @click="saveTimeOut">Save-->
      <!--        </el-button>-->
      <!--      </div>-->
      <div class="headrow">
        <span class="headtitle">Personal Profile Settings</span>
      </div>
      <div class="row">
        <span class="label">Email</span>
        <el-input class="dlginput" v-model="info.email"></el-input>
      </div>
      <div class="row">
        <span class="label">Url</span>
        <el-input class="dlginput" v-model="info.url"></el-input>
      </div>
      <div class="row">
        <span class="label">Avater</span>
        <el-input class="dlginput" v-model="info.avatar"></el-input>
      </div>
      <div class="row">
        <span class="label">Description</span>
        <el-input class="dlginput" v-model="info.description" :rows="2" type="textarea"></el-input>
      </div>
      <div class="row">
        <span class="label">Discord</span>
        <el-input class="dlginput" v-model="info.comdiscord"></el-input>
      </div>
      <div class="row">
        <span class="label">Github</span>
        <el-input class="dlginput" v-model="info.comgithub"></el-input>
      </div>
      <div class="row">
        <span class="label">Reddit</span>
        <el-input class="dlginput" v-model="info.comreddit"></el-input>
      </div>
      <div class="row">
        <span class="label">Twitter</span>
        <el-input class="dlginput" v-model="info.comtwitter"></el-input>
      </div>
      <div class="row">
        <span class="label">Telegram</span>
        <el-input class="dlginput" v-model="info.comtelegram"></el-input>
        <el-button color="#6E3FF5" :loading="btn2_loading" @click="save">Submit
        </el-button>
      </div>
    </el-scrollbar>
  </el-drawer>
</template>
<script setup>
import {onMounted, reactive, ref, toRefs, watch} from "vue";
import useWeb3 from "/src/utils/useWeb3";
import abi from '/src/assets/abi/soulBoundBridge.json';
import {ElLoading, ElNotification} from 'element-plus';

const {account, web3, ContractCall, ContractSend, bridge} = useWeb3();
const btn1_loading = ref(false);
const btn1_disable = ref(true);

const btn2_loading = ref(false);
const btn2_disable = ref(true);

const showDlg = ref(false);


const info = reactive({
  // 'timeout': '',
  'url': '',
  'email': '',
  'avatar': '',
  'description': '',
  'comdiscord': '',
  'comgithub': '',
  'comreddit': '',
  'comtwitter': '',
  'comtelegram': '',
});
let oldinfo = {};


// 编码参数
const encodeParam = () => {
    let params = [];
    Object.keys(toRefs(info)).forEach((k) => {
        // params[k] = ;
        params.push(web3.eth.abi.encodeFunctionSignature(k));
    })
    return params;
}
function fieldsdiffarr()
{ 
    let fieldarr = [];
    let valarr = [];
    Object.keys(toRefs(info)).forEach((k) => {
        if( info[ k ] != oldinfo[ k ] )
        {
            fieldarr.push( web3.eth.abi.encodeFunctionSignature(k) );
            valarr.push( info[ k ] );
        } 
    }) 
    if( !fieldarr || fieldarr.length == 0 )
    {
        return false;
    }
    return [ fieldarr, valarr ];
}
// 读取用户信息
const read = async () => {
  const loading = ElLoading.service({
    lock: true,
    text: 'Loading',
    background: 'rgba(0, 0, 0, 0.7)',
  })
  return await ContractCall(abi, bridge, 'getStrings', [account.value, encodeParam()]).then((res) => {
    loading.close();
    return res;
  }).catch(() => {
    loading.close();
  })
}
// 保存用户信息
const save = () => {
    btn2_loading.value = true;
    let key_arr = encodeParam();
    let value_arr = [];
    Object.keys(toRefs(info)).forEach((k) => {
        value_arr.push(info[k])
    });
    let savearr = fieldsdiffarr();
    if( !savearr )
    {
        showDlg.value = false;
        return;
    }
    ContractSend(abi, bridge, 'saveStrings', savearr ).then((res) => {
        // console.log(res);
        showDlg.value = false;
        btn2_loading.value = false;
        ElNotification({
        title: 'Success',
        message: 'blockHash:' + res.blockHash,
        type: 'success',
        duration: 3000
        })
    }).catch(() => {
        btn2_loading.value = false;
    })
}


// 显示dialog
const showdrawer = async () => {
    // init
    let values = await read(); 
    Object.keys(toRefs(info)).forEach((k, v) => {
        info[k] = values[v];
        oldinfo[ k ] = values[ v ]; 
    })
    showDlg.value = true;
}
defineExpose({
  showdrawer
})
</script>
<style>
.settingdrawer .el-scrollbar__view {
  overflow-x: hidden;
}

.settingdrawer {
  height: auto !important;
  top: 3.33rem;
  bottom: 0;
  border-radius: 1.67rem 1.67rem 0rem 0rem;
}

.settingdrawer .el-drawer__body {
  padding: 0px 0 1.2rem 0;
  overflow: hidden;
  overflow-y: auto;
}

.settingdrawer  .el-textarea__inner
{
    background: #F5F5F5;
    box-shadow: none;
}
.row .dlginput .el-input__wrapper {
  background: #F5F5F5;
  box-shadow: none;
}
</style>

<style lang="scss" scoped>

.el-button {
  width: 10.67rem;
  height: 2rem;
  border-radius: 0.33rem;
  margin-left: 1.67rem;
}

.row {
  margin-bottom: 0.83rem;
}

.row .label {
  width: 20.37rem;
  height: 2rem;
  line-height: 2rem;
  font-size: 0.83rem;
  font-family: PingFangSC-Regular, PingFang SC;
  font-weight: 400;
  color: #999999;
  text-align: right;
}

.row .dlginput {
  width: 35.33rem;
  min-height: 2rem;
  background: #F5F5F5;
  border-radius: 0.33rem;
  margin-left: 1.67rem;
}

.row .savebt {
  width: 10.67rem;
  height: 2rem;
  background: #EEEEEE;
  border-radius: 0.33rem;
  line-height: 2rem;
  font-size: 0.67rem;
  font-family: PingFangSC-Medium, PingFang SC;
  font-weight: 500;
  color: #999999;
  margin-left: 1.67rem;
  text-align: center;
  cursor: pointer;
}

.row .savebt.chgedbt {
  background: #6E3FF5;
  color: #FFFFFF;
}

.headrow {
  margin: 3.33rem 0 1.33rem 21rem;
  font-size: 1.25rem;
  font-family: PingFangSC-Regular, PingFang SC;
  font-weight: 400;
  color: #000000;
}

.drawerhead {
  position: absolute;
  right: 0;
  top: 0;
}

.headclose {
  height: 1rem;
  font-size: 0.71rem;
  font-family: PingFangSC-Regular, PingFang SC;
  font-weight: 400;
  color: #F53F3F;
  margin: 1.67rem 1.67rem 0 0;
  line-height: 1rem;
  float: right;
  cursor: pointer;
}
</style>
