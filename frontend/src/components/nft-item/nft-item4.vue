<template>
<div class="nonftlist" v-if="!mynfts||mynfts.length==0">

    <img :src="nonft" >
    <div class="nonftlisttxt">No NFT</div>
</div>
    <div class="nftbox" v-for="item in mynfts" v-else> 
        <div class="nft">
            <el-image class="image" :src="item.image"></el-image>
            <div class="title">{{ item.title }}</div>
            <div class="des">Holdings:{{ item.approved }}</div>
            <div class="divider"></div>
            <div class="flex align-center" style="height: 2.5rem">
                <el-image class="avatar" :src="item.daoavatar"></el-image>
                <div class="name">{{ item.daoname }}</div>
            </div>
        </div>
    </div>
</template>

<script setup> 
import {reactive, toRefs, ref, onMounted, watch } from "vue";
import useWeb3 from "/src/utils/useWeb3";
import abi from '/src/assets/abi/soulBoundBridge.json';
import {ElLoading} from 'element-plus';
let defaultavater = '/img/dapp_user_tx%402x.png'; 
let nonft = ref('/img/dapp_nonft_img.png');
const {account, web3, ContractCall, bridge} = useWeb3();
const mynfts = ref([]);
const read = async ( methodname, argsarr ) => {  
    return await ContractCall(abi, bridge, methodname, argsarr).then((res) => {
        return res;
    }).catch(() => {
    })
} 
let inidata = async function () {
    const loading = ElLoading.service({
        lock: true,
        text: 'Loading',
        background: 'rgba(0, 0, 0, 0.7)',
    }) 
    try
    { 
        let values = await read( 'userDetail', [account.value] );
        values = JSON.parse( values );
        console.log( values );
        let alldao =  values.dao;
        mynfts.value = [];
        for( let v in alldao )
        {
            let daoaddress = alldao[v].address;
            let daoinfo = await read( 'listDAOMedals', [ daoaddress , 0, 999 ] ); 
            daoinfo = JSON.parse( daoinfo );
            console.log( daoinfo );
            let daoname = atob(daoinfo.name);
            let byteavatar = web3.eth.abi.encodeFunctionSignature('avatar');
            let avatar = await read('getString', [ daoaddress, byteavatar ] );
            if( alldao[v]['medals'] && alldao[v]['medals'].length > 0 )
            { 
                let daomedals = alldao[v].medals;
                for( let dm in daomedals )
                {
                    if( daomedals[ dm ].status > 2 )
                    {
                        mynfts.value.push({
                            image: atob( daomedals[ dm ].uri ),
                            title: atob( daomedals[ dm ].name ),
                            approved: daomedals[ dm ].approved,
                            daoavatar: avatar?avatar:defaultavater,
                            daoname: daoname,
                        })
                    }
                }
            }  
        } 
        loading.close();
    }
    catch(e)
    {
        loading.close();
        console.log(e);
    } 
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

</script>

<style lang="scss" scoped>
.nonftlist
{
    width: 100%;
    min-height: 23.83rem;
    padding-right: 9.75rem;
    text-align: center;
    color:white;
}
.nonftlisttxt
{
    margin-top:1rem;
}
.nftbox
{
    margin-right: 1.67rem;
    margin-bottom: 1.67rem;
}
.nft {
  display: flex;
  flex-direction: column;
  width: 10.67rem;
  height: 16rem;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 0.33rem;
  border: 0.08rem solid rgba(255, 255, 255, 0.2);

  .name {
    margin-left: 0.42rem;
    height: 0.92rem;
    font-size: 0.67rem;
    
    font-weight: 500;
    color: #FFFFFF;
    line-height: 0.92rem;
  }

  .avatar {
    margin-left: 1.08rem;
    width: 1.67rem;
    height: 1.67rem;
    border-radius: 100rem;
  }

  .divider {
    width: 10.67rem;
    height: 0.04rem;
    background: #FFFFFF;
    opacity: 0.2;
  }

  .image {
    width: 10.67rem;
    height: 10.67rem;
    border-radius: 0.33rem;
  }

  .title {
    height: 0.92rem;
    font-size: 0.67rem;
    padding: 0.42rem 0 0 1.08rem;
    
    font-weight: 500;
    color: #FFFFFF;
    line-height: 0.92rem;
  }

  .des {
    font-size: 0.5rem;
    padding: 0.17rem 0 0.58rem 1.08rem;
    
    font-weight: 400;
    color: #FFFFFF;
    line-height: 0.71rem;
    opacity: 0.2;
  }
}
</style>
