// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Tether} from "../src/Tether.sol";
import {UsdCoin} from "../src/Usdcoin.sol";
import {WrappedBitcoin} from "../src/WrappedBitcoin.sol";

contract DeployTokenScript is Script {
    Tether public tether;
    UsdCoin public usdCoin;
    WrappedBitcoin public wrappedBitcoin;

    // Addresses to mint tokens to
    address constant addr1 = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address constant addr2 = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // Deploy the tokens
        tether = new Tether();
        console.log("Tether deployed at:", address(tether));

        usdCoin = new UsdCoin();
        console.log("USDC deployed at:", address(usdCoin));

        wrappedBitcoin = new WrappedBitcoin();
        console.log("Wrapped Bitcoin deployed at:", address(wrappedBitcoin));

        vm.stopBroadcast();
    }
}
