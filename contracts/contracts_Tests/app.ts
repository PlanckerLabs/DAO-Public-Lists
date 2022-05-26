/*
 * @Description: 
 * @Version: 1.0
 * @Autor: z.cejay@gmail.com
 * @Date: 2022-05-25 21:51:39
 * @LastEditors: cejay
 * @LastEditTime: 2022-05-25 23:47:02
 */

import { Web3Helper } from './utils/web3';
import fs from 'fs-extra';
import path from 'path';
import assert from 'assert';
const solc = require('solc');
const web3 = Web3Helper.getWeb3();

async function compileContract(solPath: string, contractClassName: string) {
    const input = {
        language: 'Solidity',
        sources: {
            'contract.sol': {
                content: fs.readFileSync(solPath, 'utf8')
            }
        },
        settings: {
            outputSelection: {
                '*': {
                    '*': ['*']
                }
            }
        }
    };
    // solc.compile use v0.8.14+commit.80d49f37
    //await solc.loadRemoteVersion('v0.8.14+commit.80d49f37');

    const output = JSON.parse(solc.compile(JSON.stringify(input)));
    const abi = output.contracts['contract.sol'][contractClassName].abi;
    const bytecode = output.contracts['contract.sol'][contractClassName].evm.bytecode.object;

    return {
        abi, bytecode
    }
}

function deployContract(solPath: string, contractClassName: string, args: any[] | undefined, account: string) {
    return new Promise(async (resolve, reject) => {
        // 编译并部署 contract.sol 文件  
        const { abi, bytecode } = await compileContract(solPath, contractClassName);
        // deploy contract
        const contract = new web3.eth.Contract(abi);
        contract.deploy({
            data: bytecode,
            arguments: args
        }).send({
            from: account,
            gas: 100000000
        }).on('error', (err) => {
            console.log(err);
            reject(err);
        }).then((instance) => {
            console.log(instance.options.address);
            resolve({
                address: instance.options.address,
                abi
            });
        }).catch((err) => {
            console.log(err);
            reject(err);
        });
    });

}

async function Main() {
    const _accounts = await web3.eth.personal.getAccounts();
    let accounts: string[] = [];
    for (let index = 0; index < 4; index++) {
        accounts.push(_accounts[index]);
    }
    const soulBoundBridge = (await deployContract(
        path.resolve(__dirname, '../build/soulBoundBridge.sol'),
        'SoulBoundBridge',
        undefined,
        accounts[0])) as any;
    const soulBoundBridge_address = soulBoundBridge.address;
    const soulBoundBridge_abi = soulBoundBridge.abi;
    const soulBoundBridge_contract = new web3.eth.Contract(soulBoundBridge_abi, soulBoundBridge_address);
    console.log(`soulBoundBridge 部署到：${soulBoundBridge_address}`);

    let soulBoundMedal_abi: any = null;
    let soulBoundMedal_address: string[] = [];
    let soulBoundMedal_contract: any[] = [];
    for (let i = 1; i < accounts.length; i++) {
        const soulBoundMedal = (await deployContract(
            path.resolve(__dirname, '../build/soulBoundMedal.sol'),
            'SoulBoundMedal',
            [
                /*
                   string memory _name, // NFT Collection Name
        string memory _symbol, // NFT Collection Symbol
        string[] memory _medalname, // Medal Name Arrary , length must be equal to _medaluri
        string[] memory _medaluri, // Medal Image Url Arrary , length must be equal to _medalname
        address _daoBridgeAddress // DAO Bridge Address, used to get cliam status
                */
                'soulBoundMedal_' + i,
                'SBM_' + i,
                ['name_' + i + '_1', 'name_' + i + '_2', 'name_' + i + '_3', 'name_' + i + '_4', 'name_' + i + '_5'],
                ['https://' + i + '?1', 'https://' + i + '?2', 'https://' + i + '?3', 'https://' + i + '?4', 'https://' + i + '?5'],
                soulBoundBridge_address
            ],
            accounts[0])) as any;
        if (i === 1) {
            soulBoundMedal_abi = soulBoundMedal.abi;
        }
        soulBoundMedal_address.push(soulBoundMedal.address);
        soulBoundMedal_contract.push(new web3.eth.Contract(soulBoundMedal_abi, soulBoundMedal.address));
        console.log(`soulBoundMedal[${i}] 部署到：${soulBoundMedal.address}`);
        break;// TODO: 只部署一个
    }


    // region 测试请求勋章功能
    for (let i = 0; i < soulBoundMedal_contract.length; i++) {
        const soulBoundMedal = soulBoundMedal_contract[i];
        for (let j = 0; j < accounts.length; j++) {
            let account = accounts[j];
            for (let k = 0; k < 5; k++) {
                const claimResult = await soulBoundMedal.methods.cliamRequest(k).send({
                    from: account,
                    gas: 100000000
                });
                let countDAO = parseInt(await soulBoundBridge_contract.methods.countDAO().call(), 10);
                assert.equal(i + 1, countDAO);
            }
        }
    }


    // endregion








}






Main();