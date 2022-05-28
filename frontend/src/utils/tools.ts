/*
 * @Description: 
 * @Version: 1.0
 * @Autor: z.cejay@gmail.com
 * @Date: 2022-05-28 21:49:53
 * @LastEditors: cejay
 * @LastEditTime: 2022-05-28 21:58:35
 */
import { unref, ref, toRaw } from 'vue';

class Tools {
    public static imgURL(url: any): string {
        if (typeof url !== 'string') {
            return '';
        }
        if (url.toLowerCase().indexOf('ipfs://') === 0) {
            return `https://ipfs.io/ipfs/${url.substr(8)}`;
        }
        return url;

    }
}

export default Tools;