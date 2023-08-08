// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";

contract tUSDC is ERC20 {
    constructor() ERC20("TestUSDC", "tUSDC") {}

    function decimals() public pure override returns (uint8) {
        return 6;
    }

    // everyone can direct mint usdc
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
