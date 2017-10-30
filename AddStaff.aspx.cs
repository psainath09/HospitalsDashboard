using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Web.Services;
namespace HospitalsDashboard
{
    public partial class AddStaff : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string AddStaffData(string fname, string mname, string lname,string dob, string id, string gender, string country, string address, string number,string email)
        {
            using (SqlConnection conn=new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd=new SqlCommand())
                {
                    cmd.CommandText = "dbo.InsertStaff";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = conn;
                    cmd.Parameters.AddWithValue("@firstName", fname);
                    cmd.Parameters.AddWithValue("@middleName", mname);
                    cmd.Parameters.AddWithValue("@lastName", lname);
                    cmd.Parameters.AddWithValue("@dob", dob);
                    cmd.Parameters.AddWithValue("@id", id);
                    cmd.Parameters.AddWithValue("@gender", gender);
                    cmd.Parameters.AddWithValue("@country", country);
                    cmd.Parameters.AddWithValue("@address", address);
                    cmd.Parameters.AddWithValue("@number", number);
                    cmd.Parameters.AddWithValue("@email", email);
                    conn.Open();
                    cmd.ExecuteNonQuery();


                }
                conn.Close();

            }



                return "success";
        }
    }
}