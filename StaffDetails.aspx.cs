using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Services;
using System.Web.Script.Services;
using System.Windows.Forms;

namespace HospitalsDashboard
{
    public partial class StaffDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                this.BindRow();
            }
        }
        private void BindRow()
        {
            DataTable data = new DataTable();
            data.Columns.Add("StaffId");
            data.Columns.Add("FirstName");
            data.Columns.Add("MiddleName");
            data.Columns.Add("LastName");
            data.Columns.Add("Age");
            data.Columns.Add("ID");
            data.Columns.Add("Gender");
            data.Columns.Add("Nationality");
            data.Columns.Add("Address");
            data.Columns.Add("Number");
            data.Columns.Add("Email");
            
            data.Rows.Add();
            gvstaff.DataSource = data;
            gvstaff.DataBind();

        }

        [WebMethod]

        public static string GetStaff()
        {


            string query = "SELECT StaffId, FirstName,MiddleName,LastName,Age,ID,Gender,Nationality,Address,Number,Email FROM dbo.StaffDetails";

            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand(query);
                using (SqlDataAdapter sda = new SqlDataAdapter())
                {
                    cmd.Connection = conn;
                    sda.SelectCommand = cmd;
                    using (DataSet ds = new DataSet())
                    {
                        sda.Fill(ds);
                        return ds.GetXml();

                    }
                }
            }

        }




        [WebMethod]
        public static string UpdateStaff(int StaffId, string fname,string mname, string lname, string id, string gender, string country,string address,string number, string email)
        {


            string constr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand("UPDATE dbo.StaffDetails SET FirstName = @Name,MiddleName=@mname,LastName=@lname,ID=@id, Gender=@Gender,Nationality = @Country,Address=@Address,Number=@number,Email=@email WHERE StaffId = @StaffId"))
                {
                    cmd.Parameters.AddWithValue("@StaffId", StaffId);
                    cmd.Parameters.AddWithValue("@Name", fname);
                    cmd.Parameters.AddWithValue("@mName", mname);
                    cmd.Parameters.AddWithValue("@lname", lname);
                    
                    cmd.Parameters.AddWithValue("@id", id);
                    cmd.Parameters.AddWithValue("@Gender", gender);
                    cmd.Parameters.AddWithValue("@Country", country);
                    cmd.Parameters.AddWithValue("@Address",address);
                    cmd.Parameters.AddWithValue("@Number", number);
                    cmd.Parameters.AddWithValue("@Email", email);
                    
                    cmd.Connection = conn;
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }

            return "success";


        }

        [WebMethod]
        public static string DeleteStaff(int StaffId)
        {

            string constr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand("DELETE FROM dbo.StaffDetails WHERE StaffId = @StaffId"))
                {
                    cmd.Parameters.AddWithValue("@StaffId", StaffId);
                    cmd.Connection = conn;
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }

            }
            return "success";
        }

    }
}
