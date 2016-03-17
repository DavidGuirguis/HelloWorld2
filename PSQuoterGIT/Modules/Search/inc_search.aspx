<%@ Import Namespace = "ADODB" %>
<script language="C#" runat="server">

    string i = null;
    string KeywordType = null;
    string sSortField = null;
    string sSortDirection = null;
    string sColour = null;
    string strType= null;
    string strURLPath = null;
    const int searchLoc_SearchBar = 1;
    const int searchLoc_CopyQuote = 2;
    //<CODE_TAG_100705>Wrap into a method</CODE_TAG_100705>
    int? iRecordCount = null;
    
    void WriteSearchOptions(bool blnSearchAllQuotes, string selectedValue) 
    {
        selectedValue = CType.ToInt32(selectedValue, -1).AsString();
        //<CODE_TAG_100753> Lookup field wordings
        Response.Write("<option " + (selectedValue == "1" ?  "selected=\"true\"" :  "") + " value=1>" + (string)GetLocalResourceObject("rkDropDown_QuoteNumber"));
        Response.Write("<option " + (selectedValue == "13" ?  "selected=\"true\"" :  "") + " value=\"13\">" + (string)GetLocalResourceObject("rkDropDown_QuoteDesc"));
        //<CODE_TAG_100705>add Quote Description</CODE_TAG_100705>
        Response.Write("<option " + (selectedValue == "2" ?  "selected=\"true\"" :  "") + " value=2>" + (string)GetLocalResourceObject("rkDropDown_CustomerNumber"));
        Response.Write("<option " + (selectedValue == "3" ?  "selected=\"true\"" :  "") + " value=3>" + (string)GetLocalResourceObject("rkDropDown_CustomerName"));
        if (blnSearchAllQuotes)
        {
            Response.Write("<option " + (selectedValue == "7" ?  "selected=\"true\"" :  "") + " value=7>" + (string)GetLocalResourceObject("rkDropDown_SalesRep"));
        }
        //<fxiao, 2010-01-19::Show the option depending on value of the flag />
        //<CODE_TAG_100369>Entered by
        Response.Write("<option " + (selectedValue == "12" ?  " selected=\"true\"" :  "") + " value=\"12\">" + (string)GetLocalResourceObject("rkDropDown_QuoteOriginator"));
        //</CODE_TAG_100369>
        Response.Write("<option " + (selectedValue == "4" ?  "selected=\"true\"" :  "") + " value=4>" + (string)GetLocalResourceObject("rkDropDown_Make"));
        Response.Write("<option " + (selectedValue == "5" ?  "selected=\"true\"" :  "") + " value=5>" + (string)GetLocalResourceObject("rkDropDown_Model"));
        Response.Write("<option " + (selectedValue == "6" ?  "selected=\"true\"" :  "") + " value=6>" + (string)GetLocalResourceObject("rkDropDown_SerialNumber"));
        Response.Write("<option " + (selectedValue == "8" ?  "selected=\"true\"" :  "") + " value=8>" + (string)GetLocalResourceObject("rkDropDown_WorkOrderNumber"));
        Response.Write("<option " + (selectedValue == "9" ?  "selected=\"true\"" :  "") + " value=9>" + (string)GetLocalResourceObject("rkDropDown_SegmentDescription"));
        //[<IAranda. 20080822> SegmentDescFilter] Added a filter.
        Response.Write("<option " + (selectedValue == "10" ?  "selected=\"true\"" :  "") + " value=10>" + (string)GetLocalResourceObject("rkDropDown_HiddenSegmentDesc"));
        //[<IAranda. 20080822> SegmentDescFilter] Added a filter.
        Response.Write("<option " + (selectedValue == "11" ?  "selected=\"true\"" :  "") + " value=11>" + (string)GetLocalResourceObject("rkDropDown_UnitNumber"));
        //[<IAranda. 20080822> SegmentDescFilter] Added a filter.
        //</CODE_TAG_100753>
    }

    //<CODE_TAG_100705>Wrap results into a method</CODE_TAG_100705>
    void SearchQuotes(int searchLocation, string iKeywordType, string sKeyWord, string iOperator, string SearchDivision) 
    {
        int iColSpan = 0;
        int SearchAllQuotes = 0;
        int? iPageSize = null;
        int? iStartRecord = null;
        ADODB.Recordset rs = null;
        ADODB.Command cmd = null;
        bool blnShowCopyButton = false;
        sKeyWord = sKeyWord ?? "";  //If null default to ""
        
          
        switch (searchLocation) {
            case searchLoc_SearchBar:
                //Search bar
                //<CODE_TAG_100753> Allow searching Make, Model, Unit Number using 2 characters instead of 3.
                if (sKeyWord.Length < 3 && i != "1" && KeywordType != "11" && KeywordType != "4" && KeywordType != "5")
                {
                    Response.Write("<span class=\"t12 tSb\"><font color=red>"+(string) GetLocalResourceObject("rkMsg_You_must_search_for_at_least_3_characters")+"</font></span>");
                    return ;
                }
                else if( sKeyWord.Length < 2 && i != "1" && (KeywordType == "4" || KeywordType == "5" || KeywordType == "11"))
                {
                    Response.Write("<span class=\"t12 tSb\"><font color=red>"+(string) GetLocalResourceObject("rkMsg_You_must_search_for_at_least_2_characters")+"</font></span>");
                    return ;
                }
                //</CODE_TAG_100753> Allow searching Make, Model, Unit Number using 2 characters instead of 3.
                SearchAllQuotes = 1;
                break;
            case searchLoc_CopyQuote:
                //Copy quote
                SearchAllQuotes = 2;
                break;
        }
        iColSpan = 13;
        blnShowCopyButton = searchLocation == searchLoc_CopyQuote;
        
        cmd = new ADODB.CommandClass();
        cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
        cmd.CommandText = "dbo.Quote_Search_Quotes";
        cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
        sSortField = Request.Form["hdnSortField"];
        sSortDirection = Request.Form["hdnSortDirection"];
        iStartRecord = Request.Form["hdnStartRecordId"].As<int?>();
        if (iStartRecord.IsNullOrWhiteSpace())
        {
            iStartRecord = 1;
        }
        iPageSize = (Request.Form["RecordNo"]).As<int?>();
        if (iPageSize.IsNullOrWhiteSpace())
        {
            iPageSize = 50;
        }
        if (sSortField.IsNullOrWhiteSpace())
        {
            sSortField = "QuoteDate";
        }
        if (sSortDirection.IsNullOrWhiteSpace())
        {
            sSortDirection = "desc";
        }
        cmd.Parameters.Append(cmd.CreateParameter("userID", ADODB.DataTypeEnum.adInteger,ADODB.ParameterDirectionEnum.adParamInput, 0, WebContext.User.IdentityEx.UserID));
        cmd.Parameters.Append(cmd.CreateParameter("SearchField", ADODB.DataTypeEnum.adSmallInt,ADODB.ParameterDirectionEnum.adParamInput, 0, iKeywordType));
        cmd.Parameters.Append(cmd.CreateParameter("Operator", ADODB.DataTypeEnum.adSmallInt,ADODB.ParameterDirectionEnum.adParamInput, 0, iOperator));
        cmd.Parameters.Append(cmd.CreateParameter("Keyword", ADODB.DataTypeEnum.adVarWChar,ADODB.ParameterDirectionEnum.adParamInput, 50, sKeyWord));
        cmd.Parameters.Append(cmd.CreateParameter("SortField", ADODB.DataTypeEnum.adVarWChar,ADODB.ParameterDirectionEnum.adParamInput, 60, sSortField));
        cmd.Parameters.Append(cmd.CreateParameter("SortDirection", ADODB.DataTypeEnum.adVarWChar,ADODB.ParameterDirectionEnum.adParamInput, 4, sSortDirection));
        cmd.Parameters.Append(cmd.CreateParameter("StartRecord", ADODB.DataTypeEnum.adInteger,ADODB.ParameterDirectionEnum.adParamInput, 0, iStartRecord));
        cmd.Parameters.Append(cmd.CreateParameter("PageSize", ADODB.DataTypeEnum.adInteger,ADODB.ParameterDirectionEnum.adParamInput, 0, iPageSize));
        cmd.Parameters.Append(cmd.CreateParameter("Division", ADODB.DataTypeEnum.adWChar,ADODB.ParameterDirectionEnum.adParamInput, 1, SearchDivision));
        cmd.Parameters.Append(cmd.CreateParameter("BusinessEntityId", ADODB.DataTypeEnum.adSmallInt,ADODB.ParameterDirectionEnum.adParamInput, 0,AppContext.Current.BusinessEntityId));
        cmd.Parameters.Append(cmd.CreateParameter("SearchAllQuotes", ADODB.DataTypeEnum.adTinyInt,ADODB.ParameterDirectionEnum.adParamInput, 0, SearchAllQuotes));
        //<fxiao, 2010-01-19::Indicate whether override user's setting to search all quotes />
        rs = new Recordset();
        rs = cmd.Execute();
        iRecordCount = rs.Fields["RecordCount"].Value.As<int?>(); 
        rs = rs.NextRecordset();
        Response.Write("<table class='tbl' cellspacing=\"1\" cellpadding=\"2\" border=\"0\" width=\"100%\" style=\"margin-top:2px;border:\"none\">");
        //[<IAranda. 20080604>. PSQuoter (QuoteListRange). START]
        if (Request.QueryString["F"] == "1" && searchLocation == searchLoc_SearchBar)
        {
            Response.Write("<tr><td class=\"t11 tSb\" colspan=\"" + iColSpan + "\">" + String.Format((string) GetLocalResourceObject("rklbl_Quotes_created_in_the_last_days"), rs.Fields["QListRange"].Value.As<string>()) + "</td></tr>");
        }
        rs = rs.NextRecordset();
        //[<IAranda. 20080604>. PSQuoter (QuoteListRange). END]
        
        Response.Write("<tr class=\"reportHeader\" >");
        if (blnShowCopyButton)
        {
            Response.Write("<td width=\"20\"></td>");
        }
        Response.Write("<td class=\"t11 tSb\" nowrap><a href=# onclick=\"Sort('QuoteNo');\" style=\"color:black;\">"+(string)GetLocalResourceObject("rkHeader_Quote_No")+"</a></td>");
        Response.Write("<td class=\"t11 tSb\" align=\"middle\"><a href=# onclick=\"Sort('Status');\" style=\"color:black;\">"+(string) GetLocalResourceObject("rkHeader_Status")+"</a></td>");
        Response.Write("<td class=\"t11 tSb\" align=\"middle\"><a href=# onclick=\"Sort('Division');\" style=\"color:black;\">"+(string) GetLocalResourceObject("rkHeader_Division")+"</a></td>");
        Response.Write("<td class=\"t11 tSb\" align=\"middle\"><a href=# onclick=\"Sort('Type');\" style=\"color:black;\">"+(string) GetLocalResourceObject("rkHeader_Type")+"</a></td>");
        Response.Write("<td class=\"t11 tSb\" nowrap align=\"middle\"><a href=# onclick=\"Sort('QuoteDate');\" style=\"color:black;\">"+(string) GetLocalResourceObject("rkHeader_Quote_Date")+"</a></td>");
        Response.Write("<td class=\"t11 tSb\"><a href=# onclick=\"Sort('CustomerNo');\" style=\"color:black;\">"+(string) GetLocalResourceObject("rkHeader_Customer")+"</a></td>");
        Response.Write("<td class=\"t11 tSb\"><a href=# onclick=\"Sort('QuoteDescription');\" style=\"color:black;\">"+(string) GetLocalResourceObject("rkHeader_Description")+"</a></td>");
        Response.Write("<td class=\"t11 tSb\" nowrap><a href=# onclick=\"Sort('SalesRepFName,SalesRepLName');\" style=\"color:black;\">"+(string) GetLocalResourceObject("rkHeader_Sales_Rep")+"</a></td>");
        Response.Write("<td class=\"t11 tSb\"><a href=# onclick=\"Sort('Make');\" style=\"color:black;\">"+(string) GetLocalResourceObject("rkHeader_Make")+"</a></td>");
        Response.Write("<td class=\"t11 tSb\"><a href=# onclick=\"Sort('Model');\" style=\"color:black;\">"+(string) GetLocalResourceObject("rkHeader_Model")+"</a></td>");
        Response.Write("<td class=\"t11 tSb\" nowrap><a href=# onclick=\"Sort('SerialNo');\" style=\"color:black;\">"+(string) GetLocalResourceObject("rkHeader_Serial_No")+"</a></td>");
        Response.Write("<td class=\"t11 tSb\" nowrap><a href=# onclick=\"Sort('UnitNo');\" style=\"color:black;\">"+(string) GetLocalResourceObject("rkHeader_Unit_No")+"</a></td>");
        //[<IAranda 20080822> UnitNoColumn.] Added Unit No. column.

        //<CODE_TAG_103976>
		  Response.Write("<td class=\"t11 tSb\" nowrap><a href=# onclick=\"Sort('QuoteTotal');\" style=\"color:black;\">"+(string) GetLocalResourceObject("rkHeader_Quote_Total")+"</a></td>");        
        //</CODE_TAG_103976>

        //<CODE_TAG_100369>Entered by
        Response.Write("<td class=\"t11 tSb\" nowrap><a href=# onclick=\"Sort('EnterUserName');\" style=\"color:black;\">"+(string) GetLocalResourceObject("rkHeader_Entered_br_User")+"</a></td>");
        Response.Write("<td class=\"t11 tSb\" nowrap><a href=# onclick=\"Sort('EnterDate');\" style=\"color:black;\">"+(string) GetLocalResourceObject("rkHeader_Entered_br_Date")+"</a></td>");
        //</CODE_TAG_100369>
        Response.Write("</tr>");
        if (rs.EOF)
        {
            Response.Write("<tr><td class=\"t11 tSb\" colspan=\"" + iColSpan + "\"><font color=\"red\">"+(string) GetLocalResourceObject("rkMsg_No_information_found")+"</font></td></tr>");
        }
        else
        {
            sColour = "white";
            while(!(rs.EOF))
            {
                strType= rs.Fields["Type"].Value.As<String>();
                //*****If only one record*****
                if (iRecordCount == 1)
                {
                    Response.Redirect(this.CreateUrl("modules/quote/quote_Summary.aspx", normalizeForAppending: true) + "QuoteId=" + rs.Fields["QuoteId"].Value.As<string>() + "&Revision=" + rs.Fields["Revision"].Value.As<string>() + "&Type=" + strType);
                }
                Response.Write("<tr valign=\"top\" class=\"t11\" bgColor=" + sColour + ">");
                if (blnShowCopyButton)
                {
                    Response.Write("<td width=\"40\"><button class=\"btn\" type=\"button\" style=\"cursor:pointer;\" onclick=\"Copy('" + rs.Fields["QuoteId"].Value.As<string>() + "');\">"+(string) GetLocalResourceObject("rkBtn_Copy")+"</button></td>");
                }
                Response.Write("<td nowrap><a href="+ this.CreateUrl("modules/quote/quote_Summary.aspx", normalizeForAppending: true) + "QuoteId=" + rs.Fields["QuoteId"].Value.As<string>() + "&Revision=" + rs.Fields["Revision"].Value.As<string>() + "&Type=" + strType+ ">" + rs.Fields["QuoteNo"].Value.As<string>() + "</a></td>");
                Response.Write("<td id=\"rsc\">" + rs.Fields["Status"].Value.As<string>() + "</td>");
                Response.Write("<td id=\"rsc\">" + rs.Fields["Division"].Value.As<string>() + "</td>");
                Response.Write("<td id=\"rsc\">" + strType+ "</td>");
                Response.Write("<td nowrap id=\"rsc\">" + Util.DateFormat(rs.Fields["QuoteDate"].Value.As<DateTime?>()) + "</td>");
                Response.Write("<td>" + rs.Fields["CustomerNo"].Value.As<string>() + " - " + rs.Fields["CustomerName"].Value.As<string>() + "</td>");
                Response.Write("<td id=\"rsc\">" + rs.Fields["QuoteDescription"].Value.As<string>() + "</td>");
                Response.Write("<td>" + rs.Fields["SalesRepFName"].Value.As<string>() + "&nbsp;" + rs.Fields["SalesRepLName"].Value.As<string>() + "</td>");
                Response.Write("<td>" + rs.Fields["Make"].Value.As<string>() + "</td>");
                Response.Write("<td>" + rs.Fields["Model"].Value.As<string>() + "</td>");
                Response.Write("<td>" + rs.Fields["SerialNo"].Value.As<string>() + "</td>");
                Response.Write("<td>" + rs.Fields["UnitNo"].Value.As<string>() + "</td>");
                //[<IAranda 20080822> UnitNoColumn.] Added Unit No. column.
                Response.Write("<td nowrap>" + Helpers.Util.NumberFormat(rs.Fields["QuoteTotal"].Value.As<double?>(), 2, null, null, null, true) + "</td>"); //<CODE_TAG_103976>
                //<CODE_TAG_100369>Entered by
                Response.Write("<td>" + rs.Fields["EnterUserName"].Value.As<string>().HtmlEncode() + "</td>");
                Response.Write("<td nowrap>" + Util.DateFormat(rs.Fields["EnterDate"].Value.As<DateTime?>()) + "</td>"); //<CODE_TAG_103976>
                //</CODE_TAG_100369>
                Response.Write("</tr>");
                if (sColour == "white")
                {
                    sColour = "#efefef";
                }
                else
                {
                    sColour = "white";
                }
                rs.MoveNext();
            }
            Response.Write("<tr><td colspan=\"" + (iColSpan - 2).As<string>() + "\">&nbsp;</td><td colspan=\"2\"></td>");
            Response.Write("<td>" + HtmlHelper.Pager(iStartRecord.As<int>(), iRecordCount.As<int>(), null, System.Web.Mvc.FormMethod.Post, "hdnStartRecordId") + "</td>");
         
            //<CODE_TAG_100278>New param - httpMethod</CODE_TAG_100278>
        }
        Response.Write("</table>");
        Response.Write("<input type=\"hidden\" name=\"hdnSortField\" value=" + sSortField + ">");
        Response.Write("<input type=\"hidden\" name=\"hdnSortDirection\" value=" + sSortDirection + ">");
        Response.Write("<input type=\"hidden\" name=\"hdnStartRecordId\">");
        rs.Close();
        Util.CleanUp(cmd);
    }
    

</script>
