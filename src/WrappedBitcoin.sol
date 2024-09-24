// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WrappedBitcoin is ERC20, Ownable {
    constructor() ERC20("WrappedBitcoin", "WBTC") Ownable(msg.sender) {
        _mint(msg.sender, 1_000_000 * 10 ** 18);
    }
}
