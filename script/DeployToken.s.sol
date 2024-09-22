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

        // Mint tokens to the addresses
        tether.mint(addr1, 1000 * 10**18); // Mint 1000 Tether to addr1
        tether.mint(addr2, 1000 * 10**18); // Mint 1000 Tether to addr2
        console.log("Minted 1000 Tether to:", addr1);
        console.log("Minted 1000 Tether to:", addr2);

        usdCoin.mint(addr1, 500 * 10**6);  // Mint 500 USDC to addr1 (USDC has 6 decimals)
        usdCoin.mint(addr2, 500 * 10**6);  // Mint 500 USDC to addr2
        console.log("Minted 500 USDC to:", addr1);
        console.log("Minted 500 USDC to:", addr2);

        wrappedBitcoin.mint(addr1, 10 * 10**8);  // Mint 10 WBTC to addr1 (WBTC has 8 decimals)
        wrappedBitcoin.mint(addr2, 10 * 10**8);  // Mint 10 WBTC to addr2
        console.log("Minted 10 WBTC to:", addr1);
        console.log("Minted 10 WBTC to:", addr2);

        vm.stopBroadcast();
    }
}
