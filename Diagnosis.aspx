<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Diagnosis.aspx.cs" Inherits="HospitalsDashboard.Diagnosis" EnableEventValidation="false" MasterPageFile="~/Main.Master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <style type="text/css">
        .auto-style1 {
            width: 105px;
        }

        .auto-style2 {
            height: 20px;
        }
    </style>

    <script>
        $(document).ready(function () {

            $("#appbutton").on('click', function (e) {

                if (document.getElementById("appid").value.length > 0 && RegExp('^[0-9]+$').test($("#appid").val())) {
                    $("#msgerror").hide();
                    $("#appointmentid").val("");
                    $("#patientid").val("");
                    $("#head").val("");
                    $("#height").val("");
                    $("#weight").val("");
                    $("#temp").val("");
                    $("#diag").val("");
                    $("#treatment").val("");
                    $.ajax({
                        type: "POST",
                        url: "Diagnosis.aspx/GetDetails",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify({ AppointmentId: $("#appid").val() }),
                        dataType: "json",
                        success: function OnSuccess(response) {
                            if (response.d != "failure") {

                                var xmldoc = $.parseXML(response.d);
                                var xml = $(xmldoc);

                                var data = xml.find("Table");
                                $("#appointmentid").val(xml.find("Table").find("AppointmentId").text());
                                $("#patientid").val(xml.find("Table").find("PatientId").text());
                                $("#patientname").val(xml.find("Table").find("PatientName").text());
                                $("#head").val(xml.find("Table").find("Head").text());
                                $("#height").val(xml.find("Table").find("Height").text());
                                $("#weight").val(xml.find("Table").find("Weight").text());
                                $("#temp").val(xml.find("Table").find("PatientId").text());
                                $("#infotable").show();

                            }
                            else {

                                $("#msgerror").show();
                                $("#msgerror").html("no records found").css('color', 'red');
                                $("#infotable").hide();

                            }

                        },
                        failure: function (response) {
                            $("#msgerror").show();
                            $("#msgerror").html("Error occured").css("color", "red");

                        },
                        error: function (response) {
                            $("#msgerror").show();
                            $("#msgerror").html("Error occured").css("color", "red");
                        }
                    });
                }
                else {
                    $("#msgerror").show();
                    $("#infotable").hide();
                    $("#msgerror").html("Incorrect Input").css('color', 'red');
                }
            });



            $("#save").on('click', function (e) {
                $("#infotable").show();

                var verification = {};
                if (document.getElementById("diag").value.length > 0) {
                    verification.diag = true;
                }
                else {
                    $("#msg").html("Please mention Diagnosis info").css('color', 'red');
                }

                if (document.getElementById("treatment").value.length > 0) {

                    verification.treatment = true;
                }
                else {
                    $("#msg").html("Please mention Treatment info").css('color', 'red');
                }

                if (verification.diag && verification.treatment) {

                    $.ajax({
                        type: "POST",
                        url: "Diagnosis.aspx/AddDetails",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify({ appointmentid: $("#appid").val(), diagnosis: $("#diag").val(), treatment: $("#treatment").val() }),
                        dataType: "json",
                        success: function OnSuccess(response) {
                            $("#msg").html("saved").css("color", "green");

                        },
                        failure: function (response) {

                            $("#msg").html("Error occured").css("color", "red");

                        },
                        error: function (response) {

                            $("#msg").html("Error occured").css("color", "red");
                        }
                    });
                }
                else {

                    $("#msg").html("Please mention required info").css('color', 'red');
                }
            });



        });




    </script>
               
                  
            <div id="page-wrapper">

                <div class="container-fluid" style="min-height: 100%; height: 100%;">

                    <!-- Page Heading -->
                    <div class="row">
                        <div class="col-lg-12">
                            <h1 class="page-header"></h1>
                            <ol class="breadcrumb">
                                <li>
                                    <i class="fa fa-dashboard"></i><a href="Home.aspx">Dashboard</a>
                                </li>
                                <li class="active">
                                    <i class="fa fa-edit"></i>Diagnosis and Treatment
                                </li>
                            </ol>
                        </div>
                    </div>
                     <div class="col-md-12">
                       <div class="col-md-3">
                        <input type="text" id="appid" class="form-control" style="margin-bottom:20px" placeholder="Enter Appointment ID" />
                        </div>
                         <div class="col-md-2">
                        <input type="button" id="appbutton" value="Click Here" class="btn btn-primary" />
                        </div>
                         <div class="col-md-3 pull-left">
                        <label id="msgerror" style="padding-bottom: 20px; text-align:left"></label>
                   
                         </div>
                         </div>
                    
                    <div class="col-md-12">

                    <form id="pdfform" runat="server">
                        <div class="table-responsive">
                            <table id="infotable" class="display table table-bordered table-hover col-lg-3">
                                <tr>
                                    <td>Appointment ID</td>
                                    <td>
                                        <input type="text" id="appointmentid" readonly />
                                    </td>
                                    <td>Patient ID</td>
                                    <td>
                                        <input type="text" id="patientid" readonly /></td>
                                </tr>

                                <tr>
                                    <td>Patient Name</td>
                                    <td>
                                        <input type="text" id="patientname" readonly /></td>
                                    <td>Height</td>
                                    <td>
                                        <input type="text" id="height" readonly /></td>
                                </tr>
                                <tr>
                                    <td>Cost</td>
                                    <td>
                                        <input type="text" readonly id="cost" />
                                    </td>
                                    <td>Weight</td>
                                    <td>
                                        <input type="text" id="weight" readonly /></td>
                                </tr>
                                <tr>
                                    <td>Insured</td>
                                    <td>
                                        <input type="text" id="insurance" readonly />
                                    </td>
                                    <td>Temperature</td>
                                    <td>
                                        <input type="text" id="temp" readonly /></td>
                                </tr>
                                <tr>
                                    <td>Head Circumference</td>
                                    <td>
                                        <input type="text" id="head" readonly /></td>
                                </tr>
                                <tr>
                                    <td>Diagnosis </td>
                                    <td>
                                        <textarea rows="5" cols="50" id="diag"></textarea></td>
                                    <td>Treatment</td>
                                    <td>
                                        <textarea rows="5" cols="50" id="treatment"></textarea></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Button ID="save" CssClass="btn btn-default btn-success" runat="server" Text="Save" /></td>
                                    <td>
                                        <asp:Button ID="export" runat="server" Text="Download" CssClass="btn btn-default btn-primary" /></td>
                                </tr>



                            </table>

                        </div>
                        <div>

                            <label id="msg"></label>
                        </div>


                    </form>
                    </div>


                </div>
            </div>
            <!-- /#page-wrapper -->

  
        <!-- /#wrapper -->
</asp:Content>
