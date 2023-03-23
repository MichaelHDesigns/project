// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./AuthToken.sol";

contract Login is Ownable, Pausable {
    AuthToken public token;

    event UserRegistered(address indexed user, string username);

    mapping(address => string) public users;

    constructor(address _tokenAddress) {
        token = AuthToken(_tokenAddress);
    }

    function register(address user, string memory username) external whenNotPaused {
        require(bytes(users[user]).length == 0, "User already registered");

        users[user] = username;
        token.login();

        emit UserRegistered(user, username);
    }

    function isRegistered(address user) public view returns (bool) {
        return bytes(users[user]).length > 0;
    }

    function editProfile(string memory username) external whenNotPaused {
        address user = msg.sender;
        require(bytes(users[user]).length > 0, "User not registered");

        users[user] = username;
    }
}
