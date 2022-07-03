// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

 contract RegulatorContract {
    
     uint private totalRegulators = 0;
     
    struct Regulator {
    string  regNo;
    string  name;
    string email;
    string phone;
    string rAddress;
    string pass;
    
    }
    

    mapping (string=>Regulator) regulators;
  

    function registerRegulators(string memory _regNo, string memory _name, string memory _email,
    string memory _phone,
    string memory _address,
    string memory _pass) public {
        regulators[_regNo] = Regulator(_regNo,_name,_email, _phone, _address, _pass);
        totalRegulators = totalRegulators + 1;
    
    }
    function getRegulatorByRegNo(string memory _regNo) public view returns (string[] memory) {
        
        Regulator memory regltr = regulators[_regNo];
        string[] memory r = new string[](5);
        r[0] = regltr.regNo;
        r[1] = regltr.name;
        r[2] = regltr.email;
        r[3] = regltr.phone;
        r[4] = regltr.rAddress;
       
        return r;
        
    }
    function getTotalRegulators() public view returns(uint) {
        return totalRegulators;
    }
 
     
    function updatenameByRegNo(string memory _regNo, string memory _name) public {
          Regulator memory regltr = regulators[_regNo];
         regltr.name = _name;
         regulators[_regNo] = regltr;
     }
  function login(string memory _regno, string memory _pass) public view returns (bool){
        string memory pass = regulators[_regno].pass;
        bool logFlag = equal(pass, _pass);
        return logFlag;
    }
   function compare(string memory _a, string memory _b) public pure returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
        //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
        for (uint i = 0; i < minLength; i ++)
            if (a[i] < b[i])
                return -1;
            else if (a[i] > b[i])
                return 1;
        if (a.length < b.length)
            return -1;
        else if (a.length > b.length)
            return 1;
        else
            return 0;
    }
    ///  Compares two strings and returns true iff they are equal.
    function equal(string memory _a, string memory _b) public pure returns (bool) {
        return compare(_a, _b) == 0;
    }
 }
