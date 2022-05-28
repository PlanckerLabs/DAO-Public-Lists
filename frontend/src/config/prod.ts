/*
 * @Description: 
 * @Version: 1.0
 * @Autor: z.cejay@gmail.com
 * @Date: 2022-05-29 00:04:31
 * @LastEditors: cejay
 * @LastEditTime: 2022-05-29 03:24:58
 */
// 线上环境配置
export default {
    BridgeAddress: <string>'0xc413bffB3e567cFd871F6B7fB13F5EbbA9bDBc18',
    Chain: <ChainOption>{
        chainId: '0x' + (80001).toString(16),
        chainName: 'Mumbai',
        rpcUrl: 'https://matic-mumbai.chainstacklabs.com'
    }
}
