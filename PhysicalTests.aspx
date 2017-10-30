<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PhysicalTests.aspx.cs" Inherits="HospitalsDashboard.PhysicalTests" MasterPageFile="~/Main.Master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  
    <script src="js/jquery.quicksearch.js"></script>

    <script type="text/javascript">
    
        $(function () {

            
          
           
        $.ajax({
            type: "POST",
            url: "PhysicalTests.aspx/GetTests",
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
                var row = $("[id*=gvdetails] tr:last-child").clone(true);
                $("[id*=gvdetails] tr").not($("[id*=gvdetails] tr:first-child")).remove();
                $.each(patients, function () {
                    var patient = $(this);
                    $("td", row).eq(0).find("span").html($(this).find("AppointmentId").text());
                    $("td", row).eq(1).find("span").html($(this).find("PatientName").text());
                    
                    $("td", row).eq(2).find("span").html($(this).find("Weight").text());
                    $("td", row).eq(2).find("input").val($(this).find("Weight").text());
                    $("td", row).eq(3).find("span").html($(this).find("Height").text());
                    $("td", row).eq(3).find("input").val($(this).find("Height").text());
                    $("td", row).eq(4).find("span").html($(this).find("Temperature").text());
                    $("td", row).eq(4).find("input").val($(this).find("Temperature").text());
                    $("td", row).eq(5).find("span").html($(this).find("Head").text());
                    $("td", row).eq(5).find("input").val($(this).find("Head").text());
                    
                   
                    //AppendRow(row, $(this).find("PatientId").text(), $(this).find("FirstName").text(), $(this).find("LastName").text(), $(this).find("Age").text(), $(this).find("Gender").text(), $(this).find("Nationality").text(), $(this).find("Number").text(), $(this).find("Email").text(), $(this).find("Insurance").text())
                    $("[id*=gvdetails]").append(row);
                    row = $("[id*=gvdetails] tr:last-child").clone(true);
                });
            }
     
      
        //Delete event handler.
        
       //$(document).on("click", "[id*=gvdetails] .Delete", function () {
               
       //        if (confirm("Do you want to delete this row?")) {
       //            var row = $(this).closest("tr");
                   
       //            var PatientId =parseInt(row.find("span").html());
                  
       //            $.ajax({
       //                type: "POST",
       //                url: "PhysicalTests.aspx/DeleteTest",
       //                data: JSON.stringify({ Appointmentid: PatientId }),
       //                contentType: "application/json; charset=utf-8",
       //                dataType: "json",
       //                success: function (response) {
       //                    if (response.d) {
       //                        row.remove();
       //                        $("#errormsg").html("Record has been deleted").css("color", "green")
       //                        //If the GridView has no records then display no records message.
       //                        if ($("[id*=gvCustomers] td").length == 0) {
       //                            $("[id*=gvCustomers] tbody").append("<tr><td colspan = '4' align = 'center'>No records found.</td></tr>")
       //                            $("#msg").html("No Records Found").css("color", "red")
       //                        }
                             
       //                    }
       //                }
                      
       //            });
       //        }

       //        return false;
       //    });

       //search patient

       $(function () {
           $('#testid').keyup(function () {
               $('#testid').each(function (i) {
                   $(this).quicksearch("[id*=gvdetails] tr:not(:has(th))", {
                       'testQuery': function (query, txt, row) {
                           return $(row).children(":eq(" + i + ")").text().toLowerCase().indexOf(query[0].toLowerCase()) != -1;

                       }
                   });
               });
           });
       });


                //Edit event handler.
           $(document).on("click", "[id*=gvdetails] .Edit", function () {
                   
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
                $(document).on("click", "[id*=gvdetails] .Update", function () {
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
                   
                    var weight = $("td", row).eq(2).find("span").html();
                    var height = $("td", row).eq(3).find("span").html();
                    var temp = $("td", row).eq(4).find("span").html();
                    var head = $("td", row).eq(5).find("span").html();
                   
                    
        
                    $.ajax({
                        type: "POST",
                        url: "PhysicalTests.aspx/UpdateTests",
                        data: JSON.stringify({AppointmentId:AppointmentId , Weight:weight  , Height: height, Temperature:  temp , Head: head  }),
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
                $(document).on("click", "[id*=gvdetails] .Cancel", function () {
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
                                <i class="fa fa-edit"></i>Patient Physical Test Details
                            </li>
                        </ol>
                    </div>
                </div>
                 
               
               
                <div class="row">
                
                    <div class="col-md-3">
                      <input type="text" id="testid" class="form-control" placeholder="Search Appointment ID" style="margin-bottom:20px" />
                      <label id="errormsg" style="margin-bottom:20px"></label>
                        </div>
               <div>    
                <form id="form1" runat="server">
 
                     <br />  
       


          <asp:GridView ID="gvdetails" runat="server" AutoGenerateColumns="false" CssClass="table table-bordered table-hover" PageSize="10" AllowPaging="true">
    <Columns>
        <asp:TemplateField HeaderText="Appointment ID" ItemStyle-Width="110px" ItemStyle-CssClass="CustomerId col-md-1 ">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("AppointmentId") %>' runat="server" />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Patient Name" ItemStyle-Width="150px" ItemStyle-CssClass="Name col-md-2">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("PatientName") %>' runat="server" />
               
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Weight" ItemStyle-Width="150px" ItemStyle-CssClass="Country col-md-2">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("Weight") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("Weight") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
         <asp:TemplateField HeaderText="Height" ItemStyle-Width="150px" ItemStyle-CssClass="Name col-md-1">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("Height") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("Height") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
         <asp:TemplateField HeaderText="Temperature" ItemStyle-Width="150px" ItemStyle-CssClass="Name col-md-2">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("Temperature") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("Temperature") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Head Circumference" ItemStyle-Width="150px" ItemStyle-CssClass="Name col-md-2">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("Head") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("Head") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
        
        
        
        <asp:TemplateField ItemStyle-CssClass="col-md-2">
            <ItemTemplate>
                <asp:LinkButton Text="Edit" runat="server" CssClass="Edit btn btn-primary" />
                <asp:LinkButton Text="Update" runat="server" CssClass="Update btn btn-success" Style="display: none" />
                <asp:LinkButton Text="Cancel" runat="server" CssClass="Cancel btn btn-warning" Style="display: none" />
             <%--   <asp:LinkButton Text="Delete" runat="server" CssClass="Delete" />--%>
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

   
    <!-- /#wrapper -->


   

</asp:Content>