<%@ Page Title="" Language="C#" MasterPageFile="~/Library/MasterPages/iFrame.master" AutoEventWireup="true" CodeFile="DBSPartDocumentsSearch.aspx.cs" Inherits="Modules_Quote_Controls_DBSPartDocumentsSearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMP" Runat="Server">
     <table width="100%">
        <tr>
            <td>
                Look For DBS Part Document 
                 &nbsp;
                &nbsp;
                <asp:TextBox ID="txtKeyword" Text="" runat="server" ></asp:TextBox>
                &nbsp;
                &nbsp;
                <asp:Button ID="btnSearch" Text="Search" runat="server" 
                    onclick="btnSearch_Click" />
            </td>
            <td></td>
        </tr>

     </table>
    <asp:Panel ID="pannelResult"  ScrollBars="Auto" Height="500px" runat="server"   >
        <asp:Literal ID="litResult" runat="server"  ></asp:Literal>
    </asp:Panel> 
    <table width="100%">
        <tr>
            <td class="tAr">
                <input type="button" id="btnOK" value="OK" onclick="btnOK_click()" />
                <input type="button" id="btnCancel" value="Cancel" onclick="parent.closeDBSPartDocumentsSearch();" /><!--CODE_TAG_103718-->

            </td>
        </tr>
    </table>
    <span id="spanWaitting" style='position: absolute;top:40%;left:50%; display:none'><img id="spanWaittingImg" src='' /></span>
    <script type="text/javascript">
        function btnOK_click() {

        //<CODE_TAG_103600>
            var operation;
            operation = '<%=Operation %>';
        //</CODE_TAG_103600>
            var selectedData = "";
            $('input[type=checkbox]:checked').each(function () {
            //$('checkbox:checked').each(function () {
                if ($(this).attr("DocumentNumber") != "") {
                    if (selectedData != "") { selectedData += ","; }
                    selectedData += $(this).attr("DocumentNumber");
                    /*selectedData += $(this).attr("DocumentNumber") + "~";
                    selectedData += $(this).attr("Store") + "~";
                    selectedData += $(this).attr("CustomerNumber") ;*/

                }
            });


            if (selectedData == "") {
                alert("Please select at least one segment.");
                return false;
            }
            var fcaller;
            /*fcaller = parent.frames['iFrameNewSegment'];
            if (fcaller.setupDBSPartDocumentNo) fcaller.setupDBSPartDocumentNo(selectedData);
            parent.closeDBSPartDocumentsSearch();*/
            //<CODE_TAG_103600>
            if (operation == "AddNewSegmentFromDBSPartDocument") {  
                fcaller = parent.frames['iFrameNewSegment'];
                //var fcaller = parent.frames['iFrameDBSPartDocumentsSearch'];
                //fcaller = parent;
                if (fcaller.setupDBSPartDocumentNo) {
					fcaller.setupDBSPartDocumentNo(selectedData);
				}
				else{
				if (fcaller.contentWindow.setupDBSPartDocumentNo) 
					fcaller.contentWindow.setupDBSPartDocumentNo(selectedData);
				}
                parent.closeDBSPartDocumentsSearch();
            }//Import DBS Document Parts
            else {
                //$("#hdnSelectedDocNos").val(selectedData);
                //$("#btnImportFromDBSPartsDoc").click();
                //fcaller = parent;

                /*fcaller = parent.frames['iFrameNewSegment'];
                parent.newSegment_onClick(2);*/

                

                //if (fcaller.setupDBSPartDocumentNo) fcaller.setupDBSPartDocumentNo(selectedData);
                //parent.closeDBSPartDocumentsSearch(2);
                parent.closeDBSPartDocumentsSearch(2, selectedData);
            }

            

            //</CODE_TAG_103600>


        }

        //<CODE_TAG_103600>
        function cbxSingleChoice(docNo) {
            $("[type='Checkbox']").prop('checked', false);
            $("[type='Checkbox']").each(function () {
                if ($(this).attr("DocumentNumber") == docNo) {
                    //this.checked;
                    $(this).prop('checked', true);

                }
            });
            
        }
        //</CODE_TAG_103600>

    </script>
</asp:Content>

