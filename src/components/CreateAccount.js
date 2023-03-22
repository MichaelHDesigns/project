import React, { useState } from "react";
import Create_Account from "../contracts/Create_Account";
import "./src/css/CreateAccount.css";

function CreateAccount() {
  const [web3, setWeb3] = useState(null);
  const [account, setAccount] = useState("");
  const [loading, setLoading] = useState(false);

  const handleCreateAccount = async () => {
    setLoading(true);
    const create_account = new web3.eth.Contract(
      Create_Account.abi,
      Create_Account.address
    );

    try {
      const accounts = await window.ethereum.enable();
      const result = await create_account.methods
        .createAccount()
        .send({ from: accounts[0] });

      setAccount(result.events.AccountCreated.returnValues.account);
      setLoading(false);
    } catch (error) {
      console.error(error);
      setLoading(false);
    }
  };

  const connectWallet = async () => {
    try {
      if (window.ethereum) {
        const web3 = new Web3(window.ethereum);
        setWeb3(web3);
        const accounts = await window.ethereum.enable();
        setAccount(accounts[0]);
      } else {
        console.log("No ethereum browser detected");
      }
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <div className="container">
      <h1>Create Account</h1>
      <button onClick={connectWallet}>Connect Wallet</button>
      <br />
      <button onClick={handleCreateAccount} disabled={!web3 || loading}>
        Create Account
      </button>
      {account && <p>New account created: {account}</p>}
    </div>
  );
}

export default CreateAccount;
