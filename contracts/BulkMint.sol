// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@thirdweb/ethereum-contracts/contracts/tokens/nf-token-metadata.sol";
import "@thirdweb/ethereum-contracts/contracts/tokens/nf-token-metadata-enumerable.sol";
import "@thirdweb/ethereum-contracts/contracts/utils/strings.sol";

contract BulkNFT is NFTokenMetadataEnumerable {
    using Strings for uint256;

    address private admin;
    string private baseURI;

    event BulkMinted(uint256[] tokenIds);

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseURI
    ) {
        nftName = _name;
        nftSymbol = _symbol;
        baseURI = _baseURI;
        admin = msg.sender;
    }

    function bulkMint(
        address _to,
        uint256 _numberOfTokens,
        string[] memory _tokenURIs
    ) external {
        require(msg.sender == admin, "Only admin can call this function");
        require(
            _numberOfTokens > 0 && _numberOfTokens == _tokenURIs.length,
            "Invalid number of tokens"
        );

        uint256[] memory tokenIds = new uint256[](_numberOfTokens);

        for (uint256 i = 0; i < _numberOfTokens; i++) {
            uint256 tokenId = totalSupply() + 1;
            tokenIds[i] = tokenId;
            _mint(_to, tokenId);
            _setTokenUri(tokenId, _tokenURIs[i]);
        }

        emit BulkMinted(tokenIds);
    }

    function setBaseURI(string memory _baseURI_) external {
        require(msg.sender == admin, "Only admin can call this function");
        baseURI = _baseURI_;
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(exists(_tokenId), "Token does not exist");
        return string(abi.encodePacked(baseURI, _tokenId.toString()));
    }
}
