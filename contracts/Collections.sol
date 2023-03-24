// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract Collections is ERC721, Ownable {
    struct Collection {
        string name;
        string symbol;
        string[] metadataFields;
    }

    Collection[] public collections;

    mapping(uint256 => string[]) private tokenMetadata;
    mapping(uint256 => address) private collectionContracts;

    constructor() ERC721("Collections", "COLL") {}

    function createCollection(string memory _name, string memory _symbol, string[] memory _metadataFields) public onlyOwner returns (uint256) {
        uint256 newCollectionId = collections.length;
        Collection memory newCollection = Collection({ name: _name, symbol: _symbol, metadataFields: _metadataFields });
        collections.push(newCollection);

        _safeMint(msg.sender, newCollectionId);
        return newCollectionId;
    }

    function addTokenMetadata(uint256 _tokenId, string[] memory _metadata) public {
        require(_isApprovedOrOwner(msg.sender, _tokenId), "Collections: caller is not owner nor approved");

        address collectionContract = collectionContracts[_tokenId];
        require(collectionContract != address(0), "Collections: invalid collection contract");

        CollectionData(collectionContract).addTokenMetadata(_tokenId, _metadata);
    }

    function setCollectionContract(uint256 _tokenId, address _collectionContract) public onlyOwner {
        require(_collectionContract != address(0), "Collections: invalid collection contract");
        collectionContracts[_tokenId] = _collectionContract;
    }

    function tokenMetadataByIndex(uint256 _tokenId, uint256 _index) public view returns (string memory) {
        address collectionContract = collectionContracts[_tokenId];
        require(collectionContract != address(0), "Collections: invalid collection contract");

        return CollectionData(collectionContract).tokenMetadataByIndex(_tokenId, _index);
    }
}

abstract contract CollectionData {
    function addTokenMetadata(uint256 _tokenId, string[] memory _metadata) public virtual;
    function tokenMetadataByIndex(uint256 _tokenId, uint256 _index) public view virtual returns (string memory);
}
