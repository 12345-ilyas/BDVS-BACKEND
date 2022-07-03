const RegulatorMigration = artifacts.require("RegulatorContract");

module.exports = function (deployer) {
  deployer.deploy(RegulatorMigration);
};
