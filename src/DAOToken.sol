// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract DAOToken is ERC20, Ownable {
    error DAOToken__DAOTokenOnlyOwnerCanMintTokens();

    constructor() ERC20("DAO Governance Token", "DAOG") Ownable(msg.sender) {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) external onlyOwner {
        if(msg.sender != owner()) {
            revert DAOToken__DAOTokenOnlyOwnerCanMintTokens();
        }
        _mint(to, amount);
    }
}
