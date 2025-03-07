// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {DAOToken} from "../src/DAOToken.sol";
import {TokenDeploy} from "../script/TokenDeploy.s.sol";

contract DAOTokenTest is Test {
    TokenDeploy public deployer;
    DAOToken public daoToken;
    address owner = address(this);

    function setUp() public {
        daoToken = new DAOToken();
    }

    function testInitialSupply() public {
        assertEq(daoToken.totalSupply(), 1000000 * 10 ** daoToken.decimals());
    }
}
