import { useState } from "react";
import CreateNFT from "../contracts/CreateNFT.sol";
import './CreateNFTPage.css';


function CreateNFTPage() {
  const [pinataApiKey, setPinataApiKey] = useState("");
  const [pinataSecretApiKey, setPinataSecretApiKey] = useState("");
  const [metadataHash, setMetadataHash] = useState("");
  const [tokenURIs, setTokenURIs] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState("");

  const handleCreateNFT = async () => {
    setIsLoading(true);
    setError("");

    const contract = new web3.eth.Contract(CreateNFT.abi, "YOUR_CONTRACT_ADDRESS");
    const account = (await web3.eth.getAccounts())[0];

    try {
      await contract.methods.bulkMintNFT(account, tokenURIs).send({ from: account });
      const metadata = contract.methods.generateMetadata(tokenURIs).call();
      await contract.methods.uploadMetadataToPinata(metadata, pinataApiKey, pinataSecretApiKey).send({ from: account, value: web3.utils.toWei("0.1", "ether") });
      const contentHash = await contract.methods.getContentHash().call();
      setMetadataHash(contentHash);
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
