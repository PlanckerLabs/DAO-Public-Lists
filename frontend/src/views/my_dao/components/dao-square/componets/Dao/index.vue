<template>
  <template v-for="(item,index) in list" :key="index">
    <DaoItem :item="item"/>
  </template>
</template>

<script setup>
import DaoItem from "./dao-item.vue";
import {toRef} from "vue";

const props = defineProps({
  list: {
    type: Array, default: []
  }
})
const list = toRef(props, 'list');

</script>

<style scoped>

</style>
