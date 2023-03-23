// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract CreateNFT is ERC721 {
    using SafeMath for uint256;

    uint256 private _maxTokens;
    uint256 private _tokenPrice;

    constructor(uint256 maxTokens, uint256 tokenPrice) ERC721("MyNFT", "MNFT") {
        _maxTokens = maxTokens;
        _tokenPrice = tokenPrice;
    }

    function mintNFT(uint256 numberOfTokens) external payable {
        require(totalSupply().add(numberOfTokens) <= _maxTokens, "Exceeds maximum NFT limit");
        require(msg.value >= _tokenPrice.mul(numberOfTokens), "Ether value sent is not correct");

        for (uint256 i = 0; i < numberOfTokens; i++) {
            uint256 tokenId = totalSupply();
            _safeMint(msg.sender, tokenId);
        }
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return "https://www.example.com/";
    }

    function totalSupply() public view override returns (uint256) {
        return super.totalSupply();
    }
}
