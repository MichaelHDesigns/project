// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CreateNFT is ERC721 {

    string private baseURI;
    uint256 private tokenCounter;

    constructor(string memory _baseURI) ERC721("MyNFT", "MNFT") {
        baseURI = _baseURI;
        tokenCounter = 0;
    }

    function mintNFT(string memory _tokenURI) external {
        uint256 newTokenId = tokenCounter;
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);
        tokenCounter++;
    }

    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        baseURI = _newBaseURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }
}
