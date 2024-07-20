// SPDX-License-Identifier: GNU General Public License v3.0
pragma solidity 0.8.20;

import {TSwapPool} from "../../src/TSwapPool.sol";
import {ERC20Mock} from "lib/node_modules/@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {PoolFactory} from "../../src/PoolFactory.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";

contract InvariantTest is StdInvariant, Test {}
