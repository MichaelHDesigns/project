const hre = require("hardhat");

const account = '0x114A612929c451417E28F0Bf9Af3C77c39fd1499';

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const tokenFactory = await hre.ethers.getContractFactory("AuthToken");
  const token = await tokenFactory.deploy();
  
  const loginFactory = await hre.ethers.getContractFactory("Login");
  const login = await loginFactory.deploy(account.address);

  const accountFactory = await hre.ethers.getContractFactory("Create_Account");
  const account = await accountFactory.deploy(login.address, profile.address);
  
  const profileFactory = await hre.ethers.getContractFactory("Profile");
  const profile = await profileFactory.deploy(account.address);

  const nftFactory = await hre.ethers.getContractFactory("CreateNFT");
  const nft = await nftFactory.deploy(100, ethers.utils.parseEther("1"));

  const dashboardFactory = await hre.ethers.getContractFactory("Dashboard");
  const dashboard = await dashboardFactory.deploy(account.address);

  const marketplaceFactory = await hre.ethers.getContractFactory("Marketplace");
  const marketplace = await marketplaceFactory.deploy(account.address, token.address);

  const editprofileFactory = await hre.ethers.getContractFactory("ProfileEditor");
  const editprofile = await editprofileFactory.deploy(account.address, token.address);

  await token.deployed();
  await login.deployed();
  await account.deployed();
  await profile.deployed();
  await nft.deployed();
  await dashboard.deployed();
  await marketplace.deployed();
  await editprofile.deployed();

  console.log("Token deployed to:", token.address);
  console.log("Login deployed to:", login.address);
  console.log("CreateAccount deployed to:", account.address);
  console.log("Profile deployed to:", profile.address);
  console.log("CreateNFT deployed to:", nft.address);
  console.log("Dashboard deployed to:", dashboard.address);
  console.log("Marketplace deployed to:", marketplace.address);
  console.log("ProfileEditor deployed to:", editprofile.address);
}

main().then(() => process.exit(0)).catch(error => {
  console.error(error);
  process.exit(1);
});
