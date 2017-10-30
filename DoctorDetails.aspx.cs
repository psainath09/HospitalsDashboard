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
    public partial class DoctorDetails : System.Web.UI.Page
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
            data.Columns.Add("DoctorId");
            data.Columns.Add("FirstName");
            data.Columns.Add("MiddleName");
            data.Columns.Add("LastName");
            data.Columns.Add("Address");
            data.Columns.Add("Number");
            data.Columns.Add("Email");
            data.Columns.Add("FirstCharge");
            data.Columns.Add("FollowCharge");
            data.Rows.Add();
            gvdoctors.DataSource = data;
            gvdoctors.DataBind();

        }

        [WebMethod]

        public static string GetDoctors()
        {


            string query = "SELECT DoctorId, FirstName,MiddleName,LastName,Address,Number,Email,FirstCharge,FollowCharge FROM dbo.DoctorDetails";

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
        public static string UpdateDoctor(int DoctorId, string fname,string mname, string lname, string address, long number, string email, int firstcharge,int followcharge)
        {


            string constr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand("UPDATE dbo.DoctorDetails SET FirstName = @fName,MiddleName=@mName,LastName=@lname,Address=@Address,Number=@number,Email=@email,FirstCharge=@firstcharge,FollowCharge=@followcharge WHERE DoctorId = @DoctorId"))
                {
                    cmd.Parameters.AddWithValue("@DoctorId",DoctorId);
                    cmd.Parameters.AddWithValue("@fName", fname);
                    cmd.Parameters.AddWithValue("@mName", mname);
                    cmd.Parameters.AddWithValue("@lname", lname);
                    cmd.Parameters.AddWithValue("@Address", address);
                    
                    cmd.Parameters.AddWithValue("@Number", number);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@firstcharge", firstcharge);
                    cmd.Parameters.AddWithValue("@followcharge", followcharge);
                    cmd.Connection = conn;
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }

            return "success";


        }

        [WebMethod]
        public static string DeleteDoctor(int DoctorId)
        {

            string constr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand("DELETE FROM dbo.DoctorDetails WHERE DoctorId = @DoctorId"))
                {
                    cmd.Parameters.AddWithValue("@PatientId", DoctorId);
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
