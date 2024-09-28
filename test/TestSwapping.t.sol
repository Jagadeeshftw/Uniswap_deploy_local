// SPDX-License-Identifier: MIT
pragma solidity >=0.8.5;

import {Test} from "forge-std/Test.sol";
import {UniswapDeployer} from "../script/UniswapDeployer.s.sol";
import {console} from "forge-std/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {TestUniswap} from "../src/TestUniswap.sol"; // Add correct path for TestUniswap contract
import {Tether} from "../src/Tokens/Tether.sol";
import {WrappedBitcoin} from "../src/Tokens/WrappedBitcoin.sol";
import {IUniswapV2Router02} from "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import {IUniswapV2Router01} from "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol";

contract TestUniswapSwap is Test {
    uint256 constant AMOUNT_IN = 10000 * 10 ** 18; // Add 100,000 USDT
    uint256 constant AMOUNT_OUT_MIN = 1 * 10 ** 18; // Add 1 WBTC

    // Create instances of the tokens
    Tether usdt = new Tether();
    WrappedBitcoin wbtc = new WrappedBitcoin();

    IUniswapV2Router02 router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    address TOKEN_IN;
    address TOKEN_OUT;
    address TO;

    IERC20 tokenIn;
    IERC20 tokenOut;
    TestUniswap testUniswap;

    function setUp() public {
        UniswapDeployer deployer = new UniswapDeployer();
        deployer.run();
        // Log initial balances
        console.log("Initial Balances:");
        console.log(usdt.balanceOf(address(this))); // Initial USDT balance
        console.log(wbtc.balanceOf(address(this))); // Initial WBTC balance

        // Approve the router to spend the tokens
        usdt.approve(address(router), type(uint256).max);
        wbtc.approve(address(router), type(uint256).max);

        // Add initial liquidity to the pool
        uint256 initialAmountA = 100000 * 10 ** 18; // Add 100,000 USDT
        uint256 initialAmountB = 20 * 10 ** 18; // Add 1 WBTC
        (uint256 amountA, uint256 amountB, uint256 liquidity) = IUniswapV2Router01(router).addLiquidity(
            address(usdt), address(wbtc), initialAmountA, initialAmountB, 1, 1, address(this), block.timestamp + 1000
        );
        // Log final amounts added and liquidity tokens received
        console.log("Final Amounts Added:");
        console.log("Amount A (USDT) added:", amountA);
        console.log("Amount B (WBTC) added:", amountB);
        console.log("Liquidity tokens received:", liquidity);
        TO = address(this);

        // Set the token addresses dynamically after deploying
        TOKEN_IN = address(usdt); // USDT address
        TOKEN_OUT = address(wbtc); // WBTC address

        tokenIn = IERC20(TOKEN_IN);
        tokenOut = IERC20(TOKEN_OUT);
        testUniswap = new TestUniswap();

        // Approve the TestUniswap contract to spend tokens on behalf of the contract
        tokenIn.approve(address(testUniswap), AMOUNT_IN);
    }

    function testSwap() public {
        // Execute the swap on Uniswap
        testUniswap.swap(TOKEN_IN, TOKEN_OUT, AMOUNT_IN, AMOUNT_OUT_MIN, TO);

        emit log_uint(AMOUNT_IN); // Log the amount of input
        emit log_uint(tokenOut.balanceOf(TO)); // Log the amount received
    }
}
