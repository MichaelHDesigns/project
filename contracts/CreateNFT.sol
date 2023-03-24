// CreateNFT.sol

pragma solidity ^0.8.0;

import "./SingleMint.sol";
import "./BulkMint.sol";
import "./Collections.sol";

contract CreateNFT {
  SingleMint private singleMint;

  constructor(address _singleMintAddress) {
    singleMint = SingleMint(_singleMintAddress);
  }

  function mintSingle(address _to, uint256 _tokenId) external {
    singleMint.mintSingle(_to, _tokenId);
  }
}
