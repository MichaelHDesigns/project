// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

interface IPinata {
    function pinJSONToIPFS(string memory _json) external returns (bytes32, bool);
}

contract BulkMint is ERC721 {
    using Strings for uint256;

    address private admin;
    string private pinataApiKey;
    string private pinataSecretApiKey;
    string private apiUrl = "https://api.pinata.cloud/pinning/pinFileToIPFS";
    IPinata private pinata;

    event BulkMinted(uint256[] tokenIds);
    event PinataMetadataUploaded(string contentHash);

    constructor(
        string memory _apiKey, 
        string memory _secretApiKey,
        address _pinataAddress,
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {
        admin = msg.sender;
        pinataApiKey = _apiKey;
        pinataSecretApiKey = _secretApiKey;
        pinata = IPinata(_pinataAddress);
    }

    function bulkMint(string[] memory _tokenURIs) external {
        require(msg.sender == admin, "Only admin can call this function");

        uint256 length = _tokenURIs.length;
        uint256[] memory tokenIds = new uint256[](length);

        for (uint256 i = 0; i < length; i++) {
            string memory tokenURI = _tokenURIs[i];
            string memory contentHash = uploadToPinata(tokenURI);
            uint256 tokenId = uint256(keccak256(abi.encodePacked(block.number, i)));
            tokenIds[i] = tokenId;
            _safeMint(msg.sender, tokenId);
            _setTokenURI(tokenId, contentHash);
        }

        emit BulkMinted(tokenIds);
    }

    function uploadToPinata(string memory tokenURI) private returns (string memory) {
        (bytes32 hash, bool _) = pinata.pinJSONToIPFS(tokenURI);
        string memory contentHash = bytes32ToString(hash);
        emit PinataMetadataUploaded(contentHash);
        return contentHash;
    }

    function bytes32ToString(bytes32 _bytes32) private pure returns (string memory) {
        bytes memory bytesArray = new bytes(64);
        for (uint256 i = 0; i < 32; i++) {
            bytes1 char = bytes1(bytes32(uint256(_bytes32) * 2 ** (8 * i)));
            bytesArray[i * 2] = char >= 0x10 ? bytes1(uint8(87 + char)) : bytes1(uint8(48 + char));
            char = bytes1(bytes32(uint256(_bytes32) * 2 ** (8 * i + 4)));
            bytesArray[i * 2 + 1] = char >= 0x10 ? bytes1(uint8(87 + char)) : bytes1(uint8(48 + char));
        }
        return string(bytesArray);
    }
}
