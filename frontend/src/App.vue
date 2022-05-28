<!--
 * @Description: 
 * @Version: 1.0
 * @Autor: z.cejay@gmail.com
 * @Date: 2022-05-28 21:06:56
 * @LastEditors: cejay
 * @LastEditTime: 2022-05-28 21:09:32
-->
<template>
  <router-view/>
</template>
<script setup lang="ts">
const oldatob = window.atob;
window.atob = function( bt )
{
  return decodeURIComponent(escape(oldatob(bt)));
}
function rem()
{
    let remsize = document.documentElement.clientWidth/80;
    document.documentElement.style.fontSize = (remsize>24?24:remsize) + 'px';
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
body{
  margin: 0;
  padding:0px !important;
}
</style>
