<%@ Page Title="" Language="C#" MasterPageFile="~/Library/MasterPages/_base.master"
    EnableEventValidation="false" AutoEventWireup="true" CodeFile="Quote_AddNew.aspx.cs"
    Inherits="quoteAddNew" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMP" runat="Server">
    <div>
        <div class="ui-dialog-titlebar ui-widget-header ui-cornet-all ui-helper-clearfix">
            <table width="100%">
                <tr>
                    <td>
                        <span class="ui-dialog-title">Add Quote</span>
                    </td>
                    <td align="right">
                        <asp:Button ID="btnSave_Top" runat="server" Text="Save" OnClientClick="this.disabled = true;  return validation(this);"
                            OnClick="btnSave_Click" /><!--CODE_TAG_104920-->
                    </td>
                </tr>
            </table>
        </div>                          
        <div class="ui-dialog-content">
            <div class="quoteHeaderEdit">
                <fieldset>
                    <legend class="ui-accordion-header">&nbsp;Quote&nbsp;</legend>
                    <table id="tblQuoteHeader">

                        <tr>
                            <th>
                                Quote Type:<span style="color: red">*</span>
                            </th>
                            <td >
                                <asp:DropDownList ID="lstQuoteType" runat="server" onchange="setupNewOppDefaultValue();"
                                    ClientIDMode="Static">
                                </asp:DropDownList>
                                <asp:DropDownList ID="lstOppType" ClientIDMode="Static" runat="server" Style="display: none;">
                                </asp:DropDownList>
                            </td>
                            <th>
                                Branch:<span style="color: red">*</span>
                            </th>
                            <td>
                                <asp:DropDownList ID="lstBranch" ClientIDMode="Static" runat="server"  onchange="reloadCostCentreCode();">
                                </asp:DropDownList><!--CODE_TAG_101936-->
                            </td>
                            <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.EstimatedByName.Show"))
                               { %>
                            <th>
                                Estimated By
                            </th>
                            <td colspan="2"><!--CODE_TAG_101764-->
                                <asp:TextBox ID="txtEstimatedByName" MaxLength="20" Style="width: 98%" ClientIDMode="Static"
                                    runat="server"></asp:TextBox>
                            </td>
                            <%} %>
                            <%--<CODE_TAG_105235> lwang--%>
                            <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.StageType.Show"))
                               { %>
                            <td></td>
                            <th>
                                Type:
                            </th>
                            <td >
                                <asp:DropDownList ID="lstQuoteStageType" runat="server" 
                                    ClientIDMode="Static">
                                </asp:DropDownList>
                            </td>
                            <%} %>
                            <%--</CODE_TAG_105235> lwang--%>
                        </tr>
                        <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.Description.Show"))
                           { %>
                        <tr>

                            <th>
                                Description:

                                 <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.Description.Required"))
                           { %>
                                
                                <span style="color: red">*</span>
                                  <%} %>
                            </th>
                            <td colspan="10">
                                <asp:TextBox ID="txtDescription" MaxLength="300" Style="width: 98%" ClientIDMode="Static"
                                    runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <%} %>
                        <tr>
                            <th>
                               Owner:<span style="color: red">*</span>
                            </th>
                            <td>

                            <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.Owner.Editable"))
                               {  %>
                                <asp:DropDownList ID="lstSalesRep" ClientIDMode="Static" onchange="lstSalesRep_onChange();" runat="server">
                                </asp:DropDownList>
                                <%}
                               else
                               { %>
                                <asp:Label ID="lblSalesRep" runat="server" ></asp:Label>
                                <%} %>
                            </td>
                            <th>
                                Office Phone No:
                            </th>
                            <td>
                                <asp:TextBox ID="txtSalesrepPhone" ClientIDMode="Static"  MaxLength="60" runat="server"></asp:TextBox>
                            </td>
                            <th>
                                Mobile Phone No:
                            </th>
                            <td>
                               <asp:TextBox ID="txtSalesrepCellPhone" ClientIDMode="Static" MaxLength="60" runat="server" CssClass="fe75"></asp:TextBox><!--CODE_TAG_101764-->
                            </td>
                            <th>
                               Fax No:
                            </th>
                            <td>
                                <asp:TextBox ID="txtSalesrepFax" ClientIDMode="Static" MaxLength="60" runat="server"  CssClass="fe75"></asp:TextBox><!--CODE_TAG_101764-->
                            </td>
                            <th>
                                Estimated Repair Time:
                            </th>
                            <td>
                                <asp:TextBox ID="txtEstimatedRepairTime" MaxLength="50" runat="server"  CssClass="fe75"></asp:TextBox><!--CODE_TAG_101764-->
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Promise Date:
                            </th>
                            <td nowrap>
                                <asp:TextBox ClientIDMode="Static" runat="server" ID="txtPromiseDate" CssClass="fe75" /><!--CODE_TAG_101764-->
                                 <img onclick="$('#txtPromiseDate').val('');" src="../../../library/images/icon_x.gif" />
                            </td>
                            <th>
                                Unit to Arrive Date:
                            </th>
                            <td nowrap>
                             
                                <asp:TextBox ClientIDMode="Static" runat="server" ID="txtUnittoArriveDate" CssClass="fe75"
                                     /><!--CODE_TAG_101764-->
                                <img onclick="$('#txtUnittoArriveDate').val('');" src="../../../library/images/icon_x.gif" />
                            </td>
                            <th>
                                Planned Indicator:
                            </th>
                            <td>
                                <asp:DropDownList ID="lstPlannedIndicator" runat="server">
                                </asp:DropDownList>
                            </td>
                            <th>
                                Urgency Indicator:
                            </th>
                            <td>
                                <asp:DropDownList ID="lstUrgencyIndicator" runat="server">
                                </asp:DropDownList>
                            </td>
                            <th>
                                Job Control Code:
                                <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.JobControlCode.Required"))
                           { %>
                                
                                <span style="color: red">*</span>
                                  <%} %>
                            </th>
                            <td>
                                <asp:TextBox runat="server" ID="txtJobControlCode" MaxLength="2" CssClass="fe" Width="60%"
                                    ClientIDMode="Static" />
                            </td>
                        </tr>
                        <!--CODE_TAG_101731-->
                        <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.Comment.Show")) {%>
                        <tr>
                            <th style="vertical-align:top">Comments:</th>
                            <td colspan="10" width="100%">
                                <asp:TextBox ID="txtComents"  Style="width:98%"   runat="server" ClientIDMode="Static" Height="50" TextMode="MultiLine"></asp:TextBox>
                            </td>
                        </tr>
                        <% } %>
                        <!--/<CODE_TAG_101731>-->

 
     
                    </table>
                </fieldset>
                
                <fieldset>
                    <legend>&nbsp;Customer&nbsp;</legend>
                    <table id="tblCustomer">
                        <tr>
                            <th>
                                Customer No:<span style="color: red">*</span>
                            </th>
                            <td colspan="3">
                                <img id="ibtnCustomerSearch" src="../../library/images/magnifier.gif" onclick="showCustomerSearch();" class='imgBtn' />
                                <asp:Label ID="lblCustomer" runat="server"></asp:Label>
                                <asp:HiddenField ID="hidCustomerNo" ClientIDMode="static" Value="" runat="server" />
                                <asp:HiddenField ID="hidWONO" ClientIDMode="static" Value="" runat="server" />
                                <asp:HiddenField ID="hidCustomerName" ClientIDMode="static" Value="" runat="server" />
                                <!--CODE_TAG_104784-->
                                <asp:Label ID="lblCustomerLoyaltyIndicator" runat="server" ClientIDMode="static" Visible="true"  ForeColor="White" style="padding:3px"></asp:Label>
                                <asp:HiddenField ID="hidCustomerLoyaltyIndicator" ClientIDMode="Static" Value="" runat="server" />
                                <!--/CODE_TAG_104784-->
                            </td>
                            <th>
                                Division:<span style="color: red">*</span>
                            </th>
                            <td>
                                <asp:DropDownList ID="lstDivision" runat="server" onchange="lstDivision_onChange();"
                                    ClientIDMode="Static">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Contact:
                            </th>
                            <td>
                                <asp:DropDownList ID="lstContact" ClientIDMode="static" onchange="lstContact_onChange();"
                                    runat="server">
                                </asp:DropDownList>
                                <asp:TextBox ID="txtContact" MaxLength="30" ClientIDMode="static" runat="server"
                                    Style="display: none"></asp:TextBox>
                                <asp:CheckBox ID="chkNewContact" ClientIDMode="static" onclick="chkNewContact_onChange();"
                                    Text="New Contact" runat="server" />
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <th>
                                Phone No:
                            </th>
                            <td>
                                <asp:TextBox ID="txtPhoneNo" MaxLength="20" runat="server" ClientIDMode="static"></asp:TextBox>		<%//<CODE_TAG_103503> Dav: Change MaxLength%>
                            </td>
                            <th>
                                PO:
                            </th>
                            <td>
                                <asp:TextBox ID="txtPO" MaxLength="20" runat="server" ClientIDMode="static"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Email:
                            </th>
                            <td colspan="3">
                                <asp:TextBox ID="txtEmail" MaxLength="200" Style="width: 95%" ClientIDMode="static"
                                    runat="server"></asp:TextBox>
                            </td>
                            <th>
                                Fax No:
                            </th>
                            <td>
                                <asp:TextBox ID="txtFax" MaxLength="200" ClientIDMode="static" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                </fieldset>
                <fieldset>
                    <legend>&nbsp;Equipment&nbsp;</legend>
                    <table id="tblEquipment">
                        <tr>
                            <th>
                                Make:
                            </th>
                            <td>
                                <asp:DropDownList ID="lstMake" runat="server" Style="width: 300px" ClientIDMode="Static">
                                </asp:DropDownList>
                            </td>
                            <th>
                                Serial No:
                            </th>
                            <td>
                                <asp:TextBox ID="txtSerialNo" MaxLength="25" runat="server" ClientIDMode="Static"></asp:TextBox>		<%//<CODE_TAG_103503> Dav: Change MaxLength%>
                            </td>
                            <th>
                                Model:
                            </th>
                            <td>
                                <asp:TextBox ID="txtModel" MaxLength="10" runat="Server" ClientIDMode="Static"></asp:TextBox>
                            </td>
                            <th>
                                Stock No:
                            </th>
                            <td>
                                <asp:TextBox ID="txtStockNo" MaxLength="9" runat="Server" ClientIDMode="Static"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Unit No:
                            </th>
                            <td>
                                <asp:TextBox ID="txtUnitNo" MaxLength="9" runat="server" ClientIDMode="Static"></asp:TextBox>
                            </td>
                            <th>
                                SMU:
                            </th>
                            <td nowrap>
                                <asp:TextBox ID="txtSMU" CssClass="tAr numbersOnly" MaxLength="10" runat="server"
                                    ClientIDMode="Static" Width="50%"></asp:TextBox>
                                <asp:DropDownList ID="lstSMUIndicator" ClientIDMode="Static" runat="server" />
                            </td>
                            <th>
                                SMU Date:
                            </th>
                            <td nowrap>
                                <asp:TextBox ClientIDMode="Static" runat="server" ID="txtSMULastRead" CssClass="fe"
                                    Width="60%" />
                                 <img onclick="$('#txtSMULastRead').val('');" src="../../../library/images/icon_x.gif" />
                            </td>
                            <th>
                                
                                <asp:Label ID="lblLastSMUValueTitle" runat="server" Text="Last Known SMU:"></asp:Label> 
                            </th>
                            <td>
                                <asp:Label ID="lblLastSMUValue" runat="server" ClientIDMode="Static"  Text=""></asp:Label> 
                                <asp:HiddenField ID="hidLastTimeSMUValue" runat="server" ClientIDMode="Static"  />
                                <asp:HiddenField ID="hidLastTimeSMUIndicator" runat="server" ClientIDMode="Static"  />
                                <asp:HiddenField ID="hidLastTimeSMUDate" runat="server" ClientIDMode="Static"  />
                            </td>

                        </tr>
                        <tr>
                        <!--CODE_TAG_104881-->
                        <%if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.CabType.Show"))
                         { %>
                            <th>Cab Type</th> <!-- <CODE_TAG_101768> -->
                            <td><asp:DropDownList ID="lstCabTypeCode" Width="150px" onchange="chkNewContact_onChange();" runat="server" ClientIDMode="Static">
                        </asp:DropDownList></td>
                        <%} %>
                        <!--/CODE_TAG_104881-->
                        </tr>
                    </table>
                </fieldset>

                <fieldset>
                    <legend>&nbsp;Opportunity&nbsp;
                        <asp:RadioButtonList ID="rdbtnOpportunity" runat="server" RepeatDirection="Horizontal"
                            RepeatLayout="Flow">
                            <asp:ListItem Value="2" Text="Yes" onclick="HasOpportunity(this.value);"></asp:ListItem>
                            <asp:ListItem Value="1" Text="No" onclick="HasOpportunity(this.value);"></asp:ListItem>
                        </asp:RadioButtonList>
                    </legend>
                    <table id="tblNoOpportunity">
                        <tr>
                            <td class="fe">
                                No Opportunity.
                            </td>
                        </tr>
                    </table>
                    <table id="tblHasOpportunity">
                        <tr>
                            <td colspan="8">
                                <asp:RadioButtonList ID="rdbtnNewOrExistingOpportunity" runat="server" RepeatDirection="Horizontal"
                                    RepeatLayout="Flow" ClientIDMode="Static">
                                    <asp:ListItem Value="1" Text="New" onclick="NewOrExistingOpportunity(this.value);"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Existing" onclick="NewOrExistingOpportunity(this.value);"></asp:ListItem>
                                </asp:RadioButtonList>
                                <asp:DropDownList ID="lstOppList" runat="server" Style="display: none" onchange="setupExistingOppValue();"
                                    ClientIDMode="static">
                                </asp:DropDownList>
                                <span id="lblOppNo" ></span>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Est. Delivery:<span style="color: red">*</span>
                            </th>
                            <td>
                                <asp:DropDownList ID="lstEstDeliveryYear" runat="server" ClientIDMode="Static">
                                    <%--//<CODE_TAG_105426> lwang
                                    <asp:ListItem Text="" Value=""></asp:ListItem>
                                    <asp:ListItem Text="2016" Value="2016"></asp:ListItem>
                                    <asp:ListItem Text="2015" Value="2015"></asp:ListItem>
                                    <asp:ListItem Text="2014" Value="2014"></asp:ListItem>
                                    <asp:ListItem Text="2013" Value="2013"></asp:ListItem>
                                    <asp:ListItem Text="2012" Value="2012"></asp:ListItem>
                                    <asp:ListItem Text="2011" Value="2011"></asp:ListItem>
                                    <asp:ListItem Text="2010" Value="2010"></asp:ListItem>
                                    <asp:ListItem Text="2009" Value="2009"></asp:ListItem>
                                    <asp:ListItem Text="2008" Value="2008"></asp:ListItem>
                                    <asp:ListItem Text="2007" Value="2007"></asp:ListItem>
                                    <asp:ListItem Text="2006" Value="2006"></asp:ListItem>
                                    //</CODE_TAG_105426> lwang--%>
                                </asp:DropDownList>
                                <asp:DropDownList ID="lstEstDeliveryMonth" runat="server" ClientIDMode="Static">
                                    <asp:ListItem Text="" Value=""></asp:ListItem>
                                    <asp:ListItem Text="January" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="February" Value="2"></asp:ListItem>
                                    <asp:ListItem Text="March" Value="3"></asp:ListItem>
                                    <asp:ListItem Text="April" Value="4"></asp:ListItem>
                                    <asp:ListItem Text="May" Value="5"></asp:ListItem>
                                    <asp:ListItem Text="June" Value="6"></asp:ListItem>
                                    <asp:ListItem Text="July" Value="7"></asp:ListItem>
                                    <asp:ListItem Text="August" Value="8"></asp:ListItem>
                                    <asp:ListItem Text="September" Value="9"></asp:ListItem>
                                    <asp:ListItem Text="October" Value="10"></asp:ListItem>
                                    <asp:ListItem Text="November" Value="11"></asp:ListItem>
                                    <asp:ListItem Text="December" Value="12"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <th>
                                Probability Of Closing:<span style="color: red">*</span>
                            </th>
                            <td>
                                <asp:RadioButton ID="rdoLow" Text="Low" GroupName="Probablity" ClientIDMode="Static"
                                    runat="server" />
                                <asp:RadioButton ID="rdoMedium" Text="Medium" GroupName="Probablity" ClientIDMode="Static"
                                    runat="server" />
                                <asp:RadioButton ID="rdoHigh" Text="High" GroupName="Probablity" ClientIDMode="Static"
                                    runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <th class="tVt">
                                Commodity:
                                 <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Opportunity.Commodity.Mandatory"))
                             { %>
                          
                        <span style="color:red">*</span>
                        <% } %>
                            </th>
                            <td class="tVt">
                                <asp:DropDownList ID="lstCommodity" runat="server" ClientIDMode="Static">
                                </asp:DropDownList>
                            </td>
                            <th class="tVt">
                                Source:<span style="color: red">*</span>
                            </th>
                            <td class="tVt" colspan="3" nowrap>
                                <asp:DropDownList ID="lstSource" ClientIDMode="Static" onchange="lstSource_onChange();" runat="server"></asp:DropDownList>
                                <asp:DropDownList ID="lstCampaign" ClientIDMode="Static" runat="server" Style="display: none;" onchange="lstCampaign_onchange();"></asp:DropDownList><!--CODE_TAG_103933-->
                                <asp:HiddenField ID="hdnlstCampaignSelected" ClientIDMode="Static" Value="" runat="server"  /><!--CODE_TAG_103933-->
                            </td>
                        </tr>
                    </table>
                </fieldset>
                <fieldset>
                    <legend>&nbsp;Segments&nbsp;</legend>
                    <div id="divSegment">
                        <iframe id="iFrameNewSegment" name="iFrameNewSegment" width="100%" frameborder="0"
                            onload="resizeIframe(this.name);"></iframe>
                    </div>
                </fieldset>
                <asp:HiddenField ID="hidRefreshParent" Value="" runat="server" />
                <asp:HiddenField ID="hdnInfList" Value="" ClientIDMode="Static" runat="server" />
                <asp:HiddenField ID="hdnCommodityList" Value="" ClientIDMode="Static" runat="server" />
                <asp:HiddenField ID="hdnCampaignList" Value="" ClientIDMode="Static" runat="server" />
                <asp:HiddenField ID="hdnOppReasonList" Value="" ClientIDMode="Static" runat="server" />
                <asp:HiddenField ID="hdnOppNo" Value="" ClientIDMode="Static" runat="server" />
                <asp:HiddenField ID="hdnNewSegmentSourceType" Value="" ClientIDMode="Static" runat="server" />
                <asp:HiddenField ID="hdnNewSegmentData" Value="" ClientIDMode="Static" runat="server" />
                <asp:HiddenField ID="hdnNewOppDefaultValue" Value="" ClientIDMode="Static" runat="server" />
                <asp:HiddenField ID="hidSelectContact" Value="" ClientIDMode="Static" runat="server" />
                <asp:HiddenField ID="hidDivision" Value="" ClientIDMode="Static" runat="server" />
                <asp:HiddenField ID="hdnCreateFromOppNo" Value="" ClientIDMode="Static" runat="server" />
                <asp:HiddenField ID="hidSelectedCommodityId" Value="" ClientIDMode="Static" runat="server" />  <%-- <CODE_TAG_101544>--%>
                <asp:HiddenField ID="hidCopyNotes" Value="1" ClientIDMode="Static" runat="server" />
                <asp:HiddenField ID="hidStageType" Value="" ClientIDMode="Static" runat="server" />         <%--<CODE_TAG_105235> lwang--%>

            </div>
            <div id="divCustomerSearch">
                <iframe id="iFrameCustomerSearch" src="" width="100%" height="100%" frameborder="0">
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
                <iframe id="iFrameStandardJobSearch" src="" width="100%" height="100%" frameborder="0">
                </iframe>
            </div>
            <!--CODE_TAG_103973-->
            <div id="divDBSPartDocumentsSearch">
                <iframe id="iFrameDBSPartDocumentsSearch" src="" width="100%" height="100%" frameborder="0" >
                </iframe>
            </div>
            <!--/CODE_TAG_103973-->
        </div>

        <span id="spanWaitting" style='position: absolute;top:40%;left:50%; display:none'><img id="spanWaittingImg" src='' /></span>

        <div class="ui-dialog-titlebar ui-widget-header ui-cornet-all ui-helper-clearfix">
            <table width="100%">
                <tr>
                    <td align="right">
                        <asp:Button ID="btnSave_Bottom" runat="server" Text="Save" OnClientClick="this.disabled = true; return validation(this);"
                            OnClick="btnSave_Click" /><!--CODE_TAG_104920-->
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <script type="text/javascript">
        var curQuoteEditMode = "ADDNEW";
        var RedirectURL = "<%= RedirectURL %>";
        var RefreshParent = "<%= RefreshParent %>";
        var QuoteNo = "<%= QuoteNo %>";
        var DisplayLastSMU = '<%= AppContext.Current.AppSettings["psQuoter.Header.SMU.LastTimeValue.Display"].ToString() %>';
        var NewQuoteFromOpp = 0;   // 0:No 2:Yes
        //<!--CODE_TAG_101936-->
        var strCostCentreCodeList = "<%= CostCentreCodeList %>";
        var arrCostCentreCode = strCostCentreCodeList.split(String.fromCharCode(5));
        //<!--/CODE_TAG_101936-->
        //<CODE_TAG_104057>
        var rowDelimiter = "<%=  Helpers.DataDelimiter.MatrixDataDelimeter.influencer_RowDelimiter %>";
        var colDelimiter = "<%= Helpers.DataDelimiter.MatrixDataDelimeter.influencer_ColumnDelimiter %>";
        //</CODE_TAG_104057>
        // General ******************************************************************************************************************
        $(function () {
            if (RefreshParent != "") {
                if (window.opener)      //window.opener.document.all["txtQuoteNo"].value = QuoteNo;
                    $("[id*=txtQuoteNo]").val(QuoteNo);  //<CODE_TAG_103547>
            }

            if (RedirectURL != "")
                document.location = RedirectURL;

            $("#txtPromiseDate").attr("readonly", true);
            $("#txtUnittoArriveDate").attr("readonly", true);
            $("#txtSMULastRead").attr("readonly", true);
            $("#accordion").accordion();
            $("#accordion").addClass("ui-accordion ui-accordion-icons ui-widget ui-helper-reset")


            $j("#divQuoteSegmentSearch").dialog({
                width: 900,
                height: 600,
                draggable: true,
                position: 'center',
                resizable: false,
                modal: true,
                title: 'Quote Segment Search',
                autoOpen: false
            });
            $j("#divWOSegmentSearch").dialog({
                width: 900,
                height: 600,
                draggable: true,
                position: 'center',
                resizable: false,
                modal: true,
                title: 'Workorder Segment Search',
                autoOpen: false
            });
            $j("#divStandardJobSearch").dialog({
                width: 950,
                height: 600,
                draggable: true,
                position: 'center',
                resizable: false,
                modal: true,
                title: 'Standard Job Search',
                autoOpen: false
            });

            //<CODE_TAG_103973>
            $j("#divDBSPartDocumentsSearch").dialog({
                width: 950,
                height: 600,
                draggable: true,
                position: 'center',
                resizable: false,
                modal: true,
                title: 'DBS Part Documents Search',
                autoOpen: false
            });
            //</CODE_TAG_103973>

            $j("#divCustomerSearch").dialog({
                width: 970,
                height: 600,
                draggable: true,
                position: 'center',
                resizable: false,
                modal: true,
                title: 'Customer Search',
                autoOpen: false
            });


            setupNewOppDefaultValue();
            <%if(bHasOpportunity_Default)
              {%>
            HasOpportunity(2);
            <%
              }else
              {%>
            HasOpportunity(1);
            <%
              }%>


            //$j("#iFrameNewSegment").attr("src", "./controls/NewSegment.aspx?TT=iframe&&Mode=NewQuote&DBSROId=<% =DBSROId %>&DBSROPId=<% =DBSROPId %>&DBSROSelectedGroup=<%=DBSROSelectedGroup %>&copyfrom=<% =CopyFrom  %>&partsAmount=<% =PartsAmount  %>&laborAmount=<% =LaborAmount  %>&miscAmount=<% =MiscAmount  %>&laborHours=<%= LaborHours  %>&Make=<% =Make  %>&SerialNo=<% =SerialNo  %>&Model=<% =Model  %>&JobCode=<% =JobCode  %>&ComponentCode=<% =ComponentCode  %>&ModifierCode=<% =ModifierCode  %>&BusinessGroupCode=<% =BusinessGroupCode  %>&QuantityCode=<% =QuantityCode  %>&WorkApplicationCode=<% =WorkApplicationCode  %>&branchNo=" + $("#lstBranch").val() + "&CostCentreCode=<% =CostCentreCode  %>&CabTypeCode=<% =CabTypeCode  %>&ShopField=<% =ShopField  %>&JobLocationCode=<% =JobLocationCode  %>&SType=<% =sType  %>");
            $j("#iFrameNewSegment").attr("src", "./controls/NewSegment.aspx?TT=iframe&&Mode=NewQuote&DBSROId=<% =DBSROId %>&DBSROPId=<% =DBSROPId %>&DBSROSelectedGroup=<%=Server.UrlEncode(DBSROSelectedGroup) %>&copyfrom=<% =CopyFrom  %>&partsAmount=<% =PartsAmount  %>&laborAmount=<% =LaborAmount  %>&miscAmount=<% =MiscAmount  %>&laborHours=<%= LaborHours  %>&Make=<% =Make  %>&SerialNo=<% =SerialNo  %>&Model=<% =Model  %>&JobCode=<% =JobCode  %>&ComponentCode=<% =ComponentCode  %>&ModifierCode=<% =ModifierCode  %>&BusinessGroupCode=<% =BusinessGroupCode  %>&QuantityCode=<% =QuantityCode  %>&WorkApplicationCode=<% =WorkApplicationCode  %>&branchNo=" + $("#lstBranch").val() + "&CostCentreCode=<% =CostCentreCode  %>&CabTypeCode=<% =CabTypeCode  %>&ShopField=<% =ShopField  %>&JobLocationCode=<% =JobLocationCode  %>&SType=<% =sType  %>");


            if ($("#hdnCreateFromOppNo").val() != "")
                setupCreateFromOppInfo();

            $("#txtPromiseDate").datepicker({ dateFormat: "M d, yy", showOn: "button", buttonImage: "../../library/images/Calendar_scheduleHS.gif", buttonImageOnly: true });
            $("#txtUnittoArriveDate").datepicker({ dateFormat: "M d, yy", showOn: "button", buttonImage: "../../library/images/Calendar_scheduleHS.gif", buttonImageOnly: true });
            $("#txtSMULastRead").datepicker({ dateFormat: "M d, yy", showOn: "button", buttonImage: "../../library/images/Calendar_scheduleHS.gif", buttonImageOnly: true });




        });

        function HasOpportunity(selectedValue) {
            if (selectedValue == 2) { // has Opportunity
                $("#tblHasOpportunity").show();
                $("#tblNoOpportunity").hide();
            } else {
                $("#tblHasOpportunity").hide();
                $("#tblNoOpportunity").show();
            }
        }

        function NewOrExistingOpportunity(selectedValue) {
            if (selectedValue == 1) { // New Opportunity
                //$("#tblHasOpportunity").show();
                //$("#tblNoOpportunity").hide();
                setupNewOppDefaultValue();
                $("#lstOppList").hide();
            } else { // Existing Opportunity
                //$("#tblHasOpportunity").hide();
                //$("#tblNoOpportunity").show();
                $("#lstOppList").show();
                getExistingOpplist();
            }

        }

        function resizeIframe(iframeName) {
            var obj = document.getElementById(iframeName);

            if (obj) {
                obj.style.height = parseInt(obj.contentDocument.body.scrollHeight) + 10 + "px";
            }
        }

        function setupDeliveryDate(sender, args) {
            var selectedDate = sender.get_selectedDate();
            var month = selectedDate.getMonth() + 1;
            var year = selectedDate.getFullYear();

            $("#lstEstDeliveryYear").val(year);
            $("#lstEstDeliveryMonth").val(month);
        }







        //function validation() {
        function validation(curButton) {
            var errorCount = 0;
            //get segment data from iframe window
            var iFSegment = frames['iFrameNewSegment'];

            $("#hdnNewSegmentSourceType").val(iFSegment.GetNewSegmentSourceType()); //1: Manual  2: copy from Quote  3: copy from workorder 4: copy from standardjob 5: Copy from DBS Part Documents
            $("#hdnNewSegmentData").val(iFSegment.GetNewSegmentData());
            $("#hidCopyNotes").val(iFSegment.GetCopyNotes());

            // validation
            if ($("#lstQuoteType").val() == "") {
                alert("Please select quote type.");
                $("#lstQuoteType").focus();
                errorCount++;
                curButton.disabled = false; //<CODE_TAG_104920>
                return false;
            }

            if ($("#lstBranch").val() == "") {
                alert("Please select a branch.");
                $("#lstBranch").focus();
                errorCount++;
                curButton.disabled = false; //<CODE_TAG_104920>
                return false;
            }

            <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.Description.Show") &&  AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.Description.Required")  )
                 { %>
            if ($.trim($("#txtDescription").val()) == "") {
                alert("Please enter description.");
                // strError += "Please enter description.";
                $("#txtDescription").focus();
                errorCount++;
                curButton.disabled = false; //<CODE_TAG_104920>
                return false;
            }
            <% } %>


             <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.JobControlCode.Required") )
                 { %>
            if ($.trim($("#txtJobControlCode").val()) == "") {
                alert("Please enter job control Code.");
                // strError += "Please enter description.";
                $("#txtJobControlCode").focus();
                errorCount++;
                curButton.disabled = false; //<CODE_TAG_104920>
                return false;
            }
            <% } %>


            if ($("#lstSalesRep").val() == "") {
                alert("Please select a sales rep.");
                $("#lstSalesRep").focus();
                errorCount++;
                curButton.disabled = false; //<CODE_TAG_104920>
                return false;
            }


            if ($("#hidCustomerNo").val() == "") {
                alert("Please select a customer.");
                errorCount++;
                curButton.disabled = false; //<CODE_TAG_104920>
                return false;
            }

            if ($("#lstDivision").val() == "") {
                alert("Please select a division.");
                $("#lstDivision").focus();
                errorCount++;
                curButton.disabled = false; //<CODE_TAG_104920>
                return false;
            }

            //SMU
            if (DisplayLastSMU == "2") {
                if ($("#hidLastTimeSMUValue").val() != "0" && $.trim($("#txtSMU").val()) != "") {
                    var lastSMUValue = parseFloat($("#hidLastTimeSMUValue").val());
                    var NewSMUValue = parseFloat($("#txtSMU").val());

                    if (NewSMUValue < lastSMUValue) {//<CODE_TAG_103502> 
                        //                        alert("The SMU Value cannot be lower than the last known SMU value.");
                        //                        $("#txtSMU").focus();
                        //                        errorCount++;
                        //                        return false;
                        //<CODE_TAG_103502> //L.Z && R.Z
                        if (!confirm("The SMU Value should not be lower than the last known SMU value. Are you sure to continue?")) {
                            $("#txtSMU").focus();
                            //errorCount++;
                            curButton.disabled = false; //<CODE_TAG_104920>
                            return false;
                        }
                        //</CODE_TAG_103502> 

                    }
                }

                if ($.trim($("#txtSMU").val()) != "" && $("#lstSMUIndicator").val() == "") {
                    alert("The SMU Indicator cannot be blank.");
                    errorCount++;
                    curButton.disabled = false; //<CODE_TAG_104920>
                    return false;
                }

                //if ( $("#hidLastTimeSMUIndicator").val() != "") 
                if ($("#hidLastTimeSMUIndicator").val() != "" && $("#lstSMUIndicator").val() != "") //<CODE_TAG_102208> 
                {
                    if ($("#hidLastTimeSMUIndicator").val() != $("#lstSMUIndicator").val()) {
                        alert("The SMU Indicator doesn't match the last known SMU Indicator.");
                        errorCount++;
                        curButton.disabled = false; //<CODE_TAG_104920>
                        return false;
                    }
                }

                if ($("#hidLastTimeSMUDate").val() != "" && $("#txtSMULastRead").val() != "") {
                    var oldSMUDate = new Date($("#hidLastTimeSMUDate").val());
                    var newSMUDate = new Date($("#txtSMULastRead").val());
                    var todayDate = new Date();

                    if (oldSMUDate > newSMUDate) {
                        alert("The SMU Date cannot backdate the last known SMU Date.");
                        errorCount++;
                        curButton.disabled = false; //<CODE_TAG_104920>
                        return false;
                    }

                    if (newSMUDate > todayDate) {
                        alert("The SMU Date cannot be future date.");
                        errorCount++;
                        curButton.disabled = false; //<CODE_TAG_104920>
                        return false;
                    }

                }
                //<CODE_TAG_104769>
                //check Existing Opp list
                if ($("#rdbtnNewOrExistingOpportunity_1").prop("checked")) {
                    if ($("#lstOppList").val() == undefined || $("#lstOppList").val() == "") {
                        alert("Please select an Existing Opp No.");
                        curButton.disabled = false; //<CODE_TAG_104920>
                        return false;
                    }
                }
                //</CODE_TAG_104769>



            }



            //Opp validation

            if ($("#tblHasOpportunity").is(':visible')) {
                if ($("#lstEstDeliveryYear").val() == "") {
                    alert("Please select a estimated delivery year.");
                    errorCount++;
                    curButton.disabled = false; //<CODE_TAG_104920>
                    return false;
                }

                if ($("#lstEstDeliveryMonth").val() == "") {
                    alert("Please select a estimated delivery month.");
                    errorCount++;
                    curButton.disabled = false; //<CODE_TAG_104920>
                    return false;
                }


                if (!($("#rdoLow").is(':checked') || $("#rdoMedium").is(':checked') || $("#rdoHigh").is(':checked'))) {
                    alert("Please select a probability of closing.");
                    errorCount++;
                    curButton.disabled = false; //<CODE_TAG_104920>
                    return false;
                }

                 <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Opportunity.Commodity.Mandatory"))
                    { %>

                if ($("#lstCommodity").val() == "") {
                    alert("Please select a commodity.");
                    errorCount++;
                    curButton.disabled = false; //<CODE_TAG_104920>
                    return false;
                }
                <% } %>


                if ($("#lstSource").val() == "") {
                    alert("Please select a source.");
                    errorCount++;
                    curButton.disabled = false; //<CODE_TAG_104920>
                    return false;
                }

                // <CODE_TAG_105411> LWANG
                if (($("#lstSource").val() == "1") && ($("#lstCampaign").val() == "")) {
                    alert("Please select a campaign.");
                    errorCount++;
                    return false;
                }
                // </CODE_TAG_105411>

            }

            if ($("#hdnNewSegmentData").val() == "") {
                alert("Please finish segment data.");
                errorCount++;
                curButton.disabled = false; //<CODE_TAG_104920>
                return false;
            }

            $("#hidSelectContact").val($('#lstContact').val());
            $("#hidDivision").val($('#lstDivision').val());
            $("#hidSelectedCommodityId").val($('#lstCommodity').val());  // <CODE_TAG_101544>


            //$("[id*=btnSave]").attr('disabled', 'disabled'); 
            $("[id*=btnSave]").hide();

            $("#spanWaitting").show();
            $("#spanWaitting img").attr("src", "../../Library/images/waiting.gif");
            curButton.disabled = false; //<CODE_TAG_104920>
            return true;
        }

        // Segment******************************************************************************************************************

        function showQuoteSegmentSearch() {
            $j("#iFrameQuoteSegmentSearch").attr("src", "Controls/QuoteSegmentSearch.aspx?TT=iframe&QuoteNo=<%= QuoteNo %>&SegmentNo=<%= SegmentNo %>");
            $j("#divQuoteSegmentSearch").dialog("open");
        }

        function closeQuoteSegmentSearch() {
            $j("#divQuoteSegmentSearch").dialog("close");
        }
        //---------------------------------------------------------------------------------------------------------------------



        function showWOSegmentSearch() {
            var searchType = 2;
            if ("LINKWO" == "<%= CopyFrom  %>")
                searchType = 3;

            $j("#iFrameWOSegmentSearch").attr("src", "Controls/WOSegmentSearch.aspx?TT=iframe&searchType=" + searchType + "&WONO=<%= WONO %>&SegmentNo=<%= SegmentNo %>");
            $j("#divWOSegmentSearch").dialog("open");
        }

        function closeWOSegmentSearch() {
            $j("#divWOSegmentSearch").dialog("close");
        }

        //--------------------------------------------------------------------------------------------------------------------------
        function showStandardJobSearch() {
            $j("#iFrameStandardJobSearch").attr("src", "../RepairOption/RepairOptions_ByModel.aspx?TT=iframe&PageMode=AddSegments&Model=" + $("#txtModel").val());
            $j("#divStandardJobSearch").dialog("open");
        }

        function closeStandardJobSearch() {
            $j("#divStandardJobSearch").dialog("close");
        }

        //<CODE_TAG_103973>
        function showDBSPartDocumentsSearch(operation) {
            if (operation == null) operation = "AddNewSegmentFromDBSPartDocument";
            var src = "Controls/DBSPartDocumentsSearch.aspx?operation=" + operation;
            $j("#iFrameDBSPartDocumentsSearch").attr("src", src);
            $j("#divDBSPartDocumentsSearch").dialog("open");
        }

        function closeDBSPartDocumentsSearch(reloadPageInd, selectedData) {
            $j("#divDBSPartDocumentsSearch").dialog("close");

        }
        //<CODE_TAG_103973>

        // Customer ********************************************************************************************************************
        function showCustomerSearch() {
            //$j("#iFrameCustomerSearch").attr("src", "../TRG_Search/Equipment/CustomerSearch/Customer_Search.aspx?TT=iframe");
            // <CODE_TAG_105262> lwang
            if ($j("#hidCustomerNo").val() != "") {
                var customerNo = $j("#hidCustomerNo").val();
                var division = $j("#lstDivision").val();
                $j("#iFrameCustomerSearch").attr("src", "../TRG_Search/Equipment/CustomerSearch/Customer_Search.aspx?TT=iframe&DefaultDivision=" + division + "&SearchField=1&keyword=" + customerNo);
            }
            else
                // <CODE_TAG_105262> lwang
                $j("#iFrameCustomerSearch").attr("src", "../TRG_Search/Equipment/CustomerSearch/Customer_Search.aspx?TT=iframe&DefaultDivision=<%=DefaultDivision %>"); //<CODE_TAG_102194>
            $j("#divCustomerSearch").dialog("open");
        }

        function closeCustomerSearch() {
            $j("#divCustomerSearch").dialog("close");
        }

        function chkNewContact_onChange() {
            if ($("#chkNewContact").prop("checked")) {
                $("#lstContact").hide();
                $("#txtContact").show();
            }
            else {
                $("#lstContact").show();
                $("#txtContact").hide();
                reloadInfluencerList();
            }
            $('#txtPhoneNo').val("");
            $('#txtFax').val("");
            $('#txtEmail').val("");
        }

        function lstDivision_onChange() {
            //<CODE_TAG_104784>
            var callId = $("#lstDivision").find('option:selected').attr("CallId");
            var CustomerLoyaltyIndicator = $("#lstDivision").find('option:selected').attr("CustomerLoyaltyIndicator");
            LoadCustomerLoyaltyIndicator(CustomerLoyaltyIndicator, callId);
            //</CODE_TAG_104784>
            reloadInfluencerList();
            reloadCampaignList();
            getExistingOpplist();
            reloadStageType();  //<CODE_TAG_105235> lwang
        }
        //<CODE_TAG_105235> lwang
        function reloadStageType() {
            var division;
            var currentDivision = $('#lstDivision').val();

            var arrStageTypeList = $("#hidStageType").val().split(String.fromCharCode(5));
            $.each(arrStageTypeList, function (index, value) {
                var arrStr = value.split("|");
                var division = arrStr[0];
                if (division == currentDivision) {
                    $("#lstQuoteStageType").val(arrStr[1]);
                    return false;
                }
            });
        }
        //</CODE_TAG_105235> lwang


        function reloadInfluencerList() {
            var division;
            var influencerId;
            var influencerType;
            var influencerName;
            var influencerPhoneNo;

            $('#lstContact >option').remove();
            $('#lstContact').append($('<option></option>').val("").html(""));
            $('#txtPhoneNo').val("");
            var currentDivision = $('#lstDivision').val();

            if ($("#hdnInfList").val() != "") {
                var infList = $("#hdnInfList").val().split(String.fromCharCode(5));
                $.each(infList, function (index, value) {
                    arrStr = value.split("-");
                    division = arrStr[0];
                    influencerId = arrStr[1];
                    influencerType = arrStr[2];
                    influencerName = arrStr[3];
                    influencerPhoneNo = arrStr[4];
                    influencerFax = arrStr[5];  //<CODE_TAG_103362>
                    influencerEmail = arrStr[6]; // <CODE_TAG_103362>
                    if (division == currentDivision)
                        $('#lstContact').append($('<option></option>').val(division + "-" + influencerId + "-" + influencerType + "-" + influencerName).html(influencerName));

                });
            }

        }

        function lstContact_onChange() {
            $('#txtPhoneNo').val("");
            $('#txtFax').val("");
            $('#txtEmail').val("");
            var arrStr = $("#lstContact").val().split("-");
            var currentDivision = arrStr[0];
            var currentInfluencerId = arrStr[1];
            var currentInfluencerType = arrStr[2];
            var currentInfluencerName = arrStr[3];

            setInfluencerPhone(currentDivision, currentInfluencerId, currentInfluencerType);

        }

        function setInfluencerPhone(currentDivision, currentInfluencerId, currentInfluencerType) {
            if ($("#hdnInfList").val() != "") {
                var infList = $("#hdnInfList").val().split(String.fromCharCode(5));
                $.each(infList, function (index, value) {

                    arrStr = value.split("-");
                    division = arrStr[0];
                    influencerId = arrStr[1];
                    influencerType = arrStr[2];
                    influencerName = arrStr[3];
                    influencerPhoneNo = arrStr[4].replace(/@/g, "-");
                    influencerFaxNo = arrStr[5].replace(/@/g, "-");
                    influencerEmail = arrStr[6];
                    if (division == currentDivision && influencerId == currentInfluencerId && influencerType == currentInfluencerType) {
                        $('#txtPhoneNo').val(influencerPhoneNo);
                        $('#txtFax').val(influencerFaxNo);
                        $('#txtEmail').val(influencerEmail);
                    }
                });
            }
        }
        function AddCustomer(sCustomerNo, sCustomerName) {
            //function AddCustomer(sCustomerNo, sCustomerName, sCustomerLoyaltyIndicator) {  //<CODE_TAG_104784>
            //$("[id*=lblCustomer]").html(sCustomerNo + "-" + sCustomerName);
            //$("#lblCustomer").html(sCustomerNo + "-" + sCustomerName);//<CODE_TAG_104784> //<CODE_TAG_105153> Lwang
            $("[id$=lblCustomer]").html(sCustomerNo + "-" + sCustomerName); //<CODE_TAG_105153> Lwang
            $("#hidCustomerNo").val(sCustomerNo);
            $("#hidCustomerName").val(sCustomerName);

            //LoadCustomerLoyaltyIndicator(sCustomerLoyaltyIndicator); //<CODE_TAG_104784>
        }
        //<CODE_TAG_104784>
        function LoadCustomerLoyaltyIndicator(customerLoyaltyInd, callerId) {
            var loyaltyUrl;
            if (callerId == undefined) {
                loyaltyUrl = "";
            }
            else {
                loyaltyUrl = "http://apps.toromontcat.com/CSM/Modules/StartSurvey.aspx?CallId=" + callerId + "&ReadOnly=1&FromSaleSLink=1";
            }
            var aLink = "";
            if (customerLoyaltyInd == undefined)
                customerLoyaltyInd = "";
            switch (customerLoyaltyInd) {
                case "1": //red color, with "at Risk"
                    $("#lblCustomerLoyaltyIndicator").css("background-color", "red");
                    //$("#lblCustomerLoyaltyIndicator").text("Risk");
                    aLink = "<a href ='" + loyaltyUrl + "' style='color:white' target='_blank' > At Risk </a>";
                    $("#lblCustomerLoyaltyIndicator").html(aLink);
                    break;
                case "2": //Orange color with "Vulnerable"
                    $("#lblCustomerLoyaltyIndicator").css("background-color", "orange");
                    //$("#lblCustomerLoyaltyIndicator").text("Vulnerable");
                    aLink = "<a href ='" + loyaltyUrl + "' style='color:white' target='_blank' > Vulnerable </a>";
                    $("#lblCustomerLoyaltyIndicator").html(aLink);
                    break;
                case "4": //green color with "Loyal"
                    $("#lblCustomerLoyaltyIndicator").css("background-color", "green");
                    //$("#lblCustomerLoyaltyIndicator").text("Loyal");
                    aLink = "<a href ='" + loyaltyUrl + "' style='color:white' target='_blank' > Loyal </a>";
                    $("#lblCustomerLoyaltyIndicator").html(aLink);
                    break;
                    //case "8": //do nothing
                    //break;
                default:
                    $("#lblCustomerLoyaltyIndicator").css("background-color", "white");
                    $("#lblCustomerLoyaltyIndicator").html(aLink);
                    break;
            }

        }
        //</CODE_TAG_104784>
        function AddWOCustomer(sCustomerNo, sCustomerName, sCustomerPONo, sJobCode, sWONO, sDivision, sWOContactName, sESBYNM) {
            $("[id*=lblCustomer]").html(sCustomerNo + "-" + sCustomerName);
            $("#hidCustomerNo").val(sCustomerNo);
            $("#hidCustomerName").val(sCustomerName);

            if (isNaN(sESBYNM))
                $("#txtEstimatedByName").val(sESBYNM);

            if (isNaN(sCustomerPONo))
                $("#txtPO").val(sCustomerPONo);
            if (isNaN(sJobCode))
                $("#txtJobControlCode").val(sJobCode);
            $("#hidWONO").val(sWONO);

            getDivisionListFromDB();
            getInfluencerListFromDB();
            SetDivision(sDivision);
            getExistingOpplist();


            if (sWOContactName != "") {
                var findWOContact = false;
                var odrpContact = document.getElementById("lstContact");

                for (var i = 0; i < odrpContact.length; i++) {
                    var arrStr = odrpContact.options[i].value.split("-");
                    var division = arrStr[0];
                    var influencerId = arrStr[1];
                    var influencerType = arrStr[2];
                    var influencerName = arrStr[3];

                    if (influencerName == Trim(sWOContactName)) {
                        odrpContact.options[i].selected = true;
                        findWOContact = true;
                        setInfluencerPhone(division, influencerId, influencerType);
                    }
                }
                if (findWOContact) {
                    $("#chkNewContact").prop("checked", false);
                    $("#lstContact").show();
                    $("#txtContact").hide();
                }
                else {
                    $("#chkNewContact").prop("checked", true);
                    $("#lstContact").hide();
                    $("#txtContact").show();
                    $("#txtContact").val(sWOContactName);
                }

            }

        }

        function AddDivisionList(array_divisionList) {
            var oDivisionList = array_divisionList.split(",");
            $("#lstDivision").html("");
            $("<option value=''></option>").appendTo("#lstDivision");
            $.each(oDivisionList, function (index, value) {
                var oDivisionInfo = value.split("|");
                //$("<option value='" + oDivisionInfo[0] + "'>" + oDivisionInfo[0] + " - " + oDivisionInfo[1] + "</option>").appendTo("#lstDivision");
                //$("<option value='" + oDivisionInfo[0] + "' customerLoyaltyIndicator='" + oDivisionInfo[4] + "'>" + oDivisionInfo[0] + " - " + oDivisionInfo[1] + "</option>").appendTo("#lstDivision"); //<CODE_TAG_104784>
                $("<option value='" + oDivisionInfo[0] + "' CustomerLoyaltyIndicator='" + oDivisionInfo[4] + "'" + " CallId='" + oDivisionInfo[5] + "' " + ">" + oDivisionInfo[0] + " - " + oDivisionInfo[1] + "</option>").appendTo("#lstDivision"); //<CODE_TAG_104784>
            });
        }

        function AddInfluencerList(array_influencerList) {
            // array_influencerList = array_influencerList.replace(/-/g ,"&#45;");
            array_influencerList = array_influencerList.replace(/-/g, "@");
            // var oInfluencerList = array_influencerList.split("~");  //<CODE_TAG_103362>
            var oInfluencerList = array_influencerList.split(rowDelimiter);  //<CODE_TAG_104057>
            var strInfluencerList = "";
            $.each(oInfluencerList, function (index, value) {
                //var arrStr = value.split("|");
                var arrStr = value.split(colDelimiter);  //<CODE_TAG_104057>
                var division = Trim(arrStr[6]);
                var influencerId = Trim(arrStr[5]);
                var influencerType = Trim(arrStr[4]);
                //var influencerName = Trim(arrStr[0]);
                var influencerName = Trim(arrStr[0]).replace("&#44;", ","); //<CODE_TAG_101969>
                //var influencerPhoneNo = Trim(arrStr[1]).replace(/-/g,"@");
                //<CODE_TAG_103328>
                var influencerPhoneNo = Trim(arrStr[1]);
                //influencerPhoneNo= (influencerPhoneNo!=undefined && influencerPhoneNo !=null && influencerPhoneNo!="")?influencerPhoneNo.replace(/-/g,"@").replace("&#44;",","):""; //<CODE_TAG_103328>
                influencerPhoneNo = (influencerPhoneNo != undefined && influencerPhoneNo != null && influencerPhoneNo != "") ? influencerPhoneNo.replace(/-/g, "@") : ""; //<CODE_TAG_103328>
                //var influencerFax = Trim(arrStr[2]).replace(/-/g,"@");
                // <CODE_TAG_103327>
                var influencerFax = Trim(arrStr[2]);
                influencerFax = (influencerFax != 'undefined' && influencerFax != null) ? influencerFax = influencerFax.replace(/-/g, "@") : "";
                // </CODE_TAG_103327>
                var influencerEmail = Trim(arrStr[3]);
                if (strInfluencerList != "") strInfluencerList += String.fromCharCode(5);
                strInfluencerList += division + "-" + influencerId + "-" + influencerType + "-" + influencerName + "-" + influencerPhoneNo + "-" + influencerFax + "-" + influencerEmail;
            });
            $("#hdnInfList").val(strInfluencerList);
        }


        function AddEquipment(eq_Model, eq_SerialNumber, eq_EquipManufCode, eq_EquipmentNumber, sEQ_IdNumber, sEQ_ServiceMeter, sEQ_ServiceMeterInd, sEQ_ServiceMeterDate, sEQ_PromiseDate, sEQ_ArriveDate, sEQ_CabTypeCode) {
            var cur_ServiceMeterInd = "";
            if (eq_EquipManufCode != null && $.trim(eq_EquipManufCode) != "")
                $("#lstMake").val(eq_EquipManufCode);
            if (eq_Model != null && $.trim(eq_Model) != "")
                $("#txtModel").val(eq_Model);
            if (eq_SerialNumber != null && $.trim(eq_SerialNumber) != "")
                $("#txtSerialNo").val(eq_SerialNumber);
            if (eq_EquipmentNumber != null && $.trim(eq_EquipmentNumber) != "")
                $("#txtUnitNo").val(eq_EquipmentNumber);
            if (sEQ_IdNumber != null && $.trim(sEQ_IdNumber) != "")
                $("#txtStockNo").val(sEQ_IdNumber);

            if (sEQ_CabTypeCode != null && $.trim(sEQ_CabTypeCode) != "")
                $("#lstCabTypeCode").val(sEQ_CabTypeCode);

            if (sEQ_ServiceMeterInd == "H") cur_ServiceMeterInd = "1";
            if (sEQ_ServiceMeterInd == "K") cur_ServiceMeterInd = "2";
            if (sEQ_ServiceMeterInd == "M") cur_ServiceMeterInd = "4";

            if (DisplayLastSMU == '2') {
                if (sEQ_ServiceMeter != null && $.trim(sEQ_ServiceMeter) != "")
                    $("#hidLastTimeSMUValue").val(sEQ_ServiceMeter);
                //Comment out for <CODE_TAG_102157>
                //else
                //  $("#hidLastTimeSMUValue").val("0");
                //</CODE_TAG_102157>

                if (cur_ServiceMeterInd != null && $.trim(cur_ServiceMeterInd) != "") {
                    $("#hidLastTimeSMUIndicator").val(cur_ServiceMeterInd);
                    $("#lstSMUIndicator").val(cur_ServiceMeterInd);
                }
                //When customer is changed, if customer has no value related to SMU, need to get previous value from hidden field.
                //Comment out for <CODE_TAG_102157>
                //else
                //    $("#hidLastTimeSMUIndicator").val("");
                //</CODE_TAG_102157> 
                //if (sEQ_ServiceMeterDate != null)
                if (sEQ_ServiceMeterDate != null && sEQ_ServiceMeterDate != "")//<CODE_TAG_102157>
                    $("#hidLastTimeSMUDate").val(sEQ_ServiceMeterDate);
                //Comment out for <CODE_TAG_102157>
                //else
                //    $("#hidLastTimeSMUDate").val("");

                // $("#lblLastSMUValue").html(sEQ_ServiceMeter + "(" + sEQ_ServiceMeterInd + ") " + sEQ_ServiceMeterDate );
                //</CODE_TAG_102157>

                //<CODE_TAG_102157> 
                var hidLastTimeSMUIndicatorDesc = $("#hidLastTimeSMUIndicator").val();
                if (hidLastTimeSMUIndicatorDesc == null) hidLastTimeSMUIndicatorDesc = "";
                if (hidLastTimeSMUIndicatorDesc == "1") hidLastTimeSMUIndicatorDesc = "H";
                if (hidLastTimeSMUIndicatorDesc == "2") hidLastTimeSMUIndicatorDesc = "K";
                if (hidLastTimeSMUIndicatorDesc == "4") hidLastTimeSMUIndicatorDesc = "M";
                $("#lblLastSMUValue").html($("#hidLastTimeSMUValue").val() + "(" + hidLastTimeSMUIndicatorDesc + ") " + $("#hidLastTimeSMUDate").val());
                //</CODE_TAG_102157>

            }
            else {
                if (sEQ_ServiceMeter != null && $.trim(sEQ_ServiceMeter) != "")
                    $("#txtSMU").val(sEQ_ServiceMeter);

                if (cur_ServiceMeterInd != null && $.trim(cur_ServiceMeterInd) != "")
                    $("#lstSMUIndicator").val(cur_ServiceMeterInd);
                if (sEQ_ServiceMeterDate != null)
                    $("#txtSMULastRead").val(sEQ_ServiceMeterDate);
            }
            //<CODE_TAG_103412>
            <% 
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.PromiseDateClear")) 
             { %>//</CODE_TAG_103412>
            if (sEQ_PromiseDate != null)
                $("#txtPromiseDate").val(sEQ_PromiseDate);
            if (sEQ_ArriveDate != null)
                $("#txtUnittoArriveDate").val(sEQ_ArriveDate);
            <%} %>//<CODE_TAG_103412>

        }
        function setupCopyFromWODefaultdata() {
            if ($("#lstQuoteType").val() != "2") {
                $("#lstQuoteType").val("2");
                setupNewOppDefaultValue();
            }
        }

        function SetDivision(selectedDivision) {
            $("#lstDivision").val(selectedDivision);
            reloadInfluencerList();
            getExistingOpplist();
            lstDivision_onChange();
        }

        function SetInfluencer(infName, infType, infId) {
            $("#chkNewContact").prop("checked", false);
            $("#lstContact").show();
            $("#txtContact").hide();
            var odrpContact = document.getElementById("lstContact");

            for (var i = 0; i < odrpContact.length; i++) {
                var arrStr = odrpContact.options[i].value.split("-");
                var division = arrStr[0];
                var influencerId = arrStr[1];
                var influencerType = arrStr[2];
                var influencerName = arrStr[3];

                if (influencerType == Trim(infType) && influencerId == Trim(infId)) {
                    odrpContact.options[i].selected = true;
                    setInfluencerPhone(division, influencerId, influencerType);
                }
            }
        }

        //Set PSSR as the Quote Owner in lstSalesRep dropdown list 
        //<CODE_TAG_103528>
        var strIsLoginUserSalesRep = "<%= strIsLoginUserSalesRep %>";
        var isPSSRExist = false;
        function ProcessQuoteOwner(strPSSRXUId) {
            <%if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.SalesRep.SetPSSRAsQuoteOwner"))
            { %>
            if (strIsLoginUserSalesRep == 1) //quote creator is not a sales rep
            {
                //set the quote owner to pssr here
                SetQuoteOwnerToPSSR(strPSSRXUId);
            }
            else {
                //do nothing
            }
           <%  }
             else
             { %>
            SetQuoteOwnerToPSSR(strPSSRXUId);
           <%   } %>
        }
        function SetQuoteOwnerToPSSR(strPSSRXUId) {//set the current customer's PSSR as the quote owner
            CheckPSSRExist(strPSSRXUId);
            //if (isPSSRExist && isPSSRExist==false) return;  //when PSSR not exists in the quote owner drop down list, not set, just return.
            if (isPSSRExist == false) return;  //when PSSR not exists in the quote owner drop down list, not set, just return.
            if (strPSSRXUId) {//to do here
                $("#lstSalesRep").val(strPSSRXUId);
            }
        }
        function CheckPSSRExist(strPSSRXUId) {
            isPSSRExist = false;
            $("#lstSalesRep option").each(function () {

                if ($(this).val() == strPSSRXUId) {
                    isPSSRExist = true;
                    return;

                }
            });
        }
        //</CODE_TAG_103528>

        var strOwnersList = "<%= strOwnersList %>";

        function lstSalesRep_onChange() {
            $("#txtSalesrepPhone").val("");
            $("#txtSalesrepCellPhone").val("");
            $("#txtSalesrepFax").val("");

            var salesrepXUID = $("#lstSalesRep").val();
            var arrSalesRepInfoList = strOwnersList.split(String.fromCharCode(5));

            $.each(arrSalesRepInfoList, function (index, value) {
                var arrStr = value.split("|");
                var userId = arrStr[0];
                var phone = arrStr[1];
                var cellPhone = arrStr[2];
                var fax = arrStr[3];

                if (userId == salesrepXUID) {
                    $("#txtSalesrepPhone").val(phone);
                    $("#txtSalesrepCellPhone").val(cellPhone);
                    $("#txtSalesrepFax").val(fax);
                }
            });


        }

        // Opportunity ***********************************************************************************************************

        function setupNewOppDefaultValue() {

            var arrNewOppDefaultValue = $("#hdnNewOppDefaultValue").val().split(String.fromCharCode(5));
            var curQuoteTypeId = $("#lstQuoteType").val();

            $.each(arrNewOppDefaultValue, function (index, value) {
                var arrStr = value.split("|");
                var quoteTypeId = arrStr[0];
                var OppTypeId = arrStr[1];
                var DefaultOppStageId = arrStr[2];
                var DefaultOppSourceId = arrStr[3];
                var DefaultOppProbabilityOfClosing = arrStr[4];

                if ((curQuoteTypeId & quoteTypeId) > 0) {
                    $("#lstOppType").val(OppTypeId);
                    lstOppType_onChange();
                    $("#lstSource").val(DefaultOppSourceId);
                    lstSource_onChange();
                    if (DefaultOppProbabilityOfClosing == "1") $("#rdoLow").attr('checked', true);
                    if (DefaultOppProbabilityOfClosing == "2") $("#rdoMedium").attr('checked', true);
                    if (DefaultOppProbabilityOfClosing == "4") $("#rdoHigh").attr('checked', true);
                }

            });

            getExistingOpplist();

        }

        var arrExistingOppList = "";
        function getExistingOpplist() {
            if (NewQuoteFromOpp == 2) return;

            var cuno = $("#hidCustomerNo").val();
            var division = $("#lstDivision").val();
            var quoteTypeId = $("#lstQuoteType").val();

            $.ajax({
                url: "QuoteAjaxHandler.ashx?op=OPPLIST&cuno=" + cuno + "&division=" + division + "&QuoteTypeId=" + quoteTypeId,
                type: "GET",
                cache: false,
                async: false,
                success: function (htmlContent) {
                    arrExistingOppList = "";
                    if (htmlContent != "") {
                        arrExistingOppList = htmlContent.split(String.fromCharCode(5));
                    }

                    $("#lstOppList").html("");
                    $("<option value=''>please select Existing Opp No.</option>").appendTo("#lstOppList"); //<CODE_TAG_104769>
                    $.each(arrExistingOppList, function (index, value) {
                        var arrStr = value.split("|");
                        var oppNo = arrStr[0];
                        var DeliveryYear = arrStr[1];
                        var oppDesc = unescape(arrStr[6]);

                        $("<option value='" + oppNo + "'>" + oppNo + " - " + oppDesc + "</option>").appendTo("#lstOppList");
                    });

                }
            });

        }

        function setupExistingOppValue() {
            var curOppNo = $("#lstOppList").val();

            $.each(arrExistingOppList, function (index, value) {
                var arrStr = value.split("|");
                var oppNo = arrStr[0];
                var deliveryYear = arrStr[1];
                var deliveryMonth = arrStr[2];
                var commodityCategoryId = arrStr[3];
                var oppSourceId = arrStr[4];
                var oppTypeId = arrStr[5];

                if (oppNo == curOppNo) {
                    $("#hdnOppNo").val(oppNo);

                    $("#lstEstDeliveryYear").val(deliveryYear);
                    $("#lstEstDeliveryMonth").val(deliveryMonth);
                    $("#lstOppType").val(oppTypeId);
                    lstOppType_onChange();
                    $("#lstCommodity").val(commodityCategoryId);
                    $("#lstSource").val(oppSourceId);
                }

            });

        }



        function AddOpportunityList(array_OpportunityList) {
        }

        function lstOppType_onChange() {
            var currentOppTypeId = parseInt($("#lstOppType").val());
            if (isNaN(currentOppTypeId)) currentOppTypeId = 0;

            var arrCommodityList = $("#hdnCommodityList").val().split(String.fromCharCode(5));
            $("#lstCommodity").html("");
            $("<option value=''></option>").appendTo("#lstCommodity");
            $.each(arrCommodityList, function (index, value) {
                var arrStr = value.split("|");
                var oppTypeId = parseInt(arrStr[0]);
                if (isNaN(oppTypeId)) oppTypeId = 0;
                var commodityId = arrStr[1];
                var commodityDesc = arrStr[2];

                if ((currentOppTypeId & oppTypeId) > 0)
                    $("<option value='" + commodityId + "'>" + commodityDesc + "</option>").appendTo("#lstCommodity");
            });

            reloadCampaignList();

        }
        /* Comment out this fucntion, because it was a duplicate one.
                function reloadInfluencerList() {
                    var division;
                    var influencerId;
                    var influencerType;
                    var influencerName;
                    var influencerPhoneNo;
        
                    $('#lstContact >option').remove();
                    $('#lstContact').append($('<option></option>').val("").html(""));
                    $('#txtPhoneNo').val("");
                    var currentDivision = $('#lstDivision').val();
        
                    if ($("#hdnInfList").val() != "") {
                        var infList = $("#hdnInfList").val().split(String.fromCharCode(5));
                        $.each(infList, function (index, value) {
                            arrStr = value.split("-");
                            division = arrStr[0];
                            influencerId = arrStr[1];
                            influencerType = arrStr[2];
                            influencerName = arrStr[3];
                            influencerPhoneNo = arrStr[4];
                            if (division == currentDivision)
                                $('#lstContact').append($('<option></option>').val(division + "-" + influencerId + "-" + influencerType + "-" + influencerName).html(influencerName));
        
                        });
                    }
        
                }
                */
        //<CODE_TAG_103933>
        function lstCampaign_onchange() {
            var campaignSelected = $("#lstCampaign option:selected").val();
            $("#hdnlstCampaignSelected").val(campaignSelected);

        }
        //</CODE_TAG_103933>

        function lstSource_onChange() {
            if ($("#lstSource").val() == "1") {
                $("#lstCampaign").show();
                reloadCampaignList();
            }
            else {
                $("#lstCampaign").hide();
            }
        }

        function reloadCampaignList() {
            var currentDivision = $("#lstDivision").val();
            var currentOppTypeId = parseInt($("#lstOppType").val());
            $("#lstCampaign").html("");

            $("<option value=''></option>").appendTo("#lstCampaign");
            var arrCampaignList = $("#hdnCampaignList").val().split(String.fromCharCode(5));
            $.each(arrCampaignList, function (index, value) {
                var arrStr = value.split("|");
                var campaignId = arrStr[0];
                var campaignName = arrStr[1];
                var oppTypeId = arrStr[2];
                var division = arrStr[3];
                //if (division == currentDivision && (oppTypeId == currentOppTypeId )
                if (division == currentDivision && (oppTypeId == currentOppTypeId || oppTypeId == 0))  //<Ticket 41671> S.S && R.Z
                    $("<option value='" + campaignId + "'>" + campaignName + "</option>").appendTo("#lstCampaign");
            });

        }

        function getDivisionListFromDB() {
            if ($("#hidCustomerNo").val() != "") {
                var str = CommonFunctionAjaxHandler("GETDIVISIONSLIST", "&cuno=" + $("#hidCustomerNo").val());
                AddDivisionList(str);
            }
        }
        function getInfluencerListFromDB() {
            if ($("#hidCustomerNo").val() != "") {
                var str = CommonFunctionAjaxHandler("GETINFLUENCERLIST", "&cuno=" + $("#hidCustomerNo").val());
                $("#hdnInfList").val(str);
            }
        }

        function setupCreateFromOppInfo() {

            var oppNo = $("#hdnCreateFromOppNo").val();
            var oppInfo = $.parseJSON(CommonFunctionAjaxHandler("GETOPPINFO", "&oppNo=" + oppNo));

            if (oppInfo.ResultCode == "0") {
                NewQuoteFromOpp = 2;

                $("#lstQuoteType").val(oppInfo.QuoteTypeId);
                setupNewOppDefaultValue();

                $("#txtDescription").val(oppInfo.Description);

                $("[id*=lblCustomer]").html(oppInfo.CustNo + "-" + oppInfo.CustName);
                $("#hidCustomerNo").val(oppInfo.CustNo);
                $("#hidCustomerName").val(oppInfo.CustName);
                // <CODE_TAG_103716>
                $("#txtSerialNo").val(oppInfo.SerialNo);
                $("#lstMake").val(oppInfo.Make);
                // </CODE_TAG_103716>
                $("#lstDivision").html("");
                $("<option value='" + oppInfo.Division + "'>" + oppInfo.Division + " - " + oppInfo.DivisionName + "</option>").appendTo("#lstDivision");


                $("#txtContact").val(oppInfo.CustomerContactName);
                $("#lstContact").hide();
                $("#txtContact").show();
                //$("#chkNewContact").attr('checked',true);
                //<CODE_TAG_103814>
                if (!oppInfo.CustomerContactName || /^\s*$/.test(oppInfo.CustomerContactName))  //if customerContact no exists, or empty,then let newcontact checkbox checked
                    $("#chkNewContact").attr('checked', true);
                //</CODE_TAG_103814>

                $("[id*=rdbtnOpportunity][value=2]").attr('checked', true);
                $("[id*=rdbtnOpportunity]").hide();
                $("[for*=rdbtnOpportunity]").hide();

                $("[id*=rdbtnNewOrExistingOpportunity][value=2]").attr('checked', true);
                $("[id*=rdbtnNewOrExistingOpportunity]").hide();
                $("[for*=rdbtnNewOrExistingOpportunity]").hide();


                $("#hdnOppNo").val(oppNo);

                $("#lstEstDeliveryYear").val(oppInfo.DeliveryYear);
                $("#lstEstDeliveryMonth").val(oppInfo.DeliveryMonth);



                $("#lstOppList").html("");
                $("<option value='" + oppNo + "'>" + oppNo + " - " + oppInfo.Description + "</option>").appendTo("#lstOppList");
                $("#lstOppList").hide();

                $("#lblOppNo").html(oppNo + " - " + oppInfo.Description);

                if (oppInfo.ProbabilityOfClosing == "1") $("#rdoLow").attr('checked', true);
                if (oppInfo.ProbabilityOfClosing == "2") $("#rdoMedium").attr('checked', true);
                if (oppInfo.ProbabilityOfClosing == "4") $("#rdoHigh").attr('checked', true);

                $("#lstCommodity").val(oppInfo.CommodityCategoryId);
                $("#lstSource").val(oppInfo.OppSourceId);
                lstSource_onChange();
                $("#lstCampaign").val(oppInfo.CampaignId);
                $("#hdnlstCampaignSelected").val(oppInfo.CampaignId); //<CODE_TAG_103933>//!!
                //<CODE_TAG_103814>
                $("#txtPhoneNo").val(oppInfo.Phone);
                //$("#txtPO").val(oppInfo.PostalCode);  //<Ticket 52808>, PO is for Purchase Number instead of PoestalCode...
                $("#txtEmail").val(oppInfo.Email);
                if (oppInfo.BranchNo && (!/^\s*$/.test(oppInfo.BranchNo))) //BranchNo eists and not empty
                    $("#lstBranch").val(oppInfo.BranchNo);
                if (oppInfo.XUId && (!/^\s*$/.test(oppInfo.XUId))) //SalesRepId eists and not empty
                    $("#lstSalesRep").val(oppInfo.XUId);
                //</CODE_TAG_103814>

            }
            else {
                alert("Cannot get the opportunity infomation in sales link, please check it in saleslink; opportunity number:" + oppNo);
            }
        }
        //<!--CODE_TAG_101936-->
        function reloadCostCentreCode() {
            document.getElementById('iFrameNewSegment').contentWindow.reloadCostCentreCode(arrCostCentreCode, $("#lstBranch").val());
        }//<!--/CODE_TAG_101936-->

        //*******************************************************************************************************************

    </script>
</asp:Content>
