import { useState } from "react";
import { ethers } from "ethers";
import CreateNFT from "../abis/CreateNFT.json";
import "./CreateNFTPage.css";

const CONTRACT_ADDRESS = process.env.REACT_APP_CONTRACT_ADDRESS;
const pinataApiUrl = "https://api.pinata.cloud/pinning/pinJSONToIPFS";

function CreateNFTPage() {
  const [apiKey, setApiKey] = useState("");
  const [secretApiKey, setSecretApiKey] = useState("");
  const [tokenURIs, setTokenURIs] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [metadataHash, setMetadataHash] = useState("");

  const provider = new ethers.providers.Web3Provider(window.ethereum);
  const contract = new ethers.Contract(CONTRACT_ADDRESS, CreateNFT.abi, provider.getSigner());

  const handleCreateNFT = async () => {
    setLoading(true);
    setError("");

    try {
      let pinataResponseJson;

      if (tokenURIs.length === 1) {
        const metadata = await contract.generateMetadata(tokenURIs[0]);
        pinataResponseJson = await pinJSONToIPFS(metadata);
      } else if (tokenURIs.length > 1) {
        const metadata = await contract.generateMetadataForMultiple(tokenURIs);
        pinataResponseJson = await pinJSONToIPFS(metadata);
      } else {
        throw new Error("Token URIs cannot be empty");
      }

      if (!pinataResponseJson.IpfsHash) {
        throw new Error("Error uploading metadata to Pinata");
      }

      setMetadataHash(pinataResponseJson.IpfsHash);
    } catch (error) {
      setError(error.message);
    }

    setLoading(false);
  };

  const pinJSONToIPFS = async (json) => {
    const response = await fetch(pinataApiUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        pinata_api_key: apiKey,
        pinata_secret_api_key: secretApiKey,
      },
      body: JSON.stringify(json),
    });

    return response.json();
  };

  return (
    <div>
      <h1>Create NFT</h1>
      <div>
        <label htmlFor="apiKey">Pinata API Key:</label>
        <input id="apiKey" type="text" value={apiKey} onChange={(e) => setApiKey(e.target.value)} />
      </div>
      <div>
        <label htmlFor="secretApiKey">Pinata Secret API Key:</label>
        <input id="secretApiKey" type="text" value={secretApiKey} onChange={(e) => setSecretApiKey(e.target.value)} />
      </div>
      <div>
        <label htmlFor="tokenURIs">Token URIs:</label>
        <textarea id="tokenURIs" value={tokenURIs.join("\n")} onChange={(e) => setTokenURIs(e.target.value.split("\n"))} />
      </div>
      {loading ? (
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
