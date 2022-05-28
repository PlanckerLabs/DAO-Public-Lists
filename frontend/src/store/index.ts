import {defineStore} from 'pinia';

export const useStore = defineStore('main', {
    state: () => ({
        count: 1,
    }),
    actions: {
        increaseCount() {
            this.count++;
        },
    }
})
