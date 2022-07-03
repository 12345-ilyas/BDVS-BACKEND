const DegreeVerficationContract = artifacts.require("DegreeVerficationContract");

module.exports = function (deployer) {
  deployer.deploy(DegreeVerficationContract);
};
