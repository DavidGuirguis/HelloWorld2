<%@ Page language="c#" 
    CodeFileBaseClass="X.Web.UI.PageBase" 
    Inherits="Modules.Samples.Popup" 
    CodeFile="Popup.aspx.cs" 
    MasterPageFile="~/library/masterPages/_base.master" 
    ModuleTitle="Popup Window" %>
<asp:Content ID="cntMP" ContentPlaceHolderID="cntMP" Runat="Server">
    <a href="javascript:;" onclick="refreshOpener(false, true);">Refresh Opener &amp; Current</a>
</asp:Content>	