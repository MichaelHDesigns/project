// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CreateNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address private _owner;

    constructor(address owner) ERC721("MyNFT", "MNFT") {
        _owner = owner;
    }

    function createNFT(string memory tokenURI) public returns (uint256) {
        require(msg.sender == _owner, "Only owner can create NFTs");
        _tokenIds.increment();
        uint256 newNFTId = _tokenIds.current();
        _mint(msg.sender, newNFTId);
        _setTokenURI(newNFTId, tokenURI);
        return newNFTId;
    }
}
