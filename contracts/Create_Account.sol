// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import './Profile.sol';
import "./Login.sol";


contract Create_Account is Ownable, Pausable {
    Login public login;
    Profile public profile;

    event AccountCreated(address indexed user, string username);

    constructor(address _loginAddress, address _profileAddress) {
        login = Login(_loginAddress);
        profile = Profile(_profileAddress);
    }

    function createAccount(string memory username) external whenNotPaused {
        address user = msg.sender;
        require(login.isRegistered(user) == false, "User already exists");

        login.register(user, username);
        profile.createProfile();
        emit AccountCreated(user, username);
    }
    
    function doesAccountExist(address user) public view returns (bool) {
    return login.isRegistered(user);
}
}
