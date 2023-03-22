import React, { useState } from "react";
import { CreateSingleNFT, CreateBulkNFT, CreateCollectionNFT } from "./contracts";
import PinataUpload from "./components/PinataUpload";
import './src/css/CreateNFTPage.css';

function CreateNFTPage() {
  const [contractType, setContractType] = useState("single");
  const [pinataApi, setPinataApi] = useState("");
  const [pinataSecret, setPinataSecret] = useState("");
  const [metadata, setMetadata] = useState("");

  const handleCreateNFT = async () => {
    if (contractType === "single") {
      await CreateSingleNFT(pinataApi, pinataSecret, metadata);
    } else if (contractType === "bulk") {
      await CreateBulkNFT(pinataApi, pinataSecret, metadata);
    } else if (contractType === "collection") {
      await CreateCollectionNFT(pinataApi, pinataSecret, metadata);
    }
  };

  return (
    <div>
      <h1>Create NFT</h1>
      <select value={contractType} onChange={(e) => setContractType(e.target.value)}>
        <option value="single">Single NFT</option>
        <option value="bulk">Bulk NFT</option>
        <option value="collection">NFT Collection</option>
      </select>
      <PinataUpload onApiChange={setPinataApi} onSecretChange={setPinataSecret} onMetadataChange={setMetadata} />
      <button onClick={handleCreateNFT}>Create NFT</button>
    </div>
  );
}

export default CreateNFTPage;
