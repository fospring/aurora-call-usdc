#cat out/tUSDC.sol/tUSDC.json | jq '.abi' > out/tUSDC.sol/tUSDC.abi
#aurora-cli --network testnet --near-key-path $near_key_path call --aurora-secret-key $aurora_key --address 0xbcf48399b098d09d5588cf64778db338f55f6078 --function mint --abi-path out/tUSDC.sol/tUSDC.abi --args '{"to": "0x4053E7f3Cf94Cc7e0d90d724523fa1Fc1FA2d842", "amount": "1000000000000000000"}'
# Aurora transaction status: successful, gas used: 34037
cat out/AuroraSdk.sol/AuroraSdk.json | jq '.abi' > out/AuroraSdk.sol/AuroraSdk.abi
# data: {\"receiver_id\": \"asset-manager.orderly-dev.testnet\", \"msg\": \"Deposit\", \"amount\": \"10000000\"}
aurora-cli --network testnet view-call --address 0x6b42dafcc51dfaed414ed16e5970584227d6de95 --function addressSubAccount --abi-path out/AuroraSdk.sol/AuroraSdk.abi --args '{"account": "0x4053E7f3Cf94Cc7e0d90d724523fa1Fc1FA2d842", "accountId": "aurora"}'
# https://explorer.testnet.near.org/transactions/BRE3ZgDa75CGjxRDMn2adgvPHk3bG2nPcp8VfdToTBW8