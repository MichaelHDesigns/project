const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  const token = await hre.ethers.getContractFactory("AuthToken").deploy();

  const factories = [
    { name: "Dashboard", args: [] },
    { name: "Create_Account", args: [token.address] },
    { name: "Edit_Profile", args: [token.address] },
    { name: "Profile", args: [token.address] },
    { name: "CreateNFT", args: [token.address] },
    { name: "Marketplace", args: [token.address] },
  ];

  for (const { name, args } of factories) {
    const contract = await hre.ethers.getContractFactory(name).deploy(...args);
    console.log(`${name} deployed to:`, contract.address);
  }
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
