// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./AuthToken.sol";

contract Profile {
    struct UserProfile {
        string name;
        string bio;
        address walletAddress;
        uint256 profileImageTokenId;
    }

    mapping(address => UserProfile) public userProfiles;

    AuthToken public authToken;

    constructor(address _authToken) {
        authToken = AuthToken(_authToken);
    }

    function updateProfile(
        string memory name,
        string memory bio,
        uint256 profileImageTokenId
    ) external {
        require(
            authToken.balanceOf(msg.sender) > 0,
            "Not authenticated"
        );

        userProfiles[msg.sender] = UserProfile({
            name: name,
            bio: bio,
            walletAddress: msg.sender,
            profileImageTokenId: profileImageTokenId
        });
    }

    function getProfile(address walletAddress)
        external
        view
        returns (
            string memory name,
            string memory bio,
            address wallet,
            uint256 profileImageTokenId
        )
    {
        UserProfile storage profile = userProfiles[walletAddress];
        name = profile.name;
        bio = profile.bio;
        wallet = profile.walletAddress;
        profileImageTokenId = profile.profileImageTokenId;
    }

    function burnSAT() external {
        require(authToken.balanceOf(msg.sender) > 0, "Not authenticated");
        require(confirmBurn(), "Burn cancelled");

        authToken.burn(authToken.balanceOf(msg.sender));
    }

    function confirmBurn() internal view returns (bool) {
        // Logic to confirm burn
        return true;
    }
}
