// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {DAOToken} from "../src/DAOToken.sol";
import {DAONft} from "../src/DAONft.sol";

contract DAONftTest is Test {
    DAOToken daoToken;
    DAONft daoNft;
    address user = makeAddr('user');

    function setUp() public {
        daoToken = new DAOToken();
        daoNft = new DAONft(address(daoToken));
    }

    function testClaimNFT() public {
        daoToken.mint(user, 100 * 10 ** 18);

        vm.startPrank(user);
        daoNft.claimNFT("ipfs://metadata");
        vm.stopPrank();

        bool userClaimedNft = daoNft.getDidUserClaimNFT(user);

        assertEq(userClaimedNft, true);
    }

    function testCannotClaimWithoutTokens() public {
        vm.expectRevert(abi.encodeWithSignature("DAONft__DAONftDoesNotOwnDAOToken()"));
        vm.startPrank(user);
        daoNft.claimNFT("ipfs://metadata");
        vm.stopPrank();
    }
}