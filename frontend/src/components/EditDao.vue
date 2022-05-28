// edit dao info
<template>
  <el-dialog v-model="dialogeditdao"
             custom-class="editdlg" width="60rem;"
             :show-close="false"
             :close-on-click-modal="false"
             destroy-on-close>

    <template #header="{ close  }">
      <div class="dlgheadbox">
        <span class="headtitle">DAO Profile Settings</span>
        <span class="headclose" @click="close">close</span>
      </div>
    </template>
    <div class="row">
      <span class="label">Name(Dao)</span>
      <el-input class="dlginput" v-model="daoname" disabled></el-input>
    </div>
    <div class="row">
      <span class="label">Symbol</span>
      <el-input class="dlginput" v-model="daosymbol" disabled></el-input>
    </div>
    <div class="row">
      <span class="label">Email</span>
      <el-input class="dlginput" v-model="setinfo.email"></el-input>
    </div>
    <div class="row">
      <span class="label">Avater</span>
      <el-input class="dlginput" v-model="setinfo.avatar"  placeholder="Image URL, starts with https:// or ipfs://"></el-input>
    </div>
    <div class="row">
      <span class="label">Description</span>
      <el-input class="dlginput" v-model="setinfo.description" :rows="2" type="textarea"></el-input>
    </div>
    <div class="row">
      <span class="label">Discord</span>
      <el-input class="dlginput" v-model="setinfo.comdiscord"></el-input>
    </div>
    <div class="row">
      <span class="label">Github</span>
      <el-input class="dlginput" v-model="setinfo.comgithub"></el-input>
    </div>
    <div class="row">
      <span class="label">Reddit</span>
      <el-input class="dlginput" v-model="setinfo.comreddit"></el-input>
    </div>
    <div class="row">
      <span class="label">Twitter</span>
      <el-input class="dlginput" v-model="setinfo.comtwitter"></el-input>
    </div>
    <div class="row">
      <span class="label">Telegram</span>
      <el-input class="dlginput" v-model="setinfo.comtelegram"></el-input>
    </div>
    <div class="rowbt">
      <!-- <span class="savebt" @click="savedata()">Save</span>  -->
      <el-button color="#6E3FF5" :loading="btn2_loading" @click="savedata">Submit</el-button>
    </div>
  </el-dialog>
</template>
<script setup>
import {reactive, toRefs, ref} from "vue";
import useWeb3 from "/src/utils/useWeb3";
import abi_bridge from '/src/assets/abi/soulBoundBridge.json';
import abi_nft from '/src/assets/abi/soulBoundMedal.json';
import {ElLoading, ElNotification} from 'element-plus';

const {account, web3, ContractCall, ContractSend, bridge} = useWeb3();
const dialogeditdao = ref(false);
const contract_address = ref('');

const daoname = ref('');
const daosymbol = ref('');
const setinfo = reactive({
  // 'name': '',
  // 'symbol': '',
  'email': '',
  'avatar': '',
  'description': '',
  'comdiscord': '',
  'comgithub': '',
  'comreddit': '',
  'comtwitter': '',
  'comtelegram': '',
});
let oldsetinfo = {};
const btn2_loading = ref(false);

function fieldsdiffarr() {
  let fieldarr = [];
  let valarr = [];
  Object.keys(toRefs(setinfo)).forEach((k) => {
    if (setinfo[k] !== oldsetinfo[k]) {
      fieldarr.push(web3.eth.abi.encodeFunctionSignature(k));
      valarr.push(setinfo[k]);
    }
  })
  if (!fieldarr || fieldarr.length === 0) {
    return false;
  }
  return [fieldarr, valarr];
}

const read = async (arr, funcname, bridge) => {
  const loading = ElLoading.service({
    lock: true,
    text: 'Loading',
    background: 'rgba(0, 0, 0, 0.7)',
  })
  // console.log(arr);
  return await ContractCall(abi_bridge, bridge, funcname, arr).then((res) => {
    loading.close();
    return res;
  }).catch(() => {
    loading.close();
  })
}

function savedata() {
  btn2_loading.value = true;
  let savearr = fieldsdiffarr();
  if (!savearr) {
    dialogeditdao.value = false;
    return;
  }
  ContractSend(abi_nft, contract_address.value, 'saveStrings', savearr).then((res) => {
    // console.log(res);
    dialogeditdao.value = false;
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

//
const showdialog = async function (address) {
  let arr = [];
  contract_address.value = address;
  Object.keys(toRefs(setinfo)).forEach((k) => {
    arr.push(web3.eth.abi.encodeFunctionSignature(k));
  })
  let values = await read([address, arr], 'getStrings', bridge);
  Object.keys(toRefs(setinfo)).forEach((k, v) => {
    setinfo[k] = values[v];
    oldsetinfo[k] = values[v];
  });
  daoname.value = await ContractCall(abi_nft, address, 'name', []).then((res) => {
    return res;
  });
  daosymbol.value = await ContractCall(abi_nft, address, 'symbol', []).then((res) => {
    return res;
  });
  dialogeditdao.value = true;
}
defineExpose({
  showdialog
})
</script>
<style>
.editdlg {
  border-radius: 0.83rem !important;
  width: 60rem !important;
}

.editdlg .el-dialog__body {
  padding: 0px 0px 1.67rem 0px;
}

.editdlg .el-textarea__inner {
  background: #F5F5F5;
  box-shadow: none;
}

.editdlg .el-dialog__header {
  padding: 2.5rem 1.67rem 1.33rem 11.63rem;
  text-align: left;
  position: relative;
}

.editdlg .row {
  padding: 0px;
  margin: 0px;
}
</style>
<style lang="scss" scoped>
* {
  color: #999999;
  font-size: 0.83rem;
}

.rowbt {
  margin-top: 1.67rem;
  text-align: right;
  width: 47rem;
}

.savebt {
  display: inline-block;
  width: 10.67rem;
  height: 2rem;
  line-height: 2rem;
  background: #EEEEEE;
  border-radius: 0.33rem;
  font-size: 0.67rem;
  //font-family: PingFangSC-Medium, PingFang SC;
  font-weight: 500;
  color: #999999;
  text-align: center;
  cursor: pointer;

}

.headtitle {
  font-size: 1.25rem;
  //font-family: PingFangSC-Regular, PingFang SC;
  font-weight: 400;
  color: #000000;
  display: inline-block;
}

.headclose {
  height: 1rem;
  font-size: 0.71rem;
  //font-family: PingFangSC-Regular, PingFang SC;
  font-weight: 400;
  color: #F53F3F;
  line-height: 1rem;
  float: right;
  cursor: pointer;
  margin-top: -0.83rem;
}

.row {
  margin-bottom: 0.83rem;
}

.row .label {
  width: 10rem;
  height: 2rem;
  display: inline-block;
  //font-family: PingFangSC-Regular, PingFang SC;
  font-weight: 400;
  line-height: 2rem;
  text-align: right;
  margin-right: 0.87rem;
}

.row .dlginput {
  margin-left: 0.8rem;
  width: 35.33rem;
  min-height: 2rem;
  background: #F5F5F5;
  border-radius: 0.33rem;
}

.row .dlginput .el-input__wrapper {
  background: #F5F5F5;
  box-shadow: none !important;
}
</style>
