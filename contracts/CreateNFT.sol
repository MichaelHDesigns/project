// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract CreateNFT is ERC721, Ownable {
    string public baseURI;
    address public pinataAddress;
    string public pinataApiKey;
    string public pinataSecretApiKey;

    constructor(string memory _name, string memory _symbol, string memory _baseURI, address _pinataAddress, string memory _pinataApiKey, string memory _pinataSecretApiKey) ERC721(_name, _symbol) {
        baseURI = _baseURI;
        pinataAddress = _pinataAddress;
        pinataApiKey = _pinataApiKey;
        pinataSecretApiKey = _pinataSecretApiKey;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        baseURI = _newBaseURI;
    }

    function setPinataAddress(address _newPinataAddress) external onlyOwner {
        pinataAddress = _newPinataAddress;
    }

    function setPinataApiKey(string memory _newPinataApiKey) external onlyOwner {
        pinataApiKey = _newPinataApiKey;
    }

    function setPinataSecretApiKey(string memory _newPinataSecretApiKey) external onlyOwner {
        pinataSecretApiKey = _newPinataSecretApiKey;
    }

    function mintNFT(string memory _tokenURI) external {
        require(pinataAddress != address(0), "Pinata address is not set");
        require(bytes(pinataApiKey).length > 0, "Pinata API key is not set");
        require(bytes(pinataSecretApiKey).length > 0, "Pinata Secret API key is not set");
        
        uint256 tokenId = totalSupply() + 1;
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenURI);
    }
}
