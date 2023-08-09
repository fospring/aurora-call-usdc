near_key_path=~/.near-credentials/testnet/shrm.orderly-dev.testnet.json
aurora_key=$(cat aurora-key.txt)

forge clean && forge build --libraries lib/aurora-sdk/aurora-solidity-sdk/src/Codec.sol:Codec:0x58d4e43a1b8469c3ab1ced4c6d211234c6cc5d5b --libraries lib/aurora-sdk/aurora-solidity-sdk/src/AuroraSdk.sol:AuroraSdk:0x6b42dafcc51dfaed414ed16e5970584227d6de95
code=$(cat out/twNEAR.sol/twNEAR.json | jq '.bytecode .object' | cut -c 4- | rev | cut -c 2- | rev)
cat out/twNEAR.sol/twNEAR.json | jq '.abi' > out/twNEAR.sol/twNEAR.abi
aurora-cli --network testnet --near-key-path $near_key_path deploy --code $code --abi-path out/twNEAR.sol/twNEAR.abi --args '{}' --aurora-secret-key $aurora_key
# Contract has been deployed to address: 0x8394a2200eb33cf65818d5ab1036938352f58ea7 successfully