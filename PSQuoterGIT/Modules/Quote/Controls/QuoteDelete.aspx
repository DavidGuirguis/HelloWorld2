<%@ Page Title="" Language="C#" MasterPageFile="~/Library/MasterPages/iFrame.master"
    EnableEventValidation="false" AutoEventWireup="true" CodeFile="QuoteDelete.aspx.cs"
    Inherits="quoteDelete" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMP" runat="Server">        
    <table style=" margin-left:20px; margin-top:20px; padding:2px;" width="80%">
        <tr>
            <td>
                <asp:RadioButtonList ID="rdlistQuoteDeleteOptions" 
                    runat="server" 
                    AutoPostBack="false"
                    Repeatdirection="Vertical"
                    RepeatLayout="Table"
                    TextAlign="right"
                    CssClass="promptMessage"                    
                >
                    <%--1: Quote; 2: Opportunity --%>
                    <asp:ListItem Text="I'd like to delete Quote and Opportunity." Value="3" Selected="True"/>
                    <asp:ListItem Text="I want to delete Quote only" Value="1"/>
                </asp:RadioButtonList>   
            </td>
        </tr>
        <tr>
            <td align="right">
                <br />
                <asp:Button ID="btnDelete" runat="server" Text="Delete" OnClick="btnDelete_Click" />
                <input type="button" value="Cancel" onclick="btnCancel_onclick();" />
            </td>
        </tr>
    </table>    
    <asp:HiddenField ID="hidParentRedirect" Value="" ClientIDMode="static" runat="server" />
    <script language="javascript">        
        function btnCancel_onclick() {
            parent.closeDeleteQuote();
        }

        $(function () {
            if ($("#hidParentRedirect").val() != "") {
                parent.location = applicationPath + $("#hidParentRedirect").val();
            }
        });
        

    </script>
</asp:Content>
