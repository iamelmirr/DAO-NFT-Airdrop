// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {DAOToken} from "../src/DAOToken.sol";
import {DAONft} from "../src/DAONft.sol";
import {DAO} from "../src/DAO.sol";

contract DeployDAO is Script {
    function run() external returns (DAO) {
        vm.startBroadcast();

        DAOToken daoToken = new DAOToken();
        DAONft daoNft = new DAONft();
        DAO dao = new DAO(address(daoToken), address(daoNft));

        daoToken.transferOwnership(address(dao));
        daoNft.transferOwnership(address(dao));

        vm.stopBroadcast();

        return (dao);
    }
}
