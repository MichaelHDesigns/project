pragma solidity ^0.8.0;

import "./Profile.sol";
import "./AuthToken.sol";

contract Dashboard {
    AuthToken public authToken;
    Profile public profile;

    constructor(address _authToken, address _profile) {
        authToken = AuthToken(_authToken);
        profile = Profile(_profile);
    }

    function viewProfile() external view returns (string memory, address, uint256, string memory) {
        require(authToken.balanceOf(msg.sender) > 0, "Not authenticated");
        return profile.viewProfile(msg.sender);
    }
}
