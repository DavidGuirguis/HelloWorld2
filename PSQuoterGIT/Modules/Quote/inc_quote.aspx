<%@ Import Namespace = "ADODB" %>
<%@ Import Namespace="nce.scripting" %>
<%@ Import Namespace="X.Configuration" %>
<script language="C#" runat="server">

    bool IsNullOrEmpty = false;
    int?/*DONE:replace 'object' with proper type*/ sNewQuoteNo = null;
    int? iNewQuoteId = null;
    string/*DONE:replace 'object' with proper type*/ sCustomerNo = null;
    string sCustName = null;
    int? iRV = 0;
    string strReload = null;
    string strError = null;
    string strMsgTitle = null;
    string strPageTitle = null;
    const bool LogNotificationSent_YES = true;
    const bool LogNotificationSent_NO = false;
    const int qs_Open = 1;
    const int qs_Submitted = 2;
    const int qs_Won = 4;
    //Old value:3
    const int qs_Lost = 8;
    //Old value:4
    const int qs_Cancelled = 16;
    ADODB.CommandClass cmd1 = null;
    ADODB.Connection cnn = null;
    //string sDivision = null;
    string strEmail = null;
    string sType = null;
    private string alert = null;
    //Old value:5
    
     void SendNotification(bool blnLogNotificationSent, int? iQuoteId, int? sQuoteNo, string sType, string sCustomerNo, string sCustomerName, string sDivision) 
    {
        //ADODB.Command cmd = null;
        ADODB.Recordset rs = null;
        int Idx = 0;
        string sTo = null;
        string /*DONE:replace 'object' with proper type*/ sCc = null;
        string/*DONE:replace 'object' with proper type*/ sBcc = null;
        string sFrom = null;
        string sSubject = null;
        string sBody = null;
        string sAlert = null; 
        cmd1 = new ADODB.CommandClass();
        cmd1.ActiveConnection = LegacyHelper.OpenDataConnection();
        cmd1.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
        //************************************************************************************************
        cmd1.CommandText = "dbo.TRG_List_PSSRsByCustomer";
        cmd1.Parameters.Append(cmd1.CreateParameter("CustomerNo", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInput, 20, sCustomerNo));
        cmd1.Parameters.Append(cmd1.CreateParameter("Division", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamInput, 1, sDivision));
        cmd1.Parameters.Append(cmd1.CreateParameter("UserId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 4, WebContext.User.IdentityEx.UserID));
        rs = new Recordset();
        rs = cmd1.Execute();
        while(!(rs.EOF))
        {
            sTo = sTo + rs.Fields["Email"].Value.As<string>() + ";";
            sAlert = sAlert + rs.Fields["FirstName"].Value.As<string>() + " " + rs.Fields["LastName"].Value.As<string>() + ";";
            rs.MoveNext();
        }
        rs.Close();
        rs = null;
        if ((sTo.IsNullOrWhiteSpace()))
        {
            return ;
        }
        if (blnLogNotificationSent)
        {
        }
         cmd1.Parameters.Clear();        
        for(Idx = 1; Idx <= cmd1.Parameters.Count; Idx += 1) 
            {
                cmd1.Parameters.Clear();/*DONE:review - check if any cmd.Parameters.Delete(0) left for deletion*/
            }       
            
           cmd1.CommandText = "dbo.TRG_Edit_EmailSent";
            cmd1.Parameters.Append(cmd1.CreateParameter("QuoteId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, iQuoteId));
            cmd1.Execute();
            cmd1.Parameters.Clear();/*DONE:review - check if any cmd.Parameters.Delete(0) left for deletion*/    
            
            sFrom = strEmail.ToLower();  /*DONE:review if type conversion if necessary - was 'Convert.ToString'*/
        sSubject = (string)GetLocalResourceObject("rkHeaderText_TRGQuote") + sQuoteNo;  /*DONE:review if type conversion if necessary - was 'Convert.ToString'*/
        sBody = "<html><body><span style='font-family: arial; font-size: 11px;'>";
        sBody = sBody + "<b>"+(string)GetLocalResourceObject("rkHeaderText_QuoteNo")+"&nbsp;</b>" + sQuoteNo/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ + "<br>";
        sBody = sBody + "<b>"+(string)GetLocalResourceObject("rkHeaderText_Customer")+"&nbsp;</b>" + sCustomerNo/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ + " - " + sCustomerName/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ + "<br>";
        sBody = sBody + "<b>"+(string)GetLocalResourceObject("rkHeaderText_CreatedBy")+"&nbsp;</b>" + WebContext.User.IdentityEx.FirstName/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ + " " + WebContext.User.IdentityEx.LastName/*DONE:review if type conversion if necessary - was 'Convert.ToString'*/ + "<br>";
        sBody = sBody + "<br><br>"+(string)GetLocalResourceObject("rkHeaderText_ViewTheQuoteClick")+"<a href='http";  
       
        if ((Request.ServerVariables["HTTPS"]).ToUpper() == "ON")
        {
            sBody = sBody + "s";
        }
        sBody = sBody + "://" + Request.ServerVariables["SERVER_NAME"] + "/PSQuoter/modules/quote/quote.aspx" + "&QuoteId=" + iQuoteId + "&Type=" + sType + "'><b>"+(string)GetLocalResourceObject("rkHeaderText_Here")+"</b></a>";
        sBody = sBody + "</span>";
        alert = Util.SendEmail(sTo, sCc, sBcc, sFrom, sSubject, sBody, sAlert);
        Response.Write(alert);

    }


    void CopyQuote(string quoteId, string newQuoteNo) 
    {
        string sDivision = null;
        cmd1 = new ADODB.CommandClass();
        cmd1.ActiveConnection = LegacyHelper.OpenDataConnection();
        cmd1.CommandText = "dbo.TRG_Add_CopyQuote";
        cmd1.CommandType = ADODB.CommandTypeEnum.adCmdStoredProc;
        cmd1.Parameters.Append(cmd1.CreateParameter("ReturnValue", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamReturnValue, 0, 0));
        cmd1.Parameters.Append(cmd1.CreateParameter("NewQuoteNo", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamInputOutput, 20, newQuoteNo));
        cmd1.Parameters.Append(cmd1.CreateParameter("OldQuoteId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, quoteId));
        cmd1.Parameters.Append(cmd1.CreateParameter("UserId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamInput, 0, WebContext.User.IdentityEx.UserID));
        cmd1.Parameters.Append(cmd1.CreateParameter("NewQuoteId", ADODB.DataTypeEnum.adInteger, ADODB.ParameterDirectionEnum.adParamOutput, 0, 0));
        cmd1.Parameters.Append(cmd1.CreateParameter("CustomerNo", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamOutput, 20, 0));
        cmd1.Parameters.Append(cmd1.CreateParameter("CustomerName", ADODB.DataTypeEnum.adVarWChar, ADODB.ParameterDirectionEnum.adParamOutput, 60, 0));
        cmd1.Parameters.Append(cmd1.CreateParameter("Division", ADODB.DataTypeEnum.adWChar, ADODB.ParameterDirectionEnum.adParamOutput, 1, null));
        cmd1.Execute();
        sNewQuoteNo = cmd1.Parameters["NewQuoteNo"].Value.As<int?>();
        iNewQuoteId = cmd1.Parameters["NewQuoteId"].Value.As<int?>();

        sCustomerNo = cmd1.Parameters["CustomerNo"].Value.As<string>();

      
        sCustName = cmd1.Parameters["CustomerName"].Value.As<string>();
        sDivision = cmd1.Parameters["Division"].Value.As<string>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/;
        //If duplicate quote number
        iRV = cmd1.Parameters["ReturnValue"].Value.As<int?>()/*DONE:review data type conversion - convert to proper type or remove 'As' method if redendant*/;
        if (iRV == 1)
        {
            strError = newQuoteNo + (string)GetLocalResourceObject("rkMsg_Error");
            strMsgTitle = (string)GetLocalResourceObject("rkMsg_CannotCopyQuote");
            strPageTitle = (string)GetLocalResourceObject("rkMsg_CopyError");
        }
        else
        {
            cmd1.Parameters.Clear();/*DONE:review - check if any cmd.Parameters.Delete(0) left for deletion*/
            //**********************************SEND EMAIL*************************************************/
            //fxiao, 2010-02-10::Quote notification - Check if key is on 
            if (BitMaskBoolean.IsTrue(AppContext.Current.AppSettings["psQuoter.Quote.Notification.SendOnCopyingQuote"], true))
            {
                SendNotification(LogNotificationSent_NO, iNewQuoteId, sNewQuoteNo, sType, sCustomerNo, sCustName, sDivision);
            }
            
            strReload = "<"+ "script" + " language=javascript>\r\n";
            strReload = strReload + "window.document.location.href = \"" + this.CreateUrl("modules/quote/quote.aspx", normalizeForAppending:true) + "QuoteId=" + iNewQuoteId + "&Type=Q" + "\";\r\n";
            strReload = strReload + "<"+ "/" + "script" + ">";
            Response.Write(strReload);
        }
        Util.CleanUp(cmd: cmd1);
    }

    string GetQuoteLogoUrl(string strDivision, string strBranchNo, string strFileExtName) 
    {
        string GetQuoteLogoUrl = null;/*DONE:review - check if it's using correct type*/
        string strLogoUrlPrefix = null;/*DONE:review - check if it's using correct type*/
        FileSystemObject oFS = null;
        strLogoUrlPrefix = (ConfigurationManager.AppSettings["url.siteRootPath"]) + "DealerAppSettings/PSQuoter/Library/Images/QuoteLogoSmall";
        //strLogoUrlPrefix = "/" + "DealerAppSettings/PSQuoter/Library/Images/QuoteLogoSmall";
        strFileExtName = "." + strFileExtName;

        oFS = new FileSystemObject();
        
        if (oFS.FileExists(Server.MapPath(strLogoUrlPrefix + "_branch_" + strBranchNo + strFileExtName)))
        {
           GetQuoteLogoUrl = "/DealerAppSettings/PSQuoter/Library/Images/QuoteLogoSmall_branch_" + strBranchNo + strFileExtName;
        }
        else
        {
                if (oFS.FileExists(Server.MapPath(strLogoUrlPrefix + "_" + strDivision + strFileExtName)))
                {
                    GetQuoteLogoUrl = "/DealerAppSettings/PSQuoter/Library/Images/QuoteLogoSmall_" + strDivision + strFileExtName;
                    }
                else
                {
                    GetQuoteLogoUrl = "/DealerAppSettings/PSQuoter/Library/Images/QuoteLogoSmall" + strFileExtName;
                    }
         }
        oFS = null;

       

        return GetQuoteLogoUrl;
        
    }

    string GetQuoteWatermarkUrl(string strDivision, string strFileName, string strFileExtName) 
    {
        string GetQuoteWatermarkUrl = null;
        string strWatermarkUrlPrefix = null;
        FileSystemObject oFS = null;
        strWatermarkUrlPrefix = (ConfigurationManager.AppSettings["url.siteRootPath"]) + "DealerAppSettings/PSQuoter/Library/Images/" + strFileName;
        strFileExtName = "." + strFileExtName;

        oFS = new FileSystemObject();
        
        if (oFS.FileExists(strWatermarkUrlPrefix + "_" + strDivision + strFileExtName))
        {
            //Division specific
            GetQuoteWatermarkUrl = "/DealerAppSettings/PSQuoter/Library/Images/" + strFileName + "_" + strDivision + strFileExtName;
            }
        else
        {
            //Fallback
            GetQuoteWatermarkUrl = "/DealerAppSettings/PSQuoter/Library/Images/" + strFileName + strFileExtName;
            }

        oFS = null;

        return GetQuoteWatermarkUrl;
        
    }

</script>


