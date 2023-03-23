// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Dashboard {
    struct UserProfile {
        string name;
        string email;
        string bio;
        string profileImageUrl;
    }

    mapping(address => UserProfile) private userProfiles;

    event UserProfileUpdated(address indexed userAddress, string name, string email, string bio, string profileImageUrl);

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
}
