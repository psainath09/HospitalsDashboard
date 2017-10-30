using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;
using System.Web.Security;

namespace HospitalsDashboard
{
    public partial class AddAppointment : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!this.IsPostBack)
            {
                binddoctor();
                bindrow();
                bindslot();
               
            }

        }
        public void bindslot()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("AppointmentTime");   
            dt.Rows.Add();
            bookedslots.DataSource = dt;
            bookedslots.DataBind();

        }

        public void bindrow()
        {

            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT [PatientID] FROM [PatientDetails];"))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = conn;
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataSet ds = new DataSet();
                    da.Fill(ds);
                    PatientList.DataTextField = ds.Tables[0].Columns["PatientID"].ToString();
                    PatientList.DataSource = ds.Tables[0];
                    PatientList.DataBind();

                    conn.Close();
                }
            }
            PatientList.Items.Insert(0, new ListItem("Select PatientID", "0"));

           

        }

      
        public void binddoctor()
        {

            DataTable dt = new DataTable();
            
            dt.Columns.Add("Day");
            dt.Columns.Add("Morning");
            dt.Columns.Add("Afternoon");
            dt.Rows.Add();
            GridView1.DataSource = dt;
            GridView1.DataBind();


        }
        [WebMethod]
        public static string AddApp(string PatientID,string PatientName,string AppDate,string AppTime,string PatientVisit, int Cost,string Doctor,string FirstVisit,string insurance,string icompany)
        {
           
                using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["con"].ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = "dbo.InsertAppointment";
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Connection = conn;
                    cmd.Parameters.AddWithValue("@PatientID", PatientID);
                    cmd.Parameters.AddWithValue("@PatientName", PatientName);
                        cmd.Parameters.AddWithValue("@Date", AppDate);
                    cmd.Parameters.AddWithValue("@AppTime", AppTime);
                    cmd.Parameters.AddWithValue("@PatientVisit", PatientVisit);
                        cmd.Parameters.AddWithValue("@Cost", Cost);
                        cmd.Parameters.AddWithValue("@Doctor", Doctor);
                        cmd.Parameters.AddWithValue("@FirstVisit", FirstVisit);
                    cmd.Parameters.AddWithValue("@insurance", insurance);
                    cmd.Parameters.AddWithValue("@icompany", icompany);
                    conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                    conn.Close();
                }
              

            
            return "success";
          
           
        }

        [WebMethod]
        public static string DoctorAvail(string doctorname)
        {

            string query = "SELECT Day,Morning,Afternoon FROM dbo.DoctorTimings where DoctorName=@doctorname";

            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
               
                SqlCommand cmd = new SqlCommand(query);
                cmd.Parameters.AddWithValue("@doctorname", doctorname);
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

        public static int DateValidate(string selectd,string selectt)
        {
            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                int Results = 0;
                using (SqlCommand cmd = new SqlCommand("SELECT count(*) FROM[dbo].AppointmentDetails WHERE AppointmentDate = @selecteddate And AppointmentTime = @selectedtime;"))
                {

                    cmd.Parameters.AddWithValue("@selecteddate", selectd);
                    cmd.Parameters.AddWithValue("@selectedtime", selectt);
                    cmd.Connection = conn;
                    conn.Open();
                    Results = (int)cmd.ExecuteScalar();
                    return Results;

                }

            }
            }


        [WebMethod]

        public static string Datepick(string selectd)
        {
            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
               
                using (SqlCommand cmd = new SqlCommand("SELECT AppointmentTime FROM[dbo].AppointmentDetails WHERE AppointmentDate = @selecteddate;"))
                {

                    cmd.Parameters.AddWithValue("@selecteddate", selectd);
                    using (SqlDataAdapter da = new SqlDataAdapter())
                    {
                        cmd.Connection = conn;
                        conn.Open();
                        da.SelectCommand = cmd;
                        using (DataSet ds = new DataSet())
                        {
                            da.Fill(ds);
                            return ds.GetXml();
                        }
                    }
                }

            }
        }

        [WebMethod]

        public static int CheckDate(String SelectedDate)
        {
            
            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["con"].ConnectionString))

            {
                SqlCommand cmd = new SqlCommand("select count(*) from AppointmentDetails where AppointmentDate LIKE '%@SelectedDate%';");
                cmd.Parameters.AddWithValue("@SelectedDate", SelectedDate);
                cmd.Connection = conn;
                conn.Open();
                cmd.ExecuteNonQuery();
               
                conn.Close();

            }



                return 0;
        }
     

        protected void PatientList_SelectedIndexChanged(object sender, EventArgs e)
        {
            

            string pid = PatientList.SelectedValue.ToString();
            if(pid != null) { 
            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                string dr=null;
                    using (SqlCommand cmd = new SqlCommand("SELECT FirstName from dbo.PatientDetails WHERE PatientId = @PatientId"))
                    {
                        cmd.Parameters.AddWithValue("@PatientId", pid);
                        cmd.Connection = conn;
                        conn.Open();

                        dr = (string)cmd.ExecuteScalar();
                        conn.Close();


                        patientname.Text = dr.ToString();
                    }
                    
                   
                }
           
            }
            else
            {
                patientname.Text = null;
            }
        }

        protected void doctor_SelectedIndexChanged(object sender, EventArgs e)
        {


        }
    }
}