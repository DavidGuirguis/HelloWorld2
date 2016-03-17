<%@ Page Title="" Language="C#" MasterPageFile="~/Library/MasterPages/iFrame.master" AutoEventWireup="true" CodeFile="ImportXMLParts.aspx.cs" Inherits="ImportXMLFileParts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMP" Runat="Server">

    <asp:FileUpload ID="fuXML" size="80" runat="server" />
    <asp:Button ID="btnUpload" runat="server" Text="Upload" OnClientClick ="return  checkFile();"
        OnClick="btnUpload_Click" />
    <div id="divMainTables">
        <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red" Text=""></asp:Label>
        <asp:Panel ID="Panel1" ScrollBars="Auto" Width="800" Height="500"  runat="server">
            <asp:Repeater ID="rptParts_Validated" runat="server" OnItemDataBound="rptParts_Validated_ItemDataBound">
                <HeaderTemplate>
                    <table id="tableParts_Validated" width="97%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td colspan="11" style="font-weight: bold; text-align: left; background-color: #f7ae39;
                                height: 20px">
                                Validated Parts
                            </td>
                        </tr>
                        <tr>
                            <td class="header" style="width: 10%; text-align: left;">
                                SOS
                            </td>
                            <td class="header" style="width: 15%; text-align: left;">
                                Part No
                            </td>
                            <td class="header" style="width: 25%; text-align: left;">
                                Description
                            </td>
                            <td class="header" style="width: 10%; text-align: right;">
                                Unit Sell
                            </td>
                            <td class="header" style="width: 10%; text-align: right;">
                                Unit Disc
                            </td>
                            <td class="header" style="width: 10%; text-align: right;">
                                Net Sell
                            </td>
                            <td class="header" style="width: 10%; text-align: right;">
                                Unit Price
                            </td>
                            <td class="header" style="width: 5%; text-align: right;">
                                Qty
                            </td>
                            <td class="header" style="width: 5%; text-align: Center;">
                                Core
                            </td>
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td class="detail" style="text-align: left;">
                            <asp:Label ID="lblSOS" runat="server" Text=""></asp:Label>
                            <asp:HiddenField ID="hidPartPrice" runat="server" />
                        </td>
                        <td class="detail" style="text-align: left;">
                            <asp:Label ID="lblPartNo" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: left;">
                            <asp:Label ID="lblDesc" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: right;">
                            <asp:Label ID="lblUnitSell" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: right;">
                            <asp:Label ID="lblUnitDisc" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: right;">
                            <asp:Label ID="lblNetSell" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: right;">
                            <asp:Label ID="lblUnitPrice" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: right;">
                            <asp:Label ID="lblQty" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: center;">
                            <asp:Label ID="lblCore" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr>
                        <td class="detailAlter" style="text-align: left;">
                            <asp:Label ID="lblSOS" runat="server" Text=""></asp:Label>
                            <asp:HiddenField ID="hidPartPrice" runat="server" />
                        </td>
                        <td class="detailAlter" style="text-align: left;">
                            <asp:Label ID="lblPartNo" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detailAlter" style="text-align: left;">
                            <asp:Label ID="lblDesc" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detailAlter" style="text-align: right;">
                            <asp:Label ID="lblUnitSell" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detailAlter" style="text-align: right;">
                            <asp:Label ID="lblUnitDisc" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detailAlter" style="text-align: right;">
                            <asp:Label ID="lblNetSell" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detailAlter" style="text-align: right;">
                            <asp:Label ID="lblUnitPrice" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detailAlter" style="text-align: right;">
                            <asp:Label ID="lblQty" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detailAlter" style="text-align: center;">
                            <asp:Label ID="lblCore" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                </AlternatingItemTemplate>
                <FooterTemplate>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
            <asp:Repeater ID="rptParts_Replacements" runat="server" OnItemDataBound="rptParts_Replacement_ItemDataBound">
                <HeaderTemplate>
                    <table id="tableParts_Replacements" width="97%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td colspan="12" style="font-weight: bold; text-align: left; background-color: #f7ae39;
                                height: 20px">
                                Replacement Parts
                            </td>
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td colspan="12" style="font-weight: bold; text-align: left; background-color: #efefef;
                            height: 20px; border-top: 2px solid #f7ae39;">
                            Current Part:
                        </td>
                    </tr>
                    <tr>
                        <td class="header" style="width: 5%; text-align: left;">
                            SOS
                        </td>
                        <td class="header" style="width: 10%; text-align: left;">
                            Part No
                        </td>
                        <td class="header" style="width: 15%; text-align: left;">
                            Description
                        </td>
                        <td class="header" style="width: 10%; text-align: right;">
                            Unit Sell
                        </td>
                        <td class="header" style="width: 10%; text-align: right;">
                            Unit Disc
                        </td>
                        <td class="header" style="width: 10%; text-align: right;">
                            Net Sell
                        </td>
                        <td class="header" style="width: 10%; text-align: right;">
                            Unit Price
                        </td>
                        <td class="header" style="width: 5%; text-align: right;">
                            Qty
                        </td>
                        <td class="header" style="width: 5%; text-align: center;">
                            Core
                        </td>
                        <td class="header" style="width: 15%; text-align: center;">
                            
                        </td>
                        <td class="header" style="width: 5%; text-align: right;">
                        </td>
                    </tr>
                    <tr>
                        <td class="detail" style="text-align: left;">
                            <asp:Label ID="lblSOS" runat="server" Text="Label"></asp:Label>
                        </td>
                        <td class="detail" style="text-align: left;">
                            <asp:Label ID="lblPartNo" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: left;">
                            <asp:Label ID="lblDesc" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: right;">
                            <asp:Label ID="lblUnitSell" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: right;">
                            <asp:Label ID="lblUnitDisc" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: right;">
                            <asp:Label ID="lblNetSell" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: right;">
                            <asp:Label ID="lblUnitPrice" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: right;">
                            <asp:Label ID="lblQty" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: center;">
                            <asp:Label ID="lblCore" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: left;">
                            
                        </td>
                        <td class="detail" style="text-align: right;">
                            <asp:Literal ID="litRadioPart" runat="server"></asp:Literal>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="10" style="font-weight: bold; text-align: left; background-color: #efefef;
                            height: 20px">
                            Replacement Parts:
                        </td>
                    </tr>
                    <tr>
                        <td colspan="100">
                            <asp:Repeater ID="rptParts_Detail" runat="server" OnItemDataBound="rptParts_Replacement_Detail_ItemDataBound">
                                <HeaderTemplate>
                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="header" style="width: 5%; text-align: left;">
                                                SOS
                                            </td>
                                            <td class="header" style="width: 10%; text-align: left;">
                                                Part No
                                            </td>
                                            <td class="header" style="width: 15%; text-align: left;">
                                                Description
                                            </td>
                                            <td class="header" style="width: 10%; text-align: right;">
                                                Unit Sell
                                            </td>
                                            <td class="header" style="width: 10%; text-align: right;">
                                                Unit Disc
                                            </td>
                                            <td class="header" style="width: 10%; text-align: right;">
                                                Net Sell
                                            </td>
                                            <td class="header" style="width: 10%; text-align: right;">
                                                Unit Price
                                            </td>
                                            <td class="header" style="width: 5%; text-align: right;">
                                                Qty
                                            </td>
                                            <td class="header" style="width: 5%; text-align: center;">
                                                Core
                                            </td>
                                            <td class="header" style="width: 15%; text-align: center;">
                                                Availablity
                                            </td>
                                            <td class="header" style="width: 5%; text-align: right;">
                                                <asp:Literal ID="litRadioPart" runat="server"></asp:Literal>
                                            </td>
                                        </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td class="detail" style="text-align: left;">
                                            <asp:Label ID="lblSOS" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detail" style="text-align: left;">
                                            <asp:Label ID="lblPartNo" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detail" style="text-align: left;">
                                            <asp:Label ID="lblDesc" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detail" style="text-align: right;">
                                            <asp:Label ID="lblUnitSell" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detail" style="text-align: right;">
                                            <asp:Label ID="lblUnitDisc" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detail" style="text-align: right;">
                                            <asp:Label ID="lblNetSell" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detail" style="text-align: right;">
                                            <asp:Label ID="lblUnitPrice" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detail" style="text-align: right;">
                                            <asp:Label ID="lblQty" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detail" style="text-align: center;">
                                            <asp:Label ID="lblCore" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detail" style="text-align: left;">
                                            <asp:Label ID="lblIndirect" runat="server" Text=""></asp:Label>
                                        </td>

                                        <td class="detail" style="text-align: right;">
                                            <asp:Literal ID="litCheckboxPart" runat="server"></asp:Literal>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <AlternatingItemTemplate>
                                    <tr>
                                        <td class="detailAlter" style="text-align: left;">
                                            <asp:Label ID="lblSOS" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detailAlter" style="text-align: left;">
                                            <asp:Label ID="lblPartNo" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detailAlter" style="text-align: left;">
                                            <asp:Label ID="lblDesc" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detailAlter" style="text-align: right;">
                                            <asp:Label ID="lblUnitSell" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detailAlter" style="text-align: right;">
                                            <asp:Label ID="lblUnitDisc" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detailAlter" style="text-align: right;">
                                            <asp:Label ID="lblNetSell" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detailAlter" style="text-align: right;">
                                            <asp:Label ID="lblUnitPrice" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detailAlter" style="text-align: right;">
                                            <asp:Label ID="lblQty" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detailAlter" style="text-align: center;">
                                            <asp:Label ID="lblCore" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detailAlter" style="text-align: left;">
                                            <asp:Label ID="lblIndirect" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detailAlter" style="text-align: right;">
                                            <asp:Literal ID="litCheckboxPart" runat="server"></asp:Literal>
                                        </td>
                                    </tr>
                                </AlternatingItemTemplate>
                                <FooterTemplate>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
            <asp:Repeater ID="rptParts_Alternates" runat="server" OnItemDataBound="rptParts_Alter_ItemDataBound">
                <HeaderTemplate>
                    <table id="tableParts_Alternates" width="97%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td colspan="11" style="font-weight: bold; text-align: left; background-color: #f7ae39;
                                height: 20px">
                                Alternate Parts
                            </td>
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td colspan="11" style="font-weight: bold; text-align: left; background-color: #efefef;
                            height: 20px; border-top: 2px solid #f7ae39;">
                            Current Part:
                        </td>
                    </tr>
                    <tr>
                        <td class="header" style="width: 10%; text-align: left;">
                            SOS
                        </td>
                        <td class="header" style="width: 15%; text-align: left;">
                            Part No
                        </td>
                        <td class="header" style="width: 20%; text-align: left;">
                            Description
                        </td>
                        <td class="header" style="width: 10%; text-align: right;">
                            Unit Sell
                        </td>
                        <td class="header" style="width: 10%; text-align: right;">
                            Unit Disc
                        </td>
                        <td class="header" style="width: 10%; text-align: right;">
                            Net Sell
                        </td>
                        <td class="header" style="width: 10%; text-align: right;">
                            Unit Price
                        </td>
                        <td class="header" style="width: 5%; text-align: right;">
                            Qty
                        </td>
                        <td class="header" style="width: 5%; text-align: center;">
                            Core
                        </td>
                        <td class="header" style="width: 5%; text-align: right;">
                        </td>
                    </tr>
                    <tr>
                        <td class="detail" style="text-align: left;">
                            <asp:Label ID="lblSOS" runat="server" Text="Label"></asp:Label>
                        </td>
                        <td class="detail" style="text-align: left;">
                            <asp:Label ID="lblPartNo" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: left;">
                            <asp:Label ID="lblDesc" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: right;">
                            <asp:Label ID="lblUnitSell" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: right;">
                            <asp:Label ID="lblUnitDisc" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: right;">
                            <asp:Label ID="lblNetSell" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: right;">
                            <asp:Label ID="lblUnitPrice" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: right;">
                            <asp:Label ID="lblQty" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: center;">
                            <asp:Label ID="lblCore" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: right;">
                            <asp:Literal ID="litRadioPart" runat="server"></asp:Literal>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="11" style="font-weight: bold; text-align: left; background-color: #efefef;
                            height: 20px">
                            Alternate Parts:
                        </td>
                    </tr>
                    <tr>
                        <td colspan="100">
                            <asp:Repeater ID="rptParts_Detail" runat="server" OnItemDataBound="rptParts_Alter_Detail_ItemDataBound">
                                <HeaderTemplate>
                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="header" style="width: 10%; text-align: left;">
                                                SOS
                                            </td>
                                            <td class="header" style="width: 15%; text-align: left;">
                                                Part No
                                            </td>
                                            <td class="header" style="width: 20%; text-align: left;">
                                                Description
                                            </td>
                                            <td class="header" style="width: 10%; text-align: right;">
                                                Unit Sell
                                            </td>
                                            <td class="header" style="width: 10%; text-align: right;">
                                                Unit Disc
                                            </td>
                                            <td class="header" style="width: 10%; text-align: right;">
                                                Net Sell
                                            </td>
                                            <td class="header" style="width: 10%; text-align: right;">
                                                Unit Price
                                            </td>
                                            <td class="header" style="width: 5%; text-align: right;">
                                                Qty
                                            </td>
                                            <td class="header" style="width: 5%; text-align: center;">
                                                Core
                                            </td>
                                            <td class="header" style="width: 5%; text-align: right;">
                                            </td>
                                        </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td class="detail" style="text-align: left;">
                                            <asp:Label ID="lblSOS" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detail" style="text-align: left;">
                                            <asp:Label ID="lblPartNo" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detail" style="text-align: left;">
                                            <asp:Label ID="lblDesc" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detail" style="text-align: right;">
                                            <asp:Label ID="lblUnitSell" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detail" style="text-align: right;">
                                            <asp:Label ID="lblUnitDisc" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detail" style="text-align: right;">
                                            <asp:Label ID="lblNetSell" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detail" style="text-align: right;">
                                            <asp:Label ID="lblUnitPrice" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detail" style="text-align: right;">
                                            <asp:Label ID="lblQty" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detail" style="text-align: center;">
                                            <asp:Label ID="lblCore" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detail" style="text-align: right;">
                                            <asp:Literal ID="litRadioPart" runat="server"></asp:Literal>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <AlternatingItemTemplate>
                                    <tr>
                                        <td class="detailAlter" style="text-align: left;">
                                            <asp:Label ID="lblSOS" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detailAlter" style="text-align: left;">
                                            <asp:Label ID="lblPartNo" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detailAlter" style="text-align: left;">
                                            <asp:Label ID="lblDesc" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detailAlter" style="text-align: right;">
                                            <asp:Label ID="lblUnitSell" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detailAlter" style="text-align: right;">
                                            <asp:Label ID="lblUnitDisc" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detailAlter" style="text-align: right;">
                                            <asp:Label ID="lblNetSell" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detailAlter" style="text-align: right;">
                                            <asp:Label ID="lblUnitPrice" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detailAlter" style="text-align: right;">
                                            <asp:Label ID="lblQty" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detailAlter" style="text-align: center;">
                                            <asp:Label ID="lblCore" runat="server" Text=""></asp:Label>
                                        </td>
                                        <td class="detailAlter" style="text-align: right;">
                                            <asp:Literal ID="litRadioPart" runat="server"></asp:Literal>
                                        </td>
                                    </tr>
                                </AlternatingItemTemplate>
                                <FooterTemplate>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
            <asp:Repeater ID="rptParts_Exceptions" runat="server" OnItemDataBound="rptParts_Exceptions_ItemDataBound">
                <HeaderTemplate>
                    <table id="tableParts_Exceptions" width="97%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td colspan="10" style="font-weight: bold; text-align: left; background-color: #f7ae39;
                                height: 20px">
                                Exceptions
                            </td>
                        </tr>
                        <tr>
                            <td class="header" style="width: 20%; text-align: left;">
                                Part No
                            </td>
                            <td class="header" style="width: 75%; text-align: left;">
                                Error Message
                            </td>
                            <td class="header" style="width: 5%;">
                            </td>
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td class="detail" style="text-align: left;">
                            <asp:Label ID="lblPartNo" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: left;">
                            <asp:Label ID="lblMsg" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detail" style="text-align: right;">
                            <asp:Literal ID="litCheckPart" runat="server"></asp:Literal>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr>
                        <td class="detailAlter" style="text-align: left;">
                            <asp:Label ID="lblPartNo" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detailAlter" style="text-align: left;">
                            <asp:Label ID="lblMsg" runat="server" Text=""></asp:Label>
                        </td>
                        <td class="detailAlter" style="text-align: right;">
                            <asp:Literal ID="litCheckPart" runat="server"></asp:Literal>
                        </td>
                    </tr>
                </AlternatingItemTemplate>
                <FooterTemplate>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </asp:Panel>
        <table width="100%">
            <tr>
                <td style="text-align: right; padding:10px 50px 10px 10px">
                    <asp:Button OnClientClick="importPartsToParent();" ID="btnImport" Text="Import" runat="server" />
                    <asp:Button OnClientClick="closeMe();" ID="btnClose" Text="Cancel" runat="server" />
                </td>
            </tr>
        </table>
    </div>
    <div id="div_Waiting" style="position: absolute; left: 380px; top: 150px; display: none;">
        <img id="img_Waiting" src="../../../library/images/waiting.gif" />
    </div>
    <script type="text/javascript">
        function importPartsToParent() {

            var selectedData = "{\"data\":[";

            $('#tableParts_Validated tr').each(function () {
                var hidData = $(this).find("[id*=hidPartPrice]");
                if (hidData.length != 0) {
                    selectedData += hidData.val() + ",";
                }
            });

            $('#tableParts_Replacements input[type=radio]:checked').each(function () {
                if ($(this).attr("partData") != "")
                    selectedData += $(this).attr("partData") + ",";
            });

            $('#tableParts_Replacements input[type=checkbox]:checked').each(function () {
                selectedData += $(this).attr("partData") + ",";
            });

            $('#tableParts_Alternates input[type=radio]:checked').each(function () {
                selectedData += $(this).attr("partData") + ",";
            });

            $('#tableParts_Exceptions input[type=checkbox]:checked').each(function () {
                selectedData += $(this).attr("partData") + ",";
            });
            if (selectedData.substring(selectedData.length - 1, selectedData.length) == ",") {
                selectedData = selectedData.substring(0, selectedData.length - 1);
            }
            selectedData += "]}";

            parent.importSelectedParts(selectedData);
            clearMe();
            closeMe();

        }

        function setReplacementSelectedPart(partNo, val) {

        	if (val == 1) {
        		//<CODE_TAG_103467> Dav
        		//$("[name^=chk_" + partNo + "]").attr("disabled", "");
        		$("[name^=chk_" + partNo + "]").removeAttr("disabled");
        		//</CODE_TAG_103467> Dav
                $("[name^=chk_" + partNo + "]").filter("[indirectFlag=N]").prop('checked', true);
                $("[name^=chk_" + partNo + "]").filter("[indirectFlag=Y]").prop('checked', false);
            }
            else {
                $("[name^=chk_" + partNo + "]").prop('checked', false);
                $("[name^=chk_" + partNo + "]").attr("disabled", "true");
                
            }
        }

        function clearMe() {
            $("#divMainTables").html("");
        }

        function checkFile() {
            if ($("[id*=fuXML]").val() == "")
                return false;
            else {
                $("#div_Waiting").show();
                setTimeout("UpdateImg('img_Waiting','../../../library/images/waiting.gif');", 50);
                return true;
            }
        }
        function closeMe() {
            parent.closeImportXML();
        }

        function UpdateImg(ctrl, imgsrc) {
            $("#" + ctrl).attr("src", imgsrc);
        }
      
    </script>
    
</asp:Content>