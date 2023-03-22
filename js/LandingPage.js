import React from 'react';
import { Link } from 'react-router-dom';

const LandingPage = () => {
  return (
    <div>
      <h1>Welcome to My Dapp</h1>
      <p>My Dapp is a decentralized application that allows users to create and manage their own profiles and connect with others.</p>
      <Link to="/login">Log In</Link>
      <Link to="/signup">Sign Up</Link>
    </div>
  );
};

export default LandingPage;
