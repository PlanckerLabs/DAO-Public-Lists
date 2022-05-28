<template>
  <div :style="bg_style">
    <Header/>
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
  <a target="_blank" style="color: #cdcdcd; float: right; font-size: 0.8rem; padding: 1rem;"
     href="https://github.com/PlanckerLabs/DAO-Square/blob/main/Third-party%20License.md">Third&nbsp;party&nbsp;License</a>

</template>

<script setup>
import Header from '@/components/Header.vue';

const bg_style = {
  backgroundImage: 'url(/src/assets/img/home_bg_2x.png)',
  backgroundRepeat: 'no-repeat',
  backgroundSize: '100%'
}
</script>

<style lang="scss" scoped>
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
