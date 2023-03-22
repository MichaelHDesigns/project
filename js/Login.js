import React, { useState } from "react";
import Web3 from "web3";
import AuthToken from "./contracts/AuthToken.json";
import './src/css/Login.css';


function Login() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [loggedIn, setLoggedIn] = useState(false);

  async function handleLogin() {
    setLoading(true);
    setError("");

    try {
      const web3 = new Web3(Web3.givenProvider || "http://localhost:8545");
      const accounts = await web3.eth.getAccounts();

      const networkId = await web3.eth.net.getId();
      const deployedNetwork = AuthToken.networks[networkId];
      const contract = new web3.eth.Contract(
        AuthToken.abi,
        deployedNetwork && deployedNetwork.address
      );

      await contract.methods.login().send({ from: accounts[0] });

      setLoggedIn(true);
    } catch (error) {
      setError(error.message);
    } finally {
      setLoading(false);
    }
  }

  if (loggedIn) {
    return <div>You are logged in!</div>;
  }

  return (
    <div className="login-container">
      <h1>My Dapp Login</h1>
      <button onClick={handleLogin} disabled={loading}>
        {loading ? "Loading..." : "Log In"}
      </button>
      {error && <div className="error">{error}</div>}
    </div>
  );
}

export default Login;
