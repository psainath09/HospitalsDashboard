<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="ProofRecords.aspx.cs" Inherits="HospitalsDashboard.ProofRecords" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   <script src="js/jquery.quicksearch.js"></script>
    <script>

        //search documents

        $(function () {
            $('#searchdoc').keyup(function () {
                $('#searchdoc').each(function (i) {
                    $(this).quicksearch("[id*=GridView1] tr:not(:has(th))", {
                        'testQuery': function (query, txt, row) {
                            return $(row).children(":eq(" + i + ")").text().toLowerCase().indexOf(query[0].toLowerCase()) != -1;

                        }
                    });
                });
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
                            <i class="fa fa-dashboard"></i><a href="UploadRecords.aspx">Upload Records</a>
                        </li>
                        <li class="active">
                            <i class="fa fa-edit"></i>Proof Records
                            </li>
                    </ol>
                </div>
            </div>
     <div class="row">

         <div class="col-md-12">
             <div class="col-md-2"><input type="text" id="searchdoc" placeholder="Search with PatientID" class="form-control" style="margin-bottom:20%" /></div>
          
         </div>
       <div class="col-md-12">
    <form runat="server">
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" EmptyDataText = "No files uploaded" CssClass="table table-bordered table-hover">
    <Columns>
        <asp:BoundField DataField="PatientID" HeaderText="PatientID" />
          <asp:BoundField DataField="AppointmentID" HeaderText="AppointmentID" />
           
        <asp:BoundField DataField="proofname" HeaderText="File Name" />
        
        <asp:BoundField DataField="proofcontent" HeaderText="File Content" />
        <asp:BoundField DataField="datecreated" HeaderText="DateCreated" />
        
        <asp:TemplateField>
            <ItemTemplate>
                <asp:LinkButton ID="lnkDownload" Text = "Download" CommandArgument = '<%# Eval("AppointmentID") %>' runat="server" OnClick = "DownloadFile"></asp:LinkButton>
            </ItemTemplate>
        </asp:TemplateField>
       
        
    </Columns>
</asp:GridView>
    </form>
        </div>
            </div>
         </div>
    </div>
</asp:Content>
