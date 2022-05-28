<template>
  <div class="nonftlist" v-if="!mynfts||mynfts.length==0">

    <img :src="nonft">
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
import {ref} from "vue";
import {ElLoading} from 'element-plus';
import useContractTool from '@/utils/useContractTool';
import {useStore} from "@/store";

const {Bridge_userDetail, Bridge_listDAOMedals, Bridge_getString} = useContractTool();
let defaultavater = '/img/dapp_user_tx%402x.png';
let nonft = ref('/img/dapp_nonft_img.png');
const store = useStore();
const mynfts = ref([]);

let inidata = async function () {
  const loading = ElLoading.service({
    lock: true,
    text: 'Loading',
    background: 'rgba(0, 0, 0, 0.7)',
  })
  try {
    let values = await Bridge_userDetail(store.Account);
    let alldao = values.dao;
    mynfts.value = [];
    for (let v in alldao) {
      let daoaddress = alldao[v].address;
      let daoinfo = await Bridge_listDAOMedals(daoaddress);
      let daoname = daoinfo.name;
      let avatar = await Bridge_getString(daoaddress, 'avatar');
      if (alldao[v]['medals'] && alldao[v]['medals'].length > 0) {
        let daomedals = alldao[v].medals;
        for (let dm in daomedals) {
          if (daomedals[dm].status > 2) {
            mynfts.value.push({
              image: daomedals[dm].uri,
              title: daomedals[dm].name,
              approved: daomedals[dm].approved,
              daoavatar: avatar ? avatar : defaultavater,
              daoname: daoname,
            })
          }
        }
      }
    }
    loading.close();
  } catch (e) {
    loading.close();
    // console.log(e);
  }
}
inidata();
</script>

<style lang="scss" scoped>
.nonftlist {
  width: 100%;
  min-height: 23.83rem;
  padding-right: 9.75rem;
  text-align: center;
  color: white;
}

.nonftlisttxt {
  margin-top: 1rem;
}

.nftbox {
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
