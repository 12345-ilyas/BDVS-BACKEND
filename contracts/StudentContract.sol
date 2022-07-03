// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./DegreeVerficationContract.sol";

 contract StudentContract {
    
     uint private totalStudents = 0;
  
    struct Student {
    string  rollNo;
    string  name;
    string  fatherName;
    string  cnic;
    string  DOB;
    string  session;
    string  program;
    string  email;
    string  pass;
    }
    

    mapping (string=>Student) students;
  

    function registerStudent(string memory _rollNo, string memory _name, string memory _fatherName, 
    string memory _cnic, string memory _DOB, string memory _session, string memory _program, string memory _email, string memory _pass) public {
        students[_cnic] = Student(_rollNo,_name, _fatherName, _cnic,_DOB, _session,_program,_email,_pass);
        totalStudents = totalStudents + 1;
    
    }
    function login(string memory _cnic, string memory _pass) public view returns (bool){
        string memory pass = students[_cnic].pass;
        bool logFlag = equal(pass, _pass);
        return logFlag;
    }

    function getStudentByCnic(string memory _cnic) public view returns (string[] memory) {
        
        Student memory st = students[_cnic];
        string[] memory s = new string[](8);
        s[0] = st.rollNo;
        s[1] = st.name;
        s[2] = st.fatherName;
        s[3] = st.cnic;
        s[4] = st.DOB;
        s[5] = st.session;
        s[6] = st.program;
        s[7] = st.email;
        return s;
        
    }
    function getTotalStudents() public view returns(uint) {
        return totalStudents;
    }
 
     
    function updateFatherNameByCnic(string memory _cnic, string memory _fathername) public {
          Student memory st = students[_cnic];
         st.fatherName = _fathername;
         students[_cnic] = st;
     }



  

     function updateEmailByCnic(string memory _cnic, string memory _email) public {
         Student memory st = students[_cnic];
         st.email = _email;
         students[_cnic] = st;
     }
   
    // function checkDegree(address _address, string memory _cnic) external view returns (string[] memory){
    //     DegreeVerficationContract dv = DegreeVerficationContract(_address);
    //     return dv.checkDegreeByCnic(_cnic);
    // }
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