<%@ Page Title="" Language="C#" MasterPageFile="~/Library/MasterPages/_base.master"
    AutoEventWireup="true" CodeFile="Quote_Summary.aspx.cs" Inherits="Modules_Quote_Summary" %>

<%@ Register Src="Controls/QuoteHeader.ascx" TagName="QutoeHeader" TagPrefix="uc1" %>
<%@ Register Src="Controls/Financials.ascx" TagName="Financials" TagPrefix="uc3" %>
<%@ Register Src="Controls/Notes.ascx" TagName="Notes" TagPrefix="uc5" %>
<asp:Content ID="Content5" ContentPlaceHolderID="cntMP" runat="Server">
    <uc1:QutoeHeader ID="quoteHeader" runat="server"></uc1:QutoeHeader>
    <asp:ScriptManager ID="scriptmanager1" runat="Server" AsyncPostBackTimeout="120"
        EnableScriptGlobalization="True" />
    <table width="100%">
        <tr>
            <td class="tAr">
                 <%  //<CODE_TAG_105318> lwang 
                     if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.RepricingWhenQuoteIsOpen")) { %>
                    <asp:Button ID="btnLaborRepricing" runat="server" Text="Labor Repricing"  ClientIDMode="Static" OnClick="btnLaborRepricing_Click" />
                <%} //</CODE_TAG_105318> lwang %>
                <asp:Button ID="btnEdit" runat="server" Text="Edit"  ClientIDMode="Static" OnClick="btnPageEdit_Click" OnClientClick="btnEditClick()" /> <!--CODE_TAG_104119-->
                <asp:Button ID="btnSave" runat="server" Text="Save" ClientIDMode="Static"  style="display:none"   OnClick="btnPageSave_Click" /> <!--CODE_TAG_104119-->
                <input type="button" id="inptBtnSave" onclick="return serializeFormData();"   value="Save" /> <!--CODE_TAG_104119-->
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnPageCancel_Click" />
                <asp:HiddenField ID="hdnInptBtnSaveShowInd"  ClientIDMode="Static" Value="0" runat="server" /><!--CODE_TAG_104119-->
            </td>
        </tr>
    </table>
    <div id="accordion">
        <h3>
            <a href="#">Notes <span id="spanDetailCountExternalNotes"></span></a>
        </h3>
        <div>
            <uc5:Notes ID="ucNotes" runat="server"></uc5:Notes>
        </div>
        <h3>
            <a href="#">Special Instructions <span id="spanDetailCountInstructions"></span></a>
        </h3>
        <div>
            <div>
                <!--CODE_TAG_103379-->
                <% if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Notes.MultiLineEdit.Show"))  { %>
                * Only first 4 lines are sent to DBS work orders.
                <%  } %>
                <!--CODE_TAG_103379-->
            </div>
            <uc5:Notes ID="ucInstructions" runat="server"></uc5:Notes>
        </div>
        <h3>
            <a href="#">Segment Summary <span id="spanDetailCountParts"></span></a>
        </h3>
        <div>
            <asp:UpdatePanel ID="up1" runat="server">
                <ContentTemplate>
                    <table style="margin: 5px 0 5px; width: 100%">
                        <tr>
                            <th class="tSb" style="width: 25%">
                                &nbsp;
                            </th>
                            <td style="width: 25%">
                                &nbsp;
                                <%-- Current Status:
                        <asp:Label ID="lblQuoteCurrentRevisionStatus" runat="server" Text=""></asp:Label>--%>
                            </td>
                            <td style="width: 25%">
                                <asp:Label ID="lblQuoteCurrentRevisionUpdateInfo" runat="server" Text=""></asp:Label>
                            </td>
                            <td style="text-align: right; width: 25%">
                                <asp:DropDownList ID="lstCustomer" runat="server" AutoPostBack="true" OnSelectedIndexChanged="lstCustomer_SelectedIndexChanged">
                                </asp:DropDownList>
                                <asp:Label ID="lblCustomer" runat="server"></asp:Label>
                            </td>
                        </tr>
                    </table>
                    <div class="quoteSummary">
                        <asp:Repeater ID="repSegments" runat="server" OnItemDataBound="repSegments_ItemDataBound">
                            <HeaderTemplate>
                                <table>
                                    <tr class="reportHeader">
                                        <td class="tSb tAc tCb">
                                            Seg
                                        </td>
                                        <td class="tSb tCb">
                                            Job Code
                                        </td>
                                        <td class="tSb tCb">
                                            Comp Code
                                        </td>
                                        <td class="tSb tCb">
                                            Job Code Desc
                                        </td>
                                        <td class="tSb tCb">
                                            Comp Code Desc
                                        </td>
                                        <td colspan="2" class="tSb tAc tCb">
                                            Parts$
                                        </td>
                                        <td colspan="2" class="tSb tAc tCb">
                                            Labor$
                                        </td>
                                        <td colspan="2" class="tSb tAc tCb">
                                            Misc$
                                        </td>
                                        <td colspan="2" class="tSb tAc tCb">
                                            Total$
                                        </td>
                                        <td class="tSb tAc">
                                            Qty
                                        </td>
                                        <td  class="tSb tAc">
                                            Seg Total$
                                        </td>
                                    </tr>
                            </HeaderTemplate>
                            <AlternatingItemTemplate>
                                <tr class="reportContentEvenRow">
                                    <td class="tAc">
                                        <asp:PlaceHolder ID="plhSegmentNo" runat="server"></asp:PlaceHolder>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblJobCode" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblComponentCode" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblJobCodeDesc" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblComponentCodeDesc" runat="server"></asp:Label>
                                    </td>
                                    <td class="tAr">
                                        <asp:Label ID="lblPartsFlatRateAmount" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblPartsFlatRateInd" runat="server"></asp:Label>
                                    </td>
                                    <td class="tAr">
                                        <asp:Label ID="lblLaborFlatRateAmount" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblLaborFlatRateInd" runat="server"></asp:Label>
                                    </td>
                                    <td class="tAr">
                                        <asp:Label ID="lblMiscFlatRateAmount" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblMiscFlatRateInd" runat="server"></asp:Label>
                                    </td>
                                    <td class="tAr">
                                        <asp:Label ID="lblTotalFlatRateAmount" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblTotalFlatRateInd" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblSegQty" runat="server"></asp:Label>
                                    </td>
                                    <td class="tAr">
                                        <asp:Label ID="lblSegTotalFlatRateAmount" runat="server"></asp:Label>
                                    </td>
<%--                                    <td>
                                        <asp:Label ID="lblSegTotalFlatRateInd" runat="server"></asp:Label>
                                    </td>--%>
                                </tr>
                            </AlternatingItemTemplate>
                            <ItemTemplate>
                                <tr class="reportContentOddRow">
                                    <td class="tAc">
                                        <asp:PlaceHolder ID="plhSegmentNo" runat="server"></asp:PlaceHolder>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblJobCode" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblComponentCode" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblJobCodeDesc" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblComponentCodeDesc" runat="server"></asp:Label>
                                    </td>
                                    <td class="tAr">
                                        <asp:Label ID="lblPartsFlatRateAmount" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblPartsFlatRateInd" runat="server"></asp:Label>
                                    </td>
                                    <td class="tAr">
                                        <asp:Label ID="lblLaborFlatRateAmount" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblLaborFlatRateInd" runat="server"></asp:Label>
                                    </td>
                                    <td class="tAr">
                                        <asp:Label ID="lblMiscFlatRateAmount" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblMiscFlatRateInd" runat="server"></asp:Label>
                                    </td>
                                    <td class="tAr">
                                        <asp:Label ID="lblTotalFlatRateAmount" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblTotalFlatRateInd" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="lblSegQty" runat="server"></asp:Label>
                                    </td>
                                    <td class="tAr">
                                        <asp:Label ID="lblSegTotalFlatRateAmount" runat="server"></asp:Label>
                                    </td>
<%--                                    <td>
                                        <asp:Label ID="lblSegTotalFlatRateInd" runat="server"></asp:Label>
                                    </td>--%>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                <tr class="reportFooter">
                                    <td colspan="5" class="tSb tCb">
                                        Total
                                    </td>
                                    <td class="tSb tAr tCb">
                                        <asp:Label ID="lblTotalPartsFlatRateAmount" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                    </td>
                                    <td class="tSb tAr tCb">
                                        <asp:Label ID="lblTotalLaborFlatRateAmount" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                    </td>
                                    <td class="tSb tAr tCb">
                                        <asp:Label ID="lblTotalMiscFlatRateAmount" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                    </td>
                                    <td class="tSb tAr tCb">
                                        <asp:Label ID="lblTotalTotalFlatRateAmount" runat="server"></asp:Label>
                                    </td>
                                    <td>
                                    </td>
                                    <td></td>
                                    <td class="tSb tAr">
                                        <asp:Label ID="lblTotalSegTotalFlatRateAmount" runat="server"></asp:Label>
                                    </td>
<%--                                    <td></td>--%>
                                </tr>
                                </table>
                            </FooterTemplate>
                        </asp:Repeater>
                    </div>
                    <div id="divRevisionFinancial" style="display: initial">
                        <uc3:Financials ID="ucFinancials" runat="server"></uc3:Financials>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
            <span style='position: absolute; top: 40%; left: 50%;'>
                <asp:UpdateProgress runat="server" AssociatedUpdatePanelID="up1">
                    <ProgressTemplate>
                        <img alt="" src="../../Library/images/waiting.gif" />
                    </ProgressTemplate>
                </asp:UpdateProgress>
            </span>
        </div>
    </div>
    <asp:HiddenField ID="hidExternalNotes" Value='' ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hidExternalNotesMasterIndicators" Value='' ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hidInstructions" Value='' ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hidExternalNotesCount" Value='0' ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hidInstructionsCount" Value='0' ClientIDMode="Static" runat="server" />

    <script type="text/javascript">
        $(function () {
            $("#accordion").addClass("ui-accordion ui-accordion-icons ui-widget ui-helper-reset")
                                    .find("h3")
                                    .addClass("ui-accordion-header ui-helper-reset ui-state-default ui-corner-top ui-corner-bottom ui-state-active")
                                    .prepend('<span class="ui-icon ui-icon-triangle-1-e"></span>')
                                    .click(function () {
                                        $(this)
                                        .toggleClass("ui-accordion-header-active  ui-state-default ui-corner-bottom")
                                        .find("> .ui-icon").toggleClass("ui-icon-triangle-1-e ui-icon-triangle-1-s").end()
                                        .next().toggleClass("ui-accordion-content-active").slideToggle();

                                        return false;
                                    })
                                    .next()
                                      .addClass("ui-accordion-content  ui-helper-reset ui-widget-content ui-corner-bottom")
                                      .show();
            $("#accordion").find("h3").first().click();
            $("#accordion").find("h3").eq(1).click();
        });
        //****************************************************************************************************************************

        $(function () {
            displayNote("ExternalNotes");
            displayNote("Instructions");
            displayDetailCount();
        });

        function displayDetailCount() {
            //<CODE_TAG_103379>
            <%if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Notes.MultiLineEdit.Show")) { %>
            $("#spanDetailCountExternalNotes").html("(" + $("#hidExternalNotesCount").val() + ")");
            $("#spanDetailCountInstructions").html("(" + $("#hidInstructionsCount").val() + ")");
            <%}  
            else {
            if ( (multiLineNote!=null) && (!string.IsNullOrEmpty(multiLineNote.Replace("~",""))) ) //show check icon only the multiple-line notes not empty 
                    {                   
                    %>
                    
                        $("#spanDetailCountExternalNotes").html("(" + "<img src='../../Library/images/check.gif' /> " + ")");
                    <%
                    }
                    if ( !string.IsNullOrEmpty(multilineInstruction) ) //show check icon only the multiple-line special instructions not empty 
                    {%>
                        $("#spanDetailCountInstructions").html("(" + "<img src='../../Library/images/check.gif' /> " +")");
                    <%} 

                 } %>
            //</CODE_TAG_103379>
        }
        //<CODE_TAG_104119>
        function inputBtnSaveClick() {
            
                $("#btnEdit").show();
                $("#inptBtnSave").hide();
        }
        function btnEditClick() {
            $("#btnEdit").hide();
            $("#inptBtnSave").show();
        } 
        setupInptBtnSaveDisplayState();
        function setupInptBtnSaveDisplayState() {
            if($("#hdnInptBtnSaveShowInd").val() =="2")
            {
                 $("#inptBtnSave").show();
            }
            else
            {
                $("#inptBtnSave").hide();
            }
            
        }

        //</CODE_TAG_104119>
        function serializeFormData() {
            pageDataChanged = false;  //<CODE_TAG_104819>
            inputBtnSaveClick();  //<CODE_TAG_104119>
            saveNote("ExternalNotes");
            $("#hidExternalNotesMasterIndicators").val(ExternalNotesMasterIndicators);
            saveNote("Instructions");

            $("#hidExternalNotes").val(ExternalNotesNotes);
            $("#hidInstructions").val(InstructionsNotes);

            if ($('[id*=chkEnvironmental]').is(':checked'))
                $('#hidEnvironmental').val("1");
            else
                $('#hidEnvironmental').val("2");
            //<CODE_TAG_104119>
            <%if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Summary.RevisionFinancialsSummary.Show")) { %>//<CODE_TAG_104368>
                var retVal = true;
                if ($j(".financialsTable").length > 0)  //<CODE_TAG_105384> lwang
                    retVal = saveValidation();
                else $("#btnSave").click();  //<CODE_TAG_105384> lwang
            //<CODE_TAG_104368>
            <% } else {%> //<CODE_TAG_104368>
                $("#btnSave").click();
            <% }%>
            //</CODE_TAG_104368>
            
                if (!retVal)
                    return retVal;

            //</CODE_TAG_104119>
            return true;
        }
        //Ticket No:  19813  
        //<CODE_TAG_104819>
        var checkChangesEnabled = true;

        window.onbeforeunload = function (e) {
            if (checkChangesEnabled && pageDataChanged && allowDataChangedWarning && '2' == '<%= AppContext.Current.AppSettings["psQuoter.AllowDataChangedWarning"].AsString() %>') {
                event.returnValue = "The quote data is changed.";
                disableLeavingCheck();
            }
        }
        //</CODE_TAG_104819>
        //<CODE_TAG_102203>


        $("div.SegmentNotes input").bind("keydown",
            function () {
                if (event.keyCode == 13) event.keyCode = 9;
            }
        );


        //</CODE_TAG_102203>
    </script>
</asp:Content>
