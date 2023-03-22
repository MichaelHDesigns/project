// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Profile.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Edit_Profile {
    Profile public profileContract;
    
    constructor(Profile _profileContract) {
        profileContract = _profileContract;
    }
    
    function updateName(string memory newName) public {
        profileContract.updateName(newName);
    }
    
    function updateBio(string memory newBio) public {
        profileContract.updateBio(newBio);
    }
    
    function updateProfileImage(address nftContract, uint256 tokenId) public {
        require(IERC721(nftContract).ownerOf(tokenId) == msg.sender, "You don't own this NFT.");
        string memory ipfsHash = IERC721Metadata(nftContract).tokenURI(tokenId);
        profileContract.updateProfileImage(ipfsHash);
    }
}
