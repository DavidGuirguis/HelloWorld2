<%@ Page Title="" Language="C#" MasterPageFile="~/Library/MasterPages/iFrame.master"
    EnableEventValidation="false" AutoEventWireup="true" CodeFile="QuoteHeaderEdit.aspx.cs"
    Inherits="quoteHeaderEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMP" runat="Server">
    <div class="quoteHeaderEdit">
        <fieldset>
            <legend>Quote</legend>
            <table>
                <tr style="display: <%= (IsNewQuote) ?"none":""  %>">
                    
                   <%-- <th>
                        Quote No:
                    </th>
                    <td>
                       
                    </td>--%>
                    <th>
                       <asp:Label ID="lblQuoteNo" Visible="false"  runat="server"></asp:Label>
                        Quote Status:<span style="color:red">*</span>
                    </th>
                    <td>
                        <asp:DropDownList ID="lstQuoteStatus" ClientIDMode="Static" onchange="lstQuoteStatus_onChange();"
                            runat="server">
                        </asp:DropDownList>
                    </td>
                    <th>
                        Quote Type:<span style="color:red">*</span>
                    </th>
                    <td>
                        <asp:DropDownList ID="lstQuoteType" ClientIDMode="Static" runat="server" onchange="lstQuoteType_onChange();">
                        </asp:DropDownList>
                        <asp:DropDownList ID="lstOppType" ClientIDMode="Static" runat="server" Style="display: none;">
                        </asp:DropDownList>
                    </td>
                    <th>
                        Branch:<span style="color:red">*</span>
                    </th>
                    <td ><!--CODE_TAG_101755--><!--<CODE_TAG_105235> lwang-->
                        <asp:DropDownList ID="lstBranch"  ClientIDMode="Static"  runat="server">
                        </asp:DropDownList>
                    </td>
                    <%--<CODE_TAG_105235> lwang--%>
                    <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.StageType.Show"))
                    { %>
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
                <tr>
                    
                    <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.Description.Show"))
                       { %>
                       
                    <th>
                        Description: 
                         <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.Description.Required"))
                            { %>
                        <span style="color:red">*</span>
                        <%
                            } %>
                    </th>
                    <td colspan="10">
                        <asp:TextBox ID="txtDescription" MaxLength="300" Style="width: 100%" ClientIDMode="Static" runat="server"></asp:TextBox>
                    </td>
                    
                    <%} %>


                    </tr>
                <tr>
                  <th>
                        Owner:<span style="color:red">*</span>
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
                        <asp:TextBox ID="txtSalesrepPhone" ClientIDMode="Static"   MaxLength="60" runat="server"></asp:TextBox>
                    </td>
                    <th>
                        Mobile Phone No:
                    </th>
                    <td>
                        <asp:TextBox ID="txtSalesrepCellPhone" ClientIDMode="Static" MaxLength="60" runat="server"></asp:TextBox>
                    </td>
                    <th>
                        Fax No:
                    </th>
                    <td>
                        <asp:TextBox ID="txtSalesrepFax" ClientIDMode="Static" MaxLength="60" runat="server"></asp:TextBox>
                    </td>
                  
                    <th>
                    </th>
                    <td>
                    </td>
                </tr>
                <tr>
                    <th>
                        Promise Date:
                    </th>
                    <td nowrap>
                        <asp:TextBox runat="server" ID="txtPromiseDate" CssClass="fe" Width="60%" ClientIDMode="Static" />
                        <img onclick="$('#txtPromiseDate').val('');" src="../../../library/images/icon_x.gif" />
                    </td>
                    <th>
                        Unit to Arrive Date:
                    </th>
                    <td nowrap>
                        <asp:TextBox runat="server" ID="txtUnittoArriveDate" ClientIDMode="Static" CssClass="fe"
                            Width="60%" />
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
                </tr>
                <tr>
                    <th>
                        Job Control Code:
                         <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.JobControlCode.Required"))
                           { %>
                                <span style="color: red">*</span>
                                  <%} %>
                    </th>
                    <td>
                        <asp:TextBox runat="server" ID="txtJobControlCode" CssClass="fe" MaxLength="2" Width="60%"
                            ClientIDMode="Static" />
                    </td>
                    <th>
                        Estimated Repair Time
                    </th>
                    <td>
                        <asp:TextBox runat="server" ID="txtEstimatedRepairTime" CssClass="fe" MaxLength="50"
                            Width="60%" ClientIDMode="Static" />
                    </td>
                    <!--relocated estimated field for CODE_TAG_101755-->
                     <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.EstimatedByName.Show"))
                    {  %>
                    <th>
                        Estimated By:
                    </th>
                    <td>
                        <asp:TextBox ID="txtEstimatedByName" MaxLength="20" Style="width: 80%" ClientIDMode="Static" runat="server"></asp:TextBox>
                    </td>
                    <% } %><!--/relocated estimated field for CODE_TAG_101755-->

                    <!--CODE_TAG_103674-->
                    <th>
                        Print Quote Date:
                    </th>
                    <td colspan="1"><!--CODE_TAG_101755-->
                        <asp:TextBox ID="txtPrintQuoteDate" runat="server"  ClientIDMode="Static" Width="60%" Title="Clear the textbox, it will print today's date."></asp:TextBox>
                        <img onclick="$('#txtPrintQuoteDate').val('');" src="../../../library/images/icon_x.gif" />
                    </td>
                    <!--CODE_TAG_103674-->

                </tr>
                <!--CODE_TAG_101731-->
                <%  if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.Comment.Show")) { %>
                <tr>
                    <th style="vertical-align:top">Comments:</th>
                    <td colspan="7" >
                        <asp:TextBox ID="txtComents"  Style="width:98%"   runat="server" ClientIDMode="Static" Height="50" TextMode="MultiLine"></asp:TextBox>
                    </td>
                </tr>
                <% } %>
                <!--/CODE_TAG_101731-->
            </table>

                    

        </fieldset>
        <fieldset>
            <legend>Customer </legend>
            <table>
                <tr>
                    <th>
                        Customer No:<span style="color:red">*</span>
                    </th>
                    <td colspan="3">
                        <img src="../../../library/images/magnifier.gif" onclick="openCustomerSearch()" class='imgBtn' />
                        <asp:Label ID="lblCustomer" runat="server" ClientIDMode="Static"></asp:Label> <!--CODE_TAG_104784-->
                        <asp:HiddenField ID="hidCustomerNo" ClientIDMode="static" Value="" runat="server" />
                        <asp:HiddenField ID="hidCustomerName" ClientIDMode="static" Value="" runat="server" />
                        <asp:Label ID="lblCustomerLoyaltyIndicator" ClientIDMode="static" runat="server" Visible="true"  ForeColor="White" style="padding:3px"></asp:Label><!--CODE_TAG_104784-->
                    </td>
                    <th>
                        Division:<span style="color:red">*</span>
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
                        <asp:TextBox ID="txtContact" MaxLength="30" ClientIDMode="static" runat="server"></asp:TextBox>
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
                        <asp:TextBox ID="txtPO" MaxLength="20" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>
                        Email:
                    </th>
                    <td colspan="3">
                        <asp:TextBox ID="txtEmail" CssClass="w98p" MaxLength="200" ClientIDMode="static"
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
            <legend>Equipment </legend>
            <table>
                <tr>
                    <th>
                        Make:
                    </th>
                    <td>
                        <asp:DropDownList ID="lstMake" runat="server" style="width:150px" ClientIDMode="Static"></asp:DropDownList>
                        <%--<asp:TextBox ID="txtMake" MaxLength="20" runat="server" ClientIDMode="Static"></asp:TextBox>--%>
                    </td>
                    <th>
                        Serial No:
                    </th>
                    <td>
                        <asp:TextBox ID="txtSerialNo" MaxLength="25" CssClass="w98p" runat="server" ClientIDMode="Static" onClick="txtSerialNo_onClick();"  onBlur="txtSerialNo_onBlur();"  ></asp:TextBox>		<%//<CODE_TAG_103503> Dav: Change MaxLength%><!--CODE_TAG_104742-->
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
                        <asp:TextBox ID="txtSMU" MaxLength="10" CssClass="tAr numbersOnly" runat="server"
                            ClientIDMode="static" Width="50%"></asp:TextBox>
                        <asp:DropDownList ID="lstSMUIndicator" ClientIDMode="static" runat="server" />
                    </td>
                    <th>
                        SMU Date:
                    </th>
                    <td nowrap>
                        <asp:TextBox runat="server" ID="txtSMULastRead" CssClass="fe" Width="60%" ClientIDMode="Static" />
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
                    <th>Cab type:</th>
                    <td><asp:DropDownList ID="lstCabTypeCode" Width="150px" onchange="chkNewContact_onChange();" runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>
        </fieldset>

        <fieldset>
            <legend>Opportunity
                <asp:RadioButton ID="rdobtnOpportunityYes" runat="server" GroupName="rdobtnOpportunity"
                    onclick="HasOpportunity(2);" ClientIDMode="Static" Text="Yes" />
                    &nbsp;&nbsp;
                <asp:RadioButton ID="rdobtnOpportunityNo" runat="server" GroupName="rdobtnOpportunity"
                    onclick="HasOpportunity(1);" ClientIDMode="Static" Text="No" />
            </legend>
            <table id="tblNoOpportunity" runat="server" clientidmode="Static" >
                <tr>
                    <td class="fe">
                        No Opportunity.
                    </td>
                </tr>
            </table>
            <table id="tblHasOpportunity" runat="server" clientidmode="Static" >
                <tr>
                    <td colspan="6">
                        <asp:RadioButtonList ID="rdbtnNewOrExistingOpportunity" runat="server" RepeatDirection="Horizontal"
                            RepeatLayout="Flow" ClientIDMode="Static">
                            <asp:ListItem Value="1" Text="New" onclick="NewOrExistingOpportunity(this.value);"></asp:ListItem>
                            <asp:ListItem Value="2" Text="Existing" onclick="NewOrExistingOpportunity(this.value);"></asp:ListItem>
                        </asp:RadioButtonList>
                        <asp:DropDownList ID="lstOppList" runat="server" Style="display: none" onchange="setupExistingOppValue();"
                            ClientIDMode="static">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <th>
                        Opp. No:
                    </th>
                    <td>
                        <asp:Label ID="lblOppNo" runat="server"></asp:Label>
                    </td>
                    <th>
                        Est. Delivery:<span style="color:red">*</span>
                    </th>
                    <td nowrap>
                        <asp:DropDownList ID="lstEstDeliveryYear" runat="server" ClientIDMode="Static">
                            <%--//<CODE_TAG_105426> lwang
                            <asp:ListItem Text="" Value=""></asp:ListItem>
                            <asp:ListItem Text="2020" Value="2020"></asp:ListItem>
                            <asp:ListItem Text="2019" Value="2019"></asp:ListItem>
                            <asp:ListItem Text="2018" Value="2018"></asp:ListItem>
                            <asp:ListItem Text="2017" Value="2017"></asp:ListItem>
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
                        Probability Of <br/> Closing:<span style="color:red">*</span>
                    </th>
                    <td nowrap>
                        <asp:RadioButton ID="rdoLow" Text="Low" GroupName="Probablity" ClientIDMode="Static"   runat="server" />
                        <asp:RadioButton ID="rdoMedium" Text="Medium" GroupName="Probablity" ClientIDMode="Static"   runat="server" />
                        <asp:RadioButton ID="rdoHigh" Text="High" GroupName="Probablity" ClientIDMode="Static"   runat="server" />
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
                        Source:<span style="color:red">*</span>
                    </th>
                    <td class="tVt" colspan="3" nowrap>
                        <asp:DropDownList ID="lstSource" ClientIDMode="Static" onchange="lstSource_onChange();"  runat="server"></asp:DropDownList>
                        <asp:DropDownList ID="lstCampaign" ClientIDMode="Static" runat="server"  onchange="lstCampaign_onchange();"></asp:DropDownList><!--CODE_TAG_103933-->
                        <asp:HiddenField ID="hdnlstCampaignSelected" ClientIDMode="Static" Value="" runat="server"  /><!--CODE_TAG_103933-->
                    </td>
                </tr>
                <tr id="trOppMore" runat="server" clientidmode="Static">
                    <th class="tVt">
                        Status:
                    </th>
                    <td class="tVt">
                        <asp:Label ID="lblOppStatus" runat="server" ClientIDMode="Static"></asp:Label>
                    </td>
                    <th class="tVt">
                        <asp:Label ID="lblOppReasonTitle" runat="server" ClientIDMode="Static" Text="Reason:"></asp:Label>
                    </th>
                    <td class="tVt">
                        <asp:DropDownList ID="lstOppReason" runat="server" ClientIDMode="Static">
                        </asp:DropDownList>
                    </td>
                    <th class="tVt">
                        Comment:
                    </th>
                    <td colspan="3">
                        <asp:TextBox ID="txtOppComment" runat="server" TextMode="MultiLine" Rows="3" Style="width: 100%"></asp:TextBox>
                    </td>
                </tr>
            </table>
        </fieldset>
        <fieldset style="display: <%= (IsNewQuote) ?"":"none"  %>">
            <legend>Segment</legend>
            <iframe src="NewSegment.aspx?TT=iframe&&Mode=NewQuote" width="100%" height="100%"
                frameborder="0"></iframe>
        </fieldset>
        <table width="100%">
            <tr>
                <td style="text-align: right">
                    <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" OnClientClick="return validation();" />
                    <input type="button" value="Cancel" onclick="btnCancel_onclick();" />
                </td>
            </tr>
        </table>
        <asp:HiddenField ID="hidRefreshParent" Value="" runat="server" />
        <asp:HiddenField ID="hdnInfList" Value="" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hdnCommodityList" Value="" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hdnCampaignList" Value="" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hdnOppReasonList" Value="" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hdnOppNo" Value="" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hdnNewOppDefaultValue" Value="" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidSelectContact" Value="" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidDivision" Value="" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="hidSelectedCommodityId" Value="" ClientIDMode="Static" runat="server" />  <%-- <CODE_TAG_101544>--%>
        <asp:HiddenField ID="hidStageType" Value="" ClientIDMode="Static" runat="server" />         <%--<CODE_TAG_105235> lwang--%>
    </div>
    <span id="spanWaitting" style='position: absolute;top:40%;left:50%; display:none'><img id="spanWaittingImg" src='' /></span>
    <div id="divErrors">
        <div id="divErrorsContent">
        </div>
    </div>
    <script type="text/javascript">
        var SegmentHasProspectCust = "<%= SegmentHasProspectCust %>";
        var DisplayLastSMU='<%= AppContext.Current.AppSettings["psQuoter.Header.SMU.LastTimeValue.Display"].ToString() %>';
        var lstCampaignSelected0 = "<%=strLstCampaignSelected %>";  //<CODE_TAG_103933>
        //<CODE_TAG_104057>
        var rowDelimiter = "<%=  Helpers.DataDelimiter.MatrixDataDelimeter.influencer_RowDelimiter %>";
        var colDelimiter = "<%= Helpers.DataDelimiter.MatrixDataDelimeter.influencer_ColumnDelimiter %>";
        //</CODE_TAG_104057>
        $(function () {
            $("#txtPromiseDate").attr("readonly", true);
            $("#txtUnittoArriveDate").attr("readonly", true);
            $("#txtSMULastRead").attr("readonly", true);
            //lstSource_onChange();// <CODE_TAG_102024>
            //<CODE_TAG_103933>
            var lstCampaignSelected = $("#lstCampaign").val() 
            //firstLoad = true; 
            lstSource_onChange(lstCampaignSelected);// <CODE_TAG_102024>
            //</CODE_TAG_103933>
            $("#txtPrintQuoteDate").attr("readonly", true); //<!--CODE_TAG_103674-->

            if ($('[id*=hidRefreshParent]').val() == "1")
                parent.document.location.href = parent.document.location.href.replace("&SegmentEdit=0", "&SegmentEdit=1");

            $("#txtPromiseDate" ).datepicker({ dateFormat: "M d, yy", showOn: "button", buttonImage: "../../../library/images/Calendar_scheduleHS.gif", buttonImageOnly: true }); 
            $("#txtUnittoArriveDate" ).datepicker({ dateFormat: "M d, yy", showOn: "button", buttonImage: "../../../library/images/Calendar_scheduleHS.gif", buttonImageOnly: true }); 
            $("#txtSMULastRead" ).datepicker({ dateFormat: "M d, yy", showOn: "button", buttonImage: "../../../library/images/Calendar_scheduleHS.gif", buttonImageOnly: true }); 
            $("#txtPrintQuoteDate" ).datepicker({ dateFormat: "M d, yy", showOn: "button", buttonImage: "../../../library/images/Calendar_scheduleHS.gif", buttonImageOnly: true }); //<!--CODE_TAG_103674-->
            //parent.refreshPage();                
        });

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

        }

        function lstDivision_onChange() {

            //<CODE_TAG_104784>
            var callId = $("#lstDivision").find('option:selected').attr("CallId");
            var CustomerLoyaltyIndicator = $("#lstDivision").find('option:selected').attr("CustomerLoyaltyIndicator");
            LoadCustomerLoyaltyIndicator(CustomerLoyaltyIndicator, callId);
            //</CODE_TAG_104784>

            reloadInfluencerList();
            reloadCampaignList();
            reloadStageType();  //<CODE_TAG_105235> lwang
        }

        // <CODE_TAG_105235> lwang
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
        // </CODE_TAG_105235> lwang

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

        }*/

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
                    //<CODE_TAG_102211>
                    influencerPhoneNo = arrStr[4].replace(/&#45;/g ,"-");
                    influencerFaxNo = arrStr[5].replace(/&#45;/g ,"-");
                    influencerEmail = arrStr[6].replace(/&#45;/g ,"-");
                    //</CODE_TAG_102211>
                    if (division == currentDivision && influencerId == currentInfluencerId && influencerType == currentInfluencerType) {
                        $('#txtPhoneNo').val(influencerPhoneNo);
                        $('#txtFax').val(influencerFaxNo);
                        $('#txtEmail').val(influencerEmail);
                    }
                });
            }
        }

        function btnCancel_onclick() {
            parent.closeEditHeader();
            //parent.closeAddNewQuote();
        }

        function openCustomerSearch() {
            parent.showCustomerSearch();
        }

        function AddCustomer(sCustomerNo, sCustomerName) {
        //function AddCustomer(sCustomerNo, sCustomerName, sCustomerLoyaltyIndicator) {  //<CODE_TAG_104784>
            //$("[id*=lblCustomer]").html(sCustomerNo + "-" + sCustomerName);
            //$("#lblCustomer").html(sCustomerNo + "-" + sCustomerName);//<CODE_TAG_104784> //<CODE_TAG_105153> Lwang
            $("[id$=lblCustomer]").html(sCustomerNo + "-" + sCustomerName); //<CODE_TAG_105153> Lwang
            $("#hidCustomerNo").val(sCustomerNo);
            $("#hidCustomerName").val(sCustomerName);
            //LoadCustomerLoyaltyIndicator(customerLoyaltyInd); //<CODE_TAG_104784>
        }

        function AddDivisionList(array_divisionList) {
            var oDivisionList = array_divisionList.split(",");
            $("#lstDivision").html("");
            $("<option value=''></option>").appendTo("#lstDivision");
            $.each(oDivisionList, function (index, value) {
                var oDivisionInfo = value.split("|");
                //$("<option value='" + oDivisionInfo[0] + "'>" + oDivisionInfo[0] + " - " + oDivisionInfo[1] + "</option>").appendTo("#lstDivision");
                $("<option value='" + oDivisionInfo[0] + "' CustomerLoyaltyIndicator='" + oDivisionInfo[4] + "'" + " CallId='" + oDivisionInfo[5] + "' " + ">" + oDivisionInfo[0] + " - " + oDivisionInfo[1] + "</option>").appendTo("#lstDivision"); //<CODE_TAG_104784>
            });
        }

        function AddInfluencerList(array_influencerList) {
            array_influencerList = array_influencerList.replace(/-/g ,"&#45;");
            //var oInfluencerList = array_influencerList.split(",");
            //var oInfluencerList = array_influencerList.split("~"); //<CODE_TAG_103327.>
            var oInfluencerList = array_influencerList.split(rowDelimiter); //<CODE_TAG_104057>
            var strInfluencerList = "";
            $.each(oInfluencerList, function (index, value) {
                //var arrStr = value.split("|");
                var arrStr = value.split(colDelimiter);  //<CODE_TAG_104057>
                var division = Trim(arrStr[6]);
                var influencerId = Trim(arrStr[5]);
                var influencerType = Trim(arrStr[4]);
                var influencerName = Trim(arrStr[0]);
                var influencerPhoneNo = Trim(arrStr[1]);
                // <CODE_TAG_103327>
                //influencerPhoneNo= (influencerPhoneNo!=undefined && influencerPhoneNo !=null && influencerPhoneNo!="")?influencerPhoneNo.replace(/-/g,"@").replace("&#44;",","):""; //<CODE_TAG_103328>
                influencerPhoneNo= (influencerPhoneNo!=undefined && influencerPhoneNo !=null && influencerPhoneNo!="")?influencerPhoneNo.replace(/-/g,"@"):""; //<CODE_TAG_103328>
                //var influencerFax = Trim(arrStr[2]);
                // <CODE_TAG_103327>
                var influencerFax = Trim(arrStr[2]);
                influencerFax = (influencerFax!='undefined' && influencerFax!=null)? influencerFax = influencerFax.replace(/-/g,"@"): ""; 
                // </CODE_TAG_103327>
                var influencerEmail = Trim(arrStr[3]);
                if (strInfluencerList != "") strInfluencerList += String.fromCharCode(5);
                strInfluencerList += division + "-" + influencerId + "-" + influencerType + "-" + influencerName + "-" + influencerPhoneNo + "-" + influencerFax + "-" + influencerEmail;
            });
            $("#hdnInfList").val(strInfluencerList);
        }

        function AddEquipment(eq_Model, eq_SerialNumber, eq_EquipManufCode, eq_EquipmentNumber, sEQ_IdNumber, sEQ_ServiceMeter, sEQ_ServiceMeterInd, sEQ_ServiceMeterDate, sEQ_PromiseDate, sEQ_ArriveDate) {
            //$("#txtMake").val(eq_EquipManufCode);
            var cur_ServiceMeterInd = "";
            $("#lstMake").val(eq_EquipManufCode);
            $("#txtModel").val(eq_Model);
            $("#txtSerialNo").val(eq_SerialNumber);
            $("#txtUnitNo").val(eq_EquipmentNumber);
            $("#txtStockNo").val(sEQ_IdNumber);

            if (sEQ_ServiceMeterInd == "H") cur_ServiceMeterInd = "1";
            if (sEQ_ServiceMeterInd == "K") cur_ServiceMeterInd = "2";
            if (sEQ_ServiceMeterInd == "M") cur_ServiceMeterInd = "4";

             if (DisplayLastSMU == '2')
            {
                 if (sEQ_ServiceMeter != null && $.trim(sEQ_ServiceMeter) != "" )
                    $("#hidLastTimeSMUValue").val(sEQ_ServiceMeter);
                else
                    $("#hidLastTimeSMUValue").val("0");

                if (cur_ServiceMeterInd != null && $.trim(cur_ServiceMeterInd) != "" )
                {
                    $("#hidLastTimeSMUIndicator").val(cur_ServiceMeterInd);
                    $("#lstSMUIndicator").val(cur_ServiceMeterInd);
                }
                else
                    $("#hidLastTimeSMUIndicator").val("");

                if (sEQ_ServiceMeterDate != null)
                    $("#hidLastTimeSMUDate").val(sEQ_ServiceMeterDate);
                else
                    $("#hidLastTimeSMUDate").val("");
                 $("#lblLastSMUValue").html(sEQ_ServiceMeter + "(" + sEQ_ServiceMeterInd + ") " + sEQ_ServiceMeterDate );

                 $("#txtSMU").val("");
                $("#lstSMUIndicator").val("");
                $("#txtSMULastRead").val("");
            }
            else
            {
                $("#txtSMU").val(sEQ_ServiceMeter);
                $("#lstSMUIndicator").val(cur_ServiceMeterInd);
                $("#txtSMULastRead").val(sEQ_ServiceMeterDate);
            }
            // <CODE_TAG_103412>
            <% 
            if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.PromiseDateClear")) 
             { %> //</CODE_TAG_103412>
            
            //if (sEQ_PromiseDate != null)
            if ( sEQ_PromiseDate != null && sEQ_PromiseDate.trim()!= "")  //<Ticket 36540>
                $("#txtPromiseDate").val(sEQ_PromiseDate);
            //if (sEQ_ArriveDate != null)
            if (sEQ_ArriveDate != null && sEQ_ArriveDate.trim() != "")  //<Ticket 36540>
                $("#txtUnittoArriveDate").val(sEQ_ArriveDate);
                
                <%} %> //</CODE_TAG_103412>
            
        }

        function SetDivision(selectedDivision) {
            $("#lstDivision").val(selectedDivision);
            reloadInfluencerList();
            getExistingOpplist();
            //TODO:   
            //if (document.all['hdnRefreshAllSegmentPrice'].value=="1")
            //{  
            //   RefreshCatPrice();
            //}
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

        function AddOpportunityList(array_OpportunityList) {
        }

        function lstQuoteType_onChange() {
            $("#lstOppType").find("option:contains('" + $("#lstQuoteType").val() + "')").each(function () {

                if ($(this).text() == $("#lstQuoteType").val()) {

                    $(this).attr("selected", "selected");

                }
            });

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
            getExistingOpplist();

        }

        function reloadInfluencerList() {
            var division;
            var influencerId;
            var influencerType;
            var influencerName;
            var influencerPhoneNo;
            var influencerFax;
            var influencerEmail

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
                    influencerFax = arrStr[5];
                    influencerEmail = arrStr[6];
                    if (division == currentDivision)
                        $('#lstContact').append($('<option></option>').val(division + "-" + influencerId + "-" + influencerType + "-" + influencerName).html(influencerName));

                });
            }

        }
        //<CODE_TAG_103933>
        function lstCampaign_onchange() {
            var campaignSelected = $("#lstCampaign option:selected").val();
            $("#hdnlstCampaignSelected").val(campaignSelected);

        }
        //</CODE_TAG_103933>
        //function lstSource_onChange() {
        function lstSource_onChange( lstCampaignSelected ) {  //<CODE_TAG_103933>
            if ($("#lstSource").val() == "1") {
                $("#lstCampaign").show();
                //reloadCampaignList();
                //<CODE_TAG_103933>
                if (lstCampaignSelected == null) //when no select option pass in, use previous value from Db
                        {lstCampaignSelected = lstCampaignSelected0;} 
                reloadCampaignList(lstCampaignSelected); 
                //</CODE_TAG_103933>
            }
            else {
                $("#lstCampaign").hide();
            }
        }
        //function reloadCampaignList() {
        function reloadCampaignList(lstCampaignSelected) { //<CODE_TAG_103933>
            var currentDivision = $("#lstDivision").val();
            //var currentOppTypeId = parseInt($("#lstOppType :selected").text());// comment out for <CODE_TAG_102024> 
            var currentOppTypeId = parseInt($("#lstOppType :selected").val());//<CODE_TAG_102024>
            $("#lstCampaign").html("");

            $("<option value=''></option>").appendTo("#lstCampaign");
            var arrCampaignList = $("#hdnCampaignList").val().split(String.fromCharCode(5));
            $.each(arrCampaignList, function (index, value) {
                var arrStr = value.split("|");
                var campaignId = arrStr[0];
                var campaignName = arrStr[1];
                var oppTypeId = arrStr[2];
                var division = arrStr[3];

                if (division == currentDivision && oppTypeId == currentOppTypeId)
                    $("<option value='" + campaignId + "'>" + campaignName + "</option>").appendTo("#lstCampaign");
            });
            //<CODE_TAG_103933>
              //if (firstLoad) {
                $("#lstCampaign").val(lstCampaignSelected);
                //firstLoad = false;
              //}
            //</CODE_TAG_103933>

        }


        function lstQuoteStatus_onChange() {
            var quoteStatusId = $("#lstQuoteStatus").val();
            if (quoteStatusId == 1 || quoteStatusId == 2) {
                $("#trOppMore").hide();
                return;
            }

            $("#trOppMore").show();
            var currentStageId = "";
            var oppStatusDesc = "";
            switch (quoteStatusId) {
                case "1":
                    oppStatusDesc = "Development";
                    currentStageId = "4";
                    break;
                case "2":
                    oppStatusDesc = "Proposal";
                    currentStageId = "8";
                    break;
                case "4":
                    oppStatusDesc = "Won";
                    currentStageId = "16";
                    break;
                case "8":
                    oppStatusDesc = "Lost";
                    currentStageId = "32";
                    break;
                case "16":
                    oppStatusDesc = "No Deal";
                    currentStageId = "64";
                    break;
                default:
                    oppStatusDesc = "Development";
                    currentStageId = "4";
            }

            $("#lblOppStatus").html(oppStatusDesc);
            if (quoteStatusId == "4") {
                $("#lblOppReasonTitle").hide();
                $("#lstOppReason").hide();
            }
            else {
                $("#lstOppReason").html("");
                $("<option value=''></option>").appendTo("#lstOppReason");
                var arrOppReasonList = $("#hdnOppReasonList").val().split(String.fromCharCode(5));
                $.each(arrOppReasonList, function (index, value) {
                    var arrStr = value.split("|");
                    var reasonId = arrStr[0];
                    var reasonName = arrStr[1];
                    var stageId = arrStr[2];

                    // Ticket 11488 should be bitwise and instead of ==
                    //if (stageId == currentStageId)
                    if ((stageId & currentStageId) > 0)
                        $("<option value='" + reasonId + "'>" + reasonName + "</option>").appendTo("#lstOppReason");
                });
                $("#lblOppReasonTitle").show();
                $("#lstOppReason").show();
            }
        }

        function validation() {
            var errorCount = 0;
            var strError = "";
            // validation

            if ($("#lstQuoteStatus").val() == "") {
                alert("Please select quote status.");
                strError += "Please select quote status.";
                $("#lstQuoteStatus").focus();
                errorCount++;
                //return false;
            }

            if ($("#lstQuoteType").val() == "") {
                alert("Please select quote type.");
                strError += "Please select quote type.";
                $("#lstQuoteType").focus();
                errorCount++;
                //return false;
            }

            if ($("#lstBranch").val() == "") {
                alert("Please select a branch.");
                strError += "Please select a branch.";
                $("#lstBranch").focus();
                errorCount++;
                //return false;
            }

            <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.Description.Show") &&  AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.Description.Required")  )
                 { %>
            if ($.trim($("#txtDescription").val()) == "") {
                alert("Please enter description.");
                strError += "Please enter description.";
                $("#txtDescription").focus();
                errorCount++;
                //return false;
            }
            
               <%} %>

            <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.JobControlCode.Required") )
                 { %>
            if ($.trim($("#txtJobControlCode").val()) == "") {
                alert("Please enter job control Code.");
               // strError += "Please enter description.";
                $("#txtJobControlCode").focus();
                errorCount++;
                return false;
            }
            <% } %>

            if ($("#lstDivision").val() == "") {
                alert("Please select a division.");
                strError += "Please select a division.";
                $("#lstDivision").focus();
                errorCount++;
                //return false;
            }

            if ($("#lstSalesRep").val() == "") {
                alert("Please select a sales rep.");
                strError += "Please select a sales rep.";
                $("#lstSalesRep").focus();
                errorCount++;
                //return false;
            }


             //Opp validation

            if ($("#tblHasOpportunity").is(':visible'))
            {
                if ($("#lstEstDeliveryYear").val() == "") {

                alert("Please select a estimated delivery year.");
                errorCount++;
                return false;
                }

                if ($("#lstEstDeliveryMonth").val() == "") {
                alert("Please select a estimated delivery month.");
                errorCount++;
                return false;
                }


                if (! ($("#rdoLow").is(':checked') || $("#rdoMedium").is(':checked') || $("#rdoHigh").is(':checked')))
                {
                    alert("Please select a probability of closing.");
                    errorCount++;
                    return false;
                }

                 <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Opportunity.Commodity.Mandatory"))
                    { %>
                          
                     if ($("#lstCommodity").val() == "") {
                    alert("Please select a commodity.");
                    errorCount++;
                    return false;
                }
                <% } %>
                

                 if ($("#lstSource").val() == "") {
                    alert("Please select a source.");
                    errorCount++;
                    return false;
                 }
                // <CODE_TAG_105411>
                 if (($("#lstSource").val() == "1") && ($("#lstCampaign").val() == "")) {
                     alert("Please select a campaign.");
                     errorCount++;
                     return false;
                 }
                // </CODE_TAG_105411>
            }



            if ($("#lstQuoteStatus").val() == "4" && SegmentHasProspectCust == "1") {

                alert("Please change prospect customer to DBS customer in all segments of the current revision before change quote status to won.");
                strError += "Please change prospect customer to DBS customer in all segments of the current revision before change quote status to won."
            }

            if ($("#lstQuoteStatus").val() == "4" && $("#hidCustomerNo").val().substring(0, 1) == "$") {

                alert("Please change prospect customer to DBS customer before change quote status to won.");
                strError += "Please change prospect customer to DBS customer before change quote status to won."
            }



           //SMU
            if (DisplayLastSMU == "2")
            {
                if ( $("#hidLastTimeSMUValue").val() != "0" && $.trim($("#txtSMU").val()) != "" )
                {
                    var lastSMUValue = parseFloat($("#hidLastTimeSMUValue").val());
                    var NewSMUValue = parseFloat($("#txtSMU").val());

                    if (NewSMUValue < lastSMUValue)
                    {   //<CODE_TAG_103502> 
                        //alert("The SMU Value cannot be lower than the last known SMU value.");
                        confirm("The SMU Value should not be lower than the last known SMU value. Are you sure to continue?");
                            $("#txtSMU").focus();
                            //errorCount++;
                        //return false;
                    }
                }

                if ($.trim($("#txtSMU").val()) != "" && $("#lstSMUIndicator").val() == "")
                 {
                        alert("The SMU Indicator cannot be blank.");
                        errorCount++;
                        return false;
                 }
                
                
                //if ( $("#hidLastTimeSMUIndicator").val() != "") 
                if ( $("#hidLastTimeSMUIndicator").val() != "" && $("#lstSMUIndicator").val()!="") 
                {
                   if ($("#hidLastTimeSMUIndicator").val() != $("#lstSMUIndicator").val())
                    {
                        alert("The SMU Indicator doesn't match the last known SMU Indicator.");
                        errorCount++;
                        return false;
                    }
                }

                if ( $("#hidLastTimeSMUDate").val() != "" &&  $("#txtSMULastRead").val() != "")
                {
                    var oldSMUDate = new Date($("#hidLastTimeSMUDate").val()).toISODateString(); // <CODE_TAG_104986>
                    var newSMUDate = new Date($("#txtSMULastRead").val()).toISODateString(); // <CODE_TAG_104986>
                    var todayDate = new Date().toISODateString(); // <CODE_TAG_104986>

                   if (oldSMUDate >newSMUDate)
                    {
                        alert("The SMU Date cannot backdate the last known SMU Date.");
                        errorCount++;
                        return false;
                    }
                    if (newSMUDate > todayDate)
                    {
                        alert("The SMU Date cannot be future date.");
                        errorCount++;
                        return false;
                    }
                }

                //<CODE_TAG_104769>
                //check Existing Opp list
                if ($("#rdbtnNewOrExistingOpportunity_1").prop("checked")) {
                    if ($("#lstOppList").val() == undefined || $("#lstOppList").val() == "")
                    {
                        alert("Please select an Existing Opp No.");
                        return false;
                    }
                    

                }
                //</CODE_TAG_104769>



            }






            if (strError == "")
            {
                $("#hidSelectContact").val($("#lstContact").val()); 
                $("#hidDivision").val($('#lstDivision').val() );
                $("#hidSelectedCommodityId").val($('#lstCommodity').val());  // <CODE_TAG_101544>
                $("#spanWaitting").show();
                $("#spanWaitting img").attr("src", "../../../Library/images/waiting.gif");
                return true;
                }
            else {
                //showErrors(strError);
                return false;
            }
        }

        function setupDeliveryDate(sender, args) {
            var selectedDate = sender.get_selectedDate();
            //sundayDate = getSundayDateUsingYourAlgorithm(selectedDate);      
            //sender.set_SelectedDate(sundayDate);  
            var month = selectedDate.getMonth() + 1;
            var year = selectedDate.getFullYear();

            $("#lstEstDeliveryYear").val(year);
            $("#lstEstDeliveryMonth").val(month);
        }
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
            if (selectedValue == 1) { 
                setupNewOppDefaultValue();
                $("#lstOppList").hide();
            } else { 
                $("#lstOppList").show();
                getExistingOpplist();
            }

        }
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

                if ((curQuoteTypeId == quoteTypeId) > 0) {
                    $("#lstOppType").val(OppTypeId);
                    lstOppType_onChange();
                    $("#lstSource").val(DefaultOppSourceId);
                    if (DefaultOppProbabilityOfClosing == "1") $("#rdoLow").attr('checked', true);
                    if (DefaultOppProbabilityOfClosing == "2") $("#rdoMedium").attr('checked', true);
                    if (DefaultOppProbabilityOfClosing == "4") $("#rdoHigh").attr('checked', true);
                }

            });

            getExistingOpplist();

        }
        var arrExistingOppList = "";
        function getExistingOpplist() {
            if ($("#hdnOppNo").val() != "")
                return;

            var cuno = $("#hidCustomerNo").val();
            var division = $("#lstDivision").val();
            var quoteTypeId = $("#lstQuoteType").val();
            $.ajax({
                url: "../QuoteAjaxHandler.ashx?op=OPPLIST&cuno=" + cuno + "&division=" + division + "&QuoteTypeId=" + quoteTypeId,
                type: "GET",
                cache: false,
                async: false,
                success: function (htmlContent) {
                    arrExistingOppList = "";
                    if (htmlContent != "") {
                        arrExistingOppList = htmlContent.split(String.fromCharCode(5));
                    }

                    $("#lstOppList").html("");
                    $("<option value=''>please select Existing Opp No.</option>").appendTo("#lstOppList");//<CODE_TAG_104769>
                    $.each(arrExistingOppList, function (index, value) {
                        var arrStr = value.split("|");
                        var oppNo = arrStr[0];
                        var DeliveryYear = arrStr[1];
                        var oppDesc = unescape(arrStr[6]);

                        $("<option value='" + oppNo + "'>" + oppNo + " - " +oppDesc + "</option>").appendTo("#lstOppList");
                    });

                }
            });

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

        //Set PSSR as the Quote Owner in lstSalesRep dropdown list 
        //<CODE_TAG_103528>
        var strIsLoginUserSalesRep = "<%= strIsLoginUserSalesRep %>";
        var isPSSRExist = false;
        function ProcessQuoteOwner(strPSSRXUId)
        {
            <%if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.SalesRep.SetPSSRAsQuoteOwner"))
            { %>
                if (strIsLoginUserSalesRep==1) //quote creator is not a sales rep
                 {
                    //set the quote owner to pssr here
                    SetQuoteOwnerToPSSR(strPSSRXUId);
                 }
                 else
                 {
                    //do nothing
                 }
           <%  }
             else
             { %>
                SetQuoteOwnerToPSSR(strPSSRXUId);
           <%   } %>
        }
        function SetQuoteOwnerToPSSR(strPSSRXUId)
        {//set the current customer's PSSR as the quote owner
            CheckPSSRExist(strPSSRXUId);
            //if (isPSSRExist && isPSSRExist==false) return;  //when PSSR not exists in the quote owner drop down list, not set, just return.
            if ( isPSSRExist==false) return;  //when PSSR not exists in the quote owner drop down list, not set, just return.
            if (strPSSRXUId) 
            {//to do here
                $("#lstSalesRep").val(strPSSRXUId);
            }
        }
        function CheckPSSRExist(strPSSRXUId)
        {
            isPSSRExist = false;
            $("#lstSalesRep option").each(function(){

                if ($(this).val()==strPSSRXUId) 

                {
                  isPSSRExist = true;
                  return;

                }
            } );
        }
        //</CODE_TAG_103528>
        var strOwnersList = "<%= strOwnersList %>";

        function lstSalesRep_onChange()
        {
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

                if (userId == salesrepXUID){
                       $("#txtSalesrepPhone").val(phone);
                       $("#txtSalesrepCellPhone").val(cellPhone);
                       $("#txtSalesrepFax").val(fax);
                }
            });


        }


        $(document).ready(function () {
            if (/iPhone|iPod|iPad/.test(navigator.userAgent))
                $('#wrapper').css({
                    'overflow-y': 'scroll',
                    'overflow-x': 'hidden',
                    '-webkit-overflow-scrolling': 'touch',
                    height: $(parent.document.getElementById("divQuoteHeaderEdit")).height(),
                    width: $(parent.document.getElementById("divQuoteHeaderEdit")).width()
                });
        });

        //<CODE_TAG_104742>
        var serialNo_Old;
        var serialNo_New;
        serialNo_Old = $("#txtSerialNo").val();
        function txtSerialNo_onClick() {
            serialNo_Old = $("#txtSerialNo").val();
        }
        function txtSerialNo_onBlur() {
            <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.Equipment.ResetEquipInfoWhenSerialNoChanged")) { %>
                    serialNo_New = $("#txtSerialNo").val();
                    if (serialNo_Old != serialNo_New) {
                        //alert("changed");
                        $("#txtModel").val("");
                        $("#txtStockNo").val("");
                        $("#txtUnitNo").val("");
                        $("#txtSMU").val("");
                        $("#txtSMULastRead").val("");
                        $("#lblLastSMUValue").val("");
                        $("#lstSMUIndicator").val("");

                    }
            <% } %>
        }
        //</CODE_TAG_104742>
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
    </script>
</asp:Content>
