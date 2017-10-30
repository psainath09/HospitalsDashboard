<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DoctorDetails.aspx.cs" Inherits="HospitalsDashboard.DoctorDetails" MasterPageFile="~/Main.Master" %>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <script type="text/javascript">
    
    $(function () {
        $.ajax({
            type: "POST",
            url: "DoctorDetails.aspx/GetDoctors",
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
                var row = $("[id*=gvdoctors] tr:last-child").clone(true);
                $("[id*=gvdoctors] tr").not($("[id*=gvdoctors] tr:first-child")).remove();
                $.each(patients, function () {
                    var patient = $(this);
                    $("td", row).eq(0).find("span").html($(this).find("DoctorId").text());
                    $("td", row).eq(1).find("span").html($(this).find("FirstName").text());
                    $("td", row).eq(1).find("input").val($(this).find("FirstName").text());
                    $("td", row).eq(2).find("span").html($(this).find("MiddleName").text());
                    $("td", row).eq(2).find("input").val($(this).find("MiddleName").text());
                    $("td", row).eq(3).find("span").html($(this).find("LastName").text());
                    $("td", row).eq(3).find("input").val($(this).find("LastName").text());
                    $("td", row).eq(4).find("span").html($(this).find("Address").text());
                    $("td", row).eq(4).find("input").val($(this).find("Address").text());
                    $("td", row).eq(5).find("span").html($(this).find("Number").text());
                    $("td", row).eq(5).find("input").val($(this).find("Number").text());
                    $("td", row).eq(6).find("span").html($(this).find("Email").text());
                    $("td", row).eq(6).find("input").val($(this).find("Email").text());
                    $("td", row).eq(7).find("span").html($(this).find("FirstCharge").text());
                    $("td", row).eq(7).find("input").val($(this).find("FirstCharge").text());
                    $("td", row).eq(8).find("span").html($(this).find("FollowCharge").text());
                    $("td", row).eq(8).find("input").val($(this).find("FollowCharge").text());
                    //AppendRow(row, $(this).find("PatientId").text(), $(this).find("FirstName").text(), $(this).find("LastName").text(), $(this).find("Age").text(), $(this).find("Gender").text(), $(this).find("Nationality").text(), $(this).find("Number").text(), $(this).find("Email").text(), $(this).find("Insurance").text())
                    $("[id*=gvdoctors]").append(row);
                    row = $("[id*=gvdoctors] tr:last-child").clone(true);
                });
            }
     
      
        //Delete event handler.
        
       $(document).on("click", "[id*=gvdoctors] .Delete", function () {
               
               if (confirm("Do you want to delete this row?")) {
                   var row = $(this).closest("tr");
                   
                   var PatientId =parseInt(row.find("span").html());
                  
                   $.ajax({
                       type: "POST",
                       url: "DoctorDetails.aspx/DeleteDoctor",
                       data: JSON.stringify({ DoctorId: PatientId }),
                       contentType: "application/json; charset=utf-8",
                       dataType: "json",
                       success: function (response) {
                           if (response.d) {
                               row.remove();
                               $("#errormsg").html("Record has been deleted").css("color", "green")
                               //If the GridView has no records then display no records message.
                               if ($("[id*=gvdoctors] td").length == 0) {
                                   $("[id*=gvdoctors] tbody").append("<tr><td colspan = '4' align = 'center'>No records found.</td></tr>")
                                   $("#msg").html("No Records Found").css("color", "red")
                               }
                             
                           }
                       }
                      
                   });
               }

               return false;
           });

       


                //Edit event handler.
       $(document).on("click", "[id*=gvdoctors] .Edit", function () {
                   
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
       $(document).on("click", "[id*=gvdoctors] .Update", function () {
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
 
                    var DoctorId = row.find("span").html();
                   
                    var fname = $("td", row).eq(1).find("span").html();
                    var mname = $("td", row).eq(2).find("span").html();
                    var lname = $("td", row).eq(3).find("span").html();
                    var address = $("td", row).eq(4).find("span").html();
                    var number = $("td", row).eq(5).find("span").html();
                    var email = $("td", row).eq(6).find("span").html();
                    var firstcharge = $("td", row).eq(7).find("span").html();
                    var followcharge = $("td", row).eq(8).find("span").html();
                    
                    
        
                    $.ajax({
                        type: "POST",
                        url: "DoctorDetails.aspx/UpdateDoctors",
                        data: JSON.stringify({DoctorId: DoctorId , fname: fname ,mname:mname, lname: lname, address:  address , number: number ,email: email ,firstcharge:firstcharge,followcharge: followcharge }),
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
       $(document).on("click", "[id*=gvdoctorss] .Cancel", function () {
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
                    <div class="col-lg-12">
                        <h1 class="page-header">
                           
                        </h1>
                        <ol class="breadcrumb">
                            <li>
                                <i class="fa fa-dashboard"></i>  <a href="Home.aspx">Dashboard</a>
                            </li>
                            <li class="active">
                                <i class="fa fa-edit"></i>Doctor Details
                            </li>
                        </ol>
                    </div>
                </div>
    
                
              
             
                <label id="errormsg"></label>
   
                <form id="form1" runat="server">
 
                     <br />  
       


          <asp:GridView ID="gvdoctors" runat="server" AutoGenerateColumns="false" CssClass="table table-bordered table-hover" PageSize="10" AllowPaging="true">
    <Columns>
        <asp:TemplateField HeaderText="Doctor Id" ItemStyle-Width="110px" ItemStyle-CssClass="CustomerId">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("DoctorId") %>' runat="server" />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="First Name" ItemStyle-Width="150px" ItemStyle-CssClass="Name">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("FirstName") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("FirstName") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Middle Name" ItemStyle-Width="150px" ItemStyle-CssClass="Name">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("MiddleName") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("MiddleName") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Last Name" ItemStyle-Width="150px" ItemStyle-CssClass="Country">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("LastName") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("LastName") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
         <asp:TemplateField HeaderText="Address" ItemStyle-Width="150px" ItemStyle-CssClass="Name">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("Address") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("Address") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
         
        
         <asp:TemplateField HeaderText="Mobile" ItemStyle-Width="150px" ItemStyle-CssClass="Name">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("Number") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("Number") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
         <asp:TemplateField HeaderText="Email" ItemStyle-Width="150px" ItemStyle-CssClass="Name">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("Email") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("Email") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
         <asp:TemplateField HeaderText="First Vist Charge" ItemStyle-Width="150px" ItemStyle-CssClass="Name">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("FirstCharge") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("FirstCharge") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Followup Charge" ItemStyle-Width="150px" ItemStyle-CssClass="Name">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("FollowCharge") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("FollowCharge") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField>
            <ItemTemplate>
                <asp:LinkButton Text="Edit" runat="server" CssClass="Edit" />
                <asp:LinkButton Text="Update" runat="server" CssClass="Update" Style="display: none" />
                <asp:LinkButton Text="Cancel" runat="server" CssClass="Cancel" Style="display: none" />
                <asp:LinkButton Text="Delete" runat="server" CssClass="Delete" />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>

</form>

                </div>
        </div>
        <!-- /#page-wrapper -->

   
   


</asp:Content>