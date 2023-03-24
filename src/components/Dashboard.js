import React, { useState, useEffect } from 'react';
import { ethers } from 'ethers';
import Dashboard from '../../Dashboard.sol';
import dashboardABI from '../abis/Dashboard.json'; // Import the ABI JSON file
import './Dashboard.css';

function DashboardComponent(props) {
  const [dashboardContract, setDashboardContract] = useState(null);
  const [userAddress, setUserAddress] = useState('');
  const [userName, setUserName] = useState('');
  const [userEmail, setUserEmail] = useState('');
  const [userBio, setUserBio] = useState('');
  const [profileImageUrl, setProfileImageUrl] = useState('');
  const [mintType, setMintType] = useState('');

  // Set up the Ethereum provider
  const provider = new ethers.providers.Web3Provider(window.ethereum);

  // Set up the Dashboard smart contract
  useEffect(() => {
    async function setupDashboardContract() {
      const signer = provider.getSigner();
      const dashboardContractAddress = process.env.REACT_APP_DASHBOARD_CONTRACT_ADDRESS; // Use environment variable
      const dashboardContract = new ethers.Contract(dashboardContractAddress, dashboardABI, signer); // Use the imported ABI JSON file
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

  // Function to mint a token
  async function mintToken() {
    if (dashboardContract) {
      let tx;
      switch (mintType) {
        case 'single':
          tx = await dashboardContract.mintSingleToken();
          break;
        case 'bulk':
          tx = await dashboardContract.mintBulkToken();
          break;
        case 'collection':
          tx = await dashboardContract.createCollection();
          break;
        default:
          return;
      }
      // Wait for the transaction to be mined
      await tx.wait();
      // Update the user's profile information
      fetchUserProfile();
    }
  }

  return (
    <div>
      <h1>Welcome to your Dashboard, {userName}!</h1>
      <p>Address: {userAddress}</p>
      <p>Email: {userEmail}</p>
      <p>Bio: {userBio}</p>
      <img src={profileImageUrl} alt="Profile" />
      <div>
        <label htmlFor="mintType">Select Token Type:</label>
        <select name="mintType" id="mintType" onChange={(e) => setMintType(e.target.value)}>
          <option value="">Select</option>
          <option value="single">Single Token</option>
          <option value="bulk">Bulk Token</option>
          <option value="collection">Collection</option>
        </select>
        <button onClick={mintToken}>Mint Token</button>
      </div>
    </div>
  );
}

export default DashboardComponent;
