const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const tokenFactory = await hre.ethers.getContractFactory("AuthToken");
  const token = await tokenFactory.deploy();

  const accountFactory = await hre.ethers.getContractFactory("Create_Account");
  const account = await accountFactory.deploy(token.address);

  const nftFactory = await hre.ethers.getContractFactory("CreateNFT");
  const nft = await nftFactory.deploy(account.address);

  const bulkNftFactory = await hre.ethers.getContractFactory("CreateBulkNFT");
  const bulkNft = await bulkNftFactory.deploy(account.address);

  const collectionFactory = await hre.ethers.getContractFactory("CreateCollection");
  const collection = await collectionFactory.deploy(account.address);

  const marketplaceFactory = await hre.ethers.getContractFactory("Marketplace");
  const marketplace = await marketplaceFactory.deploy(account.address, token.address);

  await token.deployed();
  await account.deployed();
  await nft.deployed();
  await bulkNft.deployed();
  await collection.deployed();
  await marketplace.deployed();

  console.log("Token deployed to:", token.address);
  console.log("CreateAccount deployed to:", account.address);
  console.log("CreateNFT deployed to:", nft.address);
  console.log("CreateBulkNFT deployed to:", bulkNft.address);
  console.log("CreateCollection deployed to:", collection.address);
  console.log("Marketplace deployed to:", marketplace.address);
}

main().then(() => process.exit(0)).catch(error => {
  console.error(error);
  process.exit(1);
});
