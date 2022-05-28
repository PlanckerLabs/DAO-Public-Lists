/*
 * @Description: 
 * @Version: 1.0
 * @Autor: z.cejay@gmail.com
 * @Date: 2022-05-29 03:01:29
 * @LastEditors: cejay
 * @LastEditTime: 2022-05-29 03:48:18
 */
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
const path = require("path");
// https://vitejs.dev/config/
export default defineConfig({
  base: './',
  plugins: [vue()],
  resolve: {
    // 配置路径别名
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
})
