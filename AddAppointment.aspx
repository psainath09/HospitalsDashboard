<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddAppointment.aspx.cs" Inherits="HospitalsDashboard.AddAppointment" MasterPageFile="~/Main.Master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <%-- <link href="css/bootstrap-datetimepicker.min.css" rel="stylesheet" />
<script src="js/bootstrap-datetimepicker.min.js"></script>--%>
    <script>
        $(document).ready(function () {
            $('#<%=bookedslots.ClientID%>').hide();
            $("#doctor").change(function () {
                 var doctorname = $("#doctor option:selected").text();
                $.ajax({
                    type: "POST",
                    url: "AddAppointment.aspx/DoctorAvail",
                    data: JSON.stringify({ doctorname: doctorname }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {

                        console.log(response);
                       
                            var xmlDoc = $.parseXML(response.d);

                            var xml = $(xmlDoc);
                            var patients = xml.find("Table");
                            var row = $("[id*=GridView1] tr:last-child").clone(true);
                            $("[id*=GridView1] tr").not($("[id*=GridView1] tr:first-child")).remove();
                            $.each(patients, function () {
                                var patient = $(this);
                                $("td", row).eq(0).find("span").html($(this).find("Day").text());
                                $("td", row).eq(1).find("span").html($(this).find("Morning").text());
                                $("td", row).eq(2).find("span").html($(this).find("Afternoon").text());

                                //AppendRow(row, $(this).find("PatientId").text(), $(this).find("FirstName").text(), $(this).find("LastName").text(), $(this).find("Age").text(), $(this).find("Gender").text(), $(this).find("Nationality").text(), $(this).find("Number").text(), $(this).find("Email").text(), $(this).find("Insurance").text())
                                $("[id*=GridView1]").append(row);
                                row = $("[id*=GridView1] tr:last-child").clone(true);
                            });
                        
                       

                    },

                    error: "error"
                });


            });
           

            $("#datepicker").datepicker({
                defaultDate: "+1w",
                minDate: 0,
                firstDay: 0,
                dateFormat: 'dd-mm-yy',
                changeMonth: true,
                numberOfMonths: 1,
                beforeShowDay: function (date) {
                    var day = date.getDay();
                    return [(day!=5),''];
                },
                onSelect: function (date, instance) {
                    $.ajax({
                        type: "POST",
                        url: "AddAppointment.aspx/Datepick",
                        data: JSON.stringify({ selectd: $("#datepicker").val()}),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            $("#slotinfo").hide();
                            $("#dateinfo").hide();
                            $('#<%=bookedslots.ClientID%>').show();
                            
                            var xmlDoc = $.parseXML(response.d);

                            var xml = $(xmlDoc);
                            if ((xml.find("Table").length)>0){
                            var patients = xml.find("Table");
                            var row = $("[id*=bookedslots] tr:last-child").clone(true);
                            $("[id*=bookedslots] tr").not($("[id*=bookedslots] tr:first-child")).remove();
                            $.each(patients, function () {
                                var patient = $(this);
                                $("td", row).eq(0).find("span").html($(this).find("AppointmentTime").text());

                                //AppendRow(row, $(this).find("PatientId").text(), $(this).find("FirstName").text(), $(this).find("LastName").text(), $(this).find("Age").text(), $(this).find("Gender").text(), $(this).find("Nationality").text(), $(this).find("Number").text(), $(this).find("Email").text(), $(this).find("Insurance").text())
                                $("[id*=bookedslots]").append(row);
                                row = $("[id*=bookedslots] tr:last-child").clone(true);
                            });
                        }
                         else {
                                $('#<%=bookedslots.ClientID%>').hide();
                                $("#slotinfo").show();
                            $("#slotinfo").html("all slots are available").css('color', 'green');
                        }

                        }

                    });

                }
                //onClose: function( selectedDate ) {

                //    /*var day1 = $("#booking-from").datepicker('getDate').getDate() + 1;                 
                //    var month1 = $("#booking-from").datepicker('getDate').getMonth();             
                //    var year1 = $("#booking-from").datepicker('getDate').getFullYear();
                //    year1 = year1.toString().substr(2,2);
                //    var fullDate = day1 + "-" + month1 + "-" + year1;*/			
                //    var minDate = $(this).datepicker('getDate');
                //    var newMin = new Date(minDate.setDate(minDate.getDate() + 1));
                //    $( "#booking-to" ).datepicker( "option", "minDate", newMin );
                //}
            });

            $("#timepicker").timepicker({

            });

            //$("#datetimepicker").datetimepicker({
            //    format: 'mm/dd/yyyy hh:ii',
            //    minDate: 0,
            //    autoclose: true,
            //    showHour: true,
            //    startDate:Date()

            //});
            $("#dateselect").on('click', function (e) {
                var a = $("#datepicker").val();
                var b = $("#timepicker").val();

                if (a.length > 0 && b.length > 0) {
                    $.ajax({
                        type: "POST",
                        url: "AddAppointment.aspx/DateValidate",
                        data: JSON.stringify({ selectd: $("#datepicker").val(), selectt: $("#timepicker").val() }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSuccess,
                        error: OnErrorCall
                    });
                    function OnSuccess(response) {
                        var res = response.d;

                        if (res == 0) {
                            $("#dateinfo").show();
                            $("#dateinfo").html("selected slot available").css('color', 'green');
                        }
                        else {
                            $("#dateinfo").show();
                            $("#dateinfo").html("selected slot is not available").css('color', 'red');
                        }
                    }

                    function OnErrorCall(response) {
                        $("#dateinfo").show();
                        $("#dateinfo").html("failed,something went wrong");
                    }
                }
                else {
                    $("#dateinfo").show();
                    $("#dateinfo").html("Please select date and time").css('color', 'red');
                }
            });

           


            $("#submitRecord").on('click', function (e) {

                $("#nameerror").hide();
                $("#dateerror").hide();
                $("#costerror").hide();
                $("#dateinfo").hide();

                verification = {};
                if (RegExp('^[a-zA-Z]+$').test($("#patientname").val())) {
                    verification.name = true;
                }
                else {
                    $("#nameerror").show();

                }

                if ($("#datepicker").val() && $("#timepicker").val()) {
                    verification.date = true;
                }
                else {
                    $("#dateinfo").html("Please select date and time").css('color', 'red');
                }

                if (RegExp('^[0-9]+$').test($("#cost").val())) {
                    verification.cost = true;
                }
                else {
                    $("#costerror").show();

                }

                var appdetails = {};
                e.preventDefault();
                if (document.getElementById("visit1").checked) {
                    appdetails.visit = $("#visit1").val();

                }

                else {
                    appdetails.visit = $("#visit2").val();
                }

                if (document.getElementById("visit3").checked) {
                    appdetails.firstvisit = $("#visit3").val();
                }
                else {
                    appdetails.firstvisit = "No";
                }
                appdetails.cost = $("#cost").val();
                
                if(document.getElementById("insurance1").checked){
                    appdetails.insurance = $("#insurance1").val();
                    $("#icompany").prop("enabled", true);
                }
                else if (document.getElementById("insurance2").checked)
                {
                    appdetails.insurance = $("#insurance2").val();
                    $("#icompany").prop("disabled", true);
                    $("#icompany").val("");

                }


                if (verification.name && verification.cost && verification.date) {
                    var id = $('#<%=PatientList.ClientID%>').val();
                    var name = $('#<%=patientname.ClientID%>').val();
                    $.ajax({
                        type: "POST",
                        url: "AddAppointment.aspx/AddApp",
                        data: JSON.stringify({ PatientID: id, PatientName: name, AppDate: $("#datepicker").val(), AppTime: $("#timepicker").val(), PatientVisit: appdetails.visit, Cost: appdetails.cost, Doctor: $("#doctor").val(), FirstVisit: appdetails.firstvisit,insurance:appdetails.insurance ,icompany:$("#icompany").val() }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSuccess,
                        error: OnErrorCall
                    });

                    function OnSuccess(response) {
                        var result = response.d;
                        if (result == "success") {
                            $("#msg").html("New Appointment addded successfully  :)").css("color", "green");
                        }
                        $("#patientname").val("");
                        // $("#AppDate").val("");
                        $("#cost").val("");


                    }

                    function OnErrorCall(response) {
                        $("#msg").html("Error occurs  :(").css("color", "red");
                    }
                }
                else {
                    $("#msg").html("Please fill all required details").css("color", "red");


                }

            });
         });


    </script>




    <div id="page-wrapper">

        <div class="container-fluid" style="min-height: 100%; height: 100%;">

            <!-- Page Heading -->
            <div class="row">
                <div class="col-lg-12">

                    <ol class="breadcrumb">
                        <li>
                            <i class="fa fa-dashboard"></i><a href="Home.aspx">Home</a>
                        </li>
                        <li>
                            <i class="fa fa-dashboard"></i><a href="AppointmentDetails.aspx">Appointment Details</a>
                        </li>
                        <li class="active">
                            <i class="fa fa-edit"></i>Add New Appointment
                            </li>
                    </ol>
                </div>
            </div>


            <div class="row">
                <form id="appform" runat="server">
                    <div class="col-lg-4">
                        <div>
                            <label>Patient ID</label>
                            <asp:DropDownList ID="PatientList" runat="server" AutoPostBack="true" Height="29px" Width="186px" OnSelectedIndexChanged="PatientList_SelectedIndexChanged" EnableViewState="true">
                                <asp:ListItem Selected="True" Text="Select PatientID"></asp:ListItem>
                            </asp:DropDownList>

                        </div>
                        <br />

                        <div class="form-group">
                            <label>Patient Name</label>
                            <asp:TextBox ID="patientname" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>

                            <%--<input class="form-control" placeholder="Enter text" id="patientname">--%>
                           

                        </div>

                          <div class="form-group">
                         <select id="doctor" name="doctor">
                             <option value="">Select Doctor</option>
                             <option id="doc1">Doctor1</option>
                             <option id="doc2">Doctor2</option>
                         </select>
                        </div>
                        <div class="form-group">
                            <div>
                                <label>Appointment Date</label>
                                <input type="text" id="datepicker" placeholder="Pick Date" name="SelectDate" readonly style="margin-bottom: 10%" />
                            </div>
                            <div>
                                 <asp:GridView ID="bookedslots" runat="server" AutoGenerateColumns="false" Width="117px">
                       <Columns>
                       <asp:TemplateField HeaderText="Slots Booked"  ItemStyle-CssClass="Name col-md-1">
                                    <ItemTemplate>
                                        <asp:Label Text='<%# Eval("AppointmentTime") %>' runat="server" />   
                                    </ItemTemplate>
                                </asp:TemplateField>
                       </Columns>
                        </asp:GridView>
                                <label id="slotinfo"></label>
                            </div>
                            <div>
                                <label>Appointment Time</label>
                                <input type="text" id="timepicker" placeholder="Pick Time" name="SelectTime" readonly />
                            </div>
                            
                        </div>
                       
                        <div class="form-group">
                            <input class="btn btn-primary" type="button" id="dateselect" value="Check Slot Availablity" />
                            <label id="dateinfo"></label>
                        </div>

                        <div class="form-group">
                            <label>Patient Visited</label>
                            <div class="radio">
                                <label>
                                    <input type="radio" name="optionsRadio" id="visit1" value="Visited" checked>Visited
                                   
                                </label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input type="radio" name="optionsRadio" id="visit2" value="Not Visited">Not Vsited
                                   
                                </label>
                            </div>

                        </div>

                        <div class="form-group">
                            <label>Cost of Appointment</label>
                            <input class="form-control" id="cost">
                            <label id="costerror" style="color: red; display: none">Not a valid Value</label>
                        </div>
                        <div class="form-group">
                               <label>Select Doctor</label>
                    
                        </div>
                        <div class="form-group">
                            <label>Insurance</label>
                            <div class="radio">
                                <label>
                                    <input type="radio" name="optionsRadios" id="insurance1" value="Insured" checked>Insured
                                   
                                </label>
                            </div>
                            <div class="radio">
                                <label>
                                    <input type="radio" name="optionsRadios" id="insurance2" value="Not Insured">Not Insured
                                   
                                </label>
                            </div>

                        </div>

                        <div class="form-group">
                            <label>Select Insurance Company</label>
                            <select id="icompany" name="InsuranceCompany">
                                <option value="SNIC" selected>SNIC</option>
                                <option value="MedGulf">MedGulf</option>
                            </select>
                        </div>
                        <div class="checkbox">
                            <label>
                                <input type="checkbox" value="yes" id="visit3">Is First Visit?
                                   
                            </label>
                        </div>

                        <label id="msg"></label>

                        <input type="button" class="btn btn-default btn-success" id="submitRecord" value="submit">
                  </div>
                    <div class="col-lg-1"></div>
                    <div class="col-lg-3 container">
                        
                        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" CssClass="table table-bordered table-hover">
                       <Columns>
                                <asp:TemplateField HeaderText="Day" ItemStyle-CssClass="CustomerId col-md-1">
                                    <ItemTemplate>
                                        <asp:Label Text='<%# Eval("Day") %>' runat="server" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Morning Time"  ItemStyle-CssClass="Name col-md-1">
                                    <ItemTemplate>
                                        <asp:Label Text='<%# Eval("Morning") %>' runat="server" />
                                      
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Afternoon Time" ItemStyle-CssClass="Country col-md-1">
                                    <ItemTemplate>
                                        <asp:Label Text='<%# Eval("Afternoon") %>' runat="server" />
                                       
                                    </ItemTemplate>
                                </asp:TemplateField>
                           </Columns>

                        </asp:GridView>

                    </div>
                </form>
            </div>





        </div>
    </div>
</asp:Content>
