// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PepeCoin is ERC20 {
    constructor(uint256 initialSupply) ERC20("PepeCoin", "PP") {
        _mint(msg.sender, initialSupply);
    }
}