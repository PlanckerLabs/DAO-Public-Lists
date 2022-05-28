// @ts-ignore
import Web3 from 'web3/dist/web3.min.js'; //vite会优化掉部分文件 直接引入min.js
import {AbiItem} from "web3-utils";
import detectEthereumProvider from "@metamask/detect-provider";

let eth: any = null;
let provider: any;
try {
    // @ts-ignore
    eth = ethereum;
} catch (e) {
    eth = {};
}

//DEMO:0xc413bffB3e567cFd871F6B7fB13F5EbbA9bDBc18
//DEV:0x4E3ba0edcE8df1b20eE19FfF11fC32447933bf4c
export default function useWeb3(account?: string) {
    const init = async () => {
        provider = await detectEthereumProvider();
    }
    // 获取账号地址
    const getAccount = async () => {
        try {
            return await eth.request({method: 'eth_requestAccounts'}).then((accounts: string[]) => {
                if (accounts.length > 0) {
                    // console.log("accounts", accounts[0]);
                    return accounts[0];
                }
            })
        } catch (e) {
            throw new Error('err');
        }
    };
    // 连接网络
    const connectNetwork = async (options: ChainOption) => {
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
        let web3: Web3 = await getWeb3();
        let contract = new web3.eth.Contract(jsonInterface, contractAddress, {from: account});
        return await contract.methods[method](...params).call();
    }
    // 调用合约方法send
    const ContractSend = async (jsonInterface: AbiItem[], contractAddress: string, method: string, params: any[]) => {
        let web3: Web3 = await getWeb3();
        let contract = new web3.eth.Contract(jsonInterface, contractAddress, {from: account});
        return await contract.methods[method](...params).send();
    }
    // 部署合约
    const deployContract = async (jsonInterface: AbiItem[], bytecode: string, args: [string, string, [], [], string]) => {
        let web3: Web3 = await getWeb3();
        let contract = new web3.eth.Contract(jsonInterface);
        return await contract.deploy({
            arguments: args,
            data: bytecode
        }).send({
            from: account
        });
    }
    // 获取web3对象
    const getWeb3 = () => {
        let instance: Web3;
        if (instance === undefined) {
            instance = new Web3(provider);
        }
        return instance;
    }
    return {
        init,
        getAccount,
        connectNetwork,
        ContractCall,
        deployContract,
        ContractSend,
        getWeb3
    }
}
