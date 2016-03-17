<%@ Page Title="" Language="C#" MasterPageFile="~/Library/MasterPages/iFrame.master"
    EnableEventValidation="false" AutoEventWireup="true" CodeFile="CustomerSearch.aspx.cs"
    Inherits="quoteSegmentSearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMP" runat="Server">
     <table>
        <tr>
            <td>
                Look For Customer with 
                <asp:DropDownList ID="lstSearchFields" runat="server" >
                    <asp:ListItem Value="CustomerNumber" Text="Customer No"></asp:ListItem> 
                    <asp:ListItem Value="CustomerName" Text="Customer Name"></asp:ListItem> 
                </asp:DropDownList>
                That
                <asp:DropDownList ID="lstOp" runat="server" >
                    <asp:ListItem Value="Contains" Text="Contains"></asp:ListItem> 
                    <asp:ListItem Value="Equals" Text="Equals"></asp:ListItem> 
                    <asp:ListItem Value="StartsWith" Text="Starts With"></asp:ListItem> 
                </asp:DropDownList>
                &nbsp;
                <asp:TextBox ID="txtKeyword" Text="" runat="server" ></asp:TextBox>
                &nbsp;
                &nbsp;
                <asp:Button ID="btnSearch" Text="Search" runat="server" 
                    onclick="btnSearch_Click" />

            </td>
        </tr>
     </table>
     <asp:Panel ID="pannelResult" ScrollBars="Auto" runat="server"   >
        <asp:Literal ID="litResult" runat="server"  ></asp:Literal>
     </asp:Panel> 

        <script type="text/javascript" >
            function btnAdd_click(customerNo, customerName) {
			
                var fcaller;
                if (parent.frames['iFrameSegmentCustomer'])
                    fcaller = parent.frames['iFrameSegmentCustomer'];
                else
                    fcaller = parent;
					

				if (fcaller.setupCustomer){	
                fcaller.setupCustomer(customerNo, customerName);
				}
               else{
					if (fcaller.contentWindow.setupCustomer)	
						fcaller.contentWindow.setupCustomer(customerNo, customerName);
				}
                parent.closeSegmentCustomerSearch();
				return false;
            }
     </script>
</asp:Content>
