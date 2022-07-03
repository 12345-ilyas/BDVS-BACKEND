const StudentMigration = artifacts.require("StudentContract");

module.exports = function (deployer) {
  deployer.deploy(StudentMigration);
};
