<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddStaff.aspx.cs" Inherits="HospitalsDashboard.AddStaff" MasterPageFile="~/Main.Master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

    <script>
        $(document).ready(function () {

            $("#dob").datepicker({
                dateFormat: 'mm/dd/yy',
                changeMonth: true,
                changeYear: true,
                yearRange: '-100y:c+nn',
                maxDate: '-1d'
            });

            $("#submitRecord").on('click', function (e) {

                $("#fnameerror").hide();
                $("#lnameerror").hide();
                $("#dateerror").hide();
                $("#countryerror").hide();
                $("#numbererror").hide();
                $("#emailerror").hide();
                e.preventDefault();
                var staffDetails = {};
                var verification = {};
                if (document.getElementById("fname").value.length > 0 && RegExp('^[a-zA-Z]+$').test($("#fname").val())) {
                    verification.fname = true;

                }
                else {
                    $("#fnameerror").show();
                }
                if (document.getElementById("lname").value.length > 0 && RegExp('^[a-zA-Z]+$').test($("#lname").val())) {
                    verification.lname = true;

                }
                else {
                    $("#lnameerror").show();
                }

                if ($("#dob").val().length > 0) {
                    verification.date = true;
                }
                else {
                    $("#dateerror").show();
                }

                if (document.getElementById("country").value.length > 0 && RegExp('^[a-zA-Z]+$').test($("#country").val())) {
                    verification.country = true;

                }
                else {
                    $("#countryerror").show();
                }

                if (document.getElementById("number").value.length > 0 && RegExp('^[0-9]+$').test($("#number").val())) {
                    verification.number = true;

                }
                else {
                    $("#numbererror").show();
                }


                if (document.getElementById("optionsRadios1").checked) {
                    staffDetails.gender = $("#optionsRadios1").val();

                }

                else {
                    staffDetails.gender = $("#optionsRadios2").val();
                }

                if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(document.getElementById("email").value)) {
                    verification.email = true;
                }
                else {
                    $("#emailerror").show();
                }
                if (verification.fname && verification.lname && verification.date && verification.number && verification.email) {
                    $.ajax({
                        type: "POST",
                        url: "AddStaff.aspx/AddStaffData",
                        data: JSON.stringify({ fname: $("#fname").val(), mname: $("#mname").val(), lname: $("#lname").val(), dob: $("#dob").val(), id: $("#cpr").val(), gender: staffDetails.gender, country: $("#country").val(), address: $("#address").val(), number: $("#number").val(), email: $("#email").val() }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSuccess,
                        error: OnErrorCall
                    });

                    function OnSuccess(response) {
                        var result = response.d;
                        if (result == "success") {
                            $("#msg").html("New record addded successfully  :)").css("color", "green");
                        }
                        $("#fname").val("");
                        $("#mname").val("");
                        $("#lname").val("");
                        $("#dob").val("");
                        $("#cpr").val("");
                        $("#country").val("");
                        $("#address").val("");
                        $("#email").val("");
                        $("#number").val("");

                    }

                    function OnErrorCall(response) {
                        $("#msg").html("Error occurs  :(").css("color", "red");
                    }
                }
                else {
                    $("#msg").html("Please fill all details").css("color", "red");
                }
            });
        
        
            });
       
        

    </script>

        

        <div id="page-wrapper">

            <div class="container-fluid"  style="min-height: 100%; height: 100%;">

                 <!-- Page Heading -->
                <div class="row">
                    <div class="col-lg-12">
                        <h1 class="page-header">
                           
                        </h1>
                        <ol class="breadcrumb">
                             <li>
                                <i class="fa fa-dashboard"></i>  <a href="Home.aspx">Home</a>
                            </li>
                            <li>
                                <i class="fa fa-dashboard"></i>  <a href="StaffDetails.aspx">Staff Details</a>
                            </li>
                            <li class="active">
                                <i class="fa fa-edit"></i>Add New Staff
                            </li>
                        </ol>
                    </div>
                </div>
               
            
          
                 
               
                    <div class="row">
                    <div class="col-lg-4">

                      

                            <div class="form-group">
                                <label>First Name</label>
                                <input class="form-control" placeholder="Enter First Name" id="fname">
                                 <label id="fnameerror" style="color:red;display:none"> Not a valid Name</label>
                            </div>
                             <div class="form-group">
                                <label>Middle Initial</label>
                                <input class="form-control" placeholder="Enter Middle Name" id="mname">
                            </div>
                             <div class="form-group">
                                <label>Last Name</label>
                                <input class="form-control" placeholder="Enter Last Name" id="lname">
                                  <label id="lnameerror" style="color:red;display:none"> Not a valid Name</label>
                            </div>
                         <div class="form-group">
                               
                             <p>Date of Birth<input type="text" placeholder="Pick the Date" id="dob" /></p>
                            </div> 
                         
                         <div class="form-group">
                                <label>CPR/ID</label>
                                <input class="form-control" placeholder="Enter CPR/ID" id="cpr">
                                 
                            </div> 
                         <div class="form-group">
                                <label>Gender</label>
                                <div class="radio">
                                    <label>
                                        <input type="radio" name="optionsRadio" id="optionsRadios1" value="Male" checked>Male
                                    </label>
                                </div>
                                <div class="radio">
                                    <label>
                                        <input type="radio" name="optionsRadio" id="optionsRadios2" value="FeMale">FeMale
                                    </label>
                                </div>
                               
                            </div>
                 </div>
                 <div class="col-lg-4">
                            <div class="form-group">
                                <label>Nationality</label>
                                <input class="form-control" placeholder="Enter Country" id="country">
                                 <label id="countryerror" style="color:red;display:none"> Not a valid Value</label>
                            </div>
                            
                             <div class="form-group">
                                <label>Present Address</label>
                                <input class="form-control" placeholder="Enter Address" id="address">
                            </div>
                             <div class="form-group">
                                <label>Phone Number</label>
                                <input class="form-control" placeholder="Enter Phone Number" id="number">
                                  <label id="numbererror" style="color:red;display:none"> Not a valid Number</label>
                            </div>
                             <div class="form-group">
                                <label>Email Address</label>
                                <input class="form-control" placeholder="Enter Email" id="email">
                                 <label id="emailerror" style="color:red;display:none"> Not a valid Email</label>
                            </div>
                          
                               
                          
                           
                           <div>

                        <label id="msg"></label>
                           <%--<button type="submit" class="btn btn-default" id="submitRecord"></button>--%>
                            <input type="button" class="btn btn-default btn-success" id="submitRecord" value="submit">
<%--                          <button type="reset" class="btn btn-default">Reset Button</button>--%>
                        </div>
                      

                    </div>
                  
                   
             
             </div>  

           

        </div>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->

    <!-- jQuery -->
   

  
</asp:Content>
