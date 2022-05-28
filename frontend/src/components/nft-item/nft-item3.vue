<template>
  <div class="nft">
    <el-image class="image" :src="info.image"></el-image>
    <div class="title">{{ info.title }}</div>
    <div class="des">{{ info.des }}</div>
    <div class="divider"></div>
    <div class="flex align-center" style="height: 2.5rem">
      <el-image class="avatar" :src="info.avatar"></el-image>
      <div class="name">{{ info.name }}</div>
    </div>
  </div>
</template>

<script setup>
import {reactive} from 'vue';

const info = reactive({
  image: 'https://muyu-pub.oss-cn-beijing.aliyuncs.com/dao2dao/demo/80f2a5ae1d0a01a3083dea14bf84b01.jpg',
  title: 'Kyle Medal of Honour',
  des: 'holdings：2191223104',
  avatar: 'https://muyu-pub.oss-cn-beijing.aliyuncs.com/dao2dao/demo/d9a0e1c7ba235ce4f3be9d416c3f15c.jpg',
  name: 'Kyle Dao'
});

</script>

<style lang="scss" scoped>
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
