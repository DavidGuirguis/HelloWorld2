<%@ Page language="c#" 
    CodeFileBaseClass="X.Web.UI.PageBase" 
    CodeFile="~/Modules/Samples/Default.aspx.cs" 
    Inherits="Modules.Samples._default" 
    MasterPageFile="~/library/masterPages/_base.master" 
    ModuleTitle="Sample"%>
<%@ Import Namespace="X.Data" %>
<%@ Import Namespace="System.Data" %>
<asp:Content ID="cntMP" ContentPlaceHolderID="cntMP" Runat="Server">		
<script runat="server">
void Page_Init(object sender, EventArgs e) {
//    AppContext.Current.AppSettings.Mockup(new Dictionary<string, object>{
//        {"ck.SalesLink.CustomerInfo.SpouseField.Label", "323a as da "}
//    });
}
</script>
   <div>
    <%
    //Writes Tabs in inline coding style
        var tabStrip = new TabStrip("tabIdx", TabStripMethod.Url);
        //Jump to different page
        tabStrip.Add("Tab 1", "1").NavigateUrl = "modules/samples/default.aspx?taggroups=2";
        tabStrip.Add("Tab 2", "2");       
        tabStrip.AddSpacer(20);       
        tabStrip.Add("Tab 3", "Tab 3 tooltip", "3");       
        tabStrip.Write();

        //Response.Write("Selected tab value:" + tabStrip.SelectedValue + "<br/>");
    %>
    <div><b>Company Name:</b> <%=WebContext.User.IdentityEx.Company %></div>
    <div><b>Company Type:</b> <%=WebContext.User.IdentityEx.CompanyType %></div>
    <div><b>Company ID:</b> <%=WebContext.User.IdentityEx.CompanyID %></div>
    <div><b>Is New Session:</b> <%=Session.IsNewSession %></div>
    <div><b>Session ID:</b> <%=String.Format("{0} ({1})", WebContext.Session.SessionID, Session.SessionID)%></div>
    <div><b>Session Start-up App Data:</b> <%=WebContext.Session.StartUpAppData == null ? "[Nothing]" : (WebContext.Session.StartUpAppData.Tables.Count.ToString() + " tables")%> (Accessed via <span style="font-weight:bold;font-style:italic;">WebContext.Session.StartUpAppData</span> in <b>Page</b> or <span style="font-weight:bold;font-style:italic;">WebContext.Current.Session.StartUpAppData</span> at anywhere or <b>XSession_Start</b> event in global.asax)</div>
    </div>
    <div style="margin-top:10px;margin-bottom:10px;">
        <b style="color:Red;">Error Handling:</b> <asp:LinkButton ID="lnkCauseError" OnClick="lnkCauseError_Click" runat="server">Click here to raise exception</asp:LinkButton>
        <ui>
          <li>To receive notification of the exception details, please update your email in web.config setting - 'x.configuration/customErrors/@defaultContacts' and make sure your're not a debugger (i.e. debug='false' in your 'users/user' setting)</li>
          <li>Customize your friendly message in page - modules/errors/customErrors.aspx</li>
        </ui>
    </div>
    <p>
		<asp:button id="btn1" runat="server" text="button1" OnClick="btn1_Click" CssClass="btn"></asp:button>&nbsp;
		<asp:button id="btn2" runat="server" text="button2" OnClick="btn2_Click" CssClass="btn"></asp:button>&nbsp; <input class="btn" type="button" value="Reset" onclick="document.location.href = document.location.href" /></p>
	<p><asp:hyperlink id="lnk" runat="server" NavigateUrl="javascript:openWin('modules/samples/popup.aspx')"
			cssClass="f">Popup Window</asp:hyperlink>&nbsp;<asp:GridView ID="GridView1" runat="server"
                SkinID="default" AutoGenerateColumns="true" DataSourceID="odsMain">
                <%--
                ## Uncomment for specifying customize columns, i.e. set 'false' to AutoGenerateColumns ##
                <Columns>
                    <asp:BoundField DataField="FirstName" HeaderText="First Name" HeaderStyle-HorizontalAlign="center" />
                    <asp:BoundField DataField="LastName" HeaderText="Last Name" />
                    <asp:BoundField DataField="Title" HeaderText="Title" />
                </Columns>
                --%>
            </asp:GridView>
        <asp:ObjectDataSource ID="odsMain" runat="server" SelectMethod="SampleDataGet" TypeName="Repositories.SampleRepository">
        </asp:ObjectDataSource>
    </p>
			
	<a href="<%=X.Url.UrlBuilder("modules/samples/default.aspx", "report", null)%>">Report View</a>&nbsp;&nbsp;<a href="<%=X.Url.UrlBuilder("modules/samples/default.aspx", "print", null)%>">Print View</a>&nbsp;&nbsp;<a href="<%=X.Url.UrlBuilder("modules/samples/default.aspx")%>">Default View</a>
	
	<p>
		<asp:textbox id="txt" runat="server"></asp:textbox> (this text box should be always in focus)</p>
		<asp:Panel ID="pnlTabs" runat="server"></asp:Panel>

	<!-- Calendar: 
	        - See code-behind file for how to set date range
	 -->
    <br/><b>Calendar: </b><xui:Calendar 
			id="Calendar1"
			runat="server" 
			nullable=true 
		></xui:Calendar><span style="margin-left:10px;margin-right:10px;"><a href="javascript:showDate('<%=Calendar1.ClientID %>');">Show date value</a></span>
		<b>Disabled Cal:</b>
		<xui:Calendar 
			id="Calendar2" 
			runat="server" 
			enabled="false"
			nullable=true 
		></xui:Calendar><span style="margin-left:10px;"><a href="javascript:enableDate('<%=Calendar2.ClientID %>');">Enable</a>&nbsp;&nbsp;&nbsp;<a href="javascript:showDate('<%=Calendar2.ClientID%>');">Show date value</a></span>		
	    <script type="text/javascript">
		    function showDate(id){
			    var oDate = document.getElementById(id);
    			
			    if(!oDate.calendar.hasValue())
				    alert("Please select a date.");
			    else			
				    alert("Year: " + oDate.Year + "\n"
					    + "Month: " + oDate.Month + "\n"
					    + "Day: " + oDate.Day + "\n"
					    + "value: " + oDate.value);
		    }
    		
		    function enableDate(id){
			    var oDate = document.getElementById(id);
    			
			    oDate.calendar.setEnabled(true);			
		    }
		    
		    //simple row highligher
		    TableHelper.registerHighlighter('<%=GridView1.ClientID%>');
	    </script>
</asp:Content>