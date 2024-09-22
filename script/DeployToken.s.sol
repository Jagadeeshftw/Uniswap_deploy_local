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

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        tether = new Tether();
        console.log("Tether deployed at:", address(tether));

        usdCoin = new UsdCoin();
        console.log("USDC deployed at:", address(usdCoin));

        wrappedBitcoin = new WrappedBitcoin();
        console.log("Wrapped Bitcoin deployed at:", address(wrappedBitcoin));

        vm.stopBroadcast();
    }
}
