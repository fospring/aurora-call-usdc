near_key_path=~/.near-credentials/testnet/shrm.orderly-dev.testnet.json
aurora_key=$(cat aurora-key.txt)

cat out/twNEAR.sol/twNEAR.json | jq '.abi' > out/twNEAR.sol/twNEAR.abi
aurora-cli --network testnet --near-key-path $near_key_path call --aurora-secret-key $aurora_key --address 0x8394a2200eb33cf65818d5ab1036938352f58ea7 --function mint --abi-path out/twNEAR.sol/twNEAR.abi --args '{"to": "0x4053E7f3Cf94Cc7e0d90d724523fa1Fc1FA2d842", "amount": "100000000000000000000000000"}'
# Aurora transaction status: successful, gas used: 34037