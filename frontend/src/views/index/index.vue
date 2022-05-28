<!--
 * @Description: 
 * @Version: 1.0
 * @Autor: z.cejay@gmail.com
 * @Date: 2022-05-28 21:06:56
 * @LastEditors: cejay
 * @LastEditTime: 2022-05-28 22:17:24
-->
<template>
  <div class="bg">
    <Header />
    <div class="flex justify-center" style="margin-top: 88px;">
      <div class="flex flex-column align-center">
        <div style="width: 100%">
          <div class="tip">
            Welcome to the dao 2 dao
            interstellar family
          </div>
        </div>
        <div class="mt-4 mb-4">
          <video playsinline="" controls src="https://cdn.modao.cc/Default_video.mp4">
            <source src="https://cdn.modao.cc/Default_video.mp4">
            Video element is not supported in this browser.
          </video>
        </div>
      </div>
    </div>
  </div>
  <!-- Third-party License -->
  <a target="_blank" style="color: #cdcdcd; float: right; font-size: 0.8rem; padding: 1rem;" href="https://github.com/PlanckerLabs/DAO-Square/blob/main/Third-party%20License.md">Third&nbsp;party&nbsp;License</a>

</template>

<script setup>
import Header from '../../components/Header.vue';

</script>

<style lang="scss" scoped>
.bg {
  background: url(https://muyu-pub.oss-cn-beijing.aliyuncs.com/dao2dao/home_bg.png) 100% no-repeat;
}

.tip {
  width: 31rem;
  height: 5.92rem;
  font-size: 2.5rem;
  font-family: Helvetica;
  color: #FFFFFF;
  line-height: 3rem;
}

.video {
  width: 60rem;
  height: 33.75rem;
}
</style>
