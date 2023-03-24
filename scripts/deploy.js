const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  // Deploy Create_Account contract
  const accountFactory = await ethers.getContractFactory("Create_Account");
  const account = await accountFactory.deploy();
  await account.deployed();
  console.log("Create_Account deployed to:", account.address);

  // Deploy other contracts that depend on Create_Account
  const tokenFactory = await ethers.getContractFactory("AuthToken");
  const token = await tokenFactory.deploy();
  await token.deployed();
  console.log("AuthToken deployed to:", token.address);

  const profileFactory = await ethers.getContractFactory("Profile");
  const profile = await profileFactory.deploy(account.address);
  await profile.deployed();
  console.log("Profile deployed to:", profile.address);

  const dashboardFactory = await ethers.getContractFactory("Dashboard");
  const dashboard = await dashboardFactory.deploy(account.address);
  await dashboard.deployed();
  console.log("Dashboard deployed to:", dashboard.address);

  const nftFactory = await ethers.getContractFactory("CreateNFT");
  const nft = await nftFactory.deploy(account.address);
  await nft.deployed();
  console.log("CreateNFT deployed to:", nft.address);

  const marketplaceFactory = await ethers.getContractFactory("Marketplace");
  const marketplace = await marketplaceFactory.deploy(account.address, token.address);
  await marketplace.deployed();
  console.log("Marketplace deployed to:", marketplace.address);

  const editprofileFactory = await ethers.getContractFactory("ProfileEditor");
  const editprofile = await editprofileFactory.deploy(account.address, token.address);
  await editprofile.deployed();
  console.log("ProfileEditor deployed to:", editprofile.address);

  const loginFactory = await ethers.getContractFactory("Login");
  const login = await loginFactory.deploy(account.address, token.address);
  await login.deployed();
  console.log("Login deployed to:", login.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
