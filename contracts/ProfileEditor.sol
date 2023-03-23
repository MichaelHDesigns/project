// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Profile.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";

contract ProfileEditor {
    Profile public profileContract;

    constructor(Profile _profileContract) {
        profileContract = _profileContract;
    }

    function updateName(string calldata newName) public {
        profileContract.setName(newName);
    }

    function updateBio(string calldata newBio) public {
        profileContract.setBio(newBio);
    }

    function updateProfileImage(address nftContract, uint256 tokenId) public {
        require(IERC721(nftContract).ownerOf(tokenId) == msg.sender, "You don't own this NFT.");
        string memory ipfsHash = IERC721Metadata(nftContract).tokenURI(tokenId);
        profileContract.setProfileImage(ipfsHash);
    }
