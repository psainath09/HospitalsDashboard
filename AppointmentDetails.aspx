<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AppointmentDetails.aspx.cs" Inherits="HospitalsDashboard.AppointmentDetails" MasterPageFile="~/Main.Master" %>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <script src="js/jquery.quicksearch.js"></script>

    <script type="text/javascript">

        $(function () {
            $.ajax({
                type: "POST",
                url: "AppointmentDetails.aspx/GetAppointments",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnSuccess,
                failure: function (response) {
                    $("#errormsg").html("Error occured").css("color", "red");
                    alert(response.d);
                },
                error: function (response) {
                    alert(response.d);
                }
            });
        });
        function OnSuccess(response) {

            var xmlDoc = $.parseXML(response.d);
            console.log(xmlDoc);
            var xml = $(xmlDoc);
            var patients = xml.find("Table");
            var row = $("[id*=gvAppointments] tr:last-child").clone(true);
            $("[id*=gvAppointments] tr").not($("[id*=gvAppointments] tr:first-child")).remove();
            $.each(patients, function () {
                var patient = $(this);
                $("td", row).eq(0).find("span").html($(this).find("AppointmentId").text());
                $("td", row).eq(1).find("span").html($(this).find("PatientId").text());

                $("td", row).eq(2).find("span").html($(this).find("PatientName").text());
                $("td", row).eq(2).find("input").val($(this).find("PatientName").text());
                $("td", row).eq(3).find("span").html($(this).find("AppointmentDate").text());
                $("td", row).eq(3).find("input").val($(this).find("AppointmentDate").text());
                $("td", row).eq(4).find("span").html($(this).find("AppointmentTime").text());
                $("td", row).eq(4).find("input").val($(this).find("AppointmentTime").text());
                $("td", row).eq(5).find("span").html($(this).find("PatientVisit").text());
                $("td", row).eq(5).find("input").val($(this).find("PatientVisit").text());
                $("td", row).eq(6).find("span").html($(this).find("Icompany").text());
                $("td", row).eq(6).find("input").val($(this).find("Icompany").text());
                $("td", row).eq(7).find("span").html($(this).find("Cost").text());
                $("td", row).eq(7).find("input").val($(this).find("Cost").text());
                $("td", row).eq(8).find("span").html($(this).find("Doctor").text());
                $("td", row).eq(8).find("input").val($(this).find("Doctor").text());
                $("td", row).eq(9).find("span").html($(this).find("FirstVisit").text());
                $("td", row).eq(9).find("input").val($(this).find("FirstVisit").text());

                //AppendRow(row, $(this).find("PatientId").text(), $(this).find("FirstName").text(), $(this).find("LastName").text(), $(this).find("Age").text(), $(this).find("Gender").text(), $(this).find("Nationality").text(), $(this).find("Number").text(), $(this).find("Email").text(), $(this).find("Insurance").text())
                $("[id*=gvAppointments]").append(row);
                row = $("[id*=gvAppointments] tr:last-child").clone(true);
            });
        }


        //search patient

        $(function () {
            $('#searchappid').keyup(function () {
                $('#searchappid').each(function (i) {
                    $(this).quicksearch("[id*=gvAppointments] tr:not(:has(th))", {
                        'testQuery': function (query, txt, row) {
                            return $(row).children(":eq(" + i + ")").text().toLowerCase().indexOf(query[0].toLowerCase()) != -1;

                        }
                    });
                });
            });
        });


        //Delete event handler.

        $(document).on("click", "[id*=gvAppointments] .Delete", function () {

            if (confirm("Do you want to delete this row?")) {
                var row = $(this).closest("tr");

                var PatientId = parseInt(row.find("span").html());

                $.ajax({
                    type: "POST",
                    url: "AppointmentDetails.aspx/DeleteAppointment",
                    data: JSON.stringify({ AppointmentId: PatientId }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d) {
                            row.remove();
                            $("#errormsg").html("Record has been deleted").css("color", "green")
                            //If the GridView has no records then display no records message.
                            if ($("[id*=gvAppointments] td").length == 0) {
                                $("[id*=gvAppointments] tbody").append("<tr><td colspan = '4' align = 'center'>No records found.</td></tr>")
                                $("#errormsg").html("No Records Found").css("color", "red")
                            }

                        }
                    }

                });
            }

            return false;
        });




        //Edit event handler.
        $(document).on("click", "[id*=gvAppointments] .Edit", function () {

            var row = $(this).closest("tr");
            $("td", row).each(function () {
                if ($(this).find("input").length > 0) {
                    $(this).find("input").show();
                    $(this).find("span").hide();
                }
            });
            row.find(".Update").show();
            row.find(".Cancel").show();
            row.find(".Delete").hide();
            $(this).hide();
            return false;
        });



        //Update event handler.
        $(document).on("click", "[id*=gvAppointments] .Update", function () {
            var row = $(this).closest("tr");
            $("td", row).each(function () {
                if ($(this).find("input").length > 0) {
                    var span = $(this).find("span");
                    var input = $(this).find("input");
                    span.html(input.val());
                    span.show();
                    input.hide();
                }
            });
            row.find(".Edit").show();
            row.find(".Delete").show();
            row.find(".Cancel").hide();
            $(this).hide();

            var AppointmentId = row.find("span").html();
            var PatientId = $("td", row).eq(1).find("span").html();
            var PatientName = $("td", row).eq(2).find("span").html();
            var AppointmentDate = $("td", row).eq(3).find("span").html();
            var AppointmentTime = $("td", row).eq(4).find("span").html();
            var PatientVisit = $("td", row).eq(5).find("span").html();
            var icompany = $("td", row).eq(6).find("span").html();
            var Cost = $("td", row).eq(7).find("span").html();
            var Doctor = $("td", row).eq(8).find("span").html();
            var FirstVisit = $("td", row).eq(9).find("span").html();


            $.ajax({
                type: "POST",
                url: "AppointmentDetails.aspx/UpdateAppointment",
                data: JSON.stringify({ AppointmentId: AppointmentId, PatientName: PatientName, AppointmentDate: AppointmentDate,AppointmentTime:AppointmentTime, PatientVisit: PatientVisit, Cost: Cost, Doctor: Doctor, FirstVisit: FirstVisit,icompany:icompany }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: $("#errormsg").html("Updation Success)").css("color", "green"),
                error: OnErrorCall
            });


            function OnErrorCall(response) {
                $("#errormsg").html("Updation Failed").css("color", "red");
            }
            return false;
        });


        //Cancel event handler.
        $(document).on("click", "[id*=gvAppointments] .Cancel", function () {
            var row = $(this).closest("tr");
            $("td", row).each(function () {
                if ($(this).find("input").length > 0) {
                    var span = $(this).find("span");
                    var input = $(this).find("input");
                    input.val(span.html());
                    span.show();
                    input.hide();
                }
            });
            row.find(".Edit").show();
            row.find(".Delete").show();
            row.find(".Update").hide();
            $(this).hide();
            return false;
        });


    </script>

 

            <div id="page-wrapper">

                <div class="container-fluid" style="min-height: 100%; height: 100%;">

                    <!-- Page Heading -->
                    <div class="row">
                        <div class="col-md-12">
                            <h1 class="page-header"></h1>
                            <ol class="breadcrumb">
                                <li>
                                    <i class="fa fa-dashboard"></i><a href="Home.aspx">Dashboard</a>
                                </li>
                                <li class="active">
                                    <i class="fa fa-edit"></i>Appointment Details
                            </li>
                            </ol>
                        </div>
                    </div>

                    <div class="col-md-12">
                      
                      <div class="col-md-3">  <input type="text" id="searchappid" class="form-control" placeholder="Search with Appointment ID" /></div>
                            
                        <div class="col-md-5 col-md-offset-1 pull-left">
                            <label id="errormsg"></label>
                        </div>
                        
                        <div class="col-md-3" style="padding-bottom: 20px; text-align: right"><a class="btn btn-default btn-success" href="AddAppointment.aspx">Add Appointment</a> </div>
                    </div>
                    <div class="col-md-12">
                        <form id="Appform" runat="server">




                            <asp:GridView ID="gvAppointments" runat="server" AutoGenerateColumns="false" CssClass="table table-bordered table-hover" PageSize="10" AllowPaging="true" AlternatingRowStyle-BackColor="SkyBlue">
                                <Columns>
                                    <asp:TemplateField HeaderText="Appointment Id" ItemStyle-Width="110px" ItemStyle-CssClass="AppointmentId col-md-1">
                                        <ItemTemplate>
                                            <asp:Label Text='<%# Eval("AppointmentId") %>' runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Patient Id" ItemStyle-Width="110px" ItemStyle-CssClass="AppointmentId col-md-1">
                                        <ItemTemplate>
                                            <asp:Label Text='<%# Eval("PatientId") %>' runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Patient Name" ItemStyle-Width="150px" ItemStyle-CssClass="Name col-md-1">
                                        <ItemTemplate>
                                            <asp:Label Text='<%# Eval("PatientName") %>' runat="server" />
                                            <asp:TextBox Text='<%# Eval("PatientName") %>' runat="server" Style="display: none" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Appointment Date " ItemStyle-Width="150px" ItemStyle-CssClass="Country col-md-1">
                                        <ItemTemplate>
                                            <asp:Label Text='<%# Eval("AppointmentDate") %>' runat="server" />
                                            <asp:TextBox Text='<%# Eval("AppointmentDate") %>' runat="server" Style="display: none" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Appointment Time" ItemStyle-Width="150px" ItemStyle-CssClass="Country col-md-1">
                                        <ItemTemplate>
                                            <asp:Label Text='<%# Eval("AppointmentTime") %>' runat="server" />
                                            <asp:TextBox Text='<%# Eval("AppointmentTime") %>' runat="server" Style="display: none" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Patient Visit" ItemStyle-Width="150px" ItemStyle-CssClass="Name col-md-1">
                                        <ItemTemplate>
                                            <asp:Label Text='<%# Eval("PatientVisit") %>' runat="server" />
                                            <asp:TextBox Text='<%# Eval("PatientVisit") %>' runat="server" Style="display: none" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                     <asp:TemplateField HeaderText="Insurance Company" ItemStyle-Width="150px" ItemStyle-CssClass="Name col-md-1">
                                        <ItemTemplate>
                                            <asp:Label Text='<%# Eval("Icompany") %>' runat="server" />
                                            <asp:TextBox Text='<%# Eval("Icompany") %>' runat="server" Style="display: none" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    
                                    <asp:TemplateField HeaderText="Appointment Cost" ItemStyle-Width="150px" ItemStyle-CssClass="Name col-md-1">
                                        <ItemTemplate>
                                            <asp:Label Text='<%# Eval("Cost") %>' runat="server" />
                                            <asp:TextBox Text='<%# Eval("Cost") %>' runat="server" Style="display: none" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Doctor" ItemStyle-Width="150px" ItemStyle-CssClass="Name col-md-1">
                                        <ItemTemplate>
                                            <asp:Label Text='<%# Eval("Doctor") %>' runat="server" />
                                            <asp:TextBox Text='<%# Eval("Doctor") %>' runat="server" Style="display: none" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="First Visit" ItemStyle-Width="150px" ItemStyle-CssClass="Name col-md-1">
                                        <ItemTemplate>
                                            <asp:Label Text='<%# Eval("FirstVisit") %>' runat="server" />
                                            <asp:TextBox Text='<%# Eval("FirstVisit") %>' runat="server" Style="display: none" />
                                        </ItemTemplate>
                                    </asp:TemplateField>



                                    <asp:TemplateField ItemStyle-CssClass="col-md-2">
                                        <ItemTemplate>
                                            <asp:LinkButton Text="Edit" runat="server" CssClass="Edit btn btn-primary" />
                                            <asp:LinkButton Text="Update" runat="server" CssClass="Update btn btn-success" Style="display: none; margin-bottom: 5px;" />
                                            <asp:LinkButton Text="Cancel" runat="server" CssClass="Cancel btn btn-warning" Style="display: none" />
                                            <asp:LinkButton Text="Delete" runat="server" CssClass="Delete btn btn-danger" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>

                        </form>

                    </div>
                    <!-- /.container-fluid -->

                </div>
                <!-- /#page-wrapper -->

            </div>
            <!-- /#wrapper -->
           </div>
            <!-- jQuery -->
</asp:Content>
