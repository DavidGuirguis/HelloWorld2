<%@ Page language="c#" 
    CodeFileBaseClass="X.Web.UI.PageBase" 
    Inherits="Modules.ErrorDisplay" 
    CodeFile="Err.aspx.cs" 
    DefaultMasterPageFile="~/library/masterPages/Error.master"
    MasterPageFile="~/library/masterPages/_base.master" %>
<asp:Content ID="cntMP" ContentPlaceHolderID="cntMP" Runat="Server">
	<asp:Label ID=lblMsg Runat="server" />
</asp:Content>