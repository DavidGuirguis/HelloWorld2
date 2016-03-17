<%@ Page Title="" Language="C#" MasterPageFile="~/Library/MasterPages/_base.master"
    EnableEventValidation="false" AutoEventWireup="true" CodeFile="Quote_Segment.aspx.cs"
    Inherits="Modules_Quote_Segment" %>

<%@ Register Src="Controls/QuoteHeader.ascx" TagName="QutoeHeader" TagPrefix="uc1" %>
<%@ Register Src="Controls/SegmentCustomersDisplay.ascx" TagName="SegmentCustomersDisplay" TagPrefix="uc6" %> 
<%@ Register Src="Controls/Parts.ascx" TagName="Parts" TagPrefix="uc2" %>
<%@ Register Src="Controls/Labor.ascx" TagName="Labor" TagPrefix="uc3" %>
<%@ Register Src="Controls/Misc.ascx" TagName="Misc" TagPrefix="uc4" %>
<%@ Register Src="Controls/Notes.ascx" TagName="Notes" TagPrefix="uc5" %>

<asp:Content ID="Content5" ContentPlaceHolderID="cntMP" runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div id="divSearchbleList" style="position: absolute; background-color: White; display: none;
        z-index: 1000">
    </div>
    <uc1:QutoeHeader ID="quoteHeader" runat="server"></uc1:QutoeHeader>
    <table style="width: 100%">
        <tr>
            <td style="vertical-align: top; width: 38px;" id="tdLeftMenuContainer">
                <div id="leftPaneBox" style="width: 38px; margin-left: 10px">
                    <div id="leftMenuSmall" style="display: ;">
                        <div>
                            <span class="tSb">SEG </span><span style="float: right">
                                <img class='imgBtn' src="../../library/images/rarrow.gif" onclick="leftMenuExchange('Large');" />
                            </span>
                        </div>
                        <%
                            leftMenuSmall.Render(MenuRenderType.Vertical);
                        %>
                    </div>
                    <div id="leftMenuLarge" style="display: none;">
                        <div>
                            <span class="tSb">SEGMENT </span><span style="float: right">
                                <img class='imgBtn' src="../../library/images/rarrow_left.gif" onclick="leftMenuExchange('Small');" />
                            </span>
                        </div>
                        <%
                            leftMenuLarge.Render(MenuRenderType.Vertical);
                        %>
                    </div>
                </div>
            </td>
            <td>
                <div id="divSegmentEdit" runat="server" class="Segment">
                    <table width="100%" cellspacing="0">
                        <tr>
                            <th>
                                Segment No:
                            </th>
                            <td>
                                <asp:TextBox ID="txtSegmentNo" ClientIDMode="Static" CssClass="segmentNoTextbox" onchange="pageDataChanged = true;"
                                    TabIndex="1" runat="server"></asp:TextBox> <!--CODE_TAG_103934-->
                                &nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:Label ID="lblSegmentNoPreviousVersionEdit" runat="server"></asp:Label>
                            </td>
                            <th>
                                <!--CODE_TAG_105387-->
                                <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.JobCode.Mandatory"))  {%>  
                                <span style="color: red">Job Code:*</span><!--CODE_TAG_101962-->
                                <% } else  {%>
                                <span>Job Code:</span>
                                <%} %>
                                <!--/CODE_TAG_105387-->
                            </th>
                            <td style="white-space: nowrap">
                                <asp:HiddenField ID="hidJobCode" Value="" runat="server" />
                                <!--CODE_TAG_103329-->
                                <asp:TextBox ID="txtOnlyJobCode" Style="width: 30px" TabIndex="2" onfocus="this.select()"  onblur="txtCodeOnly_onblur('txtOnlyJobCode','txtJobCode','hidJobCode', arrJobCode,'~' );" onkeydown="txtCodeOnly_onkeydown('txtOnlyJobCode','txtJobCode','hidJobCode', arrJobCode, 'txtOnlyComponentCode','~');"   runat="server" MaxLength="4" ></asp:TextBox>
                                
                                <asp:TextBox ID="txtJobCode" Style="width: 200px" TabIndex="2" onfocus="this.select()" onkeyup="txtSearchbleListKeyUp('txtJobCode', 'hidJobCode', arrJobCode,'txtOnlyJobCode','~');"
                                    runat="server" MaxLength="50"></asp:TextBox>
                                <span onclick="displaySearchbleList('','txtJobCode', 'hidJobCode', arrJobCode,'txtOnlyJobCode','~'); "><!--/CODE_TAG_103329-->
                                    <img style="margin-right: 8px; margin-top: 6px; cursor: pointer" alt="" src="../../library/images/arrowdown.gif" /></span>
                            </td>
                            <th>
                                <!--CODE_TAG_105387-->
                                <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.ComponentCode.Mandatory"))  {%>  
                                <span style="color: red">Component Code:*</span><!--CODE_TAG_101962-->
                                <% } else  {%>
                                <span>Component Code:</span>
                                <%} %>
                                <!--/CODE_TAG_105387-->
                            </th>
                            <td style="white-space: nowrap">
                                <asp:HiddenField ID="hidComponentCode" Value="" runat="server" />
                                <asp:TextBox ID="txtOnlyComponentCode" Style=" width: 30px" TabIndex="3" onfocus="this.select()" onblur="txtCodeOnly_onblur('txtOnlyComponentCode','txtComponentCode','hidComponentCode', arrComponentCode,'~'  );" onkeydown="txtCodeOnly_onkeydown('txtOnlyComponentCode','txtComponentCode','hidComponentCode', arrComponentCode ,'txtOnlyModifierCode','~' );" runat="server" MaxLength="4" ></asp:TextBox>  <!--CODE_TAG_103329-->
                                <asp:TextBox ID="txtComponentCode" Style=" width: 200px" TabIndex="3" onfocus="this.select()"  onkeyup="txtComponentCode_onkeyup();"
                                    runat="server" MaxLength="50"></asp:TextBox>
                                <span onclick="displaySearchbleList('','txtComponentCode', 'hidComponentCode', arrComponentCode,'txtOnlyComponentCode','~'); "><!--CODE_TAG_103329-->
                                    <img style="margin-right: 8px; margin-top: 6px; cursor: pointer" alt="" src="../../library/images/arrowdown.gif" /></span>
                            </td>
                            <%--<th>
                                Description:
                            </th>
                            <td colspan="2">
                                <asp:TextBox ID="txtSegmentDescription" Style="width: 95%" runat="server"></asp:TextBox>
                            </td>--%>
                            <td class="tAr">
                                <asp:Button ID="btnPrevisouSegmentEdit" runat="server" TabIndex="1001" Text="< Previous"
                                    OnClick="btnChangeSegment_Click" />
                                <asp:Button ID="btnNextSegmentEdit" runat="server" TabIndex="1002" Text="Next >"
                                    OnClick="btnChangeSegment_Click" />
                                &nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:Button ID="btnDelete" runat="server" Text="Delete" OnClick="btnSegmentDelete_Click"
                                    TabIndex="1003" OnClientClick="return confirmDeleteCurrentSegment();" />
                                <asp:Button ID="btnSave" runat="server" ClientIDMode="Static" Text="Save" TabIndex="1004" OnClientClick="this.disable = true;  return validation(); "
                                    OnClick="btnSegmentSave_Click" /><!--Ticket 48136-->
                                <asp:Button ID="btnCancel" runat="server" Text="Cancel" TabIndex="1005" OnClick="btnSegmentCancel_Click" />
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Modifier Code:
                            </th>
                            <td style="white-space: nowrap">
                                <asp:HiddenField ID="hidModifierCode" Value="" runat="server" />
                                <asp:TextBox ID="txtOnlyModifierCode" Style="width: 30px" TabIndex="4" onfocus="this.select()" onblur="txtCodeOnly_onblur('txtOnlyModifierCode','txtModifierCode','hidModifierCode', arrModifierCode  );" onkeydown="txtCodeOnly_onkeydown('txtOnlyModifierCode','txtModifierCode','hidModifierCode', arrModifierCode ,'lstBusinessGroupCode' );" runat="server" MaxLength="4" ></asp:TextBox>
                                <asp:TextBox ID="txtModifierCode" Style="width: 200px" TabIndex="4"  onfocus="this.select()"
                                    onkeyup="txtSearchbleListKeyUp('txtModifierCode', 'hidModifierCode', arrModifierCode, 'txtOnlyModifierCode');"
                                    runat="server" MaxLength="50"></asp:TextBox>
                                <span onclick="displaySearchbleList('','txtModifierCode', 'hidModifierCode', arrModifierCode, 'txtOnlyModifierCode');">
                                    <img style="margin-right: 8px; margin-top: 6px; cursor: pointer" alt="" src="../../library/images/arrowdown.gif" /></span>
                            </td>
                            <th>
                                Business Group:
                            </th>
                            <td>
                                <asp:DropDownList ID="lstBusinessGroupCode" TabIndex="5" onchange="pageDataChanged = true;"
                                    runat="server">
                                </asp:DropDownList>
                            </td>
                            <th>
                                Quantity Code:
                            </th>
                            <td>
                                <asp:DropDownList ID="lstQuantityCode" TabIndex="6" onchange="pageDataChanged = true;"
                                    runat="server">
                                </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Shop/Field:
                            </th>
                            <td>
                                <asp:DropDownList ID="lstShopFieldCode" TabIndex="7" onchange="pageDataChanged = true;"
                                    runat="server">
                                </asp:DropDownList>
                            </td>
                            <th>
                                <span style="color: red">Store:*</span><%--<CODE_TAG_101962>--%>
                            </th>
                            <td>
                                <asp:DropDownList ID="lstStoreCode" TabIndex="8" ClientIDMode="Static" onchange="reloadCostCentreCode();    pageDataChanged = true;"
                                    runat="server">
                                </asp:DropDownList><!--CODE_TAG_101936--><!--Ticket 20479-->
                            </td>
                            <th>
                                <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.CostCenterCode.Mandatory"))  {%>  <!--CODE_TAG_104950-->
                                <span style="color: red">Cost Center:*</span><!--CODE_TAG_101962-->
                                <% } else  {%>
                                <span>Cost Center:</span>
                                <%} %>
                            </th>
                            <td>
                                <asp:DropDownList ID="lstCostCenterCode" TabIndex="9" onchange="pageDataChanged = true; reloadLaborChargeCode(); reloadMiscChargeCode();resetLabourChargeCode();"
                                    ClientIDMode="Static" runat="server">
                                </asp:DropDownList><!--CODE_TAG_101936--><!--Ticket 20479-->
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                        <!--CODE_TAG_105264-->
                            <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Quantity.Show"))
                               { %><!--/CODE_TAG_105264-->

                                    <!-- <CODE_TAG_101750>-->
                                    <th>Segment Quantity:</th><!--CODE_TAG_101936-->
                                    <td><asp:TextBox ID="txtSegmentQty"  CssClass="segmentNoTextbox" TabIndex="91" onchange="pageDataChanged = true;" runat="server" ></asp:TextBox></td>
                                    <!--CODE_TAG_101936-->

                            <!--CODE_TAG_105264-->
                            <%} %>
                            
                            <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.StdandardHours.Show"))
                               { %><!--/CODE_TAG_105264-->

                                    <th>Standard Hours:</th>
                                    <td><asp:TextBox ID="txtStdHours"  CssClass="segmentNoTextbox" TabIndex="92" onchange="pageDataChanged = true;" runat="server" Width="83px" ></asp:TextBox></td>
                                    <!--/CODE_TAG_101936-->

                            <%} %><!--CODE_TAG_105264-->
                        </tr>
                        <tr>
                            <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.WorkApplicationCode.Show"))
                               { %>
                            <th>
                                Work Application Code:
                            </th>
                            <td>
                                <asp:DropDownList ID="lstWorkApplicationCode" TabIndex="10" onchange="pageDataChanged = true;"
                                    runat="server">
                                </asp:DropDownList>
                            </td>
                            <%
                               }
                            %>
                            <%if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.CabType.Show"))
                              { %>
                            <th>
                                Cab Type:
                            </th>
                            <td>
                                <asp:DropDownList ID="lstCabTypeCode" TabIndex="11" onchange="pageDataChanged = true;"
                                    runat="server">
                                </asp:DropDownList>
                            </td>
                            <%} %>
                            <%if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.JobLocation.Show"))
                              { %>
                            <th>
                                Job Location:
                            </th>
                            <td>
                                <asp:DropDownList ID="lstJobLocationCode" TabIndex="12" onchange="pageDataChanged = true;"
                                    runat="server">
                                </asp:DropDownList>
                            </td>
                            <td>
                            </td>
                            <%} %>
                        </tr>
                    </table>
                </div>
                <div id="divSegmentReadonly" clientidmode="Static" runat="server" class="Segment">
                    <table width="100%" cellspacing="0">
                        <tr>
                            <th>
                                Segment No:
                            </th>
                            <td>
                                <asp:Label ID="lblSegmentNo" runat="server"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:Label ID="lblSegmentNoPreviousVersionReadonly" runat="server"></asp:Label>
                            </td>
                            <th>
                                Job Code:
                            </th>
                            <td>
                                <asp:Label ID="lblJobCode" runat="server"></asp:Label>
                            </td>
                            <th>
                                Component Code:
                            </th>
                            <td>
                                <asp:Label ID="lblComponentCode" runat="server"></asp:Label>
                            </td>
                            <%--<th>
                                Description:
                            </th>
                            <td colspan="2">
                                <asp:Label ID="lblSegmentDescription" runat="server"></asp:Label>
                            </td>--%>
                            <td class="tAr">
                                <asp:Button ID="btnPrevisouSegmentReadonly" runat="server" Text="< Previous" OnClick="btnChangeSegment_Click" />
                                <asp:Button ID="btnNextSegmentReadonly" runat="server" Text="Next >" OnClick="btnChangeSegment_Click" />
                                &nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:Button ID="btnEdit" runat="server" Text="Edit" OnClick="btnSegmentEdit_Click" />
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Modifier Code:
                            </th>
                            <td>
                                <asp:Label ID="lblModifierCode" runat="server"></asp:Label>
                            </td>
                            <th>
                                Business Group:
                            </th>
                            <td>
                                <asp:Label ID="lblBusinessCode" runat="server"></asp:Label>
                            </td>
                            <th>
                                Quantity Code:
                            </th>
                            <td>
                                <asp:Label ID="lblQuantityCode" runat="server"></asp:Label>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Shop/Field:
                            </th>
                            <td>
                                <asp:Label ID="lblShopField" runat="server"></asp:Label>
                            </td>
                            <th>
                                Store:
                            </th>
                            <td>
                                <asp:Label ID="lblStoreCode" ClientIDMode="Static" runat="server"></asp:Label>
                            </td>
                            <th>
                                Cost Center:
                            </th>
                            <td>
                                <asp:Label ID="lblCostCenterCode" ClientIDMode="Static" runat="server"></asp:Label>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                        <!--CODE_TAG_105264-->
                            <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Quantity.Show"))
                               { %><!--/CODE_TAG_105264-->

                                    <!-- <CODE_TAG_101750>-->
                                    <th>Segment Quantity:</th>
                                    <td><asp:Label ID="lblSegmentQty" runat="server" ></asp:Label></td>
                                    <%--<CODE_TAG_102032>--%>
                                    <% if (WOSegmentQty.CompareTo("1")>0)  {%>
                                    <th>Work Order Segment Quantity:</th>
                                    <td><span id="lblWOSegmentQty"><%=WOSegmentQty %></span></td>
                                    <% } %>
                                    <%--<CODE_TAG_102032>--%>

                            <!--CODE_TAG_105264-->
                            <%} %>
                            
                            <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.StdandardHours.Show"))
                               { %><!--/CODE_TAG_105264-->

                                    <!--CODE_TAG_101936-->
                                    <th>Std Hours</th>
                                    <td><asp:Label ID="lblStdHours" runat="server" ></asp:Label></td>
                                    <!--/CODE_TAG_101936-->
                            <%} %><!--CODE_TAG_105264-->

                        </tr>
                        <tr>
                            <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.WorkApplicationCode.Show"))
                               { %>
                            <th>
                                Work Application Code:
                            </th>
                            <td>
                                <asp:Label ID="lblWorkApplicationCode" runat="server"></asp:Label>
                            </td>
                            <%} %>
                            <%if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.CabType.Show"))
                              { %>
                            <th>
                                Cab Type:
                            </th>
                            <td>
                                <asp:Label ID="lblCabTypeCode" runat="server"></asp:Label>
                            </td>
                            <%} %>
                            <%if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.JobLocation.Show"))
                              { %>
                            <th>
                                Job Location:
                            </th>
                            <td>
                                <asp:Label ID="lblJobLocation" runat="server"></asp:Label>
                            </td>
                            <td>
                            </td>
                            <%} %>
                        </tr>
                    </table>
                </div>

               <div id="divSegmentCustomerDisplay">
               <uc6:SegmentCustomersDisplay ID="ucSegmentCustomers" runat="server"></uc6:SegmentCustomersDisplay>
               </div>
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
                        <%--CODE_TAG_103339--%>
                        <%if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Notes.MultiLineEdit.Show")) { %>
                            * Only first 4 lines are sent to DBS work orders.
                        <%} %>
                        <%--CODE_TAG_103339--%>
                        </div>
                        <uc5:Notes ID="ucInstructions" runat="server"></uc5:Notes>
                    </div>
                    <h3>
                        <a href="#">Parts <span id="spanDetailCountParts"></span></a>
                    </h3>
                    <div>
                        <uc2:Parts ID="ucParts" runat="server"></uc2:Parts>
                         <!--CODE_TAG_104302-->
                        <%if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Print.ShowDetailAndSummaryFromSegmentLevel"))
                          { %>
                           <table>
                        <%}
                          else
                          { %>
                          <table style="display:none">
                        <% }%>
                        <!--/CODE_TAG_104302-->
                            <tr>
                            <td>
                                Quote Document:
                            </td>
                            <td style='width:200px'>
                                <asp:CheckBox ID="ckbShowPartsDetail" runat="server" Checked="true" Enabled="false" />Show Parts Detail
                            </td>

                            <td style='width:200px'>
                                <asp:CheckBox ID="ckbShowPartsSummary" runat="server" Enabled="false" onclick='$("#txtPartsSummary").toggle();' />Show Parts Summary
                               
                            </td>
                            <td style='width:650px'>
                                <asp:TextBox ID="txtPartsSummary" ClientIDMode="Static" runat="server" TextMode="MultiLine" Width="100%" Enabled="false" style="display:none"></asp:TextBox>
                            </td>
                            </tr>
                        </table>
                    </div>
                    <h3>
                        <a href="#">Labor <span id="spanDetailCountLabor"></span></a>
                    </h3>
                    <div>
                        <uc3:Labor ID="ucLabor" runat="server"></uc3:Labor>
                         <!--CODE_TAG_104302-->
                        <%if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Print.ShowDetailAndSummaryFromSegmentLevel"))
                          { %>
                           <table>
                        <%}
                          else
                          { %>
                          <table style="display:none">
                        <% }%>
                        <!--/CODE_TAG_104302-->
                            <tr>
                            <td>
                                Quote Document:
                            </td>
                            <td style='width:200px'>
                                <asp:CheckBox ID="ckbShowLaborDetail" runat="server" Checked="true" Enabled="false" />Show Labor Detail
                            </td>

                            <td style='width:200px'>
                                <asp:CheckBox ID="ckbShowLaborSummary" runat="server" Enabled="false" onclick='$("#txtLaborSummary").toggle();' />Show Labor Summary
                               
                            </td>
                            <td style='width:650px'>
                                <asp:TextBox ID="txtLaborSummary" TextMode="MultiLine" ClientIDMode="Static" runat="server" Width="100%" Enabled="false" style="display:none"></asp:TextBox>
                            </td>
                            </tr>
                        </table>
                    </div>
                    <h3>
                        <a href="#">Miscellaneous <span id="spanDetailCountMisc"></span></a>
                    </h3>
                    <div>
                        <uc4:Misc ID="ucMisc" runat="server"></uc4:Misc>
                         <!--CODE_TAG_104302-->
                        <%if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Print.ShowDetailAndSummaryFromSegmentLevel"))
                          { %>
                           <table>
                        <%}
                          else
                          { %>
                          <table style="display:none">
                        <% }%>
                        <!--/CODE_TAG_104302-->
                            <tr>
                            <td>
                                Quote Document:
                            </td>
                            <td style='width:200px'>
                                <asp:CheckBox ID="ckbShowMiscDetail" runat="server" Checked="true" Enabled="false" />Show Misc Detail
                            </td>

                            <td style='width:200px'>
                                <asp:CheckBox ID="ckbShowMiscSummary" runat="server" Enabled="false" onclick='$("#txtMiscSummary").toggle();' />Show Misc Summary
                               
                            </td>
                            <td style='width:650px'>
                                <asp:TextBox ID="txtMiscSummary" ClientIDMode="Static" runat="server" TextMode="MultiLine" Width="100%" Enabled="false" style="display:none"></asp:TextBox>
                            </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </td>
        </tr>
    </table>
    <table width="100%" cellspacing="0">
        <tr>
            <td class="tAr">
                <asp:Button ID="btnBottomSave" runat="server" Text="Save" TabIndex="1006" OnClientClick="return validation();"
                    OnClick="btnSegmentSave_Click" />
                <asp:Button ID="btnBottomCancel" runat="server" Text="Cancel" TabIndex="1007" OnClick="btnSegmentCancel_Click" />
            </td>
        </tr>
    </table>
     
       <span id="spanSegmentWaitting" style='position: absolute;top:40%;left:50%; display:none'><img id="spanSegmentWaittingImg" src='' /></span>
    <div id="divNewSegment">
        <iframe id="iFrameNewSegment" src="" width="100%" height="100%" frameborder="0">
        </iframe>
    </div>
    <div id="divQuoteSegmentSearch">
        <iframe id="iFrameQuoteSegmentSearch" src="" width="100%" height="100%" frameborder="0">
        </iframe>
    </div>
    <div id="divWOSegmentSearch">
        <iframe id="iFrameWOSegmentSearch" src="" width="100%" height="100%" frameborder="0">
        </iframe>
    </div>
    <div id="divStandardJobSearch">
        <iframe id="iFrameStandardJobSearch" src="" width="100%" height="100%" frameborder="0" >
        </iframe>
    </div>
    <!--CODE_TAG_103560-->
    <div id="divDBSPartDocumentsSearch">
        <iframe id="iFrameDBSPartDocumentsSearch" name = "iFrameDBSPartDocumentsSearch" src="" width="100%" height="100%" frameborder="0" >
        </iframe>
    </div>
    <!--/CODE_TAG_103560-->
    <div id="divSegmentCustomerSearch">
        <iframe id="iFrameSegmentCustomerSearch" src="" width="100%" height="100%" frameborder="0">
        </iframe>
    </div>

    <div id="divSegmentCustomer">
        <iframe id="iFrameSegmentCustomer" src="" width="100%" height="100%" frameborder="0">
        </iframe>
    </div>
     <div id="divImportXMLDetail" style="display: none;">
        <iframe id="iframeXMLDetail" src=""  width="100%" height="100%" frameborder="0"  ></iframe>
    </div>
    <div id="divRefreshAllParts">
        Refreshing Parts Pricing and Availability. Please, wait…
    </div>

    <asp:HiddenField ID="hidFocusControl" Value='' ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hidCostCentreCode" Value='' ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hidExternalNotes" Value='' ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hidExternalNotesMasterIndicators" Value='' ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hidInstructions" Value='' ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hidTotalFlatRateInd" Value='N' ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hidTxtGrandTotal" Value='N' ClientIDMode="Static" runat="server" />
    <!--CODE_TAG_103600-->
    <asp:HiddenField ID="hdnSelectedDocNos" ClientIDMode="Static" Value="" runat="server" />
    <asp:Button ID="btnImportFromDBSPartsDoc" ClientIDMode="Static" runat="server"  style="display:none" 
        onclick="btnImportFromDBSPartsDoc_Click" />
    <!--/CODE_TAG_103600-->
    <asp:HiddenField ID="hdnSegmentNoList" ClientIDMode="Static" runat="server" /><!--CODE_TAG_103934-->

    <script type="text/javascript">
       var DetailCountExternalNotes = <%=DetailCountExternalNotes  %>;
       var DetailCountInstructions = <%=DetailCountInstructions  %>;
       var DetailCountParts = <%=DetailCountParts  %>;
       var DetailCountLabor = <%=DetailCountLabor  %>;
       var DetailCountMisc = <%=DetailCountMisc  %>;

       var SourceTypeId = "<%= SourceTypeId %>";
       var SourceSegmentId = "<%= SourceSegmentId %>";
       var SourceWONO = "<%=SourceWONO  %>";
       var SourceSegmentNo = "<%=  SourceSegmentNo %>";
       var SourceROId = "<%= SourceROId %>";
       var SourceROPId = "<%= SourceROPId %>";
        var SourceSelectedGroup = "<%=  SourceSelectedGroup.UrlEncode()   %>";

       //<CODE_TAG_105318> lwang       
       var LaborRepricing = <%=LaborRepricing %>;       
       $j(window).load(function () {
            if (LaborRepricing > 0  && DetailCountLabor > 0)
            {
                for(i = 1; i <= DetailCountLabor;i++) setupLaborChargeCode(i);
            }
        });
       //</CODE_TAG_105318> lwang
        function validation() {
            var strError= "";
            //<CODE_TAG_103934>
            /*if (!validateSegmentNo()) {
                alert ("Duplicate Segment No.");
                strError += "Duplicate Segment No." 
            }*/
            //</CODE_TAG_103934>
            
            //<CODE_TAG_105326>R.Z
            var strTempError = "";
            strTempError = validateSegmentNo();
            //<CODE_TAG_103934>
            if (strTempError != "") {
                alert (strTempError);
                strError += strTempError;
            }
            //</CODE_TAG_103934>
            //</CODE_TAG_105326>
            $("#hidCostCentreCode").val($("#lstCostCenterCode").val());

            if ($("#lstStoreCode").val() == "") {
                alert("Please select Store.");
                strError += "Please select Store.";
            }
            //<CODE_TAG_105387>
            <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.JobCode.Mandatory"))  {%>  
            if ($j("[id*=hidJobCode]").val() == "" ) {
                alert("Please select Job Code.");
                strError += "Please select Job Code.";
            }
            <% }%> 

            <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.ComponentCode.Mandatory"))  {%>  
            if ($("[id*=hidComponentCode]").val() == "") {
                alert("Please select Component Code.");
                strError += "Please select Component Code.";
            }
            <% }%> 
            //</CODE_TAG_105387>
            <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.CostCenterCode.Mandatory"))  {%>  //<!--CODE_TAG_104950-->
            if ($("#lstCostCenterCode").val() == "") {
                alert("Please select Cost Center.");
                strError += "Please select Cost Center.";
            }
            <% }%>  //<!--CODE_TAG_104950-->
            //<!--CODE_TAG_101936-->
            var lbCounter = 0;
            $.each($("input[id*=txtLaborItemNo]"), function (index, item) {
                if ((item.value == "") && (lbCounter == 0)) {
                    //alert("Please enter Labour Charge Code.");
                    //strError += "Please enter Labour Charge Code.";
                    //<Ticket 48439>
                    <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labour.ChargeCode"))  {%>
                    alert("Please select Labour Charge Code.");
                    strError += "Please select Labour Charge Code.";
                    <% } else {%>  
                    alert("Please enter Labour Item No.");
                    strError += "Please enter Labour Item No.";
                    <% }%>
                    //</Ticket 48439>
                    item.focus();
                    lbCounter = 1;
                }
            });

            lbCounter = 0;
            $.each($("input[id*=txtMiscItemNo]"), function (index, item) {
                if ((item.value == "") && (lbCounter == 0)) {
                    //alert("Please select Misc Charge Code.");
                    //strError += "Please select Misc Charge Code.";
                    //<Ticket 48439>
                    <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Misc.ChargeCode"))  {%>
                    alert("Please select Misc Charge Code.");
                    strError += "Please select Misc Charge Code.";
                    <% } else {%>  
                    alert("Please enter Miscellaneous Item No.");
                    strError += "Please enter Miscellaneous Item No.";
                    <% }%>
                    //</Ticket 48439>
                    item.focus();
                    lbCounter = 1;
                }
            });//<!--CODE_TAG_101936-->

 


            if (strError == "") {
                saveNote("ExternalNotes");
                saveNote("Instructions");

                $("#hidExternalNotes").val(ExternalNotesNotes);
                $("#hidExternalNotesMasterIndicators").val(ExternalNotesMasterIndicators);
                $("#hidInstructions").val(InstructionsNotes);

                if ($("#lstTotalFlatRate").length > 0){
                    $("#hidTotalFlatRateInd").val($("#lstTotalFlatRate").val() );
                    $("#hidTxtGrandTotal").val($("#txtGrandTotal").val() );
                }

                pageDataChanged = false;

                $("#spanSegmentWaitting").show();
                $("#spanSegmentWaitting img").attr("src", "../../Library/images/waiting.gif");
                //document.getElementById("btnSave").disabled = true; //<!--Ticket 48136-->
                return true;
            }
            else {
                document.getElementById("btnSave").disabled = false; //<!--Ticket 48136-->
                return false;
            }
        }

        $(function () {
            reloadCostCentreCode();
            $("#lstCostCenterCode").val($("#hidCostCentreCode").val());

            //reloadLaborChargeCode();//<!--CODE_TAG_101936-->
            //reloadMiscChargeCode();


            $j("#divRefreshAllParts").dialog({ width: 200,
                height: 100,
                draggable: true,
                position: 'center',
                resizable: false,
                modal: true,
                title: 'Refreshing Parts',
                autoOpen: false
            });

            $j("#divImportXMLDetail").dialog({ width: 800,
                    height: 400,
                    draggable: true,
                    position: 'center',
                    resizable: false,
                    modal: true,
                    title: 'Segment Pending Details',
                    autoOpen: false
                });

            if ('<%= RefreshParts %>' == '2') {
                //if (SourceTypeId == "4" ){   //Victor: Other source Type will do same thing in the future, already bring all parameters on the page
                //if (SourceTypeId == "4" || SourceTypeId == "3" ){   //<CODE_TAG_102198>
                if (SourceTypeId == "5" || SourceTypeId == "4" || SourceTypeId == "3" ){   //<CODE_TAG_102198>//<CODE_TAG_103560>
                   showStandardJobParts(); 
                }
                else{
                
                    $j("#divRefreshAllParts").dialog("open");
                    detailDataChanged = true; 
                    SegmentDetailAjaxHandler(0, 'RefreshAllPartsPriceAndAvailability');
                }
            }

            /* if ('<%= HasPendingLabor %>' == '2' || '<%= HasPendingMisc %>' == '2') {
                 var url = "Controls/ImportXMLDetails.aspx?segmentId=<%=SegmentId.ToString() %>"; */
            //<CODE_TAG_101832>
             if ('<%= HasPendingLabor %>' == '2' || '<%= HasPendingMisc %>' == '2'  || '<%=IsRepriceRequired%>' == '2' ) {
                 var url = "Controls/ImportXMLDetails.aspx?segmentId=<%=SegmentId.ToString() %>&IsRepriceRequired=<%=IsRepriceRequired %> ";
                $j("#iframeXMLDetail").attr("src", url);
                $j("#divImportXMLDetail").dialog("open");
            }//</CODE_TAG_101832>
        });

        function txtComponentCode_onkeyup()
        {
            if ($("[id*=txtComponentCode]").val().length < <%= AppContext.Current.AppSettings["psQuoter.Quote.Segment.Component.Search.MinCharacters"] %> ) {
                $("#divSearchbleList").hide();
                return;
            }

            //txtSearchbleListKeyUp('txtComponentCode', 'hidComponentCode', arrComponentCode,'txtOnlyComponentCode');
            txtSearchbleListKeyUp('txtComponentCode', 'hidComponentCode', arrComponentCode,'txtOnlyComponentCode', '~');//<CODE_TAG_103329>
        }
         
                               

    // ****************************************************************************************************************


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


        function refreshPage() {
            document.location.href = document.location.href;
        }
        function reloadPage(quoteId, revision, segmentId) {
            document.location.href = "<%=HttpContext.Current.Request.Url.AbsolutePath %>?QuoteId=" + quoteId + "&Revision=" + revision + "&SegmentId=" + segmentId + "&SegmentEdit=1";
        }

        var strJobCodeList = "<%=JobCodeList %>";
        var arrJobCode = strJobCodeList.split(String.fromCharCode(5));
        var strComponentCodeList = "<%=ComponentCodeList %>";
        var arrComponentCode = strComponentCodeList.split(String.fromCharCode(5));
        var strModifierCodeList = "<%=ModifierCodeList %>";
        var arrModifierCode = strModifierCodeList.split(String.fromCharCode(5));
        var strLaborChargeCodeList = "<%= LaborChargeCodeList %>";
        var arrLaborChargeCode = strLaborChargeCodeList.split(String.fromCharCode(5));
        var strMiscChargeCodeList = "<%= MiscChargeCodeList %>";
        var arrMiscChargeCode = strMiscChargeCodeList.split(String.fromCharCode(5));

        var strCostCentreCodeList = "<%= CostCentreCodeList %>";
        var arrCostCentreCode = strCostCentreCodeList.split(String.fromCharCode(5));


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

            reloadLaborChargeCode();
            reloadMiscChargeCode();


            //<CODE_TAG_101832>
//             
//                var url = "Controls/ImportXMLDetails.aspx?segmentId=<%=SegmentId.ToString() %>&IsRepriceRequired=<%=IsRepriceRequired %> ";
//                $j("#iframeXMLDetail").attr("src", url);
//                $j("#divImportXMLDetail").dialog("open");
            //</CODE_TAG_101832>
        }

//<Ticket 20479>.<!--CODE_TAG_101936-->
        function resetLabourChargeCode(element){
       //     $("input[id*=txtLaborItemNo]").val("");
       //     $("input[id*=hidLaborChargeCode]").val("");
       //     $("input[id*=txtLaborDescription]").val("");

            var arrLaborChargeCodeTemp = strLaborChargeCodeList.split(String.fromCharCode(5));
            var strLaborChargeCodeListTemp = "";
            var curStoreCode = $("#lstStoreCode").val();
            var curCostCode = $("#lstCostCenterCode").val();
            
            var storeCode= "";
            var costCode = "";
            $.each(arrLaborChargeCodeTemp, function (index, value) {
                    arrStr = value.split(",");
                    storeCode = arrStr[5];
                    costCode = arrStr[6];
                    //<Ticket 20479>
                    if ((storeCode == curStoreCode || curStoreCode == '' || storeCode == '<%=AppContext.Current.AppSettings["psQuoter.DBS.Store.Wildcard"] %>' ) && (costCode == curCostCode || curCostCode == '' || costCode == '<%=AppContext.Current.AppSettings["psQuoter.DBS.CSCC.Wildcard"] %>') )
                    {
                        if (strLaborChargeCodeListTemp != "") strLaborChargeCodeListTemp+= String.fromCharCode(5);
                        strLaborChargeCodeListTemp +=  arrStr;
                    }

             });

            //<Ticket 20479>
            //arrLaborChargeCode = strLaborChargeCodeListTemp.split(String.fromCharCode(5));
            var itemNo = "";
            $.each($("input[id*=txtLaborItemNo]"), function (index, item) {
                if (strLaborChargeCodeListTemp.indexOf(item.value) != -1) {
                    itemNo = item.value.replace("txtLaborItemNo", "");
                    $("input[id=txtLaborItemNo" + itemNo + "]").val("");
                    $("input[id=hidLaborChargeCode" + itemNo + "]").val("");
                    $("input[id=txtLaborDescription" + itemNo + "]").val("");
                }
            });
        }//</Ticket 20479>//<!--CODE_TAG_101936-->


        <% // <CODE_TAG_101452> %>
        function reloadLaborChargeCode() {
              <% if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labour.ChargeCodeFilterdByStoreCostCenter") )
              { %>
               // return; //<!--CODE_TAG_101936-->
            <% } %>
            
            getLabourChargeCode();
  
        }

        function reloadMiscChargeCode() {
              <% if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Misc.ChargeCodeFilterdByStoreCostCenter") )
              { %>
            //    return; 
            <% } %>
            getMiscChargeCode();
        }
         <% // </CODE_TAG_101452> %>
        //-------------------------------------------------------------------------------------------------
        function setupLaborChargeCode(itemId) {
            var arrStr;
            var strChargeCode, strChargeCodeDesc, strCRTR, strCOTR, strCPTR;
            var chargeCode = $.trim($("#hidLaborChargeCode" + itemId).val());
            var shiftValue = $.trim($("#lstLaborShift" + itemId).val());

            $.each(arrLaborChargeCode, function (index, value) {
                //strItemValue = value;
                arrStr = value.split(",");
                strChargeCode = $.trim(arrStr[0]);
                strChargeCodeDesc = $.trim(arrStr[1]);
                strChargeCodeDesc = $.trim(strChargeCodeDesc.replace(strChargeCode + '-','')) ;
                strCRTR = arrStr[2];
                strCOTR = arrStr[3];
                strCPTR = arrStr[4];
                //<CODE_TAG_105100> lwang
                //if (strChargeCode == chargeCode) {
                if (strChargeCode.substring(1,3) == chargeCode.substring(1,3)) {
                    //</CODE_TAG_105100> lwang
                    $("#txtLaborDescription" + itemId).val(strChargeCodeDesc);
                    switch (shiftValue) {
                        case "CRTR":
                            $("#txtLaborUnitSellPrice" + itemId).val(strCRTR);
                            $("#txtLaborUnitPrice" + itemId).val(strCRTR);
                            break;
                        case "COTR":
                            $("#txtLaborUnitSellPrice" + itemId).val(strCOTR);
                            $("#txtLaborUnitPrice" + itemId).val(strCOTR);
                            break;
                        default:
                            $("#txtLaborUnitSellPrice" + itemId).val(strCPTR);
                            $("#txtLaborUnitPrice" + itemId).val(strCPTR);

                    }
                    return false; //to exit the each loop when find the charge code from charge code list. //<CODE_TAG_102255>
                }
            });
            detailDataChanged = true;

            var lbCounter = 0;
            $.each($("input[id*=txtLaborItemNo]"), function (index, item) {
                if ((item.value == "")) {
                    lbCounter = 1;
                }
            });
            if (lbCounter != 1)
                SegmentDetailAjaxHandler(itemId, '', 'Labor');
        }
        function setupMiscChargeCode(itemId) {
            var arrStr;
            var strChargeCode, strChargeCodeDesc, strUnitPrice, strUnitCost, strPercentRate;
            var chargeCode = $("#hidMiscChargeCode" + itemId).val();

            $.each(arrMiscChargeCode, function (index, value) {
                //strItemValue = value;
                arrStr = value.split(",");
                strChargeCode = arrStr[0];
                strChargeCodeDesc = arrStr[1];
                strChargeCodeDesc = strChargeCodeDesc.replace(strChargeCode + '-', '');
                /*strUnitPrice = arrStr[2];
                strUnitCost = arrStr[3];*/
                //<Ticket 24754>
                //strUnitPrice = arrStr[2];
                //strUnitCost = arrStr[3];
                //</Ticket 24754>

                //<CODE_TAG_105045>
				<% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Misc.MiscUnitCostSwitch") )
				{ %>
                    strUnitPrice = arrStr[2];
                    strUnitCost = arrStr[3];
				<%}
				else
				{%>
                    strUnitPrice = arrStr[3];
                    strUnitCost = arrStr[2];
                <% } %>
                //<CODE_TAG_105045>

                strPercentRate = arrStr[4];

                //<CODE_TAG_105100> lwang
                //if (strChargeCode == chargeCode) {
                if (strChargeCode.substring(1,3) == chargeCode.substring(1,3)) {
                    //</CODE_TAG_105100> lwang
                    $("#txtMiscDescription" + itemId).val(strChargeCodeDesc);
                    $("#txtMiscUnitSellPrice" + itemId).val(strUnitPrice);
                    $("#txtMiscUnitPrice" + itemId).val(strUnitPrice);
                    $("#txtMiscUnitCostPrice" + itemId).val(strUnitCost);
                    $("#txtMiscUnitPercentRate" + itemId).val(strPercentRate);
                    $("#chkUnitPriceLock" + itemId).attr("checked", false);
                    
                    return false; //to exit the loop when find the charge code from charge code list.//<CODE_TAG_102255>

                }
            });
            detailDataChanged = true;
         
            SegmentDetailAjaxHandler(itemId, 'CALCULATEUNITPRICE', 'Misc');
        }

        //-------------------------------------------------------------------------------------------------

        var detailDataChanged = false;
        //var callBacking = false;
        //<CODE_TAG_103407>
        var callBacking_part = false; 
        var callBacking_labor = false;
        var callBacking_misc = false;
        //</CODE_TAG_103407>
        var partSerializedData = "";
        var laborSerializedData = "";
        var miscSerializedData = "";

        $(function () {
            partSerializedData = $("#divPartsList input[type!='button'], select").serialize();
            laborSerializedData = $("#divLaborList input[type!='button'], select").serialize();
            miscSerializedData = $("#divMiscList input[type!='button'], select").serialize();
        });
        
        //<CODE_TAG_105845> lwang
        function ApplyPartsDiscount()
        {
            var partsDiscount = $j("#txtPartDiscount1").val();
            if (partsDiscount =="" || partsDiscount=="undefined")
            {    
                alert("Please input ajustment number in the first part line price adjustment field.");
                return;
            }   
            else 
            {   
                if (confirm("Apply " + partsDiscount +"% ajustment to all parts?"))
                    SegmentDetailAjaxHandler(0,'RefreshAllPartsDiscount');
            }
        }
        //</CODE_TAG_105845> lwang

        //function SegmentDetailAjaxHandler(itemId, op, source, field ) {
        function SegmentDetailAjaxHandler(itemId, op, source, field, coreInd) {//<CODE_TAG_102268> 

            var addNewPartFlag = false;
            //<CODE_TAG_102284>
            var addNewMiscFlag = false;
            var addNewLaborFlag = false;
            //</CODE_TAG_102284>
            //<CODE_TAG_101986>
            /*if (op == "REFRESHCATPRICE")
            {
              //var txtPartNoName = "#txtPartNo" + itemId;
              var txtPartSOSName = "#txtPartSOS" + itemId;
              //if ($(txtPartNoName).val()=="" || $(txtPartSOSName).val()=="")
              if ($(txtPartSOSName).val()=="")
                    return;
                
            }*/
            //</CODE_TAG_101986>

            if (op == null || op == "") op = "CALCULATE";
            if (source == null || source == "") source = "Part";
            if (field == null || field == "") field = "UNKNOW";
            if (coreInd === null || coreInd =="") coreInd = 1;//<CODE_TAG_102268>
            
             if (field=="UnitPrice")
              {
                //if ($("#hdnPartsCount").val() == itemId)
                //if ($("#hdnPartsCount").val() == itemId && coreInd != 2)//<CODE_TAG_102268>
                   //addNewPartFlag = true;
                //<CODE_TAG_102284>
                if ($("#hdnPartsCount").val() == itemId && coreInd != 2 && source=="Part")
                   addNewPartFlag = true; //</CODE_TAG_102268>
                /*alert($("#hdnLaborCount").val());
                alert(itemId);
                alert(source);*/
                if ($("#hdnLaborCount").val() == itemId && source =="Labor")
                    addNewLaborFlag = true;

                if ($("#hdnMiscCount").val() == itemId && source =="Misc")
                    addNewMiscFlag = true;
                        
                //</CODE_TAG_102284>
              }
            
             if (source == "Part" && op == "ADD" && $("#hdnPartsCount").val() != "0")
             {
                addNewPart();
                replaceEnterKeyWithTab(); //<CODE_TAG_102203> 

                return;
             }


            if (op == "DELETE") {
                if (!confirm("Are you sure to delete this item?"))
                    return;
            }
            
            //if (callBacking == false && detailDataChanged) {
            //if (callBacking == false ) {
            if ( (source =="Part" && callBacking_part == false) || (source=="Labor" && callBacking_labor ==false ) || ( source == "Misc" && callBacking_misc == false)  ) {//<CODE_TAG_103407>
                
                if (itemId != null) {
                    var customerNo=""; 
                    if (CATAPICustomerNo != "")
                        customerNo = CATAPICustomerNo;
                    else
                        customerNo = $("#hdnCustomerNo").val();

                    
                    var branchNo = $("#hdnBranchNo").val();
                    //<CODE_TAG_102235>
                    <% if (!string.IsNullOrEmpty(curSegmentBranchNo)){  %>
                        branchNo = "<%=curSegmentBranchNo %>";
                    <%} %>
                    //</CODE_TAG_102235>
                    var division = $("#hdnDivision").val();

                    var serializedData;
                    
                    switch (source) {
                        case "Labor":
                        //!!<CODE_TAG_102284>
                            if (itemId > 0) {
                                if ($.trim($("#txtLaborItemNo" + itemId).val()) == "" && op != "DELETE") {
                                     return;
                                  }
                            }
                        //!!</CODE_TAG_102284>
                            serializedData = $("#divLaborList input[type!='button'], select").serialize();
                            //if (laborSerializedData == serializedData && !detailDataChanged) 
                            //return;  //no changes don't call back.
                            //<CODE_TAG_102284>
                            if (laborSerializedData == serializedData && !detailDataChanged) 
                            {
                                if (addNewLaborFlag) addNewLabor();
                                
                                return;  //no changes don't call back.
                            }
                            //</CODE_TAG_102284>
                            break;

                        case "Misc":
                        //!!<CODE_TAG_102284>
                            if (itemId > 0) {
                                if ($.trim($("#txtMiscItemNo" + itemId).val()) == "" && op != "DELETE") {
                                     return;
                                  }
                            }
                        //!!</CODE_TAG_102284>
                            serializedData = $("#divMiscList input[type!='button'], select").serialize();
                            //if (miscSerializedData == serializedData && !detailDataChanged) 
                            //return;  //no changes don't call back.
                            //<CODE_TAG_102284>
                            if (miscSerializedData == serializedData && !detailDataChanged) 
                            {
                                if (addNewMiscFlag) addNewMisc();
                                return;  //no changes don't call back.
                            }
                            //</CODE_TAG_102284>
                            break;

                        default:
                            if (itemId > 0) {
                                //if ($.trim($("#txtPartNo" + itemId).val()) == "" && op != "DELETE")
                                //return;
                                // <CODE_TAG_102277>
                                <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.PartNoEmptyAllowed")) { %>
                                    //if ($.trim($("#txtPartDescription" + itemId).val()) == "" && op != "DELETE") 
                                    if (($.trim($("#txtPartNo" + itemId).val()) == "" &&$.trim($("#txtPartDescription" + itemId).val()) == "") && op != "DELETE") 
                                        return;
                                <% } else { %>
                                    if ($.trim($("#txtPartNo" + itemId).val()) == "" && op != "DELETE")
                                        return;
                                    <% } %>
                                // <CODE_TAG_102277>

                            }
                            serializedData = $("#divPartsList input[type!='button'], select").serialize();
                            if (partSerializedData == serializedData && !detailDataChanged) {
                                if (addNewPartFlag) addNewPart();
                                return;  //no changes don't call back.
                            }
                            break;
                    }

                    //callBacking = true;
                    //<CODE_TAG_103407>
                    if ( source == "Part") callBacking_part = true;
                    if (source == "Labor") callBacking_labor = true;
                    if (source == "Misc") callBacking_misc = true;
                    //</CODE_TAG_103407>

                    //<CODE_TAG_105845> lwang
                    var PartDiscount = $j("#txtPartDiscount1").val();                    
                    if (op=="RefreshAllPartsDiscount" && PartDiscount == "")
                        return;
                    //</CODE_TAG_105845> lwang
                    
                    var request = $.ajax({
                        //url: "Controls/SegmentDetailAjaxHandler.ashx?ItemID=" + itemId + "&op=" + op + "&source=" + source + "&customerNo=" + customerNo + "&branchNo=" + branchNo + "&division=" + division + "&field=" + field,
                        url: "Controls/SegmentDetailAjaxHandler.ashx?ItemID=" + itemId + "&op=" + op + "&source=" + source + "&customerNo=" + customerNo + "&branchNo=" + branchNo + "&division=" + division + "&field=" + field + "&segmentId=<%=SegmentId.ToString() %>" + "&PartsDiscount=" + PartDiscount ,//<CODE_TAG_101832> //<CODE_TAG_105845> add PartDiscount
                        type: "POST",
                        data: serializedData,
                        cache: false,
                        async: true, //false
                        beforeSend: function () {
                        displayWaitingIcon(source)
                                      
                        },
                        complete: function () {
                            $("#spanLaborWaitting").hide();
                            $("#spanMiscWaitting").hide();
                            $("#spanPartsWaitting").hide();
                            $j("#divRefreshAllParts").dialog("close");                      
                        },
                        success: function (htmlContent) {
                            var currentFocusedControlId = typeof (document.activeElement) == "undefined" ? "" : document.activeElement.id;
                            var rtOp = htmlContent.substr(0, 1);  // R: Replace   A: Alert   P: Popup
                            htmlContent = htmlContent.substr(2);
                            

                                                            
                            if (rtOp == "R") {
                            
                                switch (source) {
                                    case "Labor":
                                        $("#divLaborList").html(htmlContent);
                                        laborSerializedData = $("#divLaborList input[type!='button'], select").serialize();

                                        $("[id^=txtLaborQuantity]").last().focus().select();//<CODE_TAG_102259>

                                        //if ($j("#hdnXMLMisc").val() != "") setTimeout("SegmentDetailAjaxHandler(0, 'IMPORTXML', 'Misc')",1000); ////comment out for <CODE_TAG_103453>
                                        //break;
                                        break;
                                    case "Misc":
                                        $("#divMiscList").html(htmlContent);
                                        miscSerializedData = $("#divMiscList input[type!='button'], select").serialize();
                                        $("[id^=txtMiscQuantity]").last().focus().select();//<CODE_TAG_102259>
                                        break;
                                    default:
                                        $("#divPartsList").html(htmlContent);
                                        partSerializedData = $("#divPartsList input[type!='button'], select").serialize();
                                      $("[id^=txtPartQuantity]").last().focus().select();//<CODE_TAG_102259>
                                      /*
                                         $("#txtPartSOS" + itemId).focus();
                                         $("#txtPartSOS" + itemId).select();  */

                                      }

                                calculateSegmentTotal();
                               

                                $("#" + currentFocusedControlId).focus();
                                $("#" + currentFocusedControlId).select();
                         
                                if (addNewPartFlag) addNewPart();

                            }
                            
                            if (rtOp == "A") {
                                alert(htmlContent);
                            }

                            if (rtOp == "P") {
                                switch (source) {
                                    case "Labor":

                                    case "Misc":

                                        break;
                                    default:
                                        $("#divPartsChoice").html(htmlContent);
                                        $j("#divPartsChoiceDialog").dialog("open");
                                        
                                }
                            }
                            if (rtOp == "E") {
                                switch (source) {
                                    case "Labor":
                                        break;
                                    case "Misc":
                                        break;
                                    default:
                                        eval(htmlContent);
                                }

                            }
                            _initPage();
                            //callBacking = false;
                            //<CODE_TAG_103407>
                            if ( source == "Part") callBacking_part = false;
                            if (source == "Labor") callBacking_labor = false;
                            if (source == "Misc") callBacking_misc = false; 
                            //</CODE_TAG_103407>
                            detailDataChanged = false;
                            pageDataChanged = true;

                            replaceEnterKeyWithTab(); //<CODE_TAG_102203>

                         
                        },
                        //error: function () { callBacking = false; }
                        //<CODE_TAG_103407>
                        error: function () 
                        { 
                            //<CODE_TAG_103407>
                            if ( source == "Part") callBacking_part = false;
                            if (source == "Labor") callBacking_labor = false;
                            if (source == "Misc") callBacking_misc = false; 
                            //</CODE_TAG_103407>
                        }
                        //</CODE_TAG_103407>


                    });
                }
            }
        }

     

        function displayWaitingIcon(source) {
            switch (source) {
                case "Labor":
                    $("#spanLaborWaitting").show();
                    $("#spanLaborWaitting img").attr("src", "../../Library/images/waiting.gif");
                    break;
                case "Misc":
                    $("#spanMiscWaitting").show();
                     setTimeout('$("#spanMiscWaitting img").attr("src", "../../Library/images/waiting.gif")',1000);
                    break;
                default:
                    $("#spanPartsWaitting").show();
                    setTimeout('document.getElementById("spanPartsWaittingImg").src = "../../Library/images/waiting.gif"', 1000);
                    
            }
        }


        function confirmDeleteCurrentSegment() {
            if (confirm("Are you sure to delete the current segment?")) {
                allowDataChangedWarning = false;
                return true;
            }
            else
                return false;
        }

        //-----------------------------------------------------------------------------------------------
        function leftMenuExchange(menuType) {
            if (menuType == "Large") {
                $("#leftMenuSmall").hide();
                $("#leftMenuLarge").show();
                $("#tdLeftMenuContainer").width(180);
                $("#leftPaneBox").width(180);
            }
            else {
                $("#leftMenuSmall").show();
                $("#leftMenuLarge").hide();
                $("#tdLeftMenuContainer").width(38);
                $("#leftPaneBox").width(38);
            }
        }
        //------------------------------------------------------------------------------------------------------------------
        $(function () {
            calculateSegmentTotal();
        });
        /*
        function lsttotalFlatRate_onChange() {
        if ($("#lstTotalFlatRate").val() == "Y")
        $("#txtTotalFlatRateAmount").show();
        else
        $("#txtTotalFlatRateAmount").hide();

        calculateSegmentTotal();
        }
        */

        function lockPartsTotal() {
            $("#chkPartsAutoCalculate").attr('checked', 'checked');
        }
        function lockLaborTotal() {
            $("#chkLaborAutoCalculate").attr('checked', 'checked');
        }
        function lockMiscTotal() {
            $("#chkMiscAutoCalculate").attr('checked', 'checked');
        }
        function calculateSegmentTotal() {
            
            var totalParts = parseFloat($("#hdnTotalParts").val());
            var totalLabor = parseFloat($("#hdnTotalLabor").val());
            var totalMisc = parseFloat($("#hdnTotalMisc").val());
            
            if (isNaN(totalParts)) {
                totalParts = 0;
            }
            if (isNaN(totalLabor)) {
                totalLabor = 0;
            }
            if (isNaN(totalMisc)) {
                totalMisc = 0;
            }
            
            var flatRateIndPart = $("#lstPartFlatRate").val();
            var flatRateIndLabor = $("#lstLaborFlatRate").val();
            var flatRateIndMisc = $("#lstMiscFlatRate").val();
            var flatRateIndTotal = $("#lstTotalFlatRate").val();

            var totalTotal = 0;

            var flatRateIndPartDesc = "";
            if (flatRateIndPart == "F") flatRateIndPartDesc = "<%=Consts.FlatRateFlag %>";
            if (flatRateIndPart == "E") flatRateIndPartDesc = "<%=Consts.EstimateFlag %>";

            var flatRateIndLaborDesc = "";
            if (flatRateIndLabor == "F") flatRateIndLaborDesc = "<%=Consts.FlatRateFlag %>";
            if (flatRateIndLabor == "E") flatRateIndLaborDesc = "<%=Consts.EstimateFlag %>";

            var flatRateIndMiscDesc = "";
            if (flatRateIndMisc == "F") flatRateIndMiscDesc = "<%=Consts.FlatRateFlag %>";
            if (flatRateIndMisc == "E") flatRateIndMiscDesc = "<%=Consts.EstimateFlag %>";

            var flatRateIndTotalDesc = "";
            if (flatRateIndMisc == "F" && flatRateIndLabor == "F" && flatRateIndMisc == "F") flatRateIndTotalDesc = "<%=Consts.FlatRateFlag %>";
            if (flatRateIndMisc == "E" && flatRateIndLabor == "E" && flatRateIndMisc == "E") flatRateIndTotalDesc = "<%=Consts.EstimateFlag %>";

            $("#spanTotalParts").html($.global.format(totalParts, "c") + flatRateIndPartDesc);            
            $("#spanTotalLabor").html($.global.format(totalLabor, "c") + flatRateIndLaborDesc);
            $("#spanTotalMisc").html($.global.format(totalMisc,"c") + flatRateIndMiscDesc);

            $("#spanTotalDetails").html( $.global.format(totalParts + totalLabor + totalMisc, "c"));
        }


        $(function () {

            $j("#divNewSegment").dialog({ width: 500,
                height: 400,
                draggable: true,
                position: 'center',
                resizable: false,
                modal: true,
                title: 'New Segment',
                autoOpen: false,
                close: function () { allowDataChangedWarning = true; }
            });
            $j("#divQuoteSegmentSearch").dialog({ width: 900,
                height: 600,
                draggable: true,
                position: 'center',
                resizable: false,
                modal: true,
                title: 'Quote Segment Search',
                autoOpen: false
            });

            $j("#divWOSegmentSearch").dialog({ width: 850,
                height: 600,
                draggable: true,
                position: 'center',
                resizable: false,
                modal: true,
                title: 'Workorder Segment Search',
                autoOpen: false
            });


            $j("#divStandardJobSearch").dialog({ width: 950,
                height: 600,
                draggable: true,
                position: 'center',
                resizable: false,
                modal: true,
                title: 'Standard Job Search',
                autoOpen: false
            });
            //<CODE_TAG_103560>
            $j("#divDBSPartDocumentsSearch").dialog({ width: 950,
                height: 600,
                draggable: true,
                position: 'center',
                resizable: false,
                modal: true,
                title: 'DBS Part Documents Search',
                autoOpen: false
            });
            //</CODE_TAG_103560>

            $j("#divSegmentCustomerSearch").dialog({ width: 600,
                height: 400,
                draggable: true,
                position: 'center',
                resizable: false,
                modal: true,
                title: 'Customer Search',
                autoOpen: false
            });

            $j("#divSegmentCustomer").dialog({ width: 400,
                height: 200,
                draggable: true,
                position: 'center',
                resizable: false,
                modal: true,
                title: 'Segment Customer',
                autoOpen: false
            });

        });

        //function newSegment_onClick() {
        function newSegment_onClick(importDBSDocumentPartsInd) {//<CODE_TAG_103600>
            if (importDBSDocumentPartsInd != 2) {//<CODE_TAG_103600>
                if (pageDataChanged) {
                    if (!confirm("This segment data is changed, Are you going to leave?"))
                    {
                        disableLeavingCheck(); 
                        return false;
                    }
                }
            }//<CODE_TAG_103600>
            //<!--CODE_TAG_101936-->
            var branch = $("#hdnBranchNo").val();//<CODE_TAG_103600> 
            allowDataChangedWarning = false; //  pageDataChanged = false;
            //$j("#iFrameNewSegment").attr("src", "./Controls/NewSegment.aspx?TT=iframe&branchNo=" + branch + "&quoteId=<%=QuoteId%>&revision=<%=Revision%>");
            $j("#iFrameNewSegment").attr("src", "./Controls/NewSegment.aspx?TT=iframe&branchNo=" + branch + "&quoteId=<%=QuoteId%>&revision=<%=Revision%>&importDBSDocumentPartsInd=" + importDBSDocumentPartsInd);//<CODE_TAG_103600>
            $j("#divNewSegment").dialog({ width: 950,
            height: 300,
            draggable: true,
            position: 'center',
            resizable: false,
            modal: true,
            title: 'Standard Job Search',
            //autoOpen: false, // <CODE_TAG_105180>
            autoOpen: false // <CODE_TAG_105180>
            });
            //<!--/CODE_TAG_101936-->
            $j("#divNewSegment").dialog("open");
            

        }



        function showQuoteSegmentSearch() {
            $j("#iFrameQuoteSegmentSearch").attr("src", "Controls/QuoteSegmentSearch.aspx?TT=iframe");
            $j("#divQuoteSegmentSearch").dialog("open");
        }

        function closeQuoteSegmentSearch() {
            $j("#divQuoteSegmentSearch").dialog("close");
        }

        function showWOSegmentSearch() {
            $j("#iFrameWOSegmentSearch").attr("src", "Controls/WOSegmentSearch.aspx?TT=iframe&searchType=1");
            $j("#divWOSegmentSearch").dialog("open");
        }

        function closeWOSegmentSearch() {
            $j("#divWOSegmentSearch").dialog("close");
        }

        function showStandardJobSearch() {
            $j("#iFrameStandardJobSearch").attr("src", "../RepairOption/RepairOptions_ByModel.aspx?TT=iframe&PageMode=AddSegments&Model=" + $("#hdnModel").val());
            $j("#divStandardJobSearch").dialog("open");
        }

        function closeStandardJobSearch() {
            $j("#divStandardJobSearch").dialog("close");
        }

        //<CODE_TAG_103560>
        //function showDBSPartDocumentsSearch() {
        //<CODE_TAG_103600>
        function showDBSPartDocumentsSearch(operation) {
            if (operation==null) operation="AddNewSegmentFromDBSPartDocument";
        //</CODE_TAG_103600>
            //$j("#iFrameDBSPartDocumentsSearch").attr("src", "Controls/DBSPartDocumentsSearch.aspx");
            //<CODE_TAG_103600>
            //var src =  "Controls/DBSPartDocumentsSearch.aspx?operation=" + operation;
            var src =  "Controls/DBSPartDocumentsSearch.aspx?QuoteId=" + "<%=QuoteId %>&Revision=" + "<%=Revision %>&segmentId=" + <%=SegmentId %>  +    "&BranchNo=" + "<%=curSegmentBranchNo %>&operation=" + operation ;
            $j("#iFrameDBSPartDocumentsSearch").attr("src",src);
            //</CODE_TAG_103600>
            $j("#divDBSPartDocumentsSearch").dialog("open");
        }
        //function closeDBSPartDocumentsSearch() {
        function closeDBSPartDocumentsSearch(reloadPageInd, selectedData) {//<CODE_TAG_103600>
            $j("#divDBSPartDocumentsSearch").dialog("close");
            //<CODE_TAG_103600> //reload page only when Import DBS Document Parts
            if (reloadPageInd ==2)
            {
                //location.reload();
                $("#hdnSelectedDocNos").val(selectedData);
                $("#btnImportFromDBSPartsDoc").click();
            }
            //<CODE_TAG_103600>
        }
        //</CODE_TAG_103560>

        //<CODE_TAG_103600>
        function setupDBSPartDocumentNo(DocNos)
        {
        
            $("#spanSegmentWaitting").show();
            $("#spanWaitting img").attr("src", "../../Library/images/waiting.gif");
            $("[id*=hidDBSPartDocumentIds]").val(DocNos);
            //$("#btnDBSPartDocumentsGetData").click();

        }
        //</CODE_TAG_103600>
        function showStandardJobParts() {
            var customerNo = "";
            if (CATAPICustomerNo != "")
                customerNo = CATAPICustomerNo;
            else
                customerNo = $("#hdnCustomerNo").val();

            var branchNo = $("#hdnBranchNo").val();
            //<CODE_TAG_102235>
            <% if (!string.IsNullOrEmpty(curSegmentBranchNo)){  %>
                branchNo = "<%=curSegmentBranchNo %>";
            <%} %>
            //</CODE_TAG_102235>
            var division = $("#hdnDivision").val();

            var rdurl = escape("ImportXMLParts.aspx?customerNo=" + customerNo +"&branchNo=" + branchNo + "&division=" + division + "&segmentId=<%=SegmentId%>");

            $j("#iframeXMLParts").attr("src", "Controls/waitingRedirect.aspx?RdURL=" + rdurl);
    
            $j("#divImportXMLParts").dialog("open");
        }

        function closeStandardJobParts() {
            $j("#divImportXMLParts").dialog("close");
        }

        function showSegmentCustomerSearch() {
            $j("#iFrameSegmentCustomerSearch").attr("src", "Controls/CustomerSearch.aspx?TT=iframe");
            $j("#divSegmentCustomerSearch").dialog("open");
        }

        function showSegmentCustomer() {
            $j("#iFrameSegmentCustomer").attr("src", "Controls/SegmentCustomer.aspx?TT=iframe&segmentId=<%=SegmentId%>");
            $j("#divSegmentCustomer").dialog("open");
            return false;
        }

        function closeSegmentCustomerSearch() {
            $j("#divSegmentCustomerSearch").dialog("close");
        }

        function closeSegmentCustomer() {
            $j("#divSegmentCustomer").dialog("close");
        }

        //*******************************************************************************************************************
        //<CODE_TAG_104819>
        var checkChangesEnabled = true;
        
        window.onbeforeunload = function (e) {
            if (checkChangesEnabled && pageDataChanged && allowDataChangedWarning && '2' == '<%= AppContext.Current.AppSettings["psQuoter.AllowDataChangedWarning"].AsString() %>') {
                event.returnValue= "The segment data is changed.";
                disableLeavingCheck();
            }
        }
        //</CODE_TAG_104819>
        window.onerror = function (msg, url, linenumber) {
            //alert('Error message: ' + msg + '\nURL: ' + url + '\nLine Number: ' + linenumber)
            return true;
        }

        function disableLeavingCheck() {
            checkChangesEnabled = false;
            setTimeout("enableLeavingCheck()", "1000");
        }

        function enableLeavingCheck() {
            checkChangesEnabled = true;
        }   

//*****************************************************************************************************************
        $(function () {
            displayNote("ExternalNotes");
            displayNote("Instructions");
            displayDetailCount();
        });


        

        function displayDetailCount() {
            //<CODE_TAG_103339>
            <%if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Notes.MultiLineEdit.Show")) { %>
            $("#spanDetailCountExternalNotes").html("(" + DetailCountExternalNotes + ")");
            $("#spanDetailCountInstructions").html("(" + DetailCountInstructions +")");
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
            //</CODE_TAG_103339>
            $("#spanDetailCountParts").html("(" + DetailCountParts +")");
            $("#spanDetailCountLabor").html("(" + DetailCountLabor +")");
            $("#spanDetailCountMisc").html("(" + DetailCountMisc +")");

        }



        function lstTotalFlatRate_onChange(){
           if ($("#lstTotalFlatRate").val() == "F")
           {
             $("#txtGrandTotal").show();
             $("#lblGrandTotal").hide();
           }
           else
           {
             $("#txtGrandTotal").hide();
             $("#lblGrandTotal").show();
           }
        }


        function RefreshSegmentCustomer()
        {
          var segmentId='<%=SegmentId%>';
          
            var str = CommonFunctionAjaxHandler("GETSEGMENTCUSTOMERSHTML","&segmentId=" + segmentId );
            $("#divSegmentCustomerDisplay").html(str);
            _initPage();
        }

        function importXMLDetail_Close()
        {
            $j("#divImportXMLDetail").dialog("close");
        }
        //<!--CODE_TAG_101936-->
        function getLabourChargeCode()
        {
               var STN1 = $("#lstStoreCode").val();
               var CSCC = $("#lstCostCenterCode").val();
               displayWaitingIcon("Labor");
               $.ajax({
                        url: "QuoteAjaxHandler.ashx?op=LABOURCHARGECODE&SegmentId=<%=SegmentId.ToString() %>&quoteId=<%=QuoteId%>&STN1=" + STN1 + "&CSCC=" + CSCC,
                        type: "GET",
                        cache: false,
                        async: true,
                        success: function (htmlContent) {
                            strLaborChargeCodeList = htmlContent;
                            arrLaborChargeCode = strLaborChargeCodeList.split(String.fromCharCode(5));    
                            $("#spanLaborWaitting").hide();
                            validateLaborCode();
                        }

               });
               
        }//<!--/CODE_TAG_101936-->
        function getMiscChargeCode()
        {
               var STN1 = $("#lstStoreCode").val();
               var CSCC = $("#lstCostCenterCode").val();
               displayWaitingIcon("Misc");
               $.ajax({
                        url: "QuoteAjaxHandler.ashx?op=MISCCHARGECODE&SegmentId=<%=SegmentId.ToString() %>&quoteId=<%=QuoteId%>&STN1=" + STN1 + "&CSCC=" + CSCC,
                        type: "GET",
                        cache: false,
                        async: true,
                        success: function (htmlContent) {
                            strMiscChargeCodeList = htmlContent;
                            arrMiscChargeCode = strMiscChargeCodeList.split(String.fromCharCode(5));    
                            $("#spanMiscWaitting").hide();
                            validateMiscCode();
                        }

             });                  
               
        }

        function validateLaborCode()
        {
            var itemNo = "";
            var fullItem = ""
            var startLocation = 0;
            var chargecode = "";
            var cscc = "";
            var stn1 = "";
            var lbcc = "";
            
            var flag_exist = false;
            //$.each($("input[id*=txtLaborItemNo]"), function (index, item) {
            $.each($("input[id*=hidLaborChargeCode]"), function (index, item) {
                fullItem = item.value.split("-");
                chargecode = $.trim(fullItem[0]);
                cscc = $.trim(fullItem[1]);
                stn1 = $.trim(fullItem[2]);
                lbcc = $.trim(fullItem[3]);
                startLocation = strLaborChargeCodeList.indexOf(chargecode);
                if (startLocation == -1) {
                    flag_exist = false;
                }
                else {
                    
                    if (strLaborChargeCodeList.substring(startLocation).split("-")[1] != cscc) 
                        flag_exist = false;
                    else
                        if (strLaborChargeCodeList.substring(startLocation).split("-")[2] != stn1) 
                             flag_exist = false;
                        else
                            if ($.trim(strLaborChargeCodeList.substring(startLocation).split(",")[0].split("-")[3]) != lbcc) 
                                flag_exist = false;
                            else
                                flag_exist = true;
                }
                
                if (flag_exist == false) {
                    //alert(item.id.replace("txtLaborItemNo", ""));
                    itemNo = item.id.replace("txtLaborItemNo", "");
                    $("input[id=txtLaborItemNo" + itemNo + "]").val("");
                    $("input[id=hidLaborChargeCode" + itemNo + "]").val("");
                    $("input[id=txtLaborDescription" + itemNo + "]").val("");
                }
            });
        }
        function validateMiscCode()
        {
            var itemNo = "";
            var fullItem = ""
            var startLocation = 0;
            var chargecode = "";
            var cscc = "";
            var stn1 = "";
            var lbcc = "";
            
            var flag_exist = false;
            $.each($("input[id*=hidMiscChargeCode]"), function (index, item) {
                fullItem = item.value.split("-");
                chargecode = $.trim(fullItem[0]);
                cscc = $.trim(fullItem[1]);
                stn1 = $.trim(fullItem[2]);
                lbcc = $.trim(fullItem[3]);
                startLocation = strMiscChargeCodeList.indexOf(chargecode);

                
                if (startLocation == -1) {
                    flag_exist = false;
                }
                else {
                    
                    if (strMiscChargeCodeList.substring(startLocation).split("-")[1] != cscc) 
                        flag_exist = false;
                    else
                        if (strMiscChargeCodeList.substring(startLocation).split("-")[2] != stn1) 
                             flag_exist = false;
                        else
                            if ($.trim(strMiscChargeCodeList.substring(startLocation).split(",")[0].split("-")[3]) != lbcc) 
                                flag_exist = false;
                            else
                                flag_exist = true;
                }
                
                if (flag_exist == false) {
                    //alert(item.id.replace("txtLaborItemNo", ""));
                    itemNo = item.id.replace("txtMiscItemNo", "");
                    $("input[id=txtMiscItemNo" + itemNo + "]").val("");
                    $("input[id=hidMiscChargeCode" + itemNo + "]").val("");
                    $("input[id=txtMiscDescription" + itemNo + "]").val("");
                }
            });
        }
//<CODE_TAG_102203>

        function replaceEnterKeyWithTab() {
                $("#bottomContainer input, select").bind("keydown", 
                    function() {
                        if (event.keyCode == 13) event.keyCode = 9;   }  );


        }

        replaceEnterKeyWithTab();
//</CODE_TAG_102203>

        //<CODE_TAG_103532>
        function ToNextField(txtBoxId)
        {
          var txtPartNoId = "txtPartNo" +  txtBoxId;
          txtSosId = "txtPartSOS" + txtBoxId;
          var lengthTxt = $("#" + txtSosId).val().length;
          //var txtSos = $("#" + txtBoxId);
          if (lengthTxt && lengthTxt>=3)
          {

            if ($("#" + txtPartNoId)) { $("#" + txtPartNoId).focus();}
  
          }

        }

        //</CODE_TAG_103532>

        //<CODE_TAG_103934>
        //
        function validateSegmentNo() {  //function to check if segment no duplicate
            var curSegNo = $("#txtSegmentNo").val();
            //<CODE_TAG_105326>R.Z
            if(curSegNo.indexOf('!') !== -1)
            {
                return "Segment No is invalid.";
            }
            //</CODE_TAG_105326>
            var curSegmentId = 0;
            <% if (SegmentId > 0) { %>
                curSegmentId = <%=SegmentId %>;
            <% } %>
            var hdnSegmentNoList = $("#hdnSegmentNoList").val();
            var arrSegmentNoList = hdnSegmentNoList.split(",");
            for (var i= 0; i< arrSegmentNoList.length; i++ ) {
                
                var segment = arrSegmentNoList[i].split("|");
                var segmentId = segment[0];
                var segmentNo = segment[1];
                if ( segmentNo == curSegNo &&  segmentId != curSegmentId) {
                    //return false; //duplicate segment no
                    return "Duplicate Segment No."; //<CODE_TAG_105326>R.Z
                    }
            }
           
            //return true;
            return "";//<CODE_TAG_105326>R.Z
        }

        //</CODE_TAG_103934>

        //<CODE_TAG_105120>
        function allowOnlyNumber(evt)
        {
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (charCode > 47 && charCode < 58 || charCode == 46)
                return true;
            return false;
        }
        //</CODE_TAG_105120>

        //<CODE_TAG_104932>
        $(document).ready(function() {

            $('[numberCheck="true"]').keypress(function (event) {
            
                return isNumber(event, this)

            });

        });


  
        // THE SCRIPT THAT CHECKS IF THE KEY PRESSED IS A NUMERIC OR DECIMAL VALUE.
        function isNumber(evt, element) {

            var charCode = (evt.which) ? evt.which : event.keyCode

            if (
                (charCode != 45 || $(element).val().indexOf('-') != -1) &&      // “-” CHECK MINUS, AND ONLY ONE.
                (charCode != 46 || $(element).val().indexOf('.') != -1) &&      // “.” CHECK DOT, AND ONLY ONE.
                (charCode < 48 || charCode > 57))
                return false;

            return true;
        }    


        //</CODE_TAG_104932>
    </script>
</asp:Content>
