require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    localhost: {
      chainId: 2330,
      blockConfirmations: 1,
      allowUnlimitedContractSize: true,
    },
    hardhat: {
      chainId: 2330,
      blockConfirmations: 1,
      allowUnlimitedContractSize: true,
    },
  },
  solidity: {
    compilers: [{ version: "0.8.4", settings: {
      optimizer: {
        runs: 200,
        enabled: true
      }
    } }, { version: "0.8.17"}],
  },
  mocha: {
    timeout: 300000, // 300 seconds max
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
  gasReporter: {
    enabled: true,
    currency: "USD",
    gasPrice: 200,
    gas: 200000,
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
    player: {
      default: 1,
    },
  },
};
