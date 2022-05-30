<!--
 * @Description: 
 * @Version: 1.0
 * @Autor: z.cejay@gmail.com
 * @Date: 2022-05-29 21:53:16
 * @LastEditors: cejay
 * @LastEditTime: 2022-05-30 15:27:03
-->
<template>
  <div class="bg">
    <Header />
    <div class="flex justify-center" style="margin-top: 88px;">
      <div class="flex flex-column align-center">
        <div style="width: 100%">
          <div class="tip">
            Thanks for using NFTtool
          </div>
        </div>
        <div class="mt-4 mb-4">
          <iframe id="ytplayer" width="560" height="315" src="https://www.youtube.com/embed/pajE2OuoYZI?autoplay=1&mute=1"
            title="YouTube video player" frameborder="0"
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
            allowfullscreen></iframe>
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

</script>
<script type="text/javascript">
function resizeVideo() {
  // get window width
  let width = window.innerWidth * 0.7;
  let r = 560 / 315;
  let height = width / r;
  let iframe = document.getElementById('ytplayer');
  iframe.style.height = Math.round(height) + 'px';
  iframe.style.width = Math.round(width) + 'px';
}
// on documet ready
document.addEventListener('DOMContentLoaded', () => {
  // resize iframe
  resizeVideo();
});
// on window resize
window.addEventListener('resize', () => {
  resizeVideo();
});


</script>

<style lang="scss" scoped>
.bg {
  background: url("@/assets/img/home_bg.png") 100% no-repeat;
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
