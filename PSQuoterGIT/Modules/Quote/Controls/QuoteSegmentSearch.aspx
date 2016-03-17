<%@ Page Title="" Language="C#" MasterPageFile="~/Library/MasterPages/iFrame.master"
    EnableEventValidation="false" AutoEventWireup="true" CodeFile="QuoteSegmentSearch.aspx.cs"
    Inherits="quoteSegmentSearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMP" runat="Server">
     <table>
        <tr>
            <td>
                Look For Segments with 
                <asp:DropDownList ID="lstSearchFields" runat="server" >
                    <asp:ListItem Value="QuoteNo" Text="Quote No"></asp:ListItem> 
                 
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
     <asp:Panel ID="pannelResult" ScrollBars="Auto" Height="500px" runat="server"   >
        <asp:Literal ID="litResult" runat="server"  ></asp:Literal>
     </asp:Panel> 

     <table width="100%"  >
     <tr>
        <td class="tAr"> 
        <input type="button" id="btnOK" value="OK" onclick="btnOK_click();" />
        <input type="button" id="btnCancel" value="Cancel" onclick="parent.closeQuoteSegmentSearch();"  />
        </td>
     </tr>
     </table>
        <script type="text/javascript" >

            function btnOK_click() {
                var selectedData = "";
                $('input[type=checkbox]:checked').each(function () {
                    if ($(this).attr("QuoteSegmentId") != "") {
                        if (selectedData != "") selectedData += ",";
                        selectedData += $(this).attr("QuoteSegmentId");
                    }
                });

                if (selectedData == "") {
                    alert("Please select at least one segment.");
                    return false;
                }
                var fcaller = parent.frames['iFrameNewSegment'];
                if (fcaller.setupQuoteSegmentNo) fcaller.setupQuoteSegmentNo(selectedData);
                parent.closeQuoteSegmentSearch();

            }
     
     </script>
</asp:Content>
