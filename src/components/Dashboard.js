import React, { useState, useEffect } from 'react';
import { ethers } from 'ethers';
import Dashboard from '../contracts/Dashboard.sol';
import './Dashboard.css';

function DashboardComponent(props) {
  const [dashboardContract, setDashboardContract] = useState(null);
  const [userAddress, setUserAddress] = useState('');
  const [userName, setUserName] = useState('');
  const [userEmail, setUserEmail] = useState('');
  const [userBio, setUserBio] = useState('');
  const [profileImageUrl, setProfileImageUrl] = useState('');

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
        const result = await dashboardContract.viewProfile();
        setUserAddress(result[0]);
        setUserName(result[1]);
        setUserEmail(result[2]);
        setUserBio(result[3]);
        setProfileImageUrl(result[4]);
      }
    }
    fetchUserProfile();
  }, [dashboardContract]);

  return (
    <div>
      <h1>Welcome to your Dashboard, {userName}!</h1>
      <p>Address: {userAddress}</p>
      <p>Email: {userEmail}</p>
      <p>Bio: {userBio}</p>
      <img src={profileImageUrl} alt="Profile" />
    </div>
  );
}

export default DashboardComponent;
