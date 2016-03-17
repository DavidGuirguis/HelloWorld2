<%@ Page Title="" Language="C#" MasterPageFile="~/Library/MasterPages/iFrame.master"
    EnableEventValidation="false" AutoEventWireup="true" CodeFile="CloseQuote.aspx.cs"
    Inherits="quoteClose" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMP" runat="Server">        
    <table style=" margin-left:20px; margin-top:20px; padding:2px;" width="80%">
        <tr>
            <td class="fe">
                Choose Revision to <%=quoteCloseStatusDesc %>:
            </td>
        </tr>
        <tr>
            <td class="fe">
                <asp:RadioButtonList ID="rdlistQuoteRevisionList" 
                    runat="server" 
                    AutoPostBack="false"
                    Repeatdirection="Vertical"
                    RepeatLayout="Table"
                    TextAlign="right"
                    CssClass="promptMessage"                    
                >                    
                </asp:RadioButtonList>   
            </td>
        </tr>
        <tr>
			<td style="padding-top:20px">
				<asp:checkbox id="chkCreateTicket" runat="Server" Checked="false" text="Create Service Link ticket" />
			</td>
		</tr>
        <tr>
            <td align="right">
                <br />
                <asp:Button ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click"  OnClientClick="return btnSubmit_clientClick();" />
                <input type="button" value="Cancel" onclick="btnCancel_onclick();" />
            </td>
        </tr>
    </table>
	<asp:HiddenField ID="hidCreateTicket" Value="0" runat="server" />
    <asp:HiddenField ID="hidRefreshParent" Value="" runat="server" />
    <script language="javascript">
        $(function () {
            if ($('[id*=hidRefreshParent]').val() == "1")
                parent.document.location.href = parent.document.location.href;
            //parent.refreshPage();                
        });
		function btnSubmit_clientClick()
		{

			return true;
		}
        function btnCancel_onclick() {
            parent.closeChangeQuoteStatus();
        }
    </script>
</asp:Content>
