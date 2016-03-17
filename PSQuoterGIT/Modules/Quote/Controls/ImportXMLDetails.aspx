<%@ Page Title="" Language="C#" MasterPageFile="~/Library/MasterPages/iFrame.master"
    AutoEventWireup="true" CodeFile="ImportXMLDetails.aspx.cs" Inherits="ImportXMLDetails" %>
    <%@ Import Namespace="System.Data" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cntMP" runat="Server">
<div id="divSearchbleList" style="position: absolute; background-color: White; display: none;
        z-index: 1000">
        <div>The charge code from the work order is not valid, please choose another one charge code and select OK.  Click on cancel to not import this item to the estimate.</div>
    </div>
       <div id="tabs" style="width:750px">
        <ul>
            <li style="display:<% = (HasLaborDetail == 2)? "":"none"%> "><a href="#tabs_Labor">Labor</a></li>
            <li style="display:<% = (HasMiscDetail == 2)? "":"none"%> "><a href="#tabs_Misc" >Misc</a></li>
        </ul>
        <div id="tabs_Labor" >
            <table width="100%">
                <tr style="border-bottom:1px solid black">
                    <th style="width:5%;font-weight:bold;"></th>
                    <th style="width:40%;font-weight:bold;">
                        Charge Code (LCC-LC-ST-CC)
                    </th>
                    <th class='tAr' style="width:5%;font-weight:bold;">
                        Qty
                    </th>
                    <th class='tAc' style="width:15%;font-weight:bold;">
                        Rate Type
                    </th>
                    <th class='tAr' style="width:10%;font-weight:bold;">
                        Unit Price
                    </th>
                    <th class='tAr' style="width:10%;font-weight:bold;">
                        Sell Price
                    </th>
                    <th class='tAr' style="display:<%= (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.Discount.Show"))?"":"none" %>; width:5%;font-weight:bold;">
                        Disc
                    </th>
                    <th class='tAr' style="width:10%;font-weight:bold;">
                        Ext Price
                    </th>
                </tr>
                <asp:Repeater ID="rptLabor" runat="server" >
                <ItemTemplate>
                    <tr style="<%# ( ((DataRow)Container.DataItem)["ItemId"].AsInt(0) % 2 == 0) ?"": "background-color:White"   %>">
                        <td>
                            
                        </td>
                        <td>
                            <%#  ((DataRow)Container.DataItem)["chargeCode"].ToString() %> (<%#  ((DataRow)Container.DataItem)["Description"].ToString()%>)
                        </td>

                        <td class="tAr">
                            <%#  ((DataRow)Container.DataItem)["Qty"].ToString() %>
                        </td>
                        <td class="tAl">
                            &nbsp;&nbsp;<%#  ( ((DataRow)Container.DataItem)["Rate"].ToString() == "CPTR")?"Premium":   (( ((DataRow)Container.DataItem)["Rate"].ToString() == "COTR")?"Overtime":    "Regular"   )                 %>
                        </td>
                        <td class="tAr">
                            <%#   Util.NumberFormat(((DataRow)Container.DataItem)["UnitSellPrice"].AsDouble(0), 2, null, null, null, null)   %>
                        </td>
                        <td class="tAr">
                             <%#   Util.NumberFormat(((DataRow)Container.DataItem)["UnitPrice"].AsDouble(0), 2, null, null, null, null)   %>
                        </td>
                        <td class="tAr" style="display:<%# (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.Discount.Show"))?"":"none" %>">
                             <%#   Util.NumberFormat(((DataRow)Container.DataItem)["discount"].AsDouble(0), 2, null, null, null, null)   %>
                        </td>
                        <td class="tAr">
                            <%#   Util.NumberFormat(((DataRow)Container.DataItem)["ExtendedPrice"].AsDouble(0), 2, null, null, null, null)%>
                        </td>
                    </tr>
                    <tr  id="trLabor<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>" style="border-bottom:1px solid black;<%# ( ((DataRow)Container.DataItem)["ItemId"].AsInt(0) % 2 == 0) ?"": "background-color:White"   %> ">
                        <td>
                        <input type="checkbox" checked="checked" />
                        </td>
                        <td style=" white-space:nowrap ">
                            <input type='hidden' id='hidItemId<%#  ((DataRow)Container.DataItem)["ItemId"].ToString() %>' name='hidItemId<%#  ((DataRow)Container.DataItem)["ItemId"].ToString() %>' value='<%#  ((DataRow)Container.DataItem)["ItemId"].ToString() %>'' /> <%--<CODE_TAG_101832>--%>
                            <input type='hidden' id='hidLaborChargeCode<%#  ((DataRow)Container.DataItem)["ItemId"].ToString() %>' name='hidLaborChargeCode<%#  ((DataRow)Container.DataItem)["ItemId"].ToString() %>' value='' />
                            <%--<CODE_TAG_105100> lwang
                                <input class='w90p' type='text' id='txtLaborItemNo<%#  ((DataRow)Container.DataItem)["ItemId"].ToString() %>' name='txtLaborItemNo<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>' onkeyup="txtSearchbleListKeyUp('txtLaborItemNo<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>', 'hidLaborChargeCode<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>', arrLaborChargeCode);"  value=""  />
                                <span onclick="displaySearchbleList('','txtLaborItemNo<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>', 'hidLaborChargeCode<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>' , arrLaborChargeCode);"  ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../../library/images/arrowdown.gif' /></span> --%>
                            <input class='w90p' type='text' id='txtLaborItemNo<%#  ((DataRow)Container.DataItem)["ItemId"].ToString() %>' name='txtLaborItemNo<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>' onkeyup="txtSearchbleListKeyUp('txtLaborItemNo<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>', 'hidLaborChargeCode<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>', arrLaborChargeCode, null, null, 'Y');"  value=""  />                              
                            <span onclick="displaySearchbleList('','txtLaborItemNo<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>', 'hidLaborChargeCode<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>' , arrLaborChargeCode, null, null,'Y');"  ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../../library/images/arrowdown.gif' /></span> 
                             <%--</CODE_TAG_105100>--%>
                            <input type='text' id='txtLaborDescription<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>' name='txtLaborDescription<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>' class='w90p' readonly='readonly' value='' style='display:none' />
                        </td>
                        <td class="tAr">
                            <input class='w90p tAr' type="text" id="txtLaborQty<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>" name="txtLaborQty<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>" onblur="AjaxHandler(<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>, 'PENDINGLABORCALCUALTE','Labor','Qty');"  value='<%# ((DataRow)Container.DataItem)["Qty"].ToString() %>' />
                        </td>
                        <td class="tAc">
                            <select class='w90p' id="lstLaborShift<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>" name="lstLaborShift<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>"  onchange='setupLaborChargeCode(<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>);'> <option value='CRTR'>Regular</option><option value='COTR'>Overtime</option><option value='CPTR'>Premium</option> </select>
                        </td>
                        
                        <td class="tAr">
                            <input class='w90p tAr' type="text" id="txtLaborUnitSellPrice<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>"  name="txtLaborUnitSellPrice<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>" readonly='readonly'/>
                        </td>
                        <td class="tAr">
                            <input class='w90p tAr' type="text" id="txtLaborUnitPrice<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>" name="txtLaborUnitPrice<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>" onblur="AjaxHandler(<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>, 'PENDINGLABORCALCUALTE','Labor','UnitPrice');"  readonly='readonly'/>
                        </td>
                        <td class="tAr" style="display:<%# (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.Discount.Show"))?"":"none" %>">
                            <input class='w90p tAr' type="text" id="txtLaborDiscount<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>" name="txtLaborDiscount<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>" onblur="AjaxHandler(<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>, 'PENDINGLABORCALCUALTE','Labor','Discount');"/>
                        </td>
                        <td class="tAr">
                            <input class='w90p tAr' type="text" id="txtLaborExtendedPrice<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>" name="txtLaborExtendedPrice<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>" readonly='readonly' />
                        </td>
                    </tr>
                </ItemTemplate> 
                </asp:Repeater>




            </table>
        </div>
        <div id="tabs_Misc">
             <table width="100%">
                <tr style="border-bottom:1px solid black">
                    <th style="width:5%;font-weight:bold;"></th>
                    <th style="width:40%;font-weight:bold;">
                        Charge Code (MCC-MC-ST-CC)
                    </th>
                    <th class='tAr' style="width:5%;font-weight:bold;">
                        Qty
                    </th>
                    <th class='tAr' style="width:15%;font-weight:bold;">
                        Unit Cost
                    </th>
                    <th class='tAr' style="width:10%;font-weight:bold;">
                        Markup%
                    </th>
                    <th class='tAr' style="width:10%;font-weight:bold;">
                        Unit Price
                    </th>
                    <th class='tAr' style="width:5%;font-weight:bold;">
                        Sell Price
                    </th>
                    <th class='tAr' style="width:10%;font-weight:bold;">
                        Ext Price
                    </th>
                </tr>
                <asp:Repeater ID="rptMisc" runat="server" >
                <ItemTemplate>
                    <tr style="<%# ( ((DataRow)Container.DataItem)["ItemId"].AsInt(0) % 2 == 0) ?"": "background-color:White"   %>">
                        <td>
                            
                        </td>
                        <td>
                            <%#  ((DataRow)Container.DataItem)["chargeCode"].ToString() %> (<%#  ((DataRow)Container.DataItem)["description"].ToString()%>)
                        </td>

                        <td class="tAr">
                            <%#  ((DataRow)Container.DataItem)["qty"].ToString() %>
                        </td>
                        <td class="tAr">
                            <%#   Util.NumberFormat(((DataRow)Container.DataItem)["unitCost"].AsDouble(0), 2, null, null, null, null)   %>
                        </td>
                        <td class="tAr">
                            
                        </td>
                        <td class="tAr">
                             <%#   Util.NumberFormat(((DataRow)Container.DataItem)["unitSell"].AsDouble(0), 2, null, null, null, null)   %>
                        </td>
                        <td class="tAr" >
                             <%#   Util.NumberFormat(((DataRow)Container.DataItem)["unitSell"].AsDouble(0), 2, null, null, null, null)   %>
                        </td>
                        <td class="tAr">
                            <%#   Util.NumberFormat(((DataRow)Container.DataItem)["extendedPrice"].AsDouble(0), 2, null, null, null, null)%>
                        </td>
                    </tr>
                    <tr  id="trMisc<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>" style="border-bottom:1px solid black;<%# ( ((DataRow)Container.DataItem)["ItemId"].AsInt(0) % 2 == 0) ?"": "background-color:White"   %> ">
                        <td>
                        <input type="checkbox" checked="checked" />
                        </td>
                        <td style=" white-space:nowrap ">
                            <input type='hidden' id='hidMiscItemId<%#  ((DataRow)Container.DataItem)["ItemId"].ToString() %>' name='hidMiscItemId<%#  ((DataRow)Container.DataItem)["ItemId"].ToString() %>' value='<%#  ((DataRow)Container.DataItem)["ItemId"].ToString() %>'' /> <%--<CODE_TAG_101832>--%>
                            <input type='hidden' id='hidMiscChargeCode<%#  ((DataRow)Container.DataItem)["ItemId"].ToString() %>' name='hidMiscChargeCode<%#  ((DataRow)Container.DataItem)["ItemId"].ToString() %>' value='' />
                            <%--<CODE_TAG_105100>  lwang--%>
                            <%--<input class='w90p' type='text' id='txtMiscItemNo<%#  ((DataRow)Container.DataItem)["ItemId"].ToString() %>' name='txtMiscItemNo<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>' onkeyup="txtSearchbleListKeyUp('txtMiscItemNo<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>', 'hidMiscChargeCode<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>', arrMiscChargeCode);"  value=""  />
                                <span onclick="displaySearchbleList('','txtMiscItemNo<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>', 'hidMiscChargeCode<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>' , arrMiscChargeCode);"  ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../../library/images/arrowdown.gif' /></span>--%>
                            <input class='w90p' type='text' id='txtMiscItemNo<%#  ((DataRow)Container.DataItem)["ItemId"].ToString() %>' name='txtMiscItemNo<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>' onkeyup="txtSearchbleListKeyUp('txtMiscItemNo<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>', 'hidMiscChargeCode<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>', arrMiscChargeCode, null, null, 'Y');"  value=""  />
                            <span onclick="displaySearchbleList('','txtMiscItemNo<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>', 'hidMiscChargeCode<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>' , arrMiscChargeCode, null, null, 'Y');"  ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../../library/images/arrowdown.gif' /></span>
                            <%--</CODE_TAG_105100>  lwang--%>
                            <input type='text' id='txtMiscDescription<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>' name='txtMiscDescription<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>' class='w90p' readonly='readonly' value='' style='display:none' />
                        </td>
                        <td class="tAr">
                            <input class='w90p tAr' type="text" id="txtMiscQty<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>" name="txtMiscQty<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>" onblur="AjaxHandler(<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>, 'PENDINGMISCCALCUALTE','Misc','Qty');"  value='<%# ((DataRow)Container.DataItem)["Qty"].ToString() %>' />
                        </td>
                        <td class="tAr">
                            <input class='w90p tAr' type="text" id="txtMiscUnitCostPrice<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>"  name="txtMiscUnitCostPrice<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>" onblur="AjaxHandler(<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>, 'PENDINGMISCUNITPRICE','Misc','UnitCost');"/>
                        </td>
                        <td class="tAr" >
                            <input class='w90p tAr' type="text" id="txtMiscUnitPercentRate<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>" name="txtMiscUnitPercentRate<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>" onblur="AjaxHandler(<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>, 'PENDINGMISCUNITPRICE','Misc','UnitPercentRate');"/>
                        </td>
                        <td class="tAr">
                            <input class='w90p tAr' type="text" id="txtMiscUnitSellPrice<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>"  name="txtMiscUnitSellPrice<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>" readonly='readonly'/>
                        </td>
                        <td class="tAr">
                            <input class='w90p tAr' type="text" id="txtMiscUnitPrice<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>" name="txtMiscUnitPrice<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>" onblur="AjaxHandler(<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>, 'PENDINGMISCCALCUALTE','Misc','UnitPrice');"  />
                        </td>
                        
                        <td class="tAr">
                            <input class='w90p tAr' type="text" id="txtMiscExtendedPrice<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>" name="txtMiscExtendedPrice<%# ((DataRow)Container.DataItem)["ItemId"].ToString() %>" readonly='readonly' />
                        </td>
                    </tr>
                </ItemTemplate> 
                </asp:Repeater>




            </table>
        </div>
    </div>
  <div style=" float:right; padding:5px 20px 0px 0px  ">
    <input type='button'  value='OK' onclick="btn_OK_onclick();" />
    <input type='button'  value='Cancel' onclick="btn_Cancel_onclick();" />
    <asp:HiddenField ID="hdnChargeCodeDisplay" runat="server" Value="" ClientIDMode="static" /> <%-- <CODE_TAG_105100> lwang--%>

    </div>
      <script type="text/javascript" >
          var strLaborChargeCodeList = "<%= LaborChargeCodeList %>";
          var arrLaborChargeCode = strLaborChargeCodeList.split(String.fromCharCode(5));
          var strMiscChargeCodeList = "<%= MiscChargeCodeList %>";
          var arrMiscChargeCode = strMiscChargeCodeList.split(String.fromCharCode(5));
          var callBacking = false;
          var laborSerializedData = "";
          var miscSerializedData = "";


          $(function () {
              $("#tabs").tabs( <% = (HasLaborDetail == 2)? "":"{selected: 1 }"%> );
              $(".ui-widget-header").removeClass("ui-widget-header");
          });
          
          function AjaxHandler(itemId, op, source, field) {
              if (field == null || field == "") field = "UNKNOW";

              if (callBacking == false) {
                  if (itemId != null) {
                      var serializedData;
                      switch (source) {
                          case "Labor":
                              serializedData = $("#trLabor" + itemId + " input[type!='button'], select").serialize();
                              if (laborSerializedData == serializedData) return;
                              break;

                          case "Misc":
                              serializedData = $("#trMisc" + itemId + " input[type!='button'], select").serialize();
                              if (miscSerializedData == serializedData ) return;  
                              break;
                      }
                      callBacking = true;

                      var request = $.ajax({
                          url: "../QuoteAjaxHandler.ashx?ItemID=" + itemId + "&op=" + op + "&source=" + source + "&field=" + field,
                          type: "POST",
                          data: serializedData,
                          cache: false,
                          async: false,
                          beforeSend: function () {
                              // displayWaitingIcon(source)
                          },
                          complete: function () {
                              //$("#spanLaborWaitting").hide();
                              callBacking = false;
                          },
                          success: function (htmlContent) {
                              var currentFocusedControlId = typeof (document.activeElement) == "undefined" ? "" : document.activeElement.id;
                              var rtOp = htmlContent.substr(0, 1);  // R: Replace   A: Alert   P: Popup
                              htmlContent = htmlContent.substr(2);
                              if (rtOp == "R") {
                                  switch (source) {
                                      case "Labor":
                                          $("#txtLaborExtendedPrice" + itemId).val(htmlContent);
                                          laborSerializedData = $("#trLabor" + itemId + " input[type!='button'], select").serialize();
                                          break;
                                      case "Misc":
                                          switch (op) {
                                              case "PENDINGMISCUNITPRICE":
                                                  var rtVal = htmlContent.split(String.fromCharCode(5));
                                                  $("#txtMiscUnitPrice" + itemId).val(rtVal[0]);
                                                  $("#txtMiscExtendedPrice" + itemId).val(rtVal[1]);
                                                  miscSerializedData = $("#trMisc" + itemId + " input[type!='button'], select").serialize();
                                                  break;

                                              case "PENDINGMISCCALCUALTE":
                                                  $("#txtMiscExtendedPrice" + itemId).val(htmlContent);
                                                  miscSerializedData = $("#trMisc" + itemId + " input[type!='button'], select").serialize();
                                                  break;
                                          }
                                          break;
                                      default:

                                  }

                              }

                              if (rtOp == "P") {
                                  switch (source) {
                                      case "Labor":

                                          break;
                                      case "Misc":

                                          break;
                                      default:
                                  }
                              }

                          },
                          error: function () { callBacking = false; }


                      });
                  }
              }
          }




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
                  strChargeCodeDesc = $.trim(strChargeCodeDesc.replace(strChargeCode + '-', ''));
                  strCRTR = arrStr[2];
                  strCOTR = arrStr[3];
                  strCPTR = arrStr[4];
                  <%--<CODE_TAG_105100>lwang--%>
                  //if (strChargeCode == chargeCode ) {
                  if (strChargeCode.substring(1, 3) == chargeCode.substring(1, 3)) {
                       <%--</CODE_TAG_105100>lwang--%>
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

                  }
              });
              AjaxHandler(itemId, 'PENDINGLABORCALCUALTE', 'Labor','ChargeCode');
          }

          function setupMiscChargeCode(itemId) {
              var arrStr;
              var strChargeCode, strChargeCodeDesc, strUnitPrice, strUnitCost, strPercentRate;
              var chargeCode = $("#hidMiscChargeCode" + itemId).val();

              $.each(arrMiscChargeCode, function (index, value) {
                  arrStr = value.split(",");
                  strChargeCode = arrStr[0];
                  strChargeCodeDesc = arrStr[1];
                  strChargeCodeDesc = strChargeCodeDesc.replace(strChargeCode + '-', '');
                  strUnitPrice = arrStr[2];
                  strUnitCost = arrStr[3];
                  strPercentRate = arrStr[6];
                   <%--<CODE_TAG_105100>lwang--%>
                  //if (strChargeCode == chargeCode) {
                  if (strChargeCode.substring(1,3) == chargeCode.substring(1,3)) {
                  <%--</CODE_TAG_105100>lwang--%>
                      $("#txtMiscDescription" + itemId).val(strChargeCodeDesc);
                      $("#txtMiscUnitSellPrice" + itemId).val(strUnitPrice);
                      $("#txtMiscUnitPrice" + itemId).val(strUnitPrice);
                      $("#txtMiscUnitCostPrice" + itemId).val(strUnitCost);
                      $("#txtMiscUnitPercentRate" + itemId).val(strPercentRate);
                  }
              });

              AjaxHandler(itemId, 'PENDINGMISCUNITPRICE', 'Misc', 'ChargeCode');
             
          }


        function btn_OK_onclick()
        {
            var strLabor = "";
            var strMisc = "";
            var tr;
            var chargeCode = "";
            var desc = "";
            var qty = "";
            var shift = "";
            var unitSellPrice = "";
            var unitPrice = "";
            var discount = "";
            var extPrice = "";
            var pct = "";
            var laborError = 0;
            var miscError = 0;
            //Labor
            $('#tabs_Labor input[type=checkbox]:checked').each(function () {
                tr = $(this).closest("tr");
                chargeCode = $(tr).find("[id*=hidLaborChargeCode]").val();
                newLaborItemId = $(tr).find("[id*=hidItemId]").val(); //<CODE_TAG_101832>
                desc = $(tr).find("[id*=txtLaborDescription]").val();
                qty = $(tr).find("[id*=txtLaborQty]").val();
                shift = $(tr).find("[id*=lstLaborShift]").val();
                unitSellPrice = $(tr).find("[id*=txtLaborUnitSellPrice]").val();
                unitPrice = $(tr).find("[id*=txtLaborUnitPrice]").val();
                discount = $(tr).find("[id*=txtLaborDiscount]").val();
                extPrice = $(tr).find("[id*=txtLaborExtendedPrice]").val();
                if (strLabor != "") strLabor += ",";
                
                strLabor += "{";
                strLabor += "\"chargeCode\":\"" + chargeCode + "\", ";
                strLabor += "\"newLaborItemId\":\"" + newLaborItemId + "\", ";  //<CODE_TAG_101832>
                strLabor += "\"desc\":\"" + desc + "\", ";
                strLabor += "\"qty\":\"" + qty + "\", ";
                strLabor += "\"shift\":\"" + shift + "\", ";
                strLabor += "\"unitSellPrice\":\"" + unitSellPrice + "\", ";
                strLabor += "\"unitPrice\":\"" + unitPrice + "\", ";
                strLabor += "\"discount\":\"" + discount + "\", ";
                strLabor += "\"extPrice\":\"" + extPrice + "\" ";
                strLabor += "}";
                if ($.trim(chargeCode) == "") laborError = 2;
            });
            if (strLabor != "") strLabor = "{\"data\":[" + strLabor + "]}";

            //Misc
            $('#tabs_Misc input[type=checkbox]:checked').each(function () {
                tr = $(this).closest("tr");
                newMiscItemId = $(tr).find("[id*=hidMiscItemId]").val(); //<CODE_TAG_101832>
                chargeCode = $(tr).find("[id*=hidMiscChargeCode]").val();
                desc = $(tr).find("[id*=txtMiscDescription]").val();
                qty = $(tr).find("[id*=txtMiscQty]").val();
                unitCostPrice = $(tr).find("[id*=txtMiscUnitCostPrice]").val();
                unitSellPrice = $(tr).find("[id*=txtMiscUnitSellPrice]").val();
                unitPrice = $(tr).find("[id*=txtMiscUnitPrice]").val();
                pct = $(tr).find("[id*=txtMiscUnitPercentRate]").val();
                extPrice = $(tr).find("[id*=txtMiscExtendedPrice]").val();
                if (strMisc != "") strMisc += ",";

                strMisc += "{";
                strMisc += "\"chargeCode\":\"" + chargeCode + "\", ";
                strMisc += "\"newMiscItemId\":\"" + newMiscItemId + "\", ";  //<CODE_TAG_101832>
                strMisc += "\"desc\":\"" + desc + "\", ";
                strMisc += "\"qty\":\"" + qty + "\", ";
                strMisc += "\"unitCostPrice\":\"" + unitCostPrice + "\", ";
                strMisc += "\"unitSellPrice\":\"" + unitSellPrice + "\", ";
                strMisc += "\"unitPrice\":\"" + unitPrice + "\", ";
                strMisc += "\"pct\":\"" + pct + "\", ";
                strMisc += "\"extPrice\":\"" + extPrice + "\" ";
                strMisc += "}";

                if ($.trim(chargeCode) == "") miscError = 2;
            });

            if (strMisc!="") strMisc = "{\"data\":[" + strMisc + "]}";
            
            if (laborError == 2 || miscError == 2) {
                if (laborError == 2) alert("please finish all items in Labor section.");
                if (miscError == 2) alert("please finish all items in Misc section.");
            }
            else {
                //alert(strMisc);
                if (strLabor != "") parent.importSelectedLabor(strLabor);
                if (strMisc != "") parent.importSelectedMisc(strMisc);
                parent.importXMLDetail_Close();
            }
        }
        function btn_Cancel_onclick() {
            parent.importXMLDetail_Close();
        }
      </script>
</asp:Content>
