import {createRouter, createWebHashHistory, RouteRecordRaw} from 'vue-router'
import Home from '../views/index/index.vue';
import MyDao from '../views/my_dao/index.vue';
import PersonalCenter from '../views/personal_center/index.vue';

const routes: RouteRecordRaw[] = [
    {
        path: '/',
        name: 'home',
        component: Home,
        children: []
        // meta: {
        //     title: '测试页面'
        // }
    },
    {
        path: '/myDao',
        name: 'myDao',
        component: MyDao
    },
    {
        path: '/personal_center',
        name: 'personal_center',
        component: PersonalCenter
    }
]

const router = createRouter({
    history: createWebHashHistory(),
    routes
})
// 全局后置钩子
// router.afterEach(to => {
//     // 设置title
//     document.title = to.meta.title;
// })
export default router
