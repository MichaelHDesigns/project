import React, { useState, useEffect } from 'react';
import { ethers } from 'ethers';
import ProfileContract from './contracts/Profile.sol';

const Profile = ({ address }) => {
  const [profileImage, setProfileImage] = useState('');
  const [name, setName] = useState('');
  const [bio, setBio] = useState('');

  useEffect(() => {
    const loadProfile = async () => {
      try {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(ProfileContract.address, ProfileContract.abi, signer);

        const profile = await contract.getProfile(address);

        setProfileImage(profile.profileImage);
        setName(profile.name);
        setBio(profile.bio);
      } catch (err) {
        console.error(err);
      }
    };

    loadProfile();
  }, [address]);

  const handleBurnSAT = async () => {
    if (window.confirm('Are you sure you want to burn your SAT? This action cannot be undone.')) {
      try {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(ProfileContract.address, ProfileContract.abi, signer);

        await contract.burnSAT();
        alert('Your SAT has been burned successfully.');
      } catch (err) {
        console.error(err);
        alert('An error occurred while burning your SAT.');
      }
    }
  };

  return (
    <div>
      <img src={`https://ipfs.io/ipfs/${profileImage}`} alt="Profile" />
      <h1>{name}</h1>
      <p>{bio}</p>
      <button onClick={handleBurnSAT}>Burn SAT</button>
    </div>
  );
};

export default Profile;
