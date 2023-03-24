const { ethers } = require("hardhat");
const fs = require("fs");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  // Deploy Create_Account contract
  const account = await ethers.getContractFactory("Create_Account").deploy();

  console.log("Create_Account deployed to:", account.address);

  // Deploy other contracts that depend on Create_Account
  const token = await ethers.getContractFactory("AuthToken").deploy();

  console.log("AuthToken deployed to:", token.address);

  const profile = await ethers.getContractFactory("Profile")
    .deploy(account.address);

  console.log("Profile deployed to:", profile.address);

  const dashboard = await ethers.getContractFactory("Dashboard")
    .deploy(account.address);

  console.log("Dashboard deployed to:", dashboard.address);

  const marketplace = await ethers.getContractFactory("Marketplace")
    .deploy(account.address, token.address);

  console.log("Marketplace deployed to:", marketplace.address);

  const editprofile = await ethers.getContractFactory("ProfileEditor")
    .deploy(account.address, token.address);

  console.log("ProfileEditor deployed to:", editprofile.address);

  const login = await ethers.getContractFactory("Login")
    .deploy(account.address, token.address);

  console.log("Login deployed to:", login.address);

  // Deploy SingleMint contract
  const singleMint = await ethers.getContractFactory("SingleMint")
    .deploy(account.address);

  console.log("SingleMint deployed to:", singleMint.address);

  // Deploy BulkMint contract
  const bulkMint = await ethers.getContractFactory("BulkMint")
    .deploy(account.address);

  console.log("BulkMint deployed to:", bulkMint.address);

  // Deploy Collections contract
  const collections = await ethers.getContractFactory("Collections")
    .deploy(account.address);

  console.log("Collections deployed to:", collections.address);

  // Write addresses to .env file
  fs.writeFileSync(".env", `REACT_APP_ACCOUNT_ADDRESS=${account.address}\n`);
  fs.appendFileSync(".env", `REACT_APP_TOKEN_ADDRESS=${token.address}\n`);
  fs.appendFileSync(".env", `REACT_APP_PROFILE_ADDRESS=${profile.address}\n`);
  fs.appendFileSync(".env", `REACT_APP_DASHBOARD_ADDRESS=${dashboard.address}\n`);
  fs.appendFileSync(".env", `REACT_APP_MARKETPLACE_ADDRESS=${marketplace.address}\n`);
  fs.appendFileSync(".env", `REACT_APP_PROFILE_EDITOR_ADDRESS=${editprofile.address}\n`);
  fs.appendFileSync(".env", `REACT_APP_LOGIN_ADDRESS=${login.address}\n`);
  fs.appendFileSync(".env", `REACT_APP_SINGLE_MINT_ADDRESS=${singleMint.address}\n`);
  fs.appendFileSync(".env", `REACT_APP_BULK_MINT_ADDRESS=${bulkMint.address}\n`);
  fs.appendFileSync(".env", `REACT_APP_COLLECTIONS_ADDRESS=${collections.address}\n`);
}

main()
  .then(() => {
    console.log("Contract deployment successful.");
    process.exit(0);
  })
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
