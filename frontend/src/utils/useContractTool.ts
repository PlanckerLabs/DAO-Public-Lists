import useWeb3 from "@/utils/useWeb3";
import abi_bridge from '@/assets/abi/soulBoundBridge.json';
import abi_dao from '@/assets/abi/soulBoundMedal.json';
import {useStore} from '@/store';
import {config} from "@/config";
import {AbiItem} from "web3-utils";
import bytecode from '@/assets/bytecode/soulBoundMedal.json';

export default function useContractTool() {
    const store = useStore();
    const {ContractCall, ContractSend, getWeb3, deployContract: deployContract_} = useWeb3(store.Account);
    // 解码
    const atob_: (base64: string) => string = (base64: string): string => {
        return decodeURIComponent(escape(window.atob(base64)));
    }
    // 编码
    const encode_ = (param: any) => {
        let web3 = getWeb3()
        if (typeof param === 'string') {
            return web3.eth.abi.encodeFunctionSignature(param)
        } else if (typeof param === 'object') {
            if (Array.isArray(param)) {
                // 数组
                return param.map((e: string) => {
                    return web3.eth.abi.encodeFunctionSignature(e);
                })
            }
        }
    }
    const deployContract = (params: any[]) => {
        return deployContract_(<AbiItem[]>abi_dao, bytecode.code, [...params, config.BridgeAddress])
    }
    // 获取用户信息
    const Bridge_userDetail = (address?: string) => {
        address = address == null ? store.Account : address;
        return ContractCall(<AbiItem[]>abi_bridge, config.BridgeAddress, 'userDetail', [address]).then((res) => {
            let ret = JSON.parse(res);
            ret.dao.forEach((dao: any) => {
                dao.medals.forEach((medal: any) => {
                    medal.name = atob_(medal.name);
                    medal.uri = atob_(medal.uri);
                })
            })
            return ret;
        }).catch((err) => {
            throw Error(err);
        })
    }
    // 获取Dao的勋章列表
    const Bridge_listDAOMedals = (address: string) => {
        return ContractCall(<AbiItem[]>abi_bridge, config.BridgeAddress, 'listDAOMedals', [address, 0, 999]).then((res) => {
            let ret = JSON.parse(res);
            // NFT name 解码
            ret.name = atob_(ret.name);
            ret.medals.forEach((medal: any) => {
                medal.name = atob_(medal.name);
                medal.uri = atob_(medal.uri);
            })
            // console.log(ret);
            return ret;
        }).catch((err) => {
            throw Error(err);
        })
    }
    // 获取address的单个字段值
    const Bridge_getString = (address: string, attr: string) => {
        return ContractCall(<AbiItem[]>abi_bridge, config.BridgeAddress, 'getString', [address, encode_(attr)]).then((res) => {
            return res;
        }).catch((err) => {
            throw Error(err);
        })
    }

    /*
    * method 获取address的多个字段值
    * address 地址
    * params 查询字段数组
    */
    const Bridge_getStrings = (address: string, params: string[]) => {
        // console.log(address,params)
        return ContractCall(<AbiItem[]>abi_bridge, config.BridgeAddress, 'getStrings', [address, encode_(params)]).then((res: string[]) => {
            // console.log(res);
            let obj: {
                [propName: string]: string;
            } = {};
            params.forEach((k, v) => {
                obj[k] = res[v]
            })
            return obj;
        }).catch((err) => {
            throw Error(err);
        })
    }
    // 获取Dao name字段值
    const Dao_Name = (address: string) => {
        return ContractCall(<AbiItem[]>abi_dao, address, 'name', []).then((res) => {
            return res;
        }).catch((err) => {
            throw Error(err);
        });
    }
    // 获取Dao symbol字段值
    const Dao_Symbol = (address: string) => {
        return ContractCall(<AbiItem[]>abi_dao, address, 'symbol', []).then((res) => {
            return res;
        }).catch((err) => {
            throw Error(err);
        })
    }
    // 保存Dao的多个字段
    const Dao_saveStrings = (address: string, keys: string[], values: string[]) => {
        return ContractSend(<AbiItem[]>abi_dao, address, 'saveStrings', [encode_(keys), values]).then((res) => {
            return res
        }).catch((err) => {
            throw Error(err);
        })
    }
    // 保存用户的多个字段
    const Bridge_saveStrings = (keys: string[], values: string[]) => {
        return ContractSend(<AbiItem[]>abi_bridge, config.BridgeAddress, 'saveStrings', [encode_(keys), values]).then((res) => {
            return res
        }).catch((err) => {
            throw Error(err);
        })
    }
    // Dao组织创建勋章
    const Dao_addMedals = (address: string, params: string[]) => {
        return ContractSend(<AbiItem[]>abi_dao, address, 'addMedals', params).then((res) => {
            return res
        }).catch((err) => {
            throw Error(err);
        })
    }
    //获取一个DAO中全部勋章的请求、拒绝、通过列表【无法做到分勋章，只能查询全部，然后前端可以按照勋章分页】
    // address dao地址
    const Bridge_getCliamRequest = (address: string) => {
        return ContractCall(<AbiItem[]>abi_bridge, config.BridgeAddress, 'getCliamRequest', [address, 0, 999]).then((res) => {
            return JSON.parse(res);
        }).catch((err) => {
            throw Error(err);
        })
    }
    // 勋章同意
    const Dao_cliamApproved = (address: string, nftIndex: number) => {
        return ContractSend(<AbiItem[]>abi_dao, address, 'cliamApproved', [nftIndex]);
    }
    // 勋章拒绝
    const Dao_cliamRejected = (address: string, nftIndex: number) => {
        return ContractSend(<AbiItem[]>abi_dao, address, 'cliamRejected', [nftIndex]);
    }
    // 合约注册
    const Bridge_register = (address: string) => {
        return ContractSend(<AbiItem[]>abi_bridge, config.BridgeAddress, 'register', [address]);
    }
    // 列出所有Dao
    const Bridge_listDAO = () => {
        return ContractCall(<AbiItem[]>abi_bridge, config.BridgeAddress, 'listDAO', [0, 999, 0, 999]).then((res) => {
            return JSON.parse(res);
        }).catch((err) => {
            throw Error(err);
        })
    }
    // 请求一个Dao的勋章
    const Dao_cliamRequest = (address: string, nftIndex: number) => {
        return ContractSend(<AbiItem[]>abi_dao, address, 'cliamRequest', [nftIndex])
    }
    return {
        deployContract,
        Bridge_userDetail,
        Bridge_listDAOMedals,
        Bridge_getString,
        Bridge_getStrings,
        Bridge_getCliamRequest,
        Dao_Name,
        Dao_Symbol,
        Dao_saveStrings,
        Bridge_saveStrings,
        Dao_addMedals,
        Dao_cliamApproved,
        Dao_cliamRejected,
        Bridge_register,
        Bridge_listDAO,
        Dao_cliamRequest
    }
}
