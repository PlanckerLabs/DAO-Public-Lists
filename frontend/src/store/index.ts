import {defineStore} from 'pinia';
import {config} from '@/config';
import storage from "@/utils/storage";
import useWeb3 from "@/utils/useWeb3";

const {getAccount, connectNetwork} = useWeb3();
export const useStore = defineStore('main', {
    state: () => ({
        account: <string>'',
    }),
    getters: {
        Account() {
            return storage.get('account');
        }
    },
    actions: {
        // 用户登录
        async login() {
            let account = await getAccount();
            storage.set('account', account);
            return connectNetwork(config.Chain)
        },
        // 用户退出登录
        loginOut() {
            storage.remove('account');
        },
    }
})
