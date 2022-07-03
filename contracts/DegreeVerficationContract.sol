// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

 contract DegreeVerficationContract {
     uint totaldegrees = 0;
     struct Degreeverification {
         string degreeFrontHash;
         string degreeBackHash;
         string studentCnic;
         string uniRegNo;
         string degreeTitle;
         string degreeRegNo;
         string degreeVerified; //univerified
         string hecVerified;

     }

     mapping (string=>Degreeverification) degrees;
  
     struct DegreeUploadRequest {
          string uniRegNo;
          string challanNo;
          string studentCnic;
          string challanSlip;
          string status;
     }

     struct HECVerificationReq {
          string challanNo;
          string studentCnic;
          string challanSlip;
          string status;
     }
     mapping(string => HECVerificationReq) hecVerificationReq;
     string[]  aHECDegreeVReqs;
     mapping(string => DegreeUploadRequest) tblDegreeUploadRequests;

    struct ArrDegreeUploadReq {
            string uniRegNo;
            string studentCnic;
     } 

     ArrDegreeUploadReq[] public arrDegreeUploadReq;
    
    function uploadDegree(string memory _degreeFrontHash, string memory _degreeBackHash,string memory _studentCnic, string memory _UniRegNo,
    string memory _degreeTitle,string memory _degreeRegNo,string memory _degreeVerified) public {
        degrees[_studentCnic] = Degreeverification(_degreeFrontHash,_degreeBackHash,_studentCnic,_UniRegNo,_degreeTitle,_degreeRegNo, "1", "0");
        //update status of req from student to verified.
        DegreeUploadRequest memory dur = tblDegreeUploadRequests[_studentCnic];
        dur.status = "verified";
        tblDegreeUploadRequests[_studentCnic] = dur;
        totaldegrees = totaldegrees + 1;
    }
    function degreeVerificationByHEC(string memory _cnic,string memory flag) public {
        Degreeverification memory dv = degrees[_cnic];
        dv.hecVerified = flag;
        degrees[_cnic] = dv;
        //update status of req from student to verified.
        HECVerificationReq memory hf = hecVerificationReq[_cnic];
        hf.status = "verified";
        hecVerificationReq[_cnic] = hf;

    }
    function getDegreeReqsForHEC() public returns (string[][] memory) {
            uint totalRecords = 0;
            uint arraySize = aHECDegreeVReqs.length;
            string[][] memory data = new string[][](arraySize);  
        for (uint i=0; i < arraySize; i++){
            string memory cnic = aHECDegreeVReqs[i]; 
                HECVerificationReq memory pr = hecVerificationReq[cnic];
                string[] memory s = new string[](4);
                s[0] = pr.challanNo;
                s[1] = pr.challanSlip;
                s[2] = pr.studentCnic;
                s[3] = pr.status;
                data[totalRecords] = s;
                totalRecords = totalRecords + 1;
        }
        return data;
    }
 function hecDegreeVerificationReq(string memory _challanNo,
 string memory _studentCnic, string memory _challanSlip) public {
        hecVerificationReq[_studentCnic] = HECVerificationReq(_challanNo,_studentCnic,_challanSlip, "pending");
        aHECDegreeVReqs.push(_studentCnic);
       
    }

function checkDegreeByCnic(string memory _Cnic) public view returns (string[] memory) {
        
        Degreeverification memory d = degrees[_Cnic];
        string[] memory arr = new string[](6);
        arr[0] = d.degreeFrontHash;
        arr[1] = d.degreeBackHash;
        arr[2] = d.studentCnic;
        arr[3] = d.degreeVerified;
        arr[4]= d.hecVerified;
        arr[5] = d.uniRegNo;
        return arr;
        
    }

 function convertBoolToString(bool flag) private pure returns (string memory){
     if(flag){
         return "1";
     }
     return "0";
 }
 function degreeUploadRequest(string memory _uniRegNo, string memory _challanNo,
 string memory _studentCnic, string memory _challanSlip) public {
        tblDegreeUploadRequests[_studentCnic] = DegreeUploadRequest(_uniRegNo,_challanNo,_studentCnic,_challanSlip, "pending");
        ArrDegreeUploadReq memory du = ArrDegreeUploadReq(_uniRegNo, _studentCnic);
        arrDegreeUploadReq.push(du);
    }

    function getDegreeReqsForUniversity(string memory _uniReg) public returns (string[][] memory) {
            uint totalRecords = 0;
            uint arraySize = getTotalRequestForUni(_uniReg);
            string[][] memory data = new string[][](arraySize);  
        for (uint i=0; i < arrDegreeUploadReq.length; i++){
            ArrDegreeUploadReq memory ap = arrDegreeUploadReq[i];
            
            if(equal(ap.uniRegNo, _uniReg)){
                DegreeUploadRequest memory pr = tblDegreeUploadRequests[ap.studentCnic];
                string[] memory s = new string[](5);
                s[0] = pr.uniRegNo;
                s[1] = pr.challanNo;
                s[2] = pr.challanSlip;
                s[3] = pr.studentCnic;
                s[4] = pr.status;
                data[totalRecords] = s;
                totalRecords = totalRecords + 1;
                
            }
        }
        return data;
    }
    //this fuctnion will calculated many records found against uniRegNo.
    //so we can create array of degree upload request exact to this figure.
    event totalDegreeReqEvent(string _uniReg, string aUniReg, bool flag);
    function getTotalRequestForUni(string memory _uniRegNo) public returns (uint){
         uint totalRecords = 0;
        for (uint i=0; i < arrDegreeUploadReq.length; i++){
            ArrDegreeUploadReq memory ap = arrDegreeUploadReq[i];
            emit totalDegreeReqEvent(_uniRegNo, ap.uniRegNo, equal(ap.uniRegNo, _uniRegNo));
            if(equal(ap.uniRegNo, _uniRegNo)){
              
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