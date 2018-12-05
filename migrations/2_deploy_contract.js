var StakeToken = artifacts.require("./StakeToken.sol");

module.exports = function(deployer) {
  deployer.deploy(StakeToken);
};