const HDWalletProvider = require("@truffle/hdwallet-provider");
const developmentMnemonic =
  "favorite myth child gain obvious push butter museum chunk blame evolve floor";

module.exports = {
  networks: {
    development: {
      provider: () => new HDWalletProvider(developmentMnemonic, "http://localhost:8545"),
      network_id: "2330", // Match any network id
      blockConfirmations: 1
    }
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "pragma", // Fetch exact version from solc-bin (default: truffle's version)
      settings: {
        optimizer: {
          enabled: false,
          runs: 200
        }
      }
    }
  }
};
