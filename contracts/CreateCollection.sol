// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import CreateCollection from './contracts/CreateCollection.sol';
import Web3 from 'web3';


interface IPinata {
    function pinJSONToIPFS(
        string memory _json,
        bytes memory _pinataMetadata
    ) external returns (string memory);
}

contract CreateCollection is ERC721, Ownable {
    IPinata private pinata;

    struct NFTMetadata {
        string name;
        string description;
        string imageURI;
    }

    mapping(uint256 => NFTMetadata) private _tokenMetadata;

    constructor(string memory name, string memory symbol, address _pinata) ERC721(name, symbol) {
        pinata = IPinata(_pinata);
    }

    function setPinata(address _pinata) external onlyOwner {
        pinata = IPinata(_pinata);
    }

    function mint(address to, uint256 tokenId) external onlyOwner {
        _safeMint(to, tokenId);
    }

    function setTokenMetadata(uint256 tokenId, NFTMetadata memory metadata) external onlyOwner {
        _tokenMetadata[tokenId] = metadata;
    }

    function getTokenMetadata(uint256 tokenId) external view returns (NFTMetadata memory) {
        return _tokenMetadata[tokenId];
    }

    function mintNFTCollection(
        address to,
        uint256[] memory tokenIds,
        NFTMetadata[] memory metadatas,
        string[] memory pinataApiKeys,
        bytes[] memory pinataSecretApiKeys,
        bytes[] memory pinataMetadata
    ) external onlyOwner {
        require(tokenIds.length == metadatas.length, "TokenId and metadata array length mismatch");
        require(pinataApiKeys.length == pinataSecretApiKeys.length && pinataApiKeys.length == pinataMetadata.length, "Invalid Pinata API keys or metadata");
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _safeMint(to, tokenIds[i]);
            _tokenMetadata[tokenIds[i]] = metadatas[i];
            string memory metadataJson = generateMetadataJson(tokenIds[i], metadatas[i]);
            string memory ipfsHash = pinata.pinJSONToIPFS(metadataJson, pinataMetadata[i]);
            _tokenMetadata[tokenIds[i]].imageURI = ipfsHash;
        }
    }

    function generateMetadataJson(uint256 tokenId, NFTMetadata memory metadata) private pure returns (string memory) {
        return string(abi.encodePacked('{"name": "', metadata.name, '", "description": "', metadata.description, '", "image": "', metadata.imageURI, '", "tokenId": ', tokenId.toString(), '}'));
    }
}
