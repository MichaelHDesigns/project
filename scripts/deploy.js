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

  const nft = await ethers.getContractFactory("CreateNFT")
    .deploy(account.address);

  console.log("CreateNFT deployed to:", nft.address);

  const marketplace = await ethers.getContractFactory("Marketplace")
    .deploy(account.address, token.address);

  console.log("Marketplace deployed to:", marketplace.address);

  const editprofile = await ethers.getContractFactory("ProfileEditor")
    .deploy(account.address, token.address);

  console.log("ProfileEditor deployed to:", editprofile.address);

  const login = await ethers.getContractFactory("Login")
    .deploy(account.address, token.address);

  console.log("Login deployed to:", login.address);

  // Write addresses to .env file
  fs.writeFileSync(".env", `ACCOUNT_ADDRESS=${account.address}\n`);
  fs.appendFileSync(".env", `TOKEN_ADDRESS=${token.address}\n`);
  fs.appendFileSync(".env", `PROFILE_ADDRESS=${profile.address}\n`);
  fs.appendFileSync(".env", `DASHBOARD_ADDRESS=${dashboard.address}\n`);
  fs.appendFileSync(".env", `NFT_ADDRESS=${nft.address}\n`);
  fs.appendFileSync(".env", `MARKETPLACE_ADDRESS=${marketplace.address}\n`);
  fs.appendFileSync(".env", `PROFILE_EDITOR_ADDRESS=${editprofile.address}\n`);
  fs.appendFileSync(".env", `LOGIN_ADDRESS=${login.address}\n`);
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
