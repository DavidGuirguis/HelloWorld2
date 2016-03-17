<%@ Page Title="" Language="C#" MasterPageFile="~/Library/MasterPages/iFrame.master"
    EnableEventValidation="false" AutoEventWireup="true" CodeFile="WOSegmentSearch.aspx.cs"
    Inherits="quoteSegmentSearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMP" runat="Server">
     <table width="100%">
        <tr>
            <td>
                Look For WorkOrder Number 
                 &nbsp;
                &nbsp;
                <asp:TextBox ID="txtKeyword" Text="" runat="server" ></asp:TextBox>
                &nbsp;
                &nbsp;
                <asp:Button ID="btnSearch" Text="Search" runat="server" OnClientClick="return doSearch();" 
                    onclick="btnSearch_Click" />
                <!--CODE_TAG_103549-->
                    <input id="cbxUncheckAll" name="cbxUncheckAll" type="checkbox" title="Check/Uncheck All" style="display:none" wono="Uncheck-All" onclick="toggleSelectWOSegment();" />
                    <label id="lblUncheckAll" style="display:none" >Check/Uncheck All</label>
                    <!--/CODE_TAG_103549-->
                
            </td>
            <td style=" text-align:right  ">
               <span id="spanCopyCustomerEquipment" style="display:none"> 
                <input id="chkCopyCustomerInfo" style='display:' type='checkbox'  /> Copy customer details
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input id="chkCopyEqInfo" style='display:' type='checkbox'  /> Copy Equipment details
                </span> 
            </td>
        </tr>
     </table>
     <asp:Panel ID="pannelResult" ScrollBars="Auto" Height="500px" runat="server"   >
        <asp:Literal ID="litResult" runat="server"  ></asp:Literal>
     </asp:Panel> 

     <table width="100%"  >
     <tr>
        <td class="tAr"> 
        <input type="button" id="btnOK" value="OK" onclick="btnOK_click();"  />
        <%--<input type="button" id="Button1" value="Cancel" onclick="parent.closeWOSegmentSearch();" />--%>
        <input type="button" id="btnCancel" value="Cancel" onclick="btnclose_click();" /> <%--<CODE_TAG_101895>--%>
        </td>
     </tr>
     </table>
       <span id="spanWaitting" style='position: absolute;top:40%;left:50%; display:none'><img id="spanWaittingImg" src='' /></span>

     <script type="text/javascript" >
        var searchType = <%= SearchType %>;
          $(function () {
            if (searchType == 2) { $("#spanCopyCustomerEquipment").show();}
          });

          function doSearch()
          {
              $("#spanWaitting").show();
            $("#spanWaitting img").attr("src", "../../../Library/images/waiting.gif");
            return true;
          }

         function btnOK_click() {
             var selectedData = "";
             var headerBranchNo = ""; //<CODE_TAG_104537>
             

             var rdo = $('input[type=radio]:checked');
             if ( rdo.length == 0)
             {
                alert("Please choose a work order" );
                return false;
             }
             //<CODE_TAG_104537>
             else
             {
                 headerBranchNo = $(rdo).attr("HeaderBranchNo");
             }
             //</CODE_TAG_104537>
             if (searchType == 4)
             {
                parent.editWorkorderNo($(rdo).val());
                //parent.closeLinkWOSegmentSearch();
                return ;
             }

                          
             if ($('#chkCopyCustomerInfo').attr('checked') || searchType == 3) 
             {
                var rtWono = "";
                if (searchType == 3) rtWono= $(rdo).val();
                parent.AddWOCustomer( $(rdo).attr("CustomerNo"), $(rdo).attr("CustomerName") , $(rdo).attr("CustomerPONo") ,$(rdo).attr("ResponseArea"), rtWono , $(rdo).attr("Division"), $(rdo).attr("WOContactName"), $(rdo).attr("ESBYNM") );
             }

             if ($('#chkCopyEqInfo').attr('checked') || searchType == 3)   
                parent.AddEquipment($(rdo).attr("Model"), $(rdo).attr("SerialNo"), $(rdo).attr("EquipManufCode"), $(rdo).attr("EquipmentNo"), $(rdo).attr("stockNumber"),$(rdo).attr("serviceMeter"),$(rdo).attr("HourMileIndicator"), $(rdo).attr("SMUDate"),  $(rdo).attr("PromiseDate"), $(rdo).attr("ArriveDate")  );

             $('input[type=checkbox]:checked').each(function () {

                 //if ($(this).attr("wono") != "") { 
                 if ($(this).attr("wono") != "" && this.id != "cbxUncheckAll") { //<CODE_TAG_103549>
                     if (selectedData != "") selectedData += ",";
                     selectedData += $(this).attr("wono");
                 }
             });


              if (selectedData == "") {
                    alert("Please select at least one segment.");
                    return false;
                }

             if (searchType == 3) {
                parent.setupCopyFromWODefaultdata();
             }

             var fcaller = parent.frames['iFrameNewSegment'];
             if (fcaller.setupWOSegmentNo) {
				fcaller.setupWOSegmentNo(selectedData);
			}
			else{
				if (fcaller.contentWindow.setupWOSegmentNo) 
					fcaller.contentWindow.setupWOSegmentNo(selectedData);
			}

             //parent.closeWOSegmentSearch();
             //parent.closeWOSegmentSearch(headerBranchNo); //<CODE_TAG_104537>
             //<CODE_TAG_104537>
             <% if (AppContext.Current.AppSettings.IsTrue("psQuoter.Quote.Header.Branch.CopyBranchNoFromWO"))
                { %>
                parent.closeWOSegmentSearch(headerBranchNo); 
             <% } else {%>
                parent.closeWOSegmentSearch();
             <% } %>
             //</CODE_TAG_104537>
         }
         <%--<CODE_TAG_101895>--%>
         function btnclose_click()
         {
          
           if (searchType == 4)
            parent.closeLinkWOSegmentSearch()
          else
            parent.closeWOSegmentSearch();
            
            
         }
         
         <%--</CODE_TAG_101895>--%>
         function rdoWONO_click(rdo) {

             var wono = $(rdo).val();
             var curWono = "";
             var arrStr = "";

             if (searchType == 4) return;

             $('input[wono][type=checkbox]').each(function () {

     
                 arrStr = $(this).attr("wono").split("-");
                 curWono = arrStr[0];
                 if (curWono != wono) {
                     $(this).hide();
                     $(this).removeAttr('checked');
                 }
                 else {
                     $(this).show();
                     $(this).attr('checked', 'checked');
                 }

                //<CODE_TAG_103549>
                $("#cbxUncheckAll").show();
                $("#lblUncheckAll").show();
                //</CODE_TAG_103549>

             });

         }

         //<CODE_TAG_103549>
         function toggleSelectWOSegment() {

            var rdo = $('input[type=radio]:checked');  
            var wono = $(rdo).val();  //T210601
            var curWono = "";
            var arrStr = "";
            $('input[wono][type=checkbox]').each(function () {

                        arrStr = $(this).attr("wono").split("-");
                        curWono = arrStr[0];
                        if (curWono == wono) { //only toggle the checkboxes scope within the selected readio button

                                //if ($(this).is(":checked") && this.id != "cbxUncheckAll") {
                                if (this.id != "cbxUncheckAll" ) {
                                    if ($(this).is(":checked") ) 
                                         $(this).removeAttr('checked'); 
                                    else 
                                        $(this).attr('checked', 'checked');
                                  }  
                          }
                });
                      
            

 
             
         }
         //</CODE_TAG_103549>
     </script>
</asp:Content>
