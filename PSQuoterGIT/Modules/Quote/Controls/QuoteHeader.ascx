<%@ Control Language="C#" AutoEventWireup="true" CodeFile="QuoteHeader.ascx.cs" Inherits="Modules_Quote_Controls_QuoteHeader" %>
<div class="quoteHeader">
    <table cellspacing="0px">
        <tr>
            <th>
                Quote No:
            </th>
            <td>
                <asp:Label ID="lblQuoteNo" runat="server" Text=""></asp:Label>
            </td>
            <th>
                Quote Status:
            </th>
            <td>
                <asp:Label ID="lblStatus" runat="server" Text=""></asp:Label>
            </td>
            <th>
                Quote Type:
            </th>
            <td>
                <asp:Label ID="lblQuoteType" runat="server" Text=""></asp:Label>
            </td>
             <%if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.SalesRep.Show"))
               {%>
            <th>
                Owner:
            </th>
            <td>
                <asp:Label ID="lblSalesrep" runat="server" Text=""></asp:Label>
            </td>
           <%}
            else { %>
            <th></th><td></td>
            <%} %>
            <th>
                Branch:
            </th>
            <td>
                <asp:Label ID="lblBranch" runat="server" Text=""></asp:Label>
            </td>
           <th>
                Originator:
           </th>
           <td>
                <asp:Label ID="lblCreator" runat="server" Text=""></asp:Label>
           </td>   
            <td class="tAr" rowspan="2">
                <%
                    if (CanModify)
                        menu.Render(MenuRenderType.Context);
                    else
                    {
                %>
                <a href="javascript:copyToNewQuote(); ">Copy To New Quote </a>
                <%   
                   }    
                %>
            </td>
        </tr>
        <tr>
        <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.Description.Show"))
           { %>
        
            <th>
                Description:
            </th>
            <td colspan="5">
                <asp:Label ID="lblDescription" runat="server" Text=""></asp:Label>
            </td>
        
        <%
          }
        %>
         <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.EstimatedByName.Show"))
               {  %>
            <th>
                Estimated By:
            </th>
            <td>
                <asp:Label ID="lblEstimatedByName" runat="server"></asp:Label>
            </td>
            <% } %>

            <%--<CODE_TAG_105235> lwang--%>
            <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.StageType.Show"))
                { %>
            <th>
                Type:
            </th>
            <td >
                <asp:Label ID="lblQuoteStageType" runat="server"></asp:Label>
            </td>
            <%} %>
            <%--</CODE_TAG_105235> lwang--%>
        </tr>
        <tr>
            <th>
                Customer:
            </th>
            <td colspan="3">
                <asp:Label ID="lblCustomer" runat="server" Text=""></asp:Label>
				<asp:Label ID="lblCustomerLoyaltyIndicator" runat="server"  ClientIDMode="static" Visible="true"  ForeColor="White" style="padding:3px"></asp:Label><!--CODE_TAG_104784-->
            </td>
            <th>
                Division:
            </th>
            <td>
                <asp:Label ID="lblDivision" runat="server" Text=""></asp:Label>
            </td>
            <th>
                Contact:
            </th>
            <td>
                <asp:Label ID="lblContact" runat="server" Text=""></asp:Label>
                <asp:ImageButton ID="imgbtnMailTo" ImageUrl="~/Library/images/email.png" runat="server"
                    Visible="false" />
            </td>
            <th>
                Phone No:
            </th>
            <td>
                <asp:Label ID="lblPhoneNo" runat="server" Text=""></asp:Label>
            </td>
            <th>
                PO No:
            </th>
            <td>
                <asp:Label ID="lblPONo" runat="server" Text="ii"></asp:Label>
            </td>
            <td>
            </td>
            <th>
            </th>
            <td>
            </td>
            <td>
            </td>
        </tr>
        <tr>
            <th>
                Make:
            </th>
            <td>
                <asp:Label ID="lblMake" runat="server" Text=""></asp:Label>
            </td>
            <th>
                Serial No:
            </th>
            <td>
                <asp:Label ID="lblSerialNo" runat="server" Text=""></asp:Label>
            </td>
            <th>
                Model:
            </th>
            <td>
                <asp:Label ID="lblModel" runat="server" Text=""></asp:Label>
            </td>
            <th>
                Unit No:
            </th>
            <td>
                <asp:Label ID="lblUnitNo" runat="server" Text=""></asp:Label>
            </td>
            <th>
                SMU:
            </th>
            <td>
                <asp:Label ID="lblSMU" runat="server" Text=""></asp:Label>
            </td>
        <!--CODE_TAG_104881-->
        <%if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.CabType.Show"))
         { %>
            <th>
                Cab Type:
            </th>
            <td>
                <asp:Label ID="lblCab" runat="server" Text=""></asp:Label>
            </td>
        <%} %>
        <!--/CODE_TAG_104881-->
        </tr>
        <tr>
            <th style="width: 6%">
                Opp. No:
            </th>
            <td style="width: 8%">
                <asp:Label ID="lblOppNo" runat="server" Text=""></asp:Label>
            </td>
            <th style="width: 6%">
                Est. Delivery:
            </th>
            <td style="width: 8%">
                <asp:Label ID="lblEsDelivery" runat="server" Text=""></asp:Label>
            </td>
            <th style="width: 6%">
                Probablity:
            </th>
            <td style="width: 8%">
                <asp:Label ID="lblProbabilityOfClosing" runat="server" Text=""></asp:Label>
            </td>
            <th style="width: 6%">
                Opp. Type:
            </th>
            <td style="width: 8%">
                <asp:Label ID="lblQuoeType" runat="server" Text=""></asp:Label>
            </td>
            <th style="width: 6%">
                Commodity:
            </th>
            <td style="width: 8%">
                <asp:Label ID="lblCommodity" runat="server" Text=""></asp:Label>
            </td>
            <th style="width: 6%">
                Source:
            </th>
            <td style="width: 8%">
                <asp:Label ID="lblSource" runat="server" Text=""></asp:Label>
            </td>
            <td style="width: 16%">
            </td>
        </tr>
        <tr>
            <th style="width: 6%">
                Promise Date:
            </th>
            <td style="width: 8%">
                <asp:Label ID="lblPromiseDate" runat="server" Text=""></asp:Label>
            </td>
            <th style="width: 6%">
                Unit to Arrive Date:
            </th>
            <td style="width: 8%">
                <asp:Label ID="lblUnittoArriveDate" runat="server" Text=""></asp:Label>
            </td>
            <th style="width: 6%">
                Planned Indicator:
            </th>
            <td style="width: 8%">
                <asp:Label ID="lblPlannedIndicator" runat="server" Text=""></asp:Label>
            </td>
            <th style="width: 6%">
                Urgency Indicator:
            </th>
            <td style="width: 8%">
                <asp:Label ID="lblUrgencyIndicator" runat="server" Text=""></asp:Label>
            </td>
            <th style="width: 6%">
                Job Control Code:
            </th>
            <td style="width: 8%">
                <asp:Label ID="lblJobControlCode" runat="server" Text=""></asp:Label>
            </td>
            <th style="width: 6%">
                Estimated Repair Time:
            </th>
            <td style="width: 8%">
                <asp:Label ID="lblEstimatedRepairTime" runat="server" Text=""></asp:Label>
            </td>
            <td style="width: 16%">
            </td>
        </tr>
        <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.Comment.Show")) { %>
        <tr>
            <th style="width: 8%; vertical-align:top">
                Comments:
            </th>
            <td colspan="12">
                <asp:Label ID="lblComments" runat="server" Text=""></asp:Label>
            </td>
        </tr>
        <% } %>
    </table>
</div>
<asp:Button ID="btnPostBack" ClientIDMode="Static" runat="server" Text="PostBack"
    OnClick="btnPostback_Click" Style="display: none" />
<asp:HiddenField ID="hdnPostbackOperation" ClientIDMode="static" Value="" runat="server" />
<asp:HiddenField ID="hdnCustomerNo" ClientIDMode="static" Value="" runat="server" />
<asp:HiddenField ID="hdnBranchNo" ClientIDMode="Static" Value="" runat="server" />
<asp:HiddenField ID="hdnDivision" ClientIDMode="Static" Value="" runat="server" />
<asp:HiddenField ID="hdnModel" runat="server" Value="" ClientIDMode="static" />
<asp:HiddenField ID="hdnEmail" runat="server" Value="" ClientIDMode="static" /> <%--TICKET 23348--%>
<asp:HiddenField ID="hdnFax" runat="server" Value="" ClientIDMode="static" /> <%--<CODE_TAG_103401>--%>
<asp:HiddenField ID="hdnSegmentEditLockedByRevisionUpdate" runat="server" Value="" ClientIDMode="static" /> <%--<CODE_TAG_106869>--%>
<div>
    <asp:Literal ID="litRevision" runat="server"></asp:Literal>
</div>
<div>
    <table class="w100p" cellpadding="0" cellspacing="0">
        <tr>
            <td style="width: 50%">
                <asp:Literal ID="litGroupTabs" runat="server"></asp:Literal>
            </td>
			<td style="vertical-align: bottom; padding-bottom: 5px;">
				<div style="border-bottom: 1px solid #999; width: 100%;font-weight: bolder; ">
					<% if (SVLTicketId > 0){%>
						Ticket: <a href="javascript:openTicket(<%= SVLTicketId %>)"><%= SVLTicketId %></a> &nbsp;(&nbsp;<%= SVLTicketStatus %>)
					<%} %>
				</div>
			</td>
            <td class="tAr" style="vertical-align: bottom; padding-bottom: 5px;">
                <div style="border-bottom: 1px solid #999; width: 100%;"><!--Ticket 25447-->
                    <span id="divPrint" runat="server">
                        <!--CODE_TAG_105435--><!--Internal Icons Begin-->
                        <span id="divInternalPDF" runat="server">Internal
                        <a href="javascript:print('Pdf','<%= CustomerNo %>' ,1)"><img src="../../Library/images/icon_doctype_pdf.gif" title="Internal PDF Document" /></a> 
                        <!--CODE_TAG_104248--><!--control to hide the interanl word document output-->
                        <% if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Print.Document.Format.Word.Hide.Internal")) {%>
                        <a href="javascript:print('Word','<%= CustomerNo %>' ,1)"><img src="../../Library/images/icon_doctype_word.gif"  title="Internal Word Document" /></a> 
                             <% } %>

                        <!--/CODE_TAG_104248-->
                        <!--CODE_TAG_104470--><!--control to hide the interanl EXCEL document output-->
                        <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Print.Document.Format.Excel.Show.Internal"))
                           {%>
                        <a href="javascript:print('Excel','<%= CustomerNo %>' ,1)"><img src="../../Library/images/icon_doctype_excel.gif"  title="Internal Excel Document" /></a> 
                             <% } %>
                        <!--/CODE_TAG_104470-->
                        <a href="javascript:print('Email','<%= CustomerNo %>' ,1)"><img src="../../Library/images/email.png" title="Internal Email" /></a>
                    </span>
                    <!--Internal Icons End--><!--CODE_TAG_105435-->
                        &nbsp;&nbsp;&nbsp;
                    <!--CODE_TAG_105435--><!--Customer Icons Begin-->
                        Customer<a href="javascript:print('Pdf','<%= CustomerNo %>' , 0)">
                    <img src="../../Library/images/icon_doctype_pdf.gif" title="External PDF Document" /></a>
                    <!--CODE_TAG_104248--><!--control to hide the customer word document output-->
                    <% if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Print.Document.Format.Word.Hide.Customer")) {%>
                    <a href="javascript:print('Word','<%= CustomerNo %>' , 0)"><img src="../../Library/images/icon_doctype_word.gif"  title="External Word Document"/></a>
                     <% } %>
                    <!--/CODE_TAG_104248-->
                    <!--CODE_TAG_104470--><!--control to hide the interanl EXCEL document output-->
                    <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Print.Document.Format.Excel.Show.Customer"))
                       {%>
                    <a href="javascript:print('Excel','<%= CustomerNo %>' ,0)"><img src="../../Library/images/icon_doctype_excel.gif"  title="External Excel Document" /></a>
                    <% } %>
                    <!--/CODE_TAG_104470-->                         
                    <a href="javascript:print('Email','<%= CustomerNo %>' ,0)"><img src="../../Library/images/email.png" title="External Email"/></a>
                    <!--Customer Icons End--><!--CODE_TAG_105435-->
                    </span>&nbsp;&nbsp;&nbsp;<!--/Ticket 25447-->
                </div>
            </td>
        </tr>
    </table>
</div>
<div id="divQuoteHeaderEdit" style="display: none">
    <iframe id="iFrameHeaderEdit" name="iFrameHeaderEdit" src="" width="100%" height="100%"
        frameborder="0"></iframe>
</div>
<div id="divQuoteDeletion" style="display: none;">
    <iframe id="iFrameQuoteDeletion" src="" width="100%" height="100%" frameborder="0">
    </iframe>
</div>
<div id="divQuoteStatusChange" style="display: none;">
    <iframe id="iFrameQuoteStatusChange" src="" width="100%" height="100%" frameborder="0">
    </iframe>
</div>
<div id="divCustomerSearch">
    <iframe id="iFrameCustomerSearch" src="" width="100%" height="100%" frameborder="0">
    </iframe>
</div>
<div id="divEmailPDF">
    <iframe id="iFrameEmailPDF" src="" width="100%" height="100%" frameborder="0"></iframe>
</div>
<div id="divLinkWOSegmentSearch">
    <iframe id="iFrameLinkWOSegmentSearch" src="" width="100%" height="100%" frameborder="0">
    </iframe>
</div>
<div id="divPopWaiting">
    <div  style='position: absolute;top:10%;left:35%;'>Please Wait</div>
    <span style='position: absolute;top:40%;left:40%;'><img id="divPopWaiting_Img" src='' /></span> 
</div>
<%--<CODE_TAG_103401> start--%>
<div id="divFax">
    <iframe id="iFrameFax" src="" width="100%" height="100%" frameborder="0"></iframe>
</div>
<%--<CODE_TAG_103401> end--%>
<div id="divPrintDetail">
    <table width="100%">
        <tr>
            <td>
                Segment Details: &nbsp;&nbsp;&nbsp;&nbsp;
            </td>
            <td>
                <input type="radio" id="rdoPrintDetailShow" name="PrintDetail" checked="checked" />
                Show &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="radio" id="rdoPrintDetailHide" name="PrintDetail" />
                Hide
            </td>
        </tr>
        <tr>
            <td style="height: 100px">
            </td>
        </tr>
        <tr>
            <td colspan="2" class="tAr">
                <input type="button" value="Ok" onclick=" divPrintDetailOK_onclick();" />
                <input type="button" value="Cancel" onclick="$j('#divPrintDetail').dialog('close');" />
            </td>
        </tr>
    </table>
</div>
<script type="text/javascript">
    var errorMessage = "<%= ErrorMessage.JavaScriptStringEncode() %>";
    var DBSCustomer = "<%= DBSCustomer %>";
    var SegmentHasProspectCust = "<%= SegmentHasProspectCust %>";
	var SegmentHasBlankJobCode = "<%= SegmentHasBlankJobCode %>";
	var SegmentHasBlankComponentCode = "<%= SegmentHasBlankComponentCode %>";
    var CustomerCount = "<%= CustomerCount %>";
    var RevisionCount = <%= RevisionCount %>;
    var SMUCheck = "<%= SMUCheck.ToString() %>";
    var CostCentreCheck = "<%= CostCentreCheck.ToString() %>";
    var serviceLinkTicket = '<%=AppContext.Current.AppSettings["psQuoter.Quote.WO.ServiceLink"]%>'; //V.W. Added July 2, 2015
    //<CODE_TAG_105100>
    var chargeCodeDisplay = '<%=AppContext.Current.AppSettings["psQuoter.Quote.ChargeCodeDisplay"]%>';  //0: display ChargeCode-CustomerClassCode-StoreNo-CostCenterCode (default) 1: ChargeCodeOnly
    if (typeof chargeCodeDisplay === 'undefined' || (!chargeCodeDisplay))
        chargeCodeDisplay = "";
    //</CODE_TAG_105100>
    $(function () {

        var curQuoteEditMode = "EDIT";

        $("#moduleTitleContainer").html("Quote:<%= QuoteNo %>");

        $j("#divQuoteHeaderEdit").dialog({ width: 850,
            height: 700,
            draggable: true,
            position: 'center',
            resizable: false,
            modal: true,
            title: 'Edit Quote Header',
            autoOpen: false,
            open: function () { allowDataChangedWarning = false; },
            close: function () { allowDataChangedWarning = true; }
        });


        $j("#divQuoteDeletion").dialog({ width: 350,
            height: 200,
            draggable: true,
            position: 'center',
            resizable: false,
            modal: true,
            title: 'Delete Quote',
            autoOpen: false,
            open: function () { allowDataChangedWarning = false; },
            close: function () { allowDataChangedWarning = true; }
        });

        $j("#divQuoteStatusChange").dialog({ width: 350,
            height: 220,
            draggable: true,
            position: 'center',
            resizable: false,
            modal: true,
            title: 'Quote Status Change',
            autoOpen: false,
            open: function () { allowDataChangedWarning = false; },
            close: function () { allowDataChangedWarning = true; }
        });

        $j("#divEmailPDF").dialog({ width: 650,
            height: 360,
            draggable: true,
            position: 'center',
            resizable: false,
            modal: true,
            title: 'Email',
            autoOpen: false,
            open: function () { allowDataChangedWarning = false; },
            close: function () { allowDataChangedWarning = true; }
        });

        $j("#divPrintDetail").dialog({ width: 400,
            height: 200,
            draggable: true,
            position: 'center',
            resizable: false,
            modal: true,
            title: 'Detail Option',
            autoOpen: false,
            open: function () { allowDataChangedWarning = false; },
            close: function () { allowDataChangedWarning = true; }
        });

        $j("#divLinkWOSegmentSearch").dialog({ width: 850,
            height: 600,
            draggable: true,
            position: 'center',
            resizable: false,
            modal: true,
            title: 'Workorder Segment Search',
            autoOpen: false
        });

        $j("#divCustomerSearch").dialog({ width: 970,
            height: 600,
            draggable: true,
            position: 'center',
            resizable: false,
            modal: true,
            title: 'Customer Search',
            autoOpen: false
        });

        $j("#divPopWaiting").dialog({ width: 200,
            height: 100,
            draggable: true,
            position: 'center',
            resizable: false,
            modal: true,
            autoOpen: false
        });
//<CODE_TAG_103401> start
        $j("#divFax").dialog({ width: 650,
            height: 360,
            draggable: true,
            position: 'center',
            resizable: false,
            modal: true,
            title: 'Fax',
            autoOpen: false,
            open: function () { allowDataChangedWarning = false; },
            close: function () { allowDataChangedWarning = true; }
        });
//<CODE_TAG_103401> end
        if (errorMessage != "")
            alert(errorMessage);

    });

   

    function showCustomerSearch() {
        // <CODE_TAG_105262> lwang
        if ($j("#hdnCustomerNo").val() !="") {
            var customerNo = $j("#hdnCustomerNo").val();
            var division = $j("#hdnDivision").val();
            $j("#iFrameCustomerSearch").attr("src", "../TRG_Search/Equipment/CustomerSearch/Customer_Search.aspx?TT=iframe&DefaultDivision=" + division + "&SearchField=1&keyword=" + customerNo);
        }
        else
        // <CODE_TAG_105262> lwang
        $j("#iFrameCustomerSearch").attr("src", "../TRG_Search/Equipment/CustomerSearch/Customer_Search.aspx?TT=iframe");
        $j("#divCustomerSearch").dialog("open");
    }

    function closeCustomerSearch() {
        $j("#divCustomerSearch").dialog("close");
    }

    function editHeader() {
        curQuoteEditMode = "EDIT";
        $j("#iFrameHeaderEdit").attr("src", "./Controls/QuoteHeaderEdit.aspx?TT=iframe&quoteID=<%=QuoteId.ToString() %>&revision=<%=Revision.ToString() %>");
        $j("#divQuoteHeaderEdit").dialog("open");
    }

    function closeEditHeader() {
        $j("#divQuoteHeaderEdit").dialog("close");
    }


    function changeQuoteStatusToOpen(statusId, statusDesc) {
        if (confirm("Are you sure to change the quote status to to [" + statusDesc  + "] ?")) {
            $("#hdnPostbackOperation").val("operation=ChangeStatus&statusId=" + statusId);
            $("#btnPostBack").click();
        }
    }

    function changeQuoteStatusToClose(statusId, statusDesc) {
        //$("#hdnPostbackOperation").val("operation=ChangeStatus&statusId=" + statusId);
        //$("#btnPostBack").click();

        if (statusId == 4 && (DBSCustomer == "0" || SegmentHasProspectCust == "1")) {
            if (SegmentHasProspectCust == "1")
                alert("Please change prospect customer to DBS customer in all segments of current revision.")
            if (DBSCustomer == "0") {
                alert("Please change prospect customer to DBS customer before creating work order.");
                editHeader();
            }
        }
        else {
            if (confirm("Are you sure to change the quote status to [" + statusDesc + "] ?")) {
                if (RevisionCount == 1)
                {
                    var autoCreateTicket = 0;
                    if (statusId == 4 && serviceLinkTicket === '2' && SegmentHasBlankJobCode == "0" && SegmentHasBlankComponentCode == "0"){
                        if (confirm("Do you want to create serviceslink ticket?")){
                            autoCreateTicket = 2;
                        }
                    }
                    $("#hdnPostbackOperation").val("operation=ChangeStatus&statusId=" + statusId + "&CreateTicket=" + autoCreateTicket);
                    $("#btnPostBack").click();
                }
                else
                {
                    $j("#iFrameQuoteStatusChange").attr("src", "./Controls/CloseQuote.aspx?TT=iframe&quoteID=<%=QuoteId.ToString() %>&Revision=<%=Revision.ToString() %>&quoteCloseStatusDesc=" + statusDesc + "&quoteCloseStatusId=" + statusId);
                    $j("#divQuoteStatusChange").dialog("open");
                }
                // CODE_TAG_105518> lwang
                if ('<%= AppContext.Current.AppSettings["psQuoter.Quote.Lost.Opportunity.Edit"]%>' == '2')
                {
                    var oppNo = $j("[id*=lblOppNo]").text();
                    if (statusId == 8 && oppNo != "")
                    {                                        
                        var x = window.open("<%=ConfigurationManager.AppSettings["url.siteRootPath"]%>lwang/SalesLink/Executive/modules/opportunity/oppdetails.aspx?Edit=1&OppNo=" + oppNo , "OpportunityEdit", "width=600,height=600,scrollbars=yes,resizable=yes");
                        x.focus();                
                    } 
                }
                // <CODE_TAG_105518> lwang
            }
        }
    }

    function copyToNewRevision() {
        $("#hdnPostbackOperation").val("operation=CopyRevision");
        $("#btnPostBack").click();
    }
    function copyToNewQuote() {
        $("#hdnPostbackOperation").val("operation=CopyQuote");
        $("#btnPostBack").click();
    }
    function deleteRevision() {
        if (confirm("Are you sure to delete the current revision?")) {
            allowDataChangedWarning = false;
            $("#hdnPostbackOperation").val("operation=DeleteRevision");
            $("#btnPostBack").click();
        }
    }
    function deleteQuote() {
        if (confirm("Are you sure to delete the current quote?")) {
            allowDataChangedWarning = false;
            $j("#iFrameQuoteDeletion").attr("src", "./Controls/QuoteDelete.aspx?TT=iframe&quoteID=<%=QuoteId.ToString() %>");
            $j("#divQuoteDeletion").dialog("open");
        }
    }
    function closeDeleteQuote() {
        $j("#divQuoteDeletion").dialog("close");
    }
    function closeChangeQuoteStatus() {
        $j("#divQuoteStatusChange").dialog("close");
    }
    function changeRevisionStatus(statusId) {
        if (confirm("Are you sure to change the current revision status?")) {
            $("#hdnPostbackOperation").val("operation=ChangeRevisionStatus&statusId=" + statusId);
            $("#btnPostBack").click();
        }
    }
    function createWorkorder() {

            if (SegmentHasProspectCust == "1")
            {
                alert("Please change prospect customer to DBS customer in all segments of current revision.");
                return;
            }
            if (DBSCustomer == "0") {
                alert("Please change prospect customer to DBS customer in the quote header before creating work order.");
                editHeader();
                return;
           }
           if (SMUCheck=="0"){
            //<CODE_TAG_103502> 
                var c = confirm("The SMU Value should not be lower than the last known SMU value. Are you sure to continue?");
                //alert("The SMU value is no longer valid, please update it.");
                if (c == false)
                {
                    editHeader();
                    return;
                }
           }
           if (CostCentreCheck=="0"){
                alert("The Cost Center is blank in one or more segments, please update before creating work order.");
                return;
           }
            setTimeout('document.getElementById("divPopWaiting_Img").src = "../../Library/images/waiting.gif"', 1000);
            $j(".ui-dialog-titlebar").hide();
            $j("#divPopWaiting").dialog("open");

            $("#hdnPostbackOperation").val("operation=CreateWorkorder");
            $("#btnPostBack").click();
    }
    function linkWorkorder() {
        showLinkWOSegmentSearch();
    }
    //<CODE_TAG_103366> start
    function unlinkWorkorder() {
        if (confirm("Are you sure to unlink the current work order?")) {
            allowDataChangedWarning = false;
            $("#hdnPostbackOperation").val("operation=UnlinkWorkorder");
            $("#btnPostBack").click(); 
        }       
    }
    //<CODE_TAG_103366> end
    function linkWorkorderToNewRevision() {
        $("#hdnPostbackOperation").val("operation=LinkWOToNewRevision");
        $("#btnPostBack").click();
    }
    function editWorkorderNo(wono) {
        closeLinkWOSegmentSearch();
        $("#hdnPostbackOperation").val("operation=LinkWorkorder&wono=" + wono);
        $("#btnPostBack").click();
    }
    function openWorkorder() {
        $("#hdnPostbackOperation").val("operation=OpenWorkorder");
        $("#btnPostBack").click();
    }
    function updateWorkorder() {

         if (SMUCheck=="0"){
                alert("The SMU value is no longer valid, please update it.");
                editHeader();
                return;
         }
        
         if (CostCentreCheck=="0"){
                alert("The Cost Center is blank in one or more segments, please update it.");
                return;
           }

         setTimeout('document.getElementById("divPopWaiting_Img").src = "../../Library/images/waiting.gif"', 1000);
         $j(".ui-dialog-titlebar").hide();
         $j("#divPopWaiting").dialog("open");

         $("#hdnPostbackOperation").val("operation=UpdateWorkorder");
         $("#btnPostBack").click();
        
    }
    function deleteWorkorder() {
        setTimeout('document.getElementById("divPopWaiting_Img").src = "../../Library/images/waiting.gif"', 1000);
        $j(".ui-dialog-titlebar").hide();
        $j("#divPopWaiting").dialog("open");

        $("#hdnPostbackOperation").val("operation=DeleteWorkorder");
        $("#btnPostBack").click();
    }
    function closeEmail() {
        $j("#divEmailPDF").dialog("close");
    }
//<CODE_TAG_103401> start
    function closeFax() {
        $j("#divFax").dialog("close");
    }
//<CODE_TAG_103401> end    
    function divPrintDetailOK_onclick() {
        $j('#divPrintDetail').dialog('close');
        var detail = 1;
        if ($("#rdoPrintDetailHide").attr("checked") == "checked")
            detail = 0;
        var url = "Print_QuotePDF.aspx?Type=1&QuoteId=<%=QuoteId %>&Revision=<%=Revision %>&QuoteNo=<%=QuoteNo %>&Internal=0&SendEmail=1&Division=G&Detail=" + detail + "&TT=iframe";
        $j("#iFrameEmailPDF").attr("src", url);
        $j("#divEmailPDF").dialog("open");
    }
    <% // <CODE_TAG_101481> %>
    function print(printType,customerNo,internal) {
        var x;
        switch(printType)
        {
            case "Pdf":
               // x = window.open("Print_QuotePDF.aspx?Type=1&QuoteId=<%=QuoteId %>&Revision=<%=Revision %>&QuoteNo=<%=QuoteNo %>&Internal=" + internal + "&CustomerNo=" + customerNo + "&SendEmail=0&Division=G&Detail=1", "PDF", "scrollbars=yes,menubar=yes,resizable=yes,toolbar=no,height=800,width=710,left=50,top=50");
                x = window.open("PrintQuoteDocument.aspx?QuoteId=<%=QuoteId %>&Revision=<%=Revision %>&Internal=" + internal + "&CustomerNo=" + customerNo + "&UserId=<%= X.Web.WebContext.Current.User.IdentityEx.UserID   %>&docType=PDF", "Report", "scrollbars=yes,menubar=yes,resizable=yes,toolbar=no,height=2,width=2,left=50,top=50");
                // to display the document with pop up window.
               // x = window.open("PrintQuoteDocumentDebug.aspx?QuoteId=<%=QuoteId %>&Revision=<%=Revision %>&Internal=" + internal + "&CustomerNo=" + customerNo + "&UserId=<%= X.Web.WebContext.Current.User.IdentityEx.UserID   %>&docType=PDF", "Report", "scrollbars=yes,menubar=yes,resizable=yes,toolbar=no,height=2,width=2,left=50,top=50");
                break;

            case "Word":
               // x = window.open("Print_QuotePDF.aspx?Type=1&QuoteId=<%=QuoteId %>&Revision=<%=Revision %>&QuoteNo=<%=QuoteNo %>&Internal=" + internal + "&CustomerNo=" + customerNo + "&SendEmail=0&Division=G&Detail=1", "PDF", "scrollbars=yes,menubar=yes,resizable=yes,toolbar=no,height=800,width=710,left=50,top=50");
                x = window.open("PrintQuoteDocument.aspx?QuoteId=<%=QuoteId %>&Revision=<%=Revision %>&Internal=" + internal + "&CustomerNo=" + customerNo + "&UserId=<%= X.Web.WebContext.Current.User.IdentityEx.UserID   %>&docType=WORD", "Report", "scrollbars=yes,menubar=yes,resizable=yes,toolbar=no,height=2,width=2,left=50,top=50");
                break;
            //<CODE_TAG_104470>
            case "Excel":
                // x = window.open("Print_QuotePDF.aspx?Type=1&QuoteId=<%=QuoteId %>&Revision=<%=Revision %>&QuoteNo=<%=QuoteNo %>&Internal=" + internal + "&CustomerNo=" + customerNo + "&SendEmail=0&Division=G&Detail=1", "PDF", "scrollbars=yes,menubar=yes,resizable=yes,toolbar=no,height=800,width=710,left=50,top=50");
                x = window.open("PrintQuoteDocument.aspx?QuoteId=<%=QuoteId %>&Revision=<%=Revision %>&Internal=" + internal + "&CustomerNo=" + customerNo + "&UserId=<%= X.Web.WebContext.Current.User.IdentityEx.UserID   %>&docType=EXCEL", "Report", "scrollbars=yes,menubar=yes,resizable=yes,toolbar=no,height=2,width=2,left=50,top=50");
                break;
            //<CODE_TAG_104470>
            case "Email":
                //$j("#divPrintDetail").dialog("open");
                //var url = "Print_QuotePDF.aspx?Type=1&QuoteId=<%=QuoteId %>&Revision=<%=Revision %>&QuoteNo=<%=QuoteNo %>&Internal=0&CustomerNo=" + customerNo + "&SendEmail=1&Division=G&Detail=1&TT=iframe";
                var email = document.getElementById('hdnEmail').value;  <%--TICKET 23348--%>
                 var url = "EmailQuoteDocument.aspx?QuoteId=<%=QuoteId %>&Revision=<%=Revision %>&Internal=" + internal + "&Email=" + email + "&CustomerNo=" + customerNo + "&UserId=<%= X.Web.WebContext.Current.User.IdentityEx.UserID   %>&TT=iframe";
                
                $j("#iFrameEmailPDF").attr("src", url);
                $j("#divEmailPDF").dialog("open");
                break;
//<CODE_TAG_103401> start
            case "Fax":
                var fax = document.getElementById('hdnFax').value;  <%--TICKET 23348--%>
                var url = "FaxQuoteDocument.aspx?QuoteId=<%=QuoteId %>&Revision=<%=Revision %>&Internal=" + internal + "&Fax=" + fax + "&CustomerNo=" + customerNo + "&UserId=<%= X.Web.WebContext.Current.User.IdentityEx.UserID   %>&TT=iframe";
                
                $j("#iFrameFax").attr("src", url);
                $j("#divFax").dialog("open");
                break;
//<CODE_TAG_103401> end
        } 
        
    }
     <% // </CODE_TAG_101481> %>
    function showLinkWOSegmentSearch() {
        $j("#iFrameLinkWOSegmentSearch").attr("src", "Controls/WOSegmentSearch.aspx?TT=iframe&searchType=4");
        $j("#divLinkWOSegmentSearch").dialog("open");
    }

    function closeLinkWOSegmentSearch() {
        $j("#divLinkWOSegmentSearch").dialog("close");
    }

    function createTicket() {
            if (SegmentHasProspectCust == "1")
            {
                alert("Please change prospect customer to DBS customer in all segments of current revision.");
                return;
            }

            if (SegmentHasBlankJobCode == "1")
            {
                alert("Please fill job code in all segments of current revision.");
                return;
            }

            if (SegmentHasBlankComponentCode == "1")
            {
                alert("Please fill component code in all segments of current revision.");
                return;
            }

			

            if (DBSCustomer == "0") {
                alert("Please change prospect customer to DBS customer in the quote header before creating work order.");
                editHeader();
                return;
           }
           if (SMUCheck=="0"){
            //<CODE_TAG_103502> 
                var c = confirm("The SMU Value should not be lower than the last known SMU value. Are you sure to continue?");
                //alert("The SMU value is no longer valid, please update it.");
                if (c == false)
                {
                    editHeader();
                    return;
                }
           }
//           if (CostCentreCheck=="0"){
//                alert("The Cost Center is blank in one or more segments, please update before creating work order.");
//                return;
//           }
            setTimeout('document.getElementById("divPopWaiting_Img").src = "../../Library/images/waiting.gif"', 1000);
            $j(".ui-dialog-titlebar").hide();
            $j("#divPopWaiting").dialog("open");

            $("#hdnPostbackOperation").val("operation=CreateTicket");
            $("#btnPostBack").click();
    }
   function updateTicket() {

         if (SMUCheck=="0"){
                alert("The SMU value is no longer valid, please update it.");
                editHeader();
                return;
         }
        
         if (CostCentreCheck=="0"){
                alert("The Cost Center is blank in one or more segments, please update it.");
                return;
           }

         setTimeout('document.getElementById("divPopWaiting_Img").src = "../../Library/images/waiting.gif"', 1000);
         $j(".ui-dialog-titlebar").hide();
         $j("#divPopWaiting").dialog("open");

         $("#hdnPostbackOperation").val("operation=Updateticket");
         $("#btnPostBack").click();
    }


  function deleteTicket() {
        setTimeout('document.getElementById("divPopWaiting_Img").src = "../../Library/images/waiting.gif"', 1000);
        $j(".ui-dialog-titlebar").hide();
        $j("#divPopWaiting").dialog("open");

        $("#hdnPostbackOperation").val("operation=DeleteTicket");
        $("#btnPostBack").click();
    }

 function openTicket(ticketId){
    window.open("/EquipmentLink/#SVL/ticket/index?ticket_Id=" + ticketId +"&view=overview");

 }
 function openZjb() {
    window.open("http://intranet.holtcompanies.com/mach/MACHServiceSite/StandardJobs/Lists/Standard%20Jobs%20List/AllItems.aspx" );
 }

 
</script>
