<template>
  <router-view/>
</template>
<script setup lang="ts">
import useWeb3 from "@/utils/useWeb3";
import {onMounted} from "vue";

const {init} = useWeb3();
onMounted(async () => {
  await init();
})

function rem() {
  let remsize = document.documentElement.clientWidth / 80;
  document.documentElement.style.fontSize = (remsize > 24 ? 24 : remsize) + 'px';
}
rem();
</script>
<style lang="scss">
@import "style/free.scss";
@import "style/font.scss";

html {
  margin: 0;
  background-color: #000000;
  font-size: 24px;
  /*overflow: hidden;*/
}

body {
  margin: 0;
  padding: 0px !important;
}
</style>
