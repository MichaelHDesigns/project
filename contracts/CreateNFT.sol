// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CreateNFT is ERC721URIStorage, Ownable {
    using SafeMath for uint256;

    uint256 public tokenCounter;

    constructor() ERC721("NFT Marketplace", "NFTM") {}

    function createToken(string memory tokenURI) public onlyOwner returns (uint256) {
        uint256 newTokenId = tokenCounter.add(1);
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        tokenCounter = newTokenId;
        return newTokenId;
    }

    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        _setBaseURI(_newBaseURI);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return "https://nft-marketplace.com/token/";
    }
}
