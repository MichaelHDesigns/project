import React, { useState } from "react";
import { useWeb3React } from "@web3-react/core";
import { createCollection } from "../contracts/Collections.js";

function Collections() {
  const { account } = useWeb3React();
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");

  async function handleCreateCollection() {
    try {
      const collectionId = await createCollection(name, description);
      console.log(`Created collection with ID ${collectionId}`);
    } catch (error) {
      console.error(error);
    }
  }

  return (
    <div>
      <h1>Collections</h1>
      {account ? (
        <div>
          <h2>Create Collection</h2>
          <label>
            Name:
            <input type="text" value={name} onChange={(e) => setName(e.target.value)} />
          </label>
          <br />
          <label>
            Description:
            <textarea value={description} onChange={(e) => setDescription(e.target.value)} />
          </label>
          <br />
          <button onClick={handleCreateCollection}>Create Collection</button>
        </div>
      ) : (
        <p>Please connect your wallet to create a collection.</p>
      )}
    </div>
  );
}

export default Collections;
