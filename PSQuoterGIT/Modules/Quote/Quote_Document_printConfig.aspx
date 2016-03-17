<%@ Page Title="" Language="C#" MasterPageFile="~/Library/MasterPages/_base.master"
    AutoEventWireup="true" CodeFile="Quote_Document_printConfig.aspx.cs" Inherits="Modules_Quote_Document" %>

<%@ Import Namespace="System.Data" %>
<%@ Register Src="Controls/QuoteHeader.ascx" TagName="QutoeHeader" TagPrefix="uc1" %>
<%@ Register Src="../quote/Controls/PrintConfig.ascx" TagName="PrintConfig" TagPrefix="uc2" %>
<asp:Content ID="Content5" ContentPlaceHolderID="cntMP" runat="Server">
    <uc1:QutoeHeader ID="quoteHeader" runat="server"></uc1:QutoeHeader>


    <uc2:PrintConfig ID="print1" runat="server" />
</asp:Content>
