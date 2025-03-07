// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract DAONft is ERC721, Ownable {
    error DAONft__DAONftRecepientAlreadyMintedNft();

    uint256 private _tokenId;
    mapping(address => bool) public hasMinted;
    mapping(uint256 tokenId => string) private s_tokenURI;

    constructor() ERC721("Governance NFT", "GOVNFT") Ownable(msg.sender) {
        _tokenId = 0;
    }

    function mintNFT(address recipient, string memory tokenURI) external onlyOwner {
        if (hasMinted[recipient]) {
            revert DAONft__DAONftRecepientAlreadyMintedNft();
        }

        uint256 newTokenId = _tokenId;
        _tokenId++;

        _mint(recipient, newTokenId);
        s_tokenURI[newTokenId] = tokenURI;

        hasMinted[recipient] = true;
    }
}
