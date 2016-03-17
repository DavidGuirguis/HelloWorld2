using AppContext = Canam.AppContext;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data;
using X;
using X.Extensions;
using X.Web.UI.WebControls;
using Entities;
using Helpers;
using System.Text;
using System.IO;

using MenuItem = X.Web.Entities.MenuItem;
using MenuItemGroup = X.Web.Entities.MenuItemGroup;

public partial class Modules_AdvancedSearch : UI.Abstracts.Pages.ReportViewPage   
{
    protected string JobCodeList = "";
    protected string ComponentCodeList = "";
    protected string ModifierCodeList = "";
    protected string CostCentreCodeList = "";
    // <CODE_TAG_104104>
    protected string StoreCodeList = "";
    protected string OriginatorList = "";
    protected string OwnerList = "";
    protected string ManagerList = "";
    // </CODE_TAG_104104>

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
        ds = DAL.Quote.Quote_Get_InitAdvancedSearch();
        rowsSet = ds.ToDictionary();

        //Make

        StringBuilder sb;
        //JobCode
        IEnumerable<DataRow> drJobCodes = rowsSet["JobCode"];
        //JobCodeList += ",&nbsp;" ;
        JobCodeList += "~&nbsp;";//<CODE_TAG_103329>
        if (drJobCodes != null)
        {
            sb = new StringBuilder();
            foreach (DataRow dr in drJobCodes)
            {
                //if (JobCodeList != "") JobCodeList += spiltChar.ToString();
                //JobCodeList += dr["jobCode"].ToString().Trim() + "," + dr["jobCode"].ToString().Trim() + "-" + Server.HtmlEncode(dr["JobCodeDesc"].ToString());
                sb.Append(spiltChar.ToString());
                //sb.Append(dr["jobCode"].ToString().Trim() + "," + dr["jobCode"].ToString().Trim() + "-" + Server.HtmlEncode(dr["JobCodeDesc"].ToString()));
                sb.Append(dr["jobCode"].ToString().Trim() + "~" + dr["jobCode"].ToString().Trim() + "-" + Server.HtmlEncode(dr["JobCodeDesc"].ToString()));////<CODE_TAG_103329>
            }
            JobCodeList += sb.ToString();
        }


        //Component Code
        IEnumerable<DataRow> drComponentCodes = rowsSet["ComponentCode"];
        //ComponentCodeList += ",&nbsp;";
        ComponentCodeList += "~&nbsp;";//<CODE_TAG_103329>
        if (drComponentCodes != null)
        {
            sb = new StringBuilder();
            foreach (DataRow dr in drComponentCodes)
            {
               // if (ComponentCodeList != "") ComponentCodeList += spiltChar.ToString();
               // ComponentCodeList += dr["ComponentCode"].ToString().Trim() + "," + dr["ComponentCode"].ToString().Trim() + "-" + Server.HtmlEncode(dr["ComponentCodeDesc"].ToString());
               sb.Append(spiltChar.ToString());
               //sb.Append(dr["ComponentCode"].ToString().Trim() + "," + dr["ComponentCode"].ToString().Trim() + "-" + Server.HtmlEncode(dr["ComponentCodeDesc"].ToString()));
               sb.Append(dr["ComponentCode"].ToString().Trim() + "~" + dr["ComponentCode"].ToString().Trim() + "-" + Server.HtmlEncode(dr["ComponentCodeDesc"].ToString())); //<CODE_TAG_103329>
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
        // <CODE_TAG_104104>
        //lstStoreCode.Items.Clear();   
        //lstStoreCode.Items.Add("");   
        IEnumerable<DataRow> drStoreCodes = rowsSet["StoreCode"];
        //StoreCodeList += "~&nbsp;";  
        StoreCodeList = "";
        if (drStoreCodes != null)
        {
            sb = new StringBuilder();
            foreach (DataRow dr in drStoreCodes)
            {
                //lstStoreCode.Items.Add(new ListItem(dr["BranchCode"].ToString().Trim() + "-" + dr["BranchName"].ToString(), dr["BranchCode"].ToString().Trim()));                
                sb.Append(spiltChar.ToString());
                sb.Append(dr["BranchCode"].ToString().Trim() + "~" + dr["BranchCode"].ToString().Trim() + "-" + Server.HtmlEncode(dr["BranchName"].ToString()));
            } 
            StoreCodeList += sb.ToString();
        }      

        //CostCentreCode
        //CostCentreCodeList += ",&nbsp;";
        CostCentreCodeList = "";
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
                    sb.Append(Server.HtmlEncode(dr["BranchNo"].ToString().Trim()) + dr["CostCentreCode"].ToString().Trim() + "~" + dr["BranchNo"].ToString().Trim() + " - " + dr["CostCentreCode"].ToString().Trim() + " - " + dr["CostCentreName"].ToString().Trim());
                }
                CostCentreCodeList += sb.ToString();
            }
        }
        // </CODE_TAG_104104>

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
        tabStrip.SelectedValue = "3";
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

        // <CODE_TAG_104104>
        //Originator
        IEnumerable<DataRow> drOriginator = rowsSet["Originator"];
        OriginatorList = "";
        if (drOriginator != null)
        {
            sb = new StringBuilder();
            foreach (DataRow dr in drOriginator)
            {
                sb.Append(spiltChar.ToString());
                sb.Append(dr["UserId"].ToString().Trim() + "~" + Server.HtmlEncode(dr["UserName"].ToString()));
            }
            OriginatorList += sb.ToString();
        }

        //Owner
        IEnumerable<DataRow> drOwner = rowsSet["Owner"];
        OwnerList = "";
        if (drOwner != null)
        {
            sb = new StringBuilder();
            foreach (DataRow dr in drOwner)
            {
                sb.Append(spiltChar.ToString());
                sb.Append(dr["OwnerId"].ToString().Trim() + "~" + Server.HtmlEncode(dr["OwnerName"].ToString()));
            }
            OwnerList += sb.ToString();
        }

        //Manager
        IEnumerable<DataRow> drManager = rowsSet["Manager"];
        ManagerList += "";
        if (drManager != null)
        {
            sb = new StringBuilder();
            foreach (DataRow dr in drManager)
            {
                sb.Append(spiltChar.ToString());
                sb.Append(dr["ManagerId"].ToString().Trim() + "~" + Server.HtmlEncode(dr["ManagerName"].ToString()));
            }
            ManagerList += sb.ToString();
        }
    }

    
    private void Page_PreRender(object sender, System.EventArgs e)
    {
        
    }

    protected void lbtnExcel_Click_QT(object sender, EventArgs e)
    {

        //ds = X.Data.SqlHelper.ExecuteDataset("dbo.Quote_List_AdvancedSearch_Quote", txtOnlyCutomerNo.Text, lstMake.Text, txtSerialNo.Text, txtModel.Text, hidJobCode.Value, txtJobCode.Text, hidComponentCode.Value, txtComponentCode.Text,
        //    hidModifierCode.Value, txtModifierCode.Text, lstBusinessGroupCode.Text, lstQuantityCode.Text, lstWorkApplicationCode.Text, hidStoreCode.Value, hidCostCenterCode.Value, lstCabTypeCode.Text, lstShopFieldCode.Text,
        //    lstJobLocationCode.Text,"", "", hidOriginator.Value, hidOwner.Value, hidManager.Value, txtLimitRecords.Text, (rdoLimitRecordsByDate.Checked)? "Date":"Number", 2568);
        ds = X.Data.SqlHelper.ExecuteDataset("dbo.Quote_List_AdvancedSearch_Quote", txtOnlyCutomerNo.Text, lstMake.Text, txtSerialNo.Text, txtModel.Text, hidJobCode.Value, txtJobCode.Text, hidComponentCode.Value, txtComponentCode.Text,
            hidModifierCode.Value, txtModifierCode.Text, lstBusinessGroupCode.Text, lstQuantityCode.Text, lstWorkApplicationCode.Text, hidStoreCode.Value, hidCostCenterCode.Value, lstCabTypeCode.Text, lstShopFieldCode.Text,
            lstJobLocationCode.Text, txtFromDate.Text,txtToDate.Text, hidOriginator.Value, hidOwner.Value, hidManager.Value, (rdoLimitRecordsByDate.Checked) ? "50" : txtLimitRecords.Text, (rdoLimitRecordsByDate.Checked) ? "Date" : "Number");

        Helpers.ExcelHelper.WriteHeader("Quote.xls");
        Response.Write("<table>");
        Response.Write(renderResultHeader(false));
        Response.Write(renderResultData("Data.Items", true));
        Response.Write(renderResultData("Data.Total", true));
        Response.Write("</table>");
        Helpers.ExcelHelper.WriteFooter(true);

    }

    private string renderResultHeader(bool exportExcel = false)
    {
        string[] thStyle = new string[29];
        thStyle[0] = "style='text-align:center'";
        thStyle[1] = "style='text-align:center'";
        thStyle[2] = "style='text-align:center'";
        for (int i = 3; i < thStyle.Length - 1; i++)
        {
            thStyle[i++] = "style='text-align:right;'";
            thStyle[i] = "style='text-align:center'";
        }
        int idx = 0;
        StringBuilder sb = new StringBuilder();
        string fieldName;
        string displayName;
        string groupName;
        string align;
        string extraPropetries;
        string tooltip;
        int colspan = 0;
        string oldGroupName = "";

        DataTable dtHeader = getDataTable("Config.Header");
        if (dtHeader == null) return "";

        int headerRows = 1;
        //foreach (DataRow dr in dtHeader.Rows)
        //{
        //    if (dr["DisplayName"].ToString().Contains("{") && dr["DisplayName"].ToString().Contains("}"))
        //    {
        //        headerRows = 2;
        //        break;
        //    }
        //}

        for (int iRow = 1; iRow <= headerRows; iRow++)
        {
            sb.Append("<tr class='thc' >" + Environment.NewLine);  //<CODE_TAG_101720>
            foreach (DataRow dr in dtHeader.Rows)
            {
                fieldName = dr["fieldName"].ToString().Trim();
                displayName = dr["displayName"].ToString().Trim();
                extraPropetries = dr["extraProperties"].ToString().Trim();
                tooltip = getExtraProperty(extraPropetries, "ToolTip");
                groupName = getGroupName(displayName);
                align = getExtraProperty(extraPropetries, "Align");

                if (iRow == 1)
                {
                    if (groupName != "")
                    {
                        if (groupName != oldGroupName && oldGroupName != "")
                        {
                            sb.Append("<th  style='text-align:center' colspan='" + colspan + "'>");
                            sb.Append(oldGroupName);
                            sb.Append("</th>" + Environment.NewLine);  //<CODE_TAG_101720>
                            colspan = 1;
                        }
                        else
                        {
                            colspan++;
                        }
                        oldGroupName = groupName;
                    }
                    else
                    {
                        sb.Append("<th rowspan='1' style='cursor: pointer; text-align:" + align + "' title='" + tooltip + "' ");
                        if (exportExcel)
                            sb.Append("  >" + displayName);
                        else
                            sb.Append(" onclick=\"sort('" + fieldName + "')\" >" + displayName);
                        sb.Append("</th>" + Environment.NewLine);  //<CODE_TAG_101720>
                    }
                }
                else
                {
                    if (groupName != "")
                    {
                        displayName = displayName.Replace("{" + groupName + "}", "");
                        //<CODE_TAG_101720>
                        if (exportExcel)
                        {
                            displayName = displayName.Replace("<br/>", " ");
                            sb.Append(string.Format("<th {0} >{1}</th>", thStyle[idx], displayName));
                        }
                        else
                        {
                            sb.Append("<th style='cursor: pointer;  font-weight: normal; text-align:" + align + "' title='" + tooltip + "' ");// <CODE_TAG_101710> 
                            sb.Append(" onclick=\"sort('" + fieldName + "')\" >" + displayName);
                        }
                        sb.Append("</th>" + Environment.NewLine);
                        //<CODE_TAG_101720>
                    }
                    idx++;
                }
            }

            if (colspan > 0 && iRow == 1 && oldGroupName != "")
            {
                sb.Append("<th style='text-align:center' colspan='" + colspan + "'>");
                sb.Append(oldGroupName);
                sb.Append("</th>");
            }
            sb.Append("</tr>" + Environment.NewLine); //<CODE_TAG_101720>
        }
        return sb.ToString();
    }

    private string renderResultData(string dataSection, bool exportExcel = false)
    {
        //<CODE_TAG_101720>
        string[] tdStyle = new string[29];
        tdStyle[0] = "style='text-align:left;mso-number-format:\"\\@\"'";
        tdStyle[1] = "style='text-align:center;mso-number-format:\"0\"'";
        tdStyle[2] = "style='text-align:center;mso-number-format:\"0\"'";
        for (int i = 3; i < 7; i++)
        {
            //tdStyle[i++] = "style='text-align:right;mso-number-format:\"0\\.00\"'";
            tdStyle[i] = "style='text-align:left;mso-number-format:\"\\@\"'";
        }

        for (int i = 7; i < 14; i++)
        {
            //tdStyle[i++] = "style='text-align:right;mso-number-format:\"0\\.00\"'";
            tdStyle[i] = "style='text-align:left;mso-number-format:\"\\0\\.00\"'";
        }
        for (int i = 14; i < 19; i++)
        {
            //tdStyle[i++] = "style='text-align:right;mso-number-format:\"0\\.00\"'";
            tdStyle[i] = "style='text-align:left;mso-number-format:\"\\@\"'";
        };        

        tdStyle[19] = "style='text-align:left;mso-number-format:\"\\mm/dd/yyyy\"'";
        tdStyle[20] = "style='text-align:left;mso-number-format:\"\\mm/dd/yyyy\"'";
        tdStyle[21] = "style='text-align:left;mso-number-format:\"\\@\"'";
        tdStyle[22] = "style='text-align:left;mso-number-format:\"\\@\"'";
        tdStyle[23] = "style='text-align:left;mso-number-format:\"\\mm/dd/yyyy\"'";
        tdStyle[24] = "style='text-align:center;mso-number-format:\"0\"'";
        tdStyle[25] = "style='text-align:right;mso-number-format:\"\\0\\.00\"'";
        tdStyle[26] = "style='text-align:right;mso-number-format:\"\\0\\.00\"'";
        tdStyle[27] = "style='text-align:right;mso-number-format:\"\\0\\.00\"'";
        tdStyle[28] = "style='text-align:right;mso-number-format:\"\\0\\.00\"'";
        StringBuilder sb = new StringBuilder();
        string fieldName;
        string displayName;
        string extraPropetries;

        string wrap;		//<CODE_TAG_101776> Dav

        string link;
        string itemLink;
        string totalLink;

        string dataType;
        int digit = 0;
        string align;
        int colspan = 0;
        string oldGroupName = "";
        string value;
        List<string> liReplaces;
        int columnId = 0;
        DataTable dtHeader = getDataTable("Config.Header");
        DataTable dtResult;
        if (dataSection == "Data.Total")
            dtResult = getDataTable("Data.Total");
        else
            dtResult = getDataTable("Data.Items");

        if (dtHeader == null || dtResult == null) return "";

        string rowClass = "rd";

        foreach (DataRow drData in dtResult.Rows)
        {
            if (dataSection == "Data.Total") /*rowClass = "thc"*/; //<CODE_TAG_101710>

            sb.Append("<tr  class='" + rowClass + "'>" + Environment.NewLine); //<CODE_TAG_101720>
            if (rowClass == "rd")
                rowClass = "rl";
            else
                rowClass = "rd";


            columnId = 0;
            foreach (DataRow drHeader in dtHeader.Rows)
            {
                fieldName = drHeader["fieldName"].ToString().Trim();
                displayName = drHeader["displayName"].ToString().Trim();
                extraPropetries = drHeader["extraProperties"].ToString().Trim();
                link = getExtraProperty(extraPropetries, "Link");
                itemLink = getExtraProperty(extraPropetries, "ItemLink");
                totalLink = getExtraProperty(extraPropetries, "TotalLink");

                wrap = getExtraProperty(extraPropetries, "Wrap");		//<CODE_TAG_101776> Dav

                if (dataSection == "Data.Total")
                {
                    if (totalLink != "") link = totalLink;
                }
                else
                {
                    if (itemLink != "") link = itemLink;
                }

                dataType = getExtraProperty(extraPropetries, "DataType");
                digit = getExtraProperty(extraPropetries, "Digit").AsInt(0);
                align = getExtraProperty(extraPropetries, "Align");
                value = drData[fieldName].ToString();
                liReplaces = getReplaces(link);
                if (!exportExcel)
                {
                    if (dataType == "Double")
                    {
                        double d = value.AsDouble(0);
                        value = Util.NumberFormat(d, digit, null, null, null, null);
                    }
                    if (dataType == "Integer")
                    {
                        int tempI = value.AsInt(0);
                        value = Util.NumberFormat(tempI, 0, null, null, null, null);
                    }
                }
                if (dataSection == "Data.Total" && columnId == 0)
                    //value = GetLocalResourceObject("rkLabel_Total").ToString();
                    value = "Total";

                if (liReplaces != null)
                {
                    foreach (string str in liReplaces)
                    {
                        link = link.Replace("{" + str + "}", drData[str].ToString());
                    }
                    //link = link.Replace("{DateRangeTypeId}", (rdoMonthBack.Checked) ? "1" : "2");
                    //link = link.Replace("{DateRangeId}", lstMonthBack.SelectedValue);
                    //link = link.Replace("{ReportYearTypeId}", lstYearType.SelectedValue);
                    //link = link.Replace("{ReportYear}", lstYear.SelectedValue);
                }

                //<CODE_TAG_101720>
                if (exportExcel)
                {
                    sb.Append(string.Format("<td {0} >", tdStyle[columnId]));
                }
                else
                {
                    //<CODE_TAG_101776> Dav
                    //sb.Append("<td style='text-align:" + align  + "'>");
                    sb.Append("<td style='text-align:" + align + "' " + wrap + ">");
                    //</CODE_TAG_101776> Dav

                }
                //</CODE_TAG_101720>
                if (exportExcel) link = "";

                if (link == "")
                    sb.Append(value);
                else
                { }// sb.Append("<a href='" + this.CreateUrl(link) + "'>" + value + "</a>");

                sb.Append("</td>" + Environment.NewLine); //<CODE_TAG_101720>
                columnId++;
            }
            sb.Append("</tr>" + Environment.NewLine);
        }
        return sb.ToString();

    }

    private DataTable getDataTable(string tableName)
    {

        foreach (DataTable dt in ds.Tables)
        {
            if (dt.Rows.Count > 0 && dt.Columns.Contains("RS_Type"))
            {
                if (dt.Rows[0]["RS_Type"].ToString() == tableName)
                    return dt;
            }
        }

        return null;
    }

    private string getExtraProperty(string extraXML, string propertyName)
    {
        //string rt = "";
        //extraXML = "<root>" + extraXML + "</root>";
        //XmlDocument xdoc = new XmlDocument();
        //xdoc.LoadXml(extraXML);

        //XmlNodeList xnList = xdoc.SelectNodes("root/" + propertyName);
        //if (xnList.Count > 0)
        //    rt = xnList[0].InnerText;

        return "";//rt.Trim();

    }

    private string getGroupName(string title)
    {
        string rt = "";
        if (title.Contains("{") && title.Contains("}"))
        {
            int posStart = title.IndexOf("{") + 1;
            int posEnd = title.IndexOf("}") - 1;
            if (posEnd > posStart && posStart > 0 && posEnd > 0)
                rt = title.Substring(posStart, posEnd - posStart + 1);
        }

        return rt.Trim();
    }

    private List<string> getReplaces(string inputStr)
    {
        if (inputStr.IsNullOrWhiteSpace()) return null;
        string[] inputArr = inputStr.Select(ch => ch.ToString()).ToArray();
        List<string> li = new List<string>();
        bool inKey = false;
        string key = "";
        foreach (string ch in inputArr)
        {
            switch (ch)
            {
                case "{":
                    inKey = true;
                    key = "";
                    break;
                case "}":
                    inKey = false;
                    if (key != "") li.Add(key);
                    break;
                default:
                    if (inKey) key += ch;
                    break;
            }
        }

        return li;

    }

    protected void lbtnExcel_Click_SJ(object sender, EventArgs e)
    {
        ds = X.Data.SqlHelper.ExecuteDataset("dbo.Quote_List_AdvancedSearch_StandardJob", txtOnlyCutomerNo.Text, lstMake.Text, txtSerialNo.Text, txtModel.Text, hidJobCode.Value, txtJobCode.Text, hidComponentCode.Value, txtComponentCode.Text,
            hidModifierCode.Value, txtModifierCode.Text, lstBusinessGroupCode.Text, lstQuantityCode.Text, lstWorkApplicationCode.Text, hidStoreCode.Value, hidCostCenterCode.Value, lstCabTypeCode.Text, lstShopFieldCode.Text,
            lstJobLocationCode.Text, hidOriginator.Value, hidOwner.Value, hidManager.Value);

        Helpers.ExcelHelper.WriteHeader("StandardJob.xls");
        Response.Write("<table>");
        Response.Write(renderResultHeader(false));
        Response.Write(renderResultData("Data.Items", true));
        Response.Write(renderResultData("Data.Total", true));
        Response.Write("</table>");
        Helpers.ExcelHelper.WriteFooter(true);

    }
    protected void lbtnExcel_Click_WO(object sender, EventArgs e)
    {
        ds = X.Data.SqlHelper.ExecuteDataset("dbo.Quote_List_AdvancedSearch_WorkOrder", txtOnlyCutomerNo.Text, lstMake.Text, txtSerialNo.Text, txtModel.Text, hidJobCode.Value, txtJobCode.Text, hidComponentCode.Value, txtComponentCode.Text,
            hidModifierCode.Value, txtModifierCode.Text, lstBusinessGroupCode.Text, lstQuantityCode.Text, lstWorkApplicationCode.Text, hidStoreCode.Value, hidCostCenterCode.Value, lstCabTypeCode.Text, lstShopFieldCode.Text,
            lstJobLocationCode.Text, txtFromDate.Text, txtToDate.Text, hidOriginator.Value, hidOwner.Value, hidManager.Value, (rdoLimitRecordsByDate.Checked) ? "50" : txtLimitRecords.Text, (rdoLimitRecordsByDate.Checked) ? "Date" : "Number");            
        Helpers.ExcelHelper.WriteHeader("WorkOrder.xls");
        Response.Write("<table>");
        Response.Write(renderResultHeader(false));
        Response.Write(renderResultData("Data.Items", true));
        Response.Write(renderResultData("Data.Total", true));
        Response.Write("</table>");
        Helpers.ExcelHelper.WriteFooter(true);

    }


}

