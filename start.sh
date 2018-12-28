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
NETWORK_ID="3913"
IDENTITY="TestNode1"
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
