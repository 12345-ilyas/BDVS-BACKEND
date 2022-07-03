// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "../utils/Strings.sol";
contract PermissionContract {

    //permissionlevel
    //1 full access
    //2 student degree access (employer)


    //employer (23 -> DeptRegNo), (2170383439 -> StudentCnic), (degree (2) -> permissionLevel)
    // university allow or reject  access of concerned entity.
    //Access Level
    //Approved = 1 (then employer can access student degreee)
    //Pending = 0
    //Rejected = 2 (then employer not allowed to access the degree)
    struct Permission {
        string DeptRegNo;
        string UniRegNo;
        string studentCnic;
        uint permissionLevel;
        uint access;
    }
    struct ArrPermission{
        string stakeHolder;
        string studentCnic;
        uint index;
    }
            mapping(string=>mapping(string=>Permission)) tblpermission;
              ArrPermission[] public aPers;
            uint totalRequestPers = 0;
     constructor() public {
         string memory HecRegNo = "1";
       tblpermission[HecRegNo][HecRegNo] = Permission(HecRegNo,"0","0",1,1);
    }
    
    function requestPermission(string memory _DeptRegNo, string memory UniRegNo, string memory _studentCnic, uint _permissionLevel) public  {
      tblpermission[_DeptRegNo][_studentCnic] = Permission(_DeptRegNo,UniRegNo,_studentCnic,_permissionLevel,0);
   ArrPermission memory aP = ArrPermission(_DeptRegNo, _studentCnic, totalRequestPers);
     aPers.push(aP);
    totalRequestPers = totalRequestPers + 1;
    }
    event eApprovedPermission(address sender, string _deptReg, string Message, string _studentCnic);
    function approvePermissionRequest(string memory _DeptRegNo, string memory _studentCnic) public {
        Permission memory pr = tblpermission[_DeptRegNo][_studentCnic];
        pr.access = 1;
        tblpermission[_DeptRegNo][_studentCnic] = pr;
        emit eApprovedPermission(msg.sender, _DeptRegNo, "permission granted  for verified degree.", _studentCnic);
    }
      event eRejectPermission(address sender, string _deptReg, string Message, string _studentCnic);
    function rejectPermissionRequest(string memory _DeptRegNo, string memory _studentCnic) public {
        Permission memory pr = tblpermission[_DeptRegNo][_studentCnic];
        pr.access = 2;
        tblpermission[_DeptRegNo][_studentCnic] = pr;
        emit eApprovedPermission(msg.sender, _DeptRegNo, "permission rejected  for verified degree.", _studentCnic);
    }
    function getPermissionRequest(string memory _DeptRegNo) public view returns (string[] memory) {
        mapping(string => Permission) storage deptPers = tblpermission[_DeptRegNo];
        Permission memory pr = deptPers[_DeptRegNo];
         string[] memory s = new string[](4);
        s[0] = pr.DeptRegNo;
        s[1] = pr.UniRegNo;
        s[2] = pr.studentCnic;
        s[3] = Strings.toString(pr.access);
        return s;
    }
    event studentPersMatched(address sender, string  stakeholder, string  _cnic);
    function getStudentPermissionRequests(string memory _cnic) public returns (string[][] memory) {
            uint totalRecords = 0;
            uint arraySize = getTotalRequestForStudent(_cnic);
            string[][] memory data = new string[][](arraySize);  
        for (uint i=0; i < aPers.length; i++){
            ArrPermission memory ap = aPers[i];
            
            if(equal(ap.studentCnic, _cnic)){
                Permission memory pr = tblpermission[ap.stakeHolder][ap.studentCnic];
                string[] memory s = new string[](4);
                s[0] = pr.DeptRegNo;
                s[1] = pr.UniRegNo;
                s[2] = pr.studentCnic;
                s[3] = Strings.toString(pr.access);
                data[totalRecords] = s;
                emit studentPersMatched(msg.sender, pr.DeptRegNo, pr.studentCnic);
                totalRecords = totalRecords + 1;
            }
        }
        return data;
    }
    event employerPersMatched(address sender, string  _deptRegNo, string  _cnic);
    function getEmployerPermissionRequests(string memory _deptRegNo) public returns (string[][] memory) {
            uint totalRecords = 0;
            uint arraySize = getTotalRequestForEmployer(_deptRegNo);
            string[][] memory data = new string[][](arraySize);  
        for (uint i=0; i < aPers.length; i++){
            ArrPermission memory ap = aPers[i];
            
            if(equal(ap.stakeHolder, _deptRegNo)){
                Permission memory pr = tblpermission[ap.stakeHolder][ap.studentCnic];
                string[] memory s = new string[](4);
                s[0] = pr.DeptRegNo;
                s[1] = pr.UniRegNo;
                s[2] = pr.studentCnic;
                s[3] = Strings.toString(pr.access);
                data[totalRecords] = s;
                emit employerPersMatched(msg.sender, pr.DeptRegNo, pr.studentCnic);
                totalRecords = totalRecords + 1;
            }
        }
        return data;
    }
    function getTotalRequestForEmployer(string memory _stakeHolder) public view returns (uint){
         uint totalRecords = 0;
        for (uint i=0; i < aPers.length; i++){
            ArrPermission memory ap = aPers[i];
              if(equal(ap.stakeHolder, _stakeHolder)){
              
                totalRecords += 1;
            }
        }
        return totalRecords;
    }
function getTotalRequestForStudent(string memory _cnic) public view returns (uint){
         uint totalRecords = 0;
        for (uint i=0; i < aPers.length; i++){
            ArrPermission memory ap = aPers[i];
              if(equal(ap.studentCnic, _cnic)){
              
                totalRecords += 1;
            }
        }
        return totalRecords;
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