<%@ Page Title="" Language="C#" MasterPageFile="~/Library/MasterPages/iFrame.master"
    EnableEventValidation="false" AutoEventWireup="true" CodeFile="NewSegment.aspx.cs"
    Inherits="quoteHeaderEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMP" runat="Server">
    <asp:RadioButton ID="rdoManual" GroupName="SegmentSource" Text="Manual" Checked="true"
        runat="server" onclick="segmentsource_onChange('Manual');" ClientIDMode="Static" />
    <asp:RadioButton ID="rdoQuote" GroupName="SegmentSource" Text="Copy From Quote" runat="server"
        onclick="segmentsource_onChange('CopyFromQuote');" ClientIDMode="Static" />
    <asp:RadioButton ID="rdoWorkorder" GroupName="SegmentSource" Text="Copy From Workorder"
        runat="server" onclick="segmentsource_onChange('CopyFromWorkorder');" ClientIDMode="Static" />
    <asp:RadioButton ID="rdoStandardJob" GroupName="SegmentSource" Text="Copy From Standard Job"
        runat="server" onclick="segmentsource_onChange('CopyFromStandardJob');" ClientIDMode="Static" />
<!--CODE_TAG_103560-->
    <asp:RadioButton ID="rdoDBSPartDocuments" GroupName="SegmentSource" Text="Copy From DBS Part Documents" 
        runat="server" 
        onclick="segmentsource_onChange('CopyFromDBSPartDocuments');"  ClientIDMode="Static"  />
<!--/CODE_TAG_103560-->
    <div id="divManual" runat="server" clientidmode="Static">
        <fieldset>
            <legend>Manual</legend>
            <asp:Button ID="btnOK_Manual" OnClick="btnOK_Manual_Click" OnClientClick="return  validation();"
                Text="OK" Style="float: right" runat="server" />
            <table>
                <tr>
                    <th>
                        Segment No:<span style="color: red">*</span>
                    </th>
                    <td>
                        <asp:TextBox ID="txtManualSegmentNo" CssClass="segmentNoTextbox" runat="server" MaxLength="2"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Label ID="lblManualErrorMessage" CssClass="errorMessage" runat="Server" Text=""></asp:Label>
                    </td>
                </tr>
            </table>
            <table class="w100p" id="tableNewSegmentManualDetails" runat="server" clientidmode="Static"
                visible="false">
                <tr>
                    <th>
                        Job Code:
                    </th>
                    <td>
                        <asp:Label ID="lblManualJobCode" runat="server"></asp:Label>
                    </td>
                    <th>
                        Component Code:
                    </th>
                    <td>
                        <asp:Label ID="lblManualComponentCode" runat="server"></asp:Label>
                    </td>
                    <th>
                        Modifier Code:
                    </th>
                    <td>
                        <asp:Label ID="lblManualModifierCode" runat="server"></asp:Label>
                    </td>
                    <th>
                        Business Group Code:
                    </th>
                    <td>
                        <asp:Label ID="lblManualBusinessGroupCode" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <th>
                        Quanity Code:
                    </th>
                    <td>
                        <asp:Label ID="lblManualQuanityCode" runat="server"></asp:Label>
                    </td>
                    <th>
                        Branch Code:
                    </th>
                    <td>
                        <asp:Label ID="lblManualBranchCode" runat="server"></asp:Label>
                    </td>
                    <th>
                        Cost Centre Code:
                    </th>
                    <td>
                        <asp:Label ID="lblManualCostCentreCode" runat="server"></asp:Label>
                    </td>
                    <th>
                        Shop/Field:
                    </th>
                    <td>
                        <asp:Label ID="lblManualShopField" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <th>
                        Avg. Parts:
                    </th>
                    <td style="">
                        <asp:Label ID="lblManualAvgParts" runat="server"></asp:Label>
                    </td>
                    <th>
                        Avg. Labor:
                    </th>
                    <td>
                        <asp:Label ID="lblManualAvgLabor" runat="server"></asp:Label>
                    </td>
                    <th>
                        Avg. Misc:
                    </th>
                    <td>
                        <asp:Label ID="lblManualAvgMisc" runat="server"></asp:Label>
                    </td>
                    <th>
                        Avg. Hours:
                    </th>
                    <td>
                        <asp:Label ID="lblManualAvgHours" runat="server"></asp:Label>
                    </td>
                </tr>
            </table>
        </fieldset>
    </div>
    <div id="divQuote" runat="server" clientidmode="Static">
        <fieldset>
            <legend>Copy From Quote</legend>Please search Quote segment
            <img alt="show" src="../../../library/images/magnifier.gif" onclick="parent.showQuoteSegmentSearch()"
                class='imgBtn' /><!--CODE_TAG_101936-->

            <asp:Button ID="btnOK_CopyFromQuote" OnClick="btnOK_CopyFromQuote_Click" Text="OK"
                Style="float: right" OnClientClick="return  validation();" runat="server" />
            <asp:CheckBox ID="chkQuote_CopyNotes" runat="server" Style="float: right; margin-right:10px " Text="Copy Notes"  ClientIDMode="Static" Checked="true" /><!--CODE_TAG_101936-->
            <asp:Button ID="btnQuoteGetData" Style="display: none" Text="GetData" runat="server"
                OnClick="btnQuoteGetData_Click" ClientIDMode="Static" />
            <asp:HiddenField ID="hidQuoteSegmentIds" Value="" runat="server" />
            <asp:Repeater ID="repQuoteSegmentList" runat="server" OnItemDataBound="repSegmentsList_ItemDataBound">
                <HeaderTemplate>
                    <table class='segmentSearchResult'>
                        <tr class="reportHeader">
                            <th style='width: 40px'>
                                Seg No<span style="color: red">*</span>
                            </th>
                            <th>
                                Quote No
                            </th>
                            <th>
                                Customer
                            </th>
                            <th>
                                Revision
                            </th>
                            <th>
                                Seg No
                            </th>
                            <th>
                                Job Code
                            </th>
                            <th>
                                Comp Code
                            </th>
                            <th>
                                Quantity
                            </th>
                            <!--CODE_TAG_105504-->
                            <% if (ChargeCodeEnabled) {%>
                            <th style="width:8%">
                                Cost Center<span style="color: red">*</span>
                            </th>
                            <%} %>
                            <!--/CODE_TAG_105504-->
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr class="rd">
                        <td>
                            <asp:TextBox ID="txtQuoteSegNo" MaxLength="2" runat="server" Style="width: 20px"></asp:TextBox>
                            <asp:HiddenField ID="segmentId" Value='<%# DataBinder.Eval(Container.DataItem, "QuoteSegmentId") %>'
                                runat="server" />
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "QuoteNo") %>
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "CustomerNo")%>
                            -
                            <%# DataBinder.Eval(Container.DataItem, "CustomerName")%>
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "Revision")%>
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "SegmentNo")%>
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "JobCode")%>
                            -
                            <%# DataBinder.Eval(Container.DataItem, "JobCodeDesc")%>
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "ComponentCode")%>
                            -
                            <%# DataBinder.Eval(Container.DataItem, "ComponentCodeDesc")%>
                        </td>
                        <td><!-- <CODE_TAG_101750> -->
                            <%# DataBinder.Eval(Container.DataItem, "SegmentQty")%>
                        </td>
                        <!--CODE_TAG_105504-->
                        <% if (ChargeCodeEnabled) {%>
                        <td>
                            <asp:DropDownList ID="lstCostCenterCode" CssClass="CostCenterCode" runat="server"></asp:DropDownList>
                        </td>
                        <%} %>
                        <!--/CODE_TAG_105504-->
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr class="rl">
                        <td>
                            <asp:TextBox ID="txtQuoteSegNo" MaxLength="2" runat="server" Style="width: 20px"></asp:TextBox>
                            <asp:HiddenField ID="segmentId" Value='<%# DataBinder.Eval(Container.DataItem, "QuoteSegmentId") %>'
                                runat="server" />
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "QuoteNo") %>
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "CustomerNo")%>
                            -
                            <%# DataBinder.Eval(Container.DataItem, "CustomerName")%>
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "Revision")%>
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "SegmentNo")%>
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "JobCode")%>
                            -
                            <%# DataBinder.Eval(Container.DataItem, "JobCodeDesc")%>
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "ComponentCode")%>
                            -
                            <%# DataBinder.Eval(Container.DataItem, "ComponentCodeDesc")%>
                        </td>
                        <td><!-- <CODE_TAG_101750> -->
                            <%# DataBinder.Eval(Container.DataItem, "SegmentQty")%>
                        </td>
                        <!--CODE_TAG_105504-->
                        <% if (ChargeCodeEnabled) {%>
                        <td>
                            <asp:DropDownList ID="lstCostCenterCode" CssClass="CostCenterCode" runat="server"></asp:DropDownList>
                        </td>
                        <%} %>
                        <!--/CODE_TAG_105504-->
                    </tr>
                </AlternatingItemTemplate>
                <FooterTemplate>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
            <asp:Label ID="lblCopyFromQuoteErrorMessage" CssClass="errorMessage" runat="Server"
                Text=""></asp:Label>
        </fieldset>
    </div>
    <div id="divWorkorder" runat="server" clientidmode="Static">
        <fieldset>
            <legend>Copy From Workorder</legend>Please search Work order segment:
            <img alt="show" src="../../../library/images/magnifier.gif" onclick="parent.showWOSegmentSearch()"
                class='imgBtn' /><!--CODE_TAG_101936-->
            <asp:Button ID="btnOK_CopyFromWorkorder" OnClick="btnOK_CopyFromWorkorder_Click"
                Style="float: right" OnClientClick="return  validation();" Text="OK" runat="server" />
            <asp:CheckBox ID="chkWorkOrder_CopyNotes" runat="server" Style="float: right; margin-right:10px " Text="Copy Notes"  ClientIDMode="Static"/><!--CODE_TAG_101936--><!--CODE_TAG_105726-->
            <asp:Button ID="btnWOGetData" Style="display: none" Text="GetData" runat="server"
                ClientIDMode="Static" OnClick="btnWOGetData_Click" />
            <asp:HiddenField ID="hidWOSegmentIds" Value="" runat="server" />
            <asp:Repeater ID="repWOSegmentList" runat="server" OnItemDataBound="repSegmentsList_ItemDataBound">
                <HeaderTemplate>
                    <table class='segmentSearchResult'>
                        <tr class="reportHeader">
                            <th style='width: 40px'>
                                Seg No<span style="color: red">*</span>
                            </th>
                            <th>
                                WO No
                            </th>
                            <th>
                                Customer
                            </th>
                            <th>
                                Seg No
                            </th>
                            <th>
                                Job Code
                            </th>
                            <th>
                                Comp Code
                            </th>
                            <th>
                                Quantity
                            </th>
                            <!--CODE_TAG_105504-->
                            <% if (ChargeCodeEnabled) {%>
                            <th style="width:8%">
                                Cost Center<span style="color: red">*</span>
                            </th>
                            <%} %>
                            <!--/CODE_TAG_105504-->
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr class="rd">
                        <td>
                            <asp:TextBox ID="txtQuoteSegNo" MaxLength="2" Text='<%# DataBinder.Eval(Container.DataItem, "SegmentNo")%>'
                                runat="server" Style="width: 20px"></asp:TextBox>
                            <asp:HiddenField ID="wono" Value='<%# DataBinder.Eval(Container.DataItem, "woNo").ToString().Trim( ) %>'
                                runat="server" />
                            <asp:HiddenField ID="segmentNo" Value='<%# DataBinder.Eval(Container.DataItem, "SegmentNo").ToString().Trim( ) %>'
                                runat="server" />
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "woNo") %>
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "CustomerNo")%>
                            -
                            <%# DataBinder.Eval(Container.DataItem, "CustomerName")%>
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "SegmentNo")%>
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "JobCode")%>
                            -
                            <%# DataBinder.Eval(Container.DataItem, "JobCodeDesc")%>
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "ComponentCode")%>
                            -
                            <%# DataBinder.Eval(Container.DataItem, "ComponentCodeDesc")%>
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "Quantity")%>
                        </td>
                        <!--CODE_TAG_105504-->
                        <% if (ChargeCodeEnabled) {%>
                        <td>
                            <asp:DropDownList ID="lstCostCenterCode" CssClass="CostCenterCode" runat="server"></asp:DropDownList>
                        </td>
                        <%} %>
                        <!--/CODE_TAG_105504-->
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr class="rl">
                        <td>
                            <asp:TextBox ID="txtQuoteSegNo" MaxLength="2" Text='<%# DataBinder.Eval(Container.DataItem, "SegmentNo")%>'
                                runat="server" Style="width: 20px"></asp:TextBox>
                            <asp:HiddenField ID="wono" Value='<%# DataBinder.Eval(Container.DataItem, "woNo").ToString().Trim( ) %>'
                                runat="server" />
                            <asp:HiddenField ID="segmentNo" Value='<%# DataBinder.Eval(Container.DataItem, "SegmentNo").ToString().Trim( ) %>'
                                runat="server" />
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "woNo") %>
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "CustomerNo")%>
                            -
                            <%# DataBinder.Eval(Container.DataItem, "CustomerName")%>
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "SegmentNo")%>
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "JobCode")%>
                            -
                            <%# DataBinder.Eval(Container.DataItem, "JobCodeDesc")%>
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "ComponentCode")%>
                            -
                            <%# DataBinder.Eval(Container.DataItem, "ComponentCodeDesc")%>
                        </td>
                        <td>
                            <%# DataBinder.Eval(Container.DataItem, "Quantity")%>
                        </td>
						<!--CODE_TAG_105504-->
						<% if (ChargeCodeEnabled) {%>
                        <td>
                            <asp:DropDownList ID="lstCostCenterCode" CssClass="CostCenterCode" runat="server"></asp:DropDownList>
                        </td>
						<%} %>
						<!--/CODE_TAG_105504-->
                    </tr>
                </AlternatingItemTemplate>
                <FooterTemplate>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
            <asp:Label ID="lblCopyFromWorkOrderErrorMessage" CssClass="errorMessage" runat="Server"
                Text=""></asp:Label>
        </fieldset>
    </div>
    <div id="divStandardJob" runat="server" clientidmode="Static">
        <fieldset>
            <legend>Standard Job</legend>Please search standard jobs:
            <img alt="show" src="../../../library/images/magnifier.gif" onclick="parent.showStandardJobSearch();"
                class='imgBtn' /><!--CODE_TAG_101936-->
            <asp:Button ID="btnOK_CopyFromStandardJob" OnClick="btnOK_CopyFromStandardJob_Click"
                Style="float: right" OnClientClick="return  validation();" Text="OK" runat="server" /><!--CODE_TAG_101936-->
            <asp:CheckBox ID="chkStandardJob_CopyNotes" runat="server" Style="float: right; margin-right:10px " Text="Copy Notes"  ClientIDMode="Static" Checked="true" /><!--CODE_TAG_101936-->
            <asp:Button ID="btnStandardJobGetData" Style="display: none" Text="GetData" runat="server"
                ClientIDMode="Static" OnClick="btnStandardJobGetData_Click" />
            <asp:HiddenField ID="hidStandardJobROId" Value="" runat="server" />
            <asp:HiddenField ID="hidStandardJobROPId" Value="" runat="server" />
            <asp:HiddenField ID="hidStandardJobSelectedGroup" Value="" runat="server" />
            <asp:HiddenField ID="hidStandardJobSType" Value="" runat="server" />
            <asp:HiddenField ID="hidWorkApplicationCodeSelected" ClientIDMode = "Static" Value="" runat="server" /><!--CODE_TAG_103916-->
            <!--CODE_TAG_101936-->
            <asp:HiddenField ID="hidCostCenterCode" Value="" runat="server" />
            <asp:HiddenField ID="hidCurrBranch" Value="" runat="server" />
            <!--/CODE_TAG_101936-->
            <div id="divStandardJobSegmentsList" visible="false" runat="server">
            <!--CODE_TAG_101936-->
            <asp:Repeater ID="repStandardJobSegmentsList" OnItemDataBound="repSegmentsList_ItemDataBound" runat="server">
                <HeaderTemplate>
                    <table class='segmentSearchResult fe'>
                        <tr class="reportHeader">
                            <th width="5%" align="center">
                                Segment No<span style="color: red">*</span>
                            </th>
                            <th width="8%" align="center">
                                Model / Flate Rate Exchange
                            </th>
                            <th width="12%" align="center">
                                Job Code
                            </th>
                            <th width="12%" align="center">
                                Component Code
                            </th>
                            <th width="12%" align="center">
                                Modifer
                            </th>
                            <th width="5%" align="center">
                                Quantity
                            </th>
                            <th width="8%" align="center">Labor Code</th>
                            <th width="5%" align="center">
                                Labor Hours
                            </th>
                            <th width="8%" align="center">
                                Parts Amount
                            </th>
                            <th width="8%" align="center">
                                Labor Amount
                            </th>
                            <th width="8%" align="center">
                                Misc Amount
                            </th>
                            <th width="8%" align="center">
                                Total Amount
                            </th>
                            <th width="12%" align="center">
                                Features and Benifits
                            </th>
                            <!--CODE_TAG_105504-->
							<% if (ChargeCodeEnabled) {%>
                            <th width="8%" align="center">
                                Cost Center<span style="color: red">*</span>
                            </th>
							<%} %>
							<!--/CODE_TAG_105504-->
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                        <tr class="rd">
                            <td width="5%" align="center">
                                <asp:TextBox ID="txtQuoteSegNo" CssClass="segmentNoTextbox" runat="server"
                                    Text="01" MaxLength="2"></asp:TextBox>
                                <asp:HiddenField ID="hidROId" Value='<%# DataBinder.Eval(Container.DataItem, "stROId")%>' runat="server" />
                                <asp:HiddenField ID="hidROPId" Value='<%# DataBinder.Eval(Container.DataItem, "stROPId")%>' runat="server" />

                            </td>
                            <td width="8%" align="center">
                                <%# DataBinder.Eval(Container.DataItem, "Model")%>
                            </td>
                            <td width="12%" align="center">
                                <%# DataBinder.Eval(Container.DataItem, "JobCode")%> - <%# DataBinder.Eval(Container.DataItem, "JobCodeDesc")%>
                            </td>
                            <td width="12%" align="center">
                                <%# DataBinder.Eval(Container.DataItem, "ComponentCode")%> - <%# DataBinder.Eval(Container.DataItem, "ComponentCodeDesc")%>
                            </td>
                            <td width="12%" align="center">
                                <%# DataBinder.Eval(Container.DataItem, "ModifierCode")%> - <%# DataBinder.Eval(Container.DataItem, "ModifierDesc")%>
                            </td>
                            <td width="5%" align="center">
                                <%# DataBinder.Eval(Container.DataItem, "QuantityCode")%> - <%# DataBinder.Eval(Container.DataItem, "QuantityDesc")%>
                            </td>
                            <td width="12%" align="center">
                                <%# DataBinder.Eval(Container.DataItem, "ChargeCode") %>
                            </td>
                            <td width="5%" align="center">
                                <%# Helpers.Util.NumberFormat(DataBinder.Eval(Container.DataItem, "FRPriceHours").AsDouble(0.00), 2, -1, -1, -1, true) %>
                            </td>
                            <td width="8%" align="center">
                                <%# Helpers.Util.NumberFormat(DataBinder.Eval(Container.DataItem, "PartsStdDollarAmount").AsDouble(0.00), 2, -1, -1, -1, true) %>
                            </td>
                            <td width="8%" align="center">
                                <%# Helpers.Util.NumberFormat(DataBinder.Eval(Container.DataItem, "LabourStdDollarAmount").AsDouble(0.00), 2, -1, -1, -1, true) %>
                            </td>
                            <td width="8%" align="center">
                                <%# Helpers.Util.NumberFormat(DataBinder.Eval(Container.DataItem, "MiscStdDollarAmount").AsDouble(0.00), 2, -1, -1, -1, true) %>
                            </td>
                            <td width="8%" align="center">
                                <%# Helpers.Util.NumberFormat(DataBinder.Eval(Container.DataItem, "PartsStdDollarAmount").AsDouble(0.00) + DataBinder.Eval(Container.DataItem, "LabourStdDollarAmount").AsDouble(0.00) + DataBinder.Eval(Container.DataItem, "MiscStdDollarAmount").AsDouble(0.00), 2, -1, -1, -1, true) %>   <%--//<CODE_TAG_104228>--%>
                            </td>
                            <td width="12%" align="center">
                                <%# DataBinder.Eval(Container.DataItem, "FeaturesAndBenefits") %>
                            </td>
                            <!--CODE_TAG_105504-->
							<% if (ChargeCodeEnabled) {%>
                            <td>
                                <asp:DropDownList ID="lstCostCenterCode" CssClass="CostCenterCode" runat="server"></asp:DropDownList>
                            </td>
                            <%} %>
							<!--/CODE_TAG_105504-->
                        </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                        <tr class="rl">
                            <td width="5%" align="center">
                                <asp:TextBox ID="txtQuoteSegNo" CssClass="segmentNoTextbox" runat="server"
                                    Text="02" MaxLength="2"></asp:TextBox>
                                <asp:HiddenField ID="hidROId" Value='<%# DataBinder.Eval(Container.DataItem, "stROId")%>' runat="server" />
                                <asp:HiddenField ID="hidROPId" Value='<%# DataBinder.Eval(Container.DataItem, "stROPId")%>' runat="server" />

                            </td>
                            <td width="8%" align="center">
                                <%# DataBinder.Eval(Container.DataItem, "Model")%>
                            </td>
                            <td width="12%" align="center">
                                <%# DataBinder.Eval(Container.DataItem, "JobCode")%> - <%# DataBinder.Eval(Container.DataItem, "JobCodeDesc")%>
                            </td>
                            <td width="12%" align="center">
                                <%# DataBinder.Eval(Container.DataItem, "ComponentCode")%> - <%# DataBinder.Eval(Container.DataItem, "ComponentCodeDesc")%>
                            </td>
                            <td width="12%" align="center">
                                <%# DataBinder.Eval(Container.DataItem, "ModifierCode")%> - <%# DataBinder.Eval(Container.DataItem, "ModifierDesc")%>
                            </td>
                            <td width="5%" align="center">
                                <%# DataBinder.Eval(Container.DataItem, "QuantityCode")%> - <%# DataBinder.Eval(Container.DataItem, "QuantityDesc")%>
                            </td>
                            <td width="12%" align="center">
                                <%# DataBinder.Eval(Container.DataItem, "ChargeCode") %>
                            </td>
                            <td width="5%" align="center">
                                <%# Helpers.Util.NumberFormat(DataBinder.Eval(Container.DataItem, "FRPriceHours").AsDouble(0.00), 2, -1, -1, -1, true) %>
                            </td>
                            <td width="8%" align="center">
                                <%# Helpers.Util.NumberFormat(DataBinder.Eval(Container.DataItem, "PartsStdDollarAmount").AsDouble(0.00), 2, -1, -1, -1, true) %>
                            </td>
                            <td width="8%" align="center">
                                <%# Helpers.Util.NumberFormat(DataBinder.Eval(Container.DataItem, "LabourStdDollarAmount").AsDouble(0.00), 2, -1, -1, -1, true) %>
                            </td>
                            <td width="8%" align="center">
                                <%# Helpers.Util.NumberFormat(DataBinder.Eval(Container.DataItem, "MiscStdDollarAmount").AsDouble(0.00), 2, -1, -1, -1, true) %>
                            </td>
                            <td width="8%" align="center">
                                <%# Helpers.Util.NumberFormat(DataBinder.Eval(Container.DataItem, "PartsStdDollarAmount").AsDouble(0.00) + DataBinder.Eval(Container.DataItem, "LabourStdDollarAmount").AsDouble(0.00) + DataBinder.Eval(Container.DataItem, "MiscStdDollarAmount").AsDouble(0.00), 2, -1, -1, -1, true) %>    <%--//<CODE_TAG_104228>--%>
                            </td>
                            <td width="12%" align="center">
                                <%# DataBinder.Eval(Container.DataItem, "FeaturesAndBenefits") %>
                            </td>
                            <!--CODE_TAG_105504-->
							<% if (ChargeCodeEnabled) {%>
                            <td>
                                <asp:DropDownList ID="lstCostCenterCode" CssClass="CostCenterCode" runat="server"></asp:DropDownList>
                            </td>
                            <%} %>
							<!--/CODE_TAG_105504-->
                        </tr>
                </AlternatingItemTemplate>
                <FooterTemplate>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
            <asp:Label ID="lblStandardJobErrorMessage" CssClass="errorMessage" runat="Server" Text=""></asp:Label>
            <!--/CODE_TAG_101936-->
            </div>
        </fieldset>
    </div>
    <!--CODE_TAG_103560-->
    <div id="divDBSPartDocuments"  runat="server"  clientidmode="Static">
    
        <fieldset>
            <legend>DBS Part Documents</legend>Please search DBS Part Documents:
            <img alt="show" src="../../../library/images/magnifier.gif" onclick="parent.showDBSPartDocumentsSearch();" class='imgBtn' />
            <asp:Button ID="btnOK_CopyFromDBSPartDocuments"  Style="float: right"  OnClientClick="return  validation();" Text="OK" runat="server" onclick="btnOK_CopyFromDBSPartDocuments_Click" />    
            <asp:Button ID="btnDBSPartDocumentsGetData" Style="display: none" Text="GetData" runat="server"  ClientIDMode="Static" onclick="btnDBSPartDocumentsGetData_Click" />
            <asp:HiddenField ID="hidDBSPartDocumentIds" Value="" runat="server" />
            <div id="divDBSPartDocumentList" visible="false" runat="server">
            <asp:Repeater ID="repDBSPartDocumentList" runat="server"  
                    onitemdatabound="repDBSPartDocumentList_ItemDataBound">
                <HeaderTemplate>
                    <table class='segmentSearchResult'>
                        <tr class="reportHeader">
                            <th style='width: 40px'>Seg No<span style="color: red">*</span></th>
                            <th>Document Number</th>
                            <th>Store</th>
                            <th>Customer Number</th>
                        </tr>
                    
                </HeaderTemplate>
                <ItemTemplate>
                        <tr class="rd">
                            <td>
                                <asp:TextBox ID="txtQuoteSegNo" MaxLength="2" Text='<%# DataBinder.Eval(Container.DataItem, "SegmentNo")%>'  runat="server" Style="width: 20px"></asp:TextBox>
                                <asp:HiddenField ID="docNo" Value='<%# DataBinder.Eval(Container.DataItem, "DocumentNumber").ToString().Trim( ) %>' runat="server" />
                            </td>
                            <td>
                                <%# DataBinder.Eval(Container.DataItem, "DocumentNumber") %>
                            </td>
                            <td>
                                <%# DataBinder.Eval(Container.DataItem, "Store") %>
                            </td>
                            <td>
                                <%# DataBinder.Eval(Container.DataItem, "CustomerNumber") %>
                            </td>
                        </tr>
                </ItemTemplate>
                        
                <AlternatingItemTemplate>
                        <tr class="rl">
                            <td>
                                <asp:TextBox ID="txtQuoteSegNo" MaxLength="2" Text='<%# DataBinder.Eval(Container.DataItem, "SegmentNo")%>'  runat="server" Style="width: 20px"></asp:TextBox>
                                <asp:HiddenField ID="docNo" Value='<%# DataBinder.Eval(Container.DataItem, "DocumentNumber").ToString().Trim( ) %>' runat="server" />
                            </td>
                            <td>
                                <%# DataBinder.Eval(Container.DataItem, "DocumentNumber") %>
                            </td>
                            <td>
                                <%# DataBinder.Eval(Container.DataItem, "Store") %>
                            </td>
                            <td>
                                <%# DataBinder.Eval(Container.DataItem, "CustomerNumber") %>
                            </td>
                        </tr>
                </AlternatingItemTemplate>
                <FooterTemplate>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
            <asp:Label ID="lblDBSPartDocumentsErrorMessage" CssClass="errorMessage" runat="Server" Text=""></asp:Label>
            </div>
        </fieldset>
    </div>
    <!--/CODE_TAG_103560-->
    <span id="spanWaitting" style='position: absolute;top:40%;left:50%; display:none'><img id="spanWaittingImg" src='' /></span>

   
    <asp:HiddenField ID="hidRefreshParent" Value="" runat="server" />
    <asp:HiddenField ID="hidNewSegmentData" Value="" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hidManualData" Value="" runat="server" ClientIDMode="Static" />
    <script type="text/javascript">
        //<CODE_TAG_101936>
        $(function () {
            if ($('[id*=hidRefreshParent]').val() == "1") {
                parent.reloadPage(<%=QuoteId %>,<%=Revision %>, <%= NewSegmentId %>  );    
                $("#spanWaitting").show();
                $("#spanWaitting img").attr("src", "../../../Library/images/waiting.gif");
            }

            resizeParentiFrame();     

            if ("WO" == '<% =CopyFrom %>' || "LINKWO" == '<% =CopyFrom %>' )
            {
                $("#rdoWorkorder").attr("checked", "checked");
                segmentsource_onChange('CopyFromWorkorder');
                    if (parent.RedirectURL == '') //<CODE_TAG_103400>  this stops Work Order Segment Search Window show up again on Save
                        parent.showWOSegmentSearch();
            }


            if ("Quote" == '<% =CopyFrom %>')
            {
                $("#rdoQuote").attr("checked", "checked");
                segmentsource_onChange('CopyFromQuote');
                    parent.showQuoteSegmentSearch();
            }
        });
        //</CODE_TAG_101936>
        function validation()
        {
           var strSegmentData = GetNewSegmentData();
           if (strSegmentData == "")
           {
             alert("Please finish segment data." );
             return false;
           }
           else
           {
             $("#hidNewSegmentData").val(strSegmentData);

             
             $("#btnOK_Manual").hide(); 
             $("#btnOK_CopyFromQuote").hide(); 
             $("#btnOK_CopyFromWorkorder").hide(); 
             $("#btnOK_CopyFromStandardJob").hide(); 
             $("#btnOK_CopyFromDBSPartDocuments").hide(); //<CODE_TAG_103560>

             $("#spanWaitting").show();
             $("#spanWaitting img").attr("src", "../../../Library/images/waiting.gif");
             
            return true;
           }
        }

        function GetNewSegmentSourceType()
        {
            //1: Manual  2: copy from Quote  3: copy from workorder 4: Copy from Standard Job 5: copy from DBS Part Documents
            var rt = 1;
            if ($("[id*=rdoQuote]").is(":checked"))  rt = 2;
            if ($("[id*=rdoWorkorder]").is(":checked"))  rt = 3;
            if ($("[id*=rdoStandardJob]").is(":checked"))  rt = 4;
            if ($("[id*=rdoDBSPartDocuments]").is(":checked"))  rt = 5;  //<CODE_TAG_103560>
            return rt;
        }

        function GetNewSegmentData()
        {
            var rt = "";
            var newSegmentNo="";
            var rtXML = "";
            var wono="";
            var segmentId="";
            var woSegmentNo="";
            var hasError = false;
            var stApplicationCodeSelected //<CODE_TAG_103916>
            //<CODE_TAG_101936>
            var stSegmentNo = "";
            var stROId = "";
            var stROPId = "";
            var stGroup = "";
            var stCC = "";
            //</CODE_TAG_101936>
            var documentNo = ""; //<CODE_TAG_103560>
            //Manual
            if (GetNewSegmentSourceType() == 1)
            {
                //rt = $("[id*=txtManualSegmentNo]").val();
                newSegmentNo = $.trim($("[id*=txtManualSegmentNo]").val());
                if (newSegmentNo != "")
                {
                    rtXML = "<Segments>";
                    rtXML += "<Segment>";
                    rtXML += "<newSegmentNo>" + newSegmentNo + "</newSegmentNo>";
                    rtXML += $('#hidManualData').val();
                    rtXML += "</Segment>";
                    rtXML += "</Segments>";
                }
                rt = rtXML;
            }

            //Copy from Quote
            if (GetNewSegmentSourceType() == 2)
            {
                rtXML = "<Segments>";
                $("#divQuote").find("tr:gt(0)").each(function (i,e){

                    newSegmentNo = $(e).find("[id*=txtQuoteSegNo]").val();
                    segmentId = $(e).find("[id*=segmentId]").val();
                    stCC = $(e).find("[id*=lstCostCenterCode]").val();
                    newSegmentNo = jQuery.trim(newSegmentNo);
                    if (newSegmentNo == "")
                        hasError = true;

                    rtXML += "<Segment>";
                    rtXML += "<id>" + i + "</id>";
                    rtXML += "<newSegmentNo>" + newSegmentNo + "</newSegmentNo>";
                    rtXML += "<segmentId>" + segmentId + "</segmentId>";
                    rtXML += "<stCC>" + stCC + "</stCC>";
                    rtXML += "</Segment>";
                });
            
                rtXML += "</Segments>";

                if (rtXML == "<Segments></Segments>" || hasError) rtXML="";
                rt = rtXML;

            }

            //Copy from workorder
            if (GetNewSegmentSourceType() == 3)
            {
                rtXML = "<Segments>";
                $("#divWorkorder").find("tr:gt(0)").each(function (i,e){

                    newSegmentNo = $(e).find("[id*=txtQuoteSegNo]").val();
                    wono = $(e).find("[id*=wono]").val();
                    woSegmentNo = $(e).find("[id*=segmentNo]").val();
                    stCC = $(e).find("[id*=lstCostCenterCode]").val();
                    newSegmentNo = jQuery.trim(newSegmentNo);
                    if (newSegmentNo == "")
                        hasError = true;

                    rtXML += "<Segment>";
                    rtXML += "<id>" + i + "</id>";
                    rtXML += "<newSegmentNo>" + newSegmentNo + "</newSegmentNo>";
                    rtXML += "<woNo>" + wono + "</woNo>";
                    rtXML += "<woSegmentNo>" + woSegmentNo + "</woSegmentNo>";
                    rtXML += "<stCC>" + stCC + "</stCC>";
                    rtXML += "</Segment>";
                });
            
                rtXML += "</Segments>";

                if (rtXML == "<Segments></Segments>" || hasError) rtXML="";
                rt = rtXML;
            }

            //Copy from Standard Job
            //<CODE_TAG_101936>
            if (GetNewSegmentSourceType() == 4)
            {
                rtXML = "<Segments>";
                $("#divStandardJob").find("tr:gt(0)").each(function (i,e){

                    stSegmentNo = $(e).find("[id*=txtQuoteSegNo]").val();
                    stROId =  $(e).find("[id*=hidROId]").val();
                    stROPId =  $(e).find("[id*=hidROPId]").val();
                    stROPId_Array =  $("[id*=hidStandardJobROPId]").val();
                    stGroup = $("[id*=hidStandardJobSelectedGroup]").val();
                    sType_Array =  $("[id*=hidStandardJobSType]").val();
                    //stCC = $(e).find("[id*=lstCostCenterCode]").val();
                    ////stCC = $("[id*=lstCostCenterCode]").val();
                    //stApplicationCodeSelected = $("[id*=hidWorkApplicationCodeSelected]").val(); //<CODE_TAG_103916>
                    //<CODE_TAG_105504>R.Z
					<% if (ChargeCodeEnabled) {%>
                    stCC = $(e).find("[id*=lstCostCenterCode]").val();
                    stApplicationCodeSelected = $("[id*=hidWorkApplicationCodeSelected]").val(); //<CODE_TAG_103916>
					<%} else { %>
                    stCC="%%";
                    stApplicationCodeSelected = "%%";
                    <%}%>
                    //</CODE_TAG_105504>
                    if (stSegmentNo == "")
                        hasError = true;
                    if (stCC == "")
                        hasError = true;
                    
                    var index = 0;
                    index = jQuery.inArray(stROPId,stROPId_Array.split(","));
                    //alert(index + '--stROId:' + stROPId)
                    rtXML += "<Segment>";
                    rtXML += "<id>" + index + "</id>";
                    rtXML += "<stSegmentNo>" + stSegmentNo + "</stSegmentNo>";
                    rtXML += "<stROId>" + stROId + "</stROId>";
                    rtXML += "<stROPId>" + stROPId + "</stROPId>";
                    rtXML += "<stGroup>" + stGroup.split(",")[index] + "</stGroup>";
                    rtXML += "<stCC>" + stCC + "</stCC>";
                    rtXML += "<stAppCode>" + stApplicationCodeSelected + "</stAppCode>"; //<CODE_TAG_103916>
                    rtXML += "</Segment>";
                });
            
                rtXML += "</Segments>";
                if (rtXML == "<Segments></Segments>" || hasError) rtXML="";
                rt = rtXML;
            }
            //</CODE_TAG_101936>
            //<CODE_TAG_103560>
            //Copy from DBS Part Documents
            if (GetNewSegmentSourceType() == 5)
            {
                rtXML = "<Segments>";
                $("#divDBSPartDocuments").find("tr:gt(0)").each(function (i,e){

                    newSegmentNo = $(e).find("[id*=txtQuoteSegNo]").val();
                    documentNo= $(e).find("[id*=docNo]").val();
                    
                    if (newSegmentNo == "")
                        hasError = true;

                    rtXML += "<Segment>";
                    rtXML += "<id>" + i + "</id>";
                    rtXML += "<newSegmentNo>" + newSegmentNo + "</newSegmentNo>";
                    rtXML += "<docNo>" + documentNo + "</docNo>";
                    rtXML += "</Segment>";
                });
            
                rtXML += "</Segments>";

                if (rtXML == "<Segments></Segments>" || hasError) rtXML="";
                rt = rtXML;
            }
            //</CODE_TAG_103560>
            return (rt);
        }
        function setupWOSegmentNo(Ids)
        {
            $("#spanWaitting").show();
            $("#spanWaitting img").attr("src", "../../../Library/images/waiting.gif");
            $("[id*=hidWOSegmentIds]").val(Ids);

            $("#btnWOGetData").click();
        }


        function setupQuoteSegmentNo(Ids)
        {

            $("#spanWaitting").show();
            $("#spanWaitting img").attr("src", "../../../Library/images/waiting.gif");
            $("[id*=hidQuoteSegmentIds]").val(Ids);
            $("#btnQuoteGetData").click();
        }

        //<CODE_TAG_103560>
        function setupDBSPartDocumentNo(DocNos)
        {
        
            $("#spanWaitting").show();
            $("#spanWaitting img").attr("src", "../../../Library/images/waiting.gif");
            $("[id*=hidDBSPartDocumentIds]").val(DocNos);
            $("#btnDBSPartDocumentsGetData").click();

        }
        //</CODE_TAG_103560>
        function segmentsource_onChange(source)
        {
            $("#divManual").hide();
            $("#divQuote").hide();
            $("#divWorkorder").hide();
            $("#divStandardJob").hide();
            $("#divDBSPartDocuments").hide();//<CODE_TAG_103560>
            switch (source) {
                case "CopyFromQuote":
                    $("#divQuote").show();
                    break;
                case "CopyFromWorkorder":
                    $("#divWorkorder").show();
                    break;
                case "CopyFromStandardJob":
                    $("#divStandardJob").show();
                    break;
//<CODE_TAG_103560>
                case "CopyFromDBSPartDocuments":
                    $("#divDBSPartDocuments").show();
                    break;
//</CODE_TAG_103560>
                default:
                    $("#divManual").show();
                    break;
            }
            resizeParentiFrame();
        }

        function resizeParentiFrame(){
            if(typeof(parent.resizeIframe) == "function"){
                parent.resizeIframe(parent.window.frames[window.name].name); 
            }
        }

        //function setupStandardJob(iDBSROId, iRepairOptionPricingID, selectedGroup)
        function setupStandardJob(iDBSROId, iRepairOptionPricingID, selectedGroup, stAppCode, sType) //<CODE_TAG_103916>
        {
            
            $("#spanWaitting").show();
            $("#spanWaitting img").attr("src", "../../../Library/images/waiting.gif");
            $("[id*=hidStandardJobROId]").val(iDBSROId);
            $("[id*=hidStandardJobROPId]").val(iRepairOptionPricingID);
            $("[id*=hidStandardJobSelectedGroup]").val(selectedGroup);
            $("#hidWorkApplicationCodeSelected").val(stAppCode);//<CODE_TAG_103916>
            $("[id*=hidStandardJobSType]").val(sType);
            $("#btnStandardJobGetData").click();
            
        }


        function GetCopyNotes()
        {
            var rt = "1";
            //Copy from Quote
            if (GetNewSegmentSourceType() == 2)
            {
                if ($('#chkQuote_CopyNotes').is(':checked')) rt = "2";
            }

            //Copy from workorder
            if (GetNewSegmentSourceType() == 3)
            {
                if ($('#chkWorkOrder_CopyNotes').is(':checked')) rt = "2";            
            }

            //copy from standard job
            if (GetNewSegmentSourceType() == 4)
            {
                if ($('#chkStandardJob_CopyNotes').is(':checked')) rt = "2";            
            }
            return (rt);
        }
        //<CODE_TAG_101936>
        var strCostCentreCodeList = "<%= CostCentreCodeList %>";
        var arrCostCentreCode = strCostCentreCodeList.split(String.fromCharCode(5));

        function reloadCCC() {
            reloadCostCentreCode(arrCostCentreCode, $("[id*=hidCurrBranch]").val());
        }
        function reloadCostCentreCode(arrCCCode, curSC) {
            
            $("[id*=hidCostCenterCode]").val(arrCCCode); 
            $("[id*=hidCurrBranch]").val(curSC); 
            $(".CostCenterCode").html("");
            $("<option value=''></option>").appendTo(".CostCenterCode");
            $.each(arrCCCode, function (index, value) {
                var arrStr = value.split("|");
                var costCentreCode = arrStr[0];
                var costCentreName = arrStr[1];
                var storeCode = arrStr[2];
                if (curSC == storeCode)
                    $("<option value='" + costCentreCode + "'>" + costCentreCode + '-' + costCentreName + "</option>").appendTo(".CostCenterCode");
            });

            //reloadLaborChargeCode();
            //reloadMiscChargeCode();
        }
        //</CODE_TAG_101936>
       
    </script>
</asp:Content>
