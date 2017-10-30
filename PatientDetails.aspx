<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PatientDetails.aspx.cs" Inherits="HospitalsDashboard.PatientDetails" MasterPageFile="~/Main.Master" ClientTarget="uplevel" %>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="js/jquery.quicksearch.js"></script>
       <script type="text/javascript">
    
    $(function () {
        $.ajax({
            type: "POST",
            url: "PatientDetails.aspx/GetPatients",
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
               
                var xml = $(xmlDoc);
                var patients = xml.find("Table");
                var row = $("[id*=gvCustomers] tr:last-child").clone(true);
                $("[id*=gvCustomers] tr").not($("[id*=gvCustomers] tr:first-child")).remove();
                $.each(patients, function () {
                    var patient = $(this);
                    $("td", row).eq(0).find("span").html($(this).find("PatientId").text());
                    $("td", row).eq(1).find("span").html($(this).find("FirstName").text());
                    $("td", row).eq(1).find("input").val($(this).find("FirstName").text());
                    $("td", row).eq(2).find("span").html($(this).find("LastName").text());
                    $("td", row).eq(2).find("input").val($(this).find("LastName").text());
                    $("td", row).eq(3).find("span").html($(this).find("Age").text());
                   
                    $("td", row).eq(4).find("span").html($(this).find("Gender").text());
                    $("td", row).eq(4).find("input").val($(this).find("Gender").text());
                    $("td", row).eq(5).find("span").html($(this).find("Nationality").text());
                    $("td", row).eq(5).find("input").val($(this).find("Nationality").text());
                    $("td", row).eq(6).find("span").html($(this).find("cpr").text());
                    $("td", row).eq(6).find("input").val($(this).find("cpr").text());
                    $("td", row).eq(7).find("span").html($(this).find("Number").text());
                    $("td", row).eq(7).find("input").val($(this).find("Number").text());
                    $("td", row).eq(8).find("span").html($(this).find("Email").text());
                    $("td", row).eq(8).find("input").val($(this).find("Email").text());
                   
                    //AppendRow(row, $(this).find("PatientId").text(), $(this).find("FirstName").text(), $(this).find("LastName").text(), $(this).find("Age").text(), $(this).find("Gender").text(), $(this).find("Nationality").text(), $(this).find("Number").text(), $(this).find("Email").text(), $(this).find("Insurance").text())
                    $("[id*=gvCustomers]").append(row);
                    row = $("[id*=gvCustomers] tr:last-child").clone(true);
                });
            }
     
      
        //Delete event handler.
        
           $(document).on("click", "[id*=gvCustomers] .Delete", function () {
               
               if (confirm("Do you want to delete this row?")) {
                   var row = $(this).closest("tr");
                   
                   var PatientId =parseInt(row.find("span").html());
                  
                   $.ajax({
                       type: "POST",
                       url: "PatientDetails.aspx/DeletePatient",
                       data: JSON.stringify({ patientId: PatientId }),
                       contentType: "application/json; charset=utf-8",
                       dataType: "json",
                       success: function (response) {
                           if (response.d == "0") {
                               $("#errormsg").html("Record Cannot be Deleted,Appointment exist on this patient name").css("color", "red")
                           }
                           else {
                               row.remove();
                               $("#errormsg").html("Record has been deleted").css("color", "green")
                               //If the GridView has no records then display no records message.
                               if ($("[id*=gvCustomers] td").length == 0) {
                                   $("[id*=gvCustomers] tbody").append("<tr><td colspan = '4' align = 'center'>No records found.</td></tr>")
                                   $("#msg").html("No Records Found").css("color", "red")
                               }
                             
                           }
                          
                       }
                      
                      
                   });
               }

               return false;
           });

           //search patient

           $(function () {
               $('#searchid').keyup(function () {
                   $('#searchid').each(function (i) {
                       $(this).quicksearch("[id*=gvCustomers] tr:not(:has(th))", {
                           'testQuery': function (query, txt, row) {
                               return $(row).children(":eq(" + i + ")").text().toLowerCase().indexOf(query[0].toLowerCase()) != -1;

                           }
                       });
                   });
               });
           });

           //search CPR
           $(function () {
               $('#searchcpr').keyup(function () {
                   $('#searchcpr').each(function (i) {
                       $(this).quicksearch("[id*=gvCustomers] tr:not(:has(th))", {
                           'testQuery': function (query, txt, row) {
                               return $(row).children(":eq(" + i + ")").text().toLowerCase().indexOf(query[0].toLowerCase()) != -1;

                           }
                       });
                   });
               });
           });


                //Edit event handler.
                $(document).on("click", "[id*=gvCustomers] .Edit", function () {
                   
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
                $(document).on("click", "[id*=gvCustomers] .Update", function () {
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
 
                    var PatientId = row.find("span").html();
                    if (/^[0-9]+$/.test($("td", row).eq(6).find("span").html()) && /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test( $("td", row).eq(7).find("span").html())) {
                        var fname = $("td", row).eq(1).find("span").html();
                        var lname = $("td", row).eq(2).find("span").html();
                        var age = $("td", row).eq(3).find("span").html();
                        var gender = $("td", row).eq(4).find("span").html();
                        var country = $("td", row).eq(5).find("span").html();
                        var cpr = $("td", row).eq(6).find("span").html();
                        var number = $("td", row).eq(7).find("span").html();
                        var email = $("td", row).eq(8).find("span").html();
                      


                        $.ajax({
                            type: "POST",
                            url: "PatientDetails.aspx/UpdatePatient",
                            data: JSON.stringify({ PatientId: PatientId, fname: fname, lname: lname, gender: gender, country: country,cpr:cpr, number: number, email: email }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: $("#errormsg").html("Updation Success)").css("color", "green"),
                            error: OnErrorCall
                        });


                        function OnErrorCall(response) {
                            $("#errormsg").html("Updation Failed").css("color", "red");
                        }
                       
                    }
                    else {
                        $("#errormsg").html("Invalid Input,Updation Failed").css("color", "red");
                    }
                    return false;
                });
             
              
    //Cancel event handler.
    $(document).on("click", "[id*=gvCustomers] .Cancel", function () {
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
                        <h1 class="page-header"> </h1>
                        <ol class="breadcrumb">
                            <li>
                                <i class="fa fa-dashboard"></i>  <a href="Home.aspx">Dashboard</a>
                            </li>
                            <li class="active">
                                <i class="fa fa-edit"></i>Patient Details
                            </li>
                        </ol>
                    </div>
                   
                    
                    <div class="col-md-12">
                        <div class="col-md-2"><input type="text" id="searchid" placeholder="Search with PatientID" class="form-control" /></div>
                        <div class="col-md-2"><input type="text" id="searchcpr" placeholder="Search with CPR/ID" class="form-control" /></div>  
                        <div class="col-md-4 col-md-offset-1 pull-left"> <label id="errormsg"></label> </div>
                       
                        <div class="col-md-3" style="padding-bottom: 20px; text-align:right"> <a class="btn btn-default btn-success" href="AddPatient.aspx">+Add Patient</a> </div>
                        
                    </div>
                    
                    <div class="col-md-12">
                        <form id="form1" runat="server">
                         <asp:GridView ID="gvCustomers" runat="server" AutoGenerateColumns="false" CssClass="table table-bordered table-hover" PageSize="10" AllowPaging="true" OnSelectedIndexChanged="gvCustomers_SelectedIndexChanged" AlternatingRowStyle-BackColor="SkyBlue">
                            <Columns>
                                <asp:TemplateField HeaderText="Patient Id" ItemStyle-CssClass="CustomerId col-md-1">
                                    <ItemTemplate>
                                        <asp:Label Text='<%# Eval("PatientId") %>' runat="server" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="First Name"  ItemStyle-CssClass="Name col-md-1">
                                    <ItemTemplate>
                                        <asp:Label Text='<%# Eval("FirstName") %>' runat="server" />
                                        <asp:TextBox Text='<%# Eval("LastName") %>' runat="server" Style="display: none" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Last Name" ItemStyle-CssClass="Country col-md-1">
                                    <ItemTemplate>
                                        <asp:Label Text='<%# Eval("LastName") %>' runat="server" />
                                        <asp:TextBox Text='<%# Eval("LastName") %>' runat="server" Style="display: none" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                 <asp:TemplateField HeaderText="Age"  ItemStyle-CssClass="Name col-md-1">
                                    <ItemTemplate>
                                        <asp:Label Text='<%# Eval("Age") %>' runat="server" />
               
                                    </ItemTemplate>
                                </asp:TemplateField>
                                 <asp:TemplateField HeaderText="Gender"  ItemStyle-CssClass="Name col-md-1">
                                    <ItemTemplate>
                                        <asp:Label Text='<%# Eval("Gender") %>' runat="server" />
                                        <asp:TextBox Text='<%# Eval("Gender") %>' runat="server" Style="display: none" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Nationality"  ItemStyle-CssClass="Name col-md-1">
                                    <ItemTemplate>
                                        <asp:Label Text='<%# Eval("Nationality") %>' runat="server" />
                                        <asp:TextBox Text='<%# Eval("Nationality") %>' runat="server" Style="display: none" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="CPR/ID"  ItemStyle-CssClass="Name col-md-1">
                                    <ItemTemplate>
                                        <asp:Label Text='<%# Eval("cpr") %>' runat="server" />
                                        <asp:TextBox Text='<%# Eval("cpr") %>' runat="server" Style="display: none" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                 <asp:TemplateField HeaderText="Mobile"  ItemStyle-CssClass="Name col-md-1">
                                    <ItemTemplate>
                                        <asp:Label Text='<%# Eval("Number") %>' runat="server" />
                                        <asp:TextBox Text='<%# Eval("Number") %>' runat="server" Style="display: none" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                 <asp:TemplateField HeaderText="Email"  ItemStyle-CssClass="Name col-md-2">
                                    <ItemTemplate>
                                        <asp:Label Text='<%# Eval("Email") %>' runat="server" />
                                        <asp:TextBox Text='<%# Eval("Email") %>' runat="server" Style="display: none" />
                                    </ItemTemplate>
                                </asp:TemplateField>
        
                            
        
                                <asp:TemplateField ItemStyle-CssClass="col-md-2">
                                    <ItemTemplate>
                                        <asp:LinkButton Text="Edit" runat="server" CssClass="Edit btn btn-primary" />
                                        <asp:LinkButton Text="Update" runat="server" CssClass="Update btn btn-success" Style="display: none; margin-bottom: 5px; " />
                                        <asp:LinkButton Text="Cancel" runat="server" CssClass="Cancel btn btn-warning" Style="display: none" />
                                        <asp:LinkButton Text="Delete" runat="server" CssClass="Delete btn btn-danger" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>

      </form> 
                         </div> 
                        
                   
                </div>
            </div>
        </div>
        <!-- /#page-wrapper -->

</asp:Content>