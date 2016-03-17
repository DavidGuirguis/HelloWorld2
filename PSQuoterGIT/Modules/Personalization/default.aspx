<%@ Page Title="" Language="C#" MasterPageFile="~/Library/MasterPages/_base.master"
    AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="Default" %>
    <%@ Register Src="../quote/Controls/PrintConfig.ascx" TagName="PrintConfig" TagPrefix="uc2" %>
<asp:Content ID="Content5" ContentPlaceHolderID="cntMP" runat="Server">

    <div class="filters">
        Division</div>
    <table cellspacing="0" cellpadding="2" border="0">
        <tr class="t">
         <asp:RadioButtonList ID="rlstDivision" runat="server" RepeatDirection="Horizontal"   >
            
         </asp:RadioButtonList>


        </tr>
    </table>

    <div class="filters">
        Branch</div>
    <table cellspacing="0" cellpadding="2" border="0">
        <tr class="t">
        <td>
            <asp:DropDownList ID="lstBranch" runat="server"  ></asp:DropDownList>
        </td>
        </tr>
    </table>

    <div class="filters">
        Office Phone Number</div>
    <table cellspacing="0" cellpadding="2" border="0">
        <tr class="t">
        <td>
            <asp:TextBox ID="txtPhoneNo" runat="server" ></asp:TextBox>
        </td>
        </tr>
    </table>

    <div class="filters">
        Mobile Phone Number</div>
    <table cellspacing="0" cellpadding="2" border="0">
        <tr class="t">
        <td>
            <asp:TextBox ID="txtCellPhoneNo" runat="server" ></asp:TextBox>
        </td>
        </tr>
    </table>

    <div class="filters">
        Fax Number</div>
    <table cellspacing="0" cellpadding="2" border="0">
        <tr class="t">
        <td>
            <asp:TextBox ID="txtFaxNo" runat="server" ></asp:TextBox>
        </td>
        </tr>
    </table>
     <div class="filters">
        Print Configuration</div>

     <uc2:PrintConfig ID="printConfig" runat="server" />

    <asp:Button ID="btnSave" runat="server" Text="Save" OnClientClick="return btnSave_onclick();"
        onclick="btnSave_Click"    />
</asp:Content>
