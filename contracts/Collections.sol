pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
import "https://api.pinata.cloud/pinning/pinFileToIPFS";

contract Collections is ERC721, Ownable {
    struct Collection {
        string name;
        string symbol;
        string[] metadataFields;
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

    function addTokenMetadata(uint256 _tokenId, string[] memory _metadata) public {
        require(_isApprovedOrOwner(msg.sender, _tokenId), "Collections: caller is not owner nor approved");

        Collection storage collection = collections[_tokenId];
        require(_metadata.length == collection.metadataFields.length, "Collections: incorrect number of metadata fields");

        string memory metadataUri = createMetadataUri(_metadata);
        tokenMetadata[_tokenId] = _metadata;

        emit URI(metadataUri, _tokenId);
    }

    function tokenMetadataByIndex(uint256 _tokenId, uint256 _index) public view returns (string memory) {
        require(_index < collections[_tokenId].metadataFields.length, "Collections: index out of range");

        return tokenMetadata[_tokenId][_index];
    }

function createMetadataUri(string[] memory _metadata) private returns (string memory) {
    string[] memory parts = new string[](_metadata.length * 2 + 1);
    parts[0] = "data:application/json;base64,";

    for (uint256 i = 0; i < _metadata.length; i++) {
        parts[i * 2 + 1] = collections[msg.tokenId].metadataFields[i];
        parts[i * 2 + 2] = _metadata[i];
    }

    string memory json = string(abi.encodePacked("{", string(abi.encodePacked(parts)), "}"));

    // Pin JSON to IPFS using Pinata
    string memory pinataApiKey = "<your_pinata_api_key>";
    string memory pinataApiSecret = "<your_pinata_api_secret>";

    // Encode the JSON as bytes
    bytes memory jsonBytes = bytes(json);

    // Set the pinata options
    string memory pinataOptions = '{"pinataMetadata": {"name": "Collections metadata"}}';

    // Make the API request
    (bool success, bytes memory data) = address(0x8BCCBEF7f1E1Df277859A2Db030f45E7aB9e45Df).call(abi.encodeWithSignature("pinFileToIPFS(string,string,bytes,string)", pinataApiKey, pinataApiSecret, jsonBytes, pinataOptions));
    require(success, "Failed to pin JSON to IPFS");

    // Decode the response
    string memory result = abi.decode(data, (string));

    return result;
}
}
