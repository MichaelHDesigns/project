import React, { useState } from 'react';
import { Redirect } from 'react-router-dom';
import { getWeb3, getSingleMint } from '../utils/getWeb3';
import AuthToken from '../contracts/AuthToken.sol';
import './Login.css';

const Login = ({ setLoggedIn }) => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  const handleLogin = async (e) => {
    e.preventDefault();
    try {
      const web3 = await getWeb3();
      const singleMint = await getSingleMint(web3);
      const accounts = await web3.eth.getAccounts();
      const auth = new web3.eth.Contract(AuthToken.abi, AuthToken.address);
      const loginResult = await auth.methods.login(email, password).send({ from: accounts[0] });
      if (loginResult.status) {
        setLoggedIn(true);
      } else {
        setError("Invalid email or password");
      }
    } catch (error) {
      setError("Error while logging in");
      console.log(error);
    }
  };

  if (localStorage.getItem("authToken")) {
    return <Redirect to="/dashboard" />;
  }

  return (
    <div className="login-container">
      <h2>Login</h2>
      <form onSubmit={handleLogin}>
        <label htmlFor="email">Email:</label>
        <input type="email" id="email" value={email} onChange={(e) => setEmail(e.target.value)} required />

        <label htmlFor="password">Password:</label>
        <input type="password" id="password" value={password} onChange={(e) => setPassword(e.target.value)} required />

        <button type="submit">Login</button>
      </form>

      {error && <p className="error">{error}</p>}
    </div>
  );
};

export default Login;
