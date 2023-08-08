near_key_path=~/.near-credentials/testnet/shrm.orderly-dev.testnet.json
aurora_key=$(cat aurora-key.txt)

#cat out/tUSDC.sol/tUSDC.json | jq '.abi' > out/tUSDC.sol/tUSDC.abi
#aurora-cli --network testnet --near-key-path $near_key_path call --aurora-secret-key $aurora_key --address 0xbcf48399b098d09d5588cf64778db338f55f6078 --function mint --abi-path out/tUSDC.sol/tUSDC.abi --args '{"to": "0x4053E7f3Cf94Cc7e0d90d724523fa1Fc1FA2d842", "amount": "1000000000000000000"}'
# Aurora transaction status: successful, gas used: 34037
cat out/FtCall.sol/FtCall.json | jq '.abi' > out/FtCall.sol/FtCall.abi
# data: {\"receiver_id\": \"asset-manager.orderly-dev.testnet\", \"msg\": \"Deposit\", \"amount\": \"10000000\"}
aurora-cli --network testnet --near-key-path $near_key_path call --aurora-secret-key $aurora_key --address 0x6c99c4a93dd61b549f0e124a18b79aade90531d9 --function ftTransferCall --abi-path out/FtCall.sol/FtCall.abi --args '{"attachedNear": "1", "ftTokenAcc": "usdc.orderly-dev.testnet", "data": "0x7b5c2272656365697665725f69645c223a205c2261737365742d6d616e616765722e6f726465726c792d6465762e746573746e65745c222c205c226d73675c223a205c224465706f7369745c222c205c22616d6f756e745c223a205c2231303030303030305c227d"}'
