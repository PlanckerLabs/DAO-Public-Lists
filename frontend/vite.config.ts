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
