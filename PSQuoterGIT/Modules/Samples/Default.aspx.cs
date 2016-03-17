using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using X.Data;
using X.Web.UI.WebControls;

namespace Modules.Samples {
	/// <summary>
	/// Summary description for _default.
	/// </summary>
    public partial class _default : UI.Abstracts.Pages.FullGUI
    {
		protected void Page_Load(object sender, System.EventArgs e) {
            // set default button, send 'null' to disable default button
			SetDefaultButton(btn2);
            
			// set focus control
			SetFocus(txt);
		    
		    if(!IsPostBack)
		    {
                Calendar1.Value = DateTime.Now.AddDays(-2).ToShortDateString();
		        Bind();
		    }

            // tabs
            TabStrip tabsFirst = new TabStrip("FirstGroup", TabStripMethod.Url);
		    tabsFirst.GroupName = "TabGroups";
		    tabsFirst.Add("Tab 1", "1");
		    tabsFirst.Add("Tab 2", "2");
		    tabsFirst.Add("Tab 3", "3");
            
            TabStrip tabsSecond = new TabStrip("SecondGroup", TabStripMethod.Url);
            tabsSecond.GroupName = "TabGroups";
            tabsSecond.Add("Tab 4", "4");
            tabsSecond.Add("Tab 5", "5");
            tabsSecond.Add("Tab 6", "6");

            if(!tabsSecond.HasClicked)
		        tabsSecond.SelectedValue = "6";

            pnlTabs.Controls.Add(tabsFirst);
            pnlTabs.Controls.Add(tabsSecond);
       }

        private void Bind()
        {
            //Manually bind data
            //GridView1.DataSource = SampleClass.SampleDataGet();
            //GridView1.DataBind();

            // Calendars
            Calendar1.DefaultValue = DateTime.Now.AddDays(10);
            Calendar1.MaxDate = DateTime.Now.AddDays(30);   
            Calendar1.MinDate = DateTime.Now.AddDays(-30);

            Calendar2.MaxDate = DateTime.Now.AddDays(30);
            Calendar2.MaxDate = DateTime.Now.AddDays(-30);
        }

		protected void btn2_Click(object sender, EventArgs e) {
			DisplayMessage("btn2_Click");
		}

		protected void btn1_Click(object sender, EventArgs e) {
			Response.Write("btn1_Click");
		}

        protected void lnkCauseError_Click(object sender, EventArgs e)
        {
            int i = 0;
            Response.Write(0 / i);
        }
    }
}
