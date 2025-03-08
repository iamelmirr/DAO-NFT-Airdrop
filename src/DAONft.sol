// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {DAOToken} from "./DAOToken.sol";

contract DAONft is ERC721, Ownable {
    error DAONft__DAONftAlreadyClaimedNFT();
    error DAONft__DAONftDoesNotOwnDAOToken();

    uint256 private _tokenId;
    mapping(address => bool) public hasClaimed;
    mapping(uint256 tokenId => string) private s_tokenURI;
    DAOToken public daoToken;

    constructor(address _daoToken) ERC721("Governance NFT", "GOVNFT") Ownable(msg.sender) {
        _tokenId = 0;
        daoToken = DAOToken(_daoToken);
    }

    function claimNFT(string memory tokenURI) external {
        if (daoToken.balanceOf(msg.sender) <= 0) {
            revert DAONft__DAONftDoesNotOwnDAOToken();
        }

        if (hasClaimed[msg.sender]) {
            revert DAONft__DAONftAlreadyClaimedNFT();
        }

        uint256 newTokenId = _tokenId;
        _tokenId++;

        _mint(msg.sender, newTokenId);
        s_tokenURI[newTokenId] = tokenURI;

        hasClaimed[msg.sender] = true;
    }

    function getDidUserClaimNFT(address user) public view returns (bool success) {
        bool userClaimed = hasClaimed[user];

        return userClaimed;
    }
}
