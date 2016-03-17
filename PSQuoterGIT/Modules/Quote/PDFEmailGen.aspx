<%@ Page Language="C#" 
AutoEventWireup="true" 
CodeFile="~/Modules/Quote/PDFEmailGen.aspx.cs" 
Inherits="PDFEmailGen"
MasterPageFile="~/library/masterPages/_base.master"
%>
 <%@ Import Namespace="X.Data" %>
<%@ Import Namespace="System.Data" %>

<asp:Content ID="cntMP" ContentPlaceHolderID="cntMP" Runat="Server">	
<script language="javascript">

    function window_close() {
        parent.closeEmail();
        // window.close();
    }

</script>


            <asp:PlaceHolder id="phForm" runat="server">
                <TR>
						<TD class="t11b" CssClass="fe275">To:<FONT color="red">*</FONT></TD>
						<TD class="t11b">
                            <asp:TextBox id="tbTo" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" CssClass="t10" ErrorMessage="<-Required" display="Dynamic" ControlToValidate="tbTo"></asp:RequiredFieldValidator>
                            <BR />
                        </TD>
                </TR>
                <TR>
						<TD class="t11b">Cc:</TD>
						<TD><asp:TextBox id="tbCC" runat="server" CssClass="fe275"></asp:TextBox></TD>
                        <BR />
                </TR>

                <TR>
						<TD class="t11b">Subject:<FONT color="red">*</FONT></TD>
						<TD class="t11b">
							<asp:TextBox id="tbSubject" runat="server" CssClass="fe275" ></asp:TextBox>
							<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" CssClass="t10" ErrorMessage="<-Required"
								Display="Dynamic" ControlToValidate="tbSubject"></asp:RequiredFieldValidator>
                                <BR />
                         </TD>
				</TR>

                <TR>
						<TD class="t11b">Attachment:</TD>
						<TD class="t11"><asp:HyperLink id="hlPDF" runat="server" Target="_blank"></asp:HyperLink></TD>
                        <BR />
				</TR>
                <tr>
						<td></td>
						<td></td>
				</tr>

                <TR>
						<TD class="t11b" vAlign="top">Message:</TD>
                        <BR />
						<TD class="t11b"><asp:TextBox id="tbBody" CssClass="t11" runat="server" TextMode="MultiLine" Columns="51" Rows="14"></asp:TextBox>
                        </TD>
                        <BR />
				</TR>

                <TR>
						<TD></TD>
						<TD class="t11b">
							<asp:Button id="btSendEmail" runat="server" CssClass="t11b" Text="Send" OnClick="BtnSend"></asp:Button>
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<button onclick="parent.closeEmail();" Class="t11b">Cancel</button>
                          </TD>
				</TR>

            </asp:PlaceHolder>

            <asp:PlaceHolder id="phResult" runat="server" Visible="False">
					<TR>
						<TD align="center" width="410" colspan="2"><BR>
							<BR />
							<BR />
							<BR />
							<asp:Label id="lbResult" runat="server"></asp:Label>
                        </TD>
					</TR>
			</asp:PlaceHolder>
</asp:Content>



