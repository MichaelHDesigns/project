import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { ethers } from 'ethers';
import EditProfile from './EditProfile';
import axios from 'axios';

const Profile = ({ address, setLoggedIn }) => {
  const [profileImage, setProfileImage] = useState('');
  const [name, setName] = useState('');
  const [bio, setBio] = useState('');

  useEffect(() => {
    const loadProfile = async () => {
      try {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(process.env.REACT_APP_PROFILE_ADDRESS, process.env.REACT_APP_PROFILE_ABI, signer);

        const profile = await contract.getProfile(address);

        setProfileImage(profile.profileImageHash);
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
        const contract = new ethers.Contract(process.env.REACT_APP_PROFILE_ADDRESS, process.env.REACT_APP_PROFILE_ABI, signer);

        await contract.burnSAT();
        alert('Your SAT has been burned successfully.');
      } catch (err) {
        console.error(err);
        alert('An error occurred while burning your SAT.');
      }
    }
  };

  const handleProfileImageUpload = async (e) => {
    try {
      const file = e.target.files[0];
      const formData = new FormData();
      formData.append('file', file);

      const response = await axios.post('https://api.pinata.cloud/pinning/pinFileToIPFS', formData, {
        maxContentLength: 'Infinity',
        headers: {
          'Content-Type': `multipart/form-data; boundary=${formData._boundary}`,
          'pinata_api_key': process.env.REACT_APP_PINATA_API_KEY,
          'pinata_secret_api_key': process.env.REACT_APP_PINATA_SECRET_API_KEY
        }
      });

      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(process.env.REACT_APP_PROFILE_ADDRESS, process.env.REACT_APP_PROFILE_ABI, signer);

      await contract.setProfileImage(response.data.IpfsHash);

      setProfileImage(response.data.IpfsHash);
    } catch (err) {
      console.error(err);
      alert('An error occurred while uploading your profile image.');
    }
  };

  return (
    <>
      <div>
        <h2>Profile</h2>
        <p>This is your profile page.</p>
        <Link to="/editprofile"><button>Edit Profile</button></Link>
      </div>
      <div>
        <img src={`https://gateway.pinata.cloud/ipfs/${profileImage}`} alt="Profile" />
        <h1>{name}</h1>
        <p>{bio}</p>
        <button onClick={handleBurnSAT}>Burn SAT</button>
        <div>
          <input type="file" onChange={handleProfileImageUpload} />
        </div>
      </div>
      <div>
        <EditProfile setLoggedIn={setLoggedIn} />
      </div>
    </>
  );
};

export default Profile;
