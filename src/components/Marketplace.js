import React, { useState } from 'react';
import { Marketplace } from './contracts/Marketplace.sol';
import './src/css/Marketplace.css';

function MarketplacePage() {
  const [tokenId, setTokenId] = useState("");
  const [price, setPrice] = useState("");

  const handleListNFT = async () => {
    await Marketplace.listNFT(tokenId, price);
  };

  const handleUnlistNFT = async () => {
    await Marketplace.unlistNFT(tokenId);
  };

  const handleBuyNFT = async () => {
    await Marketplace.buyNFT(tokenId, { value: price });
  };

  const handleGetListing = async () => {
    const listing = await Marketplace.getListing(tokenId);
    console.log(listing);
  };

  return (
    <div>
      <h1>Marketplace</h1>
      <label>Token ID:</label>
      <input type="text" value={tokenId} onChange={(e) => setTokenId(e.target.value)} />
      <label>Price:</label>
      <input type="text" value={price} onChange={(e) => setPrice(e.target.value)} />
      <button onClick={handleListNFT}>List NFT</button>
      <button onClick={handleUnlistNFT}>Unlist NFT</button>
      <button onClick={handleBuyNFT}>Buy NFT</button>
      <button onClick={handleGetListing}>Get Listing</button>
    </div>
  );
}

export default MarketplacePage;
