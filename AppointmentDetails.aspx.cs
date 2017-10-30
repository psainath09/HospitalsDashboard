using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

namespace HospitalsDashboard
{
    public partial class AppointmentDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                this.BindAppointments();
            }
        }

       private void BindAppointments()
        {
            DataTable Dt = new DataTable();
            Dt.Columns.Add("AppointmentId");
            Dt.Columns.Add("PatientId");
            Dt.Columns.Add("PatientName");
            Dt.Columns.Add("AppointmentDate");
            Dt.Columns.Add("AppointmentTime");
            Dt.Columns.Add("PatientVisit");
            Dt.Columns.Add("Icompany");
            Dt.Columns.Add("Cost");
            Dt.Columns.Add("Doctor");
            Dt.Columns.Add("FirstVisit");
            Dt.Rows.Add();
            gvAppointments.DataSource = Dt;
            gvAppointments.DataBind();


        }

        [WebMethod]
        public static string GetAppointments()
        {
            string query = "select AppointmentId,PatientId, PatientName,AppointmentDate,AppointmentTime,PatientVisit,Cost,Doctor,FirstVisit,Icompany FROM dbo.AppointmentDetails";
            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand(query);
                using(SqlDataAdapter Da = new SqlDataAdapter())
                {
                    cmd.Connection = conn;
                    Da.SelectCommand = cmd;
                    using (DataSet ds = new DataSet())
                    {

                        Da.Fill(ds);
                        return ds.GetXml();

                    }
                }

            }



        }
        [WebMethod]
        public static string UpdateAppointment(int AppointmentId, string PatientName, string AppointmentDate,string AppointmentTime,string PatientVisit, int Cost, string Doctor, string FirstVisit,string icompany)
        {


            string constr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand("UPDATE dbo.AppointmentDetails SET PatientName = @Name,AppointmentDate=@AppDate,AppointmentTime=@AppTime,PatientVisit=@PatientVisit,Icompany=@icompany, Cost=@Cost,Doctor = @Doctor,FirstVisit=@FirstVisit WHERE AppointmentId = @AppointmentId"))
                {
                    cmd.Parameters.AddWithValue("@AppointmentId",AppointmentId);
                    cmd.Parameters.AddWithValue("@Name", PatientName);
                    cmd.Parameters.AddWithValue("@AppDate",AppointmentDate);
                    cmd.Parameters.AddWithValue("@AppTime", AppointmentTime);
                    cmd.Parameters.AddWithValue("@PatientVisit",PatientVisit);
                    cmd.Parameters.AddWithValue("@Cost", Cost);
                    cmd.Parameters.AddWithValue("@Doctor", Doctor);
                    cmd.Parameters.AddWithValue("@FirstVisit", FirstVisit);
                    cmd.Parameters.AddWithValue("@icompany", icompany);
                   
                    cmd.Connection = conn;
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }

            return "success";


        }

        [WebMethod]
        public static string DeleteAppointment(int AppointmentId)
        {

            string constr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand("DELETE FROM dbo.AppointmentDetails WHERE AppointmentId = @AppointmentId"))
                {
                    cmd.Parameters.AddWithValue("@AppointmentId", AppointmentId);
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
