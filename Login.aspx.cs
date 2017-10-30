using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Web.Security;
using System.Security.Cryptography;

namespace HospitalsDashboard
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.Cookies["geste"] != null)
                    textusername.Text = Request.Cookies["geste"].Value;
                if (Request.Cookies["pasre"] != null)
                    textpassword.Text = Request.Cookies["pasre"].Value;
                if (Request.Cookies["geste"] != null && Request.Cookies["pasre"] != null)
                    textpassword.Attributes["value"] = Request.Cookies["pasre"].Value;
                    RememberMe.Checked = true;

            }
        }
        protected void submit_Data(object sender, EventArgs e)
        {

            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                int Results = 0;
                using (SqlCommand cmd = new SqlCommand())
                {

                    cmd.CommandText = "LoginProc";
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@username", SqlDbType.VarChar, 50).Value = textusername.Text;
                    cmd.Parameters.Add("@password", SqlDbType.VarChar, 50).Value = textpassword.Text;
                    cmd.Parameters.Add("@Result", SqlDbType.Int, 4);
                    cmd.Parameters["@Result"].Direction = ParameterDirection.Output;
                    cmd.Connection = conn;

                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        Results = (int)cmd.Parameters["@Result"].Value;
                        if (Results == 1)
                        {


                            //HttpContext.Current.Response.Redirect("Home.aspx",true);

                            if (RememberMe.Checked)
                            {
                                Session["username"] = textusername.Text;
                                Session.Timeout = 30;
                                Response.Cookies["geste"].Value = textusername.Text;
                                Response.Cookies["pasre"].Value = textpassword.Text;
                                Response.Cookies["geste"].Expires = DateTime.Now.AddDays(30);
                                Response.Cookies["pasre"].Expires = DateTime.Now.AddDays(30);
                                FormsAuthentication.RedirectFromLoginPage(textusername.Text,RememberMe.Checked);
                            
                            
                            }
                            else
                            {
                                Response.Cookies["geste"].Expires = DateTime.Now.AddDays(30);
                                Response.Cookies["pasre"].Expires = DateTime.Now.AddDays(30);
                                FormsAuthentication.RedirectFromLoginPage(textusername.Text,false);
                            }
                            // Response.Redirect("Home.aspx");
                           // if (Response.Cookies.Count > 0)
                            //{
                            //    foreach (string s in Response.Cookies.AllKeys)
                            //    {
                            //        if (s == FormsAuthentication.FormsCookieName || s.ToLower() == "asp.net_sessionid")
                            //        {
                            //            Response.Cookies[s].Secure = true;
                            //        }
                            //    }
                            //}

                        }
                        else
                        {

                            // HttpContext.Current.Response.Redirect("Index.aspx",true);
                            msg.Text = "Please enter valid Username and Password";
                        }


                    }
                    catch (SqlException ae)
                    {

                    }
                    finally
                    {

                        cmd.Dispose();
                        if (conn != null)
                        {
                            conn.Close();
                        }
                    }



                }
            }
        }

        protected void RememberMe_CheckedChanged(object sender, EventArgs e)
        {

        }
    }
}