const UniversityMigration = artifacts.require("UniversityContract");

module.exports = function (deployer) {
  deployer.deploy(UniversityMigration);
};
