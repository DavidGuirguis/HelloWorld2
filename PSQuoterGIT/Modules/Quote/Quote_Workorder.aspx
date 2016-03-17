<%@ Page Title="" Language="C#" MasterPageFile="~/Library/MasterPages/_base.master"
    AutoEventWireup="true" CodeFile="Quote_Workorder.aspx.cs" Inherits="Modules_Quote_Workorder" %>

<%@ Import Namespace="System.Data" %>
<%@ Register Src="Controls/QuoteHeader.ascx" TagName="QutoeHeader" TagPrefix="uc1" %>
<asp:Content ID="Content5" ContentPlaceHolderID="cntMP" runat="Server">
    <uc1:QutoeHeader ID="quoteHeader" runat="server"></uc1:QutoeHeader>
    <div id="divLoading" style="text-align:center; vertical-align:middle; height:100px;">
        <img src="../../Library/images/waiting.gif" />
    </div>    
    <%--<iframe onload="$j('#divLoading').hide();" src= '<%= ConfigurationManager.AppSettings["url.siteRootPath"] %>AppLink/EquipmentLink/Modules/equipment/workorder/wo_drill.aspx?TT=iframe&WONO=<%=WOno %>' frameborder="0" width="100%" height="800">        --%>

    <iframe onload="$j('#divLoading').hide();" src= '<%=  WOUrl  %>'  frameborder="0" width="100%" height="800"> <!--CODE_TAG_101885--><!--CODE_TAG_103717--> 
    </iframe> 
</asp:Content>
