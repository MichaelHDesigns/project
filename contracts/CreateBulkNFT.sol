// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@nomiclabs/buidler/console.sol";
import CreateBulkNFT from './contracts/CreateBulkNFT.sol';
import Web3 from 'web3';

// Import Pinata SDK for uploading files to IPFS

contract CreateBulkNFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Pinata API key and secret
    string private pinataApiKey;
    string private pinataSecretApiKey;

    // Pinata SDK object
    Pinata private pinata;

    constructor(string memory _pinataApiKey, string memory _pinataSecretApiKey) ERC721("BulkNFT", "BNFT") {
        pinataApiKey = _pinataApiKey;
        pinataSecretApiKey = _pinataSecretApiKey;

        pinata = new Pinata();
    }

    function mintBulkNFT(uint256 numNFTs, string[] calldata metadata) public {
        require(numNFTs > 0, "Number of NFTs must be greater than 0");

        for (uint256 i = 0; i < numNFTs; i++) {
            _tokenIds.increment();
            uint256 newTokenId = _tokenIds.current();

            // Mint new NFT
            _mint(msg.sender, newTokenId);

            // Upload metadata to IPFS using Pinata
            string memory ipfsHash = pinata.pinJSONToIPFS(msg.sender, pinataApiKey, pinataSecretApiKey, metadata[i]);
            emit MetadataUploaded(msg.sender, newTokenId, ipfsHash);
        }
    }

    event MetadataUploaded(address indexed owner, uint256 indexed tokenId, string ipfsHash);
}
