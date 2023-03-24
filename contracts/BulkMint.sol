// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CreateNFT.sol";
import "./Pinata.sol";

contract BulkMint {
    CreateNFT private nftContract;
    Pinata private pinataContract;
    address private admin;

    event BulkMinted(uint256[] tokenIds);

    constructor(address _nftAddress, address _pinataAddress) {
        nftContract = CreateNFT(_nftAddress);
        pinataContract = Pinata(_pinataAddress);
        admin = msg.sender;
    }

    function bulkMint(
        string[] memory _tokenURIs,
        address _recipient,
        string memory _pinataApiKey,
        string memory _pinataSecretApiKey
    ) external {
        require(msg.sender == admin, "Only admin can call this function");

        uint256 length = _tokenURIs.length;
        uint256[] memory tokenIds = new uint256[](length);

        for (uint256 i = 0; i < length; i++) {
            string memory tokenURI = _tokenURIs[i];
            string memory ipfsHash = pinataContract.pinJSONToIPFS(tokenURI, _pinataApiKey, _pinataSecretApiKey);
            uint256 tokenId = nftContract.createNFT(ipfsHash, _recipient);
            tokenIds[i] = tokenId;
        }

        emit BulkMinted(tokenIds);
    }
}
