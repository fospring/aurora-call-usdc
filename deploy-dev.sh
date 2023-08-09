near_key_path=~/.near-credentials/testnet/shrm.orderly-dev.testnet.json
aurora_key=$(cat aurora-key.txt)

forge clean && forge build --libraries lib/aurora-sdk/aurora-solidity-sdk/src/Codec.sol:Codec:0x58d4e43a1b8469c3ab1ced4c6d211234c6cc5d5b --libraries lib/aurora-sdk/aurora-solidity-sdk/src/AuroraSdk.sol:AuroraSdk:0x6b42dafcc51dfaed414ed16e5970584227d6de95
code=$(cat out/FtCall.sol/FtCall.json | jq '.bytecode .object' | cut -c 4- | rev | cut -c 2- | rev)
cat out/FtCall.sol/FtCall.json | jq '.abi' > out/FtCall.sol/FtCall.abi
aurora-cli --network testnet --near-key-path $near_key_path deploy --code $code --abi-path out/FtCall.sol/FtCall.abi --args '{"_wNEAR": "0x8394a2200eb33cf65818d5ab1036938352f58ea7"}' --aurora-secret-key $aurora_key
# Contract has been deployed to address: 0xcb07c55ee1462c0d4918a6837412e78ac470ca8e successfully
# https://explorer.testnet.aurora.dev/address/0xcb07c55ee1462c0d4918a6837412e78ac470ca8e
# https://explorer.testnet.aurora.dev/tx/0x92e3219fee06dc3e0269d12921423195a12dae5470697ae816a17a645ad45df2
# https://explorer.testnet.near.org/transactions/7EU3ZZhWNsyjNiq4sh7hVtANzQDJ5bKB3GnY4AUduh9s
