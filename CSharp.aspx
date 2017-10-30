<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="CSharp.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>GridView Add, Edit, Delete AJAX Way</title>
<script type = "text/javascript" src = "scripts/jquery-1.3.2.min.js"></script>
<script type = "text/javascript" src = "scripts/jquery.blockUI.js"></script>
<script type = "text/javascript">
    function BlockUI(elementID) {
    var prm = Sys.WebForms.PageRequestManager.getInstance();
    prm.add_beginRequest(function() {
    $("#" + elementID).block({ message: '<table align = "center"><tr><td>' + 
     '<img src="images/loadingAnim.gif"/></td></tr></table>',
     css: {},
     overlayCSS: { backgroundColor: '#000000', opacity: 0.6, border: '3px solid #63B2EB'
    }
    });
    });
    prm.add_endRequest(function() {
        $("#" + elementID).unblock();
    });
}
    $(document).ready(function() {

            BlockUI("dvGrid");
            $.blockUI.defaults.css = {};            
    });
</script> 
</head>
<body style ="margin:0;padding:0">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
    <div id = "dvGrid" style ="padding:10px;width:550px">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
       <asp:GridView ID="GridView1" runat="server"  Width = "550px"
        AutoGenerateColumns = "false" Font-Names = "Arial" 
        Font-Size = "11pt" AlternatingRowStyle-BackColor = "#C2D69B"  
        HeaderStyle-BackColor = "green" AllowPaging ="true"  ShowFooter = "true"  
        OnPageIndexChanging = "OnPaging" onrowediting="EditCustomer"
        onrowupdating="UpdateCustomer"  onrowcancelingedit="CancelEdit"
        PageSize = "10" >
       <Columns>
        <asp:TemplateField ItemStyle-Width = "30px"  HeaderText = "CustomerID">
            <ItemTemplate>
                <asp:Label ID="lblCustomerID" runat="server" Text='<%# Eval("CustomerID")%>'></asp:Label>
            </ItemTemplate> 
            <FooterTemplate>
                <asp:TextBox ID="txtCustomerID" Width = "40px" MaxLength = "5" runat="server"></asp:TextBox>
            </FooterTemplate> 
        </asp:TemplateField> 
        <asp:TemplateField ItemStyle-Width = "100px"  HeaderText = "Name">
            <ItemTemplate>
                <asp:Label ID="lblContactName" runat="server" Text='<%# Eval("ContactName")%>'></asp:Label>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="txtContactName" runat="server" Text='<%# Eval("ContactName")%>'></asp:TextBox>
            </EditItemTemplate>  
            <FooterTemplate>
                <asp:TextBox ID="txtContactName" runat="server"></asp:TextBox>
            </FooterTemplate> 
        </asp:TemplateField>
        <asp:TemplateField ItemStyle-Width = "150px"  HeaderText = "Company">
            <ItemTemplate>
                <asp:Label ID="lblCompany" runat="server" Text='<%# Eval("CompanyName")%>'></asp:Label>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="txtCompany" runat="server" Text='<%# Eval("CompanyName")%>'></asp:TextBox>
            </EditItemTemplate>  
            <FooterTemplate>
                <asp:TextBox ID="txtCompany" runat="server"></asp:TextBox>
            </FooterTemplate> 
        </asp:TemplateField>
        <asp:TemplateField>
            <ItemTemplate>
                <asp:LinkButton ID="lnkRemove" runat="server" CommandArgument = '<%# Eval("CustomerID")%>' 
                 OnClientClick = "return confirm('Do you want to delete?')"
                Text = "Delete" OnClick = "DeleteCustomer"></asp:LinkButton>
            </ItemTemplate>
             <FooterTemplate>
                <asp:Button ID="btnAdd" runat="server" Text="Add" OnClick = "AddNewCustomer" />
            </FooterTemplate> 
        </asp:TemplateField> 
        <asp:CommandField  ShowEditButton="True" /> 
       </Columns> 
       <AlternatingRowStyle BackColor="#C2D69B"  />
    </asp:GridView> 
    </ContentTemplate> 
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID = "GridView1" /> 
    </Triggers> 
    </asp:UpdatePanel> 
    </div>
    </form>
</body>
</html>
