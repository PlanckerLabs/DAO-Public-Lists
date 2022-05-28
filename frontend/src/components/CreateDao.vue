// replace nft
<template>
  <el-dialog v-model="showDlg"
             custom-class="editdaodlg" width="60rem;"
             :show-close="false"
             :close-on-click-modal="false"
             destroy-on-close>
    <template #header="{ close  }">
      <div class="dlgheadbox">
        <span class="headtitle">Create Dao</span>
        <span class="headclose" @click="close">close</span>
      </div>
    </template>
    <div class="row">
      <span class="label">DAO Name</span>
      <el-input class="dlginput" v-model="nftdao.name" placeholder="No more than 50 char" maxlength="50"></el-input>
      <div class="tipmsg">Once created， Cannot be modified</div>
    </div>
    <div class="row">
      <span class="label">DAO Symbol</span>
      <el-input class="dlginput" v-model="nftdao.symol" placeholder="Please enter Symol" maxlength="50"></el-input>
      <div class="tipmsg">Once created， Cannot be modified</div>
    </div>
    <div class="rowbt">
      <el-button type="primary" color="#6E3FF5" :loading="loading" @click="createDao" :disabled="btnDisable">Create
      </el-button>
    </div>
  </el-dialog>
</template>
<script setup>
import {reactive, ref, toRefs} from "vue";
import useWeb3 from "/src/utils/useWeb3";
import abi from '/src/assets/abi/soulBoundMedal.json';
import bytecode from '/src/assets/bytecode/soulBoundMedal.json';
import {ElNotification} from 'element-plus';
import {ElMessage, ElMessageBox} from 'element-plus'
import {watch} from 'vue';
import abi_bridge from '/src/assets/abi/soulBoundBridge.json'

const nftdao = reactive({
  'name': '',
  'symol': ''
});
const showDlg = ref(false);
const {deployContract, ContractSend, bridge} = useWeb3();
const loading = ref(false);
const btnDisable = ref(true);

watch(nftdao, (newV, preV) => {
  btnDisable.value = !(nftdao.name !== '' && nftdao.symol !== '');
})
const createDao = () => {
  loading.value = true;
  deployContract(abi, bytecode.code, [
    nftdao.name,
    nftdao.symol,
    [], [],
    bridge,
  ]).then((newContractInstance) => {
    // console.log("部署成功", newContractInstance.options.address) // instance with the new contract address
    loading.value = false;
    showDlg.value = false;
    // console.log("Dao Address", newContractInstance.options.address);
    // 紧接着提示用户是否注册到dao广场
    ElMessageBox.confirm(
        'Whether to register to the Dao Square?',
        'Prompt',
        {
          confirmButtonText: 'Yes',
          cancelButtonText: 'No',
          type: 'info',
        }
    )
        .then(() => {
          ContractSend(abi_bridge, bridge, 'register', [newContractInstance.options.address]).then((res) => {
            // console.log("注册成功",res)
            ElNotification({
              title: 'Success',
              message: 'Register',
              type: 'success',
              duration: 3000
            })
          })
        })
        .catch(() => {
          ElMessage({
            type: 'info',
            message: 'Register Fail',
          })
        })
  }).catch(() => {
    // console.log("err");
    loading.value = false;
    ElNotification({
      title: 'Error',
      message: 'Deploy Error',
      type: 'error',
      duration: 0
    })
  })
}

const showdialog = function () {
  showDlg.value = true;
  Object.keys(toRefs(nftdao)).forEach((k) => {
    nftdao[k] = '';
  })
}
defineExpose({
  showdialog
})
</script>
<style>
.editdaodlg {
  border-radius: 0.83rem !important;
  width: 60rem !important;
}

.editdaodlg .el-dialog__body {
  padding: 0px 0px 1.67rem 0px;
}

.editdaodlg .el-dialog__header {
  padding: 2.5rem 1.67rem 1.33rem 11.63rem;
  text-align: left;
  position: relative;
}

.editdaodlg .el-input__wrapper {
  padding-left: 1.33rem;
  background: #F5F5F5;
  box-shadow: none;
}

.editdaodlg .el-input__wrapper .el-input__inner {
  /* font-weight: 600; */
  color: #000000;
}

.settingdrawer .el-drawer__body {
  padding: 0px;
  overflow: hidden;
}

.editdaodlg .row {
  padding: 0px;
  margin: 0px;
}
</style>
<style lang="scss" scoped>
.tipmsg
{
    font-size: 0.67rem;
    //font-family: PingFangSC-Regular, PingFang SC;
    font-weight: 400;
    color: #F53F3F; 
    margin-left: 11.7rem;
}
.rowbt { 
    margin-top:0.84rem;
  margin-bottom: 7.83rem;
  text-align: right;
  width: 47rem;
}

.el-button {
  width: 10.67rem;
  height: 2rem;
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
  margin-top: -0.83rem;
  cursor: pointer;
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
  height: 2rem;
  background: #F5F5F5;
  border-radius: 0.33rem;
}

.row .dlginput .el-input__wrapper {
  background: #F5F5F5;
}
</style>
