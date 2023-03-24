pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Collections is ERC721, Ownable {
    using Strings for uint256;

    struct Collection {
        string name;
        string symbol;
        string[] metadataFields;
        mapping(uint256 => bytes) tokenImages;
    }

    Collection[] public collections;

    mapping(uint256 => string[]) private tokenMetadata;

    constructor() ERC721("Collections", "COLL") {}

    function createCollection(string memory _name, string memory _symbol, string[] memory _metadataFields) public onlyOwner returns (uint256) {
        uint256 newCollectionId = collections.length;
        Collection memory newCollection = Collection({ name: _name, symbol: _symbol, metadataFields: _metadataFields });
        collections.push(newCollection);

        _safeMint(msg.sender, newCollectionId);
        return newCollectionId;
    }

    function addTokenMetadataAndImage(uint256 _tokenId, string[] memory _metadata, bytes memory _image) public {
        require(_isApprovedOrOwner(msg.sender, _tokenId), "Collections: caller is not owner nor approved");

        Collection storage collection = collections[_tokenId];
        require(_metadata.length == collection.metadataFields.length, "Collections: incorrect number of metadata fields");

        // Convert the token ID to a string for use in the image URI
        string memory tokenIdString = _tokenId.toString();

        // Set the image URI
        string memory imageUri = string(abi.encodePacked("data:image/jpeg;base64,", Base64.encode(_image)));

        // Store the image on-chain
        collection.tokenImages[_tokenId] = _image;

        // Store the metadata on-chain
        string memory metadataUri = createMetadataUri(_metadata, imageUri);
        tokenMetadata[_tokenId] = _metadata;

        emit URI(metadataUri, _tokenId);
    }

    function tokenMetadataByIndex(uint256 _tokenId, uint256 _index) public view returns (string memory) {
        require(_index < collections[_tokenId].metadataFields.length, "Collections: index out of range");

        return tokenMetadata[_tokenId][_index];
    }

    function tokenImage(uint256 _tokenId) public view returns (bytes memory) {
        return collections[_tokenId].tokenImages[_tokenId];
    }

    function createMetadataUri(string[] memory _metadata, string memory _imageUri) private returns (string memory) {
        string[] memory parts = new string[](_metadata.length * 2 + 4);
        parts[0] = "{";
        parts[1] = string(abi.encodePacked('"image":"', _imageUri, '",'));

        for (uint256 i = 0; i < _metadata.length; i++) {
            parts[i * 2 + 2] = string(abi.encodePacked('"', collections[msg.tokenId].metadataFields[i], '":"', _metadata[i], '",'));
        }

        // Remove the trailing comma
        parts[parts.length - 2] = "}";
        parts[parts.length - 1] = "";

        string memory json = string(abi.encodePacked(parts));

        return json;
    }
}
