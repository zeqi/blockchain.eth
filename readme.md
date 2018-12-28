# geth部署说明
## 创建genesis.json
```js
{
  "config": {
    "chainId": 15,
    "homesteadBlock": 0,
    "eip155Block": 0,
    "eip158Block": 0
  },
  "coinbase": "0x0000000000000000000000000000000000000000",
  "difficulty": "0x40000",
  "extraData": "",
  "gasLimit": "0xffffffff",
  "nonce": "0x0000000000000042",
  "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "timestamp": "0x00",
  "alloc": {}
}

```

## 初始化区块节点
```sh
geth --datadir data0 init genesis.json
```

## 启动geth客户端节点
```sh
geth --identity "TestNode1" --datadir "data0" --rpc --rpcapi "db,eth,net,web3,admin,personal,miner" --rpcaddr "0.0.0.0" --rpccorsdomain "*" --networkid "3912" --ws --wsaddr "0.0.0.0" --wsorigins "*" console 2>>geth.log
geth --identity "TestNode2" --datadir "data0" --rpc --rpcport 8546 --rpcapi "db,eth,net,web3" --rpcaddr "0.0.0.0" --rpccorsdomain "*"  --port 30304 --networkid "3912" console 2>>geth.log
```
## 创建账户
```js
web3.eth.accounts
web3.personal.newAccount("123123")
web3.personal.newAccount()
web3.eth.accounts
```

## 开始挖矿
```js
miner.start(1)
var acc0 = eth.accounts[0]
eth.getBalance(acc0)
miner.stop()

eth.getBlock("pending", true).transactions
```

## 转账操作
```js
web3.eth.sendTransaction({from:acc0,to:acc1,value:web3.toWei(3,"ether")})
web3.personal.unlockAccount(acc0,"123123")  //解锁账户
eth.sendTransaction({from: "0xd6b84bfdc09e15747841db062d0f6d4baf484df8", to: "0x8647895fc9c8f05dfc37988cfbe3fb25b0c04663", value: web3.toWei(1, "ether")})

```

## 连接geth服务
```sh
geth attach ipc:/home/blockChain/data/00/geth.ipc
993f510120733c89a82ad0a0ee3fe124fcd8417537b0dec307d20387991d44aa
modules:modules: admin:1.0 debug:1.0 eth:1.0 miner:1.0 net:1.0 personal:1.0 rpc:1.0 txpool:1.0 web3:1.0
```

## 主节点添加新节点
```js
admin.nodeInfo.enode
admin.addPeer("enode://a07967565ab6ff052d97477a9e93b80b5fb951751d7d90a77eea44fe0e8b3363bfb6332dd9392433a5020082446aa2deb0e0d3ef90a4002a1647053df875888a@10.140.10.106:30304")

geth --datadir "data0" --rpccorsdomain "http://localhost:3000" --rpc --unlock "0xceb69f5c9a89eb1833f568873db89593495e944e"

geth --datadir "data0" --rpc --ws --wsorigins "http://localhost:3000" --unlock "0xceb69f5c9a89eb1833f568873db89593495e944e"
f2aefbb8eea7a00ac1386802cd65a41933b4d8fdb8cbd8e8ade9a587f85dbaf8
```

## 自动化脚本
```sh
#!/usr/bin/env bash
# Created by zeqi
# @description
# @module
# @version 1.0.0
# @author Xijun Zhu <zhuzeqi2010@163.com>
# @File ${NAME}
# @Date 17-5-31
# @Wechat zhuzeqi2010
# @QQ 304566647
# @Office-email zhuxj4@lenovo.cn

echo "===== Starting geth node =====";
set -x;
pushd `dirname $0` > /dev/null
base_dir=$(pwd -P);
echo "base_dir:                 $base_dir"
GETH_HOME="./"
DATADIR="data"
GENESIS="genesis.json"
VERBOSITY=3
BOOTNODE_URLS=""
MAX_PEERS=25
NETWORK_ID="3912"
IDENTITY="TestNode"
PORT=30303
RPCADDR="0.0.0.0"
RPCPORT="8545"
RPCCROSDOMAIN="*"
RPCAPI="db,eth,net,web3,admin,personal,miner"
WSADDR="0.0.0.0"
WSPORT="8546"
WSORIGINS="*"
WSAPI="db,eth,net,web3,admin,personal,miner"
MINE_OPTIONS="--minerthreads 1"
FAST_SYNC="--syncmode fast"
GETH_LOG_FILE_PATH="geth.log"
if [ ! -d "$GETH_HOME" ]; then
    echo "Create geth home dir:         $GETH_HOME"
    mkdir -p "$GETH_HOME"
fi
if [ ! -f "$GENESIS" ]; then
    echo "Generate config file(genesis.json)"
    echo '{
  "config": {
    "chainId": 15,
    "homesteadBlock": 0,
    "eip155Block": 0,
    "eip158Block": 0
  },
  "coinbase": "0x0000000000000000000000000000000000000000",
  "difficulty": "0x40000",
  "extraData": "",
  "gasLimit": "0xffffffff",
  "nonce": "0x0000000000000042",
  "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "timestamp": "0x00",
  "alloc": {
    "0x0000000000000000000000000000000000000001": {"balance": "111111111"},
    "0x0000000000000000000000000000000000000002": {"balance": "222222222"}
  }
}' >> $GENESIS
fi
cd $GETH_HOME
if [ ! -d "$DATADIR" ]; then
    echo "Init geth"
    geth --datadir $DATADIR init $GENESIS
fi
nohup geth --identity $IDENTITY --datadir $DATADIR --verbosity $VERBOSITY --maxpeers $MAX_PEERS --nat any --networkid $NETWORK_ID --port $PORT $MINE_OPTIONS $FAST_SYNC --rpc --rpcaddr $RPCADDR --rpcport $RPCPORT --rpccorsdomain "$RPCCROSDOMAIN" --rpcapi $RPCAPI --ws --wsaddr $WSADDR --wsport $WSPORT --wsorigins "$WSORIGINS" --wsapi $WSAPI >> $GETH_LOG_FILE_PATH 2>&1 &
if [ $? -ne 0 ]; then echo "Previous command failed. Exiting"; exit $?; fi
set +x;
echo "===== Started geth node =====";
```

## ganache
```sh
Available Accounts
==================
(0) 0x71f3d2be9c76a085b11374213ad6bb46345e9be6
(1) 0xe308d5bdfb1e150e97303e1912a484c54f8cf8c8
(2) 0x9d52b5becc34655141120dc43d3cdec4b0ac4e81
(3) 0x5e18038b5d1cb29d75eb33bf7c010847f4da12b8
(4) 0xc28eea07f4a978a143ad750a8c4400eac520537b
(5) 0x13617ec12320770f3aa8f143c32a1aac4f213dfc
(6) 0x6bf97e0ef1e5fefb4f745ecb60019a317acbb51b
(7) 0xdf77bb00b98aeda3fe96ff93680764abeb19ef7a
(8) 0xe6e2b5fafa39073a06294a0c61f5b5611a8dad20
(9) 0x86e493d263b0e2cf1dc53dee97fd1ff00cb653c4

Private Keys
==================
(0) dd0b6aa3bc38a971860518b0cffe9a72d09e42ef208a2fbbceb9f32724c69bc9
(1) ecf9ea5580edaf4d2a878aac91f9c21f6ad2f54298624fbe04931a512cd791bf
(2) 346a8ad0f0af9cacb1aa0ff74d40e97a8ebe2e0463832a244fdc71a4fede8b94
(3) 45596b513c029d31a80fef5caa37c509a9dc9309d8d3dbb1e12aec2e2326eee3
(4) 97c61ddd48c0fa4572752f7b5d3348f43d7d3158b94daab8ecfee33ef67af96e
(5) 2b33f8de73d10f610ad333590c99f4518071b2e9f38437a28c408d8b7ecf4168
(6) e84221716556b937222f0b18b6805dd2d0f96c82eab18851f68715c08a337186
(7) 70afac1ee4c59d3dac495c052dfa3c01981c0b75f8d6279a645edfac4dda9bbb
(8) d5fdf61162b596e4d63428f895fdb69578990ffca0706895cd57538620cc8a75
(9) 197ef5653f6162d0443e571716428ea16941a056a9b3b03f8e2ee3da1301c132

```

## 本地测试信息
```sh
personal.unlockAccount('0xd621e84Bdd3A41599C435693607988d6099763df', '123123', 1000*60*60*24)

{ address: '0xd621e84Bdd3A41599C435693607988d6099763df',
  privateKey: '0xb468b702ebbc691485898e5033e809ce200aa4563eb0aadbf063f283b18d1709',
  signTransaction: [Function: signTransaction],
  sign: [Function: sign],
  encrypt: [Function: encrypt] }
[ '0x9383587389D4b03669f1DC04A1A6d43C251724aA',
  '0x151bbeA9511331e00c7b1EBEa02eB1ADa413ebD3' ]



3d52a8874b310d1d689b18fe22f2ecd9ebf871633309b543f1b2d8018bfba182
0af589f9eec4b7683f45ddbb4787f8a0875b5919dfa6e6103fbc6f69308154be

spoil sample cousin actress tiny impact universe jungle egg manage save army
ac0f1ee9a474a2faecea4b34d949bcaa139e7677c75954cf7e1c13b77d208f31

0x69372D5be63c5a0846c463e543498980a4b80dbc

Using network 'development'.

Running migration: 1_initial_migration.js
  Replacing Migrations...
  ... 0x792eb4e575ff66cd965bdfe6ae0551c3af9fd0f8ae0924f8d849477a80f43759
  Migrations: 0x886947913bb131edbcb122c869933bf4b3bdbc32
Saving successful migration to network...
  ... 0x51e4592c51686259fab24d0519170814cb860738aff7fd1c7993f6c923847d1f
Saving artifacts...
Running migration: 2_deploy_contracts.js
  Replacing Adoption...
  ... 0x628abffbfd1b3e8e0054177df8f0d7aaa1d39640797d5ae0f081e088f7b1bd0b
  Adoption: 0x9a6296872edb52a6aab42a8b92f6c27bc954896b
Saving artifacts...
Running migration: 3_deploy_contracts.js
  Deploying TokenERC20...
  ... 0x75d3b7dc4bdbf2c70c073fe7a1e28f7772dd35d7a3a2dad12e2362ae45726a65
  TokenERC20: 0xf44bac41be83e34e6af9f1b803f313c9dd60adb2
Saving artifacts...
```

## 测试环境智能合约
```sh
Ropsten test metamask: 0xe0062d0a4a5b6c4ce64b04ec1ddc01d4d8aebd7f
0x137c52f142e1086728efcc5231449843c2eb26ab
0x6602b74a9b84bddad42381d75d3708084ae29ed0
```