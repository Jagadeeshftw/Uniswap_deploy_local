// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/Uniswap.sol";
import {WETH} from "solmate/tokens/WETH.sol";
import {IUniswapV2Router02} from "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

contract TestUniswap {
    IUniswapV2Router02 UNISWAP_V2_ROUTER = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    WETH weth = WETH(payable(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2));

    function swap(address _tokenIn, address _tokenOut, uint256 _amountIn, uint256 _amountOutMin, address _to)
        external
    {
        IERC20(_tokenIn).transferFrom(msg.sender, address(this), _amountIn);
        IERC20(_tokenIn).approve(address(UNISWAP_V2_ROUTER), _amountIn);

        address[] memory path;
        if (_tokenIn == address(weth) || _tokenOut == address(weth)) {
            path = new address[](2);
            path[0] = _tokenIn;
            path[1] = _tokenOut;
        } else {
            path = new address[](2);
            path[0] = _tokenIn;
            path[1] = _tokenOut;
        }

        UNISWAP_V2_ROUTER.swapExactTokensForTokens(_amountIn, _amountOutMin, path, _to, block.timestamp);
    }
}
