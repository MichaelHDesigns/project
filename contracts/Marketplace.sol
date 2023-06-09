// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";


contract Marketplace is Ownable, ERC721Holder {
    struct Listing {
        uint256 tokenId;
        address seller;
        uint256 price;
        bool active;
    }

    mapping(uint256 => Listing) private _listings;

    event NFTListed(uint256 indexed tokenId, address indexed seller, uint256 price);
    event NFTUnlisted(uint256 indexed tokenId);
    event NFTSold(uint256 indexed tokenId, address indexed seller, address indexed buyer, uint256 price);

function ownerOf(uint256 tokenId) public view returns (address) {
    return IERC721(owner()).ownerOf(tokenId);
}


    function listNFT(uint256 tokenId, uint256 price) external {
        require(msg.sender == ownerOf(tokenId), "Marketplace: must be owner to list NFT");
        _listings[tokenId] = Listing(tokenId, msg.sender, price, true);
        emit NFTListed(tokenId, msg.sender, price);
    }

    function unlistNFT(uint256 tokenId) external {
        require(_listings[tokenId].active, "Marketplace: NFT not listed");
        require(msg.sender == _listings[tokenId].seller, "Marketplace: only seller can unlist NFT");
        delete _listings[tokenId];
        emit NFTUnlisted(tokenId);
    }

    function buyNFT(uint256 tokenId) external payable {
        require(_listings[tokenId].active, "Marketplace: NFT not listed");
        require(msg.value == _listings[tokenId].price, "Marketplace: incorrect price");
        address payable seller = payable(_listings[tokenId].seller);
        delete _listings[tokenId];
        IERC721(ownerOf(tokenId)).safeTransferFrom(_listings[tokenId].seller, msg.sender, tokenId);
        seller.transfer(msg.value);
        emit NFTSold(tokenId, seller, msg.sender, msg.value);
    }

    function getListing(uint256 tokenId) external view returns (Listing memory) {
        return _listings[tokenId];
    }
}
