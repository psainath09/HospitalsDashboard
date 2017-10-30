using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Web.Services;
using System.Configuration;

namespace HospitalsDashboard
{
    public partial class PhysicalTests : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                this.BindTests();
            }
        }
        private void BindTests()
        {
            DataTable data = new DataTable();
            data.Columns.Add("AppointmentId");
            data.Columns.Add("PatientName");
            data.Columns.Add("Weight");
            data.Columns.Add("Height");
            data.Columns.Add("Temperature");
            data.Columns.Add("Head");
            
            data.Rows.Add();
            gvdetails.DataSource = data;
            gvdetails.DataBind();

        }

        [WebMethod]

        public static string GetTests()
        {


            string query = "SELECT AppointmentId,PatientName,Weight,Height,Temperature,Head FROM dbo.AppointmentDetails";

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
        public static string UpdateTests(int AppointmentId, string Weight, string Height, string Temperature, string Head)
        {


            string constr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand("UPDATE dbo.AppointmentDetails SET Weight = @Weight,Height=@Height,Temperature=@Temperature, Head=@Head where AppointmentId=@AppointmentId"))
                {
                    cmd.Parameters.AddWithValue("@AppointmentId",AppointmentId);
                    cmd.Parameters.AddWithValue("@Weight", Weight);
                    cmd.Parameters.AddWithValue("@Height", Height);
                    cmd.Parameters.AddWithValue("@Temperature", Temperature);
                    cmd.Parameters.AddWithValue("@Head", Head);
                    
                    cmd.Connection = conn;
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }

            return "success";


        }

        [WebMethod]
        public static string DeleteTest(int Appointmentid)
        {

            string constr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand("DELETE  FROM dbo.AppointmentDetails WHERE AppointmentId = @AppointmentId"))
                {
                    cmd.Parameters.AddWithValue("@AppointmentId", Appointmentid);
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
