<%@ Control Language="C#" AutoEventWireup="true" CodeFile="printConfig.ascx.cs" Inherits="Modules_Quote_Controls_PrintConfig" %>
<table width="100%">
    <tr>
        <td colspan="8" class="tAr">
            <asp:Button ID="btnDealershipConfig" runat="server" OnClientClick="return btnDealershipConfig_onclick();"
                Text="Dealership Configuration" OnClick="btnDealershipConfig_Click" />

                <asp:Button ID="btnUserConfig" runat="server" OnClientClick="return btnUserConfig_onclick();"
                Text="User Configuration" OnClick="btnUserConfig_Click" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnSave" runat="server" OnClientClick="return btnSave_onclick();"
                Text="Save" OnClick="btnSave_Click" />
            <asp:Button ID="btnBack" runat="server" Text="Back" OnClick="btnBack_Click" />
        </td>
    </tr>
    <tr>
        <!--CODE_TAG_105435-->
        <td colspan="4" style="border-left: 1px solid yellow; vertical-align: top">
            <div class="tSb">
                Internal Document Settings
            </div>
            <div id="divInternalSegment" runat="server">
                &nbsp;&nbsp;
                <div>
                    <asp:RadioButton ID="rdoInternalSegmentHide" GroupName="rdoInternalSegment" onclick="toggleInternalSegment();"
                        ClientIDMode="Static" runat="server" Text="Show Basic Segment Details" />
                         &nbsp;&nbsp; &nbsp;&nbsp;
                    <asp:RadioButton ID="rdoInternalSegmentShow" GroupName="rdoInternalSegment" onclick="toggleInternalSegment();"
                        ClientIDMode="Static" runat="server" Text="Show Extended Segment Details" />
                </div>
            </div>
            <div>
                &nbsp;</div>
            <ul id="ulInternalSegment" class="ulDetailColumns">
                <asp:Repeater ID="repInternalSegment" runat="server" OnItemDataBound="repSegment_ItemDataBound">
                    <ItemTemplate>
                        <li id='liInternalSegment<asp:Literal ID="litLiId" runat="server" ></asp:Literal>'  groupType='<asp:Literal ID="litGroupType" runat="server" ></asp:Literal>' >
                            <asp:CheckBox ID="chkDisplay" runat="server" />
                            <asp:Label ID="lblDisplayName" runat="server"></asp:Label>
                            <asp:HiddenField ID="hidColumnId" runat="server" />
                            <asp:HiddenField ID="hidColumnName" runat="server" />
                        </li>
                    </ItemTemplate>
                </asp:Repeater>
            </ul>
        </td>
        <!--/CODE_TAG_105435-->
        <!--CODE_TAG_105435-->
        <td colspan="4" style="vertical-align: top">
            <div class="tSb">
                Customer Document Settings
            </div>
            <div id="divCustomerSegment" runat="server">
                &nbsp;&nbsp;
                <div>
                    <asp:RadioButton ID="rdoCustomerSegmentHide" GroupName="rdoCustomerSegment" onclick="toggleCustomerSegment();"
                        ClientIDMode="Static" runat="server" Text="Show Basic Segment Details" />
                         &nbsp;&nbsp; &nbsp;&nbsp;
                    <asp:RadioButton ID="rdoCustomerSegmentShow" GroupName="rdoCustomerSegment" onclick="toggleCustomerSegment();"
                        ClientIDMode="Static" runat="server" Text="Show Extended Segment Details" />
                </div>
            </div>
            <div>
                &nbsp;</div>
            <ul id="ulCustomerSegment" class="ulDetailColumns">
                <asp:Repeater ID="repCustomerSegment" runat="server" OnItemDataBound="repSegment_ItemDataBound">
                    <ItemTemplate>
                        <li id='liCustomerSegment<asp:Literal ID="litLiId" runat="server" ></asp:Literal>' groupType='<asp:Literal ID="litGroupType" runat="server" ></asp:Literal>'   >
                            <asp:CheckBox ID="chkDisplay" runat="server" />
                            <asp:Label ID="lblDisplayName" runat="server"></asp:Label>
                            <asp:HiddenField ID="hidColumnId" runat="server" />
                            <asp:HiddenField ID="hidColumnName" runat="server" />
                        </li>
                    </ItemTemplate>
                </asp:Repeater>
            </ul>
        </td>
        <!--/CODE_TAG_105435-->
    </tr>
    <tr>

        <!--CODE_TAG_105435--><!--Internal begins-->
        <td class="tVt" style="border-left: 1px solid yellow; width: 15%">
            <fieldset id="secInternalPart">
                <legend>Parts </legend>
                <ul id="ulInternalParts" class="ulDetailColumns">
                    <asp:Repeater ID="repInternalParts" runat="server" OnItemDataBound="repDetail_ItemDataBound">
                        <ItemTemplate>
                            <li id='liInternalPart<asp:Literal ID="litLiId" runat="server" ></asp:Literal>'>
                                <%-- <span class="flag ui-icon ui-icon-arrowthick-2-n-s"></span>--%>
                                <asp:CheckBox ID="chkDisplay" runat="server" />
                                <asp:Label ID="lblDisplayName" runat="server"></asp:Label>
                                <asp:HiddenField ID="hidColumnId" runat="server" />
                                <asp:HiddenField ID="hidColumnName" runat="server" />
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
            </fieldset>
        </td>
        <td class="tVt" style="width: 15%">
            <fieldset id="secInternalLabor">
                <legend>Labor </legend>
                <ul id="ulInternalLabor" class="ulDetailColumns">
                    <asp:Repeater ID="repInternalLabor" runat="server" OnItemDataBound="repDetail_ItemDataBound">
                        <ItemTemplate>
                            <li id='liInternalLabor<asp:Literal ID="litLiId" runat="server" ></asp:Literal>'>
                                <%--<span class="flag ui-icon ui-icon-arrowthick-2-n-s"></span>--%>
                                <asp:CheckBox ID="chkDisplay" runat="server" />
                                <asp:Label ID="lblDisplayName" runat="server"></asp:Label>
                                <asp:HiddenField ID="hidColumnId" runat="server" />
                                <asp:HiddenField ID="hidColumnName" runat="server" />
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
            </fieldset>
        </td>
        <td class="tVt" style="width: 15%">
            <fieldset id="secInternalMisc">
                <legend>Misc </legend>
                <ul id="ulInternalMisc" class="ulDetailColumns">
                    <asp:Repeater ID="repInternalMisc" runat="server" OnItemDataBound="repDetail_ItemDataBound">
                        <ItemTemplate>
                            <li id='liInternalMisc<asp:Literal ID="litLiId" runat="server" ></asp:Literal>'>
                                <%-- <span class="flag ui-icon ui-icon-arrowthick-2-n-s"></span>--%>
                                <asp:CheckBox ID="chkDisplay" runat="server" />
                                <asp:Label ID="lblDisplayName" runat="server"></asp:Label>
                                <asp:HiddenField ID="hidColumnId" runat="server" />
                                <asp:HiddenField ID="hidColumnName" runat="server" />
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
            </fieldset>
        </td>
        <!--/CODE_TAG_105435--><!--Internal ends-->
        <td class="tVt" style="width: 5%">
        </td>
        <!--CODE_TAG_105435--><!--Curstomer begins-->
        <td class="tVt" style="width: 15%">
            <fieldset id="secCustomerPart">
                <legend>Parts </legend>
                <ul id="ulCustomerParts" class="ulDetailColumns">
                    <asp:Repeater ID="repCustomerParts" runat="server" OnItemDataBound="repDetail_ItemDataBound">
                        <ItemTemplate>
                            <li id='liCustomerPart<asp:Literal ID="litLiId" runat="server" ></asp:Literal>'>
                                <%--<span class="flag ui-icon ui-icon-arrowthick-2-n-s"></span>--%>
                                <asp:CheckBox ID="chkDisplay" runat="server" />
                                <asp:Label ID="lblDisplayName" runat="server"></asp:Label>
                                <asp:HiddenField ID="hidColumnId" runat="server" />
                                <asp:HiddenField ID="hidColumnName" runat="server" />
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
            </fieldset>
        </td>
        <td class="tVt" style="width: 15%">
            <fieldset id="secCustomerLabor">
                <legend>Labor </legend>
                <ul id="ulCustomerLabor" class="ulDetailColumns">
                    <asp:Repeater ID="repCustomerLabor" runat="server" OnItemDataBound="repDetail_ItemDataBound">
                        <ItemTemplate>
                            <li id='liCustomerLabor<asp:Literal ID="litLiId" runat="server" ></asp:Literal>'>
                                <%--<span class="flag ui-icon ui-icon-arrowthick-2-n-s"></span>--%>
                                <asp:CheckBox ID="chkDisplay" runat="server" />
                                <asp:Label ID="lblDisplayName" runat="server"></asp:Label>
                                <asp:HiddenField ID="hidColumnId" runat="server" />
                                <asp:HiddenField ID="hidColumnName" runat="server" />
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
            </fieldset>
        </td>
        <td class="tVt" style="width: 15%">
            <fieldset id="secCustomerMisc">
                <legend>Misc </legend>
                <ul id="ulCustomerMisc" class="ulDetailColumns">
                    <asp:Repeater ID="repCustomerMisc" runat="server" OnItemDataBound="repDetail_ItemDataBound">
                        <ItemTemplate>
                            <li id='liCustomerMisc<asp:Literal ID="litLiId" runat="server" ></asp:Literal>'>
                                <%--<span class="flag ui-icon ui-icon-arrowthick-2-n-s"></span>--%>
                                <asp:CheckBox ID="chkDisplay" runat="server" />
                                <asp:Label ID="lblDisplayName" runat="server"></asp:Label>
                                <asp:HiddenField ID="hidColumnId" runat="server" />
                                <asp:HiddenField ID="hidColumnName" runat="server" />
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
            </fieldset>
        </td>
        <!--/CODE_TAG_105435--><!--Curstomer ends-->
        <td class="tVt" style="width: 5%">
        </td>
    </tr>
</table>
<asp:HiddenField ID="hidRtValue" ClientIDMode="Static" runat="server" Value="" />
<script type="text/javascript">
    $(function () {
        //        $("#ulCustomerParts").sortable();
        //        $("#ulCustomerParts").disableSelection();

        //        $("#ulCustomerLabor").sortable();
        //        $("#ulCustomerLabor").disableSelection();

        //        $("#ulCustomerMisc").sortable();
        //        $("#ulCustomerMisc").disableSelection();


        //        $("#ulInternalParts").sortable();
        //        $("#ulInternalParts").disableSelection();

        //        $("#ulInternalLabor").sortable();
        //        $("#ulInternalLabor").disableSelection();

        //        $("#ulInternalMisc").sortable();
        //        $("#ulInternalMisc").disableSelection();


    });

    function btnSave_onclick() {

        var strXML = "<Root>";
        var liId = "";
        var columnId = "";
        var columnName = "";
        var sortValue = 10;
        var configValue = "1";
        var Lis;
        var arrLis;

        //customer segment
        strXML += "<CustomerSegment>";
        $('#ulCustomerSegment > li').each(function (index) {
            liId = $(this)[0].id;
            columnId = $("#" + liId + "> [id*=hidColumnId]").val();
            columnName = $("#" + liId + "> [id*=hidColumnName]").val();
            if ($("#" + liId + "> [id*=chkDisplay]").attr("checked"))
                configValue = 2;
            else
                configValue = 1;
            strXML += "<Item><Id>" + columnId + "</Id><Name>" + columnName + "</Name><Value>" + configValue + "</Value></Item>";

        });
        strXML += "</CustomerSegment>";


        //Customer Detail
        strXML += "<CustomerDetails>";
        //parts
        sortValue = 10;
        //Lis = $('#ulCustomerParts').sortable('toArray').toString();
        //arrLis = Lis.split(',');
        //$.each(arrLis, function (index, value) {
        $('#ulCustomerParts > li').each(function (index) {
            liId = $(this)[0].id;
            columnId = $("#" + liId + "> [id*=hidColumnId]").val();
            columnName = $("#" + liId + "> [id*=hidColumnName]").val();
            if ($("#" + liId + "> [id*=chkDisplay]").attr("checked"))
                configValue = 2;
            else
                configValue = 1;

            strXML += "<Item><Id>" + columnId + "</Id><Name>" + columnName + "</Name><Value>" + configValue + "</Value><Sort>" + sortValue + "</Sort></Item>";
            sortValue += 10;
        });

        //Labor
        sortValue = 10;
        //Lis = $('#ulCustomerLabor').sortable('toArray').toString();
        //arrLis = Lis.split(',');
        //$.each(arrLis, function (index, value) {
        $('#ulCustomerLabor > li').each(function (index) {
            liId = $(this)[0].id;
            columnId = $("#" + liId + "> [id*=hidColumnId]").val();
            columnName = $("#" + liId + "> [id*=hidColumnName]").val();
            if ($("#" + liId + "> [id*=chkDisplay]").attr("checked"))
                configValue = 2;
            else
                configValue = 1;
            strXML += "<Item><Id>" + columnId + "</Id><Name>" + columnName + "</Name><Value>" + configValue + "</Value><Sort>" + sortValue + "</Sort></Item>";
            sortValue += 10;
        });
        //Misc
        sortValue = 10;
        //Lis = $('#ulCustomerMisc').sortable('toArray').toString();
        //arrLis = Lis.split(',');
        //$.each(arrLis, function (index, value) {
        $('#ulCustomerMisc > li').each(function (index) {
            liId = $(this)[0].id;
            columnId = $("#" + liId + "> [id*=hidColumnId]").val();
            columnName = $("#" + liId + "> [id*=hidColumnName]").val();
            if ($("#" + liId + "> [id*=chkDisplay]").attr("checked"))
                configValue = 2;
            else
                configValue = 1;
            strXML += "<Item><Id>" + columnId + "</Id><Name>" + columnName + "</Name><Value>" + configValue + "</Value><Sort>" + sortValue + "</Sort></Item>";
            sortValue += 10;
        });
        strXML += "</CustomerDetails>";

        //Internal segment
        strXML += "<InternalSegment>";
        $('#ulInternalSegment > li').each(function (index) {
            liId = $(this)[0].id;
            columnId = $("#" + liId + "> [id*=hidColumnId]").val();
            columnName = $("#" + liId + "> [id*=hidColumnName]").val();
            if ($("#" + liId + "> [id*=chkDisplay]").attr("checked"))
                configValue = 2;
            else
                configValue = 1;
            strXML += "<Item><Id>" + columnId + "</Id><Name>" + columnName + "</Name><Value>" + configValue + "</Value></Item>";

        });
        strXML += "</InternalSegment>";

        //Internal Detail
        strXML += "<InternalDetails>";
        //parts
        sortValue = 10;
        //Lis = $('#ulInternalParts').sortable('toArray').toString();
        //arrLis = Lis.split(',');
        //$.each(arrLis, function (index, value) {
        $('#ulInternalParts > li').each(function (index) {
            liId = $(this)[0].id;
            columnId = $("#" + liId + "> [id*=hidColumnId]").val();
            columnName = $("#" + liId + "> [id*=hidColumnName]").val();
            if ($("#" + liId + "> [id*=chkDisplay]").attr("checked"))
                configValue = 2;
            else
                configValue = 1;
            strXML += "<Item><Id>" + columnId + "</Id><Name>" + columnName + "</Name><Value>" + configValue + "</Value><Sort>" + sortValue + "</Sort></Item>";
            sortValue += 10;
        });
        //Labor
        sortValue = 10;
        //Lis = $('#ulInternalLabor').sortable('toArray').toString();
        //arrLis = Lis.split(',');
        //$.each(arrLis, function (index, value) {
        $('#ulInternalLabor > li').each(function (index) {
            liId = $(this)[0].id;
            columnId = $("#" + liId + "> [id*=hidColumnId]").val();
            columnName = $("#" + liId + "> [id*=hidColumnName]").val();
            if ($("#" + liId + "> [id*=chkDisplay]").attr("checked"))
                configValue = 2;
            else
                configValue = 1;
            strXML += "<Item><Id>" + columnId + "</Id><Name>" + columnName + "</Name><Value>" + configValue + "</Value><Sort>" + sortValue + "</Sort></Item>";
            sortValue += 10;
        });
        //Misc
        sortValue = 10;
        // Lis = $('#ulInternalMisc').sortable('toArray').toString();
        // arrLis = Lis.split(',');
        // $.each(arrLis, function (index, value) {
        $('#ulInternalMisc > li').each(function (index) {
            liId = $(this)[0].id;
            columnId = $("#" + liId + "> [id*=hidColumnId]").val();
            columnName = $("#" + liId + "> [id*=hidColumnName]").val();
            if ($("#" + liId + "> [id*=chkDisplay]").attr("checked"))
                configValue = 2;
            else
                configValue = 1;
            strXML += "<Item><Id>" + columnId + "</Id><Name>" + columnName + "</Name><Value>" + configValue + "</Value><Sort>" + sortValue + "</Sort></Item>";
            sortValue += 10;
        });
        strXML += "</InternalDetails>";
        strXML += "</Root>";

        $("#hidRtValue").val(strXML);

        return true;
    }

    function toggleCustomerSegment() {
        if ($("#rdoCustomerSegmentHide").attr("checked")) {
            $("#ulCustomerSegment [grouptype=1]").show();
            $("#ulCustomerSegment [grouptype=2]").hide();

            $("#secCustomerPart").hide();
            $("#secCustomerLabor").hide();
            $("#secCustomerMisc").hide();
        }
        else {
            $("#ulCustomerSegment [grouptype=1]").hide();
            $("#ulCustomerSegment [grouptype=2]").show();
            $("#secCustomerPart").show();
            $("#secCustomerLabor").show();
            $("#secCustomerMisc").show();

        }
    }


    function toggleInternalSegment() {
        if ($("#rdoInternalSegmentHide").attr("checked")) {
            $("#ulInternalSegment [grouptype=1]").show();
            $("#ulInternalSegment [grouptype=2]").hide();
            $("#secInternalPart").hide();
            $("#secInternalLabor").hide();
            $("#secInternalMisc").hide();
        }
        else {
            $("#ulInternalSegment [grouptype=1]").hide();
            $("#ulInternalSegment [grouptype=2]").show();
            $("#secInternalPart").show();
            $("#secInternalLabor").show();
            $("#secInternalMisc").show();

        }
    }


    $(function () {
        toggleCustomerSegment();
        toggleInternalSegment();
    });


    function btnDealershipConfig_onclick() {
        if (confirm("Are you sure to reset this quote print configuration to dealership configuration?"))
            return true;
        else
            return false;
    }
    function btnUserConfig_onclick() {
        if (confirm("Are you sure to reset this quote print configuration to user configuration?"))
            return true;
        else
            return false;
    }
</script>
