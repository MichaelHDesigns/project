// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract CreateNFT is ERC721 {
    using SafeMath for uint256;

    // Base URI
    string private _baseURI;

    // Max tokens
    uint256 private _maxTokens;

    // Price
    uint256 private _price;

    // Sale status
    bool private _saleActive;

    // Total supply
    uint256 private _totalSupply;

    // Event for token creation
    event NFTCreated(uint256 tokenId);

    constructor(
        string memory baseURI_,
        uint256 maxTokens_,
        uint256 price_
    ) ERC721("MyNFT", "MNFT") {
        _baseURI = baseURI_;
        _maxTokens = maxTokens_;
        _price = price_;
        _saleActive = true;
    }

    // Only owner
    modifier onlyOwner() {
        require(msg.sender == owner(), "Only the contract owner can call this function");
        _;
    }

    // Mint a single NFT
    function mint() public payable {
        require(_saleActive, "Sale has ended");
        require(totalSupply() < _maxTokens, "Exceeds maximum NFT limit");
        require(msg.value == _price, "Incorrect Ether value");

        uint256 tokenId = totalSupply().add(1);
        _safeMint(msg.sender, tokenId);

        _totalSupply = _totalSupply.add(1);

        emit NFTCreated(tokenId);
    }

    // Mint multiple NFTs at once
    function bulkMint(uint256 numberOfTokens) public payable {
        require(_saleActive, "Sale has ended");
        require(totalSupply().add(numberOfTokens) <= _maxTokens, "Exceeds maximum NFT limit");
        require(msg.value == _price.mul(numberOfTokens), "Incorrect Ether value");

        for (uint256 i = 0; i < numberOfTokens; i++) {
            uint256 tokenId = totalSupply().add(1);
            _safeMint(msg.sender, tokenId);

            _totalSupply = _totalSupply.add(1);

            emit NFTCreated(tokenId);
        }
    }

    // Set base URI
    function setBaseURI(string memory baseURI_) external onlyOwner {
        _baseURI = baseURI_;
    }

    // Get base URI
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURI;
    }

    // Pause sale
    function pauseSale() external onlyOwner {
        _saleActive = false;
    }

    // Resume sale
    function resumeSale() external onlyOwner {
        _saleActive = true;
    }

    // End sale
    function endSale() external onlyOwner {
        _saleActive = false;
    }

    // Get max tokens
    function getMaxTokens() public view returns (uint256) {
        return _maxTokens;
    }

    // Get price
    function getPrice() public view returns (uint256) {
        return _price;
    }

    // Get sale status
    function getSaleStatus() public view returns (bool) {
        return _saleActive;
    }

    // Get total supply
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
}
