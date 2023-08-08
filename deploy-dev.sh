near_key_path=~/.near-credentials/testnet/shrm.orderly-dev.testnet.json
aurora_key=$(cat aurora-key.txt)

forge clean && forge build --libraries lib/aurora-sdk/aurora-solidity-sdk/src/Codec.sol:Codec:0x58d4e43a1b8469c3ab1ced4c6d211234c6cc5d5b --libraries lib/aurora-sdk/aurora-solidity-sdk/src/AuroraSdk.sol:AuroraSdk:0x6b42dafcc51dfaed414ed16e5970584227d6de95
code=$(cat out/FtCall.sol/FtCall.json | jq '.bytecode .object' | cut -c 4- | rev | cut -c 2- | rev)
cat out/FtCall.sol/FtCall.json | jq '.abi' > out/FtCall.sol/FtCall.abi
aurora-cli --network testnet --near-key-path $near_key_path deploy --code $code --abi-path out/FtCall.sol/FtCall.abi --args '{"_wNEAR": "bcf48399b098d09d5588cf64778db338f55f6078"}' --aurora-secret-key $aurora_key
# Contract has been deployed to address: 0x6c99c4a93dd61b549f0e124a18b79aade90531d9 successfully
# https://explorer.testnet.aurora.dev/address/0x6c99c4a93dd61b549f0e124a18b79aade90531d9
# https://explorer.testnet.aurora.dev/tx/0xbf7c16806c8146ff9685efea69631653c1f9e0f2f0a3eacd58007d2222031ee6
# https://explorer.testnet.near.org/transactions/2JzzvdnATyrZvGgVi3v5pBRSkQE4xwJkSdHfpGYfoGQk
