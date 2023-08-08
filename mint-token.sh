near_key_path=~/.near-credentials/testnet/shrm.orderly-dev.testnet.json
aurora_key=$(cat aurora-key.txt)

aurora-cli --network testnet --near-key-path $near_key_path call --aurora-secret-key $aurora_key --address 0xbcf48399b098d09d5588cf64778db338f55f6078 --function mint --abi-path out/tUSDC.sol/tUSDC.abi --args '{"to": "0x4053E7f3Cf94Cc7e0d90d724523fa1Fc1FA2d842", "amount": "1000000000000000000"}'
# Aurora transaction status: successful, gas used: 34037