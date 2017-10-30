<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="HospitalsDashboard.Home" MasterPageFile="~/Main.Master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="js/jquery.quicksearch.js"></script>
    <script type="text/javascript">

    </script>
        <div id="page-wrapper">
           <div class="container-fluid"  style="min-height: 100%; height: 100%;">
                <!-- Page Heading -->
                <div class="row">
                    <div class="col-md-12">
                        <h1 class="page-header">
                            Welcome   <asp:Label ID="displaylabel" runat="server" Text="Label" ForeColor="Green"></asp:Label> !!
                        </h1>
                        <ol class="breadcrumb">
                            <li class="active">
                                <i class="fa fa-dashboard"></i> Dashboard
                            </li>
                        </ol>
                    </div>
                </div>
              
             
               
                <!-- /.row -->

            </div>
            <!-- /.container-fluid -->

        </div>
        <!-- /#page-wrapper --> 
</asp:Content>