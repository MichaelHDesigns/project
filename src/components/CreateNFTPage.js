import React, { useState } from 'react';
import { SimpleNFTContract, MultiNFTContract, CollectionNFTContract } from './contracts';
import PinataUpload from './components/PinataUpload';
import './src/css/CreateNFTPage.css';
import Web3 from 'web3';

// code that uses Web3 library goes here

function CreateNFTPage() {
  const [contractType, setContractType] = useState("simple");
  const [pinataApi, setPinataApi] = useState("");
  const [pinataSecret, setPinataSecret] = useState("");
  const [metadata, setMetadata] = useState("");

  const handleCreateNFT = async () => {
    if (contractType === "simple") {
      await SimpleNFTContract(pinataApi, pinataSecret, metadata);
    } else if (contractType === "multi") {
      await MultiNFTContract(pinataApi, pinataSecret, metadata);
    } else if (contractType === "collection") {
      await CollectionNFTContract(pinataApi, pinataSecret, metadata);
    }
  };

  return (
    <div>
      <h1>Create NFT</h1>
      <select value={contractType} onChange={(e) => setContractType(e.target.value)}>
        <option value="simple">Simple NFT</option>
        <option value="multi">Multi NFT</option>
        <option value="collection">Collection NFT</option>
      </select>
      <PinataUpload onApiChange={setPinataApi} onSecretChange={setPinataSecret} onMetadataChange={setMetadata} />
      <button onClick={handleCreateNFT}>Create NFT</button>
    </div>
  );
}

export default CreateNFTPage;
