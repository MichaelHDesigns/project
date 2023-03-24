// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CreateNFT.sol";

contract CreateNFT {
    CreateNFT private nft;

    constructor(address nftAddress) {
        nft = CreateNFT(nftAddress);
    }

    function getOwnedTokens() external view returns (uint256[] memory) {
        return nft.tokensOfOwner(msg.sender);
    }

    function tokenIdsOwnedByOwner(address owner) external view returns (uint256[] memory) {
        uint256[] memory tokenIds = nft.tokensOfOwner(owner);
        uint256 count = 0;

        for (uint256 i = 0; i < tokenIds.length; i++) {
            if (nft.ownerOf(tokenIds[i]) == owner) {
                count++;
            }
        }

        uint256[] memory result = new uint256[](count);
        count = 0;

        for (uint256 i = 0; i < tokenIds.length; i++) {
            if (nft.ownerOf(tokenIds[i]) == owner) {
                result[count] = tokenIds[i];
                count++;
            }
        }

        return result;
    }

    struct TokenDetails {
        string uri;
        uint256 price;
        bool forSale;
    }

    function getTokenDetails(uint256 tokenId) external view returns (TokenDetails memory) {
        return nft.getTokenDetails(tokenId);
    }

    function getContractAddress() external view returns (address) {
        return address(nft);
    }
}
