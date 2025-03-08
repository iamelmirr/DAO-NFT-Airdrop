// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {DAOToken} from "../src/DAOToken.sol";
import {TokenDeploy} from "../script/TokenDeploy.s.sol";

contract DAOTokenTest is Test {
    TokenDeploy public deployer;
    DAOToken public daoToken;
    address owner = address(this);
    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");

    function setUp() public {
        daoToken = new DAOToken();
    }

    function testInitialSupply() public {
        uint256 expectedSupply = 1000000 * 10 ** daoToken.decimals();
        assertEq(daoToken.totalSupply(), expectedSupply);
        assertEq(daoToken.balanceOf(owner), expectedSupply);
    }

    function testMintingByOwner() public {
        uint256 mintAmount = 1000 * 10 ** daoToken.decimals();
        daoToken.mint(user1, mintAmount);

        assertEq(daoToken.balanceOf(user1), mintAmount);
    }

    function testRevertMintingByNonOwner() public {
        vm.prank(user1);
        vm.expectRevert();

        daoToken.mint(user2, 1000 * 10 ** 18);
    }
}
