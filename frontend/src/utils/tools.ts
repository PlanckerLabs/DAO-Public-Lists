/*
 * @Description: 
 * @Version: 1.0
 * @Autor: z.cejay@gmail.com
 * @Date: 2022-05-28 21:49:53
 * @LastEditors: cejay
 * @LastEditTime: 2022-05-30 10:11:45
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
    static blockChainBaseUrl = 'https://mumbai.polygonscan.com';
    public static blockchainScanUrl_address(address: string): string {
        return `${Tools.blockChainBaseUrl}/address/${address}`;
    }
    public static blockchainScanUrl_tokenId(contract: string, tokenid: string): string {
        return `${Tools.blockChainBaseUrl}/token/${contract}?a=${tokenid}`;
    }
}

export default Tools;
