using AppContext = Canam.AppContext;
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
using Entities;
using Helpers;
using System.Text;

using MenuItem = X.Web.Entities.MenuItem;
using MenuItemGroup = X.Web.Entities.MenuItemGroup;

public partial class Modules_AdvancedSearch : UI.Abstracts.Pages.ReportViewPage   
{
    protected string JobCodeList = "";
    protected string ComponentCodeList = "";
    protected string ModifierCodeList = "";
    protected string CostCentreCodeList = "";

    DataSet ds;
    IDictionary<string, IEnumerable<DataRow>> rowsSet;
    char spiltChar = (char)5;
    

    protected void Page_Load(object sender, EventArgs e)
    {
        ModuleTitle = "Advanced Search";
        if (!IsPostBack)
        {
            initPage();
        }
    }

    protected void initPage()
    {
        if (ds == null)
        { // item not in cache, get a fresh set   
            ds = DAL.Quote.Quote_Get_InitAdvancedSearch();
            Cache.Insert("SearchAreas", ds, null, DateTime.Now.AddMinutes(60), TimeSpan.Zero);
        }
       
             ds = (DataSet)Cache["SearchAreas"];

    //    ds = DAL.Quote.Quote_Get_InitAdvancedSearch();
     
        rowsSet = ds.ToDictionary();

        //Make

        StringBuilder sb;
        //JobCode
        IEnumerable<DataRow> drJobCodes = rowsSet["JobCode"];
     
        JobCodeList += ",&nbsp;" ;
        if (drJobCodes != null)
        {
            sb = new StringBuilder();
            foreach (DataRow dr in drJobCodes)
            {
                //if (JobCodeList != "") JobCodeList += spiltChar.ToString();
                //JobCodeList += dr["jobCode"].ToString().Trim() + "," + dr["jobCode"].ToString().Trim() + "-" + Server.HtmlEncode(dr["JobCodeDesc"].ToString());
                sb.Append(spiltChar.ToString());
                sb.Append(dr["jobCode"].ToString().Trim() + "," + dr["jobCode"].ToString().Trim() + "-" + Server.HtmlEncode(dr["JobCodeDesc"].ToString()));
            }
            JobCodeList += sb.ToString();
        }


        //Component Code
        IEnumerable<DataRow> drComponentCodes = rowsSet["ComponentCode"];
        ComponentCodeList += ",&nbsp;";
        if (drComponentCodes != null)
        {
            sb = new StringBuilder();
            foreach (DataRow dr in drComponentCodes)
            {
               // if (ComponentCodeList != "") ComponentCodeList += spiltChar.ToString();
               // ComponentCodeList += dr["ComponentCode"].ToString().Trim() + "," + dr["ComponentCode"].ToString().Trim() + "-" + Server.HtmlEncode(dr["ComponentCodeDesc"].ToString());
               sb.Append(spiltChar.ToString());
               sb.Append(dr["ComponentCode"].ToString().Trim() + "," + dr["ComponentCode"].ToString().Trim() + "-" + Server.HtmlEncode(dr["ComponentCodeDesc"].ToString()));
            }
            ComponentCodeList += sb.ToString();
        }

        //Modifer Code
        IEnumerable<DataRow> drModifierCodes = rowsSet["ModifierCode"];
        ModifierCodeList += ",&nbsp;";
        if (drModifierCodes != null)
        {
            sb = new StringBuilder();
            foreach (DataRow dr in drModifierCodes)
            {
                //if (ModifierCodeList != "") ModifierCodeList += spiltChar.ToString();
                //ModifierCodeList += dr["ModifierCode"].ToString().Trim() + "," + dr["ModifierCode"].ToString().Trim() + "-" + Server.HtmlEncode(dr["ModifierDesc"].ToString());
                sb.Append(spiltChar.ToString());
                sb.Append(dr["ModifierCode"].ToString().Trim() + "," + dr["ModifierCode"].ToString().Trim() + "-" + Server.HtmlEncode(dr["ModifierDesc"].ToString()));
            }
            ModifierCodeList += sb.ToString();
        }

        //BusinessCode
        lstBusinessGroupCode.Items.Add("");
        IEnumerable<DataRow> drBusinessGroupCodes = rowsSet["BusinessGroupCode"];
        if (drBusinessGroupCodes != null)
        {
            foreach (DataRow dr in drBusinessGroupCodes)
            {
                lstBusinessGroupCode.Items.Add(new ListItem(dr["BusinessGroupCode"].ToString().Trim() + "-" + dr["BusinessGroupDesc"].ToString(), dr["BusinessGroupCode"].ToString().Trim()));
            }
        }

        //Quantity Code
        lstQuantityCode.Items.Add("");
        IEnumerable<DataRow> drQuantityCodes = rowsSet["QuantityCode"];
        if (drQuantityCodes != null)
        {
            foreach (DataRow dr in drQuantityCodes)
            {
                lstQuantityCode.Items.Add(new ListItem(dr["QuantityCode"].ToString().Trim() + "-" + dr["QuantityDesc"].ToString(), dr["QuantityCode"].ToString().Trim()));
            }
        }

        //WorkApplicationCode
        if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.WorkApplicationCode.Show"))
        {
            lstWorkApplicationCode.Items.Add("");
            if (rowsSet.ContainsKey("WorkApplicationCode"))
            {
                IEnumerable<DataRow> drWorkApplicationCodes = rowsSet["WorkApplicationCode"];
                if (drWorkApplicationCodes != null)
                {
                    foreach (DataRow dr in drWorkApplicationCodes)
                    {
                        lstWorkApplicationCode.Items.Add(new ListItem(dr["WorkApplicationCode"].ToString().Trim() + "-" + dr["WorkApplicationDesc"].ToString(), dr["WorkApplicationCode"].ToString().Trim()));
                    }
                }
            }
        }
        //Store Code
        lstStoreCode.Items.Clear();
        lstStoreCode.Items.Add("");
        IEnumerable<DataRow> drStoreCodes = rowsSet["StoreCode"];
        if (drStoreCodes != null)
        {
            foreach (DataRow dr in drStoreCodes)
            {
                lstStoreCode.Items.Add(new ListItem(dr["BranchCode"].ToString().Trim() + "-" + dr["BranchName"].ToString(), dr["BranchCode"].ToString().Trim()));
            }
        }
        //CostCentreCode
        CostCentreCodeList += ",&nbsp;";
        if (rowsSet.ContainsKey("CostCentreCode"))
        {
            IEnumerable<DataRow> drCostCenterCodes = rowsSet["CostCentreCode"];
            if (drCostCenterCodes != null)
            {
                sb = new StringBuilder();
                foreach (DataRow dr in drCostCenterCodes)
                {
                   // if (CostCentreCodeList != "") CostCentreCodeList += spiltChar.ToString();
                   // CostCentreCodeList += dr["CostCentreCode"].ToString().Trim() + "|" + dr["CostCentreName"].ToString().Trim() + "|" + Server.HtmlEncode(dr["BranchNo"].ToString().Trim());
                    sb.Append(spiltChar.ToString());
                    sb.Append(dr["CostCentreCode"].ToString().Trim() + "|" + dr["CostCentreName"].ToString().Trim() + "|" + Server.HtmlEncode(dr["BranchNo"].ToString().Trim()));
                }
                CostCentreCodeList += sb.ToString();
            }
        }

        //cab type Code
        lstCabTypeCode.Items.Clear();
        lstCabTypeCode.Items.Add("");
        IEnumerable<DataRow> drCableTypeCodes = rowsSet["CableTypeCode"];
        if (drCableTypeCodes != null)
        {
            foreach (DataRow dr in drCableTypeCodes)
            {
                lstCabTypeCode.Items.Add(new ListItem(dr["CabTypeCode"].ToString().Trim() + "-" + dr["CabTypeDesc"].ToString(), dr["CabTypeCode"].ToString().Trim()));
            }
        }

        //Shop Field
        lstShopFieldCode.Items.Clear();
        lstShopFieldCode.Items.Add("");
        lstShopFieldCode.Items.Add(new ListItem("Shop", "S"));
        lstShopFieldCode.Items.Add(new ListItem("Field", "F"));


        //Job Location Code
        lstJobLocationCode.Items.Clear();
        lstJobLocationCode.Items.Add("");
        IEnumerable<DataRow> drJobLocationCodes = rowsSet["JobLocationCode"];
        if (drJobLocationCodes != null)
        {
            foreach (DataRow dr in drJobLocationCodes)
            {
                lstJobLocationCode.Items.Add(new ListItem(dr["JobLocationCode"].ToString().Trim() + "-" + dr["JobLocationDesc"].ToString(), dr["JobLocationCode"].ToString().Trim()));
            }
        }



        //Group
        var tabStrip = new TabStrip("tabGroup", TabStripMethod.Url);
        tabStrip.Add("Standard Jobs", "Standard Jobs", "1", new Unit( 0)  , "onclick='ChangeQuerySection(1);'");
        tabStrip.Add("Work Orders", "Work Orders", "2", new Unit(0), "onclick='ChangeQuerySection(2);'");
        tabStrip.Add("Quotes", "Quotes", "3", new Unit(0), "onclick='ChangeQuerySection(3);'"); 
        tabStrip.SelectedValue = "2";
        litGroupTabs.Text = tabStrip.GetHtml();


        lstMake.Items.Clear();
        lstMake.Items.Add("");
        IEnumerable<DataRow> drMake = rowsSet["Manufacturer"];
        if (drMake != null)
        {
            foreach (DataRow dr in drMake)
            {
                lstMake.Items.Add(new ListItem(dr["ManufacturerCode"].ToString() + "-" + dr["ManufacturerCodeDescription"].ToString(), dr["ManufacturerCode"].ToString().Trim()));  //<CODE_TAG_104589>
            }
        }

        txtFromDate.Text = Util.DateFormat(DateTime.Now.AddMonths(0 -  AppContext.Current.AppSettings["psQuoter.AdvancedSearch.DefaultTimeSpan"].AsInt( )  ));
        txtToDate.Text = Util.DateFormat(DateTime.Now);

        txtLimitRecords.Text = AppContext.Current.AppSettings["psQuoter.AdvancedSearch.DefaultLimitRecords"];
    }

    
    private void Page_PreRender(object sender, System.EventArgs e)
    {
        
    }



    protected void txtJobCode_TextChanged(object sender, EventArgs e)
    {
       // Response.Write(txtJobCode.Text);
    }
}

