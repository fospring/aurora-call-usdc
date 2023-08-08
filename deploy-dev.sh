near_key_path=~/.near-credentials/testnet/shrm.orderly-dev.testnet.json
aurora_key=$(cat aurora-key.txt)

forge clean && forge build --libraries lib/aurora-sdk/aurora-solidity-sdk/src/Codec.sol:Codec:0x58d4e43a1b8469c3ab1ced4c6d211234c6cc5d5b --libraries lib/aurora-sdk/aurora-solidity-sdk/src/AuroraSdk.sol:AuroraSdk:0x6b42dafcc51dfaed414ed16e5970584227d6de95
code=$(cat out/FtCall.sol/FtCall.json | jq '.bytecode .object' | cut -c 4- | rev | cut -c 2- | rev)
cat out/FtCall.sol/FtCall.json | jq '.abi' > out/FtCall.sol/FtCall.abi
aurora-cli --network testnet --near-key-path $near_key_path deploy --code $code --abi-path out/FtCall.sol/FtCall.abi --args '{"_wNEAR": "01B2EDff9b095DC270beca46E2eFB41a3ecEE169"}' --aurora-secret-key $aurora_key
# Contract has been deployed to address: 0xdddd6d77fddd65a5344bfa1f670bbbb770d3d908 successfully
# https://explorer.testnet.aurora.dev/address/0xDdDd6D77fDdD65A5344bFa1F670BbBB770d3d908