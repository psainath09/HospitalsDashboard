<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="UploadRecords.aspx.cs" Inherits="HospitalsDashboard.UploadRecords" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <script>
        $(document).ready(function () {
           
            if ($("div.PatientID > input").val()) {
                $('#<%=uploadfile.ClientID%>').prop("enabled", true);
                $('#<%=FileUpload1.ClientID%>').prop("enabled",true);

            }
            else {
                $('#<%=uploadfile.ClientID%>').prop("disabled", true);
                $('#<%=FileUpload1.ClientID%>').prop("disabled",true);
            }
            
         
           
         
        });

    </script>


    <div id="page-wrapper">

        <div class="container-fluid" style="min-height: 100%; height: 100%;">

            <!-- Page Heading -->
            <div class="row">
                <div class="col-lg-12">

                    <ol class="breadcrumb">
                        <li>
                            <i class="fa fa-dashboard"></i><a href="Home.aspx">Dashboard</a>
                        </li>
                        <li class="active">
                            <i class="fa fa-edit"></i>Upload Records
                        </li>

                    </ol>
                </div>
            </div>

            <div class="row">
                <div class="col-md-12"> 


                <form runat="server">
                    <div class="col-md-12">
                        <div class="col-md-9"></div>
                        <div class="col-md-3" style="padding-bottom: 20px; text-align: right"><a class="btn btn-default btn-success" href="ProofRecords.aspx">Check Records</a> </div>
                    </div>
                    <div class="col-md-12">
                        <div class="col-lg-4">
                        <div class="form-group">
                            <label>Select Appointment ID:</label>
                            <asp:DropDownList ID="aid" runat="server" CssClass="form-control" AutoPostBack="true" EnableViewState="true" OnSelectedIndexChanged="aid_SelectedIndexChanged"></asp:DropDownList>
                        </div>

                        <div class="form-group PatientID">
                            <label>Patient ID:</label>
                            <asp:TextBox ID="pid" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                        </div>
                    </div>
                      
                    <div class=" col-md-offset-1 col-lg-4">

                        <div class="form-group">

                            <h4>Upload Address Proof</h4>
                            <asp:FileUpload ID="FileUpload1" runat="server" AllowMultiple="true" ForeColor="Blue" />
                           
                             </div>
                        <div class="btn-lg">
                            <asp:Button ID="uploadfile" runat="server" CssClass="btn btn-default btn-warning" Text="Upload" OnClick="uploadfile_Click" Width="263px" />
                             <span> <label style="color: orangered"><i class="fa fa-info-circle"></i>only img or pdf format</label></span>
                        </div>
                        <asp:Label ID="proofsuccess" runat="server" ForeColor="Green"></asp:Label>
                         <asp:Label ID="prooferror" runat="server" ForeColor="Red" Font-Size="Medium"></asp:Label>
                        </div>
                    </div>
                </form>
  </div>


            </div>
        </div>
    </div>
</asp:Content>
