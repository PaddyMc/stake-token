var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "Your mnemonic here...";

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*"
    },

    rinkbey: {
      provider: () => { 
        return new HDWalletProvider(mnemonic, 'https://rinkeby.infura.io/<token>') 
      },
      network_id: '4',
      gas: 4500000,
      gasPrice: 10000000000,
    },

    ropsten: {
      provider: () =>
        new HDWalletProvider(mnemonic, "https://ropsten.infura.io/<token>"),
        network_id: '3',
        gas: 4500000,
        gasPrice: 10000000000,
    },

    kovan: {
      provider: () =>
        new HDWalletProvider(mnemonic, "https://kovan.infura.io/<token>"),
        network_id: '42',
        gas: 4500000,
        gasPrice: 10000000000,
    },

    mainnet: {
      provider: () =>
        new HDWalletProvider(mnemonic, "https://mainnet.infura.io/<token>"),
        network_id: '1',
        gas: 4500000,
        gasPrice: 10000000000,
    }
  },
  mocha: {
    enableTimeouts: false
  }
};