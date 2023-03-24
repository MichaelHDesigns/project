 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./CreateNFT.sol";


contract Dashboard {
    struct UserProfile {
        string name;
        string email;
        string bio;
        string profileImageUrl;
    }

    mapping(address => UserProfile) private userProfiles;
    mapping(address => uint256[]) private userNfts;
    mapping(address => mapping(uint256 => uint256[])) private userNftCollections;

    event UserProfileUpdated(address indexed userAddress, string name, string email, string bio, string profileImageUrl);
    event UserNftMinted(address indexed userAddress, uint256 indexed tokenId);
    event UserNftBulkMinted(address indexed userAddress, uint256[] tokenIds);
    event UserNftCollectionCreated(address indexed userAddress, uint256 indexed collectionId, uint256[] tokenIds);

    CreateNFT private _createNft;

    constructor(address createNftAddress) {
        _createNft = CreateNFT(createNftAddress);
    }

    function updateUserProfile(string memory name, string memory email, string memory bio, string memory profileImageUrl) public {
        UserProfile storage userProfile = userProfiles[msg.sender];
        userProfile.name = name;
        userProfile.email = email;
        userProfile.bio = bio;
        userProfile.profileImageUrl = profileImageUrl;

        emit UserProfileUpdated(msg.sender, name, email, bio, profileImageUrl);
    }

    function getUserAddress() public view returns (address) {
        return msg.sender;
    }

    function getUserName() public view returns (string memory) {
        return userProfiles[msg.sender].name;
    }

    function getUserEmail() public view returns (string memory) {
        return userProfiles[msg.sender].email;
    }

    function getUserBio() public view returns (string memory) {
        return userProfiles[msg.sender].bio;
    }

    function getProfileImageUrl() public view returns (string memory) {
        return userProfiles[msg.sender].profileImageUrl;
    }

    function mintNft() public returns (uint256) {
        uint256 newItemId = _createNft.createNFT(msg.sender);
        userNfts[msg.sender].push(newItemId);

        emit UserNftMinted(msg.sender, newItemId);
        return newItemId;
    }

    function bulkMintNfts(uint256 numberOfNfts) public returns (uint256[] memory) {
        uint256[] memory tokenIds = new uint256[](numberOfNfts);
        for (uint256 i = 0; i < numberOfNfts; i++) {
            uint256 newItemId = _createNft.createNFT(msg.sender);
            userNfts[msg.sender].push(newItemId);
            tokenIds[i] = newItemId;
        }

        emit UserNftBulkMinted(msg.sender, tokenIds);
        return tokenIds;
    }

    function createNftCollection(uint256[] memory tokenIds) public returns (uint256) {
        require(tokenIds.length > 0, "At least one token id is required");
        uint256 collectionId = userNftCollections[msg.sender][tokenIds[0]].length;
        for (uint256 i = 0; i < tokenIds.length; i++) {
            require(ownerOf(tokenIds[i]) == msg.sender, "Sender does not own all tokens");
            userNftCollections[msg.sender][tokenIds[i]].push(collectionId);
        }

        emit UserNftCollectionCreated(msg.sender, collectionId, tokenIds);
        return collectionId;
    }

    function getUserNfts() public view returns (uint256[] memory) {
        return userNfts[msg.sender];
    }
}
