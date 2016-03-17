<%@ Page language="c#"
Inherits="UI.Abstracts.Pages.Popup" 
MasterPageFile="~/library/masterPages/_base.master"
IsLegacyPage="true"%>
<%@ Import Namespace = "ADODB" %>
<%@ Import Namespace = "Microsoft.VisualBasic" %>
<%@ Import Namespace = "System.Net.Mail" %>
<%@ Import Namespace = "System.Text.RegularExpressions" %>
<%@ Import Namespace = "nce.scripting" %>
<%@ Import Namespace="System.Data" %>
<asp:Content ID="cntMP" ContentPlaceHolderID="cntMP" Runat="Server">
<%
    Main();
%>
<script language="C#" runat="server">

    //ADODB.Connection cnn LegacyHelper.OpenDataConnection()/*DONE:review if the code was trying to open a data connection - was 'PSQuoterOleDbConnectionString'*/ = null;
   
    string sDefaultDivision = null;/*DONE:review - check if it's using correct type*/
    string /*DONE:replace 'object' with proper type*/ gAppID_URLKey = null;
    string /*DONE:replace 'object' with proper type*/ sCUNO = null;
    string /*DONE:replace 'object' with proper type*/ sCUNM = null;
    string Direction = null;
    string strId = null;
    string strQueryString = null;
    string strLink = null;
    string tmpHTML = null;
    string strSelectInfluenceridx = "";
       //<CODE_TAG_103855>

    string GetInflencerList(DataSet ds)
    {
		DataTable dt = new DataTable();
		dt = getDataTable(ds, "Contact.List");
		string retStr = "";
        //<CODE_TAG_104057>
        string rowDelimiter = Helpers.DataDelimiter.MatrixDataDelimeter.influencer_RowDelimiter;
        string colDelimiter = Helpers.DataDelimiter.MatrixDataDelimeter.influencer_ColumnDelimiter;
        //</CODE_TAG_104057>
		foreach (DataRow row in dt.Rows)  
		{
                //retStr +=  "," + row["InfluencerName"].As<string>() + "|" + row["Phone"].As<string>() + "|" + row["FaxNo"].As<string>() + "|" + row["Email"].As<string>() + "|" + row["InfluencerType"].As<string>() + "|" + row["InfluencerId"].As<string>() + "|" + row["Division"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                //retStr +=  "~" + row["InfluencerName"].As<string>() + "|" + row["Phone"].As<string>() + "|" + row["FaxNo"].As<string>() + "|" + row["Email"].As<string>() + "|" + row["InfluencerType"].As<string>() + "|" + row["InfluencerId"].As<string>() + "|" + row["Division"].As<string>();//<CODE_TAG_103327.>			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property		
                retStr +=  rowDelimiter + row["InfluencerName"].As<string>() + colDelimiter + row["Phone"].As<string>() + colDelimiter + row["FaxNo"].As<string>() + colDelimiter + row["Email"].As<string>() + colDelimiter + row["InfluencerType"].As<string>() + colDelimiter + row["InfluencerId"].As<string>() + colDelimiter + row["Division"].As<string>();//<CODE_TAG_103327.>			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property  //<CODE_TAG_104057>

		}
		return  retStr;

    }
    //</CODE_TAG_103855>

	//<CODE_TAG_103506> Dav
    string FormatARNumber(double number, int numDigitsAfterDecimal, string color) 
    {
        string beforeBegin = null;
        string afterEnd = null;
        //if (!(Information.IsNumeric(number)))
        if (number==0) 
        {
            return "";
        }
        if (!(color.IsNullOrWhiteSpace()) && number > 0)
        {
            beforeBegin = "<font color=\"" + color + "\">";
            afterEnd = "</font>";
        }
        return beforeBegin + Strings.FormatNumber(number, numDigitsAfterDecimal, TriState.False, TriState.True, TriState.UseDefault) + afterEnd;
    }

	private DataTable getDataTable(DataSet ds, string tableName)
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
	//</CODE_TAG_103506> Dav
	        
    //<CODE_TAG_100425> Add function SortHeadrWithTab
    string SortHeaderWithTab(string sHdrTitle, int iAlign, string sSortField, string sOldField, string sOldDirection, string sOldTabName) 
    {
        
        
        //Direction Logic
        if (sSortField != sOldField)
        {
            Direction = "asc";
        }
        else
        {
            if (sOldDirection.ToLower() == "asc")
            {
                Direction = "desc";
            }
            else
            {
                Direction = "asc";
            }
        }
        switch (iAlign) {
            case 0:
                strId = "rshl";
                break;
            case 1:
                strId = "rshc";
                break;
            case 2:
                strId = "rshr";
                break;
        }
        strQueryString = Request.ServerVariables["QUERY_STRING"];
        strQueryString = strQueryString.Replace("&CurTabName=" + sOldTabName, "");
        strQueryString = strQueryString.Replace("&SortField=" + sOldField, "");
        strQueryString = strQueryString.Replace("&SortDirection=" + sOldDirection, "");
        strQueryString = strQueryString.Replace("&influenceridx=" + strSelectInfluenceridx, "");
        strLink = "Customer_Details.aspx?" + strQueryString + "&SortField=" + sSortField + "&SortDirection=" + Direction;
        tmpHTML = "<td id=\"" + strId + "\" onClick=\"sortEquipment('" + strLink + "&CurTabName=' + curTabName)  ;\" title=\"" + String.Format((string)GetLocalResourceObject("rkHeaderText_ClickHereToSortBy"), sHdrTitle) + "\" style=\"cursor:pointer;\">" + sHdrTitle + "</td>";
        return tmpHTML;
    }

    void Main() 
    {
        ADODB.Command cmd = null;
        //ADODB.Recordset rs = null;		//<CODE_TAG_103506> Dav
        string sOperation = null;/*DONE:review if it's right type - was 'object'*/
        string strOperation = null;/*DONE:review if it's right type - was 'object'*/
        string strError = null;/*DONE:review if it's right type - was 'object'*/
        int? intReturnValue = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
        string sCustomerNo = null;/*DONE:review - check if it's using correct type*/
        string sCustomerName = null;/*DONE:review - check if it's using correct type*/
        string/*DONE:replace 'object' with proper type*/ sAddress1 = null;
        string/*DONE:replace 'object' with proper type*/ sAddress2 = null;
        string/*DONE:replace 'object' with proper type*/ sAddress3 = null;
        string/*DONE:replace 'object' with proper type*/ sCity = null;
        int? iPSTRate = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
        int? iGSTRate = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
        string/*DONE:replace 'object' with proper type*/ sContact = null;
        string/*DONE:replace 'object' with proper type*/ sAddress = null;
        string/*DONE:replace 'object' with proper type*/ sDiv = null;
        int i = 0;/*DONE:review - check if it's using correct type*/
        string strClass = null;/*DONE:review if it's right type - was 'object'*/
        int? iCreditTotal = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
        int? iCreditLimit = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
        int? iInfId = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
        int? iSearchField = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
        string sSearchValue = null;/*DONE:review - check if it's using correct type*/
        string sSN = null;/*DONE:review - check if it's using correct type*/
        string sEquipNo = null;/*DONE:review - check if it's using correct type*/
        string/*DONE:replace 'object' with proper type*/ sModel = null;
        string/*DONE:replace 'object' with proper type*/ sAddressMainURL = null;
        string/*DONE:replace 'object' with proper type*/ sCityURL = null;
        string/*DONE:replace 'object' with proper type*/ sPostalURL = null;
        string sStockNo = null;/*DONE:review - check if it's using correct type*/
        string sWOSearch = null;
        int? iPPMModelId = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
        int? iPPMFPCId = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
        string/*DONE:replace 'object' with proper type*/ sServiceMeterInd = null;
        string/*DONE:replace 'object' with proper type*/ sSOSSerialNumber = null;
        string/*DONE:replace 'object' with proper type*/ sWOSerialNumber = null;
        string/*DONE:replace 'object' with proper type*/ sPPMSerialNumber = null;
        int? SalesRepId = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
        string FullName = null;/*DONE:review if it's right type - was 'object'*/
        string/*DONE:replace 'object' with proper type*/ sMainPhoneNo = null;
        int? iTermsCode = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
        string/*DONE:replace 'object' with proper type*/ sMake = null;
        int?/*DONE:replace 'object' with proper type*/ sPIP = null;
        int?/*DONE:replace 'object' with proper type*/ sWarrantyCoverage = null;
        string/*DONE:replace 'object' with proper type*/ sCabTypeCode = null; //  Ticket 17730  
        int? iAppId = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
        string sVIN = null;
        string sSearchDivision = null;/*DONE:review - check if it's using correct type*/
        string sRecordCountIsOne = null;/*DONE:review - check if it's using correct type*/
        int? iSystemId = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
        int? iBusinessEntityId = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
        string/*DONE:replace 'object' with proper type*/ TRRowClass = null;
        string EquipManufCode = null;/*DONE:review if it's right type - was 'object'*/
        string EquipManufDesc = null;/*DONE:review if it's right type - was 'object'*/
        string/*DONE:replace 'object' with proper type*/ SerialNumber = null;
        string/*DONE:replace 'object' with proper type*/ EquipmentNumber = null;
        string/*DONE:replace 'object' with proper type*/ IdNumber = null;
        string/*DONE:replace 'object' with proper type*/ ModelNumber = null;
        string/*DONE:replace 'object' with proper type*/ YearOfManuf = null;
        DateTime? PurchaseDate = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'string'*/
        string Division = null;/*DONE:review - check if it's using correct type*/
        string Description = null;/*DONE:review if it's right type - was 'object'*/
        string/*DONE:replace 'object' with proper type*/ DisplayModel = null;
        string CompatibilityCode = null;/*DONE:review if it's right type - was 'object'*/
        string IndustryCode = null;/*DONE:review if it's right type - was 'object'*/
        string FamilyProductCode = null;/*DONE:review if it's right type - was 'object'*/
        string/*DONE:replace 'object' with proper type*/ IndustryGroup = null;
        double?/*DONE:replace 'object' with proper type*/ ServiceMeter = null;
        string ServiceMeterInd = null;/*DONE:review - check if it's using correct type*/
        DateTime? ServiceMeterDate = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
        int? PPMModelId = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
        int? /*DONE:replace 'object' with proper type*/ PPMSerialNumber = null;
        int? PPMFPCId = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
        int?/*DONE:replace 'object' with proper type*/ SOSSerialNumber = null;
        int?/*DONE:replace 'object' with proper type*/ WOSerialNumber = null;
        int? CurrSystemId = null;/*DONE:review if it's right type and if it should be NOT NULLABLE - was 'object'*/
        bool blnShowOpp = false;
        string curTabName = null;/*DONE:review - check if it's using correct type*/
        string sDivisionList = null;/*DONE:review - check if it's using correct type*/
        string sInfluencerList = null;/*DONE:review - check if it's using correct type*/
        string sOpportunityList = null;/*DONE:review - check if it's using correct type*/
        string sDivision = null;
        string strSortField = null;/*DONE:review - check if it's using correct type*/
        string strSortDirection = null;/*DONE:review - check if it's using correct type*/
        
        if (Request.QueryString["influenceridx"] != null)
            strSelectInfluenceridx = Request.QueryString["influenceridx"];
        //<fxiao, 2010-02-24::Consolidate flags into one />
        //<CODE_TAG_100425>
        sCustomerNo = (Request.QueryString["CustomerNo"] ?? String.Empty).Trim();
        sCustomerName = Request.QueryString["CustomerName"];
        iSystemId = Request.QueryString["SystemId"].As<int?>();
        iBusinessEntityId = Request.QueryString["BusinessEntityId"].As<int?>();
        iSearchField = Request.QueryString["SearchField"].As<int?>();
        sSearchValue = Request.QueryString["SearchValue"];
        if (sSearchValue.IsNullOrWhiteSpace())
        {
            sSearchValue = Request.QueryString["Keyword"];
        }
        sSearchDivision = Request.QueryString["SearchDivision"];
        sSN = Request.QueryString["SN"];
        sEquipNo = Request.QueryString["EQNo"];
        sStockNo = Request.QueryString["StockNo"];
        sRecordCountIsOne = Request.QueryString["RecordCountIsOne"];
        //<CODE_TAG_100425>
        curTabName = Request.QueryString["curTabName"];
        if (curTabName.IsNullOrWhiteSpace())
        {
            curTabName = "All";
        }
        //strSortField = Request.QueryString["SortField"] ?? "EquipManufCode";
        //<CODE_TAG_104024>
        string SortField_temp = AppContext.Current.AppSettings["psQuoter.Quote.Header.CustomerSearch.Equipment.SortField"];
        if (!string.IsNullOrEmpty(SortField_temp))
            strSortField = Request.QueryString["SortField"] ?? SortField_temp;
        else
            strSortField = "EquipManufCode";
        //</CODE_TAG_104024>
        strSortDirection = Request.QueryString["SortDirection"] ?? "asc";
       
        //</CODE_TAG_100425>
        if (iSearchField == 5)
        {
            //Serial Number
            if (!sSN.IsNullOrWhiteSpace()/*DONE:review logic - was '!= ""'*/)
            {
                sSearchValue = sSN;
            }
            else
            {
                sSN = sSearchValue;
            }
            sEquipNo = null;
            sStockNo = null;
            sWOSearch = null/*DONE:review - was DBNull*/;
            sVIN = null/*DONE:review - was DBNull*/;
        }
        else if( iSearchField == 6)
        {
            //Equipment Number
            if (!sEquipNo.IsNullOrWhiteSpace()/*DONE:review logic - was '!= ""'*/)
            {
                sSearchValue = sEquipNo;
            }
            else
            {
                sEquipNo = sSearchValue;
            }
            sSN = null;
            sStockNo = null;
            sWOSearch = null/*DONE:review - was DBNull*/;
            sVIN = null/*DONE:review - was DBNull*/;
        }
        else if( iSearchField == 7)
        {
            //Stock Number
            if (!sStockNo.IsNullOrWhiteSpace()/*DONE:review logic - was '!= ""'*/)
            {
                sSearchValue = sStockNo;
            }
            else
            {
                sStockNo = sSearchValue;
            }
            sSN = null;
            sEquipNo = null;
            sWOSearch = null/*DONE:review - was DBNull*/;
            sVIN = null/*DONE:review - was DBNull*/;
        }
        else if( iSearchField == 8)
        {
            //VIN
            if (!sVIN/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/.IsNullOrWhiteSpace()/*DONE:review logic - was '!= ""'*/)
            {
                sSearchValue = sVIN/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/;
            }
            else
            {
                sVIN = sSearchValue;
            }
            sSN = null;
            sEquipNo = null;
            sWOSearch = null/*DONE:review - was DBNull*/;
            sStockNo = null;
        }
        else if( iSearchField == 10)
        {
            //WO No
            if (!sWOSearch/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/.IsNullOrWhiteSpace()/*DONE:review logic - was '!= ""'*/)
            {
                sSearchValue = sWOSearch/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/;
            }
            else
            {
                sWOSearch = sSearchValue;
            }
            sSN = null;
            sEquipNo = null;
            sStockNo = null;
            sVIN = null/*DONE:review - was DBNull*/;
        }
        if (sCustomerNo.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
        {
            sCustomerNo = null;
        }
        if (sSN.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
        {
            sSN = null;
        }
        if (sEquipNo.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
        {
            sEquipNo = null;
        }
        if (sStockNo.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
        {
            sStockNo = null;
        }
        if (sWOSearch/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
        {
            sWOSearch = null/*DONE:review - was DBNull*/;
        }
        if (sVIN/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
        {
            sVIN = null/*DONE:review - was DBNull*/;
        }
        Response.Write("    <div width=\"700\">\r\n");
        Response.Write("        <table width=\"100%\">\r\n");
        Response.Write("            <tr>\r\n");
        if (sRecordCountIsOne == "No")
        {
            Response.Write("                    <td align=\"left\" class=\"t11 tSb\"><a href=\"");
            Response.Write(this.CreateUrl("modules/TRG_Search/Equipment/CustomerSearch/Customer_Search.aspx", normalizeForAppending:true) + "SearchField=" + iSearchField + "&Keyword=" + Server.UrlEncode(sSearchValue) + "&SearchDivision=" + Server.UrlEncode(sSearchDivision));
            Response.Write("\">"+(string)GetLocalResourceObject("rkHeaderText_PrevSearchResult")+"</a></td>            \r\n");
        }
        Response.Write("                <td align=\"right\" class=\"t11 tSb\"><a href=\"");
        Response.Write(this.CreateUrl("modules/TRG_Search/Equipment/CustomerSearch/Customer_Search.aspx"));
        Response.Write("\">"+(string)GetLocalResourceObject("rkHeaderText_NewSearch")+"</a></td>            \r\n");
        Response.Write("            </tr>\r\n");
        Response.Write("        </table>");

		//<CODE_TAG_103506> Dav
        //cmd = new ADODB.CommandClass();
        //cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
        //cmd.CommandText = "dbo.TRG_CustomerSearch_Get_CustomerInfo";
        //cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
        //if (sDefaultDivision.IsNullOrWhiteSpace())
        //{
        //    sDefaultDivision = "%";
        //}
        //cmd.Parameters.Append(cmd.CreateParameter("CustomerNo", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 20, sCustomerNo));
        //cmd.Parameters.Append(cmd.CreateParameter("Division", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 1, sSearchDivision));
        //cmd.Parameters.Append(cmd.CreateParameter("SystemId", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 0, iSystemId));
        //cmd.Parameters.Append(cmd.CreateParameter("BusinessEntityId", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 0, iBusinessEntityId));
        ////<CODE_TAG_100425>
        //cmd.Parameters.Append(cmd.CreateParameter("SortField", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 60, strSortField));
        //cmd.Parameters.Append(cmd.CreateParameter("SortDirection", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 4, strSortDirection)); 
        ////</CODE_TAG_100425>
        //rs = new Recordset();
        //rs = cmd.Execute();

		if (sDefaultDivision.IsNullOrWhiteSpace())
        {
            sDefaultDivision = "%";
        }
		DataSet ds = X.Data.SqlHelper.ExecuteDataset("dbo.TRG_CustomerSearch_Get_CustomerInfo",
			sCustomerNo,
			sSearchDivision,
			iSystemId,
			iBusinessEntityId,
			strSortField,
			strSortDirection
		);
		DataTable dt = getDataTable(ds, "Customer.Header");
		DataRow firstRow = dt.Rows[0];
        string sCustomerLoyaltyIndicator = firstRow["CustomerLoyaltyIndicator"].As<string>(); //<CODE_TAG_104784>
		//</CODE_TAG_103506> Dav

		//<CODE_TAG_103506> Dav
		//if (!(Util.IsLoopableRecordset(rs)))
		if (ds.Tables.Count == 0)  
		//</CODE_TAG_103506> Dav
		{
			Response.Write("<div class=\"t11 tSb\">"+(string)GetLocalResourceObject("rkMsg_NoCustomerFound")+"</div>");
			return ;
		}
        //Settings
        blnShowOpp = BitMaskBoolean.IsTrue(firstRow["OpportunityVisible"].As<string>());		//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
        blnShowOpp = true;
        //Settings
        Response.Write("        <table class=\"tbl\" width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" style=\"border-top: 1px solid #6f6f6f; border-left: 1px solid #6f6f6f; border-right: 1px solid #6f6f6f; border-bottom :1px solid #6f6f6f; background: #efefef;\">\r\n");
        Response.Write("                <tr class=\"t11 tSb\">\r\n");
        Response.Write("                    <td>"+(string)GetLocalResourceObject("rkHeaderText_CustomerNo")+"</td>\r\n");
        if (firstRow["IsMultipleSystem"].As<string>() == "1")			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
        {
            Response.Write("                        <td>"+(string)GetLocalResourceObject("rkHeaderText_System")+"</td>\r\n");
        }
        Response.Write("                    <td>"+(string)GetLocalResourceObject("rkHeaderText_CustomerName")+"</td>\r\n");
        Response.Write("                    <td>"+(string)GetLocalResourceObject("rkHeaderText_Address")+"</td>\r\n");
        Response.Write("                    <td>"+(string)GetLocalResourceObject("rkHeaderText_City")+"</td>    \r\n");
        Response.Write("                    <td style=\"width:5%;\"></td>                                           \r\n");
        Response.Write("                </tr>\r\n");
        Response.Write("                <tr class=\"rl\">\r\n");
        Response.Write("                    <td>");
        Response.Write(Server.HtmlEncode(firstRow["CustomerNumber"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
        Response.Write("</td>\r\n");
        if (firstRow["IsMultipleSystem"].As<string>() == "1")			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
        {
            Response.Write("                        <td>");
            Response.Write(Server.HtmlEncode(firstRow["SystemDesc"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
            Response.Write("</td>\r\n");
        }
        Response.Write("                    <td>");
        Response.Write(Server.HtmlEncode(firstRow["CustomerName"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
        Response.Write("</td>\r\n");
        Response.Write("                    <td>");
        Response.Write(Server.HtmlEncode(firstRow["Address1"].As<string>() + " " + firstRow["Address2"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
        Response.Write("</td>\r\n");
        Response.Write("                    <td>");
        Response.Write(Server.HtmlEncode(firstRow["City"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
        Response.Write("</td>  \r\n");
        Response.Write("                    <td>\r\n");
        Response.Write("                        <input type=\"button\" class=\"f\" value=\"Add\" onclick=\"addCustomer();\" />\r\n");
        Response.Write("                        <input type=\"hidden\" id=\"CustomerNo\" name=\"CustoemrNo\" value=\"");
        Response.Write(Server.HtmlEncode(firstRow["CustomerNumber"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
        Response.Write("\" />\r\n");
        Response.Write("                        <input type=\"hidden\" id=\"CustomerName\" name=\"CustomerName\" value=\"");
        Response.Write(Server.HtmlEncode(firstRow["CustomerName"].As<string>()).Replace(",",""));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
        Response.Write("\" />                    \r\n");
        Response.Write("                    </td>          \r\n");
        Response.Write("                </tr>\r\n");

		//<CODE_TAG_103506> Dav
        //rs = rs.NextRecordset();
		//<CODE_TAG_103506> Dav
		dt = getDataTable(ds, "Customer.Division");
		//</CODE_TAG_103506> Dav
        Response.Write(" \r\n");
        Response.Write("        </table>");
        sDivisionList = "";
		foreach (DataRow row in dt.Rows)   //<CODE_TAG_103506> Dav: //while(!(rs.EOF))        
        {
            sDivisionList = sDivisionList + "," + row["Division"].As<string>() + "|" + row["DivisionName"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
            //<CODE_TAG_100369>Get PSSRs
            sDivisionList = sDivisionList + "|" + row["PSSRXUId"].As<string>() + "|" + (row["PSSRFirstName"].As<string>() + " " + row["PSSRLastName"].As<string>()).Trim();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
            //</CODE_TAG_100369>
            sDivisionList += "|" + row["CustomerLoyaltyIndicator"].As<string>();//<CODE_TAG_104784>
            //rs.MoveNext();  //<CODE_TAG_103506> Dav
        }
        if (!sDivisionList.IsNullOrWhiteSpace()/*DONE:review logic - was '!= ""'*/)
        {
            /*NOTE: Manual Fixup - removed sDivisionList = sDivisionList.Substring(sDivisionList.Length - sDivisionList.Length - 1)*/
            sDivisionList = sDivisionList.Right(sDivisionList.Length - 1);
        }
		
		//<CODE_TAG_103506> Dav
		//rs = rs.NextRecordset();

		//if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.CustomerSearch.AR.Show"))			//<CODE_TAG_103552>Dav
		//{//<CODE_TAG_103552>Dav

		dt = getDataTable(ds, "SalesLink.Keys");		//SalesLink Keys RecordSet
		firstRow = dt.Rows[0];
		bool blnShowUnappliedCash = BitMaskBoolean.IsTrue(firstRow["ShowUnappliedCash"].As<int?>(1));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
		bool blnShowOnCreditHold = BitMaskBoolean.IsTrue(firstRow["ShowOnCreditHold"].As<int?>(1));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
	
		dt = getDataTable(ds, "Data.AR.Header");
		double? CreditLimit = null;
		string categoryDescription = "";
		//</CODE_TAG_103506> Dav
		Response.Write("        <input type=\"hidden\" id=\"DivisionList\" name=\"DivisionList\" value=\"");
		Response.Write(Server.HtmlEncode(sDivisionList));
		Response.Write("\" />\r\n");
		Response.Write("        \r\n");
		Response.Write("        <table id=\"Influencer_Cloned\" class=\"tbl\" width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" style=\"border-left: 1px solid #6f6f6f; border-right: 1px solid #6f6f6f; border-bottom :1px solid #6f6f6f; background: #efefef;\">\r\n");
		Response.Write("        </table>    \r\n");
		Response.Write("        <table id=\"Equipment_Cloned\" class=\"tbl\" width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" style=\"border-left: 1px solid #6f6f6f; border-right: 1px solid #6f6f6f; border-bottom :1px solid #6f6f6f; background: #efefef;\">\r\n");
		Response.Write("        </table>    \r\n");
		Response.Write("        \r\n");
		Response.Write("        <br />\r\n");
		Response.Write("        <table class=\"tbl\" width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" style=\"border-top: 1px solid #6f6f6f; border-left: 1px solid #6f6f6f; border-right: 1px solid #6f6f6f; border-bottom :1px solid #6f6f6f; background: #efefef;\">\r\n");
		Response.Write("            <col width=\"130\"/>\r\n");
		Response.Write("            <col width=\"40\"/>\r\n");
		Response.Write("            <col width=\"90\"/>\r\n");
		Response.Write("            <col width=\"120\"/>\r\n");
		Response.Write("            <col />\r\n");
		if(dt == null)  //<CODE_TAG_103506> Dav: //if (rs.EOF)
		{
			Response.Write("                <tr class=\"t11 tSb\"><td>"+(string)GetLocalResourceObject("rkMsg_NoCustCreditInfoFound")+"</td></tr>\r\n");
		}
		else
		{
			firstRow = dt.Rows[0];		//<CODE_TAG_103506> Dav
			Response.Write("                <tr class=\"t11\">\r\n");
			Response.Write("                    <td id=\"rd\" nowrap><b>"+(string)GetLocalResourceObject("rkMsg_PONumberReqd")+"</b></td>\r\n");
			Response.Write("                    <td class=\"f\">");
			Response.Write(Server.HtmlEncode(firstRow["PONoRequired"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
			Response.Write("</td>\r\n");
			Response.Write("                    <td id=\"rd\" nowrap><b>"+(string)GetLocalResourceObject("rkMsg_TermsCode")+"</b></td>\r\n");
			if (firstRow["TermsCode"].As<string>() != "2")			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
			{
				Response.Write("                        <td class=\"f\"><font color=\"red\">");
				//<CODE_TAG_103506> Dav
				//Response.Write(Server.HtmlEncode(firstRow["TermsCodeDescription"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
				Response.Write(Server.HtmlEncode(firstRow["TermsCodeDescription"].As<string>() + " (" + firstRow["TermsCode"].As<string>() + ")"));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
				//</CODE_TAG_103506> Dav
				Response.Write("</font></td>\r\n");
			}
			else
			{
				Response.Write("                        <td class=\"f\">");
				//<CODE_TAG_103506> Dav
				//Response.Write(Server.HtmlEncode(firstRow["TermsCodeDescription"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
				Response.Write(Server.HtmlEncode(firstRow["TermsCodeDescription"].As<string>() + " (" + firstRow["TermsCode"].As<string>() + ")"));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
				//</CODE_TAG_103506> Dav
				Response.Write("</td>\r\n");
			}
			Response.Write("                    <td></td>\r\n");
			Response.Write("                </tr>        \r\n");

			//<CODE_TAG_103506> Dav
			CreditLimit = firstRow["CreditLimit"].As<double?>();
			categoryDescription = CType.ToString(firstRow["CategoryDescription"], null);
			//</CODE_TAG_103506> Dav
		}
		Response.Write("   \r\n");

		//<CODE_TAG_103506> Dav		
		if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.CustomerSearch.AR.Show"))			//<CODE_TAG_103552>Dav
		{
			Response.Write("		<table class=\"tbl\" width='100%' cellspacing='1' cellpadding='2' border='0'>\r\n");
			Response.Write("			<tr class=\"back\">\r\n");
			Response.Write("				<td colspan='1' class=\"t tSb\" align='left'>Customer Credit Limit: ");
			if (!CreditLimit.IsNullOrWhiteSpace() && CreditLimit != 99999999999)
			{
				Response.Write((Strings.FormatNumber(CreditLimit, 2, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault)));
			}
			else
			{
				if (CreditLimit == 99999999999)
				{
					Response.Write("Unrestricted");
				}
				else
				{
					Response.Write(" ");
				}
			}
			Response.Write("</td>\r\n");
			Response.Write("                ");
			Response.Write("												\r\n");
			Response.Write("				<td colspan=4 id=Td1 class=\"t tSb\" align=left style = \"color:red; font-weight: bold\">");
            
			if (blnShowOnCreditHold)
			{
				Response.Write(categoryDescription);
			}
			else
			{
				Response.Write(" ");
			}
			Response.Write("</td>\r\n");
			Response.Write("				<td colspan='2' id='UAC' class=\"t tSb\" align='right'></td>\r\n");
			Response.Write("			</tr>");

			dt = getDataTable(ds, "Data.AR.AgePeriod");
			bool blnDrillable = AppContext.Current.AppSettings.IsTrue("ckCommon.CustomerAR.Drillable");
			Response.Write("			<tr class=\"thc\">				\r\n");
			bool blnShowCategoryColumn = true;
			Response.Write("				 \r\n");
			Response.Write("				<td id='rshl' width='40%'>Category</td>\r\n");
			if(dt != null)
			{
				foreach (DataRow row in dt.Rows)
				{
					Response.Write("				    <td id='rshc' width='10%'>");
					Response.Write(row["ColumnHeaderLabel"]);			
					Response.Write("</td> 			\r\n");
				}
			}
			else
			{
				Response.Write("				    <td id='rshc' width='10%'>1 - 30</td>\r\n");
				Response.Write("				    <td id='rshc' width='10%'>31 - 60</td>\r\n");
				Response.Write("				    <td id='rshc' width='10%'>61 - 90</td>\r\n");
				Response.Write("				    <td id='rshc' width='10%'>91 - 120</td>\r\n");
				Response.Write("				    <td id='rshc' width='10%'>Over 120</td>\r\n");
				Response.Write("				    <td id='rshc' width='10%'>Total</td>\r\n");
			}

			dt = getDataTable(ds, "Data.AR.Details");
			Response.Write("				");
			Response.Write("			</tr>			\r\n");
			double Total_AllRanges = 0.0;
			double TotalRange0_30 = 0.0;
			double TotalRange31_60 = 0.0;
			double TotalRange61_90 = 0.0;
			double TotalRange91_120 = 0.0;
			double TotalRange_Over120 = 0.0;
			int? CategoryCode = null;
			int itemIndex = 0;
			double categoryMonetaryTotal = 0;
			double categoryPercentageTotal = 0;
			string strURL = "";
			string strCellText="";
			foreach (DataRow row in dt.Rows)
			{
				CategoryCode = row["CategoryCode"].As<int?>() ;			
				if (itemIndex % 2 == 0)
				{
					strClass = "rd";
				}
				else
				{
					strClass = "rl";
				}
				Response.Write("				\r\n");
				Response.Write("				<tr class=\"");
				Response.Write(strClass);
				Response.Write("\">");
				//URL to display drill down data
				//monetary summary for a Category ID
				//percentage summary for a Category ID
				//strURL = "modules/account/AR/Customer_AR_Drill.aspx";
				categoryMonetaryTotal = 0;
				categoryPercentageTotal = 0;
				//Category Name
				if (blnShowCategoryColumn)
				{
					Response.Write("<td>" + row["Category"].As<String>() + "</td>");			
				}
				if (row["D01_30"].As<double>() != 0)			
				{
					Response.Write("<td align='right'  >");
					if (row["D01_30"].As<double>() > 0.0)			
					{
						strCellText = FormatARNumber(row["D01_30"].As<double>(), 2, row["D01_30_Color"].As<string>()) + "<br>" + Strings.FormatPercent(row["D01_30_Percent"].As<double>(), 1, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault);			
					}
					else
					{
						strCellText = FormatARNumber(row["D01_30"].As<double>(), 2, row["D01_30_Minus_Color"].As<string>()) + "<br>" + Strings.FormatPercent(row["D01_30_Percent"].As<double>(), 1, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault);			
					}
					if (blnDrillable)
					{
						Response.Write("<a href=\"" + this.CreateUrl(strURL, normalizeForAppending:true)+ "CustomerName="+ (Server.UrlEncode(sCustomerName)) + "&DV="+ Server.UrlEncode(AppContext.Current.DivisionCode)+ "&CustomerNumber=" + Server.UrlEncode(sCustomerNo)+ "&CategoryCode="+ CategoryCode+ "&AgePeriodID=1&SystemId="+ (iSystemId).As<string>() + "\">" + strCellText + "</a>");
					}
					else
					{
						Response.Write(strCellText);
					}
					Response.Write("</td>");
					categoryMonetaryTotal = categoryMonetaryTotal + row["D01_30"].As<double>();			
					categoryPercentageTotal = categoryPercentageTotal + row["D01_30_Percent"].As<double>();			
				}
				else
				{
					Response.Write("<td>" + "" + "</td>");
				}
				if (row["D31_60"].As<double>() != 0)			
				{
					Response.Write("<td align='right' >");
					if (row["D31_60"].As<double>() > 0.0)			
					{
						strCellText = FormatARNumber(row["D31_60"].As<double>(), 2, row["D31_60_Color"].As<string>()) + "<br>" + Strings.FormatPercent(row["D31_60_Percent"].As<double>() , 1, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault);			
					}
					else
					{
						/*NOTE: Manual Fiuxp - changed to As<double> and As<string>*/
						strCellText = FormatARNumber(row["D31_60"].As<double>(), 2, row["D31_60_Minus_Color"].As<string>()) + "<br>" + Strings.FormatPercent(row["D31_60_Percent"].As<double>() , 1, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault);			
					}
					if (blnDrillable)
					{
						Response.Write("<a href=\"" + this.CreateUrl(strURL, normalizeForAppending:true)+ "CustomerName=" + (Server.UrlEncode(sCustomerName)) + "&DV=" + Server.UrlEncode(AppContext.Current.DivisionCode) + "&CustomerNumber=" + Server.UrlEncode(sCustomerNo) /*NOTE: Manual Fixup - added Server.UrlEncode*/ + "&CategoryCode=" + CategoryCode + "&AgePeriodID=2&SystemId=" + (iSystemId /*NOTE: Manual Fixup - removed oUD.CustomerDivisionInfo.SystemId*/).As<string>() + "\">" + strCellText + "</a>");
					}
					else
					{
						Response.Write(strCellText);
					}
					Response.Write("</td>");
					categoryMonetaryTotal = categoryMonetaryTotal + row["D31_60"].As<double>();			
					categoryPercentageTotal = categoryPercentageTotal + row["D31_60_Percent"].As<double>();			
				}
				else
				{
					Response.Write("<td>" + "" + "</td>");
				}
				if (row["D61_90"].As<double>() != 0)			
				{
					Response.Write("<td align='right'>");
					if (row["D61_90"].As<double>() > 0.0)			
					{
						strCellText = FormatARNumber(row["D61_90"].As<double>(), 2, row["D61_90_Color"].As<string>()) + "<br>" + Strings.FormatPercent(row["D61_90_Percent"].As<double>()/*NOTE: Manual Fixup - changed to As<double>*/, 1, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault);			
					}
					else
					{
						strCellText = FormatARNumber(row["D61_90"].As<double>(), 2, row["D61_90_Minus_Color"].As<string>()) + "<br>" + Strings.FormatPercent(row["D61_90_Percent"].As<double>()/*NOTE: Manual Fixup - changed to As<double>*/, 1, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault);			
					}
					if (blnDrillable)
					{
						Response.Write("<a href=\"" + this.CreateUrl(strURL, normalizeForAppending:true) + "CustomerName=" + (Server.UrlEncode(sCustomerName)) + "&DV=" + Server.UrlEncode(AppContext.Current.DivisionCode) + "&CustomerNumber=" + Server.UrlEncode(sCustomerNo) /*NOTE: Manual Fixup - added Server.UrlEncode*/ + "&CategoryCode=" + CategoryCode + "&AgePeriodID=4&SystemId=" + (iSystemId /*NOTE: Manual Fixup - removed oUD.CustomerDivisionInfo.SystemId*/).As<string>() + "\">" + strCellText + "</a>");
					}
					else
					{
						Response.Write(strCellText);
					}
					Response.Write("</td>");
					categoryMonetaryTotal = categoryMonetaryTotal + row["D61_90"].As<double>();			
					categoryPercentageTotal = categoryPercentageTotal + row["D61_90_Percent"].As<double>();			
				}
				else
				{
					Response.Write("<td>" + "" + "</td>");
				}
				if (row["D91_120"].As<double>()/*NOTE: Manual Fixup - changed to As<double>*/ != 0)			
				{
					Response.Write("<td align='right'>");
					//strCellText = FormatARNumber(rs("D91_120").Value,2,"red") + "<br>" + FormatPercent(rs("D91_120_Percent"),1)
					if (row["D91_120"].As<double>()/*NOTE: Manual Fixup - changed to As<double>*/ > 0.0)			
					{
						/*NOTE: Manual Fixup - changed to As<double> and As<string>*/
						strCellText = FormatARNumber(row["D91_120"].As<double>(), 2, row["D91_120_Color"].As<string>()) + "<br>" + Strings.FormatPercent(row["D91_120_Percent"].As<double>() , 1, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault);			
					}
					else
					{
						/*NOTE: Manual Fixup - changed to As<double> and As<string>*/
						strCellText = FormatARNumber(row["D91_120"].As<double>(), 2, row["D91_120_Minus_Color"].As<string>()) + "<br>" + Strings.FormatPercent(row["D91_120_Percent"].As<double>(), 1, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault);			
					}
					if (blnDrillable)
					{
						Response.Write("<a href=\"" + this.CreateUrl(strURL, normalizeForAppending:true) + "CustomerName=" + (Server.UrlEncode(sCustomerName)) + "&DV=" + Server.UrlEncode(AppContext.Current.DivisionCode) + "&CustomerNumber=" + Server.UrlEncode(sCustomerNo) + "&CategoryCode=" + CategoryCode + "&AgePeriodID=8&SystemId=" + (iSystemId).As<string>() + "\">" + strCellText + "</a>");
					}
					else
					{
						Response.Write(strCellText);
					}
					Response.Write("</td>");
					categoryMonetaryTotal = categoryMonetaryTotal + row["D91_120"].As<double>();			
					categoryPercentageTotal = categoryPercentageTotal + row["D91_120_Percent"].As<double>();			
				}
				else
				{
					Response.Write("<td>" + "" + "</td>");
				}
				if (row["Over120"].As<double>()/*NOTE: Manual Fixup - changed to As<double>*/ != 0)			
				{
					Response.Write("<td align='right' style='color: red;'>");
					if (row["Over120"].As<double>()/*NOTE: Manual Fixup - changed to As<double>*/ > 0.0)			
					{
						/*NOTE: Manual Fixup - changed to As<double> and As<string>*/
						strCellText = FormatARNumber(row["Over120"].As<double>(), 2, row["Over120_Color"].As<string>()) + "<br>" + Strings.FormatPercent(row["Over120_Percent"].As<double>() /*NOTE: Manual Fixup - changed to As<double>*/, 1, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault);			
					}
					else
					{
						/*NOTE: Manual Fixup - changed to As<double> and As<string>*/
						strCellText = FormatARNumber(row["Over120"].As<double>(), 2, row["Over120_Minus_Color"].As<string>()) + "<br>" + Strings.FormatPercent(row["Over120_Percent"].As<double>() /*NOTE: Manual Fixup - changed to As<double>*/, 1, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault);			
					}
					if (blnDrillable)
					{
						Response.Write("<a href=\"" + this.CreateUrl(strURL, normalizeForAppending:true) + "CustomerName=" + (Server.UrlEncode(sCustomerName)) + "&DV=" + Server.UrlEncode(AppContext.Current.DivisionCode) + "&CustomerNumber=" + Server.UrlEncode(sCustomerNo) /*NOTE: Manual Fixup - added Server.UrlEncode*/+ "&CategoryCode=" + CategoryCode + "&AgePeriodID=16&SystemId=" + (iSystemId /*NOTE: Manual Fixup - removed oUD.CustomerDivisionInfo.SystemId*/).As<string>() + "\">" + strCellText + "</a>");
					}
					else
					{
						Response.Write(strCellText);
					}
					Response.Write("</td>");
					categoryMonetaryTotal = categoryMonetaryTotal + row["Over120"].As<double>();			
					categoryPercentageTotal = categoryPercentageTotal + row["Over120_Percent"].As<double>();			
				}
				else
				{
					Response.Write("<td>" + "" + "</td>");
				}
				if (categoryMonetaryTotal != 0)
				{
					Response.Write("<td align='right' style='font-weight:bold;'>");
					strCellText = FormatARNumber(categoryMonetaryTotal, 2, "black") + "<br>" + Strings.FormatPercent(categoryPercentageTotal, 1, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault);
					if (blnDrillable)
					{
						Response.Write("<a href=\"" + this.CreateUrl(strURL, normalizeForAppending:true) + "CustomerName=" + (Server.UrlEncode(sCustomerName)) + "&DV=" + Server.UrlEncode(AppContext.Current.DivisionCode) + "&CustomerNumber=" + Server.UrlEncode(sCustomerNo) /*NOTE: Manual Fixup - added Server.UrlEncode*/ + "&CategoryCode=" + CategoryCode/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ + "&AgePeriodID=31&SystemId=" + (iSystemId /*NOTE: Manual Fixup - removed oUD.CustomerDivisionInfo.SystemId*/).As<string>() + "\">" + strCellText + "</a>");
					}
					else
					{
						Response.Write(strCellText);
					}
					Response.Write("</td>");
				}
				else
				{
					Response.Write("<td>" + "" + "</td>");
				}
				Response.Write("			            			             			    \r\n");
				Response.Write("				</tr>\r\n");
				TotalRange0_30 = TotalRange0_30 + row["D01_30"].As<double>();			
				TotalRange31_60 = TotalRange31_60 + row["D31_60"].As<double>();			
				TotalRange61_90 = TotalRange61_90 + row["D61_90"].As<double>();			
				TotalRange91_120 = TotalRange91_120 + row["D91_120"].As<double>();			
				TotalRange_Over120 = TotalRange_Over120 + row["Over120"].As<double>();			
				Total_AllRanges = Total_AllRanges + row["D01_30"].As<double>() + row["D31_60"].As<double>() + row["D61_90"].As<double>() + row["D91_120"].As<double>() + row["Over120"].As<double>();			
				//rs.MoveNext();  //<CODE_TAG_103506> Dav
				itemIndex = itemIndex + 1;
			}
			//Total Row
			if (itemIndex > 1)
			{
				Response.Write("						\r\n");
				Response.Write("			    <tr class=\"thc\">\r\n");
				Response.Write("				    <td id='rshl' style=\"border-right: white 1px solid\">Totals</td>");
				//<!-- Zhi 2007-09-21 -->
				if (TotalRange0_30 != 0.0 && Total_AllRanges != 0.0)
				{
					//Zhi 2007-12-31
					Response.Write("<td id='rshr' align='right' style='font-weight:bold; font-size:8pt; border-right: white 1px solid'>");
					//Zhi 2007-09-21
					strCellText = FormatARNumber(TotalRange0_30, 2, "black") + "<br>" + Strings.FormatPercent(TotalRange0_30 / Total_AllRanges, 1, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault);
					if (blnDrillable)
					{
						Response.Write("<a href=\"" + this.CreateUrl(strURL, normalizeForAppending:true) + "DV=" + Server.UrlEncode(AppContext.Current.DivisionCode) + "&CustomerNumber=" + Server.UrlEncode(sCustomerNo) /*NOTE: Manual Fixup - added Server.UrlEncode*/ + "&CategoryCode=-1" + "&AgePeriodID=1&SystemId=" + (iSystemId /*NOTE: Manual Fixup - removed oUD.CustomerDivisionInfo.SystemId*/).As<string>() /*NOTE: Manual Fixup - added As<string>*/ + "\">" + strCellText + "</a>");
					}
					else
					{
						Response.Write(strCellText);
					}
					Response.Write("</td>");
				}
				else
				{
					Response.Write("<td id='rshr'>" + "" + "</td>");
					//Zhi 2007-09-21
				}
				if (TotalRange31_60 != 0.0 && Total_AllRanges != 0.0)
				{
					//Zhi 2007-12-31
					Response.Write("<td id='rshr' align='right' style='font-weight:bold; font-size:8pt; border-right: white 1px solid'>");
					//Zhi 2007-09-21
					strCellText = FormatARNumber(TotalRange31_60, 2, "black") + "<br>" + Strings.FormatPercent(TotalRange31_60 / Total_AllRanges, 1, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault);
					if (blnDrillable)
					{
						Response.Write("<a href=\"" + this.CreateUrl(strURL, normalizeForAppending:true) + "DV=" + Server.UrlEncode(AppContext.Current.DivisionCode) + "&CustomerNumber=" + Server.UrlEncode(sCustomerNo) /*NOTE: Manual Fixup - changed to Server.UrlEncode*/ + "&CategoryCode=-1" + "&AgePeriodID=2&SystemId=" + (iSystemId /*NOTE: Manual Fixup - removed oUD.CustomerDivisionInfo.SystemId*/).As<string>() /*NOTE: Manual Fixup - added As<string>*/ + "\">" + strCellText + "</a>");
					}
					else
					{
						Response.Write(strCellText);
					}
					Response.Write("</td>");
				}
				else
				{
					Response.Write("<td id='rshr'>" + "" + "</td>");
					//Zhi 2007-09-21
				}
				if (TotalRange61_90 != 0.0 && Total_AllRanges != 0.0)
				{
					//Zhi 2007-12-31
					Response.Write("<td id='rshr' align='right' style='font-weight:bold; font-size:8pt; border-right: white 1px solid'>");
					//Zhi 2007-09-21
					strCellText = FormatARNumber(TotalRange61_90, 2, "black") + "<br>" + Strings.FormatPercent(TotalRange61_90 / Total_AllRanges, 1, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault);
					if (blnDrillable)
					{
						Response.Write("<a href=\"" + this.CreateUrl(strURL, normalizeForAppending:true) + "DV=" + Server.UrlEncode(AppContext.Current.DivisionCode) + "&CustomerNumber=" + Server.UrlEncode(sCustomerNo) /*NOTE: Manual Fixup - changed to Server.UrlEncode*/ + "&CategoryCode=-1" + "&AgePeriodID=4&SystemId=" + (iSystemId /*NOTE: Manual Fixup - removed oUD.CustomerDivisionInfo.SystemId*/).As<string>() /*NOTE: Manual Fixup - added As<string>*/ + "\">" + strCellText + "</a>");
					}
					else
					{
						Response.Write(strCellText);
					}
					Response.Write("</td>");
				}
				else
				{
					Response.Write("<td id='rshr'>" + "" + "</td>");
					//Zhi 2007-09-21
				}
				if (TotalRange91_120 != 0.0 && Total_AllRanges != 0.0)
				{
					//Zhi 2007-12-31
					Response.Write("<td id='rshr' align='right' style='font-weight:bold; font-size:8pt; border-right: white 1px solid'>");
					//Zhi 2007-09-21
					strCellText = FormatARNumber(TotalRange91_120, 2, "black") + "<br>" + Strings.FormatPercent(TotalRange91_120 / Total_AllRanges, 1, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault);
					if (blnDrillable)
					{
						Response.Write("<a href=\"" + this.CreateUrl(strURL, normalizeForAppending:true) + "DV=" + Server.UrlEncode(AppContext.Current.DivisionCode) + "&CustomerNumber=" + Server.UrlEncode(sCustomerNo) /*NOTE: Manual Fixup - added to Server.UrlEncode*/ + "&CategoryCode=-1" + "&AgePeriodID=8&SystemId=" + (iSystemId /*NOTE: Manual Fixup - removed oUD.CustomerDivisionInfo.SystemId*/).As<string>() /*NOTE: Manual Fixup - added As<string>*/ + "\">" + strCellText + "</a>");
					}
					else
					{
						Response.Write(strCellText);
					}
					Response.Write("</td>");
				}
				else
				{
					Response.Write("<td id='rshr'>" + "" + "</td>");
					//Zhi 2007-09-21
				}
				if (TotalRange_Over120 != 0.0 && Total_AllRanges != 0.0)
				{
					//Zhi 2007-12-31
					Response.Write("<td id='rshr' align='right' style='font-weight:bold; font-size:8pt'>");
					//Zhi 2007-09-21
					strCellText = FormatARNumber(TotalRange_Over120, 2, "black") + "<br>" + Strings.FormatPercent(TotalRange_Over120 / Total_AllRanges, 1, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault);
					if (blnDrillable)
					{
						Response.Write("<a href=\"" + this.CreateUrl(strURL, normalizeForAppending:true) + "DV=" + Server.UrlEncode(AppContext.Current.DivisionCode) + "&CustomerNumber=" + Server.UrlEncode(sCustomerNo) /*NOTE: Manual Fixup - changed to Server.UrlEncode*/ + "&CategoryCode=-1" + "&AgePeriodID=16&SystemId=" + (iSystemId /*NOTE: Manual Fixup - removed oUD.CustomerDivisionInfo.SystemId*/).As<string>() /*NOTE: Manual Fixup - added As<string>*/ + "\">" + strCellText + "</a>");
					}
					else
					{
						Response.Write(strCellText);
					}
					Response.Write("</td>");
				}
				else
				{
					Response.Write("<td id='rshr'>" + "" + "</td>");
				}
				if (Total_AllRanges != 0.0 && Total_AllRanges != 0.0)
				{
					Response.Write("<td id='rshr' align='right' style='font-weight:bold; font-size:8pt; border-left: white 1px solid'>");
					strCellText = FormatARNumber(Total_AllRanges, 2, "black");
					if (blnDrillable)
					{
						Response.Write("<a href=\"" + this.CreateUrl(strURL, normalizeForAppending:true) + "DV=" + Server.UrlEncode(AppContext.Current.DivisionCode) + "&CustomerNumber=" + Server.UrlEncode(sCustomerNo) /*NOTE: Manual Fixup - added Server.UrlEncode*/ + "&CategoryCode=-1" + "&AgePeriodID=31&SystemId=" + (iSystemId/*NOTE: Manual Fixup - removed oUD.CustomerDivisionInfo.SystemId*/).As<string>() /*NOTE: Manual Fixup - added As<string>*/ + "\">" + strCellText + "</a>");
					}
					else
					{
						Response.Write(strCellText);
					}
					Response.Write("</td>");
				}
				else
				{
					Response.Write("<td id='rshr'>" + "" + "</td>");
					//Zhi 2007-09-21
				}
				Response.Write("		        								\r\n");
				Response.Write("			</tr>");
			}
			////Total Row
		
			//Customer Credit Limit Row
			Response.Write(" \r\n");
			Response.Write("			<tr class=\"thc\">\r\n");
			Response.Write("				<td colspan='6' class=\"tb\" align='left' rowspan =\"3\" style=\"border-top: white 1px solid\">Customer Credit Limit<br /><br />Credit Available</td>\r\n");
			Response.Write("				<td class=\"tb\" align='right' style=\"border-left: white 1px solid; border-top: white 1px solid\" >");
			if (!CreditLimit.IsNullOrWhiteSpace() && CreditLimit != 99999999999)
			{
				Response.Write((Strings.FormatNumber(CreditLimit, 2, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault)));
			}
			else
			{
				if (CreditLimit == 99999999999)
				{
					Response.Write("Unrestricted");
				}
				else
				{
					Response.Write(" ");
				}
			}
			Response.Write("</td>\r\n");
			Response.Write("			</tr>                           \r\n");
			Response.Write("		    <tr class=\"thc\" height=\"1\" >\r\n");
			Response.Write("				<td style=\"padding:0; background: #9D9DA1; color: gray\"></td>\r\n");
			Response.Write("			</tr> \r\n");
			Response.Write("			<tr class=\"thc\">\r\n");
			if ((CreditLimit - Total_AllRanges >= 0.0))
			{
				Response.Write("				<td class=\"tb\" align='right' >");
				if (!CreditLimit.IsNullOrWhiteSpace() && CreditLimit != 99999999999)
				{
					Response.Write((Strings.FormatNumber(CreditLimit - Total_AllRanges, 2, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault)));
				}
				else
				{
					Response.Write(" ");
				}
				Response.Write("</td>\r\n");
			}
			else
			{
				Response.Write("				<td class=\"tb\" align='right'  style=\"color:Red; border-left: white 1px solid;border-top: white 0.5px solid\">");
				if (!CreditLimit.IsNullOrWhiteSpace() && CreditLimit != 99999999999)
				{
					Response.Write(("(" + Strings.FormatNumber(CreditLimit - Total_AllRanges, 2, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault) + ")"));
				}
				else
				{
					Response.Write(" ");
				}
				Response.Write("</td>\r\n");
			}
			Response.Write("			</tr> \r\n");
			Response.Write("		</table>\r\n");
		
			dt = getDataTable(ds, "Data.AR.Cash");
			firstRow = dt.Rows[0];
			if (itemIndex > 0)
			{
				Response.Write("			\r\n");
				Response.Write("		<" + "script>\r\n");
				//<CODE_TAG_100599>
				Response.Write(" \r\n");
				if (blnShowUnappliedCash)
				{
					if (dt.Rows.Count != 0)
					{
						Response.Write(" \r\n");
						Response.Write("				    UC = \"Unapplied Cash: ");
						if(firstRow["Cash"].As<double>() != 0)			
						{
							/*NOTE: Manual Fixup - added .As<double>()*/
							Response.Write((Strings.FormatNumber(firstRow["Cash"].As<double>(), 2, TriState.UseDefault, TriState.UseDefault, TriState.UseDefault)));			
						}
						else
						{
							Response.Write("0.00");
						}
						Response.Write("\"; \r\n");
					}
					else
					{
						Response.Write("				    UC = \"Unapplied Cash: 0.00\";\r\n");
					}
					Response.Write("			    UAC.innerHTML = UC;\r\n");
				}
				Response.Write("		</" + "script>\r\n");
			}
		}
		//</CODE_TAG_103506> Dav
	
		//<CODE_TAG_103506> Dav
		//rs = rs.NextRecordset();
		//dt = getDataTable(ds, "Contact.List");
        dt = getDataTable(ds, "Contact.List.Selected");  //<CODE_TAG_103855>
		//</CODE_TAG_103506> Dav
        Response.Write("     \r\n");
        Response.Write("        </table>\r\n");
        Response.Write("        <br />\r\n");
        Response.Write("        <table class=\"tbl\" width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" style=\"border-top: 1px solid #6f6f6f; border-left: 1px solid #6f6f6f; border-right: 1px solid #6f6f6f; border-bottom :1px solid #6f6f6f; background: #efefef;\">\r\n");
        if(dt == null)  //<CODE_TAG_103506> Dav: //if (rs.EOF)
        {
            Response.Write("                <tr class=\"t11 tSb\"><td>"+(string)GetLocalResourceObject("rkMsg_NoContactFound")+"</td></tr>\r\n");
        }
        else
        {
            Response.Write("                <tr class=\"t11 tSb\">                     \r\n");
            Response.Write("                    <td>"+(string)GetLocalResourceObject("rkHeaderText_Contact")+"</td>\r\n");
            Response.Write("                    <td>"+(string)GetLocalResourceObject("rkHeaderText_Address")+"</td>\r\n");
            Response.Write("                    <td>"+(string)GetLocalResourceObject("rkHeaderText_CityState")+"</td>  \r\n");
            Response.Write("                    <td>"+(string)GetLocalResourceObject("rkHeaderText_Phone")+"</td> \r\n");
            Response.Write("                    <td>"+(string)GetLocalResourceObject("rkHeaderText_Fax")+"</td>\r\n");
            Response.Write("                    <td>"+(string)GetLocalResourceObject("rkHeaderText_Email")+"</td>\r\n");
            Response.Write("                    <td>"+(string)GetLocalResourceObject("rkHeaderText_Division")+"</td>\r\n");
            Response.Write("                    <td id=\"rshl\"></td>\r\n");
            Response.Write("                </tr>\r\n");
            i = 0;
            sInfluencerList = "";
            foreach (DataRow row in dt.Rows)   //<CODE_TAG_103506> Dav: //while(!(rs.EOF))
            {
                Response.Write("                <tr class=\"");
                Response.Write((i % 2 == 0 ?  "rl" :  "rd"));
                Response.Write("\">\r\n");
                Response.Write("                    <td>");
                //Response.Write(Server.HtmlEncode(row["InfluencerName"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                //<CODE_TAG_101969>
                Response.Write(Server.HtmlEncode(row["InfluencerName"].As<string>().Replace("&#44;",",")));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                //</CODE_TAG_101969>
                Response.Write("</td>                        \r\n");
                Response.Write("                    <td>");
                Response.Write(Server.HtmlEncode(row["Address1"].As<string>() + " " + row["Address2"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("</td>\r\n");
                Response.Write("                    <td>");
                Response.Write(Server.HtmlEncode(row["CityState"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("</td>        \r\n");
                Response.Write("                    <td>");
                Response.Write(Server.HtmlEncode(row["Phone"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("</td>        \r\n");
                Response.Write("                    <td>");
                Response.Write(Server.HtmlEncode(row["FaxNo"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("</td>        \r\n");
                Response.Write("                    <td>");
                Response.Write(Server.HtmlEncode(row["Email"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("</td>        \r\n");
                Response.Write("                    <td>");
                Response.Write(Server.HtmlEncode(row["DivisionName"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("</td> \r\n");
                Response.Write("                    <td style=\"width:5%\">\r\n");
                Response.Write("                        <input type=\"radio\" influenceridx='" + i + "' id=\"selInf_radio\" name=\"selInf_radio\" onclick=\"selInfluencer(this, ");
                Response.Write(i);
                Response.Write(");\"/><input type=\"checkbox\" id=\"selInf_checkbox_");
                Response.Write(i);
                Response.Write("\" name=\"selInf_checkbox_");
                Response.Write(i);
                Response.Write("\" style=\"display:none;\"/>                            \r\n");
                Response.Write("                        <input type=\"hidden\" id=\"Inf_InfluencerName_");
                Response.Write(i);
                Response.Write("\" name=\"Inf_InfluencerName_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["InfluencerName"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />                            \r\n");
                Response.Write("                        <input type=\"hidden\" id=\"Inf_Division_");
                Response.Write(i);
                Response.Write("\" name=\"Inf_Division_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["Division"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                        <input type=\"hidden\" id=\"Inf_InfluencerType_");
                Response.Write(i);
                Response.Write("\" name=\"Inf_InfluencerType_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["InfluencerType"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                        <input type=\"hidden\" id=\"Inf_InfluencerId_");
                Response.Write(i);
                Response.Write("\" name=\"Inf_InfluencerId_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["InfluencerId"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                        <input type=\"hidden\" id=\"Inf_Phone_");
                Response.Write(i);
                Response.Write("\" name=\"Inf_Phone_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["Phone"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                        <input type=\"hidden\" id=\"Inf_FaxNo_");
                Response.Write(i);
                Response.Write("\" name=\"Inf_FaxNo_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["FaxNo"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                        <input type=\"hidden\" id=\"Inf_Email_");
                Response.Write(i);
                Response.Write("\" name=\"Inf_Email_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["Email"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                    </td>       \r\n");
                Response.Write("                </tr>");
                i = i + 1;
                //sInfluencerList = sInfluencerList + "," + row["InfluencerName"].As<string>() + "|" + row["Phone"].As<string>() + "|" + row["FaxNo"].As<string>() + "|" + row["Email"].As<string>() + "|" + row["InfluencerType"].As<string>() + "|" + row["InfluencerId"].As<string>() + "|" + row["Division"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                //sInfluencerList = sInfluencerList + "~" + row["InfluencerName"].As<string>() + "|" + row["Phone"].As<string>() + "|" + row["FaxNo"].As<string>() + "|" + row["Email"].As<string>() + "|" + row["InfluencerType"].As<string>() + "|" + row["InfluencerId"].As<string>() + "|" + row["Division"].As<string>();//<CODE_TAG_103327.>			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                //rs.MoveNext();  //<CODE_TAG_103506> Dav
            }
            sInfluencerList = GetInflencerList(ds); //<CODE_TAG_103855>
            if (!sInfluencerList.IsNullOrWhiteSpace()/*DONE:review logic - was '!= ""'*/)
            {
                sInfluencerList = sInfluencerList.Right(sInfluencerList.Length - 1);
            }
            Response.Write("                <tr><td><input type=\"hidden\" id=\"InfluencerList\" name=\"InfluencerList\" value=\"");
            Response.Write(Server.HtmlEncode(sInfluencerList));
            Response.Write("\" /></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>\r\n");
        }
        Response.Write("   \r\n");
        //<CODE_TAG_103506> Dav
		//rs = rs.NextRecordset();
		dt = getDataTable(ds, "Equipment.Count");
		//</CODE_TAG_103506> Dav
        Response.Write("        </table>\r\n");
        Response.Write("        <br />\r\n");
        Response.Write("        <div style=\"border-top: 1px solid #6f6f6f; border-left: 1px solid #6f6f6f; border-right: 1px solid #6f6f6f; border-bottom :1px solid #6f6f6f; background: #efefef;\">\r\n");
        Response.Write("            <table class=\"tbl\" width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" >\r\n");
        Response.Write("                <col width=\"70%\"/>\r\n");
        Response.Write("                <col width=\"20%\"/>\r\n");
        Response.Write("                <col width=\"10%\"/>    \r\n");
        if(dt == null)  //<CODE_TAG_103506> Dav: //if (rs.EOF)
        {
            Response.Write("<tr><td class=\"t11\">"+(string)GetLocalResourceObject("rkMsg_NoEquipmentFound")+"</td></tr>\r\n");
        }
        else
        {
			firstRow = dt.Rows[0];		//<CODE_TAG_103506> Dav
            Response.Write("                    <tr>\r\n");
            //<CODE_TAG_100425>  <CODE_TAG_100447>
            Response.Write("                        <td class=\"f\">\r\n");
            Response.Write("                            <span class=\"");
            Response.Write((curTabName == "CAT" ?  "mhc" :  "back"));
            Response.Write("\" style=\"text-align:center; width: 120px; text-decoration: none; cursor:pointer; border: 1px outset;\" onclick=\"selEquipmentTab('CAT');\" id=\"equipmentTab_CAT\" name=\"equipmentTab_CAT\">\r\n");
            Response.Write((string)GetLocalResourceObject("rkHeaderText_CATEquipment")+"(<b>");
            Response.Write(CType.ToInt32(firstRow["CATEquipmentQty"].As<int?>(), 0));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
            Response.Write("</b> )</span>\r\n");
            Response.Write("                            <span class=\"");
            Response.Write((curTabName == (string)GetLocalResourceObject("rkHeaderText_Other") ?  "mhc" :  "back"));
            Response.Write("\" style=\"text-align:center; width: 130px; text-decoration: none; cursor:pointer; border: 1px outset;\" onclick=\"selEquipmentTab('Other');\" id=\"equipmentTab_Other\" name=\"equipmentTab_Other\">\r\n");
            Response.Write((string)GetLocalResourceObject("rkHeaderText_OtherEquipment") + "(<b>");
            Response.Write(CType.ToInt32(firstRow["OtherEquipmentQty"].As<int?>(), 0));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
            Response.Write("</b>)</span>\r\n");
            Response.Write("                            <span class=\"");
            Response.Write((curTabName == (string)GetLocalResourceObject("rkHeaderText_All") ?  "mhc" :  "back"));
            Response.Write("\" style=\"text-align:center; width: 120px; text-decoration: none; cursor:pointer; border: 1px outset;\" onclick=\"selEquipmentTab('All');\" id=\"equipmentTab_All\" name=\"equipmentTab_All\">\r\n");
            Response.Write((string)GetLocalResourceObject("rkHeaderText_AllEquipment")+"(<b>");
            Response.Write(CType.ToInt32(firstRow["AllEquipmentQty"].As<int?>(), 0));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
            Response.Write("</b>)</span>\r\n");
            Response.Write("                        </td>\r\n");
            Response.Write("                        <td class=\"f\">\r\n");
            Response.Write("                            <span class=\"");
            Response.Write((curTabName == (string)GetLocalResourceObject("rkHeaderText_Rental") ?  "mhc" :  "back"));
            Response.Write("\" style=\"text-align:center; width: 100px; text-decoration: none; cursor:pointer; border: 1px outset;\" onclick=\"selEquipmentTab('Rental');\" id=\"equipmentTab_Rental\" name=\"equipmentTab_Rental\">\r\n");
            Response.Write((string)GetLocalResourceObject("rkHeaderText_Rental2")+" (");
            Response.Write(CType.ToInt32(firstRow["RentalEquipmentQty"].As<int?>(), 0));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
            Response.Write(")</span>\r\n");
            Response.Write("                        </td>\r\n");
            //</CODE_TAG_100425>   </CODE_TAG_100447>
            Response.Write("                        <td class=\"f\" align=\"right\"></td>\r\n");
            Response.Write("                </tr>    \r\n");
        }
        //<CODE_TAG_103506> Dav
		//rs = rs.NextRecordset();
		dt = getDataTable(ds, "CAT.Equipment");
		//</CODE_TAG_103506> Dav
        Response.Write("            </table>\r\n");
        i = 0;
        //CAT Equipment
        //<CODE_TAG_100425>
        Response.Write("            <table id=\"tblCATEQ\" class=\"tbl\" width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" style=\"display: ");
        if (curTabName != "CAT")
        {
            Response.Write("none");
        }
        Response.Write(";\">\r\n");
        if(dt == null)  //<CODE_TAG_103506> Dav: //if (rs.EOF)
        {
            Response.Write("                    <tr><td class=\"t11\">"+(string)GetLocalResourceObject("rkMsg_NoEquipmentFound2")+"</td></tr>\r\n");
        }
        else
        {
            Response.Write("                    <tr>");
            //<CODE_TAG_100425>
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_Model"), 0, "DisplayModel", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_CEquiv"), 0, "CompatibilityCode", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_SerialNum"), 0, "SerialNumber", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_FPC"), 0, "FamilyProductCode", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_ServiceMeter"), 0, "ServiceMeter", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_EQNo"), 0, "EquipmentNumber", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_Industry"), 0, "IndustryCode", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_MfrYear"), 0, "YearOfManuf", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_PurchDate"), 0, "PurchaseDate", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_StockNo"), 0, "IdNumber", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_VIN"), 0, "VINNumber", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)"Cab Type", 0, "CabTypeCode", strSortField, strSortDirection, curTabName));//  Ticket 17730  
            //</CODE_TAG_100425>
            Response.Write("	                    <td id=\"rshl\"></td>\r\n");
            Response.Write("	                    <td id=\"rshl\"></td>\r\n");
            Response.Write("	                    <td id=\"rshl\"></td>\r\n");
            Response.Write("	                    <td id=\"rshl\"></td>\r\n");
            Response.Write("	                    <td id=\"rshl\"></td>\r\n");
            Response.Write("                    </tr>");
            foreach (DataRow row in dt.Rows)   //<CODE_TAG_103506> Dav: //while(!(rs.EOF))
            {
                EquipManufCode = row["EquipManufCode"].As<string>()/*DONE:review data type conversion - convert to proper type*/;			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                EquipManufDesc = row["EquipManufDesc"].As<string>("")/*DONE:review data type conversion - convert to proper type*/;			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                SerialNumber = row["SerialNumber"].As<string>()/*DONE:review data type conversion - convert to proper type*/;			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                EquipmentNumber = row["EquipmentNumber"].As<string>()/*DONE:review data type conversion - convert to proper type*/;			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                IdNumber = row["IdNumber"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                ModelNumber = row["ModelNumber"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                YearOfManuf = row["YearOfManuf"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                PurchaseDate = row["PurchaseDate"].As<DateTime?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
				//<CODE_TAG_103506> Dav
                //if (!PurchaseDate.IsNullOrWhiteSpace()/*DONE:review logic - was '!= ""'*/)
                //{
                //    /*NOTE: Manual Fixup - replaced new DateTime(DateAndTime.DatePart("yyyy", PurchaseDate, Microsoft.VisualBasic.FirstDayOfWeek.Sunday, (Microsoft.VisualBasic.FirstWeekOfYear)1), DateAndTime.DatePart("m", PurchaseDate, Microsoft.VisualBasic.FirstDayOfWeek.Sunday, (Microsoft.VisualBasic.FirstWeekOfYear)1), DateAndTime.DatePart("d", PurchaseDate, Microsoft.VisualBasic.FirstDayOfWeek.Sunday, (Microsoft.VisualBasic.FirstWeekOfYear)1))*/
                //    PurchaseDate = new DateTime(PurchaseDate.Year, PurchaseDate.Month, PurchaseDate.Day);
                //}
				//</CODE_TAG_103506> Dav
                Division = (row["Division"].As<string>()).ToUpper();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Description = row["Description"].As<String>()/*DONE:review data type conversion - convert to proper type*/;			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                DisplayModel = row["DisplayModel"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                CompatibilityCode = row["CompatibilityCode"].As<string>()/*DONE:review data type conversion - convert to proper type*/;			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                IndustryCode = row["IndustryCode"].As<string>()/*DONE:review data type conversion - convert to proper type*/;			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                FamilyProductCode = row["FamilyProductCode"].As<string>()/*DONE:review data type conversion - convert to proper type*/;			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                IndustryGroup = row["IndustryGroup"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                ServiceMeter = row["ServiceMeter"].As<double?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                ServiceMeterInd = row["ServiceMeterInd"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                sVIN = row["VINNumber"].As<string>()/*DONE:review data type conversion - convert to proper type*/;			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                CurrSystemId = row["SystemId"].As<int?>()/*DONE:review data type conversion - convert to proper type*/;			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                switch (ServiceMeterInd) {
                    case "H":
                        ServiceMeterInd = "Hrs";
                        break;
                    case "M":
                        ServiceMeterInd = "Mi";
                        break;
                    case "K":
                        ServiceMeterInd = "Km";
                        break;
                }
                ServiceMeterDate = row["ServiceMeterDate"].As<DateTime?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                //** 0 - Not Linked, 1 - Linked *********************
                PPMModelId = row["PPMModelId"].As<int?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                PPMSerialNumber = row["PPMSerialNumber"].As<int?>()/*DONE:review data type conversion - convert to proper type*/;			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                PPMFPCId = row["PPMFPCId"].As<int?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                SOSSerialNumber = row["SOSSerialNumber"].As<int?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                WOSerialNumber = row["WOSerialNumber"].As<int?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                sPIP = row["PIP"].As<int?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                sWarrantyCoverage = row["WarrantyCoverage"].As<int?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                sCabTypeCode = row["CABType"].As<string>();//  Ticket 17730  			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property

                Response.Write("                        <tr class=\"");
                Response.Write((i % 2 == 0 ?  "rl" :  "rd"));
                Response.Write("\">");
                //**************PPM Model****************
                if (PPMModelId/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ != 0)
                {
                    Response.Write("<td><span onclick=\"p('");
                    Response.Write(PPMModelId);
                    Response.Write("','");
                    Response.Write(PPMFPCId);
                    Response.Write("','");
                    Response.Write(CurrSystemId);
                    Response.Write("');\" style=\"width: 45px;\" class=\"borng\">");
                    Response.Write(Server.HtmlEncode(DisplayModel/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                    Response.Write("</span></td>\r\n");
                }
                else
                {
                    Response.Write("				                <td>");
                    Response.Write(Server.HtmlEncode(DisplayModel/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                    Response.Write("</td>\r\n");
                }
                Response.Write("                        \r\n");
                Response.Write("                            <td>");
                Response.Write(Server.HtmlEncode(CompatibilityCode/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                Response.Write("</td>");
                //************PPM Serial No***************
                if (PPMSerialNumber != 0)
                {
                    Response.Write("				                <td><span onclick=\"psn('");
                    Response.Write(SerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/);
                    Response.Write("','");
                    Response.Write(CurrSystemId);
                    Response.Write("');\" style=\"width: 65px;\" class=\"bred\"><font color=\"white\">");
                    Response.Write(SerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/);
                    Response.Write("</font></span></td>\r\n");
                }
                else
                {
                    Response.Write("				                <td>");
                    Response.Write(SerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/);
                    Response.Write("</td>\r\n");
                }
                Response.Write("                                                \r\n");
                Response.Write("                            <td>");
                Response.Write(Server.HtmlEncode(FamilyProductCode/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                Response.Write("</td>\r\n");
                Response.Write("                            <td>");
                Response.Write(Server.HtmlEncode(ServiceMeter/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ + " " + ServiceMeterInd + (!(ServiceMeterDate.IsNullOrWhiteSpace()) ?  " on " + Util.DateFormat(ServiceMeterDate) :  "")));
                Response.Write("</td>                        \r\n");
                Response.Write("                            <td>");
                Response.Write(EquipmentNumber/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/);
                Response.Write("</td>\r\n");
                Response.Write("                            <td>");
                Response.Write(Server.HtmlEncode(IndustryCode/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                Response.Write("</td>\r\n");
                Response.Write("                            <td>");
                Response.Write(Server.HtmlEncode(YearOfManuf/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                Response.Write("</td>\r\n");
                Response.Write("                            <td>");
                Response.Write(Server.HtmlEncode(Util.DateFormat(PurchaseDate)));
                Response.Write("</td>\r\n");
                Response.Write("                            <td>");
                Response.Write(Server.HtmlEncode(IdNumber/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                Response.Write("</td>\r\n");
                Response.Write("                            <td>");
                Response.Write(Server.HtmlEncode(sVIN/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                Response.Write("</td>");
                //  Ticket 17730  
                Response.Write("                            <td>");
                Response.Write(Server.HtmlEncode(sCabTypeCode/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                Response.Write("</td>");
                //****************SOS********************
                if (SOSSerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ != 0)
                {
                    Response.Write("				                <td width=\"10\"><span onclick=\"sos('");
                    Response.Write(SerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/);
                    Response.Write("','");
                    Response.Write(CurrSystemId);
                    Response.Write("');\" class=\"blck\">SOS</span></td>\r\n");
                }
                else
                {
                    Response.Write("				                <td></td>\r\n");
                }
                //****************WO History*******************
                if (WOSerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ != 0)
                {
                    Response.Write("				                <td nowrap width=\"10\"><span onclick=\"wo('");
                    Response.Write(SerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/);
                    Response.Write("','");
                    Response.Write(Server.HtmlEncode(EquipManufCode/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                    Response.Write("','");
                    Response.Write(CurrSystemId);
                    Response.Write("');\" class=\"bred\"><font color=#ffffff>WO</font></span></td>\r\n");
                }
                else
                {
                    Response.Write("				                <td></td>\r\n");
                }
                //****************Service Letters********************
                if (sPIP/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ != 0)
                {
                    Response.Write("				                <td nowrap width=\"10\"><span onclick=\" sl('");
                    Response.Write(SerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/);
                    Response.Write("','");
                    Response.Write(Server.HtmlEncode(EquipManufCode/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                    Response.Write("','");
                    Response.Write(CurrSystemId);
                    Response.Write("');\" class=\"navy\"><font color=#ffffff>SL</font></span></td>\r\n");
                }
                else
                {
                    Response.Write("				                <td></td>\r\n");
                }
                //****************Warranty Coverage********************
                if (sWarrantyCoverage/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ != 0)
                {
                    Response.Write("				                <td nowrap width=\"10\"><span onclick=\"WarrantyCoverage('");
                    Response.Write(SerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/);
                    Response.Write("','");
                    Response.Write(Server.HtmlEncode(EquipManufCode/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                    Response.Write("','");
                    Response.Write(CurrSystemId);
                    Response.Write("')\" class=\"green\"><font color=#ffffff>WAR</font></span></td>\r\n");
                }
                else
                {
                    Response.Write("				                <td></td>\r\n");
                }
                //*************** Equipment Configuration ************
                if (!EquipManufCode/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/.IsNullOrWhiteSpace()/*DONE:review logic - was '!= ""'*/ && !SerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/.IsNullOrWhiteSpace())
                {
                    Response.Write("			                    <td nowrap width=\"10\"><span onclick=\"equipConfig('");
                    Response.Write(Server.HtmlEncode(EquipManufCode/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                    Response.Write("','");
                    Response.Write(SerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/);
                    Response.Write("','");
                    Response.Write(CurrSystemId);
                    Response.Write("');\" class=\"maroon\"><font color=#ffffff>CFG</font></span></td>\r\n");
                }
                else
                {
                    Response.Write("			                    <td></td>\r\n");
                }
                Response.Write("    			            \r\n");
                Response.Write("                            <td style=\"width:5%\">\r\n");
                Response.Write("                                <input type=\"radio\" id=\"selEQ_radio\" name=\"selEQ_radio\" onclick=\"selEquipment(this, ");
                Response.Write(i);
                Response.Write(");\"/><input type=\"checkbox\" id=\"selEQ_checkbox_");
                Response.Write(i);
                Response.Write("\" name=\"selEQ_checkbox_");
                Response.Write(i);
                Response.Write("\" style=\"display:none;\"/>                            \r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_Model_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_Model_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(DisplayModel));
                Response.Write("\" />                            \r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_SerialNumber_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_SerialNumber_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(SerialNumber);
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_Division_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_Division_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(Division));
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_EquipManufCode_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_EquipManufCode_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(EquipManufCode));
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_EquipmentNumber_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_EquipmentNumber_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["EquipmentNumber"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_IdNumber_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_IdNumber_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["IdNumber"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_VINNumber_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_VINNumber_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["VINNumber"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");


                Response.Write("                                <input type=\"hidden\" id=\"EQ_ServiceMeter_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_ServiceMeter_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["ServiceMeter"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_ServiceMeterInd_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_ServiceMeterInd_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["ServiceMeterInd"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_ServiceMeterDate_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_ServiceMeterDate_");
                Response.Write(i);
                Response.Write("\" value=\"");
                //Response.Write(Server.HtmlEncode(row["ServiceMeterDate"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write( (!ServiceMeterDate.IsNullOrWhiteSpace()) ?  Util.DateFormat(ServiceMeterDate) :  ""  );
                Response.Write("\" />\r\n");
                //  Ticket 17730  
                Response.Write("                                <input type=\"hidden\" id=\"EQ_CapTypeCode_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_CapTypeCode_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["CABType"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");

                
                Response.Write("                            </td>\r\n");
                Response.Write("                        </tr>");
                i = i + 1;
                //rs.MoveNext();  //<CODE_TAG_103506> Dav
            }
            Response.Write("            \r\n");
        }
        //<CODE_TAG_103506> Dav
		//rs = rs.NextRecordset();
		dt = getDataTable(ds, "Other.Equipment");
		//</CODE_TAG_103506> Dav
        Response.Write("            </table>\r\n");
        //Other Equipment
        Response.Write("            <table id=\"tblOtherEQ\" class=\"tbl\" width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" style=\"display:");
        if (curTabName != "Other")
        {
            Response.Write("none");
        }
        Response.Write(";\">  ");
        //<CODE_TAG_100425>
        
        if(dt == null)  //<CODE_TAG_103506> Dav: //if (rs.EOF)
        {
            Response.Write("<tr><td class=\"t11\">"+(string)GetLocalResourceObject("rkMsg_NoEquipmentFound3")+"</td></tr>\r\n");
        }
        else
        {
            Response.Write("                    <tr>");
            //<CODE_TAG_100425>
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_Mfr2"), 0, "EquipManufDesc", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_Mod2"), 0, "DisplayModel", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_CEquiv2"), 0, "CompatibilityCode", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_SerialNum2"), 0, "SerialNumber", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_FPC2"), 0, "FamilyProductCode", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_ServiceMeter2"), 0, "ServiceMeter", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_EQNo2"), 0, "EquipmentNumber", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_Industry2"), 0, "IndustryCode", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_MfrYear2"), 0, "YearOfManuf", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_PurchDate2"), 0, "PurchaseDate", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_StockNo2"), 0, "IdNumber", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_VIN2"), 0, "VINNumber", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)"Cab Type", 0, "CabTypeCode", strSortField, strSortDirection, curTabName)); //  Ticket 17730  
            //</CODE_TAG_100425>
            Response.Write("   \r\n");
            Response.Write("	                    <td id=\"rshl\"></td>                     \r\n");
            Response.Write("	                    <td id=\"rshl\"></td>                     \r\n");
            Response.Write("	                    <td id=\"rshl\"></td>                     \r\n");
            Response.Write("	                    <td id=\"rshl\"></td>                     \r\n");
            Response.Write("                    </tr>\r\n");
            foreach (DataRow row in dt.Rows)   //<CODE_TAG_103506> Dav: //while(!(rs.EOF))
            {
                Response.Write("                        <tr class=\"");
                Response.Write((i % 2 == 0 ?  "rl" :  "rd"));
                Response.Write("\">");
                EquipManufCode = row["EquipManufCode"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                EquipManufDesc = row["EquipManufDesc"].As<string>("");			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                SerialNumber = row["SerialNumber"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                EquipmentNumber = row["EquipmentNumber"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                IdNumber = row["IdNumber"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                ModelNumber = row["ModelNumber"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                YearOfManuf = row["YearOfManuf"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                PurchaseDate = row["PurchaseDate"].As<DateTime?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                //<CODE_TAG_103506> Dav
				//if (!PurchaseDate.IsNullOrWhiteSpace())
                //{
                //    /*NOTE: Manual Fixup - removed DateTime(DateAndTime.DatePart("yyyy", PurchaseDate, Microsoft.VisualBasic.FirstDayOfWeek.Sunday, (Microsoft.VisualBasic.FirstWeekOfYear)1), DateAndTime.DatePart("m", PurchaseDate, Microsoft.VisualBasic.FirstDayOfWeek.Sunday, (Microsoft.VisualBasic.FirstWeekOfYear)1), DateAndTime.DatePart("d", PurchaseDate, Microsoft.VisualBasic.FirstDayOfWeek.Sunday, (Microsoft.VisualBasic.FirstWeekOfYear)1))*/
                //    PurchaseDate = new DateTime(PurchaseDate.Year, PurchaseDate.Month, PurchaseDate.Day);
                //}
				//</CODE_TAG_103506> Dav
                Division = row["Division"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Description = row["Description"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                DisplayModel = row["DisplayModel"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                CompatibilityCode = row["CompatibilityCode"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                IndustryCode = row["IndustryCode"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                FamilyProductCode = row["FamilyProductCode"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                IndustryGroup = row["IndustryGroup"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                ServiceMeter = row["ServiceMeter"].As<double?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                ServiceMeterInd = row["ServiceMeterInd"].As<String>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                sVIN = row["VINNumber"].As<string>()/*DONE:review data type conversion - convert to proper type*/;			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                sCabTypeCode = row["CABType"].As<string>(); //  Ticket 17730  			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                CurrSystemId = row["SystemId"].As<int?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                switch (ServiceMeterInd) {
                    case "H":
                        ServiceMeterInd = "Hrs";
                        break;
                    case "M":
                        ServiceMeterInd = "Mi";
                        break;
                    case "K":
                        ServiceMeterInd = "Km";
                        break;
                }
                ServiceMeterDate = row["ServiceMeterDate"].As<DateTime?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                //** 0 - Not Linked, 1 - Linked *********************
                PPMModelId = row["PPMModelId"].As<int?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                PPMSerialNumber = row["PPMSerialNumber"].As<int?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                PPMFPCId = row["PPMFPCId"].As<int?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                SOSSerialNumber = row["SOSSerialNumber"].As<int?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                WOSerialNumber = row["WOSerialNumber"].As<int?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("			                <td>");
                //if (!EquipManufDesc/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/.Trim().IsNullOrWhiteSpace())
                if ( !string.IsNullOrEmpty(EquipManufDesc))  // <CODE_TAG_103406>
                {
                    Response.Write((Server.HtmlEncode(EquipManufDesc)));
                }
                Response.Write("</td>");
                //****************PPM Model*******************
                if (PPMModelId != 0)
                {
                    Response.Write("				                <td><span onclick=\"p('");
                    Response.Write(PPMModelId);
                    Response.Write("','");
                    Response.Write(PPMFPCId);
                    Response.Write("','");
                    Response.Write(CurrSystemId);
                    Response.Write("');\" style=\"width: 45px;\" class=\"borng\">");
                    Response.Write(Server.HtmlEncode(DisplayModel));
                    Response.Write("</span></td>\r\n");
                }
                else
                {
                    Response.Write("				                <td>");
                    Response.Write(Server.HtmlEncode(DisplayModel));
                    Response.Write("</td>\r\n");
                }
                Response.Write("			                <td>");
                Response.Write(Server.HtmlEncode(CompatibilityCode));
                Response.Write("</td>");
                //****************PPM Serial No*****************
                if (PPMSerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ != 0)
                {
                    Response.Write("				                <td><span onclick=\"psn('");
                    Response.Write(SerialNumber);
                    Response.Write("','");
                    Response.Write(CurrSystemId);
                    Response.Write("');\" style=\"width: 65px;\" class=\"bred\">");
                    Response.Write(SerialNumber);
                    Response.Write("</span></td>\r\n");
                }
                else
                {
                    Response.Write("				                <td>");
                    Response.Write(SerialNumber);
                    Response.Write("</td>\r\n");
                }
                Response.Write("			                <td>");
                Response.Write(Server.HtmlEncode(FamilyProductCode));
                Response.Write("</td>\r\n");
                Response.Write("			                <td nowrap>");
                Response.Write(Server.HtmlEncode(ServiceMeter + " " + ServiceMeterInd + (!(ServiceMeterDate.IsNullOrWhiteSpace()) ?  " on " + Util.DateFormat(ServiceMeterDate) :  "")));
                Response.Write("</td>\r\n");
                Response.Write("			                <td>");
                Response.Write(EquipmentNumber);
                Response.Write("</td>\r\n");
                Response.Write("			                <td>");
                Response.Write(Server.HtmlEncode(IndustryCode));
                Response.Write("</td>\r\n");
                Response.Write("			                <td>");
                Response.Write(Server.HtmlEncode(YearOfManuf));
                Response.Write("</td>\r\n");
                Response.Write("			                <td>");
                Response.Write(Server.HtmlEncode(Util.DateFormat(PurchaseDate)));
                Response.Write("</td>\r\n");
                Response.Write("			                <td>");
                Response.Write(Server.HtmlEncode(IdNumber));
                Response.Write("</td>\r\n");
                Response.Write("			                <td>");
                Response.Write(Server.HtmlEncode(sVIN));
                Response.Write("</td>");
                //  Ticket 17730  
                Response.Write("			                <td>");
                Response.Write(Server.HtmlEncode(sCabTypeCode));
                Response.Write("</td>");
                //*****************SOS************************
                if (SOSSerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ != 0)
                {
                    Response.Write("			                    <td><span onclick=\"sos('");
                    Response.Write(SerialNumber);
                    Response.Write("','");
                    Response.Write(CurrSystemId);
                    Response.Write("');\" class=\"blck\">SOS</span></td>\r\n");
                }
                else
                {
                    Response.Write("			                    <td></td>\r\n");
                }
                //***************WO History*******************
                if (WOSerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ != 0)
                {
                    Response.Write("			                    <td nowrap><span onclick=\"wo('");
                    Response.Write(SerialNumber);
                    Response.Write("','");
                    Response.Write(Server.HtmlEncode(EquipManufCode));
                    Response.Write("','");
                    Response.Write(CurrSystemId);
                    Response.Write("');\" class=\"bred\"><font color=#ffffff>WO</font></span></td>\r\n");
                }
                else
                {
                    Response.Write("			                    <td></td>\r\n");
                }
                //*************** Equipment Configuration ************
                if (!EquipManufCode/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/.IsNullOrWhiteSpace() && !SerialNumber.IsNullOrWhiteSpace())
                {
                    Response.Write("			                    <td nowrap width=\"10\"><span onclick=\"equipConfig('");
                    Response.Write(Server.HtmlEncode(EquipManufCode));
                    Response.Write("','");
                    Response.Write(SerialNumber);
                    Response.Write("','");
                    Response.Write(CurrSystemId);
                    Response.Write("');\" class=\"maroon\"><font color=#ffffff>CFG</font></span></td>\r\n");
                }
                else
                {
                    Response.Write("			                    <td></td>\r\n");
                }
                Response.Write("			            \r\n");
                Response.Write("                            <td style=\"width:5%\">\r\n");
                Response.Write("                                <input type=\"radio\" id=\"selEQ_radio\" name=\"selEQ_radio\" onclick=\"selEquipment(this, ");
                Response.Write(i);
                Response.Write(");\"/><input type=\"checkbox\" id=\"selEQ_checkbox_");
                Response.Write(i);
                Response.Write("\" name=\"selEQ_checkbox_");
                Response.Write(i);
                Response.Write("\" style=\"display:none;\"/>                            \r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_Model_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_Model_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["DisplayModel"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />                            \r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_SerialNumber_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_SerialNumber_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["SerialNumber"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_Division_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_Division_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["Division"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_EquipManufCode_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_EquipManufCode_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["EquipManufCode"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_EquipmentNumber_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_EquipmentNumber_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["EquipmentNumber"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_IdNumber_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_IdNumber_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["IdNumber"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_VINNumber_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_VINNumber_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["VINNumber"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");



                Response.Write("                                <input type=\"hidden\" id=\"EQ_ServiceMeter_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_ServiceMeter_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["ServiceMeter"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_ServiceMeterInd_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_ServiceMeterInd_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["ServiceMeterInd"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_ServiceMeterDate_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_ServiceMeterDate_");
                Response.Write(i);
                Response.Write("\" value=\"");
                //Response.Write(Server.HtmlEncode(row["ServiceMeterDate"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write( (!ServiceMeterDate.IsNullOrWhiteSpace()) ?  Util.DateFormat(ServiceMeterDate) :  ""  );
                Response.Write("\" />\r\n");
                //  Ticket 17730  
                Response.Write("                                <input type=\"hidden\" id=\"EQ_CabTypeCode_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_CabTypeCode_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["CABType"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                            </td>\r\n");
                Response.Write("                        </tr>");
                i = i + 1;
                //rs.MoveNext();  //<CODE_TAG_103506> Dav
            }
            Response.Write("            \r\n");
        }
        //<CODE_TAG_103506> Dav
		//rs = rs.NextRecordset();
		dt = getDataTable(ds, "All.Equipment");
		//</CODE_TAG_103506> Dav
        Response.Write("            </table>\r\n");
        //All Equipment
        //<CODE_TAG_100425>
        Response.Write("<table id=\"tblAllEQ\" class=\"tbl\" width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" style=\"display:");
        if (curTabName != "All")
        {
            Response.Write("none");
        }
        Response.Write(";\">\r\n");
        if(dt == null)  //<CODE_TAG_103506> Dav: //if (rs.EOF)
        {
            Response.Write("                    <tr><td class=\"t11\">"+(string)GetLocalResourceObject("rkMsg_NoEquipmentFound4")+"</td></tr>\r\n");
        }
        else
        {
            Response.Write("                    <tr>");
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_Mfr3"), 0, "EquipManufDesc", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_Mod3"), 0, "DisplayModel", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_CEquiv3"), 0, "CompatibilityCode", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_SerialNum3"), 0, "SerialNumber", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_FPC3"), 0, "FamilyProductCode", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_ServiceMeter3"), 0, "ServiceMeter", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_EQNo3"), 0, "EquipmentNumber", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_Industry3"), 0, "IndustryCode", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_MfrYear3"), 0, "YearOfManuf", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_PurchDte3"), 0, "PurchaseDate", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_StockNo3"), 0, "IdNumber", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_VIN3"), 0, "VINNumber", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)"Cab Type", 0, "CabTypeCode", strSortField, strSortDirection, curTabName)); //  Ticket 17730  
            Response.Write("     \r\n");
            Response.Write("	                    <td id=\"rshl\"></td>                   \r\n");
            Response.Write("	                    <td id=\"rshl\"></td>                   \r\n");
            Response.Write("	                    <td id=\"rshl\"></td>                   \r\n");
            Response.Write("	                    <td id=\"rshl\"></td>                   \r\n");
            Response.Write("	                    <td id=\"rshl\"></td>                   \r\n");
            Response.Write("                    </tr>\r\n");
            //<CODE_TAG_100425>
            foreach (DataRow row in dt.Rows)   //<CODE_TAG_103506> Dav: //while(!(rs.EOF))
            {
                Response.Write("                        <tr class=\"");
                Response.Write((i % 2 == 0 ?  "rl" :  "rd"));
                Response.Write("\">");
                EquipManufCode = row["EquipManufCode"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                EquipManufDesc = row["EquipManufDesc"].As<string>("");			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                SerialNumber = row["SerialNumber"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                EquipmentNumber = row["EquipmentNumber"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                IdNumber = row["IdNumber"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                ModelNumber = row["ModelNumber"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                YearOfManuf = row["YearOfManuf"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                PurchaseDate = row["PurchaseDate"].As<DateTime?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                //<CODE_TAG_103506> Dav
				//if (!PurchaseDate.IsNullOrWhiteSpace()/*DONE:review logic - was '!= ""'*/)
                //{
                //    /*NOTE: Manual Fixup - removed PurchaseDate = new DateTime(DateAndTime.DatePart("yyyy", PurchaseDate, Microsoft.VisualBasic.FirstDayOfWeek.Sunday, (Microsoft.VisualBasic.FirstWeekOfYear)1), DateAndTime.DatePart("m", PurchaseDate, Microsoft.VisualBasic.FirstDayOfWeek.Sunday, (Microsoft.VisualBasic.FirstWeekOfYear)1), DateAndTime.DatePart("d", PurchaseDate, Microsoft.VisualBasic.FirstDayOfWeek.Sunday, (Microsoft.VisualBasic.FirstWeekOfYear)1))*/
                //    PurchaseDate = new DateTime(PurchaseDate.Year, PurchaseDate.Month, PurchaseDate.Day);
                //}
				//</CODE_TAG_103506> Dav
                Division = row["Division"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Description = row["Description"].As<string>()/*DONE:review data type conversion - convert to proper type*/;			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                DisplayModel = row["DisplayModel"].As<string>()/*DONE:review data type conversion - convert to proper type*/;			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                CompatibilityCode = row["CompatibilityCode"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                IndustryCode = row["IndustryCode"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                FamilyProductCode = row["FamilyProductCode"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                IndustryGroup = row["IndustryGroup"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                ServiceMeter = row["ServiceMeter"].As<double?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                ServiceMeterInd = row["ServiceMeterInd"].As<String>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                sVIN = row["VINNumber"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                sCabTypeCode = row["CABType"].As<string>(); //  Ticket 17730  			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                CurrSystemId = row["SystemId"].As<int?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                switch (ServiceMeterInd) {
                    case "H":
                        ServiceMeterInd = "Hrs";
                        break;
                    case "M":
                        ServiceMeterInd = "Mi";
                        break;
                    case "K":
                        ServiceMeterInd = "Km";
                        break;
                }
                ServiceMeterDate = row["ServiceMeterDate"].As<DateTime?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                //** 0 - Not Linked, 1 - Linked *********************
                PPMModelId = row["PPMModelId"].As<int?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                PPMSerialNumber = row["PPMSerialNumber"].As<int?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                PPMFPCId = row["PPMFPCId"].As<int?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                SOSSerialNumber = row["SOSSerialNumber"].As<int?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                WOSerialNumber = row["WOSerialNumber"].As<int?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                sPIP = row["PIP"].As<int?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                sWarrantyCoverage = row["WarrantyCoverage"].As<int?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("			                <td>");
                Response.Write(Server.HtmlEncode(EquipManufDesc/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/.Left(4)));
                Response.Write("</td>");
                //****************PPM Model*******************
                if (PPMModelId/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ != 0)
                {
                    Response.Write("<td><span onclick=\"p('");
                    Response.Write(PPMModelId);
                    Response.Write("','");
                    Response.Write(PPMFPCId);
                    Response.Write("','");
                    Response.Write(CurrSystemId);
                    Response.Write("');\" style=\"width: 45px;\" class=\"borng\">");
                    Response.Write(Server.HtmlEncode(DisplayModel/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                    Response.Write("</span></td>\r\n");
                }
                else
                {
                    Response.Write("				                <td>");
                    Response.Write(Server.HtmlEncode(DisplayModel/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                    Response.Write("</td>\r\n");
                }
                Response.Write("            			\r\n");
                Response.Write("			                <td>");
                Response.Write(Server.HtmlEncode(CompatibilityCode/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                Response.Write("</td>");
                //****************PPM Serial No*****************
                if (PPMSerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ != 0)
                {
                    Response.Write("				                <td><span onclick=\"psn('");
                    Response.Write(SerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/);
                    Response.Write("','");
                    Response.Write(CurrSystemId);
                    Response.Write("');\" style=\"width: 65px;\" class=\"bred\">");
                    Response.Write(SerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/);
                    Response.Write("</span></td>\r\n");
                }
                else
                {
                    Response.Write("				                <td>");
                    Response.Write(SerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/);
                    Response.Write("</td>\r\n");
                }
                Response.Write("            			\r\n");
                Response.Write("			                <td>");
                Response.Write(Server.HtmlEncode(FamilyProductCode/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                Response.Write("</td>\r\n");
                Response.Write("			                <td nowrap>");
                Response.Write(Server.HtmlEncode(ServiceMeter/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ + " " + ServiceMeterInd + (!(ServiceMeterDate.IsNullOrWhiteSpace()) ?  (string)GetLocalResourceObject("rkHeaderText_On") + Util.DateFormat(ServiceMeterDate) :  "")));
                Response.Write("</td>            						            \r\n");
                Response.Write("			                <td>");
                Response.Write(EquipmentNumber/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/);
                Response.Write("</td>\r\n");
                Response.Write("			                <td>");
                Response.Write(Server.HtmlEncode(IndustryCode/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                Response.Write("</td>\r\n");
                Response.Write("			                <td>");
                Response.Write(Server.HtmlEncode(YearOfManuf/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                Response.Write("</td>\r\n");
                Response.Write("			                <td>");
                Response.Write(Server.HtmlEncode(Util.DateFormat(PurchaseDate)));
                Response.Write("</td>\r\n");
                Response.Write("			                <td>");
                Response.Write(Server.HtmlEncode(IdNumber/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                Response.Write("</td>\r\n");
                Response.Write("			                <td>");
                Response.Write(Server.HtmlEncode(sVIN/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                Response.Write("</td>");
                //  Ticket 17730  
                Response.Write("			                <td>");
                Response.Write(Server.HtmlEncode(sCabTypeCode));
                Response.Write("</td>");
                //*****************SOS************************
                if (SOSSerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ != 0)
                {
                    Response.Write("				                <td><span onclick=\"sos('");
                    Response.Write(SerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/);
                    Response.Write("','");
                    Response.Write(CurrSystemId);
                    Response.Write("');\" class=\"blck\">SOS</span></td>\r\n");
                }
                else
                {
                    Response.Write("				                <td></td>\r\n");
                }
                //***************WO History*******************
                if (WOSerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ != 0)
                {
                    Response.Write("				                <td nowrap><span onclick=\"wo('");
                    Response.Write(SerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/);
                    Response.Write("','");
                    Response.Write(Server.HtmlEncode(EquipManufCode/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                    Response.Write("','");
                    Response.Write(CurrSystemId);
                    Response.Write("');\" class=\"bred\"><font color=#ffffff>WO</font></span></td>\r\n");
                }
                else
                {
                    Response.Write("				                <td></td>\r\n");
                }
                //****************Service Letters********************
                if (sPIP/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ != 0)
                {
                    Response.Write("				                <td nowrap width=\"10\"><span onclick=\"sl('");
                    Response.Write(SerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/);
                    Response.Write("','");
                    Response.Write(Server.HtmlEncode(EquipManufCode/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                    Response.Write("','");
                    Response.Write(CurrSystemId);
                    Response.Write("');\" class=\"navy\"><font color=#ffffff>SL</font></span></td>\r\n");
                }
                else
                {
                    Response.Write("				                <td></td>\r\n");
                }
                //****************Warranty Coverage********************
                if (sWarrantyCoverage/*DONE:review if type conversion if necessary - was 'Convert.ToInt32'*/ != 0)
                {
                    Response.Write("				                <td nowrap width=\"10\"><span onclick=\"WarrantyCoverage('");
                    Response.Write(SerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/);
                    Response.Write("','");
                    Response.Write(Server.HtmlEncode(EquipManufCode/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                    Response.Write("','");
                    Response.Write(CurrSystemId);
                    Response.Write("');\" class=\"green\"><font color=#ffffff>WAR</font></span></td>\r\n");
                }
                else
                {
                    Response.Write("				                <td></td>\r\n");
                }
                //*************** Equipment Configuration ************
                if (!EquipManufCode/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/.IsNullOrWhiteSpace()/*DONE:review logic - was '!= ""'*/ && !SerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/.IsNullOrWhiteSpace()/*DONE:review logic - was '!= ""'*/)
                {
                    Response.Write("				                <td nowrap width=\"10\"><span onclick=\"equipConfig('");
                    Response.Write(Server.HtmlEncode(EquipManufCode/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/));
                    Response.Write("','");
                    Response.Write(SerialNumber/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/);
                    Response.Write("','");
                    Response.Write(CurrSystemId);
                    Response.Write("');\" class=\"maroon\"><font color=#ffffff>CFG</font></span></td>\r\n");
                }
                else
                {
                    Response.Write("				                <td></td>\r\n");
                }
                Response.Write("                            <td style=\"width:5%\">\r\n");
                Response.Write("                                <input type=\"radio\" id=\"selEQ_radio\" name=\"selEQ_radio\" onclick=\"selEquipment(this, ");
                Response.Write(i);
                Response.Write(");\"/><input type=\"checkbox\" id=\"selEQ_checkbox_");
                Response.Write(i);
                Response.Write("\" name=\"selEQ_checkbox_");
                Response.Write(i);
                Response.Write("\" style=\"display:none;\"/>                            \r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_Model_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_Model_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["DisplayModel"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />                            \r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_SerialNumber_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_SerialNumber_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["SerialNumber"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_Division_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_Division_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["Division"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_EquipManufCode_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_EquipManufCode_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["EquipManufCode"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_EquipmentNumber_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_EquipmentNumber_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["EquipmentNumber"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_IdNumber_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_IdNumber_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["IdNumber"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_VINNumber_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_VINNumber_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["VINNumber"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");



                Response.Write("                                <input type=\"hidden\" id=\"EQ_ServiceMeter_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_ServiceMeter_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["ServiceMeter"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_ServiceMeterInd_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_ServiceMeterInd_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["ServiceMeterInd"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_ServiceMeterDate_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_ServiceMeterDate_");
                Response.Write(i);
                Response.Write("\" value=\"");
                //Response.Write(Server.HtmlEncode(row["ServiceMeterDate"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write( (!ServiceMeterDate.IsNullOrWhiteSpace()) ?  Util.DateFormat(ServiceMeterDate) :  ""  );
                Response.Write("\" />\r\n");
                //  Ticket 17730  
                Response.Write("                                <input type=\"hidden\" id=\"EQ_CabTypeCode_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_CabTypeCode_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["CABType"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                            </td>\r\n");
                Response.Write("                        </tr>");
                i = i + 1;
                //rs.MoveNext();  //<CODE_TAG_103506> Dav
            }
            Response.Write("            \r\n");
        }
        //<CODE_TAG_103506> Dav
		//rs = rs.NextRecordset();
		dt = getDataTable(ds, "Rental.Equipment");
		//</CODE_TAG_103506> Dav
        Response.Write("            </table>\r\n");
        //Rental Equipment
        //<CODE_TAG_100425>
        Response.Write("<table id=\"tblRentalEQ\" class=\"tbl\" width=\"100%\" cellpadding=\"2\" cellspacing=\"1\" border=\"0\" style=\"display:");
        if (curTabName != "Rental")
        {
            Response.Write("none");
        }
        Response.Write(";\">\r\n");
        if(dt == null)  //<CODE_TAG_103506> Dav: //if (rs.EOF)
        {
            Response.Write("<tr><td class=\"t11\">"+(string)GetLocalResourceObject("rkMsg_NoEquipmentFound5")+"</td></tr>\r\n");
        }
        else
        {
            Response.Write("    \r\n");
            Response.Write("				<tr>");
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_Mfr4"), 0, "EquipManufDesc", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_Industry4"), 0, "IndustryCode", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_SerialNum4"), 0, "SerialNumber", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_FPC4"), 0, "FamilyProductCode", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_EQNo4"), 0, "EquipmentNumber", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_Mod4"), 0, "DisplayModel", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_CEquiv4"), 0, "CompatibilityCode", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_MfrYear4"), 0, "YearOfManuf", strSortField, strSortDirection, curTabName));
            Response.Write(SortHeaderWithTab((string)GetLocalResourceObject("rkHeaderText_PurchDte4"), 0, "PurchaseDate", strSortField, strSortDirection, curTabName));
            Response.Write("	                    <td id=\"rshl\">&nbsp;</td>                   \r\n");
            Response.Write("                    </tr>            \r\n");
            
            //</CODE_TAG_100425>
            Response.Write("       \r\n");
            foreach (DataRow row in dt.Rows)   //<CODE_TAG_103506> Dav: //while(!(rs.EOF))
            {
                Response.Write("                        <tr class=\"");
                Response.Write((i % 2 == 0 ?  "rl" :  "rd"));
                Response.Write("\">\r\n");
                Response.Write("                            <td>");
                Response.Write(Server.HtmlEncode(row["EquipManufDesc"].As<string>("")));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("</td>\r\n");
                Response.Write("                            <td>");
                Response.Write(Server.HtmlEncode(row["IndustryCode"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("</td>\r\n");                                        
                Response.Write("                            <td>");                 
                Response.Write(Server.HtmlEncode(row["SerialNumber"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("</td>\r\n");
                Response.Write("                            <td>");
                Response.Write(Server.HtmlEncode(row["FamilyProductCode"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("</td>\r\n");
                Response.Write("                            <td>");
                Response.Write(Server.HtmlEncode(row["EquipmentNumber"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("</td>\r\n");
                Response.Write("                            <td>");
                Response.Write(Server.HtmlEncode(row["DisplayModel"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("</td>\r\n");
                Response.Write("                            <td>");
                Response.Write(Server.HtmlEncode(row["CompatibilityCode"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("</td>\r\n");
                Response.Write("                            <td>");
                Response.Write(Server.HtmlEncode(row["YearOfManuf"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("</td>\r\n");
                Response.Write("                            <td>");
                Response.Write(Server.HtmlEncode(row["PurchaseDate"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("</td> \r\n");
                Response.Write("                            <td style=\"width:5%\">\r\n");
                Response.Write("                                <input type=\"radio\" id=\"selEQ_radio\" name=\"selEQ_radio\" onclick=\"selEquipment(this, ");
                Response.Write(i);
                Response.Write(");\"/><input type=\"checkbox\" id=\"selEQ_checkbox_");
                Response.Write(i);
                Response.Write("\" name=\"selEQ_checkbox_");
                Response.Write(i);
                Response.Write("\" style=\"display:none;\"/>                            \r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_Model_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_Model_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["DisplayModel"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />                            \r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_SerialNumber_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_SerialNumber_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["SerialNumber"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_Division_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_Division_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["Division"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_EquipManufCode_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_EquipManufCode_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["EquipManufCode"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_EquipmentNumber_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_EquipmentNumber_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["EquipmentNumber"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_IdNumber_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_IdNumber_");
                Response.Write(i);
                Response.Write("\" value=\"\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_VINNumber_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_VINNumber_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["VINNumber"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_ServiceMeter_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_ServiceMeter_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["ServiceMeter"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_ServiceMeterInd_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_ServiceMeterInd_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["ServiceMeterInd"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                Response.Write("                                <input type=\"hidden\" id=\"EQ_ServiceMeterDate_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_ServiceMeterDate_");
                Response.Write(i);
                Response.Write("\" value=\"");
                ServiceMeterDate = row["ServiceMeterDate"].As<DateTime?>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                //Response.Write(Server.HtmlEncode(row["ServiceMeterDate"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write((!ServiceMeterDate.IsNullOrWhiteSpace()) ? Util.DateFormat(ServiceMeterDate) : "");
                //  Ticket 17730  
                Response.Write("\" />\r\n");   
                Response.Write("                                <input type=\"hidden\" id=\"EQ_CabTypeCode_");
                Response.Write(i);
                Response.Write("\" name=\"EQ_CabTypeCode_");
                Response.Write(i);
                Response.Write("\" value=\"");
                Response.Write(Server.HtmlEncode(row["CABType"].As<string>()));			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
                Response.Write("\" />\r\n");
                
                Response.Write("                            </td>                       \r\n");
                Response.Write("                        </tr>");
                i = i + 1;
                //rs.MoveNext();  //<CODE_TAG_103506> Dav
            }
            Response.Write("            \r\n");
        }
        Response.Write("            \r\n");
        Response.Write("            </table>\r\n");
        Response.Write("        </div>\r\n");
        Response.Write("    </div>\r\n");
        //LBranco 2009-09-15: Opportunity Section Change:BEGIN
        
        if (blnShowOpp)
        {
            //<fxiao, 2010-02-24::Consolidate flags into one />
            //<CODE_TAG_103506> Dav
			//rs = rs.NextRecordset();
			dt = getDataTable(ds, "Opportunity.List");
			//</CODE_TAG_103506> Dav
            sOpportunityList = "";
			if(dt != null)		//<CODE_TAG_103506> Dav
			{
				foreach (DataRow row in dt.Rows)   //<CODE_TAG_103506> Dav: //while(!(rs.EOF))
				{
					sOpportunityList = sOpportunityList + "," + row["OppNo"].As<string>() + "|" + row["oppDescription"].As<string>();			//<CODE_TAG_103506> Dav: old code rs.Fields instead of row and remove .Value property
					//rs.MoveNext();  //<CODE_TAG_103506> Dav
				}
			}
            if (!sOpportunityList.IsNullOrWhiteSpace()/*DONE:review logic - was '!= ""'*/)
            {
                sOpportunityList = sOpportunityList.Right(sOpportunityList.Length - 1);
            }
            Response.Write("<input type=\"hidden\" id=\"OpportunityList\" name=\"OpportunityList\" value=\"" + Server.HtmlEncode(sOpportunityList) + "\" />");
        }

        
       
        Response.Write("<input type=\"hidden\" id=\"hidSelectInfluenceridx\" name=\"hidSelectInfluenceridx\" value=\"" + strSelectInfluenceridx + "\" />");
        
        //LBranco 2009-09-15: Opportunity Section Change:END
        Response.Write(" \r\n");
        Response.Write("<" + "script language=\"javascript\">\r\n");
        Response.Write("		var curTabName = \"");
        Response.Write(curTabName);
        Response.Write("\";   ");
        //<CODE_TAG_100425>
        Response.Write("        function selEquipmentTab(tabname) {\r\n");
        Response.Write(" 			curTabName = tabname;              ");
        //<CODE_TAG_100425>
        Response.Write("            var currentTabName = \"equipmentTab_\" + tabname;\r\n");
        Response.Write("            var currentTableName = \"tbl\" + tabname + \"EQ\";\r\n");
        Response.Write("            if ($j(document.getElementById(currentTabName)).attr('class') == 'back') {\r\n");
        Response.Write("                $j(\"[id^='equipmentTab']\").each(function() {\r\n");
        Response.Write("                    $j(this).attr('class', 'back');\r\n");
        Response.Write("                });\r\n");
        Response.Write("                $j(\"[id^='tbl'][id$='EQ']\").each(function() {\r\n");
        Response.Write("                    $j(this).hide();\r\n");
        Response.Write("                });\r\n");
        Response.Write("                \r\n");
        Response.Write("                $j(document.getElementById(currentTabName)).attr('class', 'mhc');\r\n");
        Response.Write("                $j(document.getElementById(currentTableName)).show('slow');\r\n");
        Response.Write("            }        \r\n");
        Response.Write("        }\r\n");
        Response.Write("        function selEquipment(obj, idx) {\r\n");
        Response.Write("            \r\n");
        Response.Write("            var ckObj = document.getElementById(\"selEQ_checkbox_\" + idx);\r\n");
        Response.Write("            if (ckObj && obj) {\r\n");
        Response.Write("                if (ckObj.checked) {\r\n");
        Response.Write("                    $j(\"[id^='selEQ_radio']\").each(function() {\r\n");
        Response.Write("                        $j(this).attr(\"checked\", false);\r\n");
        Response.Write("                    });\r\n");
        Response.Write("                }\r\n");
        Response.Write("                $j(\"[id^='selEQ_checkbox_']\").each(function() {\r\n");
        Response.Write("                    $j(this).attr(\"checked\", false);\r\n");
        Response.Write("                });\r\n");
        Response.Write("                ckObj.checked = obj.checked;\r\n");
        Response.Write("                \r\n");
        Response.Write("                var oInsert = $j(\"#Equipment_Cloned\");\r\n");
        Response.Write("                \r\n");
        Response.Write("                if (obj.checked){\r\n");
        Response.Write("                    //Get New Header\r\n");
        Response.Write("                    var oHeader = $j(obj).closest(\"table\").children().find(\"tr:first\").clone();            \r\n");
        Response.Write("                    //Get New Equipment\r\n");
        Response.Write("                    var oRow = $j(obj).closest(\"tr\").clone();\r\n");
        Response.Write("                    //Clear Cloned Equipment            \r\n");
        Response.Write("                    oInsert.empty();\r\n");
        Response.Write("                    //Insert Cloned New Equipment\r\n");
        Response.Write("                    oRow.attr('class', 'rl');\r\n");
        Response.Write("                    oRow.find('*').andSelf().filter('[id]').each(function() {\r\n");
        Response.Write("                        this.id += '_Cloned';\r\n");
        Response.Write("                        if(this.name) this.name += '_Cloned';\r\n");
        Response.Write("                    });                         \r\n");
        Response.Write("                    oInsert.append(oHeader);\r\n");
        Response.Write("                    oInsert.append(oRow);return; \r\n");
        Response.Write("                }\r\n");
        Response.Write("                else\r\n");
        Response.Write("                {\r\n");
        Response.Write("                    //Clear Cloned Equipment\r\n");
        Response.Write("                    oInsert.empty();                \r\n");
        Response.Write("                }           \r\n");
        Response.Write("            }\r\n");
        Response.Write("        }\r\n");
        Response.Write("        function selInfluencer(obj, idx) {\r\n");
        Response.Write("            \r\n");
        Response.Write("            var ckObj = document.getElementById(\"selInf_checkbox_\" + idx);\r\n");
        Response.Write("            if (ckObj && obj) {\r\n");
        Response.Write("                if (ckObj.checked) {\r\n");
        Response.Write("                    $j(\"[id^='selInf_radio']\").each(function() {\r\n");
        Response.Write("                        $j(this).attr(\"checked\", false);\r\n");
        Response.Write("                    });\r\n");
        Response.Write("                }\r\n");
        Response.Write("                $j(\"[id^='selInf_checkbox_']\").each(function() {\r\n");
        Response.Write("                    $j(this).attr(\"checked\", false);\r\n");
        Response.Write("                });\r\n");
        Response.Write("                ckObj.checked = obj.checked;   \r\n");
        Response.Write("                var oInsert = $j(\"#Influencer_Cloned\");\r\n");
        Response.Write("                \r\n");
        Response.Write("                if (obj.checked){\r\n");
        Response.Write("                    //Get New Header\r\n");
        Response.Write("                    var oHeader = $j(obj).closest(\"table\").children().find(\"tr:first\").clone();\r\n");
        Response.Write("                    //Get New Influencer\r\n");
        Response.Write("                    var oRow = $j(obj).closest(\"tr\").clone();\r\n");
        Response.Write("                    //Clear Cloned Influencer            \r\n");
        Response.Write("                    oInsert.empty();\r\n");
        Response.Write("                    //Insert Cloned New Influencer\r\n");
        Response.Write("                    oRow.attr('class', 'rl');\r\n");
        Response.Write("                    oRow.find('*').andSelf().filter('[id]').each(function() {\r\n");
        Response.Write("                        this.id += '_Cloned';\r\n");
        Response.Write("                        if(this.name) this.name += '_Cloned';\r\n");
        Response.Write("                    });           \r\n");
        Response.Write("                    oInsert.append(oHeader);\r\n");
        Response.Write("                    oInsert.append(oRow); \r\n");

        Response.Write("                    $('#hidSelectInfluenceridx').val(idx);  "); 
            
        Response.Write("                }\r\n");
        Response.Write("                else\r\n");
        Response.Write("                {\r\n");
        Response.Write("                    //Clear Cloned Influencer            \r\n");
        Response.Write("                    oInsert.empty();\r\n");
        Response.Write("                }\r\n");
        Response.Write("            }        \r\n");
        Response.Write("        }\r\n");


        //Response.Write("         function addCustomer(){\r\n                        ");
        //Response.Write("            var sCustomerNo;\r\n");
        //Response.Write("            var sCustomerName;\r\n");
        //Response.Write("            sCustomerNo = $j(\"input[id='CustomerNo']\").val();\r\n");
        //Response.Write("            if(typeof(sCustomerNo) == \"undefined\"){sCustomerNo = \"\";}\r\n");
        //Response.Write("            sCustomerName = $j(\"input[id='CustomerName']\").val();\r\n");
        //Response.Write("            if(typeof(sCustomerName) == \"undefined\"){sCustomerName = \"\";}\r\n");
        //Response.Write("            \r\n");
        //Response.Write("            var fcaller = parent.frames[parent.currentPOPCaller]; \r\n");
        //Response.Write("            fcaller.AddCustomer(sCustomerNo, sCustomerName);\r\n");
        //Response.Write("         }                            ");
        
        
        
        Response.Write("        function addCustomer() {\r\n");
        Response.Write("            var sDefaultDivision= '" + Request.QueryString["DefaultDivision"].AsString("") + "'; \r\n"); // <CODE_TAG_102194>
        Response.Write("            var array_DivisionList;\r\n");
        Response.Write("            var array_InfluencerList;        \r\n");
        Response.Write("            var sCustomerNo;\r\n");
        Response.Write("            var sCustomerName;\r\n");
        Response.Write("            var sEQ_Model;\r\n");
        Response.Write("            var sEQ_SerialNumber;\r\n");
        Response.Write("            var sEQ_EquipManufCode;\r\n");
        Response.Write("            var sEQ_Division;\r\n");
        Response.Write("            var sEQ_EquipmentNumber;\r\n");
        Response.Write("            var sEQ_IdNumber;\r\n");
        Response.Write("            var sEQ_VINNumber;\r\n");
        Response.Write("            var sEQ_ServiceMeter;\r\n");
        Response.Write("            var sEQ_ServiceMeterInd;\r\n");
        Response.Write("            var sEQ_ServiceMeterDate;\r\n");
        Response.Write("            var sEQ_CabTypeCode;\r\n");

        Response.Write("            var sInf_Name;\r\n");
        Response.Write("            var sInf_Type;\r\n");
        Response.Write("            var sInf_Id;\r\n");
        Response.Write("            var sInf_Division;\r\n");
        Response.Write("            var sInf_Phone;\r\n");
        Response.Write("            var sInf_FaxNo;\r\n");
        Response.Write("            var sInf_Email;\r\n");
        Response.Write("            var sSelectedDivision;\r\n");
        Response.Write("            var array_OpportunityList; //LBranco 2009-09-15: Opportunity Section Change        \r\n");
        Response.Write("            \r\n");
        Response.Write("            array_DivisionList = $j(\"input[id='DivisionList']\").val();\r\n");
        
        Response.Write("            array_InfluencerList = $j(\"input[id='InfluencerList']\").val();\r\n");
        Response.Write("            sCustomerNo = $j(\"input[id='CustomerNo']\").val();\r\n");
        Response.Write("            if(typeof(sCustomerNo) == \"undefined\"){sCustomerNo = \"\";}\r\n");
        Response.Write("            sCustomerName = $j(\"input[id='CustomerName']\").val();\r\n");
        Response.Write("            if(typeof(sCustomerName) == \"undefined\"){sCustomerName = \"\";}\r\n");
        Response.Write("            \r\n");
        Response.Write("            sInf_Name = $j(\"input[id^='Inf_InfluencerName_'][id$='_Cloned']\").val();\r\n");
        Response.Write("            if(typeof(sInf_Name) == \"undefined\"){sInf_Name = \"\";}        \r\n");
        Response.Write("            sInf_Type = $j(\"input[id^='Inf_InfluencerType_'][id$='_Cloned']\").val();\r\n");
        Response.Write("            if(typeof(sInf_Type) == \"undefined\"){sInf_Type = \"\";}\r\n");
        Response.Write("            sInf_Id = $j(\"input[id^='Inf_InfluencerId_'][id$='_Cloned']\").val();\r\n");
        Response.Write("            if(typeof(sInf_Id) == \"undefined\"){sInf_Id = \"\";}\r\n");
        Response.Write("            sInf_Division = $j(\"input[id^='Inf_Division_'][id$='_Cloned']\").val();\r\n");
        Response.Write("            if(typeof(sInf_Division) == \"undefined\"){sInf_Division = \"\";}\r\n");
        Response.Write("            sInf_Phone = $j(\"input[id^='Inf_Phone_'][id$='_Cloned']\").val();                \r\n");
        Response.Write("            if(typeof(sInf_Phone) == \"undefined\"){sInf_Phone = \"\";}\r\n");
        Response.Write("            sInf_FaxNo = $j(\"input[id^='Inf_FaxNo_'][id$='_Cloned']\").val();                \r\n");
        Response.Write("            if(typeof(sInf_FaxNo) == \"undefined\"){sInf_FaxNo = \"\";}\r\n");
        Response.Write("            sInf_Email = $j(\"input[id^='Inf_Email_'][id$='_Cloned']\").val();                \r\n");
        Response.Write("            if(typeof(sInf_Email) == \"undefined\"){sInf_Email = \"\";}\r\n");
        Response.Write("            sEQ_Model = $j(\"input[id^='EQ_Model_'][id$='_Cloned']\").val();\r\n");
        Response.Write("            if(typeof(sEQ_Model) == \"undefined\"){sEQ_Model = \"\";}\r\n");
        Response.Write("            sEQ_SerialNumber = $j(\"input[id^='EQ_SerialNumber_'][id$='_Cloned']\").val();\r\n");
        Response.Write("            if(typeof(sEQ_SerialNumber) == \"undefined\"){sEQ_SerialNumber = \"\";}\r\n");
        Response.Write("            sEQ_EquipManufCode = $j(\"input[id^='EQ_EquipManufCode_'][id$='_Cloned']\").val();\r\n");
        Response.Write("            if(typeof(sEQ_EquipManufCode) == \"undefined\"){sEQ_EquipManufCode = \"\";}\r\n");
        Response.Write("            sEQ_Division = $j(\"input[id^='EQ_Division_'][id$='_Cloned']\").val();\r\n");
        Response.Write("            if(typeof(sEQ_Division) == \"undefined\"){sEQ_Division = \"\";}\r\n");
        Response.Write("            sEQ_EquipmentNumber = $j(\"input[id^='EQ_EquipmentNumber_'][id$='_Cloned']\").val();\r\n");
        Response.Write("            if(typeof(sEQ_EquipmentNumber) == \"undefined\"){sEQ_EquipmentNumber = \"\";}\r\n");
        Response.Write("            sEQ_IdNumber = $j(\"input[id^='EQ_IdNumber_'][id$='_Cloned']\").val();\r\n");
        Response.Write("            if(typeof(sEQ_IdNumber) == \"undefined\"){sEQ_IdNumber = \"\";}\r\n");
        Response.Write("            sEQ_VINNumber = $j(\"input[id^='EQ_VINNumber_'][id$='_Cloned']\").val();\r\n");
        Response.Write("            if(typeof(sEQ_VINNumber) == \"undefined\"){sEQ_VINNumber = \"\";}\r\n");
        Response.Write("            sEQ_ServiceMeter = $j(\"input[id^='EQ_ServiceMeter_'][id$='_Cloned']\").val();\r\n");
        Response.Write("            if(typeof(sEQ_ServiceMeter) == \"undefined\"){sEQ_ServiceMeter = \"\";}\r\n");
        Response.Write("            sEQ_ServiceMeterInd = $j(\"input[id^='EQ_ServiceMeterInd_'][id$='_Cloned']\").val();\r\n");
        Response.Write("            if(typeof(sEQ_ServiceMeterInd) == \"undefined\"){sEQ_ServiceMeterInd = \"\";}\r\n");
        Response.Write("            sEQ_ServiceMeterDate = $j(\"input[id^='EQ_ServiceMeterDate_'][id$='_Cloned']\").val();\r\n");
        Response.Write("            if(typeof(sEQ_ServiceMeterDate) == \"undefined\"){sEQ_ServiceMeterDate = \"\";}\r\n");
        Response.Write("            sEQ_CabTypeCode = $j(\"input[id^='EQ_CabTypeCode_'][id$='_Cloned']\").val();\r\n");  //  Ticket 17730   
        Response.Write("            if(typeof(sEQ_CabTypeCode) == \"undefined\"){sEQ_CabTypeCode = \"\";}\r\n");   //  Ticket 17730   
        
       
        Response.Write("            array_OpportunityList = $j(\"input[id='OpportunityList']\").val(); //LBranco 2009-09-15: Opportunity Section Change      \r\n");
        Response.Write("            \r\n");
        Response.Write("            if (sEQ_Division) sSelectedDivision = sEQ_Division;\r\n");
        Response.Write("            if (sInf_Division) sSelectedDivision = sInf_Division;\r\n");
        // <CODE_TAG_102194>
        Response.Write("            if (sSelectedDivision === undefined || sSelectedDivision == null || sSelectedDivision.length <= 0)  { \r\n ");
        Response.Write("            if (array_DivisionList.indexOf( sDefaultDivision + '|')>=0)  sSelectedDivision = sDefaultDivision; \r\n ");
        Response.Write("            } \r\n ");
        //</CODE_TAG_102194>
        Response.Write("            // Get Opener\r\n");
        Response.Write("            \r\n");
        Response.Write("                var fcaller = parent; \r\n");
        Response.Write("                if ( parent.curQuoteEditMode == 'EDIT')  fcaller = parent.frames['iFrameHeaderEdit']; ; \r\n");
        //Response.Write("                if ( fcaller === 'undefined'){ alert(0);  fcaller = parent.frames['iFrameQuoteAddNew']; }\r\n");
        Response.Write("                // Add Customer Inf\r\n");
        Response.Write("                if (fcaller.AddCustomer) fcaller.AddCustomer(sCustomerNo, sCustomerName);\r\n");
        //Response.Write("                if (fcaller.AddCustomer) fcaller.AddCustomer(sCustomerNo, sCustomerName, " +  sCustomerLoyaltyIndicator + ");\r\n"); //<CODE_TAG_104784>
        Response.Write("                if (fcaller.LoadCustomerLoyaltyIndicator) fcaller.LoadCustomerLoyaltyIndicator( " + sCustomerLoyaltyIndicator + ");\r\n"); //<CODE_TAG_104784>
        Response.Write("                // Add Influencer List\r\n");
        Response.Write("                if (fcaller.AddDivisionList) fcaller.AddDivisionList(array_DivisionList);\r\n");
        Response.Write("                // Add Contact List\r\n");
        Response.Write("                if ( array_InfluencerList != null &&  fcaller.AddInfluencerList) fcaller.AddInfluencerList(array_InfluencerList);\r\n");
        Response.Write("                // Add Equipment Info\r\n");
        //  Ticket 17730   
        Response.Write("                if (fcaller.AddEquipment) fcaller.AddEquipment(sEQ_Model, sEQ_SerialNumber, sEQ_EquipManufCode, sEQ_EquipmentNumber,sEQ_IdNumber, sEQ_ServiceMeter, sEQ_ServiceMeterInd, sEQ_ServiceMeterDate, '', '',sEQ_CabTypeCode);\r\n");
           
        Response.Write("                // Set Selected Division\r\n");
        Response.Write("                if (fcaller.SetDivision) fcaller.SetDivision(sSelectedDivision);\r\n");
        //<CODE_TAG_103528>
        Response.Write("                if (getCustomerPSSR)  getCustomerPSSR(sSelectedDivision);\r\n  ");
        if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.Owner.IsCreator")) //<CODE_TAG_105747>        
            Response.Write("                if (fcaller.ProcessQuoteOwner)   fcaller.ProcessQuoteOwner(pSSRXUId);\r\n  ");        
        //</CODE_TAG_103528>
        Response.Write("                // Set Selected Influencer\r\n");
        Response.Write("                if (fcaller.SetInfluencer && (Trim(sInf_Name) != \"\" || Trim(sInf_Id) != \"\")) fcaller.SetInfluencer(sInf_Name, sInf_Type, sInf_Id);\r\n");
        Response.Write("                // Add Opportunity List\r\n");
        Response.Write("                ////if (fcaller.AddOpportunityList) fcaller.AddOpportunityList(array_OpportunityList); //LBranco 2009-09-15: Opportunity Section Change\r\n");
                
        Response.Write("                parent.closeCustomerSearch(); \r\n");
        //Response.Write("            }\r\n");
        Response.Write("        }          \r\n");
        Response.Write("        \r\n");

        Response.Write("        /**** PPM Model****/	\r\n");
        Response.Write("        function p(iModelId,iFPCId, CurrSystemId)	{        \r\n");
        /*TODO: replace slcommon with proper path*/
        Response.Write("	        sURL = \"../slcommon/modules/externalApps/ppm/default2.aspx?ModelId=\" + iModelId + \"&FPCId=\" + iFPCId + \"&CurrSystemId=\" + CurrSystemId;\r\n");
        Response.Write("	        window.open(sURL,\"newwindow\",\"toolbar=yes, resizable=yes, menu=yes, scrollbars=yes, maximize=yes, left=0, top=75, height=450,width=775\");\r\n");
        Response.Write("	    }\r\n");
        Response.Write("        	\r\n");
        Response.Write("        /**** PPM Serial No ****/	\r\n");
        Response.Write("        function psn(iSN, CurrSystemId)	{        \r\n");
        /*TODO: replace slcommon with proper path*/
        Response.Write("	        sURL = \"../slcommon/modules/externalApps/ppm/FindResults.aspx?&SerialNumber=\" + iSN + \"&CurrSystemId=\" + CurrSystemId;\r\n");
        Response.Write("	        window.open(sURL,\"newwindow\",\"toolbar=yes, resizable=yes, menu=yes, scrollbars=yes, maximize=yes, left=0, top=75, height=450,width=775\");\r\n");
        Response.Write("	    }\r\n");
        Response.Write("        	\r\n");
        Response.Write("        /**** SOS ****/	\r\n");
        Response.Write("        function sos(iSN, CurrSystemId)	{\r\n");
        /*TODO: replace slcommon with proper path*/
        Response.Write("	        sURL = \"../slcommon/modules/externalApps/sos/searchresult2.aspx?csearch=\" + iSN + \"&&searchtype1=0&searchtype2=2&submit=Search\" + \"&CurrSystemId=\" + CurrSystemId;\r\n");
        Response.Write("	        window.open(sURL,\"newwindow\",\"toolbar=yes, resizable=yes, menu=yes, scrollbars=yes, maximize=yes, left=0, top=75, height=450,width=775\");\r\n");
        Response.Write("	    }		\r\n");
        Response.Write("        /**** WORK ORDERS ****/	\r\n");
        Response.Write("        function wo(iSN,sEMC, CurrSystemId)	{	    \r\n");
        Response.Write("	        sURL = \"");
        Response.Write(ConfigurationManager.AppSettings["url.siteRootPath"]);
        /*TODO: asp file*/
        Response.Write("library/sharedmodules/equipment/WorkOrder/WO_History.asp?");
        Response.Write(gAppID_URLKey);
        Response.Write("=");
        Response.Write(iAppId);
        Response.Write("&Division=");
        Response.Write(Server.UrlEncode(sDivision));
        Response.Write("&SerialNumber=\" + iSN + \"&EMC=\" + sEMC + \"&CUNO=");
        Response.Write(sCUNO);
        Response.Write("&CUNM=");
        Response.Write(sCUNM);
        Response.Write("\" + \"&CurrSystemId=\" + CurrSystemId;		    \r\n");
        Response.Write("	        x = window.open(sURL,\"stock\",\"width=775, height=400, toolbar=yes, menubar=yes, scrollbars=yes, maximize=yes, left=25, top=25, resizable=yes\");	    \r\n");
        Response.Write("        }			\r\n");
        Response.Write("        /**** SERVICE LETTERS ****/	\r\n");
        Response.Write("        function sl(iSN,sEMC, CurrSystemId)	{	    \r\n");
        Response.Write("	        sURL = \"");
        Response.Write(ConfigurationManager.AppSettings["url.siteRootPath"]);
        /*TODO: asp file*/
        Response.Write("library/sharedmodules/equipment/ServiceLetters/ServiceLetters.asp?Division=");
        Response.Write(sDivision);
        Response.Write("&SerialNumber=\" + iSN + \"&EMC=\" + sEMC + \"&CUNO=");
        Response.Write(sCUNO);
        Response.Write("&CUNM=");
        Response.Write(sCUNM);
        Response.Write("\" + \"&CurrSystemId=\" + CurrSystemId;\r\n");
        Response.Write("	        window.open(sURL,\"newwindow\",\"toolbar=yes, resizable=yes, menu=yes, scrollbars=yes, maximize=yes, left=0, top=75, height=450,width=775\");\r\n");
        Response.Write("        }			\r\n");
        Response.Write("        	\r\n");
        Response.Write("        /**** WARRANTY COVERAGE ****/	\r\n");
        Response.Write("        function WarrantyCoverage(iSN,sEMC, CurrSystemId)	{	    \r\n");
        Response.Write("	        sURL = \"");
        Response.Write(ConfigurationManager.AppSettings["url.siteRootPath"]);
        /*TODO: asp file*/
        Response.Write("library/sharedmodules/equipment/WarrantyCoverage/WarrantyCoverage.asp?Division=");
        Response.Write(sDivision);
        Response.Write("&SerialNumber=\" + iSN + \"&EMC=\" + sEMC + \"&CUNO=");
        Response.Write(sCUNO);
        Response.Write("&CUNM=");
        Response.Write(sCUNM);
        Response.Write("\" + \"&CurrSystemId=\" + CurrSystemId;\r\n");
        Response.Write("	        window.open(sURL,\"newwindow\",\"toolbar=yes, resizable=yes, menu=yes, scrollbars=yes, maximize=yes, left=0, top=75, height=450,width=775\");\r\n");
        Response.Write("        }			\r\n");
        Response.Write("        function equipConfig(EMC, SN, CurrSystemId) {\r\n");
        Response.Write("        /** Equipment Configuration **/\r\n");
        Response.Write("	        var sURL = \"");
        Response.Write(ConfigurationManager.AppSettings["url.siteRootPath"]);
        /*TODO: asp file*/
        Response.Write("library/sharedmodules/equipment/equipmentconfig/equipmentconfig.asp?SerialNumber=\" + escape(SN) + \"&EMC=\" + escape(EMC) + \"&CurrSystemId=\" + CurrSystemId;\r\n");
        Response.Write("	        x = window.open(sURL,\"stock\",\"width=775, height=400, toolbar=yes, menubar=yes, scrollbars=yes, maximize=yes, left=25, top=25, resizable=yes\");\r\n");
        Response.Write("	        x.focus();\r\n");
        Response.Write("        } \r\n");


        string str = @"function sortEquipment( urlLink )
                      {
                        if ($('#hidSelectInfluenceridx').val() != '')
                            urlLink += '&influenceridx=' + $('#hidSelectInfluenceridx').val();
                        document.location.href= urlLink;
                      }

                    $(function () {
                        var selFluencerIdx = $('#hidSelectInfluenceridx').val();
                       if ( selFluencerIdx != ''){
                         var rdo = $('[influenceridx='+ selFluencerIdx +']');
                         if (rdo.length> 0){
                             $(rdo).attr('checked', true);
                            selInfluencer(rdo[0], selFluencerIdx);
                         }
                       }

    
                    });";
        
        
        Response.Write(str);
        Response.Write("    </" + "script>");
    }

</script>
<script type="text/javascript" language="javascript">
    $(document).ready(function () {
        if (/iPhone|iPod|iPad/.test(navigator.userAgent))
            $('#wrapper').css({
                'overflow-y': 'scroll',
                'overflow-x': 'hidden',
                '-webkit-overflow-scrolling': 'touch',
                height: $(parent.document.getElementById("divCustomerSearch")).height(),
                width: $(parent.document.getElementById("divCustomerSearch")).width()
            });
        });

        //<CODE_TAG_103528>
        var pSSRXUId = "";
        function getCustomerPSSR(sSelectedDivision) {
            if (!sSelectedDivision) return;
            var array_divisionList = $("#DivisionList").val();
            var oDivisionList = array_divisionList.split(",");

            $.each(oDivisionList, function (index, value) {
                var oDivisionInfo = value.split("|");
                if (oDivisionInfo[0] == sSelectedDivision) {
                    pSSRXUId = oDivisionInfo[2];
                    return false;
                }
            });


        }
        //</CODE_TAG_103528>
    </script>
</asp:Content>

