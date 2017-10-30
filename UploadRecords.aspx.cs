using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Web.Services;
using System.IO;

namespace HospitalsDashboard
{
    public partial class UploadRecords : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                bindproof();
            }
        }

        public void bindproof()
        {
            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("select AppointmentID from dbo.AppointmentDetails"))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = conn;
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataSet ds = new DataSet();
                    da.Fill(ds);
                    aid.DataTextField = ds.Tables[0].Columns["AppointmentID"].ToString();
                    aid.DataSource = ds.Tables[0];
                    aid.DataBind();
                    conn.Close();
                }
                aid.Items.Insert(0, new ListItem("Select AppointmentID", "0"));
            }
        }

        protected void aid_SelectedIndexChanged(object sender, EventArgs e)
        {
            string pdetail = aid.SelectedValue.ToString();
            if (pdetail != null)
            {
                int pname = 0;
                using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["con"].ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("select PatientID from dbo.AppointmentDetails where AppointmentID=@pdetail"))
                    {
                        try
                        {
                            cmd.Parameters.AddWithValue("@pdetail", pdetail);
                            cmd.Connection = conn;
                            conn.Open();
                            pname = (int)cmd.ExecuteScalar();
                            conn.Close();
                            pid.Text = pname.ToString();
                        }
                        catch
                        {
                            pid.Text = null;
                        }
                    }

                }
            }
            else {
                pid.Text = null;
            }
            
        }

      

        protected void uploadfile_Click(object sender, EventArgs e)
        {
            string appid = aid.SelectedValue.ToString();
            string patid = pid.Text.ToString();
            // int codeid = Convert.ToInt32(racha.Text.ToString());
            if (FileUpload1.HasFiles)
            {
                try
                {
                    foreach (HttpPostedFile postedFile in FileUpload1.PostedFiles)
                    {

                        string filename = Path.GetFileName(postedFile.FileName);
                        string contentType = postedFile.ContentType;
                        using (Stream fs = postedFile.InputStream)
                        {
                            using (BinaryReader br = new BinaryReader(fs))
                            {
                                byte[] bytes = br.ReadBytes((Int32)fs.Length);
                                //postedFile.InputStream.Read(bytes, 0, bytes.Length);

                                string constr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
                                using (SqlConnection con = new SqlConnection(constr))
                                {
                                    string query = "insert into dbo.ProofRecords(patientid,appointmentid,proofname,proofcontent,proofdata) values (@patid,@appid,@proofname, @proofcontent, @proofdata)";
                                    using (SqlCommand cmd = new SqlCommand(query))
                                    {
                                        cmd.Connection = con;
                                        cmd.Parameters.AddWithValue("@proofname", filename);
                                        cmd.Parameters.AddWithValue("@proofcontent", contentType);
                                        cmd.Parameters.AddWithValue("@proofdata", bytes);
                                        cmd.Parameters.AddWithValue("@appid", appid);
                                        cmd.Parameters.AddWithValue("@patid", patid);
                                        con.Open();
                                        cmd.ExecuteNonQuery();
                                        con.Close();
                                    }
                                }
                            }
                        }
                    }
                    proofsuccess.Text = "Files uploaded successfully,Please check the Record";
                }
                catch (Exception ae)
                {
                    prooferror.Text = "Upload failed";
                }
            }
            else
            {
                prooferror.Text = "Please select files";
            }
        }
    }
}