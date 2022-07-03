// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

 contract EmployerContract {
    
     uint private totalEmployers = 0;
     
    struct Employer {
    string  regNo;
    string  orgname;
    string email;
    string phone;
    string empAddress;
    string pass;
    
    }
    

    mapping (string=>Employer) employers;
  

    function registerEmployer(string memory _regNo, string memory _orgname, string memory _email, 
    string memory _phone, string memory _address, string memory _pass) public {
        employers[_regNo] = Employer(_regNo,_orgname, _email, _phone, _address, _pass);
        totalEmployers = totalEmployers + 1;
    
    }
    function getEmployerByRegNo(string memory _regNo) public view returns (string[] memory) {
        
        Employer memory emp = employers[_regNo];
        string[] memory e = new string[](6);
        e[0] = emp.regNo;
        e[1] = emp.orgname;
        e[2] = emp.email;
        e[3] = emp.phone;
        e[4] = emp.empAddress;
        return e;
        
    }
    function login(string memory _regNo, string memory _pass) public view returns (bool){
        string memory pass = employers[_regNo].pass;
        bool logFlag = equal(pass, _pass);
        return logFlag;
    }
    function getTotalEmployers() public view returns(uint) {
        return totalEmployers;
    }
 
     
    function updateorgnameByRegNo(string memory _regNo, string memory _orgname) public {
          Employer memory emp = employers[_regNo];
         emp.orgname = _orgname;
         employers[_regNo] = emp;
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
