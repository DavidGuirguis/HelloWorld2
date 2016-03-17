<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Financials.ascx.cs" Inherits="Modules_Quote_Controls_Financials" %>
<div style="margin-top: 10px;">
    <div class="tSb" style="margin-bottom: 5px;">
        Revision Financials Summary</div>
    <asp:Repeater ID="rptFinancials" runat="server" OnItemDataBound="rptFinancials_OnItemDataBound">
        <HeaderTemplate>
            <table class="financialsTable">
                <col width="300px" />
                <col width="60px" />
                <col width="80px" />
                <tr class="reportHeader">
                    <td align="left" class="tCb">
                        Name
                    </td>
                    <td align="right" class="tCb">
                        Percent
                    </td>
                    <td align="right" class="tCb">
                        Amount
                    </td>
                    <td align="left" class="tCb">
                    </td>
                </tr>
        </HeaderTemplate>
        <ItemTemplate>
            <tr id="itemRow" runat="server">
                <td>
                    <asp:Label ID="lblFinancialsItemName" runat="server" Width="100%"></asp:Label>
                </td>
                <td align="right">
                    <asp:Label ID="lblFinancialsItemPercent" runat="server" Width="100%"></asp:Label>
                </td>
                <td align="right">
                    <asp:Label ID="lblFinancialsItemAmount" runat="server" Width="100%"></asp:Label>
                    <asp:TextBox ID="tbxFinancialsItemAmount" runat="server" class="w90p tAr" ></asp:TextBox><!--CODE_TAG_104119-->
                </td>
                <td>
                    <span style="float: left">
                        <asp:CheckBox ID="chkNotApplicable" runat="server" Text="Not Applicable" />
                        &nbsp;&nbsp;
                        <asp:Label ID="lblNotApplicableChangeInfo" runat="server"></asp:Label>
                        &nbsp;&nbsp;&nbsp; </span><span style="float: right">
                        </span>
                </td>
            </tr>
        </ItemTemplate>
        <FooterTemplate>
            </table>
        </FooterTemplate>
    </asp:Repeater>
    <script type="text/javascript">
        function saveValidation() {
            //<CODE_TAG_104119>
            var retVal = true;
            $("[id*='tbxFinancialsItemAmount']").each(function (index, txb) {

                if (isNaN(this.value.replace(/,/g, '')) || (!this.value.replace(/,/g, '').trim())) {
                    alert("The Amount Column Contains Invalid Number.");
                    retVal = false
                    return retVal;
                }

            });
            if (retVal)
                $("#btnSave").click();

            //</CODE_TAG_104119>
            return true;
        }
        //<CODE_TAG_104119>
        function chkNotApplicableSelectChanged(obj) {

            var curTxb = $(obj).closest('tr').find("[id*='tbxFinancialsItemAmount']");
            var curChk = $(obj).closest('tr').find("[id*='chkNotApplicable']");
            //<CODE_TAG_104523>
            <% if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Summary.RevisionFinancialsSummary.FinancialItemAmount.ShowNumberWhenNotApplicable"))  {%>
            var curLbl = $(obj).closest('tr').find("[id*='lblFinancialsItemAmount']");
            <% } %>
            //</CODE_TAG_104523>
            if (curTxb != null) {

                if ($(curChk).is(":checked")) {
                    $(curTxb).attr("readonly", "readonly");
                    $(curTxb).css("background-color", "background-color: #efefef;");
                    //$(curTxb).val("0.00");
                    //<CODE_TAG_104523>
                    <% if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Summary.RevisionFinancialsSummary.FinancialItemAmount.ShowNumberWhenNotApplicable"))  {%>
                    $(curLbl).show();
                    $(curTxb).hide();
                    $(curLbl).removeAttr("readonly");
                    $(curLbl).val("0.00");
                    <% } %>
                    //</CODE_TAG_104523>
                }
                else {
                    $(curTxb).removeAttr("readonly");
                    $(curTxb).css("background-color", "");
                    //<CODE_TAG_104523>
                    <% if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Summary.RevisionFinancialsSummary.FinancialItemAmount.ShowNumberWhenNotApplicable"))  {%>
                    $(curLbl).hide();
                    $(curTxb).show();
                    <% } %>
                    //</CODE_TAG_104523>
                }
            }
        }

        //check the status of each tbxFinancialsItemAmount
        //readonly when its related checkbox chkNotApplicable is check, otherwise editable
        initilalFinancialItemAmoutTextBox();
        function initilalFinancialItemAmoutTextBox() {

            var txbs = $("#divRevisionFinancial").find("[id*='tbxFinancialsItemAmount']");
            var curChk;

            $.each(txbs, function (index, value) {

                var curTxb = value;
                if (curTxb != null) {
                    curChk = $(curTxb).closest('tr').find("[id*='chkNotApplicable']");
                    if ($(curChk).is(":checked")) {
                        $(curTxb).attr("readonly", "readonly");
                        $(curTxb).css("background-color", "background-color: #efefef;");
                        //$(curTxb).val("0.00");

                    }
                    else {
                        $(curTxb).removeAttr("readonly");
                        $(curTxb).css("background-color", "");

                    }

                }
            })

        }
        //</CODE_TAG_104119>
    </script>
</div>