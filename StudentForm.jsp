<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*,com.user.DBConnection" %>

<%
String slno = request.getParameter("slno");
String msg = request.getParameter("msg");
%>

<!DOCTYPE html>
<html>
<head>
<title>Student Monitoring System</title>

<style>
body{ 
    font-family: 'Poppins', 'Segoe UI', Arial, sans-serif;
    background: #f4f6f9;   /* soft white-grey */
    margin:0;
    padding:0;
}

.container{
    width: 95%;
    max-width: 1250px;
    margin: 40px auto;
    background: #ffffff;
    padding: 35px;
    border-radius: 15px;
    box-shadow: 0 8px 25px rgba(0,0,0,0.08);
}

h2{
    text-align: center;
    color: #1f3c88;
    margin-bottom: 30px;
    font-weight: 600;
}

fieldset{
    border: none;
    margin-bottom: 30px;
    padding: 25px;
    border-radius: 12px;
    background: #f8faff;
    box-shadow: 0 5px 15px rgba(0,0,0,0.08);
}


legend{
    font-weight: 600;
    color: #1f3c88;
}

.row{
    display: flex;
    gap: 20px;
    margin-bottom: 15px;
    flex-wrap: wrap;
}

.field{
    flex: 1;
    min-width: 200px;
    display: flex;
    flex-direction: column;
}

label{
    font-weight: 600;
    font-size: 14px;
    margin-bottom: 5px;
}

input{
    padding: 10px;
    border: 1px solid #d0d7e2;
    border-radius: 8px;
    font-size: 14px;
    transition: 0.3s;
}

input:focus{
    outline: none;
    border-color: #3f87ff;
    box-shadow: 0 0 8px rgba(63,135,255,0.4);
    transform: scale(1.02);
}

.buttons{
    text-align: center;
    margin-top: 20px;
}

button{
    padding: 10px 28px;
    margin: 8px;
    border: none;
    border-radius: 30px;
    font-size: 14px;
    cursor: pointer;
    font-weight: 600;
    transition: 0.3s;
}

button:hover{
    transform: translateY(-3px);
    box-shadow: 0 8px 20px rgba(0,0,0,0.2);
}

.save{ background: linear-gradient(45deg,#2ecc71,#27ae60); color:white; }
.update{ background: linear-gradient(45deg,#f39c12,#e67e22); color:white; }
.delete{ background: linear-gradient(45deg,#e74c3c,#c0392b); color:white; }
.clear{ background: linear-gradient(45deg,#7f8c8d,#636e72); color:white; }

.table-wrapper{
    width:95%;
    max-width:1400px;
    margin:20px auto;
}

table{
    width:100%;
    border-collapse: collapse;
}

th{
    background:#1f3c88;
    color:white;
    padding:12px;
    font-size:15px;
}

td{
    padding:10px;
    border:1px solid #d0d7e2;
    font-size:14px;
    text-align:center;
}

tr:nth-child(even){
    background:#f5f8fc;
}

tr:hover{
    background:#e8f0ff;
}

.action-link{
    color:#1f3c88;
    text-decoration: underline;
    cursor:pointer;
    font-weight:600;
}

.delete-text{
    color:#e74c3c;
}
.error{
    color:#e74c3c;
    font-size:12px;
    margin-top:4px;
}

.error-border{
    border:1px solid red !important;
}
</style>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
</head>

<body>

<div class="container">

<h2>Student Monitoring Form</h2>

<%
String error = (String) request.getAttribute("error");
if(error != null){
%>

<script>
window.onload = function(){

    alert("<%= error %>");

    <% if(error.contains("Phone")){ %>
        document.getElementById("phno").focus();
        document.getElementById("phno").select();
    <% } else if(error.contains("Pincode")){ %>
        document.getElementById("pincode").focus();
    <% } else if(error.contains("Aadhaar")){ %>
        document.getElementById("aadhaar").focus();
    <% } %>

}
</script>

<%
}
%>

<form action="StudentServlet" method="post" onsubmit="return validateForm()">

<input type="hidden" name="persno" value="1001">
<input type="hidden" name="slno" value="<%= slno!=null ? slno : "" %>">

<!-- Student Details -->
<fieldset>
<legend>Student Details</legend>

<div class="row">
    <div class="field">
        <label>Name</label>
        <input type="text" id="name" name="name"
        value="<%= request.getParameter("name") != null ? request.getParameter("name") : "" %>">
        <span class="error" id="nameError"></span>
    </div>
    <div class="field">
        <label>Qualification</label>
        <input type="text" id="qualf" name="qualf"
        value="<%= request.getParameter("qualf") != null ? request.getParameter("qualf") : "" %>">
        <span class="error" id="qualfError"></span>
    </div>
    <div class="field">
        <label>Branch</label>
        <input type="text" id="branch" name="branch"
        value="<%= request.getParameter("branch") != null ? request.getParameter("branch") : "" %>">
        <span class="error" id="branchError"></span>
    </div>
</div>

<div class="row">
    <div class="field">
        <label>Street</label>
        <input type="text" id="street" name="street"
        value="<%= request.getParameter("street") != null ? request.getParameter("street") : "" %>">
        <span class="error" id="streetError"></span>
    </div>
    <div class="field">
        <label>District</label>
        <input type="text" id="district" name="district"
        value="<%= request.getParameter("district") != null ? request.getParameter("district") : "" %>">
        <span class="error" id="districtError"></span>
    </div>
    <div class="field">
        <label>State</label>
        <input type="text" id="state" name="state"
        value="<%= request.getParameter("state") != null ? request.getParameter("state") : "" %>">
        <span class="error" id="stateError"></span>
    </div>
</div>

<div class="row">
    <div class="field">
        <label>Pincode</label>
        <input type="text" id="pincode" name="pincode" maxlength="6"
        value="<%= request.getParameter("pincode") != null ? request.getParameter("pincode") : "" %>">
        <span class="error" id="pincodeError"></span>
    </div>
    <div class="field">
        <label>University</label>
        <input type="text" id="university" name="university"
        value="<%= request.getParameter("university") != null ? request.getParameter("university") : "" %>">
        <span class="error" id="universityError"></span>
    </div>
</div>
</fieldset>

<!-- Guide Details -->
<fieldset>
<legend>Guide Details</legend>

<div class="row">
    <div class="field">
        <label>Guide Name</label>
        <input type="text" id="guide" name="guide"
        value="<%= request.getParameter("guide") != null ? request.getParameter("guide") : "" %>">
        <span class="error" id="guideError"></span>
    </div>
    <div class="field">
        <label>Section</label>
        <input type="text" id="section" name="section"
        value="<%= request.getParameter("section") != null ? request.getParameter("section") : "" %>">
        <span class="error" id="sectionError"></span>
    </div>
    <div class="field">
        <label>Directorate</label>
        <input type="text" id="dir" name="dir"
        value="<%= request.getParameter("dir") != null ? request.getParameter("dir") : "" %>">
        <span class="error" id="dirError"></span>
    </div>
</div>
</fieldset>

<!-- Project Details -->
<fieldset>
<legend>Project Details</legend>

<div class="row">
    <div class="field">
        <label>Project Name</label>
        <input type="text" id="project" name="project"
        value="<%= request.getParameter("project") != null ? request.getParameter("project") : "" %>">
        <span class="error" id="projectError"></span>
    </div>
    <div class="field">
        <label>College</label>
        <input type="text" id="college" name="college"
        value="<%= request.getParameter("college") != null ? request.getParameter("college") : "" %>">
        <span class="error" id="collegeError"></span>
    </div>
    <div class="field">
        <label>Documentation</label>
        <input type="text" id="doc" name="doc"
        value="<%= request.getParameter("doc") != null ? request.getParameter("doc") : "" %>">
        <span class="error" id="docError"></span>
    </div>
</div>

<div class="row">
    <div class="field">
        <label>Phone No</label>
        <input type="text" id="phno" name="phno" maxlength="10"
        value="<%= request.getParameter("phno") != null ? request.getParameter("phno") : "" %>">
        <span class="error" id="phnoError"></span>
    </div>
    <div class="field">
        <label>Aadhaar No</label>
        <input type="text" id="aadhaar" name="aadhaar" maxlength="12"
        value="<%= request.getParameter("aadhaar") != null ? request.getParameter("aadhaar") : "" %>">
        <span class="error" id="aadhaarError"></span>
    </div>
    <div class="field">
        <label>From Date</label>
        <input type="date" id="perform" name="perform"
        value="<%= request.getParameter("perform") != null ? request.getParameter("perform") : "" %>">
        <span class="error" id="performError"></span>
    </div>
</div>

<div class="row">
    <div class="field">
        <label>To Date</label>
        <input type="date" id="perupto" name="perupto"
        value="<%= request.getParameter("perupto") != null ? request.getParameter("perupto") : "" %>">
        <span class="error" id="peruptoError"></span>
    </div>
</div>

</fieldset>

<div class="buttons">

<button id="saveBtn" class="save" type="submit" name="action" value="Save"
<%= (slno != null && !slno.equals("")) ? "style='display:none'" : "" %>>
Save
</button>

<button id="updateBtn" class="update" type="submit" name="action" value="Update"
<%= (slno != null && !slno.equals("")) ? "" : "style='display:none'" %>>
Update
</button>

<button id="deleteBtn" class="delete" type="submit" name="action" value="Delete" style="display:none">
Delete
</button>

<button id="cancelBtn" class="clear" type="button"
<%= (slno != null && !slno.equals("")) ? "" : "style='display:none'" %>
onclick="cancelEdit()">
Cancel
</button>

</div>

</form>

<h2>List of Student Records</h2>

<div class="table-wrapper">
<table>
<tr>
    <th>SLNO</th>
    <th>From Date</th>
    <th>To Date</th>
    <th>Name</th>
    <th>Project</th>
    <th>Guide</th>
    <th>College</th>
    <th>Documentation</th>
    <th>Phone</th>
    <th>Aadhaar</th>
    <th>Action</th>
</tr>

<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try{
    con = DBConnection.getConnection();
    ps = con.prepareStatement("SELECT * FROM STUDENT_DETAILS ORDER BY SLNO");
    rs = ps.executeQuery();

    while(rs.next()){
%>
<tr>
    <td><%=rs.getLong("SLNO")%></td>
    <td><%=rs.getDate("PERFROM")%></td>
    <td><%=rs.getDate("PERUPTO")%></td>
    <td><%=rs.getString("F_V2NAME")%></td>
    <td><%=rs.getString("PROJECTNAME")%></td>
    <td><%=rs.getString("F_V2GUIDE")%></td>
    <td><%=rs.getString("COLLEGE")%></td>
    <td><%=rs.getString("DOCUMENTATION")%></td>
    <td><%=rs.getString("F_V2PHNO")%></td>
    <td><%=rs.getString("F_V2AADHAARNO")%></td>
<td>
<span class="action-link"
onclick="editRecord(
'<%=rs.getLong("SLNO")%>',
'<%=rs.getString("F_V2NAME")!=null?rs.getString("F_V2NAME").replace("'","\\'"):""%>',
'<%=rs.getString("F_V2QUALF")!=null?rs.getString("F_V2QUALF").replace("'","\\'"):""%>',
'<%=rs.getString("F_V2BRANCH")!=null?rs.getString("F_V2BRANCH").replace("'","\\'"):""%>',
'<%=rs.getString("F_V2STREET")!=null?rs.getString("F_V2STREET").replace("'","\\'"):""%>',
'<%=rs.getString("F_V2DISTRICT")!=null?rs.getString("F_V2DISTRICT").replace("'","\\'"):""%>',
'<%=rs.getString("F_V2STATE")!=null?rs.getString("F_V2STATE").replace("'","\\'"):""%>',
'<%=rs.getString("PINCODE")%>',
'<%=rs.getString("F_V2UNIVERSITY")!=null?rs.getString("F_V2UNIVERSITY").replace("'","\\'"):""%>',
'<%=rs.getString("F_V2GUIDE")!=null?rs.getString("F_V2GUIDE").replace("'","\\'"):""%>',
'<%=rs.getString("F_V2SECTION")!=null?rs.getString("F_V2SECTION").replace("'","\\'"):""%>',
'<%=rs.getString("F_V2DIR")!=null?rs.getString("F_V2DIR").replace("'","\\'"):""%>',
'<%=rs.getString("PROJECTNAME")!=null?rs.getString("PROJECTNAME").replace("'","\\'"):""%>',
'<%=rs.getString("COLLEGE")!=null?rs.getString("COLLEGE").replace("'","\\'"):""%>',
'<%=rs.getString("DOCUMENTATION")!=null?rs.getString("DOCUMENTATION").replace("'","\\'"):""%>',
'<%=rs.getString("F_V2PHNO")%>',
'<%=rs.getString("F_V2AADHAARNO")%>',
'<%=rs.getDate("PERFROM")!=null?rs.getDate("PERFROM").toString():""%>',
'<%=rs.getDate("PERUPTO")!=null?rs.getDate("PERUPTO").toString():""%>'
)">
Update
</span>
/
<span class="action-link delete-text"
onclick="deleteRecord('<%=rs.getLong("SLNO")%>')">
Delete
</span>
</td>

</tr>

<%
}
}catch(Exception e){
out.println(e);
}
%>

</table>
</div>

</div>

<script>
let isDeleteAction = false;
</script>

<script>

function editRecord(
		slno,name,qualf,branch,street,district,state,pincode,university,
		guide,section,dir,project,college,doc,phone,aadhar,fromDate,toDate){

		document.getElementsByName("slno")[0].value=slno;
		document.getElementsByName("name")[0].value=name || "";
		document.getElementsByName("qualf")[0].value=qualf || "";
		document.getElementsByName("branch")[0].value=branch || "";
		document.getElementsByName("street")[0].value=street || "";
		document.getElementsByName("district")[0].value=district || "";
		document.getElementsByName("state")[0].value=state || "";
		document.getElementsByName("pincode")[0].value=pincode || "";
		document.getElementsByName("university")[0].value=university || "";
		document.getElementsByName("guide")[0].value=guide || "";
		document.getElementsByName("section")[0].value=section || "";
		document.getElementsByName("dir")[0].value=dir || "";
		document.getElementsByName("project")[0].value=project || "";
		document.getElementsByName("college")[0].value=college || "";
		document.getElementsByName("doc")[0].value=doc || "";
		document.getElementsByName("phno")[0].value=phone || "";
		document.getElementsByName("aadhaar")[0].value=aadhar || "";
		
		if(fromDate) 
		    document.getElementsByName("perform")[0].value = fromDate.substring(0,10);

		if(toDate) 
		    document.getElementsByName("perupto")[0].value = toDate.substring(0,10);
		
		document.getElementById("saveBtn").style.display="none";
		document.getElementById("updateBtn").style.display="inline-block";
		document.getElementById("deleteBtn").style.display="none";//hide delete always
		document.getElementById("cancelBtn").style.display="inline-block";

		window.scrollTo({top:0,behavior:'smooth'});
		}

function cancelEdit(){
    document.querySelector("form").reset();
    document.getElementsByName("slno")[0].value="";

    document.getElementById("saveBtn").style.display="inline-block";
    document.getElementById("updateBtn").style.display="none";
    document.getElementById("deleteBtn").style.display="none"; // ensure hidden
    document.getElementById("cancelBtn").style.display="none";

    document.getElementById("name").focus(); // focus first field
}

function deleteRecord(slno){

    if(confirm("Delete this record?")){

        isDeleteAction = true;   // mark delete action

        document.getElementsByName("slno")[0].value = slno;

        let form = document.querySelector("form");

        let actionInput = document.createElement("input");
        actionInput.type = "hidden";
        actionInput.name = "action";
        actionInput.value = "Delete";

        form.appendChild(actionInput);

        form.submit();
    }

}
</script>
<script>
function validateForm(){

	// skip validation during delete
	if(isDeleteAction){
		isDeleteAction = false;
	    return true;
	}

    let valid = true;

    function setError(id,message){
        document.getElementById(id+"Error").innerText = message;
        document.getElementById(id).classList.add("error-border");
        valid = false;
    }

    function clearErrors(){
        let errors = document.querySelectorAll(".error");
        errors.forEach(e => e.innerText="");

        let inputs = document.querySelectorAll("input");
        inputs.forEach(i => i.classList.remove("error-border"));
    }

    clearErrors();

    let fields = [
        "name","qualf","branch","street","district","state",
        "pincode","university","guide","section","dir",
        "project","college","doc","phno","aadhaar","perform"
    ];

    for(let i=0;i<fields.length;i++){
        let field = document.getElementById(fields[i]);
        let value = field.value.trim();

        if(value===""){
            let fieldNames = {
                name:"Name",
                qualf:"Qualification",
                branch:"Branch",
                street:"Street",
                district:"District",
                state:"State",
                pincode:"Pincode",
                university:"University",
                guide:"Guide Name",
                section:"Section",
                dir:"Directorate",
                project:"Project Name",
                college:"College",
                phno:"Phone No",
                aadhaar:"Aadhaar No",
                perform:"From Date"
            };

            setError(fields[i], fieldNames[fields[i]] + " is required");
        }
    }

    let fromDate = document.getElementById("perform").value;
    let toDate = document.getElementById("perupto").value;

    if(toDate !== "" && fromDate > toDate){
        alert("To Date must be greater than From Date");
        document.getElementById("perupto").focus();
        return false;
    }

    return valid;
}
</script>
<script>
let fields = [
"name","qualf","branch","street","district","state",
"pincode","university","guide","section","dir",
"project","college","doc","phno","aadhaar","perform","perupto"
];

let fieldNames = {
name:"Name",
qualf:"Qualification",
branch:"Branch",
street:"Street",
district:"District",
state:"State",
pincode:"Pincode",
university:"University",
guide:"Guide Name",
section:"Section",
dir:"Directorate",
project:"Project Name",
college:"College",
doc:"Documentation",
phno:"Phone No",
aadhaar:"Aadhaar No",
perform:"From Date",
perupto:"To Date"
};

fields.forEach((id,index)=>{

    let field = document.getElementById(id);
    
    if(!field) return;
    
    field.addEventListener("focus",function(){

        if(index > 0){

            let prevFieldId = fields[index-1];
            let prevField = document.getElementById(prevFieldId);

            if(prevField.value.trim() === ""){

                document.getElementById(prevFieldId+"Error").innerText =
                fieldNames[prevFieldId] + " is required";

                prevField.focus();
            }
        }

    });

});
</script>
<script>

document.querySelectorAll("input").forEach(function(input){

    input.addEventListener("input", function(){

        let error = document.getElementById(this.id + "Error");

        if(error){
            error.innerText = "";
        }

        this.classList.remove("error-border");

    });

});

</script>
<%
if(msg != null){
%>

<script>

<% if("Saved".equals(msg)){ %>
alert("Record Saved Successfully");
<% } else if("Updated".equals(msg)){ %>
alert("Record Updated Successfully");
<% } else if("Deleted".equals(msg)){ %>
alert("Record Deleted Successfully");
<% } %>

</script>

<%
}
%>
</body>
</html>