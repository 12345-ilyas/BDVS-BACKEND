// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

 contract UniversityContract {
    
     uint private totalUniversities = 0;
     
    struct University {
    string  regNo;
    string  name;
    string email;
    string contactNo;
    string uniAddress;
    string pass;
    
    }
    

    mapping (string=>University) universities;
  string[] aUniRegNos;

    function registerUniversity(string memory _regNo, string memory _name, 
    string memory _email,string memory _contactNo,string memory _uniAddress,string memory _pass) public {
        universities[_regNo] = University(_regNo,_name,_email,_contactNo,_uniAddress,_pass);
        totalUniversities = totalUniversities + 1;
        aUniRegNos.push(_regNo);
    
    }
    function getTotalUniversities() public view returns (string[][] memory){
            uint totalRecords = 0;
            string[][] memory data = new string[][](aUniRegNos.length);
            for(uint i=0; i < aUniRegNos.length; i++){
               University memory uni = universities[aUniRegNos[i]];
               string[] memory s = new string[](2);
               s[0] = uni.regNo;
               s[1] = uni.name;   
               data[totalRecords] = s;
               totalRecords +=1;

            }

            return data;
    }
    function getUniversityByRegNo(string memory _regNo) public view returns (string[] memory) {
        
        University memory uni = universities[_regNo];
        string[] memory u = new string[](5);
        u[0] = uni.regNo;
        u[1] = uni.name;
        u[2] = uni.email;
        u[3] = uni.contactNo;
        u[4] = uni.uniAddress;
        return u;
        
    }
   
 
     
    function updateNameByRegNo(string memory _regNo, string memory _name) public {
          University memory uni = universities[_regNo];
         uni.name = _name;
         universities[_regNo] = uni;
     }
  function login(string memory _regno, string memory _pass) public view returns (bool){
        string memory pass = universities[_regno].pass;
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
