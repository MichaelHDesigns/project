// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@pinata/sdk/contracts/Pinata.sol";

contract CreateBulkNFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Pinata API key and secret
    string private pinataApiKey;
    string private pinataSecretApiKey;

    // Pinata object
    Pinata private pinata;

    constructor(string memory _pinataApiKey, string memory _pinataSecretApiKey) ERC721("BulkNFT", "BNFT") {
        pinataApiKey = _pinataApiKey;
        pinataSecretApiKey = _pinataSecretApiKey;

        // Initialize Pinata object
        pinata = new Pinata({apiKey: pinataApiKey, apiSecret: pinataSecretApiKey});
    }

    function mintBulkNFT(uint256 numNFTs, string[] calldata metadata) public {
        require(numNFTs > 0, "Number of NFTs must be greater than 0");

        for (uint256 i = 0; i < numNFTs; i++) {
            _tokenIds.increment();
            uint256 newTokenId = _tokenIds.current();

            // Mint new NFT
            _mint(msg.sender, newTokenId);

            // Upload metadata to IPFS using Pinata
            bytes memory metadataBytes = bytes(metadata[i]);
            (bool success, bytes memory result) = pinata.pinJSONToIPFS(msg.sender, metadataBytes);
            require(success, "Failed to upload metadata to Pinata");
            string memory ipfsHash = abi.decode(result, (string));

            emit MetadataUploaded(msg.sender, newTokenId, ipfsHash);
        }
    }

    event MetadataUploaded(address indexed owner, uint256 indexed tokenId, string ipfsHash);
}
