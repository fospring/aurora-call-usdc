.PHONY: all
all: help

# include .envrc file and export its env vars
# (-include to ignore error if it does not exist)
-include .envrc

.PHONY: build # Build the project
build:
	forge clean && forge build

.PHONY: test # Run tests
test:
	forge test -vvv

.PHONY: deploy # Deploy contract
deploy:
	forge create --rpc-url "https://testnet.aurora.dev" --private-key ${PRIVATE_KEY} ./src/AssetManager.sol:AssetManager --verify --etherscan-api-key ${ETHERSCAN_KEY} --verifier etherscan