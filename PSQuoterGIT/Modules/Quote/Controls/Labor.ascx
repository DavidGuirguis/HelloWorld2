<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Labor.ascx.cs" Inherits="Modules_Quote_Controls_Labor" %>
<%//<CODE_TAG_102284> %>
<%@ Import Namespace="System.Data" %> <!--CODE_TAG_101986-->
<%@ Import Namespace="System.Text" %><!--CODE_TAG_101986-->
<%//<CODE_TAG_102284> %>
<div  class="SegmentPart">
    <div id="divLaborList">
        <asp:Literal ID="litLaborList" runat="server"></asp:Literal>
        
    </div>
    <span id="spanLaborWaitting" style='position: absolute;top:40%;left:50%; display:none'><img src='../../Library/images/waiting.gif' /></span>
</div>
   

<script type="text/javascript">
    function importSelectedLabor(strLabor) {
   
    //<CODE_TAG_101832>
        var operation = 'IMPORTXML';
        if ('<%=IsRepriceRequired%>' == '2')
            operation = 'REPRICE';
        //</CODE_TAG_101832>
        //<CODE_TAG_104809>
        if ('<%=hasPendingLabor%>' == '2')
            operation = 'IMPORTXML';
        //</CODE_TAG_104809>
        //alert("Labor" + strLabor);
        $j("#hdnXMLLabor").val(strLabor);
        detailDataChanged = true;
        //SegmentDetailAjaxHandler(0, 'IMPORTXML', 'Labor'); // comment out for <CODE_TAG_101832>
        SegmentDetailAjaxHandler(0, operation, 'Labor'); // comment out for <CODE_TAG_101832>
    }

    //<CODE_TAG_102284>
    function addNewLabor() {
        //alert("Hi, I am adding new labor!")
        var lastRowItemId = $("#hdnLaborCount").val();

        var newRowItemId = parseInt(lastRowItemId) + 1;
        var lastRowTr = $("#txtLaborItemNo" + lastRowItemId).parent().parent();

        var newRowContent = "<tr>";
        //newRowContent += "<td><img src='../../Library/images/magnifier.gif' onclick='partSearch(" + newRowItemId + ");' class='imgBtn' /></td>";
        //newRowContent += "<td></td><td></td><td></td><td></td><td></td><td></td><td></td>";
                   //<CODE_TAG_101986>

            <% 
                DataSet dsSegmentColumnsOrder = DAL.Quote.QuoteGetDetailSegmentColumnsOrder(2); //<CODE_TAG_101986>
                //!!
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labour.ChargeCode"))
                { %>
                    newRowContent += "<td></td>";

                <%                     
                    foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows) //Labors
                    {
                        switch (dr["ColumnName"].ToString())
                        {
                            case "ChargeCode":

                                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.DescriptionEditMode.Show"))
                                { %>

                                //newRowContent += "<td style='white-space: nowrap'><input type='hidden' ID='hidLaborItemIdFromDb" + newRowItemId + "' name='hidLaborItemIdFromDb" + newRowItemId + "' Value='' /><input type='hidden' ID='hidLaborChargeCode" + newRowItemId + "' name='hidLaborChargeCode" + newRowItemId + "' Value='' /> <input type='text' id='txtLaborItemNo" + newRowItemId + "' name='txtLaborItemNo" + newRowItemId + "' onkeyup=\"txtSearchbleListKeyUp('txtLaborItemNo" + newRowItemId + "', 'hidLaborChargeCode" + newRowItemId + "', arrLaborChargeCode);\" class='w90p' value='' " +  "  /> <span onclick=\"displaySearchbleList('','txtLaborItemNo" + newRowItemId + "', 'hidLaborChargeCode" + newRowItemId + "' , arrLaborChargeCode, null, null, 'Y');\"   " + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> ";
                                newRowContent += "<td style='white-space: nowrap'><input type='hidden' ID='hidLaborItemIdFromDb" + newRowItemId + "' name='hidLaborItemIdFromDb" + newRowItemId + "' Value='' /><input type='hidden' ID='hidLaborChargeCode" + newRowItemId + "' name='hidLaborChargeCode" + newRowItemId + "' Value='' /> <input type='text' id='txtLaborItemNo" + newRowItemId + "' name='txtLaborItemNo" + newRowItemId + "' onkeyup=\"txtSearchbleListKeyUp('txtLaborItemNo" + newRowItemId + "', 'hidLaborChargeCode" + newRowItemId + "', arrLaborChargeCode, null, null, 'Y');\" class='w90p' value='' " + "  /> <span onclick=\"displaySearchbleList('','txtLaborItemNo" + newRowItemId + "', 'hidLaborChargeCode" + newRowItemId + "' , arrLaborChargeCode, null, null, 'Y');\"   " + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> "; //<CODE_TAG_105100> lwang
                 <%               }
                                else
                                { %>
                                    //<CODE_TAG_101832>
                                    //sb.Append("<td style='white-space: nowrap'><input type='hidden' ID='hidLaborItemIdFromDb" + itemId + "' name='hidLaborItemIdFromDb" + itemId + "' Value='" + l.ItemId + "' /><input type='hidden' ID='hidLaborChargeCode" + itemId + "' name='hidLaborChargeCode" + itemId + "' Value='" + l.ItemNo + "' /> <input type='text' id='txtLaborItemNo" + itemId + "' name='txtLaborItemNo" + itemId + "' onkeyup=\"txtSearchbleListKeyUp('txtLaborItemNo" + itemId + "', 'hidLaborChargeCode" + itemId + "', arrLaborChargeCode);\" class='w90p' value='" + l.Description + "' " + ((l.IsLocked) ? "readonly='readonly'" : "") + "  /> <span onclick=\"displaySearchbleList('','txtLaborItemNo" + itemId + "', 'hidLaborChargeCode" + itemId + "' , arrLaborChargeCode);\"   " + ((l.IsLocked) ? "style='display:none'" : "") + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> ");
                                    //newRowContent += "<td style='white-space: nowrap'><input type='hidden' ID='hidLaborItemIdFromDb" + newRowItemId + "' name='hidLaborItemIdFromDb" + newRowItemId + "' Value='' /><input type='hidden' ID='hidLaborChargeCode" + newRowItemId + "' name='hidLaborChargeCode" + newRowItemId + "' Value='' /> <input type='text' id='txtLaborItemNo" + newRowItemId + "' name='txtLaborItemNo" + newRowItemId + "' onkeyup=\"txtSearchbleListKeyUp('txtLaborItemNo" + newRowItemId + "', 'hidLaborChargeCode" + newRowItemId + "', arrLaborChargeCode);\" class='w90p' value='' readonly='readonly' " +   "  /> <span onclick=\"displaySearchbleList('','txtLaborItemNo" + newRowItemId + "', 'hidLaborChargeCode" + newRowItemId + "' , arrLaborChargeCode, null, null, 'Y');\"   " + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> ";
                                    newRowContent += "<td style='white-space: nowrap'><input type='hidden' ID='hidLaborItemIdFromDb" + newRowItemId + "' name='hidLaborItemIdFromDb" + newRowItemId + "' Value='' /><input type='hidden' ID='hidLaborChargeCode" + newRowItemId + "' name='hidLaborChargeCode" + newRowItemId + "' Value='' /> <input type='text' id='txtLaborItemNo" + newRowItemId + "' name='txtLaborItemNo" + newRowItemId + "' onkeyup=\"txtSearchbleListKeyUp('txtLaborItemNo" + newRowItemId + "', 'hidLaborChargeCode" + newRowItemId + "', arrLaborChargeCode, null, null, 'Y');\" class='w90p' value='' readonly='readonly' " + "  /> <span onclick=\"displaySearchbleList('','txtLaborItemNo" + newRowItemId + "', 'hidLaborChargeCode" + newRowItemId + "' , arrLaborChargeCode, null, null, 'Y');\"   " + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> ";    //<CODE_TAG_105100> lwang
                                    //</CODE_TAG_101832>
                 <%               }
                                //</CODE_TAG_102111>
                                break;
                            case "Description":
                                //<CODE_TAG_102111>
                                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.DescriptionEditMode.Show"))
                                {%>
                                    //sb.Append("<td>&nbsp;&nbsp;<input type='text' id='txtLaborDescription" + itemId + "' name='txtLaborDescription" + itemId + "' class='w90p'  value='" + l.Description + "'  /></td>");
                                    newRowContent += "<td>&nbsp;&nbsp;<input type='text' id='txtLaborDescription" + newRowItemId + "' name='txtLaborDescription" + newRowItemId + "' class='w90p'  value=''  /></td>";
                 <%              }
                                else
                                {%>
                                    //sb.Append("<input type='text' id='txtLaborDescription" + itemId + "' name='txtLaborDescription" + itemId + "' class='w90p' readonly='readonly' value='" + l.Description + "' style='display:none' /></td>");
                                    newRowContent += "<input type='text' id='txtLaborDescription" + newRowItemId + "' name='txtLaborDescription" + newRowItemId + "' class='w90p' readonly='readonly' value='' style='display:none' /></td>";
                 <%              }
                                //</CODE_TAG_102111>
                                break;
                            case "Quantity": %>
                                //sb.Append("<td class='tAr'><input type='text' id='txtLaborQuantity" + itemId + "' name='txtLaborQuantity" + itemId + "' class='w90p tAr' value='" + l.Quantity + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'', 'Labor');\" " + ((l.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                                newRowContent  += "<td class='tAr'><input type='text' id='txtLaborQuantity" + newRowItemId + "' name='txtLaborQuantity" + newRowItemId + "' class='w90p tAr' value='1' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + newRowItemId + ",'', 'Labor');\" "  + " /></td>";
                 <%             break;
                            case "RateType":%>
                                //sb.Append("<td class='tAc'><select id='lstLaborShift" + itemId + "' name='lstLaborShift" + itemId + "' onchange='setupLaborChargeCode(" + itemId + ");' " + ((l.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + "  > <option value='CRTR' " + ((l.Shift == "CRTR") ? "selected='selected'" : "") + " >Regular</option> <option value='COTR' " + ((l.Shift == "COTR") ? "selected='selected'" : "") + ">Overtime</option> <option value='CPTR' " + ((l.Shift == "CPTR") ? "selected='selected'" : "") + ">Premium</option>    </select>  </td>");
                                newRowContent += "<td class='tAc'><select id='lstLaborShift" + newRowItemId + "' name='lstLaborShift" + newRowItemId + "' onchange='setupLaborChargeCode(" + newRowItemId + ");' "  + "  > <option value='CRTR' "  + " >Regular</option> <option value='COTR' "  + ">Overtime</option> <option value='CPTR' "  + ">Premium</option>    </select>  </td>";
                 <%             break;

                            case "UnitPrice":%>
                                //sb.Append("<td><input type='text' id='txtLaborUnitSellPrice" + itemId + "' name='txtLaborUnitSellPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.UnitSellPrice, 2, null, null, null, null) + "' readonly='readonly' tabindex='-1' /></td>");
                                newRowContent += "<td><input type='text' id='txtLaborUnitSellPrice" + newRowItemId + "' name='txtLaborUnitSellPrice" + newRowItemId + "' class='w90p tAr' value='' readonly='readonly' tabindex='-1' /></td>";
                 <%             break;
                            case "SellPrice":%>
                                //sb.Append("<td><input type='text' id='txtLaborUnitPrice" + itemId + "' name='txtLaborUnitPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.UnitPrice, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Labor');\" " + ((l.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>");
                                //sb.Append("<td><input type='text' id='txtLaborUnitPrice" + itemId + "' name='txtLaborUnitPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.UnitPrice, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Labor','UnitPrice');\" " + ((l.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>");//<CODE_TAG_102284>
                                newRowContent += "<td><input type='text' id='txtLaborUnitPrice" + newRowItemId + "' name='txtLaborUnitPrice" + newRowItemId + "' class='w90p tAr' value='' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + newRowItemId + ",'','Labor','UnitPrice');\" " + " /></td>";
                 <%             break;
                            case "Discount":
                                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Labor.Discount.Show"))%>
                                    //sb.Append("<td><input type='text' id='txtLaborDiscount" + itemId + "' name='txtLaborDiscount" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.Discount, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Labor');\" " + ((l.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>");
                                  newRowContent += "<td><input type='text' id='txtLaborDiscount" + newRowItemId + "' name='txtLaborDiscount" + newRowItemId + "' class='w90p tAr' value='' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + newRowItemId + ",'','Labor');\" "  + " /></td>";
                 <%               break;
                            case "ExtendedPrice":%>
                                //sb.Append("<td  class='tAr'><input type='text' id='txtLaborExetendPrice" + itemId + "' name='txtLaborExetendPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.ExtendedPrice, 2, null, null, null, null) + "' readonly='readonly' tabindex='-1' /></td>");
                                newRowContent += "<td  class='tAr'><input type='text' id='txtLaborExetendPrice" + newRowItemId + "' name='txtLaborExetendPrice" + newRowItemId + "' class='w90p tAr' value='' readonly='readonly' tabindex='-1' /></td>";
                 <%             break;
                            default:
                                break;
                        }
                    }%>
                    //</CODE_TAG_101986>

                    //sb.Append("<td><img src='../../Library/Images/icon_x.gif'  onclick=\"detailDataChanged= true; SegmentDetailAjaxHandler(" + itemId + ",'DELETE', 'Labor');\" " + ((l.IsLocked) ? "style='display:none'" : "") + " />");
                    newRowContent += "<td><img src='../../Library/Images/icon_x.gif'  onclick=\"detailDataChanged= true; SegmentDetailAjaxHandler(" + newRowItemId + ",'DELETE', 'Labor');\" "  + " />";
                    //sb.Append("<input type='hidden' id='hdnLaborLock" + itemId + "' name='hdnLaborLock" + itemId + "' value='" + l.Lock + "'  /> </td>");
                    newRowContent += "<input type='hidden' id='hdnLaborLock" + newRowItemId + "' name='hdnLaborLock" + newRowItemId + "' value=''  /> </td>";
                    //sb.Append("</tr>");
                    //totalExtPrice += l.ExtendedPrice;
                    //totalQty += l.Quantity; 
          <%    }
                else
                {%>
                    //sb.Append("<td></td>");
                    newRowContent += "<td></td>";

                    //<CODE_TAG_101986>
                <%  foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows) //Labors
                    {
                        switch (dr["ColumnName"].ToString())
                        {

                            case "ChargeCode":%>
                                //sb.Append("<td><input type='text' id='txtLaborItemNo" + itemId + "' name='txtLaborItemNo" + itemId + "' class='w90p' onkeypress='detailDataChanged= true;' value='" + l.ItemNo + "' " + ((l.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                                newRowContent += "<td><input type='text' id='txtLaborItemNo" + newRowItemId + "' name='txtLaborItemNo" + newRowItemId + "' class='w90p' onkeypress='detailDataChanged= true;' value='' "  + " /></td>";
                 <%             break;
                            case "Description":%>
                                //sb.Append("<td><input type='text' id='txtLaborDescription" + itemId + "' name='txtLaborDescription" + itemId + "' class='w90p' onkeypress='detailDataChanged= true;' value='" + l.Description + "' " + ((l.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                                newRowContent += "<td><input type='text' id='txtLaborDescription" + newRowItemId + "' name='txtLaborDescription" + newRowItemId + "' class='w90p' onkeypress='detailDataChanged= true;' value='' " + " /></td>";
                 <%             break;
                            case "Quantity":%>
                                //sb.Append("<td><input type='text' id='txtLaborQuantity" + itemId + "' name='txtLaborQuantity" + itemId + "' class='w90p tAr' value='" + l.Quantity + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'', 'Labor');\" " + ((l.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                                newRowContent += "<td><input type='text' id='txtLaborQuantity" + newRowItemId + "' name='txtLaborQuantity" + newRowItemId + "' class='w90p tAr' value='1' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + newRowItemId + ",'', 'Labor');\" "  + " /></td>";

                 <%             break;

                            case "UnitPrice":%>
                                //sb.Append("<td><input type='text' id='txtLaborUnitPrice" + itemId + "' name='txtLaborUnitPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.UnitPrice, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Labor');\" " + ((l.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                                //sb.Append("<td><input type='text' id='txtLaborUnitPrice" + itemId + "' name='txtLaborUnitPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.UnitPrice, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Labor','UnitPrice');\" " + ((l.IsLocked) ? "readonly='readonly'" : "") + " /></td>"); //<CODE_TAG_102284>
                                newRowContent += "<td><input type='text' id='txtLaborUnitPrice" + newRowItemId + "' name='txtLaborUnitPrice" + newRowItemId + "' class='w90p tAr' value='' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + newRowItemId + ",'','Labor','UnitPrice');\" "  + " /></td>";
                 <%             break;

                            case "Discount":%>
                                //sb.Append("<td><input type='text' id='txtLaborDiscount" + itemId + "' name='txtLaborDiscount" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.Discount, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Labor');\" " + ((l.IsLocked) ? "readonly='readonly'" : "") + " /></td>");
                                newRowContent += "<td><input type='text' id='txtLaborDiscount" + newRowItemId + "' name='txtLaborDiscount" + newRowItemId + "' class='w90p tAr' value='' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + newRowItemId + ",'','Labor');\" "  + " /></td>";
                 <%             break;
                            case "DiscPrice":%>
                                //sb.Append("<td><input type='text' id='txtLaborDiscPrice" + itemId + "' name='txtLaborDiscPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.UnitDiscPrice, 2, null, null, null, null) + "' readonly='readonly' /></td>");
                                newRowContent += "<td><input type='text' id='txtLaborDiscPrice" + newRowItemId + "' name='txtLaborDiscPrice" + newRowItemId + "' class='w90p tAr' value='' readonly='readonly' /></td>";
                 <%             break;
                            case "ExtendedPrice":%>
                                //sb.Append("<td  class='tAr'><input type='text' id='txtLaborExetendPrice" + itemId + "' name='txtLaborExetendPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(l.ExtendedPrice, 2, null, null, null, null) + "' readonly='readonly' /></td>");
                                newRowContent += "<td  class='tAr'><input type='text' id='txtLaborExetendPrice" + newRowItemId + "' name='txtLaborExetendPrice" + newRowItemId + "' class='w90p tAr' value='' readonly='readonly' /></td>";
                 <%             break;
                            default:
                                break;
                        }
                    }
                    //</CODE_TAG_101986>

                    //sb.Append("<td><img src='../../Library/Images/icon_x.gif'  onclick=\"detailDataChanged= true; SegmentDetailAjaxHandler(" + itemId + ",'DELETE', 'Labor');\" " + ((l.IsLocked) ? "style='display:none'" : "") + " /> ");
                    //sb.Append("<input type='hidden' id='hdnLaborLock" + itemId + "' name='hdnLaborLock" + itemId + "' value='" + l.Lock + "'  /> </td>");
                    //sb.Append("</tr>");
                    //totalExtPrice += l.ExtendedPrice;
                    //totalQty += l.Quantity;

                }
                
                //!!
                
                
            %>
            

            //</CODE_TAG_101986>
        //newRowContent += "</td>";
        newRowContent += "</tr>";

        $(lastRowTr).after(newRowContent);
        $("#hdnLaborCount").val(newRowItemId);
        $("#txtLaborItemNo" + newRowItemId).focus().select();
        //alert(newRowContent);
        //alert("adding new line");
    }
    //</CODE_TAG_102284>
</script>

