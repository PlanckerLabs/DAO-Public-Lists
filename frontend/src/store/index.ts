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
        Account(state) {
            // // console.log("账号", storage.get('account'));
            // return storage.get('account')
            return state.account !== '' ? state.account : storage.get('account');
        }
    },
    actions: {
        // 用户登录
        async login() {
            this.account = await getAccount();
            // console.log("登录账号", this.account);
            storage.set('account', this.account);
            return connectNetwork(config.Chain)
        },
        // 用户退出登录
        loginOut() {
            storage.remove('account');
        },
    }
})
