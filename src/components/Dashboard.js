
import React, { useState, useEffect } from 'react';
import { ethers } from 'ethers';
import Dashboard from '../contracts/Dashboard.sol';
import './Dashboard.css';

function DashboardComponent(props) {
  const [dashboardContract, setDashboardContract] = useState(null);
  const [userProfile, setUserProfile] = useState({});

  // Set up the Ethereum provider
  const provider = new ethers.providers.Web3Provider(window.ethereum);

  // Set up the Dashboard smart contract
  useEffect(() => {
    async function setupDashboardContract() {
      const signer = provider.getSigner();
      const dashboardContractAddress = '0x123...'; // Replace with actual contract address
      const dashboardContractABI = [{...}]; // Replace with actual contract ABI
      const dashboardContract = new ethers.Contract(dashboardContractAddress, dashboardContractABI, signer);
      setDashboardContract(dashboardContract);
    }
    setupDashboardContract();
  }, [provider]);

  // Fetch the user's profile information from the Dashboard smart contract
  useEffect(() => {
    async function fetchUserProfile() {
      if (dashboardContract) {
        const userProfile = await dashboardContract.getUserProfile();
        setUserProfile(userProfile);
      }
    }
    fetchUserProfile();
  }, [dashboardContract]);

  return (
    <div>
      <h1>Welcome to your Dashboard, {userProfile.name}!</h1>
      <p>Address: {userProfile.address}</p>
      <p>Email: {userProfile.email}</p>
      <p>Bio: {userProfile.bio}</p>
      <img src={userProfile.profileImageUrl} alt="Profile" />
    </div>
  );
}

export default DashboardComponent;
