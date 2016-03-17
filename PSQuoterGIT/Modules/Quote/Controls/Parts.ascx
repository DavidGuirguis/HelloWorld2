<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Parts.ascx.cs" Inherits="Modules_Quote_Controls_Parts" %>
<%@ Import Namespace="System.Data" %> <!--CODE_TAG_101986-->
<%@ Import Namespace="System.Text" %><!--CODE_TAG_101986-->
<div  class="SegmentPart">
    <div id="divPartsList">
        <asp:Literal ID="litPartsList" runat="server"></asp:Literal>
    </div>
    <span id="spanPartsWaitting" style='position: absolute;top:40%;left:50%; display:none'><img id="spanPartsWaittingImg" src='' /></span>

    <div id="divPartsChoiceDialog">
        <div id="divPartsChoice">
            
        </div>
        <div style="float:right; padding-right:50px ">
            <input type="button" id="partChoiceOK" value="OK" onclick="partChoiceOK_onClick();" />
            <input type="button" id="partChoiceCancel" value="Cancel" onclick="closePartChoice();" />
        </div>
    </div>
    
    <div id="divImportXMLParts" style="display: none;">
        <iframe id="iframeXMLParts" src=""  width="800px" height="600px" frameborder="0" scrolling="no"   ></iframe>
    </div>

	<%--<CODE_TAG_103467> Dav--%>
	 <div id="divImportBulkParts" style="display: none;">
        <iframe id="iframeBulkParts" src=""  width="1025px" height="600px" frameborder="0" scrolling="no"   ></iframe>
    </div>
	<%--</CODE_TAG_103467> Dav--%>

    <div id="divPartSearch" style="display: none">
        <%--<iframe id="iframePartSearch" src="" width="800px" height="600px" frameborder="0" scrolling="no"  ></iframe>--%>
            <iframe id="iframePartSearch" src="" width="800px" height="600px" frameborder="0" scrolling="yes"  ></iframe><%--<CODE_TAG_101930>--%>
    </div>
    <script type="text/javascript">
        //---------------------------------------------------------------------------------------------------------------
        $(function () {
            $j("#divImportXMLParts").dialog({ width: 825,
                height: 650,
                draggable: true,
                position: 'center',
                resizable: false,
                modal: true,
                title: 'Import Parts',
                autoOpen: false
            });

        	//<CODE_TAG_103467> Dav
            $j("#divImportBulkParts").dialog({ width: 1050,
            	height: 650,
            	draggable: true,
            	position: 'center',
            	resizable: false,
            	modal: true,
            	title: 'Import Parts',
            	autoOpen: false
            });
        	//<CODE_TAG_103467> Dav

            $j("#divPartSearch").dialog({ width: 825,
                height: 650,
                draggable: true,
                position: 'center',
                resizable: false,
                modal: true,
                title: 'Parts Search',
                autoOpen: false
            });


            $j("#divPartsChoiceDialog").dialog({ width: 825,
                height: 650,
                draggable: true,
                position: 'center',
                resizable: false,
                modal: true,
                title: 'Parts Select',
                autoOpen: false
            });
        });

        function importXML() {


            
            var customerNo = "";
            if (CATAPICustomerNo != "")
                customerNo = CATAPICustomerNo;
            else
                customerNo = $("#hdnCustomerNo").val();

            var branchNo = $("#hdnBranchNo").val();
            //<CODE_TAG_102235>
            <% if (!string.IsNullOrEmpty(CurrentBranchCode) ) {%>
                branchNo = "<%=CurrentBranchCode  %>";
            <%} %>
            //</CODE_TAG_102235>

            var division = $("#hdnDivision").val();


            $("#iframeXMLParts").attr("src", "./Controls/ImportXMLParts.aspx?customerNo=" + customerNo + "&branchNo=" + branchNo + "&division=" + division);
            $j("#divImportXMLParts").dialog("open");
        }

    	//<CODE_TAG_103467> Dav
    	function importBulkParts() {
    		var customerNo = "";
    		if (CATAPICustomerNo != "")
    			customerNo = CATAPICustomerNo;
    		else
    			customerNo = $("#hdnCustomerNo").val();

    		var branchNo = $("#hdnBranchNo").val();
    		//<CODE_TAG_102235>
            <% if (!string.IsNullOrEmpty(CurrentBranchCode) ) {%>
			branchNo = "<%=CurrentBranchCode  %>";
            <%} %>
			//</CODE_TAG_102235>

			var division = $("#hdnDivision").val();


			$("#iframeBulkParts").attr("src", "./Controls/ImportBulkParts.aspx?customerNo=" + customerNo + "&branchNo=" + branchNo + "&division=" + division);
			$j("#divImportBulkParts").dialog("open");
    	}
    	function closeImportBulk() {
    		$j("#divImportBulkParts").dialog("close");
    	}
    	//<CODE_TAG_103467> Dav

        //<CODE_TAG_103600>
        function ImportDBSDocumentParts()
        {
            showDBSPartDocumentsSearch("ImportDBSDocumentParts");
        }
        //</CODE_TAG_103600>
        function closeImportXML() {
            $j("#divImportXMLParts").dialog("close");
        }

        function importSelectedParts(strParts) {

            $j("#hdnXMLParts").val(strParts);
            detailDataChanged = true; 
            SegmentDetailAjaxHandler(0, 'IMPORTXML');
        }

        function closePartChoice() {
            $j('#divPartsChoiceDialog').dialog('close');
        }

        function partChoiceOK_onClick() {
            var itemId = $("#divPartsChoice #priceChoiceItem_Current").attr("itemId");
            var selectedData = "{\"data\":[";
            // current part
            if ($("#divPartsChoice #priceChoiceItem_Current").prop("checked")) {
                selectedData += $("#divPartsChoice #priceChoiceItem_Current").attr("partData") + ",";
            }

            //Replace part
            if ($("#divPartsChoice #priceChoiceItem_Replace").prop("checked")) {
                $("#divPartsChoice [id^=chkReplace_]:checked").each(function () {
                    selectedData += $(this).attr("partData") + ",";
                });
            }

            //Alter part
                $("#divPartsChoice [id^=priceChoiceItem_Alter]:checked").each(function () {
                    selectedData += $(this).attr("partData") + ",";
                });

            if (selectedData.substring(selectedData.length - 1, selectedData.length) == ",") {
                selectedData = selectedData.substring(0, selectedData.length - 1);
            }
            selectedData += "]}";
            
            $j("#hdnXMLParts").val(selectedData);
            detailDataChanged = true;

            SegmentDetailAjaxHandler(itemId, 'UPDATEPART');

            closePartChoice();
        }

        function popReplacePartSelect(val) {
            if (val == 1) {
                $("[id^=chkReplace_]").prop("disabled", false);
                $("[id^=chkReplace_]").filter("[indirectFlag=N]").prop("checked", true);
                $("[id^=chkReplace_]").filter("[indirectFlag=Y]").prop("checked", false);
            }
            else {
                $("[id^=chkReplace_]").prop("disabled", true);
                $("[id^=chkReplace_]").prop("checked", false);
            }
        }

        var currentPartItemId = 0;

        function partSearch(itemId, sos, partNo, sosDesc) {
            currentPartItemId = itemId;
            var strURL = "./Part_Search.aspx?RecordNo=20";
            if (sos != null)
                strURL += "&sos=" + sos;
            if (partNo != null)
                strURL += "&partNo=" + partNo;
            if (sosDesc != null)
                strURL += "&sosDesc=" + sosDesc ;
            $j("#iframePartSearch").attr("src", strURL);
            $j("#divPartSearch").dialog("open");
        }

        function AddCATPrice(partNo,description,sos,sequence ) {
            $("#txtPartSOS" + currentPartItemId).val(sos);
            $("#txtPartNo" + currentPartItemId).val(partNo);
            detailDataChanged= true;
            SegmentDetailAjaxHandler(currentPartItemId, "REFRESHCATPRICE");
         }

        function closePartSearch() {
            $j('#divPartSearch').dialog('close');
        }

        function spanShowHideAvaility_click(i) {
            
            if ($("#hdnShowAvaility" + i).val() == "0") {
                $("#trPartsAvaility" + i).show();
                $("#hdnShowAvaility" + i).val("1");
                $("#spanShowHideAvaility" + i).html("-");
            }
            else {
                $("#trPartsAvaility" + i).hide();
                $("#hdnShowAvaility" + i).val("0");
                $("#spanShowHideAvaility" + i).html("+");
            }
        }

        function addNewPart() {
            var lastRowItemId = $("#hdnPartsCount").val();

            var newRowItemId = parseInt(lastRowItemId) + 1;
            var lastRowTr = $("#txtPartSOS" + lastRowItemId).parent().parent();

            var newRowContent = "<tr>";
            newRowContent += "<td><img src='../../Library/images/magnifier.gif' onclick='partSearch(" + newRowItemId + ");' class='imgBtn' /></td>";
/*            
            newRowContent += "<td><input type='text' id='txtPartSOS" + newRowItemId + "' name='txtPartSOS" + newRowItemId + "' class='w90p' value='<%= AppContext.Current.AppSettings["psQuoter.Quote.SOS.Default"].ToString() %>' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + newRowItemId + ", \"REFRESHCATPRICE\");'   /></td>" ; //<CODE_TAG_101758>

            newRowContent += "<td><input type='text' id='txtPartNo" + newRowItemId + "' name='txtPartNo" + newRowItemId + "' class='w90p' value='' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + newRowItemId + " , \"REFRESHCATPRICE\");' /></td>";
            newRowContent += "<td><input type='text' id='txtPartDescription" + newRowItemId + "' name='txtPartDescription" + newRowItemId + "' class='w90p' value='' /></td>";
            newRowContent += "<td class='tAr'><input type='text' id='txtPartQuantity" + newRowItemId + "' name='txtPartQuantity" + newRowItemId + "' class='w90p tAr numbersOnly' value='1' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + newRowItemId + ", \"CALCULATE\",\"\",\"Quantity\");' /></td>"; //<CODE_TAG_101775>
            newRowContent += "<td class='tAr'>0&nbsp;&nbsp;<input type='text' id='txtPartAvailableQty" + newRowItemId + "' name='txtPartAvailableQty" + newRowItemId + "' class='w90p tAr' value='0' style='display:none' readonly='readonly' /></td>";
            newRowContent += "<td class='noWrap'> &nbsp;&nbsp;&nbsp;&nbsp;<input type='text' id='txtPartAvaility" + newRowItemId + "' name='txtPartAvaility" + newRowItemId + "' class='w80p' value='' style='display:none' readonly='readonly' /></td>";
          
            <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitPrice.Show")) { %>
                newRowContent += "<td><input type='text' id='txtPartUnitSellPrice" + newRowItemId + "' name='txtPartUnitSellPrice" + newRowItemId + "' class='w90p tAr' style='background-color: rgb(239, 239, 239);' value='' readonly='readonly' /></td>";
            <% } %>  

            <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitDiscPrice.Show")){  %>
                newRowContent += "<td><input type='text' id='txtPartUnitDiscPrice" + newRowItemId + "' name='txtPartUnitDiscPrice" + newRowItemId + "' class='w90p tAr' style='background-color: rgb(239, 239, 239);' value='' readonly='readonly' /></td>";
            <%} %>

            <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.NetSellPrice.Show")) { %>
                newRowContent += "<td><input type='text' id='txtPartNetSellPrice" + newRowItemId + "' name='txtPartNetSellPrice" + newRowItemId + "' class='w90p tAr' style='background-color: rgb(239, 239, 239);' value='' readonly='readonly' /></td>";
            <%} %>

            newRowContent += "<td><input type='text' id='txtPartUnitPrice" + newRowItemId + "' name='txtPartUnitPrice" + newRowItemId + "' class='w90p tAr numbersOnly' value='' <%= ((AppContext.Current.AppSettings.IsTrue("psQuoter.PartPrice.UnitPrice.Editable")) ? "" : "readonly='readonly'")  %>  onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + newRowItemId + ", \"CALCULATE\",\"\",\"UnitPrice\");' /></td>";

            <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show")) {  %>
                newRowContent += "<td><input type='text' id='txtPartDiscount" + newRowItemId + "' name='txtPartDiscount" + newRowItemId + "' class='w90p tAr' value='' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + newRowItemId + ");' /></td>";
            <% } %>

            <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show")) {  %>
                newRowContent += " <td><input type='text' id='txtPartDiscPrice" + newRowItemId + "' name='txtPartDiscPrice" + newRowItemId + "' class='w90p tAr' style='background-color: rgb(239, 239, 239);' value='' readonly='readonly' /></td>";
            <% } %>

            newRowContent += "<td class='tAr'>&nbsp;&nbsp;<input type='text' id='txtPartUnitWeight" + newRowItemId + "' name='txtPartUnitWeight" + newRowItemId + "' class='w90p tAr' value='' style='display:none' readonly='readonly' /></td>";
            newRowContent += "<td class='tAr'><span></span></td>";

*/
            //<CODE_TAG_101986>
            <% 
                DataSet dsSegmentColumnsOrder = DAL.Quote.QuoteGetDetailSegmentColumnsOrder(1); //<CODE_TAG_101986>

                foreach (DataRow dr in dsSegmentColumnsOrder.Tables[0].Rows) //Parts
                {
                    switch (dr["ColumnName"].ToString())
                    {
                        case "SOS": %>
                              //newRowContent += "<td><input type='text'  id='txtPartSOS" + newRowItemId + "' name='txtPartSOS" + newRowItemId + "' class='w90p' value='<%= AppContext.Current.AppSettings["psQuoter.Quote.SOS.Default"].ToString() %>' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + newRowItemId + ", \"REFRESHCATPRICE\");'   /></td>" ; //<CODE_TAG_101758>
                              newRowContent += "<td><input type='text' maxlength='3'  id='txtPartSOS" + newRowItemId + "' name='txtPartSOS" + newRowItemId + "' class='w90p' value='<%= AppContext.Current.AppSettings["psQuoter.Quote.SOS.Default"].ToString() %>' onkeyup='detailDataChanged= true; ToNextField(" + newRowItemId +"); ' onblur='SegmentDetailAjaxHandler(" + newRowItemId + ", \"REFRESHCATPRICE\");'   /></td>" ; //<CODE_TAG_101758><CODE_TAG_103532>
                        <%    break;
                        case "PartNo": %>
                              newRowContent += "<td><input type='text' maxlength='20' id='txtPartNo" + newRowItemId + "' name='txtPartNo" + newRowItemId + "' class='w90p' value='' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + newRowItemId + " , \"REFRESHCATPRICE\");' /></td>";
                        <%    break;
                        case "Description": %>
                              newRowContent += "<td><input type='text' id='txtPartDescription" + newRowItemId + "' name='txtPartDescription" + newRowItemId + "' class='w90p' value='' /></td>";

                        <%    break;
                        case "Quantity": %>
                               //newRowContent += "<td class='tAr'><input type='text' id='txtPartQuantity" + newRowItemId + "' name='txtPartQuantity" + newRowItemId + "' class='w90p tAr numbersOnly' value='0' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + newRowItemId + ", \"CALCULATE\",\"\",\"Quantity\");' /></td>";
                               //newRowContent += "<td><input type='text' id='txtPartQuantity" + newRowItemId + "' name='txtPartQuantity" + newRowItemId + "' class='w90p' value='0' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + newRowItemId + ", \"CALCULATE\",\"\",\"Quantity\");' /></td>"; //<CODE_TAG_101986           
                               newRowContent += "<td class='tAr'><input type='text' id='txtPartQuantity" + newRowItemId + "' name='txtPartQuantity" + newRowItemId + "' class='w90p tAr numbersOnly' value='1' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + newRowItemId + ", \"CALCULATE\",\"\",\"Quantity\");' /></td>"; //<CODE_TAG_101775>//<CODE_TAG_102266>
                        <%    break;  
                        case "QtyOnhand": %>
                               newRowContent += "<td class='tAr'>0&nbsp;&nbsp;<input type='text' id='txtPartAvailableQty" + newRowItemId + "' name='txtPartAvailableQty" + newRowItemId + "' class='w90p tAr' value='0' style='display:none' readonly='readonly' tabindex='-1'/></td>";
                        <%    break;                        
                        case "Availability": %>
                               newRowContent += "<td class='noWrap'> &nbsp;&nbsp;&nbsp;&nbsp;<input type='text' id='txtPartAvaility" + newRowItemId + "' name='txtPartAvaility" + newRowItemId + "' class='w80p' value='' style='display:none' readonly='readonly' tabindex='-1' /></td>";
                        <%    break; 
                        case "UnitSellPrice": 
                              if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitPrice.Show"))
                                {
                        %>
                                   newRowContent += "<td><input type='text' id='txtPartUnitSellPrice" + newRowItemId + "' name='txtPartUnitSellPrice" + newRowItemId + "' class='w90p tAr' style='background-color: rgb(239, 239, 239);' value='' readonly='readonly' tabindex='-1' /></td>";
                        <%      }
                              break;
                        case "UnitDiscPrice": 
                              if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitDiscPrice.Show"))  
                                 {
                        %>
                                    newRowContent += "<td><input type='text' id='txtPartUnitDiscPrice" + newRowItemId + "' name='txtPartUnitDiscPrice" + newRowItemId + "' class='w90p tAr' style='background-color: rgb(239, 239, 239);' value='' readonly='readonly' tabindex='-1' /></td>";
                        <%       }                               
   
                              break;  
                        case "NetSellPrice": 
                              if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.NetSellPrice.Show"))  
                                 {
                        %>
                                    newRowContent += "<td><input type='text' id='txtPartNetSellPrice" + newRowItemId + "' name='txtPartNetSellPrice" + newRowItemId + "' class='w90p tAr' style='background-color: rgb(239, 239, 239);' value='' readonly='readonly' tabindex='-1' /></td>";
                        <%       }                               
                              break;                              
                        case "UnitPrice": 
                        %>
                              newRowContent += "<td><input type='text' id='txtPartUnitPrice" + newRowItemId + "' name='txtPartUnitPrice" + newRowItemId + "' class='w90p tAr numbersOnly' value='' <%= ((AppContext.Current.AppSettings.IsTrue("psQuoter.PartPrice.UnitPrice.Editable")) ? "" : "readonly='readonly' tabindex='-1' ")  %>  onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + newRowItemId + ", \"CALCULATE\",\"\",\"UnitPrice\");' /></td>";
                        <%                                      
                              break; 
                         case "Discount": 
                              if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show"))
                              {                                  
                                 if (!string.IsNullOrEmpty(AppContext.Current.AppSettings["psQuoter.Quote.Segment.Part.Discount.Heading"].ToString()) || !AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Parts.Discount.Markup") || AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Parts.Discount.Markup") && !AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Parts.Discount.Markup.PositiveOnly"))    //<CODE_TAG_105120>                               
                        %>
                                    newRowContent += "<td><input type='text' id='txtPartDiscount" + newRowItemId + "' name='txtPartDiscount" + newRowItemId + "' class='w90p tAr' value='' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + newRowItemId + ");' /></td>";
                        <%       
                                 // <CODE_TAG_105120>
                                 else
                        %>
                            newRowContent += "<td><input type='text' id='txtPartDiscount" + newRowItemId + "' name='txtPartDiscount" + newRowItemId + "' class='w90p tAr' value='' onkeypress='detailDataChanged= true; return allowOnlyNumber(event);' onblur='SegmentDetailAjaxHandler(" + newRowItemId + ");' /></td>";
                        <%      // </CODE_TAG_105120>
                            }                               
                              break; 
                         case "DiscountPrice": 
                              if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show"))  
                                 {
                        %>
                                    newRowContent += " <td><input type='text' id='txtPartDiscPrice" + newRowItemId + "' name='txtPartDiscPrice" + newRowItemId + "' class='w90p tAr' style='background-color: rgb(239, 239, 239);' value='' readonly='readonly' tabindex='-1' /></td>";
                        <%       }                               
                              break;
                        case "UnitWeight": %>
                               newRowContent += "<td class='tAr'>&nbsp;&nbsp;<input type='text' id='txtPartUnitWeight" + newRowItemId + "' name='txtPartUnitWeight" + newRowItemId + "' class='w90p tAr' value='' style='display:none' readonly='readonly' tabindex='-1' /></td>";
                               newRowContent += "<td class='tAr'><span></span></td>";
                        <%    break;                                
                    }
                }
                
            %>
            

            //</CODE_TAG_101986>

            newRowContent += "<td><img src='../../Library/Images/icon_x.gif' onclick=\"detailDataChanged= true; SegmentDetailAjaxHandler(" + newRowItemId + ",'DELETE');\" /> ";
            newRowContent += "<input type='hidden' id='txtPartCoreItemId" + newRowItemId + "' name='txtPartCoreItemId" + newRowItemId + "' value='0'  />";
            newRowContent += "<input type='hidden' id='hdnBoCount" + newRowItemId + "' name='hdnBoCount" + newRowItemId + "' value='0'  />";
            newRowContent += "<input type='hidden' id='hdnQtyOnhand" + newRowItemId + "' name='hdnQtyOnhand" + newRowItemId + "' value='0'  />";
            newRowContent += "<input type='hidden' id='hdnPartLock" + newRowItemId + "' name='hdnPartLock" + newRowItemId + "' value='0'  />";
               
            <%     if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitPrice.Show")) {  %>
                 newRowContent += "<input type='text' id='txtPartUnitSellPrice" + newRowItemId + "' name='txtPartUnitSellPrice" + newRowItemId + "' class='w90p tAr' style='display:none' value='' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + newRowItemId + ");' />";
            <% } %>

            <%     if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.UnitDiscPrice.Show")) { %>
                 newRowContent += "<input type='text' id='txtPartUnitDiscPrice" + newRowItemId + "' name='txtPartUnitDiscPrice" + newRowItemId + "' class='w90p tAr' style='display:none' value='' readonly='readonly' />";
            <% } %>
            <%     if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.NetSellPrice.Show")) {  %>
                 newRowContent += "<input type='text' id='txtPartNetSellPrice" + newRowItemId + "' name='txtPartNetSellPrice" + newRowItemId + "' class='w90p tAr' style='display:none' value='' readonly='readonly' />";
            <% } %>
            <%     if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show")) {  %>
                 newRowContent += "<input type='text' id='txtPartDiscount" + newRowItemId + "' name='txtPartDiscount" + newRowItemId + "' class='w90p tAr' style='display:none' value='' onkeypress='detailDataChanged= true;' onblur='SegmentDetailAjaxHandler(" + newRowItemId + ");' />";
           <% } %>
           <%     if (!AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Segment.Part.Discount.Show")) {  %>
                  newRowContent += "<input type='text' id='txtPartDiscPrice" + newRowItemId + "' name='txtPartDiscPrice" + newRowItemId + "' class='w90p tAr' style='display:none' value='' readonly='readonly' />";
           <% } %>

            newRowContent += "</td>";
            newRowContent += "</tr>";
            
            $(lastRowTr).after(newRowContent);
            
            $("#hdnPartsCount").val(newRowItemId);
            //<CODE_TAG_101986>, set here accordingly, depends on the order of column 
            //$("#txtPartSOS" + newRowItemId).focus();
            //$("#txtPartSOS" + newRowItemId).focus(function() { $(this).select(); }); //<CODE_TAG_101986>
            $("#txtPartSOS" + newRowItemId).focus().select(); //<CODE_TAG_101986><CODE_TAG_102259>
            //$("#txtPartQuantity" + newRowItemId).focus(); 
            //</CODE_TAG_101986>
        }

        function ddlSelectImportLst_onchange(){
            //<CODE_TAG_104904>
            if (pageDataChanged) {
                //pageDataChanged = true;
                alert("The page data is changed, please save.");
                $("#ddlSelectImportLst").val("00");
                return false;
            }
            //</CODE_TAG_104904>
			switch ($("#ddlSelectImportLst").val()){
				case "importXML":
					importXML();
					break;
				case "importBulkParts":
					importBulkParts();
					break;
				case "ImportDBSDocumentParts":
					ImportDBSDocumentParts();
					break;
				default:
					break;
					
			}
			
		}
    </script>
</div>

