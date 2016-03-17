<%@ Page language="c#"
Inherits="UI.Abstracts.Pages.Popup" 
MasterPageFile="~/library/masterPages/_base.master"
IsLegacyPage="true"%>
<%@ Import Namespace = "ADODB" %>
<%@ Import Namespace = "Microsoft.VisualBasic" %>
<%@ Import Namespace = "System.Net.Mail" %>
<%@ Import Namespace = "System.Text.RegularExpressions" %>
<%@ Import Namespace = "nce.scripting" %>
<asp:Content ID="cntMP" ContentPlaceHolderID="cntMP" Runat="Server">
<%
    string sSortField = null;
    string sSortDirection = null;
    int? iAppId = null;
    ADODB.Command cmd = null;
    ADODB.Recordset rs = null;
    int? strSID = null;
    int x = 0;
    string sKeyword = null;
    int? iSearchField = null;
    int? iMultipleSystem = null;
    string sCustomerNo = null;
    string sCustomerName = null;
    int? iSystemId = null;
    int? iBusinessEntityId = null;
    string sSearchDivision = null;
    string sTT = null;
    int? iRecordCount = null;
    int? iStartRecord = null;
    int? iPageSize = 0;
    ADODB.Command cmdDivision = null;
    ADODB.Recordset rsDivision = null;

    cmdDivision = new ADODB.CommandClass();
    cmdDivision.ActiveConnection = LegacyHelper.OpenDataConnection();
    cmdDivision.CommandText = "dbo.TRG_List_OwnerDivision";
    cmdDivision.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
    cmdDivision.Parameters.Append(cmdDivision.CreateParameter("BusinessEntityId", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 0, AppContext.Current.BusinessEntityId));
    rsDivision = new Recordset();
    rsDivision = cmdDivision.Execute();

    iBusinessEntityId = rsDivision.Fields["BusinessEntityId"].Value.As<int?>();
    iSystemId = rsDivision.Fields["SystemId"].Value.As<int?>();
  
    sKeyword = Request.QueryString["Keyword"].AsString();
    if (!Request.Form["txtKeyword"].IsNullOrWhiteSpace())
    {
        sKeyword = Request.Form["txtKeyword"].AsString( );
    }
    
    
    
    sSearchDivision = Request.QueryString["SearchDivision"];
    if (sSearchDivision.IsNullOrWhiteSpace())
    {
        sSearchDivision = (Request.Form["SearchDivision"] ?? String.Empty).Trim();
    }
    if (sSearchDivision.IsNullOrWhiteSpace())
    {
        sSearchDivision = "%";
    }
    iSearchField = Request.Form["cboSearchField"].As<int?>();
    if (iSearchField.IsNullOrWhiteSpace())
    {
        iSearchField = Request.QueryString["SearchField"].As<int?>();
    }
    if (iSearchField.IsNullOrWhiteSpace())
    {
        iSearchField = 2;
    }
    iStartRecord = Request.Form["hdnStartRecordId"].As<int?>();
    if (iStartRecord.IsNullOrWhiteSpace())
    {
        iStartRecord = 1;
    }

    iPageSize = (Request.Form["RecordNo"]).As<int?>(); /*NOTE: Manual Fixup added iPageSize = Request.Form["RecordNo"]*/
    if (iPageSize.IsNullOrWhiteSpace()/*DONE:review logic - was '== ""'*/)
    {
            iPageSize = 50;
    }

    sSortField = Request.Form["hdnSortField"];
    sSortDirection = Request.Form["hdnSortDirection"];
    if (sSortField.IsNullOrWhiteSpace())
    {
        sSortField = "CustomerName";
    }
    //<CODE_TAG_100753> Sort by Customer Name instead of by Customer Number
    if (sSortDirection.IsNullOrWhiteSpace())
    {
        sSortDirection = "asc";
    }
    if (!sKeyword.IsNullOrWhiteSpace())
    {
        cmd = new ADODB.CommandClass();
        cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
        cmd.CommandText = "dbo.TRG_Get_Customers";
        cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
        cmd.Parameters.Append(cmd.CreateParameter("SearchField", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput , 2, iSearchField));
        cmd.Parameters.Append(cmd.CreateParameter("SearchValue", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput , 50, sKeyword));
        cmd.Parameters.Append(cmd.CreateParameter("Division", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput , 1, sSearchDivision));
        cmd.Parameters.Append(cmd.CreateParameter("BusinessEntityId", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput , 0,  AppContext.Current.BusinessEntityId));
        cmd.Parameters.Append(cmd.CreateParameter("StartRecord", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput , 4, iStartRecord));
        cmd.Parameters.Append(cmd.CreateParameter("PageSize", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput , 4, iPageSize));
        cmd.Parameters.Append(cmd.CreateParameter("SortField", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput , 60, sSortField));
        cmd.Parameters.Append(cmd.CreateParameter("SortDirection", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput , 4, sSortDirection));
        //cmd.CommandTimeout = 20000;
        rs = new Recordset();
        rs = cmd.Execute();
        iRecordCount = rs.Fields["RecordCount"].Value.As<int?>();
        iMultipleSystem = rs.Fields["MultipleSystem"].Value.As<int?>();
       
        rs = rs.NextRecordset();
    }
%>

<form method="post" id="frmTRG" onsubmit="return Search();">
    <table border="0" width="100%" style="border-top: 1px solid #6f6f6f; border-left: 1px solid #6f6f6f; border-right: 1px solid #6f6f6f; background: #efefef;">
        <tr>
            <td class="t11 tSb" nowrap width="60">&nbsp;<%=(string) GetLocalResourceObject("rkLbl_Look_for")%>&nbsp;&nbsp;</td>
            <td width="120">
                <select accesskey="a" class="f" name="cboSearchField" id="cboSearchField">
                    <option value="1" <%= (iSearchField == 1 ?  " selected " :  "") %>><%=(string) GetLocalResourceObject("rkDrpDown_Customer_No")%></option>
                    <option value="2" <%= (iSearchField == 2 ?  " selected " :  "") %>><%=(string) GetLocalResourceObject("rkDrpDown_Customer_Name")%></option>
                    <option value="3" <%= (iSearchField == 3 ?  " selected " :  "") %>><%=(string) GetLocalResourceObject("rkDrpDown_Address")%></option>
                    <option value="4" <%= (iSearchField == 4 ?  " selected " :  "") %>><%=(string) GetLocalResourceObject("rkDrpDown_City_State")%></option>
                    <option value="9" <%= (iSearchField == 9 ?  " selected " :  "") %>><%=(string) GetLocalResourceObject("rkDrpDown_Phone_Number")%></option>
                    <option value="5" <%= (iSearchField == 5 ?  " selected " :  "") %>><%=(string) GetLocalResourceObject("rkDrpDown_Serial_Number")%></option>
                    <option value="6" <%= (iSearchField == 6 ?  " selected " :  "") %>><%=(string) GetLocalResourceObject("rkDrpDown_Unit_Number")%></option>
                    <option value="7" <%= (iSearchField == 7 ?  " selected " :  "") %>><%=(string) GetLocalResourceObject("rkDrpDown_Stock_Number")%></option>
                    <option value="8" <%= (iSearchField == 8 ?  " selected " :  "") %>><%=(string) GetLocalResourceObject("rkDrpDown_VIN")%></option>
                    <option value="10" <%= (iSearchField == 10 ?  " selected " :  "") %>><%=(string) GetLocalResourceObject("rkDrpDown_Work_Order_No")%></option>
                    <option value="11" <%= (iSearchField == 11 ?  " selected " :  "") %>>Influencer Name</option><!--CODE_TAG_102238-->
                </select>
            </td>
            <td class="t11 tSb" nowrap width="80">&nbsp;<%=(string) GetLocalResourceObject("rkLbl_that_contains")%>&nbsp;</td>
            <td><input name="txtKeyword" maxlength="50" class="f w150" value="<%= sKeyword %>"></td>
            <td class="t11 tSb"> <%=(string) GetLocalResourceObject("rkLbl_in") %></td>
            <td>
                <select class="f" name="SearchDivision" id="SearchDivision">
                    <option value="%" <%= (sSearchDivision == "%" ?  " selected " :  "") %>><%=(string) GetLocalResourceObject("rkDropDown_All_Divisions")%></option><%
    while(!(rsDivision.EOF))
    {
%>
                        <option value="<%= rsDivision.Fields["Division"].Value%>" <%=(sSearchDivision == rsDivision.Fields["Division"].Value.As<String>() ?  " selected " :  "")%>><%:rsDivision.Fields["DivisionName"].Value.As<String>() + " - (" + rsDivision.Fields["Division"].Value.As<String>() + ")"%></option><%
        rsDivision.MoveNext();
    }
%>
                </select>
            </td>
            <td><button class="btn" type="submit" id="btnSearch"><%=(string) GetLocalResourceObject("rkbtn_Search")%></button></td>
        </tr>
    </table>
<%
    if (!sKeyword.IsNullOrWhiteSpace())
    {
        
        Response.Write("<table class=\"tbl\" width=\"100%\" cellspacing=1 cellpadding=2 border=0>");
        Response.Write("<tr height=\"22\" bgcolor=\"#dedbd6\" class=\"t11 tSb\">");
        Response.Write("<td nowrap>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Customer_No")+"</td>");

        if (iMultipleSystem == 1)
        {
            Response.Write("<td>"+(string) GetLocalResourceObject("rkHeader_System")+"</td>");
        }
        Response.Write("<td nowrap>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Customer_Name")+"</td>");
        Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_Address")+"</td>");
        Response.Write("<td>&nbsp;"+(string) GetLocalResourceObject("rkHeader_City_State")+"</td>");
        Response.Write("</tr>");
        Response.Write("<tr height=1><td bgcolor=\"#6f6f6f\" colspan=" + (iMultipleSystem == 1 ?  5 :  4) + "></td></tr>");

        if (rs.EOF || rs.BOF)
        {
            Response.Write("<tr  class=\"t11 tSb\"><td colspan=\"4\">&nbsp;" + (string)GetLocalResourceObject("rkMsg_No_Customers_Found") + "</td></tr>");
        }
        else
        {
            //<BEGIN-fxiao, 2010-01-19::Obsolete logic - customer must exist>
            //'***********If SN search and SN not in equipment list but in work order list*******************
            //If iSearchField = 5 and rs("EQDefCheck") = 0 then
            //Response.Redirect "modules/TRG_Search/Equipment/workorder/wo_history.aspx?TT=" & sTT & "&EQDefCheck=0&EMC=" & rs("EquipManufCode") & "&SerialNumber=" & Server.URLEncode(rs("SerialNo"))
            //
            //'***********If not SN search or SN in equipment list*******************************************
            //Else
            //</END-fxiao, 2010-01-19>
            x = 0;
            while(!(rs.EOF))
            {
                sCustomerNo = rs.Fields["CustomerNo"].Value.As<string>();
                sCustomerName = rs.Fields["CustomerName"].Value.As<string>();

                Response.Write("<tr " + Util.RowClass(x) + " valign=\"top\">");
                Response.Write("<td width=\"85\">");
                //<BEGIN-fxiao, 2010-01-19::Obsolete logic - Remove code for equipment search>
                //If rs("TotalRecs") = 1 or iSearchField = 10 then
                //If iRecordCount = 1 then
                //Response.Redirect "../../../../customersearch/Customer_Details.aspx?TT=" & sTT & "&CUNO=" &Trim(sCustomerNo) & "&CUNM=" & Server.URLEncode(sCustomerName) & "&SearchField=" & iSearchField & "&Keyword=" & Server.URLEncode(sKeyword)
                //Else
                //rw "<a href=""" & "../../../../customersearch/Customer_Details.aspx?TT=" & sTT & "&CUNO=" &Trim(sCustomerNo) & "&CUNM=" & Server.URLEncode(sCustomerName) & "&SearchField=" & iSearchField & "&Keyword=" & Server.URLEncode(sKeyword) & """>" & sCustomerNo & "</a>"
                //End If
                //Else
                //</END-fxiao, 2010-01-19>
                string strDefaultDivision = Request.QueryString["DefaultDivision"].AsString("");//<CODE_TAG_102194>
                if (iRecordCount == 1)
                {
                    //Response.Redirect(this.CreateUrl("modules/TRG_Search/Equipment/CustomerSearch/Customer_Details.aspx", normalizeForAppending: true) + "TT=" + TemplateName.UrlEncode() + "&CustomerNo=" + Server.UrlEncode(sCustomerNo) + "&RecordCountIsOne=Yes&Division=" + Server.UrlEncode(sSearchDivision) + "&CustomerName=" + Server.UrlEncode(sCustomerName) + "&SystemId=" + iSystemId + "&BusinessEntityId=" + iBusinessEntityId + "&SearchField=" + iSearchField + "&SearchValue=" + Server.UrlEncode(sKeyword) + "&SearchDivision=" + Server.UrlEncode(sSearchDivision));
                    Response.Redirect(this.CreateUrl("modules/TRG_Search/Equipment/CustomerSearch/Customer_Details.aspx", normalizeForAppending: true) + "TT=" + TemplateName.UrlEncode() + "&CustomerNo=" + Server.UrlEncode(sCustomerNo) + "&RecordCountIsOne=Yes&Division=" + Server.UrlEncode(sSearchDivision) + "&CustomerName=" + Server.UrlEncode(sCustomerName) + "&SystemId=" + iSystemId + "&BusinessEntityId=" + iBusinessEntityId + "&SearchField=" + iSearchField + "&SearchValue=" + Server.UrlEncode(sKeyword) + "&SearchDivision=" + Server.UrlEncode(sSearchDivision) + "&DefaultDivision=" + strDefaultDivision   );//<CODE_TAG_102194>
                }
                else
                {
                    //Response.Write("<a href=\"" + this.CreateUrl("modules/TRG_Search/Equipment/CustomerSearch/Customer_Details.aspx", normalizeForAppending: true) + "TT=" + TemplateName.UrlEncode() + "&CustomerNo=" + Server.UrlEncode(sCustomerNo) + "&RecordCountIsOne=No&Division=" + Server.UrlEncode(sSearchDivision) + "&CustomerName=" + Server.UrlEncode(sCustomerName) + "&SystemId=" + iSystemId + "&BusinessEntityId=" + iBusinessEntityId + "&SearchField=" + iSearchField + "&SearchValue=" + Server.UrlEncode(sKeyword) + "&SearchDivision=" + Server.UrlEncode(sSearchDivision) + "\">" + rs.Fields["CustomerNo"].Value.As<string>().HtmlEncode() + "</a>");
                    Response.Write("<a href=\"" + this.CreateUrl("modules/TRG_Search/Equipment/CustomerSearch/Customer_Details.aspx", normalizeForAppending: true) + "TT=" + TemplateName.UrlEncode() + "&CustomerNo=" + Server.UrlEncode(sCustomerNo) + "&RecordCountIsOne=No&Division=" + Server.UrlEncode(sSearchDivision) + "&CustomerName=" + Server.UrlEncode(sCustomerName) + "&SystemId=" + iSystemId + "&BusinessEntityId=" + iBusinessEntityId + "&SearchField=" + iSearchField + "&SearchValue=" + Server.UrlEncode(sKeyword) + "&SearchDivision=" + Server.UrlEncode(sSearchDivision) + "&DefaultDivision=" + strDefaultDivision  +  "\">" + rs.Fields["CustomerNo"].Value.As<string>().HtmlEncode() + "</a>"); //<CODE_TAG_102194>
                }
              
                //END-fxiao, 2010-01-19>
                Response.Write("</td>");
                if (iMultipleSystem == 1)
                {
                    Response.Write("<td>" + rs.Fields["SystemDesc"].Value.As<String>().HtmlEncode() + "</td>");
                }

                //Response.Write("<td>" + rs.Fields["CustomerNo"].Value.As<string>().HtmlEncode() + "</td>"); /*NOTE: manual fixup - added CustomerNo*/
                //Response.Write("<td>" + sCustomerName.HtmlEncode() + "</td>");
                Response.Write("<td>" + rs.Fields["CustomerName"].Value.As<string>().HtmlEncode() + "</td>");   /*NOTE: manual fixup - added CustomerName*/
                Response.Write("<td>" + rs.Fields["Address"].Value.As<String>().HtmlEncode() + "</td>");
                //<fxiao, 2010-01-07::Get address into one field />'rw "<td>" & rs("Address2") & "&nbsp;" & rs("Address3") & "</td>"
                Response.Write("<td width=\"150\">" + rs.Fields["CityProvince"].Value.As<String>() + "</td>");
                Response.Write("</tr>");
                rs.MoveNext();
                x = x + 1;
            }
            //<BEGIN-fxiao, 2010-01-19::Obsolete logic - customer must exist>
            //End If
            //</END-fxiao, 2010-01-19>
        }
        Util.CleanUp(cmd, rs);
        Response.Write("</table>");
    }
    else
    {
        Response.Write("<br/>");
        Response.Write("<div class=\"f\">"+(string) GetLocalResourceObject("rkMsg_Choose_a_field_and_enter_a_keyword_to_search_for")+"</div>");
    }

    Response.Write("<input type=\"hidden\" name=\"hdnStartRecordId\">");
    Response.Write("<input type=\"hidden\" name=\"hdnSortField\" value=" + sSortField + ">");
    Response.Write("<input type=\"hidden\" name=\"hdnSortDirection\" value=" + sSortDirection + ">");
    Response.Write("<table>");
    
    if (!sKeyword.IsNullOrWhiteSpace())
    {
        Response.Write("<tr class=\"t11\"><td >" + HtmlHelper.Pager((int) iStartRecord, (int) iRecordCount, null, System.Web.Mvc.FormMethod.Post, "hdnStartRecordId")+ "</td></tr>");
    }
    Response.Write("</table>");
    Response.Write("</form>");
%>
<script language="javascript">
if ("<%= iAppId %>" != 24){frmTRG.txtKeyword.focus();}

function Search(){
	if (frmTRG.cboSearchField.value == 6 && frmTRG.txtKeyword.value.length < 2){
		alert ("<%=GetLocalResourceObject("rkMsg_The_Keyword_must_be_at_least_2_characters_long_").JavaScriptStringEncode()%>")
		frmTRG.txtKeyword.focus();
		return false;
	}
	else if (frmTRG.cboSearchField.value != 6 && frmTRG.txtKeyword.value.length < 3){
		alert ("<%=GetLocalResourceObject("rkMsg_The_Keyword_must_be_at_least_3_characters_long_").JavaScriptStringEncode()%>")
		frmTRG.txtKeyword.focus();
		return false;
	}
	else {
		frmTRG.submit();
	    disableOnPostBack(frmTRG);
		return true;
	}
}

function Sort(sSortField){
	if (frmTRG.hdnSortField.value == sSortField && frmTRG.hdnSortDirection.value == "asc"){
		frmTRG.hdnSortDirection.value = "desc";
	}
	else {
		frmTRG.hdnSortDirection.value = "asc";
	}
		
	frmTRG.hdnSortField.value = sSortField;
	frmTRG.submit();
	
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
    </script>
</asp:Content>
