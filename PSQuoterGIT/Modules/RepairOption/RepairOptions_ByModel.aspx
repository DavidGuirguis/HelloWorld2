<%@ Page Language="c#" Inherits="UI.Abstracts.Pages.ReportViewPage" MasterPageFile="~/library/masterPages/_base.master"
    IsLegacyPage="true" %>

<%@ Import Namespace="ADODB" %>
<%@ Import Namespace="Microsoft.VisualBasic" %>
<%@ Import Namespace="System.Net.Mail" %>
<%@ Import Namespace="System.Text.RegularExpressions" %>
<%@ Import Namespace="nce.scripting" %>
<asp:Content ID="cntMP" ContentPlaceHolderID="cntMP" runat="Server">
    <%
        
        int? iQuoteId = null;
        string sMode = null;
        string sStoreNo = null;
        int? iAdminCheck = null;
        string sStoreNoRS = null;
        ADODB.Command oCmd = null;
        ADODB.Recordset oRsEmailRecipients = null;
        string sColour = null;
        int iCounter = 0;
        string sSNBegin = null;
        int? iDBSROId = null;
       
        ADODB.Command cmd = null;
        ADODB.Recordset rs = null;
        string sEQM = null;
		string sSNPrefix = null;  //<CODE_TAG_104228>
        string sModel = null;
        string sEQMOld = null;
        string sModelOld = null;
        string sFRExchange = null;
        string sFRExchangeOld = null;
        string sWorkApplicationCode = null;
        string sBusiness = null;
        string sShowStore = null;
        string sShowBusiness = null;
        string sSpecialChar = null;
        string sSpecialCharReplacement = null;
        bool blnWorkApplicationCodesShow = false;
        string sText = null;
        string ToName = null;
        string ToEmail = null;
        string scolspan = null;

        int eqType = 1;
        int recCount = 0;

        string TT = Request.QueryString["TT"].AsString("");
        string PageMode = Request.QueryString["PageMode"].AsString("");

        iQuoteId = Request.QueryString["QuoteId"].As<int?>();
        if (0 == String.Compare(TemplateName, "Popup", StringComparison.InvariantCultureIgnoreCase))
        {
            sMode = "Add";
        }

        ModuleTitle = (string)GetLocalResourceObject("rkModTitle_Repair_Option_Search");
        //*************************************************************************************************************************


        cmd = new ADODB.CommandClass();
        cmd.ActiveConnection = LegacyHelper.OpenDataConnection();
        cmd.CommandText = "dbo.TRG_List_RepairOptionsByModel";
        cmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;

        cmd.Parameters.Append(cmd.CreateParameter("UserId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, WebContext.User.IdentityEx.UserID));
        //[<IAranda. 20080820> CodeMerge. START]
        eqType = Request.Form["eqType"].AsInt(0);
        sModel = Request.Form["txtModel"];


        if (!Page.IsPostBack && sModel.IsNullOrWhiteSpace())
        {
            if (PageMode == "AddSegments")
                sModel = Request.QueryString["Model"].AsString("");
				eqType = 1;   //<CODE_TAG_104228>
				sSNPrefix = Request.QueryString["snPrefix"].AsString("");    //<CODE_TAG_104228>
        }
        if (sModel.IsNullOrWhiteSpace())
        {
            sModel = "%";
        }


        cmd.Parameters.Append(cmd.CreateParameter("Model", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 20, sModel));
        sStoreNo = Request.Form["cboStore"];

        if (sStoreNo.IsNullOrWhiteSpace())
        {
            sStoreNo = "%%";
        }

        cmd.Parameters.Append(cmd.CreateParameter("StoreNo", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 10, sStoreNo));

        sBusiness = Request.Form["cboBusiness"];

        if (sBusiness.IsNullOrWhiteSpace())
        {
            sBusiness = ((AppContext.Current.AppSettings["psQuoter.RepairOption.BusinessGroup.Option.NONE.ShowType"]) == "3" ? "NONE" : "%%").As<string>();
        }
        ////<CODE_TAG_100752>
        cmd.Parameters.Append(cmd.CreateParameter("BusinessGroup", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 10, sBusiness));


        //********************************** Work Application Default***************************************************************
        sWorkApplicationCode = Request.Form["cboWorkApplicationCode"];

        if (sWorkApplicationCode == null || sWorkApplicationCode == "")
        {
            sWorkApplicationCode = "%";
        }



        cmd.Parameters.Append(cmd.CreateParameter("WorkApplicationCode", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 10, sWorkApplicationCode.AsString()));
        cmd.Parameters.Append(cmd.CreateParameter("BusinessEntityId", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 0, AppContext.Current.BusinessEntityId));
        cmd.Parameters.Append(cmd.CreateParameter("EQtype", ADODB.DataTypeEnum.adSmallInt, ADODB.ParameterDirectionEnum.adParamInput, 0, eqType));
		cmd.Parameters.Append(cmd.CreateParameter("SNPrefix", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 20, sSNPrefix));    //<CODE_TAG_104228>
       
        rs = new Recordset();
        cmd.CommandTimeout = 600;
        rs = cmd.Execute();
        iAdminCheck = rs.Fields["AdminCheck"].Value.As<int?>();
        rs = rs.NextRecordset();

        //*************************************************************************************************************************
        Response.Write("<form method=\"post\" action id=\"frmTRG\" onkeyup=\"SubmitForm();\">");

        Response.Write("<div class=\"filters\">");
        Response.Write("<table border=\"0\" cellpadding=\"2\" cellspacing=\"1\" style=\"MARGIN-BOTTOM:5px\">");

        sShowStore = "none";
        sShowBusiness = "none";

        switch (rs.Fields["StoreBusinessCombo"].Value.As<string>())
        {
            case "0":
                break;
            case "1":
                sShowStore = "block";
                break;
            case "2":
                sShowBusiness = "block";
                break;
            default:
                break;
        }
        sSpecialChar = rs.Fields["SpecialChar"].Value.As<string>();

        sSpecialCharReplacement = rs.Fields["SpecialCharReplacement"].Value.As<string>();

        if (rs.Fields["WorkApplicationCodesShow"].Value.As<string>() == "2")
        {
            blnWorkApplicationCodesShow = true;
        }

        rs = rs.NextRecordset();

        //************** STORE COMBO **************
        if (sBusiness == "%%" && sStoreNo == "%%")
        {
            sStoreNo = sSpecialChar;
        }
        Response.Write("<tr id=\"rshl\" height=\"22\" style=\"display:" + sShowStore + ";\">");

        Response.Write("<td class=\"t11 tSb\" width=75>&nbsp;" + (string)GetLocalResourceObject("rkLbl_Shop_Rate") + "</td>");
        Response.Write("<td>");
        Response.Write("<select class=\"f w100\" tabindex=\"1\" name=\"cboStore\" id=\"cboStore\" onchange=\"frmTRG.submit()\">");
        Response.Write("<option value=\"\">&nbsp;</option>");

        while (!(rs.EOF))
        {
            sStoreNoRS = rs.Fields["StoreNo"].Value.As<string>();
            sText = sStoreNoRS;

            if (sStoreNoRS == sSpecialChar)
            {
                sText = sSpecialCharReplacement;
            }

            if (sStoreNo == sStoreNoRS && sShowStore != "none")
            {
                Response.Write("<option value=\"" + sStoreNoRS + "\" selected>" + sText);
            }
            else
            {
                Response.Write("<option value=\"" + sStoreNoRS + "\">" + sText);
            }

            rs.MoveNext();
        }
        Response.Write("</select>");
        Response.Write("</td>");
        Response.Write("</tr>");
        Response.Write("<tr height=\"22\">");

        rs = rs.NextRecordset();


        ////***************************Work Application COMBO********************************************

        if (blnWorkApplicationCodesShow)
        {
            Response.Write("<td class=\"t11 tSb\" width=200>&nbsp;" + (string)GetLocalResourceObject("rkLbl_Work_Application") + "</td>");
            Response.Write("<td>");
            Response.Write("<select class=\"f\" tabindex=\"1\" id=\"cboWorkApplicationCode\" name=\"cboWorkApplicationCode\" onchange=\"frmTRG.submit()\">");
            Response.Write("<option value=\"%%\">&nbsp;" + (string)GetLocalResourceObject("rkDrpDown_All") + "</option>");
            while (!(rs.EOF))
            {
                if (sWorkApplicationCode.Trim() == rs.Fields["WorkApplicationCode"].Value.As<string>().Trim())
                {
                    Response.Write("<option selected value=\"" + rs.Fields["WorkApplicationCode"].Value.As<string>() + "\" >" + rs.Fields["WorkApplicationDesc"].Value.As<String>() + " (" + rs.Fields["WorkApplicationCode"].Value.As<String>() + ")</option>");
                }
                else
                {
                    Response.Write("<option  value=\"" + rs.Fields["WorkApplicationCode"].Value.As<string>() + "\" >" + rs.Fields["WorkApplicationDesc"].Value.As<String>() + " (" + rs.Fields["WorkApplicationCode"].Value.As<String>() + ")</option>");
                }

                rs.MoveNext();
            }
            Response.Write("</select>");
            Response.Write("</td>");
        }
        //************** BUSINESS COMBO **************

        Response.Write("<td class=\"t11 tSb\" width=100 style=\"display:" + sShowBusiness + ";\">" + (string)GetLocalResourceObject("rkLbl_Business_Group") + "</td>");
        Response.Write("<td style=\"display:" + sShowBusiness + ";\">");
        Response.Write("<select  tabindex=\"1\" id=\"cboBusiness\" name=\"cboBusiness\" onchange=\"frmTRG.submit()\">");
        Response.Write("<option value=\"%%\">&nbsp;" + (string)GetLocalResourceObject("rkDrpDownValue_All") + "</option>");
        rs = rs.NextRecordset();
        while (!(rs.EOF))
        {
            if (sBusiness == rs.Fields["BusinessGroup"].Value.As<String>() && sShowBusiness != "none")
            {
                Response.Write("<option value=\"" + rs.Fields["BusinessGroup"].Value.As<String>() + "\" selected>" + rs.Fields["BusinessGroupDesc"].Value.As<String>() + " (" + rs.Fields["BusinessGroup"].Value.As<String>() + ")");
            }
            else
            {
                Response.Write("<option value=\"" + rs.Fields["BusinessGroup"].Value.As<String>() + "\">" + rs.Fields["BusinessGroupDesc"].Value.As<String>() + " (" + rs.Fields["BusinessGroup"].Value.As<String>() + ")");
            }
            rs.MoveNext();
        }
        Response.Write("</select>");
        Response.Write("</td>");

        Response.Write("<td  class=\"t11 tSb\">");%>
    <a href="javascript:void(0);" onclick="displayWaiting(); frmTRG.submit();">
        <%=(string) GetLocalResourceObject("rkLink_Submit")%></a>
    <%Response.Write("</td>");
      Response.Write("<td class=\"t11 tSb\" colspan=3 width=1000 align=\"right\">");
      if (iAdminCheck == 1 && PageMode == "" && AppContext.Current.AppSettings.IsTrue("psQuoter.RepairOption.ManualAddNew.Enabled"))
      {
          //Response.Write("<a href=default.aspx >"+(string) GetLocalResourceObject("rkLink_Setup_New_Model_SN_Range")+"</a>");
          Response.Write("<a href=\"RepairOptions_SetupNewModel.aspx\" >" + (string)GetLocalResourceObject("rkLink_Setup_New_Model_SN_Range") + "</a>");
      }
      Response.Write("</td>");
      /*
      oCmd = new ADODB.CommandClass();
      oCmd.ActiveConnection = LegacyHelper.OpenDataConnection();
      oCmd.CommandText = "Admin_EmailRecipients_List";
      oCmd.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
      oRsEmailRecipients = oCmd.Execute();
      if (!(oRsEmailRecipients.EOF))
      {
          ToName = "";
          ToEmail = "";
          while (!(oRsEmailRecipients.EOF))
          {
              ToEmail = ToEmail + oRsEmailRecipients.Fields["email"].Value.As<String>() + ";";
              ToName = ToName + oRsEmailRecipients.Fields["firstname"].Value.As<String>() + " " + oRsEmailRecipients.Fields["lastname"].Value.As<String>() + ", ";
              oRsEmailRecipients.MoveNext();
          }

      }
      */
      Response.Write("</tr>");
      Response.Write("<tr>");
      Response.Write("<td  class=\"t11 tSb\" style='white-space:nowrap'>");

      Response.Write("<input type='radio' name='eqType' " + ((eqType < 2 ) ? "checked" : "") + " onclick='eqTypeClick(1)'  value='1'> Model </input>");
      Response.Write("<input type='radio' name='eqType' " + ((eqType == 2) ? "checked" : "") + " onclick='eqTypeClick(2)' value='2'> FR Exchange </input>");
      Response.Write("<input type='radio' name='eqType' " + ((eqType == 3) ? "checked" : "") + " onclick='eqTypeClick(3)' value='3'> Both </input>");




      Response.Write("</td>");
      Response.Write("<td class=\"t11 tSb\">");
      Response.Write("<input name=\"txtModel\" id=\"txtModel\" runat=\"server\" Maxlength=\"" + ((eqType < 2) ? "10" : "20") + "\" style='width:" + ((eqType < 2) ? "80px" : "160px") + "; display:' class=\"f w100\" type=\"text\" value=\"");
      if (sModel != "%")
      {
          Response.Write(sModel);
      }
      Response.Write("\">");

    

      Response.Write("</td>");

      Response.Write("</tr>");
      Response.Write("</table>");
      Response.Write("</div>");

      //**************************************************************************************************************************
      if (eqType > 0)
        rs = rs.NextRecordset();

      if ((eqType & 2) > 0)
      {
          Response.Write("<table class=\"tbl\" cellspacing=\"1\"  cellpadding=\"2\" border=\"0\" width=\"100%\" style=\"margin-top:2px;border:none;border-collapse:separate;border-spacing:1px;\">");

          Response.Write("<tr height=\"20\" id=\"rshl\" class=\"thc\" >");
          Response.Write("<td width=340>&nbsp;FR Exchange</td>");
          Response.Write("<td></td>");
          Response.Write("</tr>");
          sColour = "white";
          iCounter = 0;

          while (!(rs.EOF))
          {
              recCount++;
              sEQM = rs.Fields["EquipManufCode"].Value.As<string>();
              sFRExchange = rs.Fields["FRExchange"].Value.As<string>("");
              sModel = rs.Fields["Model"].Value.As<string>("");
              sSNBegin = rs.Fields["SerialNoBegin"].Value.As<string>();
              //==========================================Repair Option Row==============================================
              if ((sEQM != sEQMOld || sFRExchange != sFRExchangeOld) && rs.Fields["Drill"].Value.As<int?>() > 0)
              {
                  sEQMOld = sEQM;
                  sFRExchangeOld = sFRExchange;
                  Response.Write("<tr valign=\"top\" class=\"t14 tSb\">");
                  Response.Write("<td width=\"50\">" + sFRExchange + "</td>");
                  Response.Write("<td class=\"t11\"><a href=\"javascript:void(0);\"  onclick=\"FrDrill('" + sFRExchange + "');\" style=\"cursor:hand;font-weight:normal\">" + (string)GetLocalResourceObject("rkLink_View") + "</a></td>");
                  Response.Write("</tr>");
              }
              //==========================================================================================================
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
          Response.Write("</table><br>");
      }

      if (eqType == 3)
          rs = rs.NextRecordset();
          
      //begin//<CODE_TAG_104228><L.W && R.Z>
      Response.Write("<script language=\"javascript\">");
      Response.Write("var drilldownSN; ");
      Response.Write("</script>");
      //<CODE_TAG_104228> end
      
      if ((eqType & 1) > 0)
      {
          Response.Write("<table class=\"tbl\" cellspacing=\"1\"  cellpadding=\"2\" border=\"0\" width=\"100%\" style=\"margin-top:2px;border:none;border-collapse:separate;border-spacing:1px;\">");

          Response.Write("<tr height=\"20\" id=\"rshl\" class=\"thc\" >");
          Response.Write("<td width=125>&nbsp;Model</td>");
          Response.Write("<td width=100>&nbsp;" + (string)GetLocalResourceObject("rkHeader_Begin_S_N") + "</td>");
          Response.Write("<td width=100>&nbsp;" + (string)GetLocalResourceObject("rkHeader_End_S_N") + "</td>");
          Response.Write("<td></td>");
          Response.Write("</tr>");
          sColour = "white";
          iCounter = 0;

          while (!(rs.EOF))
          {
              recCount++;
              sEQM = rs.Fields["EquipManufCode"].Value.As<string>();
              sFRExchange = rs.Fields["FRExchange"].Value.As<string>("");
              sModel = rs.Fields["Model"].Value.As<string>("");
              sSNBegin = rs.Fields["SerialNoBegin"].Value.As<string>();
              //==========================================Repair Option Row==============================================
              if ((sEQM != sEQMOld || sModel != sModelOld) && (rs.Fields["Drill"].Value.As<int?>() > 0))
              {
                  sEQMOld = sEQM;
                  sModelOld = sModel;

                  Response.Write("<tr valign=\"top\" class=\"t14 tSb\">");
                  Response.Write("<td width=\"50\">" + sModel + "</td>");

                  Response.Write("</tr>");
              }
                  if (rs.Fields["Drill"].Value.As<int?>() > 0)
                  {
                      Response.Write("<tr valign=\"top\" class=\"t11\"><td></td>");
                      Response.Write("<td width=\"50\">" + sSNBegin + "</td>");
                      Response.Write("<td width=\"50\">" + rs.Fields["SerialNoEnd"].Value.As<String>() + "</td>");
                      Response.Write("<td><a href=\"javascript:void(0);\"  onclick=\"Drill('" + sSNBegin + "','" + sModel + "');\" style=\"cursor:hand;\"  >" + (string)GetLocalResourceObject("rkLink_View") + "</a></td>");//<CODE_TAG_104228>
                      Response.Write("</tr>");
                  }
              
              //==========================================================================================================
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
          Response.Write("</table><br>");
          //begin//<CODE_TAG_104228><L.W && R.Z>
          
		  rs = rs.NextRecordset();
          Response.Write("<script language=\"javascript\">");
          //Response.Write("var drilldownSN; ");
		  if (!rs.EOF)
          {
 			 Response.Write(" drilldownSN=\"" +  ((rs.Fields["drilldownNow"].Value.As<int>() == 2) ? rs.Fields["SerialNoBegin"].Value.As<String>() : "")  + "\"" );
		  }
          Response.Write("</script>");
          //<CODE_TAG_104228> end
      }



      if (recCount == 0 && eqType > 0)
      {
          Response.Write("<table class=\"tbl\" cellspacing=\"1\"  cellpadding=\"2\" border=\"0\" width=\"100%\" style=\"margin-top:2px;border:none;border-collapse:separate;border-spacing:1px;\">");
          Response.Write("<tr><td class=\"t12 tSb\"><font color=\"red\">" + (string)GetLocalResourceObject("rkMsg_No_information_found") + "</font></td></tr>");
          Response.Write("</table><br>");
      }


      rs.Close();
      Util.CleanUp(cmd);

      Response.Write("<input type=\"hidden\" name=\"hdnOperation\" value=\"1\">");
      Response.Write("<input type=\"hidden\" name=\"hdnCheck\" value=\"0\">");
      Response.Write("<input type=\"hidden\" name=\"hdnStartRecordId\">");
      Response.Write("</form>");
    %>
    <script language="javascript">


function Search(){
	var iCancel = 0

	if (iCancel != 1){
		frmTRG.hdnOperation.value = 1
		frmTRG.submit();
		
	}
}

function SubmitForm(){
	var i = window.event.keyCode;
	if (i == 13){
		Search()
	}

}

function eqTypeClick(eqType)
{
    if (eqType == 1)
    {
         $("[id*=txtModel]").attr('maxlength','10');
         $("[id*=txtModel]").css('width','80px');
         $("[id*=txtModel]").val($("[id*=txtModel]").val().substring(0,10)  );
        

    }
    else
    {
         $("[id*=txtModel]").attr('maxlength','20');
         $("[id*=txtModel]").css('width','160px');


    }
}
function Drill(sSNBegin, sModel) {  //<CODE_TAG_104228>
	
		if ("<%= sMode %>" == "Add"){
			document.location.href = "<%=this.CreateUrl("modules/RepairOption/default.aspx", normalizeForAppending: true)%>Mode=Add&ROId=<%=iDBSROId%>&QuoteId=<%=iQuoteId%>&BGroup=" + encodeURIComponent(document.all["cboBusiness"].value) + "&SNBegin=" + encodeURIComponent(sSNBegin) + "&StoreNo=" + encodeURIComponent(document.all["cboStore"].value) + "&WorkAppCode=<%= Server.UrlEncode(sWorkApplicationCode) %>";		
		}
		else {
		    document.location.href = "<%=this.CreateUrl("modules/RepairOption/default.aspx", normalizeForAppending: true)%>ROId=<%=iDBSROId%>&BGroup=" + encodeURIComponent(document.all["cboBusiness"].value) + "&SNBegin=" + encodeURIComponent(sSNBegin) + "&Model=" + encodeURIComponent(sModel) + "&StoreNo=" + encodeURIComponent(document.all["cboStore"].value) + "&WorkAppCode=<%= Server.UrlEncode(sWorkApplicationCode) %>&TT=<%= TT %>&PageMode=<%= PageMode %>";	   //<CODE_TAG_104228>
		}
	
}


function FrDrill(sFR){
    document.location.href = "<%=this.CreateUrl("modules/RepairOption/default.aspx", normalizeForAppending: true)%>ROId=<%=iDBSROId%>&BGroup=" + encodeURIComponent(document.all["cboBusiness"].value) + "&sFR=" + encodeURIComponent(sFR) + "&StoreNo=" + encodeURIComponent(document.all["cboStore"].value) + "&WorkAppCode=<%= Server.UrlEncode(sWorkApplicationCode) %>&TT=<%= TT %>&PageMode=<%= PageMode %>";	
}


        function displayWaiting() {
            $("#div_Waiting").show();
            setTimeout("UpdateImg('img_Waiting','../../library/images/waiting.gif');", 50);
            return true;
        }

        function UpdateImg(ctrl, imgsrc) {
            $("#" + ctrl).attr("src", imgsrc);
        }

    </script>

     <div id="div_Waiting" style="position: absolute; left: 50%; top: 40%; display: none;">
        <img id="img_Waiting" src="../../library/images/waiting.gif" />
    </div>
    <script type="text/javascript" language="javascript">
        $(document).ready(function () {
            if (/iPhone|iPod|iPad/.test(navigator.userAgent))
            $('#wrapper').css({
                'overflow-y': 'scroll',
                'overflow-x': 'hidden',
                '-webkit-overflow-scrolling': 'touch',
                height: $(parent.document.getElementById("divStandardJobSearch")).height(),
                width: $(parent.document.getElementById("divStandardJobSearch")).width() 
            });
        });
		
        if (drilldownSN) Drill(drilldownSN);    //<CODE_TAG_104228>
    </script>
</asp:Content>
