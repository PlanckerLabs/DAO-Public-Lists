// replace nft
<template>
  <el-dialog v-model="dialogaddnft"
             custom-class="addnftdlg" width="60rem;"
             :show-close="false"
             :close-on-click-modal="false"
             destroy-on-close>
    <template #header="{ close  }">
      <div class="dlgheadbox">
        <span class="headtitle">Add NFT</span>
        <span class="headclose" @click="close">close</span>
      </div>
    </template>
    <div class="row">
      <span class="label">NFT Name</span>
      <el-input class="dlginput" v-model="nftinfo.name" placeholder="No more than 50 characters"
                maxlength="50"></el-input>
    </div>
    <div class="row">
      <span class="label">NFT Image URL</span>
      <el-input class="dlginput" v-model="nftinfo.uri" placeholder="Image URL, starts with https:// or ipfs://"></el-input>
      <span class="addnftbt" @click="addnewnft()">+ Add</span>
    </div>
    <div class="nftrow">
      <div class="nftbox" v-for="(item, index) in nftinfolist">
        <el-image class="nftimg" :src="Tools.imgURL(item.uri)" fit="cover"/>
        <div class="nfttext">{{ item.name }}</div>
        <span class="nftremove" @click="removenft(index)">
            <el-image class="nftremoveimg" :src="removeimg" fit="fill"/>
        Delete</span>
      </div>

    </div>
    <div class="rowbt">
      <!--            <span class="savebt" @click="savedata()">Save</span>-->
      <el-button color="#6E3FF5" :disabled="btnDisable" :loading="loading" @click="createNFT">Submit</el-button>
    </div>
  </el-dialog>
</template>
<script setup>
import {reactive, ref, watch} from "vue"; 
import useContractTool from '@/utils/useContractTool';
import Tools from '/src/utils/tools';
let removeimg = 'https://muyu-pub.oss-cn-beijing.aliyuncs.com/dao2dao/addnft_delete.png'; 
const {Dao_addMedals} = useContractTool();
const nftinfo = reactive({
  'name': '',
  'uri': ''
});
const dialogaddnft = ref(false);
const loading = ref(false);
const btnDisable = ref(true);
const contract_address = ref(''); // Dao合约地址
// nftinfolist.value = [];
const nftinfolist = reactive([]);

watch(nftinfolist, (newV, oV) => {
  newV.length > 0 ? btnDisable.value = false : btnDisable.value = true;
})


function addnewnft() {
  nftinfolist.push({
    'name': nftinfo.name,
    'uri': nftinfo.uri
  });
}

function removenft(index) {
  nftinfolist.splice(index, 1);
}

function createNFT() {
  // dialogaddnft.value = false;
  loading.value = true;
  let name_arr = [];
  let uri_arr = [];
  nftinfolist.forEach((v) => {
    name_arr.push(v.name)
    uri_arr.push(v.uri)
  })
  // console.log(name_arr, uri_arr);
  Dao_addMedals( contract_address.value, [name_arr, uri_arr]).then((res) => {
    console.log(res);
    loading.value = false;
    dialogaddnft.value = false;
  })

}

const showdialog = function (address) {
  contract_address.value = address;
  dialogaddnft.value = true;
}
defineExpose({
  showdialog
})
</script>
<style>
.addnftdlg {
  border-radius: 0.83rem !important;
  width: 60rem !important;
}

.addnftdlg .el-dialog__body {
  padding: 0px 0px 1.67rem 0px;
}

.addnftdlg .el-dialog__header {
  padding: 2.5rem 1.67rem 1.33rem 11.63rem;
  text-align: left;
  position: relative;
}

.addnftdlg .el-input__wrapper {
  padding-left: 1.33rem;
}

.addnftdlg .el-input__wrapper .el-input__inner {
  /* font-weight: 600; */
  color: #000000;
}

.addnftdlg .row {
  padding: 0px;
  margin: 0px;
}
</style>
<style lang="scss" scoped>
.nftremove
{
    width: 3.69rem;
    height: 1.67rem;
    background: #F53F3F;
    box-shadow: 0rem 0.08rem 0.17rem 0rem rgba(0, 0, 0, 0.4);
    border-radius: 0.33rem;
    position: absolute;
    right:0.32rem;
    bottom: 1.9rem;
    color:white;
    cursor: pointer;
}
.nftremoveimg
{
    width: 1.1rem;
    height: 1.1rem;
    margin: 0.25rem -0.2rem 0.4rem 0.32rem;
    vertical-align: middle;
}
.nftremoveimg img
{
    vertical-align:middle;
}
.nftrow {
  margin: 1.67rem 0 2.3rem 11.63rem;
}

.nftbox {
  width: 10.67rem;
  margin-right: 1.67rem;
  margin-bottom: 1rem;
  display: inline-block;
  position:relative;
}

.nftimg {
  width: 10.67rem;
  height: 10.67rem;
}

.nfttext {
  margin-top: 0.42rem;
  text-align: center;
  height: 0.92rem;
  font-size: 0.67rem;
  
  font-weight: 500;
  color: #000000;
  line-height: 0.92rem;
}

.addnftbt {
  display: inline-block;
  height: 1.67rem;
  padding: 0 0.67rem;
  line-height: 1.67rem;
  background: #6E3FF5;
  border-radius: 0.33rem;
  margin-top: 0.16rem;
  margin-left: 1.63rem;
  font-size: 0.67rem;
  
  font-weight: 500;
  color: #FFFFFF;
  cursor: pointer;
}

.rowbt {
  margin-top: 1.67rem;
  margin-bottom: 1.67rem;
  text-align: right;
  width: 47rem;
}

.savebt {
  display: inline-block;
  width: 10.67rem;
  height: 2rem;
  line-height: 2rem;
  background: #6E3FF5;
  border-radius: 0.33rem;
  font-size: 0.67rem;
  
  font-weight: 500;
  color: #FFFFFF;
  text-align: center;
  cursor: pointer;

}

.headtitle {
  font-size: 1.25rem;
  
  font-weight: 400;
  color: #000000;
  display: inline-block;
}

.headclose {
  height: 1rem;
  font-size: 0.71rem;
  
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
