/*
 * @Description: 
 * @Version: 1.0
 * @Autor: z.cejay@gmail.com
 * @Date: 2022-05-28 21:49:53
 * @LastEditors: cejay
 * @LastEditTime: 2022-05-29 02:50:40
 */
import { unref, ref, toRaw } from 'vue';

class Tools {
    public static imgURL(url: any): string {
        if (typeof url !== 'string') {
            return '';
        }
        if (url.toLowerCase().indexOf('ipfs://') === 0) {
            return `https://ipfs.io/ipfs/${url.substring(7)}`;
        }
        return url;

    }
}

export default Tools;
