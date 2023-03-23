// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CreateNFT is ERC721, Ownable {

    string private _baseURI;
    uint256 private _tokenCounter;

    constructor(string memory baseURI) ERC721("MyNFT", "MNFT") {
        _baseURI = baseURI;
        _tokenCounter = 0;
    }

    function mintNFT(string memory tokenURI) external {
        uint256 newTokenId = _tokenCounter;
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        _tokenCounter++;
    }

    function setBaseURI(string memory newBaseURI) external onlyOwner {
        _baseURI = newBaseURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURI;
    }
}
