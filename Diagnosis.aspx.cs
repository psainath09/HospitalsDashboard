using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.html.simpleparser;
using System.Data.SqlClient;
using System.Data;
using System.Web.Services;




namespace HospitalsDashboard
{
    public partial class Diagnosis : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetDetails(int AppointmentId)
        {
            string query = "SELECT AppointmentId,PatientId, PatientName,Weight,Height,Temperature,Head FROM dbo.AppointmentDetails where AppointmentId=@AppointmentId";
             using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["con"].ConnectionString))
                {
                    SqlCommand cmd = new SqlCommand(query);
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.Parameters.AddWithValue("@AppointmentId", AppointmentId);
                        cmd.Connection = conn;
                        sda.SelectCommand = cmd;
                   
                        using (DataSet ds = new DataSet())
                        {
                            sda.Fill(ds);
                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            return ds.GetXml();
                        }
                        else {
                            return "failure";
                        }
                        }
                    
                   
                    }
                
            }
           
        }



        [WebMethod]
        public static string AddDetails(int appointmentid,string diagnosis,string treatment)
        {
            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "dbo.InsertTreatment";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = conn;
                    cmd.Parameters.AddWithValue("@AppointmentId", appointmentid);
                    cmd.Parameters.AddWithValue("@Diagnosis",diagnosis);
                    cmd.Parameters.AddWithValue("@Treatment", treatment);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                conn.Close();

            }
            return "success";

       

        }

        protected void export_Click(object sender, EventArgs e)
        {
            Response.ContentType = "application/pdf";
            Response.AddHeader("content-disposition", "attachment;filename=ConvertedPDF.pdf");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            StringWriter sw = new StringWriter();
            HtmlTextWriter hw = new HtmlTextWriter(sw);
            this.Page.RenderControl(hw);
            StringReader sr = new StringReader(sw.ToString());
            Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 100f, 0f);
            HTMLWorker htmlparser = new HTMLWorker(pdfDoc);
            PdfWriter.GetInstance(pdfDoc, Response.OutputStream);
            pdfDoc.Open();
            htmlparser.Parse(sr);
            pdfDoc.Close();
            Response.Write(pdfDoc);
            Response.End();
        }
    }
}