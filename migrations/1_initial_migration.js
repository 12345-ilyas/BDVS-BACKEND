const EmployerMigration = artifacts.require("EmployerContract");

module.exports = function (deployer) {
  deployer.deploy(EmployerMigration);
};
