const hre = require("hardhat");
const fs = require("fs");

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

  console.log("Contracts deployed to:", {
    Token: token.address,
    CreateAccount: account.address,
    CreateNFT: nft.address,
    CreateBulkNFT: bulkNft.address,
    CreateCollection: collection.address,
    Marketplace: marketplace.address,
  });

  // Write contract addresses to a JSON file for later use
  const addresses = {
    token: token.address,
    account: account.address,
    nft: nft.address,
    bulkNft: bulkNft.address,
    collection: collection.address,
    marketplace: marketplace.address,
  };
  fs.writeFileSync("addresses.json", JSON.stringify(addresses, null, 2));
}

main().then(() => process.exit(0)).catch(error => {
  console.error(error);
  process.exit(1);
});
