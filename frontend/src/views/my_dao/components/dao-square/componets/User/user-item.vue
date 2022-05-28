<template>
  <div style="margin-bottom: 0.42rem;">
    <PersonalInfo class="personal_info"/>
    <div class="flex flex-wrap nfts">
      <NFTItem class="nft_item"/>
      <NFTItem class="nft_item"/>
      <NFTItem class="nft_item"/>
    </div>
  </div>
</template>

<script setup>
import NFTItem from '/src/components/nft-item/index.vue';
import PersonalInfo from '/src/components/personal-info/index.vue';
</script>

<style lang="scss" scoped>
.personal_info {
  padding: 0.83rem 10rem;

}

.nfts {
  background-color: #FFF;
  padding: 1.67rem 0 1.63rem 10rem;
}

.nft_item {
  margin-right: 1.67rem;
}
</style>
