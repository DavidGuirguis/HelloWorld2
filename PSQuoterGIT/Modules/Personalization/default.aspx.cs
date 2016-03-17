using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using X;
using X.Extensions;
using X.Web.UI.WebControls;
using Helpers;

public partial class Default : UI.Abstracts.Pages.ReportViewPage   
{
    DataSet ds;
    IDictionary<string, IEnumerable<DataRow>> RowsSet;
    string division = "";
    string branchNo = "";
    string phoneNo = "";
    string cellPhoneNo = "";
    string faxNo = "";
   

    protected void Page_Load(object sender, EventArgs e)
    {
        ModuleTitle = "Personalization";
        if (!IsPostBack)
        {
            ds = DAL.Quote.Quote_Get_UserPersonalization();
            RowsSet = ds.ToDictionary();

            
            if (RowsSet.ContainsKey("default"))
            {
                DataRow dr = RowsSet["default"].FirstOrDefault();
                division = dr["defaultDivision"].ToString();
                branchNo = dr["DefaultBranchNo"].ToString().Trim();
                phoneNo = dr["DefaultPhoneNo"].ToString();
                cellPhoneNo = dr["DefaultCellPhoneNo"].ToString().Trim();
                faxNo = dr["DefaultFaxNo"].ToString();
            }

            foreach (DataRow dr in RowsSet["division"])
            {

                rlstDivision.Items.Add(new ListItem(dr["DivisionName"].ToString(), dr["division"].ToString()));
            }
            rlstDivision.SelectedValue = division;

   
            lstBranch.Items.Clear();
            lstBranch.Items.Add("");
            foreach (DataRow dr in RowsSet["branch"])
            {
                lstBranch.Items.Add(new ListItem(dr["BranchName"].ToString(), dr["BranchNo"].ToString().Trim()));
            }
            lstBranch.SelectedValue = branchNo;

            txtPhoneNo.Text = phoneNo;
            txtCellPhoneNo.Text = cellPhoneNo;
            txtFaxNo.Text = faxNo;

        }

    }

    private void Page_PreRender(object sender, System.EventArgs e)
    {
    }

    
    protected void btnSave_Click(object sender, EventArgs e)
    {
        division = rlstDivision.SelectedValue;

        branchNo = lstBranch.SelectedValue;
        phoneNo = txtPhoneNo.Text.Trim();
        cellPhoneNo = txtCellPhoneNo.Text.Trim();
        faxNo = txtFaxNo.Text.Trim();

        DAL.Quote.Quote_Save_UserPersonalization(division, branchNo, phoneNo, cellPhoneNo, faxNo);

        printConfig.SaveData(); 

    }
}