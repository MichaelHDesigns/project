// SPDX-License-Identifier: GPL-3.0-only

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Collections is Ownable {
    using Strings for uint256;

    struct NFT {
        address contractAddress;
        uint256 tokenId;
        string description;
    }

    mapping(address => mapping(uint256 => NFT[])) private collections;

    function addNFT(address _contractAddress, uint256 _tokenId, string memory _description) external {
        require(_contractAddress != address(0), "Collections: contract address is zero");
        require(IERC721(_contractAddress).ownerOf(_tokenId) == msg.sender, "Collections: not owner of token");

        collections[msg.sender][_tokenId].push(NFT({
            contractAddress: _contractAddress,
            tokenId: _tokenId,
            description: _description
        }));
    }

    function getNFTs(address _userAddress, uint256 _tokenId) external view returns (NFT[] memory) {
        return collections[_userAddress][_tokenId];
    }

    function setBaseURI(string memory _baseURI) external onlyOwner {
        _setBaseURI(_baseURI);
    }

    function tokenURI(address _contractAddress, uint256 _tokenId) external view returns (string memory) {
        require(_contractAddress != address(0), "Collections: contract address is zero");
        require(collections[msg.sender][_tokenId].length > 0, "Collections: no NFTs in collection");

        return string(abi.encodePacked(_baseURI(), _contractAddress, "/", _tokenId.toString(), ".json"));
    }
}
