<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Misc.ascx.cs" Inherits="Modules_Quote_Controls_Misc" %>
<%//<CODE_TAG_102284> %>
<%@ Import Namespace="System.Data" %> <!--CODE_TAG_101986-->
<%@ Import Namespace="System.Text" %><!--CODE_TAG_101986-->
<%//<CODE_TAG_102284> %>
<div  class="SegmentPart">
    <div id="divMiscList">
        <asp:Literal ID="litMiscList" runat="server"></asp:Literal>
        
    </div>
   <span id="spanMiscWaitting" style='position: absolute;top:40%;left:50%; display:none'><img src='../../Library/images/waiting.gif' /></span>
    
</div>

<script type="text/javascript">
    function importSelectedMisc(strMisc) {
        //<CODE_TAG_101832>
        var operation = 'IMPORTXML';
        if ('<%=IsRepriceRequired%>' == '2')
            operation = 'REPRICE';
        //</CODE_TAG_101832>
        //<CODE_TAG_104809>
        if ('<%=hasPendingMisc%>' == '2')
            operation = 'IMPORTXML';
        //</CODE_TAG_104809>

        //alert("Misc" + strMisc);
        $j("#hdnXMLMisc").val(strMisc);
        detailDataChanged = true;
        // if (!callBacking)  SegmentDetailAjaxHandler(0, 'IMPORTXML', 'Misc');// comment out for <CODE_TAG_101832>
        //if (!callBacking) SegmentDetailAjaxHandler(0, operation, 'Misc'); // <CODE_TAG_101832>
        if (!callBacking_misc) SegmentDetailAjaxHandler(0, operation, 'Misc'); // <CODE_TAG_101832>//<CODE_TAG_103407>
    }

        //<CODE_TAG_102284>
    function addNewMisc() {
        //alert("Hi, I am adding new Misc!")
        var lastRowItemId = $("#hdnMiscCount").val();

        var newRowItemId = parseInt(lastRowItemId) + 1;
        var lastRowTr = $("#txtMiscItemNo" + lastRowItemId).parent().parent();

        var newRowContent = "<tr>";
        //newRowContent += "<td><img src='../../Library/images/magnifier.gif' onclick='partSearch(" + newRowItemId + ");' class='imgBtn' /></td>";
        newRowContent += "<td/>"
                   //<CODE_TAG_101986>

            <% 
                DataSet dsSegmentColumnsOrder = DAL.Quote.QuoteGetDetailSegmentColumnsOrder(3); //<CODE_TAG_101986>
                //!!
                if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Misc.ChargeCode"))
                {%>
                    newRowContent +="<td></td>";

                    //<CODE_TAG_101986>
           <%       foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows) //Miscs
                    {
                        switch (dr["ColumnName"].ToString())
                        {
                            case "ChargeCode":%>
                                //<CODE_TAG_101832>
                                //sb.Append("<td style='white-space: nowrap'><input type='hidden' ID='hidMiscItemIdFromDb" + itemId + "' name='hidMiscItemIdFromDb" + itemId + "' Value='" + m.ItemId + "' /><input type='hidden' ID='hidMiscChargeCode" + itemId + "' name='hidMiscChargeCode" + itemId + "' Value='" + m.ItemNo + "' /> <input type='text' id='txtMiscItemNo" + itemId + "' name='txtMiscItemNo" + itemId + "' onkeyup=\"txtSearchbleListKeyUp('txtMiscItemNo" + itemId + "', 'hidMiscChargeCode" + itemId + "', arrMiscChargeCode);\" class='w90p' value='" + m.ItemNo + ((m.ItemNo.IsNullOrEmpty()) ? "" : "") + "' " + ((m.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + "  /> <span onclick=\"displaySearchbleList('','txtMiscItemNo" + itemId + "', 'hidMiscChargeCode" + itemId + "' , arrMiscChargeCode); \"  " + ((m.IsLocked) ? "style='display:none'" : "") + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> </td>");
                                //newRowContent += " <td style='white-space: nowrap'><input type='hidden' ID='hidMiscItemIdFromDb" + newRowItemId + "' name='hidMiscItemIdFromDb" + newRowItemId + "' Value='' /><input type='hidden' ID='hidMiscChargeCode" + newRowItemId + "' name='hidMiscChargeCode" + newRowItemId + "' Value='' /> <input type='text' id='txtMiscItemNo" + newRowItemId + "' name='txtMiscItemNo" + newRowItemId + "' onkeyup=\"txtSearchbleListKeyUp('txtMiscItemNo" + newRowItemId + "', 'hidMiscChargeCode" + newRowItemId + "', arrMiscChargeCode);\" class='w90p' value='' "  + "  /> <span onclick=\"displaySearchbleList('','txtMiscItemNo" + newRowItemId + "', 'hidMiscChargeCode" + newRowItemId + "' , arrMiscChargeCode); \"  "  + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> </td>";
                                newRowContent += " <td style='white-space: nowrap'><input type='hidden' ID='hidMiscItemIdFromDb" + newRowItemId + "' name='hidMiscItemIdFromDb" + newRowItemId + "' Value='' /><input type='hidden' ID='hidMiscChargeCode" + newRowItemId + "' name='hidMiscChargeCode" + newRowItemId + "' Value='' /> <input type='text' id='txtMiscItemNo" + newRowItemId + "' name='txtMiscItemNo" + newRowItemId + "' onkeyup=\"txtSearchbleListKeyUp('txtMiscItemNo" + newRowItemId + "', 'hidMiscChargeCode" + newRowItemId + "', arrMiscChargeCode, null, null, 'Y');\" class='w90p' value='' " + "  /> <span onclick=\"displaySearchbleList('','txtMiscItemNo" + newRowItemId + "', 'hidMiscChargeCode" + newRowItemId + "' , arrMiscChargeCode); \"  " + " ><img style='margin-right: 8px; margin-top: 6px; cursor: pointer' alt='' src='../../library/images/arrowdown.gif' /></span> </td>";    //<CODE_TAG_105100> lwang
                                //</CODE_TAG_101832>
            <%                  break;
                            case "Description":%>
                                //sb.Append("<td>&nbsp;&nbsp;<input type='text' id='txtMiscDescription" + newRowItemId + "' name='txtMiscDescription" + newRowItemId + "' class='w90p' style='display:' value='' /></td>");
                                newRowContent +="<td>&nbsp;&nbsp;<input type='text' id='txtMiscDescription" + newRowItemId + "' name='txtMiscDescription" + newRowItemId + "' class='w90p' style='display:' value='' /></td>";
            <%                  break;
                            case "Quantity":%>
                                //sb.Append("<td class='tAc'><input type='text' id='txtMiscQuantity" + itemId + "' name='txtMiscQuantity" + itemId + "' class='w90p tAr' value='" + m.Quantity + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'', 'Misc');\" " + ((m.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>");
                                newRowContent +="<td class='tAc'><input type='text' id='txtMiscQuantity" + newRowItemId + "' name='txtMiscQuantity" + newRowItemId + "' class='w90p tAr' value='1' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + newRowItemId + ",'', 'Misc');\" "  + " /></td>";
            <%                  break;
                            case "UnitCost":%>
                                //sb.Append("<td><input type='text' id='txtMiscUnitCostPrice" + itemId + "' name='txtMiscUnitCostPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.UnitCostPrice, 2, null, null, null, null) + "' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'CALCULATEUNITPRICE', 'Misc');\" /></td>");
                                newRowContent +="<td><input type='text' id='txtMiscUnitCostPrice" + newRowItemId + "' name='txtMiscUnitCostPrice" + newRowItemId + "' class='w90p tAr' value='' onblur=\"SegmentDetailAjaxHandler(" + newRowItemId + ",'CALCULATEUNITPRICE', 'Misc');\" /></td>";
            <%                  break;
                            case "Markup":%>
                                //sb.Append("<td><input type='text' id='txtMiscUnitPercentRate" + itemId + "' name='txtMiscUnitPercentRate" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.UnitPercentRate * 100, 2, null, null, null, null) + "' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'CALCULATEUNITPRICE', 'Misc');\" /></td>");
                                newRowContent += "<td><input type='text' id='txtMiscUnitPercentRate" + newRowItemId + "' name='txtMiscUnitPercentRate" + newRowItemId + "' class='w90p tAr' value='' onblur=\"SegmentDetailAjaxHandler(" + newRowItemId + ",'CALCULATEUNITPRICE', 'Misc');\" /></td>";
            <%                  break;
                            case "UnitPrice":%>
                                //sb.Append("<td><input type='text' id='txtMiscUnitSellPrice" + itemId + "' name='txtMiscUnitSellPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.UnitSellPrice, 2, null, null, null, null) + "' readonly='readonly' tabindex='-1'  /></td>");
                                newRowContent += "<td><input type='text' id='txtMiscUnitSellPrice" + newRowItemId + "' name='txtMiscUnitSellPrice" + newRowItemId + "' class='w90p tAr' value='' readonly='readonly' tabindex='-1'  /></td>";
            <%                  break;
                            case "UnitSell":%>
                                ////sb.Append("<td><input type='text' id='txtMiscUnitPrice" + itemId + "' name='txtMiscUnitPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.UnitPrice, 2, null, null, null, null) + "'  onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Misc');\" " + ((m.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>");
                                //sb.Append("<td><input type='text' id='txtMiscUnitPrice" + itemId + "' name='txtMiscUnitPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.UnitPrice, 2, null, null, null, null) + "'  onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Misc','UnitPrice');\" " + ((m.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>"); //<CODE_TAG_102284>
                                newRowContent += "<td><input type='text' id='txtMiscUnitPrice" + newRowItemId + "' name='txtMiscUnitPrice" + newRowItemId + "' class='w90p tAr' value=''  onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + newRowItemId + ",'','Misc','UnitPrice');\" "  + " /></td>";
            <%                  break;
                            case "Lock":%>
                                //sb.Append("<td class='tAc'><input type='checkbox' ID='chkUnitPriceLock" + itemId + "' name='chkUnitPriceLock" + itemId + "' " + ((m.IsUnitPriceLocked) ? "checked='checked'" : "") + " /> </td>");
                                newRowContent += "<td class='tAc'><input type='checkbox' ID='chkUnitPriceLock" + newRowItemId + "' name='chkUnitPriceLock" + newRowItemId + "' " + " /> </td>";
            <%                  break;
                            case "ExtendedPrice":%>
                                //sb.Append("<td class='tAr'><input type='text' id='txtMiscExetendPrice" + itemId + "' name='txtMiscExetendPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.ExtendedPrice, 2, null, null, null, null) + "' readonly='readonly' tabindex='-1' /></td>");
                                newRowContent += "<td class='tAr'><input type='text' id='txtMiscExetendPrice" + newRowItemId + "' name='txtMiscExetendPrice" + newRowItemId + "' class='w90p tAr' value='' readonly='readonly' tabindex='-1' /></td>";
            <%                  break;
                            default:
                                break;

                        }
                    }%>
                    //</CODE_TAG_101986>
                    newRowContent += "<td><img src='../../Library/Images/icon_x.gif'  onclick=\"detailDataChanged= true; SegmentDetailAjaxHandler(" + newRowItemId + ",'DELETE', 'Misc');\" "  + " /> ";
                    newRowContent += "<input type='hidden' id='hdnMiscLock" + newRowItemId + "' name='hdnMiscLock" + newRowItemId + "' value=''  /> </td>";

                
             <% }
                else
                { %>
                    newRowContent += "<td></td>";

                    //<CODE_TAG_101986>
             <%     foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows) //Miscs
                    {
                        switch (dr["ColumnName"].ToString())
                        {
                            /*case "Lock":
                                if (m.IsLocked)
                                    sb.Append("<td><img src='../../Library/images/lock.png' /></td>");
                                else
                                    sb.Append("<td></td>");
                                break;*/

                            case "ChargeCode":%>
                                //sb.Append("<td><input type='text' id='txtMiscItemNo" + itemId + "' name='txtMiscItemNo" + itemId + "' class='w90p' onkeypress='detailDataChanged= true;' value='" + m.ItemNo + "' onkeypress='detailDataChanged= true;' " + ((m.IsLocked) ? "readonly='readonly' tabindex='-1'" : "") + " /></td>");
                                newRowContent += "<td><input type='text' id='txtMiscItemNo" + newRowItemId + "' name='txtMiscItemNo" + newRowItemId + "' class='w90p' onkeypress='detailDataChanged= true;' value='' onkeypress='detailDataChanged= true;' "  + " /></td>";
              <%                break;
                            case "Description":%>
                                //sb.Append("<td><input type='text' id='txtMiscDescription" + itemId + "' name='txtMiscDescription" + itemId + "' class='w90p' onkeypress='detailDataChanged= true;' value='" + m.Description + "' " + ((m.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>");
                                newRowContent += "<td><input type='text' id='txtMiscDescription" + newRowItemId + "' name='txtMiscDescription" + newRowItemId + "' class='w90p' onkeypress='detailDataChanged= true;' value='' " + " /></td>";
              <%                break;
                            case "Quantity":%>
                                //sb.Append("<td><input type='text' id='txtMiscQuantity" + itemId + "' name='txtMiscQuantity" + itemId + "' class='w90p tAr' value='" + m.Quantity + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'', 'Misc');\" " + ((m.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>");
                                newRowContent += "<td><input type='text' id='txtMiscQuantity" + newRowItemId + "' name='txtMiscQuantity" + newRowItemId + "' class='w90p tAr' value='1' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + newRowItemId + ",'', 'Misc');\" "  + " /></td>";
              <%                break;

                            case "UnitPrice":%>
                                ////sb.Append("<td><input type='text' id='txtMiscUnitPrice" + itemId + "' name='txtMiscUnitPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.UnitPrice, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Misc');\" " + ((m.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>");
                                //sb.Append("<td><input type='text' id='txtMiscUnitPrice" + itemId + "' name='txtMiscUnitPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.UnitPrice, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Misc', 'UnitPrice');\" " + ((m.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>"); //<CODE_TAG_102284>
                                newRowContent += "<td><input type='text' id='txtMiscUnitPrice" + newRowItemId + "' name='txtMiscUnitPrice" + newRowItemId + "' class='w90p tAr' value='' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + newRowItemId + ",'','Misc', 'UnitPrice');\" "  + " /></td>";
              <%                break;
                            case "Discount":%>
                                //sb.Append("<td><input type='text' id='txtMiscDiscount" + itemId + "' name='txtMiscDiscount" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.Discount, 2, null, null, null, null) + "' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + itemId + ",'','Misc');\" " + ((m.IsLocked) ? "readonly='readonly' tabindex='-1' " : "") + " /></td>");
                                newRowContent += "<td><input type='text' id='txtMiscDiscount" + newRowItemId + "' name='txtMiscDiscount" + newRowItemId + "' class='w90p tAr' value='' onkeypress='detailDataChanged= true;' onblur=\"SegmentDetailAjaxHandler(" + newRowItemId + ",'','Misc');\" "  + " /></td>";
              <%                break;
                            case "DiscPrice":%>
                                //sb.Append("<td><input type='text' id='txtMiscDiscPrice" + itemId + "' name='txtMiscDiscPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.UnitDiscPrice, 2, null, null, null, null) + "' readonly='readonly' tabindex='-1' /></td>");
                                newRowContent += "<td><input type='text' id='txtMiscDiscPrice" + newRowItemId + "' name='txtMiscDiscPrice" + newRowItemId + "' class='w90p tAr' value='' readonly='readonly' tabindex='-1' /></td>";
              <%                break;
                            case "ExtendedPrice":%>
                                //sb.Append("<td class='tAr'><input type='text' id='txtMiscExetendPrice" + itemId + "' name='txtMiscExetendPrice" + itemId + "' class='w90p tAr' value='" + Util.NumberFormat(m.ExtendedPrice, 2, null, null, null, null) + "' readonly='readonly' tabindex='-1' /></td>");
                                newRowContent += "<td class='tAr'><input type='text' id='txtMiscExetendPrice" + newRowItemId + "' name='txtMiscExetendPrice" + newRowItemId + "' class='w90p tAr' value='' readonly='readonly' tabindex='-1' /></td>";
              <%                break;
                            default:
                                break;

                        }
                    }%>
                    //</CODE_TAG_101986>

                    //sb.Append("<td><img src='../../Library/Images/icon_x.gif'  onclick=\"detailDataChanged= true; SegmentDetailAjaxHandler(" + itemId + ",'DELETE', 'Misc');\" " + ((m.IsLocked) ? "style='display:none'" : "") + " /> ");
                    newRowContent += "<td><img src='../../Library/Images/icon_x.gif'  onclick=\"detailDataChanged= true; SegmentDetailAjaxHandler(" + newRowItemId + ",'DELETE', 'Misc');\" "  + " /> ";
                    //sb.Append("<input type='hidden' id='hdnMiscLock" + itemId + "' name='hdnMiscLock" + itemId + "' value='" + m.Lock + "'  /> </td>");
                    newRowContent += "<input type='hidden' id='hdnMiscLock" + newRowItemId + "' name='hdnMiscLock" + newRowItemId + "' value=''  /> </td>";

                                    
             <% }
                //!!

                
                
            %>
            
            
            //</CODE_TAG_101986>
        newRowContent += "</tr>";

        $(lastRowTr).after(newRowContent);
        $("#hdnMiscCount").val(newRowItemId);
        $("#txtMiscItemNo" + newRowItemId).focus().select();
        //alert(newRowContent);
        //alert("adding new line");
    }
    //</CODE_TAG_102284>

</script>
