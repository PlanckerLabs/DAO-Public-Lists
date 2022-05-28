import {unref, ref, toRaw} from 'vue';
// import Web3 from 'web3';
// @ts-ignore
import Web3 from 'web3/dist/web3.min.js'; //vite会优化掉部分文件 直接引入min.js
import {AbiItem} from "web3-utils";
import detectEthereumProvider from "@metamask/detect-provider";

let eth: any = null;
try {
    // @ts-ignore
    eth = ethereum;
} catch (e) {
    eth = {};
}
const provider = ref();
const account = ref<string>('');
//DEMO:0xc413bffB3e567cFd871F6B7fB13F5EbbA9bDBc18
//DEV:0x4E3ba0edcE8df1b20eE19FfF11fC32447933bf4c
const bridge: string = '0x4E3ba0edcE8df1b20eE19FfF11fC32447933bf4c';
const web3 = ref();

interface Options {
    chainId: string,
    chainName: string,
    rpcUrl: string
}

export default function useWeb3() {
    // 页面初始化激活钱包
    const mounted = async () => {
        try {
            provider.value = await detectEthereumProvider();
            // let accounts = await eth.request({method: 'eth_requestAccounts'});
            await eth.request({method: 'eth_requestAccounts'}).then((accounts: string[]) => {
                if (accounts.length > 0) {
                    account.value = accounts[0];
                }
            })
        } catch (e) {

        }
    }
    // 连接网络
    const connectNetwork = async (options: Options) => {
        try {
            return await eth.request({
                method: 'wallet_switchEthereumChain',
                params: [{chainId: options.chainId}],
            });
        } catch ({code}) {
            // This error code indicates that the chain has not been added to MetaMask.
            if (code === 4902) {
                try {
                    return await eth.request({
                        method: 'wallet_addEthereumChain',
                        params: [
                            {
                                chainId: options.chainId,
                                chainName: options.chainName,
                                rpcUrls: [options.rpcUrl] /* ... */,
                            },
                        ],
                    });
                } catch (addError) {
                    // handle "add" error
                    throw new Error('err');
                }
            } else {
                throw new Error('err');
            }
            // handle other "switch" errors

        }
    }
    // 调用合约方法call
    const ContractCall = async (jsonInterface: AbiItem[], contractAddress: string, method: string, params: any[]) => {
        let web3 = new Web3(provider.value);
        let contract = new web3.eth.Contract(jsonInterface, contractAddress, {from: account.value});
        return await contract.methods[method](...params).call();
    }
    // 调用合约方法send
    const ContractSend = async (jsonInterface: AbiItem[], contractAddress: string, method: string, params: any[]) => {
        let web3 = new Web3(provider.value);
        let contract = new web3.eth.Contract(jsonInterface, contractAddress, {from: account.value});
        // console.log(contract.methods);
        return await contract.methods[method](...params).send();
    }
    // 部署合约
    const deployContract = async (jsonInterface: AbiItem[], bytecode: string, args: [string, string, [], [], string]) => {
        let web3 = new Web3(provider.value);
        let contract = new web3.eth.Contract(jsonInterface);
        return await contract.deploy({
            arguments: args,
            data: bytecode
        }).send({
            from: account.value
        });
    }
    // 获取web3对象
    const getWeb3 = () => {
        if (web3.value == null) {
            web3.value = new Web3(provider.value);
        }
        return web3.value;
    }
    return {
        mounted,
        connectNetwork,
        ContractCall,
        deployContract,
        ContractSend,
        account,
        bridge,
        web3: getWeb3()
    }
}
