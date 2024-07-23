// SPDX-License-Identifier: GNU General Public License v3.0
pragma solidity 0.8.20;

import {TSwapPool} from "../../src/TSwapPool.sol";
import {ERC20Mock} from "lib/openzeppelin-contracts/contracts/mocks/token/ERC20Mock.sol";
import {PoolFactory} from "../../src/PoolFactory.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";

contract InvariantTest is StdInvariant, Test {
    ERC20Mock token;
    ERC20Mock weth;

    PoolFactory factory;
    TSwapPool pool;

    int256 constant STARTING_X = 100e18; //tokens
    int256 constant STARTING_Y = 50e18; // weth

    function setUp() public {
        token = new ERC20Mock();
        weth = new ERC20Mock();

        token.mint(address(this), uint256(STARTING_X));
        weth.mint(address(this), uint256(STARTING_Y));

        token.approve(address(pool), type(uint256).max);
        weth.approve(address(pool), type(uint256).max);

        pool.deposit(
            uint256(STARTING_Y),
            uint256(STARTING_Y),
            uint256(STARTING_X),
            uint64(block.timestamp)
        );
    }
}
