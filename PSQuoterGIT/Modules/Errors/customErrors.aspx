<%@ Page language="c#" 
	CodeFileBaseClass="X.Web.UI.PageBase" 
	CodeFile="customErrors.aspx.cs" 
	Inherits="Modules.customErrors" 
	MasterPageFile="~/library/masterPages/_base.master" %>
<asp:Content ID="cntMP" ContentPlaceHolderID="cntMP" Runat="Server">
	
		<div class="t14 tSb"><asp:Localize meta:resourcekey="rkMSG_AnErrorOccurred" runat="server">An Error Occurred</asp:Localize></div>
		<div class=t12 style="MARGIN-TOP:10px">
			<asp:Panel ID=msgOpenUrl Runat=server><asp:Localize meta:resourcekey="rkMSG_ThereWasAProblemOpening" runat="server">There was a problem opening</asp:Localize><asp:HyperLink id=lnkAspErrorPath Runat="server"></asp:HyperLink>.</asp:Panel>
			<asp:Panel ID=msg Runat=server style="MARGIN-TOP:10px"></asp:Panel>
			
			<div style="MARGIN-TOP:10px"><asp:Localize meta:resourcekey="rkMSG_YouCouldGo" runat="server">You could go</asp:Localize><a href="javascript:history.go(-1)"><asp:Localize meta:resourcekey="rkMSG_Back" runat="server"> back</asp:Localize></a><asp:Localize meta:resourcekey="rkMSG_AndTryAgain" runat="server"> and try again</asp:Localize><asp:PlaceHolder id="phrHomePage" runat="server"><asp:Localize meta:resourcekey="rkMSG_OrPerhapsReturnToThe" runat="server"> or perhaps return to the </asp:Localize><asp:HyperLink title="Home Page" NavigateUrl="<%# WebContext.Application.DefaultUrl%>" Runat=server><asp:Localize meta:resourcekey="rkMSG_HomePage" runat="server">Home Page</asp:Localize></asp:HyperLink></asp:PlaceHolder>.</div>
		</div>
	
  </asp:Content>
