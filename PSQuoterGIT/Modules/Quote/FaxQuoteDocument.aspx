<%@ Page Language="c#" Inherits="UI.Abstracts.Pages.Popup" MasterPageFile="~/library/masterPages/_base.master" %>

<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Web.UI" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="Microsoft.Reporting.WebForms" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="X.Data" %>
<%@ Import Namespace="System.Net.Mail" %>
<%@ Import Namespace="System.Net.Mime" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="cntMP" ContentPlaceHolderID="cntMP" runat="Server">
    <!--#include file="../../../PSQIncludes/PSQReport.aspx"-->
    <script runat="server">
        
        protected void Page_Load(object sender, EventArgs e)
        {
            Parameter_QuoteId = Request.QueryString["QuoteId"].AsInt(0 );
            Parameter_Revision = Request.QueryString["Revision"].AsInt(0);
            string Parameter_Fax = Request.QueryString["Fax"]; 
            Parameter_Internal = Request.QueryString["Internal"].AsInt(0 );
            Parameter_CustomerNo = Request.QueryString["CustomerNo"];
            Parameter_UserId = Request.QueryString["UserId"].AsInt(0);

            DataSet dsHeader = DAL.Quote.QuoteHeaderGet(Parameter_QuoteId, Parameter_Revision,0);

            foreach (DataTable dt in dsHeader.Tables)
            {
                if (dt.Rows.Count > 0)
                {
                    dt.TableName = dt.Rows[0]["RS_Type"].ToString();
                }
            }

            DataRow drHeader = null;
            if (dsHeader.Tables.Contains("QuoteHeader"))
            {
                drHeader = dsHeader.Tables["QuoteHeader"].Rows[0];
            }

            if (drHeader != null)
            {
                Global_QuoteNo = drHeader["QuoteNo"].ToString();
                Global_CustomerName = drHeader["CustomerName"].ToString();
//                Global_SalesrepFax = drHeader["SalesRepFaxNo"].ToString();
            }
            
            if (!IsPostBack)
            {
                string sSubject = string.Format(AppContext.Current.AppSettings["psQuoter.Document.Email.Subject"], Global_QuoteNo, Global_CustomerName);

                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Document.Email.SendToCurrentUser"))
                {
                    sendFax(AppContext.Current.User.LogonUser.FullName, AppContext.Current.User.LogonUser.EMail, Parameter_Fax, "", "", ""); 
                }
                else
                {
                    txtSubject.Value = sSubject; 
                    txtTo.Text = Parameter_Fax;  
                }
                
            }
        }

     

        protected void BtnSend(object sender, EventArgs e)
        {
            lblResult.Text = "Your fax has been sent.";
            divFaxSent.Visible = true;
            divFaxInfo.Visible = false; 


            sendFax(AppContext.Current.User.LogonUser.FullName, AppContext.Current.User.LogonUser.EMail,txtTo.Text.Trim(),txtMessage.Text.Trim(),"","");

        }

        private void sendFax(string sFromName, string sFromEmail, string sToEmail, string sMessage, string sBillingCode1, string sBillingCode2)
        {
            string attachmentFiles = GetReportDocumentFileName("PDF");
            string sSubject = txtSubject.Value;
            SendFaxAttachment(sFromName,sFromEmail, sToEmail, sSubject, sMessage, attachmentFiles,sBillingCode1,sBillingCode2);
        }

        protected void SendFaxAttachment(string sFromName, string sFromEmail, string sFaxNo, string sSubject, string sMessage, string sAttachments, string sBillingCode1,string sBillingCode2)
        {

            sFaxNo = sFaxNo.Trim();
	        sFaxNo =sFaxNo.Replace("(","");
	        sFaxNo = sFaxNo.Replace(")","");
	        sFaxNo = sFaxNo.Replace("-","");
	        sFaxNo = sFaxNo.Replace(" ","");
	        sFaxNo = sFaxNo.Replace(",",";");

            if (sFaxNo[sFaxNo.Length - 1] == ';')  sFaxNo = sFaxNo.Substring(sFaxNo.Length-1);

	        string[] aFaxNo = sFaxNo.Split(';');
            string[] aAttachments;
            char[] separator = new char[1];
            separator[0] = ',';
            int i = 0;
            string sFileName = "";




            if (AppContext.Current.AppSettings["psQuoter.Document.Email.From.Source"].Trim() == "2")
                sFromEmail = System.Configuration.ConfigurationManager.AppSettings["mail.from"];
            
            foreach(string faxNo in aFaxNo)
            {
            
		        if ((faxNo.Length == 10) || (faxNo.Length == 11)) 
                {
			        //'*****Create Fax To String*****
			        var sTo = "FAX=" + faxNo ;
			        if (sBillingCode1 != "") sTo = sTo + "/dd.bi1=" + sBillingCode1 ;
			        if (sBillingCode2 != "") sTo = sTo + "/dd.bi2=" + sBillingCode2 ;
			        sTo = sTo + "@fax.toromont.com" ;               
                	if (sTo != "")
                    {
                        MailMessage mail = new MailMessage(sFromEmail, sTo);
                        mail.Subject = sSubject;
                        mail.Body = sMessage;
                        aAttachments = sAttachments.Split(separator[0]);
                        if (aAttachments.Length >= 1)
                        {
                            for (i = 0; i < aAttachments.Length; i++)
                            {
                                sAttachments = aAttachments[i].Trim();
                                //attachments
                                if (sAttachments != "")
                                {
                                    Attachment attachPDF = new Attachment(sAttachments, MediaTypeNames.Application.Pdf);
                                    mail.Attachments.Add(attachPDF);
                                }
                            }
                        }
                        //send the email
                        System.Net.Mail.SmtpClient msgClient = new SmtpClient(System.Configuration.ConfigurationManager.AppSettings["mail.smtpServer"]);
                        msgClient.Send(mail);
                        msgClient = null;
			        }//end of (sTo != "")

                }//end of ((faxNo.Length == 10) || (faxNo.Length == 11))
                else
                lblResult.Text = faxNo + " is not a valid fax number.";
            } //end of for
        }
    </script>
    <asp:Label ID="lblTest" runat="server"></asp:Label>
    <div id="divFaxInfo" runat="server">
        <table width="600px">
            <tr>
                <td style="width: 10%">
                    Fax # :<span style="color: red">*</span>
                </td>
                <td style="width: 90%">
                    <asp:TextBox ID="txtTo" ClientIDMode="Static" Style="width: 90%" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:HiddenField ID="txtSubject" Value="" ClientIDMode="Static" runat="server"></asp:HiddenField>
                </td>
            </tr>
<%--            <tr>
                <td>
                    Attachment:
                </td>
                <td>
                    <asp:CheckBox ID="chkPDF" ClientIDMode="Static" runat="server" Text="" />
                    <img src="../../Library/images/icon_doctype_pdf.gif" />
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:CheckBox ID="chkWord" ClientIDMode="Static" runat="server" Text="" />
                    <img src="../../Library/images/icon_doctype_word.gif" />
                </td>
            </tr>--%>
            <tr>
                <td style="vertical-align: top">
                    Message:
                </td>
                <td>
                    <asp:TextBox ID="txtMessage" runat="server" ClientIDMode="Static" Style="width: 90%"
                        TextMode="MultiLine" Rows="10"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center;vertical-align:bottom ; height:50px">
                    <asp:Button ID="btnSend" runat="server"  Text="OK" OnClientClick="return validateSubmit();"
                        OnClick="BtnSend" />
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="button" onclick="parent.closeFax();" value="Cancel" />
                </td>
            </tr>
        </table>
    </div>
    <div id="divFaxSent" runat="server" visible ="false" >
        <table>
            <tr>
                <td>
                    <img src="../../library/images/SendEmail.gif" />
                </td>
                <td>
                    <asp:Label ID="lblResult" runat="server" Text="2222"></asp:Label>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center; ">
                    <button onclick="parent.closeFax();" Class="t11b">close</button>
                </td>
            </tr>
        </table>
    </div>
    <script type="text/javascript">
        function validateSubmit() {
            var rt = true;
            if ($.trim($("#txtTo").val()) == "") {
                alert("TO field cannot left blank.");
                rt = false;
            }
            return rt;
        }
    
    </script>
</asp:Content>
