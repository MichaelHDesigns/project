import { useState } from "react";
import { ethers } from "ethers";
import CreateNFT from "../abis/CreateNFT.json";

import "./CreateNFTPage.css";

const CONTRACT_ADDRESS = process.env.REACT_APP_CONTRACT_ADDRESS;

function CreateNFTPage() {
  const [pinataApiKey, setPinataApiKey] = useState("");
  const [pinataSecretApiKey, setPinataSecretApiKey] = useState("");
  const [tokenURIs, setTokenURIs] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState("");
  const [metadataHash, setMetadataHash] = useState("");

  // Set up the Ethereum provider
  const provider = new ethers.providers.Web3Provider(window.ethereum);

  // Set up the CreateNFT smart contract
  const contract = new ethers.Contract(CONTRACT_ADDRESS, CreateNFT.abi, provider.getSigner());

  const handleCreateNFT = async () => {
    setIsLoading(true);
    setError("");

    try {
      // Bulk mint the NFTs
      await contract.bulkMintNFT(tokenURIs);

      // Generate the metadata for the NFTs
      const metadata = await contract.generateMetadata(tokenURIs);

      // Upload the metadata to Pinata
      const pinataResponse = await fetch("https://api.pinata.cloud/pinning/pinJSONToIPFS", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          pinata_api_key: pinataApiKey,
          pinata_secret_api_key: pinataSecretApiKey,
        },
        body: JSON.stringify(metadata),
      });

      const pinataResponseJson = await pinataResponse.json();
      if (!pinataResponseJson.IpfsHash) {
        throw new Error("Error uploading metadata to Pinata");
      }

      // Save the metadata hash to state
      setMetadataHash(pinataResponseJson.IpfsHash);

      setIsLoading(false);
    } catch (error) {
      setIsLoading(false);
      setError(error.message);
    }
  };

  return (
    <div>
      <h1>Create NFT</h1>
      <div>
        <label htmlFor="pinataApiKey">Pinata API Key:</label>
        <input id="pinataApiKey" type="text" value={pinataApiKey} onChange={(e) => setPinataApiKey(e.target.value)} />
      </div>
      <div>
        <label htmlFor="pinataSecretApiKey">Pinata Secret API Key:</label>
        <input id="pinataSecretApiKey" type="text" value={pinataSecretApiKey} onChange={(e) => setPinataSecretApiKey(e.target.value)} />
      </div>
      <div>
        <label htmlFor="tokenURIs">Token URIs:</label>
        <textarea id="tokenURIs" value={tokenURIs.join("\n")} onChange={(e) => setTokenURIs(e.target.value.split("\n"))} />
      </div>
      {isLoading ? (
        <div>Loading...</div>
      ) : (
        <button onClick={handleCreateNFT}>Create NFT</button>
      )}
      {error && <div>{error}</div>}
      {metadataHash && <div>Metadata hash: {metadataHash}</div>}
    </div>
  );
}

export default CreateNFTPage;
