// SPDX-License-Identifier: MIT
pragma solidity >=0.8.5;

import {console} from "forge-std/console.sol";
import {Test} from "forge-std/Test.sol";
import {UniswapDeployer} from "../script/UniswapDeployer.s.sol";
import {IUniswapV2Factory} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import {WETH} from "solmate/tokens/WETH.sol";
import {IUniswapV2Router02} from "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import {IUniswapV2Router01} from "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol";
import {IWETH} from "@uniswap/v2-periphery/contracts/interfaces/IWETH.sol";
import {Tether} from "../src/Tokens/Tether.sol";
import {WrappedBitcoin} from "../src/Tokens/WrappedBitcoin.sol";

contract UniswapTests is Test {
    IUniswapV2Factory factory = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);

    WETH deployedWeth = WETH(payable(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2));

    IUniswapV2Router02 router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    function setUp() public {
        UniswapDeployer deployer = new UniswapDeployer();
        deployer.run();
    }

    function test_uniswapFactory() public view {
        assert(factory.feeToSetter() != address(0));
    }

    function test_wrappedEther() public view {
        assert(abi.encode(deployedWeth.name()).length > 0);
    }

    function test_deployedRouter() public view {
        assert(router.WETH() != address(0));
    }

    function test_addLiqETHToken() public {
        Tether token = new Tether();

        token.approve(address(router), type(uint256).max);

        IUniswapV2Router01(router).addLiquidityETH{value: 10 ether}(
            address(token), token.balanceOf(address(this)), 0, 0, address(this), block.timestamp + 1000
        );
    }

    function test_addLiqToken_WithExistingLiquidity() public {
        // Create instances of the tokens
        Tether usdt = new Tether();
        WrappedBitcoin wbtc = new WrappedBitcoin();

        // Log initial balances
        console.log("Initial Balances:");
        console.log(usdt.balanceOf(address(this))); // Initial USDT balance
        console.log(wbtc.balanceOf(address(this))); // Initial WBTC balance

        // Approve the router to spend the tokens
        usdt.approve(address(router), type(uint256).max);
        wbtc.approve(address(router), type(uint256).max);

        // Add initial liquidity to the pool
        uint256 initialAmountA = 100 * 10 ** 18; // Add 100,000 USDT
        uint256 initialAmountB = 1 * 10 ** 18; // Add 1 WBTC
        IUniswapV2Router01(router).addLiquidity(
            address(usdt), address(wbtc), initialAmountA, initialAmountB, 1, 1, address(this), block.timestamp + 1000
        );

        // Log balances after initial liquidity
        console.log("Balances after adding initial liquidity:");
        console.log(usdt.balanceOf(address(this)));
        console.log(wbtc.balanceOf(address(this)));

        // Desired amounts to add
        uint256 amountADesired = 163.43 * 10 ** 18; // USDT amount (1 WBTC)
        uint256 amountBDesired = 1 * 10 ** 18; // WBTC amount
        uint256 amountAMin = 1; // Minimum USDT to add (1% slippage)
        uint256 amountBMin = 1; // Minimum WBTC to add (1% slippage)

        // Add liquidity again
        (uint256 amountA, uint256 amountB, uint256 liquidity) = IUniswapV2Router01(router).addLiquidity(
            address(usdt),
            address(wbtc),
            amountADesired,
            amountBDesired,
            amountAMin,
            amountBMin,
            address(this),
            block.timestamp + 1000
        );

        // Log final amounts added and liquidity tokens received
        console.log("Final Amounts Added:");
        console.log("Amount A (USDT) added:", amountA);
        console.log("Amount B (WBTC) added:", amountB);
        console.log("Liquidity tokens received:", liquidity);

        // Verify that the amounts received are as expected
        require(amountA >= amountAMin, "Slippage limit reached for USDT");
        require(amountB >= amountBMin, "Slippage limit reached for WBTC");

        // Check if the actual amount added differs from the desired amount
        if (amountA < amountADesired) {
            console.log("Actual amount of USDT added is less than the desired amount.");
        } else {
            console.log("Actual amount of USDT added matches or exceeds the desired amount.");
        }

        if (amountB < amountBDesired) {
            console.log("Actual amount of WBTC added is less than the desired amount.");
        } else {
            console.log("Actual amount of WBTC added matches or exceeds the desired amount.");
        }
        console.log(amountA);
        console.log(amountADesired);
    }
}
