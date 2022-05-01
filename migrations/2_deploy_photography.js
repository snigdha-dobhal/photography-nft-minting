const photography = artifacts.require("Photography");

module.exports = function (deployer) {
  deployer.deploy(photography);
};
