// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {DAO} from "../src/DAO.sol";
import {DAOToken} from "../src/DAOToken.sol";
import {DAONft} from "../src/DAONft.sol";
import {console} from "forge-std/console.sol";

contract DAOTest is Test {
    DAOToken daoToken;
    DAONft daoNft;
    DAO dao;
    address user1 = address(1);
    address user2 = address(2);

    function setUp() public {
        daoToken = new DAOToken();
        daoNft = new DAONft(address(daoToken));
        dao = new DAO(address(daoToken), address(daoNft));

        daoToken.transferOwnership(address(dao));
        daoNft.transferOwnership(address(dao));
    }

    function testCreateProposal() public {
        vm.startPrank(address(dao));
        daoToken.mint(user1, 1000 * 10 ** 18);
        vm.stopPrank();
        vm.startPrank(user1);
        dao.createProposal("Add new feature");
        string memory proposal = dao.getProposalDescription(0);
        vm.stopPrank();
        assertEq(proposal, "Add new feature");
    }

    function testVote() public {
        vm.startPrank(address(dao));
        daoToken.mint(user1, 1000 * 10 ** 18);
        vm.stopPrank();

        vm.startPrank(user1);
        dao.createProposal("Upgrade system");
        dao.vote(0);
        vm.stopPrank();
        uint256 proposalVotes = dao.getProposalVotes(0);

        assertEq(proposalVotes, 1000 * 10 ** 18);
    }

    function testExecuteProposal() public {
        vm.startPrank(address(dao));
        daoToken.mint(user1, 10000 * 10 ** 18);
        vm.stopPrank();

        vm.startPrank(user1);
        dao.createProposal("Upgrade UI");
        dao.vote(0);
        vm.stopPrank();

        dao.executeProposal(0);
        bool proposalExecuted = dao.getProposalExecuted(0);
        assertEq(proposalExecuted, true);
    }
}
