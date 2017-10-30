<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Contacts.aspx.cs" Inherits="HospitalsDashboard.Contacts" MasterPageFile="~/Main.Master" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  

  <script>

        $(document).ready(function () {




            $("#submit").on('click', function (e) {
                e.preventDefault();

                verification = {};
                if (document.getElementById("username").value.length > 0 && document.getElementById("password").value.length > 0) {
                    verification.state = true;
                    
                }
                else

                {
                    $("#msg").html("Please enter Both Values").css('color', 'red');
                }

                if (verification.state) {
                    $.ajax({
                        type: "POST",
                        url: "Login.aspx/LoginData",
                        data: JSON.stringify({ username: $("#username").val(), password: $("#password").val() }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSuccess,
                        error: OnErrorCall


                    });
                    function OnSuccess() {

                     
                    }
                    function OnErrorCall() {


                    }

                }
            });




        });

    </script>
 


        <div id="page-wrapper">

            <div class="container-fluid">

                <!-- Page Heading -->
                <div class="row">
                    <div class="col-lg-12">
                        <h1 class="page-header">
                            Dashboard <small>Hospital Details</small>
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

    </div>
    <!-- /#wrapper -->

  
</asp:Content>