// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

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
