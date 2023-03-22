import React, { useState, useEffect } from "react";
import { ethers } from "ethers";
import EditProfile from "./contracts/Edit_Profile.json";

const EditProfileForm = ({ provider, signer, address }) => {
  const [newName, setNewName] = useState("");
  const [newBio, setNewBio] = useState("");
  const [newImageHash, setNewImageHash] = useState("");
  const [contractAddress, setContractAddress] = useState("");
  const [contractAbi, setContractAbi] = useState([]);
  const [contractInstance, setContractInstance] = useState(null);

  useEffect(() => {
    const init = async () => {
      // Load contract address and ABI
      const network = await provider.getNetwork();
      const contractNetworks = EditProfile.networks;
      const deployedNetwork = contractNetworks[network.chainId.toString()];
      setContractAddress(deployedNetwork.address);
      setContractAbi(EditProfile.abi);

      // Initialize contract instance
      const instance = new ethers.Contract(
        deployedNetwork.address,
        EditProfile.abi,
        signer
      );
      setContractInstance(instance);

      // Load user profile data
      const profile = await instance.getProfile(address);
      setNewName(profile[0]);
      setNewBio(profile[1]);
      setNewImageHash(profile[2]);
    };

    init();
  }, [provider, signer, address]);

  const handleNameChange = (event) => {
    setNewName(event.target.value);
  };

  const handleBioChange = (event) => {
    setNewBio(event.target.value);
  };

  const handleImageHashChange = (event) => {
    setNewImageHash(event.target.value);
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    const tx = await contractInstance.editProfile(newName, newBio, newImageHash);
    await tx.wait();
  };

  return (
    <div>
      <h2>Edit Profile</h2>
      <form onSubmit={handleSubmit}>
        <div>
          <label htmlFor="name">Name:</label>
          <input
            type="text"
            id="name"
            value={newName}
            onChange={handleNameChange}
          />
        </div>
        <div>
          <label htmlFor="bio">Bio:</label>
          <textarea
            id="bio"
            value={newBio}
            onChange={handleBioChange}
          ></textarea>
        </div>
        <div>
          <label htmlFor="imageHash">Profile Image IPFS Hash:</label>
          <input
            type="text"
            id="imageHash"
            value={newImageHash}
            onChange={handleImageHashChange}
          />
        </div>
        <button type="submit">Save Changes</button>
      </form>
    </div>
  );
};

export default EditProfileForm;
