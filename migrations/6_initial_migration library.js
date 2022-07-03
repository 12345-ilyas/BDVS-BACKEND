const PermissionContract = artifacts.require("PermissionContract");
const Strings = artifacts.require("Strings.sol");
module.exports = function (deployer) {
  //deployer.deploy(Strings);
  //deployer.link(Strings, PermissionContract);
  deployer.deploy(PermissionContract);
  
};
