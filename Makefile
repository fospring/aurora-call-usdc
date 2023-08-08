.PHONY: all
all: help

# include .envrc file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

.PHONY: build # Build the project
build:
	forge clean && forge build --libraries lib/aurora-sdk/aurora-solidity-sdk/src/Codec.sol:Codec:0x58d4e43a1b8469c3ab1ced4c6d211234c6cc5d5b --libraries lib/aurora-sdk/aurora-solidity-sdk/src/AuroraSdk.sol:AuroraSdk:0x6b42dafcc51dfaed414ed16e5970584227d6de95

.PHONY: test # Run tests
test:
	forge test -vvv

.PHONY: deploy # Deploy contract
deploy_dev:
	#forge create --rpc-url "https://testnet.aurora.dev" --private-key ${PRIVATE_KEY} ./src/FtCall.sol:FtCall --libraries aurora-sdk/AuroraSdk:AuroraSdk:
	forge create --rpc-url "https://testnet.aurora.dev" --private-key ${PRIVATE_KEY} ./src/FtCall.sol:FtCall --libraries lib/aurora-sdk/aurora-solidity-sdk/src/Codec.sol:Codec:0x58d4e43a1b8469c3ab1ced4c6d211234c6cc5d5b --libraries lib/aurora-sdk/aurora-solidity-sdk/src/AuroraSdk.sol:AuroraSdk:0x6b42dafcc51dfaed414ed16e5970584227d6de95
	code=$(cat out/AuroraSdk.sol/AuroraSdk.json | jq '.bytecode .object' | cut -c 4- | rev | cut -c 2- | rev)
	aurora-cli --network testnet --near-key-path ${near_key_path} deploy --code ${code} --aurora-secret-key ${aurora_key}

deploy_aurora_sdk:
	forge create --rpc-url "https://testnet.aurora.dev" --private-key ${PRIVATE_KEY} ./lib/aurora-sdk/aurora-solidity-sdk/src/AuroraSdk.sol:AuroraSdk

call_ft_transfer:
	aurora-cli --network testnet --near-key-path ${near_key_path} --aurora-secret-key ${aurora_key} call --address 0x6c99c4a93dd61b549f0e124a18b79aade90531d9 --function ftTransferCall --abi-path out/FtCall.sol/FtCall.abi --args '{}'