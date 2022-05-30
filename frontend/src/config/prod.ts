/*
 * @Description: 
 * @Version: 1.0
 * @Autor: z.cejay@gmail.com
 * @Date: 2022-05-29 00:04:31
 * @LastEditors: cejay
 * @LastEditTime: 2022-05-30 15:35:23
 */
// 线上环境配置
export default {
    BridgeAddress: <string>'0x7257fDd92DD8C97CF556c58275d68EE3607c3Dfa',
    Chain: <ChainOption>{
        chainId: '0x' + (80001).toString(16),
        chainName: 'Mumbai',
        rpcUrl: 'https://matic-mumbai.chainstacklabs.com'
    }
}
