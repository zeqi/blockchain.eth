var Web3 = require('web3');
if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    // set the provider you want from Web3.providers
    web3 = new Web3(new Web3.providers.HttpProvider("http://10.140.10.106:8555"));
}
var version = web3.version;
// web3.eth.personal.newAccount('123123123',function(err,acc){
//     web3.eth.getAccounts(function(err,result){
//         console.log(result)
//     })
// })
// var account = web3.eth.accounts.create('123123');
// account.encrypt('123123123')
// console.log(account);
// web3.eth.getBlockNumber().then(console.log.bind(this));
web3.eth.getAccounts().then(console.log.bind(this))
// web3.eth.getMining().then(console.log.bind(this))

// web3.eth.getBalance('0x5e4786d0156e9D5cCb76745b04bb05B6F807fE06', function(err,result) {
//     if (err == null) {
//         console.log('~balance:'+result);
//     }else  {
//         console.log('~error:'+err);
//     }
// });