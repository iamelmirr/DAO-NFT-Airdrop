// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {DAOToken} from "../src/DAOToken.sol";
import {Script} from "forge-std/Script.sol";

contract TokenDeploy is Script {
    function run() external returns (DAOToken) {
        vm.startBroadcast();
        DAOToken token = new DAOToken();
        vm.stopBroadcast();
        return token;
    }
}
