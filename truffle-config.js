require('dotenv').config();
const HDWalletProvider = require('@truffle/hdwallet-provider');

const mnemonic = process.env.MNEMONIC;

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "2330"
    },
  },
  compilers: {
    solc: {
      version: "0.8.0"
    }
  },
  contracts_build_directory: './build/contracts',

  plugins: [
    'truffle-plugin-verify'
  ],

  // Run deploy script
  migrations_directory: './scripts',
  migrations_file_extension: '.js'
};
