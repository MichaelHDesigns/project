// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Create_Account.sol";

contract CreateNFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    Create_Account private _createAccount;

    constructor(address createAccountAddress) ERC721("MyNFT", "NFT") {
        _createAccount = Create_Account(createAccountAddress);
    }

    function createNFT(address recipient) public returns (uint256) {
        require(_createAccount.doesAccountExist(msg.sender), "Sender does not have a registered account");
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);

        return newItemId;
    }
}
