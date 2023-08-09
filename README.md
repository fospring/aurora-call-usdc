# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

first pull the project:
```shell
git submodule update --init --recursive
```

```shell
git submodule update --recursive
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```

# deploy library
[reference1](https://blog.csdn.net/zhangce315/article/details/82824369)

# ftCall contract
address：https://explorer.testnet.aurora.dev/address/0x6c99c4a93dd61b549f0e124a18b79aade90531d9

[aurora evm contract source code](./src/FtCall.sol)
```solidity
import "openzeppelin-contracts/access/AccessControl.sol";
import "openzeppelin-contracts/token/ERC20/IERC20.sol";
import {
    AuroraSdk,
    Codec,
    NEAR,
    PromiseCreateArgs,
    PromiseResultStatus,
    PromiseWithCallback
} from "aurora-sdk/AuroraSdk.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

uint64 constant SET_NEAR_GAS = 120_000_000_000_000;
uint64 constant SET_CALLBACK_NEAR_GAS = 10_000_000_000_000;

contract FtCall is AccessControl {
    using AuroraSdk for NEAR;
    using AuroraSdk for PromiseCreateArgs;
    using AuroraSdk for PromiseWithCallback;
    using Codec for bytes;

    IERC20 public wNEAR;
    bytes32 public constant CALLBACK_ROLE = keccak256("CALLBACK_ROLE");
    NEAR public near;

    constructor(IERC20 _wNEAR) {
        near = AuroraSdk.initNear(_wNEAR);
        wNEAR = _wNEAR;
        _grantRole(CALLBACK_ROLE, AuroraSdk.nearRepresentitiveImplicitAddress(address(this)));
    }

    function ftTransferCall(uint128 attachedNear, string memory ftTokenAcc, bytes memory data) public {
        wNEAR.transferFrom(msg.sender, address(this), attachedNear);
        PromiseCreateArgs memory callSet = near.call(ftTokenAcc, "ft_transfer_call", data, attachedNear, SET_NEAR_GAS);
        PromiseCreateArgs memory callback = near.auroraCall(address(this), abi.encodePacked(this.setCallback.selector), 0, SET_CALLBACK_NEAR_GAS);
        callSet.then(callback).transact();
    }

    // This function is not meant to be called by an externally owned account (EOA) on Aurora.
    // It should only be invoked as a callback from the main `set` method above. This is
    // the reason why this function has separate access control from `set`.
    function setCallback() public onlyRole(CALLBACK_ROLE) {
        if (AuroraSdk.promiseResult(0).status != PromiseResultStatus.Successful) {
            revert("Call to set failed");
        }
    }
}
```
# signer on near
[shrm.orderly-dev.testnet](https://explorer.testnet.near.org/accounts/shrm.orderly-dev.testnet)
# transfer aurora record
```shell
near call aurora ft_transfer '{"receiver_id": "4053e7f3cf94cc7e0d90d724523fa1fc1fa2d842.aurora", "amount": "200000000000000
0"}' --accountId shrm.orderly-dev.testnet --depositYocto 1
```
tx: https://explorer.testnet.near.org/transactions/4wmweQ6LpjMEgsfU9JJwsu6RXbNYoNna1YxwBVCAV3Wc

contract call command:
```shell
# data: {\"receiver_id\": \"asset-manager.orderly-dev.testnet\", \"msg\": \"Deposit\", \"amount\": \"10000000\"}
aurora-cli --network testnet --near-key-path $near_key_path call --aurora-secret-key $aurora_key --address 0x6c99c4a93dd61b549f0e124a18b79aade90531d9 --function ftTransferCall --abi-path out/FtCall.sol/FtCall.abi --args '{"attachedNear": "1", "ftTokenAcc": "usdc.orderly-dev.testnet", "data": "0x7b5c2272656365697665725f69645c223a205c2261737365742d6d616e616765722e6f726465726c792d6465762e746573746e65745c222c205c226d73675c223a205c224465706f7369745c222c205c22616d6f756e745c223a205c2231303030303030305c227d"}'
```
Near tx: https://explorer.testnet.near.org/transactions/9suxzJXJwP7fyNHZBfNENxKY6UWFi2AyTt5WpZc6TA4t  
log info:
```text
signer_address Address(0x4053e7f3cf94cc7e0d90d724523fa1fc1fa2d842)
total_writes_count 1
total_written_bytes 32
```
error info:  
`ERC20: insufficient allowance...`
# my account's token balance：
nETH
```shell
near view aurora ft_balance_of '{"account_id": "4053e7f3cf94cc7e0d90d724523fa1fc1fa2d842.aurora"}'
View call: aurora.ft_balance_of({"account_id": "4053e7f3cf94cc7e0d90d724523fa1fc1fa2d842.aurora"})
Log [aurora]: Balance of nETH [4053e7f3cf94cc7e0d90d724523fa1fc1fa2d842.aurora]: 2000000000000000
'2000000000000000'
```
ft token:
```shell
near view usdc.orderly-dev.testnet ft_balance_of '{"account_id": "4053e7f3cf94cc7e0d90d724523fa1fc1fa2d842.aurora"}'
View call: usdc.orderly-dev.testnet.ft_balance_of({"account_id": "4053e7f3cf94cc7e0d90d724523fa1fc1fa2d842.aurora"})
'100000000'
```
