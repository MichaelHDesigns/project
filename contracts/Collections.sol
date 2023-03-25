// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract Collections is ERC721Enumerable {
    mapping (address => uint256[]) private _userCollections;
    mapping (address => uint256) private _userCollectionCount;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    function createCollection(string memory collectionName) public {
        uint256 collectionId = totalSupply() + 1;
        _mint(msg.sender, collectionId);
        _setTokenURI(collectionId, collectionName);
        _userCollections[msg.sender].push(collectionId);
        _userCollectionCount[msg.sender]++;
    }

    function getCollectionCount(address user) public view returns (uint256) {
        return _userCollectionCount[user];
    }

    function getCollection(address user, uint256 index) public view returns (uint256) {
        return _userCollections[user][index];
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal virtual override(ERC721, ERC721Enumerable) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
}
