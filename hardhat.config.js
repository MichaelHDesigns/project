require("@nomiclabs/hardhat-ethers");

module.exports = {
  networks: {
    altcoinchain: {
      url: "https://rpc0.altcoinchain.org/rpc",
      chainId: 2330,
      accounts: [
        "0x75977130c549b04599bd654612e82519f7227d0ed6ea9e45670708d71d5789f6"
      ],
      gas: "auto"
    }
  },
  solidity: {
    version: "0.8.9",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
};