// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CreateNFT is ERC721, Ownable {
    using SafeMath for uint256;
    
    string private _baseURI;
    uint256 private _tokenIdTracker;
    uint256 private _maxTokens;
    uint256 private _tokenPrice;
    bool private _saleActive;
    
    constructor(string memory name, string memory symbol, string memory baseURI, uint256 maxTokens, uint256 tokenPrice) ERC721(name, symbol) {
        _baseURI = baseURI;
        _maxTokens = maxTokens;
        _tokenPrice = tokenPrice;
    }
    
    modifier saleIsOpen {
        require(totalSupply() < _maxTokens, "Sale has already ended");
        require(_saleActive == true, "Sale is not active");
        _;
    }
    
    function mint(uint256 numberOfTokens) public payable saleIsOpen {
        require(numberOfTokens > 0, "You need to mint at least 1 NFT");
        require(totalSupply().add(numberOfTokens) <= _maxTokens, "Exceeds maximum NFT limit");
        require(msg.value >= _tokenPrice.mul(numberOfTokens), "Ether value sent is not correct");
        
        for (uint i = 0; i < numberOfTokens; i++) {
            _safeMint(msg.sender, _tokenIdTracker);
            _tokenIdTracker = _tokenIdTracker.add(1);
        }
    }
    
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURI;
    }
    
    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        _baseURI = _newBaseURI;
    }
    
    function startSale() external onlyOwner {
        _saleActive = true;
    }
    
    function stopSale() external onlyOwner {
        _saleActive = false;
    }
    
    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
}
