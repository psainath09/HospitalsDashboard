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
using System.Web.Security;


namespace HospitalsDashboard
{

    

    public partial class AddPatient : System.Web.UI.Page
    {

        
        public byte[] data { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {

           

        }
        [WebMethod]
        public static string AddData(string fname, string mname, string lname, string dob, string gender, string country, string address, string number,string secnumber, string email,string cpr)
        {
           
          
            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "dbo.InsertPatient";
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = conn;

                    cmd.Parameters.AddWithValue("@firstName", fname);
                    cmd.Parameters.AddWithValue("@middleName", mname);
                    cmd.Parameters.AddWithValue("@lastName", lname);
                    cmd.Parameters.AddWithValue("@dob", dob);
                    cmd.Parameters.AddWithValue("@gender", gender);
                    cmd.Parameters.AddWithValue("@country", country);
                    cmd.Parameters.AddWithValue("@address", address);
                    cmd.Parameters.AddWithValue("@number", number);
                    cmd.Parameters.AddWithValue("@secnumber",secnumber);
                    cmd.Parameters.AddWithValue("@email", email);
                    cmd.Parameters.AddWithValue("@cpr", cpr);
                    cmd.Parameters.AddWithValue("@Identity", SqlDbType.Int).Direction = ParameterDirection.Output;

                    //FileStream fstream = File.OpenRead(proof);

                    //byte[] contents = new byte[fstream.Length];
                    //fstream.Read(contents, 0, (int)fstream.Length);
                    //fstream.Close();
                   // cmd.Parameters.AddWithValue("@proof", proof);
                   

                    conn.Open();

                   // modified = (int)cmd.ExecuteScalar();

                    cmd.ExecuteNonQuery();

                    temp.id = cmd.Parameters["@Identity"].Value.ToString();
                }
                conn.Close();

            }
            return temp.id;
                




        }





       

        protected void Button1_Click1(object sender, EventArgs e)
        {

            HttpFileCollection files = Request.Files;
            foreach (string fileTagName in files)
            {
                HttpPostedFile file = Request.Files[fileTagName];
                if (file.ContentLength > 0)
                {

                    int size = file.ContentLength;
                    string name = file.FileName;
                    int position = name.LastIndexOf("\\");
                    name = name.Substring(position + 1);
                    string contentType = file.ContentType;
                    byte[] fileData = new byte[size];
                    file.InputStream.Read(fileData, 0, size);



                }
            }
        }

        //protected void Button2_Click(object sender, EventArgs e)
        //{
        //    string codeid = temp.id;
        //   // int codeid = Convert.ToInt32(racha.Text.ToString());
        //    foreach (HttpPostedFile postedFile in FileUpload1.PostedFiles)
        //    {
        //        string filename = Path.GetFileName(postedFile.FileName);
        //        string contentType = postedFile.ContentType;
        //        using (Stream fs = postedFile.InputStream)
        //        {
        //            using (BinaryReader br = new BinaryReader(fs))
        //            {
        //                byte[] bytes = br.ReadBytes((Int32)fs.Length);
        //                string constr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
        //                using (SqlConnection con = new SqlConnection(constr))
        //                {
        //                    string query = "insert into dbo.ProofRecords(Id,proofname,proofcontent,proofdata) values (@codeid,@proofname, @proofcontent, @proofdata)";
        //                    using (SqlCommand cmd = new SqlCommand(query))
        //                    {
        //                        cmd.Connection = con;
        //                        cmd.Parameters.AddWithValue("@proofname", filename);
        //                        cmd.Parameters.AddWithValue("@proofcontent", contentType);
        //                        cmd.Parameters.AddWithValue("@proofdata", bytes);
        //                        cmd.Parameters.AddWithValue("@codeid", codeid);
        //                        con.Open();
        //                        cmd.ExecuteNonQuery();
        //                        con.Close();
        //                    }
        //                }
        //            }
        //        }
        //    }
        //  //  Response.Redirect(Request.Url.AbsoluteUri);
        //}

        //protected void Button3_Click(object sender, EventArgs e)
        //{
        //    string codeid = temp.id;
        //    // int codeid = Convert.ToInt32(racha.Text.ToString());
        //    foreach (HttpPostedFile postedFile in FileUpload1.PostedFiles)
        //    {
        //        string filename = Path.GetFileName(postedFile.FileName);
        //        string contentType = postedFile.ContentType;
        //        using (Stream fs = postedFile.InputStream)
        //        {
        //            using (BinaryReader br = new BinaryReader(fs))
        //            {
        //                byte[] bytes = br.ReadBytes((Int32)fs.Length);
        //                string constr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
        //                using (SqlConnection con = new SqlConnection(constr))
        //                {
        //                    string query = "insert into dbo.ProofRecords(Id,proofname,proofcontent,proofdata) values (@codeid,@proofname, @proofcontent, @proofdata)";
        //                    using (SqlCommand cmd = new SqlCommand(query))
        //                    {
        //                        cmd.Connection = con;
        //                        cmd.Parameters.AddWithValue("@proofname", filename);
        //                        cmd.Parameters.AddWithValue("@proofcontent", contentType);
        //                        cmd.Parameters.AddWithValue("@proofdata", bytes);
        //                        cmd.Parameters.AddWithValue("@codeid", codeid);
        //                        con.Open();
        //                        cmd.ExecuteNonQuery();
        //                        con.Close();
        //                    }
        //                }
        //            }
        //        }
        //    }
        //}

        //protected void Button4_Click(object sender, EventArgs e)
        //{
        //    string codeid = temp.id;
        //    // int codeid = Convert.ToInt32(racha.Text.ToString());
        //    foreach (HttpPostedFile postedFile in FileUpload1.PostedFiles)
        //    {
        //        string filename = Path.GetFileName(postedFile.FileName);
        //        string contentType = postedFile.ContentType;
        //        using (Stream fs = postedFile.InputStream)
        //        {
        //            using (BinaryReader br = new BinaryReader(fs))
        //            {
        //                byte[] bytes = br.ReadBytes((Int32)fs.Length);
        //                string constr = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
        //                using (SqlConnection con = new SqlConnection(constr))
        //                {
        //                    string query = "insert into dbo.ProofRecords(Id,proofname,proofcontent,proofdata) values (@codeid,@proofname, @proofcontent, @proofdata)";
        //                    using (SqlCommand cmd = new SqlCommand(query))
        //                    {
        //                        cmd.Connection = con;
        //                        cmd.Parameters.AddWithValue("@proofname", filename);
        //                        cmd.Parameters.AddWithValue("@proofcontent", contentType);
        //                        cmd.Parameters.AddWithValue("@proofdata", bytes);
        //                        cmd.Parameters.AddWithValue("@codeid", codeid);
        //                        con.Open();
        //                        cmd.ExecuteNonQuery();
        //                        con.Close();
        //                    }
        //                }
        //            }
        //        }
        //    }
        //}
    }
}