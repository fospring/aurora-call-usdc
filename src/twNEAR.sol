// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";

contract twNEAR is ERC20 {
    constructor() ERC20("TestwNEAR", "twNEAR") {}

    function decimals() public pure override returns (uint8) {
        return 24;
    }

    // everyone can direct mint usdc
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
