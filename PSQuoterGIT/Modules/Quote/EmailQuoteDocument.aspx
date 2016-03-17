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
<%@ Import Namespace="System.Text" %> <%--CODE_TAG_104531--%>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:Content ID="cntMP" ContentPlaceHolderID="cntMP" runat="Server">
    <!--#include file="../../../DealerAppSettings/PSQuoter/DocumentGenerator/PSQReport.aspx"--><!--note here for developer back 5 level, for publish 3 level -->
    <script runat="server">
        
        protected void Page_Load(object sender, EventArgs e)
        {
            Parameter_QuoteId = Request.QueryString["QuoteId"].AsInt(0 );
            Parameter_Revision = Request.QueryString["Revision"].AsInt(0);
            string Parameter_Email = Request.QueryString["Email"];  <%--TICKET 23348--%>
            Parameter_Internal = Request.QueryString["Internal"].AsInt(0 );
            if (Parameter_Internal == 1) Parameter_Email=""; // <CODE_TAG_105294>
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
                Global_SalesrepEmail = drHeader["SREmail"].ToString();
            }
            
            if (!IsPostBack)
            {
                string sSubject = string.Format(AppContext.Current.AppSettings["psQuoter.Document.Email.Subject"], Global_QuoteNo, Global_CustomerName);

                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Document.Email.SendToCurrentUser"))
                {
                    sendemail(Global_SalesrepEmail, AppContext.Current.User.LogonUser.EMail, "", sSubject, "", true, true); 

                }
                else
                {
                    txtSubject.Text = sSubject; 
                    txtTo.Text = Parameter_Email;   <%--TICKET 23348--%>
                    //<CODE_TAG_103804>
                    if (AppContext.Current.AppSettings.IsTrue("psQuoter.Document.Email.CcToCurrentUser"))
                        txtCc.Text = AppContext.Current.User.LogonUser.EMail;
                        //</CODE_TAG_103804>
                }

                if ((AppContext.Current.AppSettings["psQuoter.Document.Email.AttachmentType"].AsInt(0) & 1) > 0)
                    chkPDF.Checked = true;

                if ((AppContext.Current.AppSettings["psQuoter.Document.Email.AttachmentType"].AsInt(0) & 2) > 0)
                    chkWord.Checked = true;

				// <CODE_TAG_104969>
				if (AppContext.Current.AppSettings.IsTrue("psQuoter.Document.Email.NotAllowSendToCustomer"))
				{
					divEmailInfo.Visible = false;
					divEmailSent.Visible = true;
					lblResult.Text ="The email has been sent successfully";
				}
				else
				{
					divEmailInfo.Visible = true;
					divEmailSent.Visible = false;
					lblResult.Text ="2222";
				}
				// </CODE_TAG_104969>                
                
            }
        }

     

        protected void BtnSend(object sender, EventArgs e)
        {
           // lblTest.Text = "OK";
            lblResult.Text = "Your email has been sent.";
            divEmailSent.Visible = true;
            divEmailInfo.Visible = false; 

            
            sendemail(Global_SalesrepEmail, txtTo.Text.Trim(), txtCc.Text.Trim(), txtSubject.Text.Trim(), txtMessage.Text.Trim(), chkPDF.Checked ? true : false, chkWord.Checked ? true : false);


        }

        private void sendemail(string sFromEmail, string sToEmail, string sCcEmail, string sSubject, string sMessage, bool attachPDF, bool attachWord)
        {
            string attachmentFiles = "";

            if (attachPDF)
            {
                attachmentFiles = GetReportDocumentFileName("PDF");
            }


            if (attachWord)
            {
                if (attachmentFiles != "") attachmentFiles += ",";
                attachmentFiles += GetReportDocumentFileName("WORD"); ;
            }

            //lblTest.Text = attachmentFiles;
            //<CODE_TAG_104531>
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.SendEmailWithSignature"))
            {
                sMessage += "<br/><br/><br/><br/><br/><br/>" + GetEmailSignature( Request.QueryString["UserId"].AsInt(0)); 
            }
            //</CODE_TAG_104531>
            SendEmailAttachment(sFromEmail, sToEmail, sCcEmail, sSubject, sMessage, attachmentFiles);
            
        }
        //GetUserSignatureInfo4Email
        //<CODE_TAG_104531>
        protected string GetEmailSignature( int UserId)
        {

            DataSet ds = new DataSet();
            StringBuilder sb = new StringBuilder();
            ds = DAL.Quote.GetUserSignatureInfoForEmail(UserId);
            DataRow dr = ds.Tables[0].Rows[0];
            //FirstName
            if (dr["FirstName"] != DBNull.Value)
                sb.Append(dr["FirstName"].ToString() + " ");
            else
                sb.Append(" ");
            //LastName
            if (dr["LastName"] != DBNull.Value)
                sb.Append(dr["LastName"].ToString() + "<br/>");
            else
                sb.Append("<br/>");
            //Title
            if (dr["Title"] != DBNull.Value)
                sb.Append(dr["Title"].ToString() + "<br/>");
            else
                sb.Append("<br/>");
            //Company
            if (dr["Company"] != DBNull.Value)
                sb.Append(dr["Company"].ToString() + "<br/>");
            else
                sb.Append("<br/>");
            //HomePhone
            if (dr["HomePhone"] != DBNull.Value)
                sb.Append("O: " + dr["HomePhone"].ToString() + "<br/>");
            else
                sb.Append("O: <br/>");
            //MobilePhone
            if (dr["MobilePhone"] != DBNull.Value)
                sb.Append("C: " + dr["MobilePhone"].ToString() + "<br/>");
            else
                sb.Append("C: <br/>");

            sb.Append("<br/>");    
            //Note: Specific to dealer here (Cashman here below)

            sb.Append("<span style=\"font-family: Arial;font-size:12pt;\"><strong>Our Core Values:</strong></span><br>");

            sb.Append("<span style=\"font-family: Arial;font-size:12pt;\"><strong>C</strong></span>");
            sb.Append("<span style=\"font-family: Arial;font-size:12pt;\">ommunicators. </span>");

            sb.Append("<span style=\"font-family: Arial;font-size:12pt;\"><strong>A</strong></span>");
            sb.Append("<span style=\"font-family: Arial;font-size:12pt;\">ccountable. </span>");

            sb.Append("<span style=\"font-family: Arial;font-size:12pt;\"><strong>S</strong></span>");
            sb.Append("<span style=\"font-family: Arial;font-size:12pt;\">afe. </span>");

            sb.Append("<span style=\"font-family: Arial;font-size:12pt;\"><strong>M</strong></span>");
            sb.Append("<span style=\"font-family: Arial;font-size:12pt;\">entors. </span>");

            sb.Append("<span style=\"font-family: Arial;font-size:12pt;\"><strong>A</strong></span>");
            sb.Append("<span style=\"font-family: Arial;font-size:12pt;\">daptable. </span>");

            sb.Append("<span style=\"font-family: Arial;font-size:12pt;\"><strong>N</strong></span>");
            sb.Append("<span style=\"font-family: Arial;font-size:12pt;\">ow – </span>");

            sb.Append("<span style=\"font-family: Arial;font-size:12pt; color:#29486d\"><strong>Right Now!</strong></span><br>");


        
            return sb.ToString();
        }
        //</CODE_TAG_104531>

        protected void SendEmailAttachment(string sFromEmail, string sToEmail, string sCcEmail, string sSubject, string sMessage, string sAttachments)
        {

            string sTo = sToEmail.Trim();
            string sCc = sCcEmail.Trim();
            string[] aAttachments;
            char[] separator = new char[1];
            separator[0] = ',';
            int i = 0;
            string sFileName = "";
            int iPos = 0;

            if (sTo != "")
            {
                string mailFrom;

                if (AppContext.Current.AppSettings["psQuoter.Document.Email.From.Source"].Trim() == "2")
                    mailFrom = System.Configuration.ConfigurationManager.AppSettings["mail.from"];
                else
                    mailFrom = sFromEmail;

                // mailFrom = "wang@canamsolutionsinc.com";///////

                MailMessage mail = new MailMessage(mailFrom, sToEmail);

                mail.Subject = sSubject;
                //<CODE_TAG_104531>
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.SendEmailWithSignature"))
                {
                    mail.IsBodyHtml = true;  
                }
                //</CODE_TAG_104531>
                if (sCc != "")
                {
                    mail.CC.Add(sCc); 
                }

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

                //  lblTest.Text = System.Configuration.ConfigurationManager.AppSettings["mail.smtpServer"];
            }

        }
    </script>
    <asp:Label ID="lblTest" runat="server"></asp:Label>
    
    <div id="divEmailInfo" runat="server">
        <table width="600px">
            <tr>
                <td style="width: 10%">
                    To:<span style="color: red">*</span>
                </td>
                <td style="width: 90%">
                    <asp:TextBox ID="txtTo" ClientIDMode="Static" Style="width: 90%" runat="server"></asp:TextBox>

                </td>
            </tr>
            <tr>
                <td>
                    Cc:
                </td>
                <td>
                    <asp:TextBox ID="txtCc" ClientIDMode="Static" Style="width: 90%" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    Subject:<span style="color: red">*</span>
                </td>
                <td>
                    <asp:TextBox ID="txtSubject" ClientIDMode="Static" Style="width: 90%" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    Attachment:
                </td>
                <td>
                    <asp:CheckBox ID="chkPDF" ClientIDMode="Static" runat="server" Text="" />
                    <img src="../../Library/images/icon_doctype_pdf.gif" />
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <!--CODE_TAG_104248--><!--control to hide the customer word document output-->
                    <% if (Parameter_Internal == 0)  { %> <!--customer email-->
                        <%--<% if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Print.Document.Format.Word.Hide.Customer") ) {%> <CODE_TAG_104583>--%> <!--customer word doc not hide-->
                        <% if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Email.Document.Format.Word.Hide.Customer") ) {%> <!--customer word doc not hide-->
                        <asp:CheckBox ID="chkWord" ClientIDMode="Static" runat="server" Text="" />
                        <img src="../../Library/images/icon_doctype_word.gif" />
                        <% } %>

                    <% }%>
                    <% else {   %> <!--internal email-->
                        <% if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Print.Document.Format.Word.Hide.Internal") ) {%> <!--internal word doc not hide-->
                        <asp:CheckBox ID="CheckBox1" ClientIDMode="Static" runat="server" Text="" />
                        <img src="../../Library/images/icon_doctype_word.gif" />
                        <% } %>
                    <%} %>


                    <!--/CODE_TAG_104248-->
                </td>
            </tr>
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
                    <asp:Button ID="btnSend" runat="server"  Text="send" OnClientClick="return validateSubmit();"
                        OnClick="BtnSend" />
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="button" onclick="parent.closeEmail();" value="Cancel" />
                </td>
            </tr>
        </table>
    </div>
    <div id="divEmailSent" runat="server" ><!--CODE_TAG_104969-->
        <table>
            <tr>
                <td>
                    <img src="../../library/images/SendEmail.gif" />
                </td>
                <td>
                    <asp:Label ID="lblResult" runat="server" ></asp:Label><!--CODE_TAG_104969-->
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center; ">
                    <button onclick="parent.closeEmail();" Class="t11b">close</button>
                </td>
            </tr>
        </table>
    </div>
    <script type="text/javascript">
        var objFocus; //<CODE_TAG_103610>
        function validateSubmit() {
            var rt = true;
            if ($.trim($("#txtTo").val()) == "") {
                alert("TO field cannot left blank.");
                rt = false;
            }

            if ($.trim($("#txtSubject").val()) == "") {
                alert("Subject field cannot left blank.");
                rt = false;
            }
            //<CODE_TAG_103610>
            if (!validateEmailAddress()) {
                alert("Invalid Email Address.");
                rt = false;
                $(objFocus).focus();  
            }

            //</CODE_TAG_103610>
                
            return rt;

        }

        //<CODE_TAG_103610>
        function validateEmailAddress() {
            //--Get the controls
            var txtTo = $("#txtTo").val();
            var txtCc = $("#txtCc").val();

            //--validate email address using regex
            var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;

            //--validate to allow only numbers

            if ( reg.test(txtTo) == false) {
                objFocus = "#txtTo";
                return false;
            }
            else if (txtCc!="" &&  reg.test(txtCc) == false) { //txtCC allow empty
                objFocus = "#txtCc";
                return false;
            }
            return true;
        }

        //</CODE_TAG_103610>  
    
    </script>
</asp:Content>
