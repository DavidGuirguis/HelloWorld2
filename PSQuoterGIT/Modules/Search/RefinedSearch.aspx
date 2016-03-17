<%@ Page Title="" Language="C#" MasterPageFile="~/Library/MasterPages/_base.master"
    AutoEventWireup="true" CodeFile="RefinedSearch.aspx.cs" Inherits="Modules_AdvancedSearch" %>

<%@ Register TagPrefix="ajaxToolkit" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cntMP" runat="Server">
    <asp:ScriptManager ID="scriptmanager1" runat="Server" AsyncPostBackTimeout="120"
        EnableScriptGlobalization="True">
    </asp:ScriptManager>
    <div id="divSearchbleList" style="position: absolute; background-color: White; display: none;
        z-index: 1000">
    </div>
    <fieldset style=" background-color:rgb(239, 239, 239) ">
        <legend></legend>
        <table width="100%" >
            <tr>
                <th>
                    Make:
                </th>
                <td>&nbsp;<asp:DropDownList ID="lstMake" runat="server" ClientIDMode="Static"  ></asp:DropDownList>
                </td>
                <th>
                    SerialNo (prefix):
                </th>
                <td>
                    <asp:TextBox ID="txtSerialNo" MaxLength="20" runat="server" ClientIDMode="Static"></asp:TextBox>
                </td>
                <th>
                    Model:
                </th>
                <td>
                    <asp:TextBox ID="txtModel" MaxLength="10" runat="server" ClientIDMode="Static"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <th>
                    Job Code:
                </th>
                <td style="white-space: nowrap">
                    <asp:HiddenField ID="hidJobCode" Value="" runat="server" ClientIDMode="Static" />
                    <asp:TextBox ID="txtJobCode" Style="float: left; width: 200px" onkeyup="txtSearchbleListKeyUp('txtJobCode', 'hidJobCode', arrJobCode);"
                        runat="server" MaxLength="50" ></asp:TextBox>
                    <span onclick="displaySearchbleList('','txtJobCode', 'hidJobCode', arrJobCode);">
                        <img style="margin-right: 8px; margin-top: 6px; cursor: pointer" alt="" src="../../library/images/arrowdown.gif" /></span>
                </td>
                <th>
                    Component Code:
                </th>
                <td style="white-space: nowrap">
                    <asp:HiddenField ID="hidComponentCode" Value="" runat="server" ClientIDMode="Static" />
                    <asp:TextBox ID="txtComponentCode" Style="float: left; width: 200px"  
                        onkeyup="txtSearchComponentCodeListKeyUp('txtComponentCode', 'hidComponentCode', arrComponentCode);"
                        runat="server" MaxLength="50"></asp:TextBox>
                    <span onclick="displaySearchbleList('','txtComponentCode', 'hidComponentCode', arrComponentCode);">
                        <img style="margin-right: 8px; margin-top: 6px; cursor: pointer" alt="" src="../../library/images/arrowdown.gif" /></span>
                </td>
                <th>
                    Modifer Code:
                </th>
                <td style="white-space: nowrap">
                    <asp:HiddenField ID="hidModifierCode" Value="" runat="server" ClientIDMode="Static" />
                    <asp:TextBox ID="txtModifierCode" Style="float: left; width: 200px" 
                        onkeyup="txtSearchbleListKeyUp('txtModifierCode', 'hidModifierCode', arrModifierCode);"
                        runat="server" MaxLength="50"></asp:TextBox>
                    <span onclick="displaySearchbleList('','txtModifierCode', 'hidModifierCode', arrModifierCode);">
                        <img style="margin-right: 8px; margin-top: 6px; cursor: pointer" alt="" src="../../library/images/arrowdown.gif" /></span>
                </td>
            </tr>
            <tr>
                <th>
                    Business Group:
                </th>
                <td>&nbsp;<asp:DropDownList ID="lstBusinessGroupCode"  ClientIDMode="Static" runat="server">
                    </asp:DropDownList>
                </td>
                <th>
                    Quantity Code:
                </th>
                <td>&nbsp;<asp:DropDownList ID="lstQuantityCode"  ClientIDMode="Static" runat="server">
                    </asp:DropDownList>
                </td>
                <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.WorkApplicationCode.Show"))
                   { %>
                <th>
                    Work Application Code:
                </th>
                <td>
                    <asp:DropDownList ID="lstWorkApplicationCode"  ClientIDMode="Static"
                        runat="server">
                    </asp:DropDownList>
                </td>
                <%
                   }
                %>
            </tr>
            <tr>
                <th>
                    Store:
                </th>
                <td>&nbsp;<asp:DropDownList ID="lstStoreCode"  ClientIDMode="Static" onchange="reloadCostCentreCode();"
                        runat="server">
                    </asp:DropDownList>
                </td>
                <th>
                    Cost Center:
                </th>
                <td>&nbsp;<asp:DropDownList ID="lstCostCenterCode"  ClientIDMode="Static" runat="server" style="width:152px;">
                        <asp:ListItem Value="" Text=""></asp:ListItem>
                    </asp:DropDownList>
                </td>
                <%if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.CabType.Show"))
                  { %>
                <th>
                    Cab Type:
                </th>
                <td>
                    <asp:DropDownList ID="lstCabTypeCode"  ClientIDMode="Static" runat="server">
                    </asp:DropDownList>
                </td>
                <%} %>
            </tr>
            <tr>
                <th>
                    Shop/Field:
                </th>
                <td>&nbsp;<asp:DropDownList ID="lstShopFieldCode"  ClientIDMode="Static" runat="server">
                    </asp:DropDownList>
                </td>
                <%if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.JobLocation.Show"))
                  { %>
                <th>
                    Job Location:
                </th>
                <td>
                    <asp:DropDownList ID="lstJobLocationCode" TabIndex="12" ClientIDMode="Static" runat="server">
                    </asp:DropDownList>
                </td>
                <td>
                </td>
                <%} %>
            </tr>
            <tr>
                <th colspan="4">
                    Limit Work Orders and Quotes to Latest
                    &nbsp;&nbsp;
                    <input type="radio" id="rdoLimitRecordsByNumber" name="rdoLimitRecords" checked="checked"   value="0" onclick="limitRecords('NUMBER');" />
                    <asp:TextBox ID="txtLimitRecords" style="width:50px; text-align:right  " ClientIDMode="Static" runat="server"></asp:TextBox>
                    records
                     &nbsp;&nbsp;
                    or 
                     &nbsp;&nbsp;
                     <input type="radio" id="rdoLimitRecordsByDate" name="rdoLimitRecords" value="1" onclick="limitRecords('DATE');" />
                     from
                    <asp:TextBox ClientIDMode="Static" runat="server" ID="txtFromDate" CssClass="fe"
                        Width="100px" />
                    <span style="cursor: hand">
                        <img id="imgCalendarFromDate" src="../../Library/images/Calendar_scheduleHS.gif" />
                    </span>


                    <ajaxToolkit:CalendarExtender Format="MMM dd, yyyy" ID="CalendarFromDate" EnabledOnClient="true" 
                        runat="server" TargetControlID="txtFromDate" PopupButtonID="imgCalendarFromDate"
                        OnClientShown="calendarShown" Animated="False" Enabled="True" />
                     to
                    <asp:TextBox ClientIDMode="Static" runat="server" ID="txtToDate" CssClass="fe"
                        Width="100px" />
                    <span style="cursor: hand">
                     <img id="imgCalendarToDate" src="../../Library/images/Calendar_scheduleHS.gif" />
                    </span>
                    <ajaxToolkit:CalendarExtender Format="MMM dd, yyyy" ID="CalendarToDate" EnabledOnClient="true"
                        runat="server" TargetControlID="txtToDate" PopupButtonID="imgCalendarToDate"
                        OnClientShown="calendarShown" Animated="False" Enabled="True"  />

                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="checkbox" id="chkIncludeZero" onclick="setIncludeZero();" /> Include $0 Segments

                </th>
                <td>
                    <input type="button" onclick="SearchAjaxHandler(7);" value="Search" />
                </td>
            </tr>
        </table>
    </fieldset>

    <span id="spanWaitting" style='position: absolute; top: 40%; left: 50%; display: none'>
            <img src='../../Library/images/waiting.gif' /></span>
    <div id="divResult" style="display:none">

    <table id="queryTab" width="100%">
        <tr>
            <td class="tAc">
                <asp:Literal ID="litGroupTabs" runat="server"></asp:Literal>
            </td>
        </tr>
    </table>
    <div>
        
        <div id="divSJResult" style="display: none">
            <div id="divSJResultDetails">
            </div>
        </div>
        <div id="divWOResult">
            <div>
                <table width="100%" style="">
                    <tr>
                        <td class="tSb tAr" style="width: 35%">
                            Total Segments:
                        </td>
                        <td class="tAr" style="width: 5%">
                            <span id="spanWOTotalRecords"></span>
                        </td>
                        <td class="tSb tAr" style="width: 15%">
                            Avg. Parts:
                        </td>
                        <td class="tAr" style="width: 10%">
                            <span id="spanWOAvgPartsAmount"></span>
                        </td>
                        <td style="width: 35%" class="tAr">
                            <a href="javascript:createQuoteFromAvg('WO')">New Quote Using Averages</a>
                        </td>
                    </tr>
                    <tr>
                        <td class="tSb tAr">
                            Excluded Segments:
                        </td>
                        <td class="tAr">
                            <span id="spanWOExcludedRecords"></span>
                        </td>
                        <td class="tSb tAr">
                            Avg. Labor:
                        </td>
                        <td class="tAr">
                            <span id="spanWOAvgLaborAmount"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="tSb tAr">
                            Segments for Average Calculation:
                        </td>
                        <td class="tAr">
                            <span id="spanWOCalculatedRecords"></span>
                        </td>
                        <td class="tSb tAr">
                            Avg. Misc:
                        </td>
                        <td class="tAr">
                            <span id="spanWOAvgMiscAmount"></span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                        <td>
                        </td>
                        <td class="tSb tAr">
                            Avg. Hours:
                        </td>
                        <td class="tAr">
                            <span id="spanWOAvgHours"></span>
                        </td>
                    </tr>
                </table>
            </div>
            <div id="divWOResultDetails">
            </div>
        </div>
        <div id="divQuoteResult" style="display: none">
            <div>
                <table width="100%" style="">
                    <tr>
                        <td class="tSb tAr" style="width: 35%">
                            Total Segments:
                        </td>
                        <td class="tAr" style="width: 5%">
                            <span id="spanQuoteTotalRecords"></span>
                        </td>
                        <td class="tSb tAr" style="width: 15%">
                            Avg. Parts:
                        </td>
                        <td class="tAr" style="width: 10%">
                            <span id="spanQuoteAvgPartsAmount"></span>
                        </td>
                        <td style="width: 35%" class="tAr">
                            <a href="javascript:createQuoteFromAvg('Quote')">New Quote Using Averages</a>
                        </td>
                    </tr>
                    <tr>
                        <td class="tSb tAr">
                            Excluded Segments:
                        </td>
                        <td class="tAr">
                            <span id="spanQuoteExcludedRecords"></span>
                        </td>
                        <td class="tSb tAr">
                            Avg. Labor:
                        </td>
                        <td class="tAr">
                            <span id="spanQuoteAvgLaborAmount"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="tSb tAr">
                            Segments for Average Calculation:
                        </td>
                        <td class="tAr">
                            <span id="spanQuoteCalculatedRecords"></span>
                        </td>
                        <td class="tSb tAr">
                            Avg. Misc:
                        </td>
                        <td class="tAr">
                            <span id="spanQuoteAvgMiscAmount"></span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                        <td>
                        </td>
                        <td class="tSb tAr">
                            Avg. Hours:
                        </td>
                        <td class="tAr">
                            <span id="spanQuoteAvgHours"></span>
                        </td>
                    </tr>
                </table>
            </div>
            <div id="divQuoteResultDetails">
            </div>
        </div>
    </div>
    </div>
    <script type="text/javascript">

        var search_by_type = getSearchByQuerystring("searchbytype"); // may 1, 2012

        var strJobCodeList = "<%=JobCodeList  %>";
        var arrJobCode = strJobCodeList.split(String.fromCharCode(5));

        

        var strComponentCodeList = "<%=ComponentCodeList  %>";
        var arrComponentCode = strComponentCodeList.split(String.fromCharCode(5));
        var lastArrLength = -1;

        var arrComponentCodeLarge = strComponentCodeList.split(String.fromCharCode(5));

        var strModifierCodeList = "<%=ModifierCodeList  %>";
        var arrModifierCode = strModifierCodeList.split(String.fromCharCode(5));

        var strCostCentreCodeList = "<%= CostCentreCodeList %>";
        var arrCostCentreCode = strCostCentreCodeList.split(String.fromCharCode(5));

        var quoteAvgPartsAmount = "0";
        var quoteAvgLaborAmount = "0";
        var quoteAvgMiscAmount = "0";
        var quoteAvgHours = "0";

        var woAvgPartsAmount = "0";
        var woAvgLaborAmount = "0";
        var woAvgMiscAmount = "0";
        var woAvgHours = "0";


        function reloadCostCentreCode() {

            $("#lstCostCenterCode").html("");
            var curStoreCode = $("#lstStoreCode").val();
            $("<option value=''></option>").appendTo("#lstCostCenterCode");
            $.each(arrCostCentreCode, function (index, value) {
                var arrStr = value.split("|");
                var costCentreCode = arrStr[0];
                var costCentreName = arrStr[1];
                var storeCode = arrStr[2];
                if (curStoreCode == storeCode)
                    $("<option value='" + costCentreCode + "'>" + costCentreCode + '-' + costCentreName + "</option>").appendTo("#lstCostCenterCode");
            });

        }

        // Search Ajax handler -----------------------------------------------------------------------------------------------------------
        var callBacking = false;
        function SearchAjaxHandler(refreshSection) {
            var url = "AdvancedSearchAjaxHandler.ashx?";
            url += "make=" + $("#lstMake").val();
            url += "&serialNo=" + $("#txtSerialNo").val();
            url += "&model=" + $("#txtModel").val();
            url += "&jobCode=" + $("#hidJobCode").val();
            url += "&componentCode=" + $("#hidComponentCode").val();
            url += "&modifierCode=" + $("#hidModifierCode").val();
            url += "&businessGroupCode=" + $("#lstBusinessGroupCode").val();
            url += "&quantityCode=" + $("#lstQuantityCode").val();
            if ($("#lstWorkApplicationCode").length > 0)
                url += "&workApplicationCode=" + $("#lstWorkApplicationCode").val();
            url += "&branchCode=" + $("#lstStoreCode").val();

            url += "&costCentreCode=" + $("#lstCostCenterCode").val();

            if ($("#lstCabTypeCode").length > 0)
                url += "&cabTypecde=" + $("#lstCabTypeCode").val();
            url += "&shopField=" + $("#lstShopFieldCode").val();
            if ($("#lstJobLocationCode").length > 0)
                url += "&jobLocationCode=" + $("#lstJobLocationCode").val();
            url += "&fromDate=" + $("#txtFromDate").val();
            url += "&toDate=" + $("#txtToDate").val();
            url += "&limitRecords=" + $("#txtLimitRecords").val();
            if ($('#rdoLimitRecordsByDate').is(':checked'))
                url += "&limitType=Date";
            else
                url += "&limitType=Number";
            if ($('#chkIncludeZero').is(':checked'))
                url += "&IncludeZero=2";


            if ($("#hidSJSortField").length > 0) url += "&sjSortField=" + $("#hidSJSortField").val();
            if ($("#hidSJSortDirection").length > 0) url += "&sjSortDirection=" + $("#hidSJSortDirection").val();
            if ($("#hidWOSortField").length > 0) url += "&woSortField=" + $("#hidWOSortField").val();
            if ($("#hidWOSortDirection").length > 0) url += "&woSortDirection=" + $("#hidWOSortDirection").val();
            if ($("#hidQuoteSortField").length > 0) url += "&quoteSortField=" + $("#hidQuoteSortField").val();
            if ($("#hidQuoteSortDirection").length > 0) url += "&quoteSortDirection=" + $("#hidQuoteSortDirection").val();

            url += "&refreshSection=" + refreshSection;
            //alert(url);
            if (callBacking == false) {
                callBacking == true;
                var request = $.ajax({
                    url: url,
                    type: "GET",
                    cache: false,
                    async: true, //false
                    beforeSend: function () {
                        $("#spanWaitting").show();
                        $("#spanWaitting img").attr("src", "../../Library/images/waiting.gif");
                    },
                    complete: function () {
                        $("#spanWaitting").hide();
                    },
                    success: function (htmlContent) {
                        $("#divResult").show(); 
                        var rtOp = htmlContent.substr(0, 1);  // R: Replace   A: Alert  
                        htmlContent = htmlContent.substr(2);
                        if (rtOp == "R") {
                            var htmlResult = htmlContent.split(String.fromCharCode(5));
                            if ((refreshSection & 1) > 0) {
                                $("#divSJResultDetails").html(htmlResult[0]);
                                if ($('#divSJResultDetails tr').length > 0)
                                    $("#queryTab li[value='1'] a").html("Standard Jobs (" + ($('#divSJResultDetails tr').length - 1) + ")");   //header takes 1 tr
                                else
                                    $("#queryTab li[value='1'] a").html("Standard Jobs (0)");
                            }
                            if ((refreshSection & 2) > 0) {
                                $("#divWOResultDetails").html(htmlResult[1]);
                                $("#queryTab li[value='2'] a").html("Work Orders (" + $('#divWOResultDetails input[type=checkbox]').length + ")");
                                calculateWOSummary();
                            }
                            if ((refreshSection & 4) > 0) {
                                $("#divQuoteResultDetails").html(htmlResult[2]);
                                $("#queryTab li[value='3'] a").html("Quotes (" + $('#divQuoteResultDetails input[type=checkbox]').length + ")");
                                calculateQuoteSummary();
                            }
                        }

                        callBacking = false;
                    },
                    error: function () { callBacking = false; }
                });
            }

        }


        function ChangeQuerySection(tabValue) {
            $("#queryTab li").removeClass("ui-tabs-selected");
            $("#queryTab li").removeClass("ui-state-active");

            $("#queryTab li[value='" + tabValue + "']").addClass("ui-tabs-selected");
            $("#queryTab li[value='" + tabValue + "']").addClass("ui-state-active");

            $("#divSJResult").hide();
            $("#divWOResult").hide();
            $("#divQuoteResult").hide();

            if (tabValue == 1)
                $("#divSJResult").show();
            if (tabValue == 2)
                $("#divWOResult").show();
            if (tabValue == 3)
                $("#divQuoteResult").show();


        }


        function calculateWOSummary() {
            var totalLaborHours = 0;
            var totalPartsAmount = 0;
            var totalLaborAmount = 0;
            var totalMiscAmount = 0;
            var totalRecords = 0;
            var totalCalculatedRecords = 0;

            totalRecords = $('#divWOResultDetails input[type=checkbox]').length;

            $('#divWOResultDetails input[type=checkbox]:checked').each(function () {
                totalLaborHours += parseFloat($(this).attr("LaborHours"));
                totalPartsAmount += parseFloat($(this).attr("PartsAmount"));
                totalLaborAmount += parseFloat($(this).attr("LaborAmount"));
                totalMiscAmount += parseFloat($(this).attr("MiscAmount"));
                totalCalculatedRecords += 1;
            });

            $("#spanWOTotalRecords").html(totalRecords);
            $("#spanWOExcludedRecords").html(totalRecords - totalCalculatedRecords);
            $("#spanWOCalculatedRecords").html(totalCalculatedRecords);

            $("#spanWOAvgPartsAmount").html($.global.format(totalPartsAmount / totalCalculatedRecords, "c"));
            $("#spanWOAvgLaborAmount").html($.global.format(totalLaborAmount / totalCalculatedRecords, "c"));
            $("#spanWOAvgMiscAmount").html($.global.format(totalMiscAmount / totalCalculatedRecords, "c"));

            $("#spanWOAvgHours").html($.global.format(totalLaborHours / totalCalculatedRecords, "n2"));

            woAvgPartsAmount = Math.round(totalPartsAmount / totalCalculatedRecords * 100) / 100;
            woAvgLaborAmount = Math.round(totalLaborAmount / totalCalculatedRecords * 100) / 100;
            woAvgMiscAmount = Math.round(totalMiscAmount / totalCalculatedRecords * 100) / 100;
            woAvgHours = Math.round(totalLaborHours / totalCalculatedRecords * 100) / 100;
        }

        function calculateQuoteSummary() {
            var totalLaborHours = 0;
            var totalPartsAmount = 0;
            var totalLaborAmount = 0;
            var totalMiscAmount = 0;
            var totalRecords = 0;
            var totalCalculatedRecords = 0;

            totalRecords = $('#divQuoteResultDetails input[type=checkbox]').length;


            $('#divQuoteResultDetails input[type=checkbox]:checked').each(function () {
                totalLaborHours += parseFloat($(this).attr("LaborHours"));
                totalPartsAmount += parseFloat($(this).attr("PartsAmount"));
                totalLaborAmount += parseFloat($(this).attr("LaborAmount"));
                totalMiscAmount += parseFloat($(this).attr("MiscAmount"));
                totalCalculatedRecords += 1;
            });

            $("#spanQuoteTotalRecords").html(totalRecords);
            $("#spanQuoteExcludedRecords").html(totalRecords - totalCalculatedRecords);
            $("#spanQuoteCalculatedRecords").html(totalCalculatedRecords);

            $("#spanQuoteAvgPartsAmount").html($.global.format(totalPartsAmount / totalCalculatedRecords, "c"));
            $("#spanQuoteAvgLaborAmount").html($.global.format(totalLaborAmount / totalCalculatedRecords, "c"));
            $("#spanQuoteAvgMiscAmount").html($.global.format(totalMiscAmount / totalCalculatedRecords, "c"));

            $("#spanQuoteAvgHours").html($.global.format(totalLaborHours / totalCalculatedRecords, "n2"));

            quoteAvgPartsAmount = Math.round(totalPartsAmount / totalCalculatedRecords * 100)/100;
            quoteAvgLaborAmount = Math.round(totalLaborAmount / totalCalculatedRecords * 100) / 100;
            quoteAvgMiscAmount = Math.round(totalMiscAmount / totalCalculatedRecords * 100) / 100;
            quoteAvgHours = Math.round(totalLaborHours / totalCalculatedRecords * 100) / 100;

        }

        function sortResult(section, fieldName) {
            var currentField = "";
            var currentDirection = "";

            switch (section) {
                case "SJ":
                    currentField = $("#hidSJSortField").val();
                    currentDirection = $("#hidSJSortDirection").val();
                    if (fieldName != currentField) {
                        $("#hidSJSortField").val(fieldName);
                        $("#hidSJSortDirection").val("ASC");
                    }
                    else {
                        if (currentDirection == "ASC")
                            $("#hidSJSortDirection").val("DESC");
                        else
                            $("#hidSJSortDirection").val("ASC");
                    }
                    SearchAjaxHandler(1);

                    break;

                case "WO":
                    currentField = $("#hidWOSortField").val();
                    currentDirection = $("#hidWOSortDirection").val();
                    if (fieldName != currentField) {
                        $("#hidWOSortField").val(fieldName);
                        $("#hidWOSortDirection").val("ASC");
                    }
                    else {
                        if (currentDirection == "ASC")
                            $("#hidWOSortDirection").val("DESC");
                        else
                            $("#hidWOSortDirection").val("ASC");
                    }
                    SearchAjaxHandler(2);
                    break;

                case "Quote":
                    currentField = $("#hidQuoteSortField").val();
                    currentDirection = $("#hidQuoteSortDirection").val();
                    if (fieldName != currentField) {
                        $("#hidQuoteSortField").val(fieldName);
                        $("#hidQuoteSortDirection").val("ASC");
                    }
                    else {
                        if (currentDirection == "ASC")
                            $("#hidQuoteSortDirection").val("DESC");
                        else
                            $("#hidQuoteSortDirection").val("ASC");
                    }
                    SearchAjaxHandler(4);

                    break;
            }
        }

        function createSJSeg(DBSROId, DBSROPId) {
            document.location.href = "../Quote/Quote_addnew.aspx?DBSROId=" + DBSROId + "&DBSROPId=" + DBSROPId;
        }
        function createWOSeg(WONO, SegmentNo) {
            document.location.href = "../Quote/Quote_addnew.aspx?COPYFROM=WO&WONO=" + WONO + "&SegmentNo=" + SegmentNo;
        }
        function createQuoteSeg(QuoteNo, SegmentNo) {
            document.location.href = "../Quote/Quote_addnew.aspx?COPYFROM=Quote&QuoteNo=" + QuoteNo + "&SegmentNo=" + SegmentNo;
        }

        function calendarShown(sender, args) { sender._popupBehavior._element.style.zIndex = 10005; }

        function limitRecords( limitType) {
            if (limitType == 'NUMBER') {
                $("#txtLimitRecords").removeAttr('disabled');
                $("#txtFromDate").attr('disabled', 'disabled');
                $("#txtToDate").attr('disabled', 'disabled');
                $("#imgCalendarFromDate").attr('disabled', 'disabled');
                $("#imgCalendarToDate").attr('disabled', 'disabled');
                
            }
            else {
                $("#txtLimitRecords").attr('disabled', 'disabled');
                $("#txtFromDate").removeAttr('disabled');
                $("#txtToDate").removeAttr('disabled');
                $("#imgCalendarFromDate").removeAttr('disabled');
                $("#imgCalendarToDate").removeAttr('disabled');

            }
        }

        function setIncludeZero() {
            var includeZero = $('#chkIncludeZero').is(':checked');
            if (includeZero) {
                $('#divWOResultDetails input[type=checkbox][TotalAmount=0]').attr('checked', true);
                $('#divQuoteResultDetails input[type=checkbox][TotalAmount=0]').attr('checked', true); 
            }
            else {
                $('#divWOResultDetails input[type=checkbox][TotalAmount=0]').attr('checked', false);
                $('#divQuoteResultDetails input[type=checkbox][TotalAmount=0]').attr('checked', false);
            }

            calculateWOSummary();
            calculateQuoteSummary();
        }

        function createQuoteFromAvg(dataSource) {
            if (dataSource == "WO") {
                var url = "../Quote/Quote_addnew.aspx?COPYFROM=WOAVG";
                url += "&partsAmount=" + woAvgPartsAmount;
                url += "&LaborAmount=" + woAvgLaborAmount;
                url += "&MiscAmount=" + woAvgMiscAmount;
                url += "&LaborHours=" + woAvgHours;
            }
            else {
                var url = "../Quote/Quote_addnew.aspx?COPYFROM=QuoteAVG";
                url += "&partsAmount=" + quoteAvgPartsAmount;
                url += "&LaborAmount=" + quoteAvgLaborAmount;
                url += "&MiscAmount=" + quoteAvgMiscAmount;
                url += "&LaborHours=" + quoteAvgHours;
            }
            url += "&make=" + $("#lstMake").val();
            url += "&serialNo=" + $("#txtSerialNo").val();
            url += "&model=" + $("#txtModel").val();
            url += "&jobCode=" + $("#hidJobCode").val();
            url += "&componentCode=" + $("#hidComponentCode").val();
            url += "&modifierCode=" + $("#hidModifierCode").val();
            url += "&businessGroupCode=" + $("#lstBusinessGroupCode").val();
            url += "&quantityCode=" + $("#lstQuantityCode").val();
            if ($("#lstWorkApplicationCode").length > 0)
                url += "&workApplicationCode=" + $("#lstWorkApplicationCode").val();
            url += "&branchCode=" + $("#lstStoreCode").val();

            url += "&costCentreCode=" + $("#lstCostCenterCode").val();

            if ($("#lstCabTypeCode").length > 0)
                url += "&cabTypecde=" + $("#lstCabTypeCode").val();
            url += "&shopField=" + $("#lstShopFieldCode").val();
            if ($("#lstJobLocationCode").length > 0)
                url += "&jobLocationCode=" + $("#lstJobLocationCode").val();

            document.location.href = url;
        }



        $(function () {
        limitRecords('NUMBER');

        });



    </script>
</asp:Content>
