require("@nomiclabs/hardhat-waffle");
require("hardhat-gas-reporter");
require("@nomiclabs/hardhat-etherscan");
require("hardhat-preprocessor");
require('hardhat-deploy');
require('dotenv').config();

const fs = require("fs");
const { env } = require("process");

// for foundry remappings
function getRemappings() {
  return fs
    .readFileSync("remappings.txt", "utf8")
    .split("\n")
    .filter(Boolean) // remove empty lines
    .map((line) => line.trim().split("="));
}

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.13",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  namedAccounts: {
    deployer: 0,
  },
  networks: {
    hardhat: {
      gas: 50000000000,
      blockGasLimit: 100000000429720,
      allowUnlimitedContractSize: true,
    },
    mainnet: {
      url: process.env.NODE_URL_MAINNET,
      accounts: [process.env.PK],
      // gasPrice: 40000000000
    },
    rinkeby: {
      url: process.env.NODE_URL,
      accounts: [process.env.PK],
      // gas: 2100000,
      // gasPrice: 8000000000
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
  // for foundry
  preprocess: {
    eachLine: (hre) => ({
      transform: (line) => {
        if (line.match(/^\s*import /i)) {
          getRemappings().forEach(([find, replace]) => {
            if (line.match('"' + find)) {
              line = line.replace('"' + find, '"' + replace);
            }
          });
        }
        return line;
      },
    }),
  },
  paths: {
    sources: "./src",
    tests: "./hh-tests",
    cache: "./hh-cache",
    artifacts: "./artifacts"
  },
  gasReporter: {
    currency: 'USD',
    gasPrice: 100,
    showTimeSpent: true,
  },
};