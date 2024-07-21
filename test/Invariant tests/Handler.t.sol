// SPDX-License-Identifier: GNU General Public License v3.0
pragma solidity 0.8.20;

import {TSwapPool} from "../../src/TSwapPool.sol";
import {ERC20Mock} from "@openzeppelin/mocks/token/ERC20Mock.sol";
import {PoolFactory} from "../../src/PoolFactory.sol";
import {Test, console} from "forge-std/src/Test.sol";

contract Handler is Test {
    TSwapPool pool;

    ERC20Mock token;
    ERC20Mock weth;

    address liquidityProvider = makeAddr("lp");
    address swapper = makeAddr("swp");

    int256 startingX;
    int256 startingY;
    int256 expectedDeltaX; //expected change
    int256 expectedDeltaY;
    int256 actualDeltaX; //actual change
    int256 actualDeltaY;

    constructor(TSwapPool _pool) {
        pool = _pool;
        weth = ERC20Mock(pool.getWeth());
        token = ERC20Mock(pool.getPoolToken());
    }

    function deposit(uint256 wethAmount) public {
        wethAmount = bound(wethAmount, 0, type(uint64).max);

        startingY = int256(weth.balanceOf(address(this))); //weth starting b4 tx
        startingX = int256(token.balanceOf(address(this))); //token starting balance

        expectedDeltaY = int256(wethAmount); //weth change introduced
        expectedDeltaX = int256(
            pool.getPoolTokensToDepositBasedOnWeth(wethAmount)
        );

        vm.startPrank(liquidityProvider);
        weth.mint(liquidityProvider, wethAmount);
        token.mint(liquidityProvider, uint256(expectedDeltaX));

        weth.approve(address(pool), type(uint256).max);
        token.approve(address(pool), type(uint256).max);

        pool.deposit(
            wethAmount,
            0,
            uint256(expectedDeltaX),
            uint64(block.timestamp)
        );

        //actual
        uint256 endingY = weth.balanceOf(address(this)); //weth ending
        uint256 endingX = token.balanceOf(address(this));
        actualDeltaY = int256(endingY) - int256(startingY);
        actualDeltaX = int256(endingX) - int256(startingX);
    }
}
