// replace nft
<template>
    <el-dialog v-model="dialogeditnft" 
    custom-class="editnftdlg" width="60rem;" 
    :show-close="false" 
    :close-on-click-modal="false"  
    destroy-on-close>
        <template #header="{ close  }">
            <div class="dlgheadbox"> 
                <span class="headtitle">Replacement Medal</span>
                <span class="headclose" @click="close">close</span>
            </div>
        </template>
        <div class="row">
            <span class="label">NFT Name</span>
            <el-input class="dlginput" v-model="nftinfo.description"></el-input>
        </div>
        <div class="row">
            <span class="label">NFT Image URL</span>
            <el-input class="dlginput" v-model="nftinfo.link"></el-input>
        </div>
        <div class="rowbt">
            <span class="savebt" @click="savedata()">Submit</span> 
        </div>
    </el-dialog>
</template>
<script setup> 
import {ref} from "vue";
let nftinfo = ref();
let dialogeditnft = ref(false);
let parentcurnft = ref();
let parentcallback = ref();
nftinfo.value = {
    'description': 'Daoxxx',
    'link': 'dxx'
};
function savedata()
{
    dialogeditnft.value = false;
    if( parentcallback.value != null )
    {
        parentcallback.value( nftinfo.value );
    }
}
const showdialog = function(curnft = null, callback = null )
{
    dialogeditnft.value = true;
    parentcurnft.value = curnft;
    parentcallback.value = callback;
}
defineExpose({
   showdialog
})
</script> 
<style>
    .editnftdlg
    {
        border-radius: 0.83rem !important;
        width: 60rem !important;
    } 
    .editnftdlg  .el-dialog__body
    {
        padding:0px 0px 1.67rem 0px;
    }
    .editnftdlg  .el-dialog__header
    {
        padding:2.5rem 1.67rem 1.33rem 11.63rem;
        text-align: left;
        position: relative;
    } 
    .editnftdlg  .el-input__wrapper
    {
        padding-left: 1.33rem;
    } 
    .editnftdlg  .el-input__wrapper .el-input__inner
    {
        /* font-weight: 600; */
        color: #000000;
    } 
    .editnftdlg  .row
    {
        padding:0px;
        margin:0px;
    }
</style>
<style lang="scss" scoped> 
    *
    {
        color:#999999;
        font-size: 0.83rem;
    }
    .rowbt
    {
        margin-top:1.67rem;
        margin-bottom: 7.83rem;
        text-align: right;
        width:47rem;
    }
    .savebt
    {
        display:inline-block;
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
    .headtitle
    { 
        font-size: 1.25rem;
        
        font-weight: 400;
        color: #000000; 
        display:inline-block;
    }
    .headclose{
        height: 1rem;
        font-size: 0.71rem;
        
        font-weight: 400;
        color: #F53F3F;
        line-height: 1rem; 
        float: right;
        cursor: pointer;
        margin-top: -0.83rem;
    } 
    .row
    {
        margin-bottom: 0.83rem;
    }
    .row .label
    {
        width: 10rem;
        height: 2rem; 
        display:inline-block;
        
        font-weight: 400; 
        line-height: 2rem; 
        text-align: right;
        margin-right: 0.87rem; 
    }
    .row .dlginput
    {
        margin-left: 0.8rem;
        width: 35.33rem;
        height: 2rem;
        background: #F5F5F5;
        border-radius: 0.33rem;
    }
    .row .dlginput .el-input__wrapper
    {
        background: #F5F5F5;
    }
</style>
