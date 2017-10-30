<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StaffDetails.aspx.cs" Inherits="HospitalsDashboard.StaffDetails" MasterPageFile="~/Main.Master" %>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  



    <script type="text/javascript">
    
    $(function () {
        $.ajax({
            type: "POST",
            url: "StaffDetails.aspx/GetStaff",
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
                var row = $("[id*=gvstaff] tr:last-child").clone(true);
                $("[id*=gvstaff] tr").not($("[id*=gvstaff] tr:first-child")).remove();
                $.each(patients, function () {
                    var patient = $(this);
                    $("td", row).eq(0).find("span").html($(this).find("StaffId").text());
                    $("td", row).eq(1).find("span").html($(this).find("FirstName").text());
                    $("td", row).eq(1).find("input").val($(this).find("FirstName").text());
                    $("td", row).eq(2).find("span").html($(this).find("MiddleName").text());
                    $("td", row).eq(2).find("input").val($(this).find("MiddleName").text());
                    $("td", row).eq(3).find("span").html($(this).find("LastName").text());
                    $("td", row).eq(3).find("input").val($(this).find("LastName").text());
                    $("td", row).eq(4).find("span").html($(this).find("Age").text());
                   
                    $("td", row).eq(5).find("span").html($(this).find("ID").text());
                    $("td", row).eq(5).find("input").val($(this).find("ID").text());
                    $("td", row).eq(6).find("span").html($(this).find("Gender").text());
                    $("td", row).eq(6).find("input").val($(this).find("Gender").text());
                    $("td", row).eq(7).find("span").html($(this).find("Nationality").text());
                    $("td", row).eq(7).find("input").val($(this).find("Nationality").text());
                    $("td", row).eq(8).find("span").html($(this).find("Address").text());
                    $("td", row).eq(8).find("input").val($(this).find("Address").text());
                    $("td", row).eq(9).find("span").html($(this).find("Number").text());
                    $("td", row).eq(9).find("input").val($(this).find("Number").text());
                    $("td", row).eq(10).find("span").html($(this).find("Email").text());
                    $("td", row).eq(10).find("input").val($(this).find("Email").text());
                    
                    //AppendRow(row, $(this).find("PatientId").text(), $(this).find("FirstName").text(), $(this).find("LastName").text(), $(this).find("Age").text(), $(this).find("Gender").text(), $(this).find("Nationality").text(), $(this).find("Number").text(), $(this).find("Email").text(), $(this).find("Insurance").text())
                    $("[id*=gvstaff]").append(row);
                    row = $("[id*=gvstaff] tr:last-child").clone(true);
                });
            }
     
      
        //Delete event handler.
        
           $(document).on("click", "[id*=gvstaff] .Delete", function () {
               
               if (confirm("Do you want to delete this row?")) {
                   var row = $(this).closest("tr");
                   
                   var StaffId =parseInt(row.find("span").html());
                  
                   $.ajax({
                       type: "POST",
                       url: "StaffDetails.aspx/DeleteStaff",
                       data: JSON.stringify({ StaffId: StaffId }),
                       contentType: "application/json; charset=utf-8",
                       dataType: "json",
                       success: function (response) {
                           if (response.d) {
                               row.remove();
                               $("#errormsg").html("Record has been deleted").css("color", "green")
                               //If the GridView has no records then display no records message.
                               if ($("[id*=gvstaff] td").length == 0) {
                                   $("[id*=gvstaff] tbody").append("<tr><td colspan = '4' align = 'center'>No records found.</td></tr>")
                                   $("#errormsg").html("No Records Found").css("color", "red")
                               }
                             
                           }
                       }
                      
                   });
               }

               return false;
           });

       


                //Edit event handler.
                $(document).on("click", "[id*=gvstaff] .Edit", function () {
                   
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
                $(document).on("click", "[id*=gvstaff] .Update", function () {
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
                    if (/^[0-9]+$/.test($("td", row).eq(9).find("span").html()) && /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test($("td", row).eq(10).find("span").html())) {
                        var StaffId = row.find("span").html();

                        var fname = $("td", row).eq(1).find("span").html();
                        var mname = $("td", row).eq(2).find("span").html();
                        var lname = $("td", row).eq(3).find("span").html();
                        var age = $("td", row).eq(4).find("span").html();
                        var id = $("td", row).eq(5).find("span").html();
                        var gender = $("td", row).eq(6).find("span").html();
                        var country = $("td", row).eq(7).find("span").html();
                        var address = $("td", row).eq(8).find("span").html();
                        var number = $("td", row).eq(9).find("span").html();
                        var email = $("td", row).eq(10).find("span").html();



                        $.ajax({
                            type: "POST",
                            url: "StaffDetails.aspx/UpdateStaff",
                            data: JSON.stringify({ StaffId: StaffId, fname: fname, mname: mname, lname: lname, id: id, gender: gender, country: country, address: address, number: number, email: email }),
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
    $(document).on("click", "[id*=gvstaff] .Cancel", function () {
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
                        <h1 class="page-header">
                           
                        </h1>
                        <ol class="breadcrumb">
                            <li>
                                <i class="fa fa-dashboard"></i>  <a href="Home.aspx">Dashboard</a>
                            </li>
                            <li class="active">
                                <i class="fa fa-edit"></i>Staff Details
                            </li>
                        </ol>
                    </div>
                </div>
    
                
              
               
               <div class="col-md-12">            
                        <div class="col-md-6 pull-left"> <label id="errormsg"></label> </div>
                        <div class="col-md-6" style="padding-bottom: 20px; text-align:right"> <a class="btn btn-default btn-success" href="AddStaff.aspx">+Add Staff</a> </div>
                    </div>
               
   <div class="col-md-12">
                <form id="form1" runat="server">
 
                     <br />  
       


          <asp:GridView ID="gvstaff" runat="server" AutoGenerateColumns="false" CssClass="table table-bordered table-hover" PageSize="10" AllowPaging="true" AlternatingRowStyle-BackColor="SkyBlue">
    <Columns>
        <asp:TemplateField HeaderText="Staff Id" ItemStyle-Width="110px" ItemStyle-CssClass="CustomerId col-md-1">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("StaffId") %>' runat="server" />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="First Name" ItemStyle-Width="150px" ItemStyle-CssClass="Name col-md-1">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("FirstName") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("LastName") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Middle Name" ItemStyle-Width="150px" ItemStyle-CssClass="Name col-md-1">
        <ItemTemplate>
                <asp:Label Text='<%# Eval("MiddleName") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("MiddleName") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Last Name" ItemStyle-Width="150px" ItemStyle-CssClass="Country col-md-1">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("LastName") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("LastName") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
         <asp:TemplateField HeaderText="Age" ItemStyle-Width="150px" ItemStyle-CssClass="Name col-md-1">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("Age") %>' runat="server" />
               
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="CPR\ID" ItemStyle-Width="150px" ItemStyle-CssClass="Name col-md-1">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("ID") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("ID") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
         <asp:TemplateField HeaderText="Gender" ItemStyle-Width="150px" ItemStyle-CssClass="Name col-md-1">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("Gender") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("Gender") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
         <asp:TemplateField HeaderText="Address" ItemStyle-Width="150px" ItemStyle-CssClass="Name col-md-1">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("Address") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("Address") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
        
        <asp:TemplateField HeaderText="Nationality" ItemStyle-Width="150px" ItemStyle-CssClass="Name col-md-1">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("Nationality") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("Nationality") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
         <asp:TemplateField HeaderText="Mobile" ItemStyle-Width="150px" ItemStyle-CssClass="Name col-md-1">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("Number") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("Number") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
         <asp:TemplateField HeaderText="Email" ItemStyle-Width="150px" ItemStyle-CssClass="Name col-md-1">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("Email") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("Email") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
        
        <asp:TemplateField ItemStyle-CssClass="Name col-md-1">
            <ItemTemplate>
                <asp:LinkButton Text="Edit" runat="server" CssClass="Edit btn btn-primary" />
                <asp:LinkButton Text="Update" runat="server" CssClass="Update btn btn-success" Style="display: none" />
                <asp:LinkButton Text="Cancel" runat="server" CssClass="Cancel btn btn-warning" Style="display: none" />
                <asp:LinkButton Text="Delete" runat="server" CssClass="Delete btn btn-danger" />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>

</form>

                </div>
        </div>
        <!-- /#page-wrapper -->

   
    <!-- /#wrapper -->


</asp:Content>