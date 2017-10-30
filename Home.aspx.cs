using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;

namespace HospitalsDashboard
{
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (User.Identity.IsAuthenticated)
            {

                if (Session["username"] != null)
                {

                    displaylabel.Text = Session["username"].ToString();
                }
                else
                {
                    displaylabel.Text = "User";
                }
            }
           
        }

      
    }
}