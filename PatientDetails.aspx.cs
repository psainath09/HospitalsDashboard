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
using System.IO;

namespace HospitalsDashboard
{
    public partial class PatientDetails : System.Web.UI.Page
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
            data.Columns.Add("PatientId");
            data.Columns.Add("FirstName");
            data.Columns.Add("LastName");
            data.Columns.Add("Age");
            data.Columns.Add("Gender");
            data.Columns.Add("Nationality");
            data.Columns.Add("cpr");
            data.Columns.Add("Number");
            data.Columns.Add("Email");
            
           
            data.Rows.Add();
           gvCustomers.DataSource = data;
            gvCustomers.DataBind();
           
        }

        [WebMethod]
       
        public static string GetPatients()
        {
            

          string query = "SELECT PatientId, FirstName,LastName,Age,Gender,Nationality,cpr,Number,Email FROM dbo.PatientDetails";
                
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
        public static string UpdatePatient(int PatientId, string fname, string lname, string gender, string country,string cpr,long number,string email)
        {

          
                string constr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(constr))
                {
                    using (SqlCommand cmd = new SqlCommand("UPDATE dbo.PatientDetails SET FirstName = @Name,LastName=@lname, Gender=@Gender,Nationality = @Country,cpr=@cpr,Number=@number,Email=@email WHERE PatientId = @PatientId"))
                    {
                        cmd.Parameters.AddWithValue("@PatientId", PatientId);
                        cmd.Parameters.AddWithValue("@Name", fname);
                        cmd.Parameters.AddWithValue("@lname", lname);
                       
                        cmd.Parameters.AddWithValue("@Gender", gender);
                        cmd.Parameters.AddWithValue("@Country", country);
                        cmd.Parameters.AddWithValue("@Number", number);
                        cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@cpr", cpr);
                        cmd.Connection = conn;
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                    }
                }

                return "success";
           
           
        }

        [WebMethod]
        public static int DeletePatient(int patientId)
        {
            try
            {
                string constr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(constr))
                {

                    using (SqlCommand cmd = new SqlCommand("DELETE FROM dbo.PatientDetails WHERE PatientId = @PatientId"))
                    {
                        cmd.Parameters.AddWithValue("@PatientId", patientId);
                        cmd.Connection = conn;
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                    }

                }
                return 1;
            }
            catch (Exception e)
            {
                return 0;

            }
            
        }

        protected void DownloadFile(object sender, EventArgs e)
        {
            int id = int.Parse((sender as LinkButton).CommandArgument);
            byte[] bytes;
            
            string constr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "select Proof from dbo.PatientDetails where Proof=@Proof";
                    cmd.Parameters.AddWithValue("@Id", id);
                    cmd.Connection = con;
                    con.Open();
                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        sdr.Read();
                        bytes = (byte[])sdr["Proof"];
                       
                    }
                    con.Close();
                }
            }
            Response.Clear();
            Response.Buffer = true;
            Response.Charset = "";
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
           // Response.ContentType = contentType;
          //  Response.AppendHeader("Content-Disposition", "attachment; filename=" + fileName);
            Response.BinaryWrite(bytes);
            Response.Flush();
            Response.End();
        }

        protected void gvCustomers_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
