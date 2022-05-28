<template>
  <div class="bg">
    <div class="flex box justify-center">
      <div class="flex flex-column align-center">
        <el-image :src="nodao"></el-image>
        <div class="des">No Dao</div>
      </div>
    </div>
  </div>
</template>

<script setup>

import nodao from '/src/assets/img/dapp_nodao_img.png';
</script>

<style lang="scss" scoped>
.bg {
  height: 45rem;
  background: #F5F5F5;
}

.box {
  padding-top: 6.71rem;

  .des {
    margin-top: 0.42rem;
    height: 0.92rem;
    font-size: 0.67rem;

    font-weight: 500;
    color: #000000;
    line-height: 0.92rem;
  }
}
</style>
