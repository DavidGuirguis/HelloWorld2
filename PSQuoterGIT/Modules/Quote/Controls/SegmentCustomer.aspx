<%@ Page Title="" Language="C#" MasterPageFile="~/Library/MasterPages/iFrame.master"
    EnableEventValidation="false" AutoEventWireup="true" CodeFile="SegmentCustomer.aspx.cs"
    Inherits="quoteSegmentSearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMP" runat="Server">
     <table class="SegmentCustomerEdit">
        <tr>
            <th style="width:10%"></th>
            <th style="width:80%" class="tAc">Customer</th>
            <th style="width:10%" class="tAc">%</th>
        </tr>
        <tr>
            <th class="tAl">Parts</th>
            <td>
            <img src="../../../library/images/magnifier.gif" onclick="showSegmentCustomerSearch('PARTS')" class='imgBtn' />
            <asp:Label ID="lblPartsCustomer" runat="server" ClientIDMode="Static"  ></asp:Label> 
            <img src="../../../library/images/icon_x.gif" id="ibtnDeletePartsCustomer" onclick="deleteSegmentCustomer('PARTS')" class='imgBtn' />
             </td>
            <td><asp:TextBox ID="txtPartsPercent" CssClass="numbersOnly"  style="width:20px"   MaxLength="3" runat="server" ClientIDMode="Static" ></asp:TextBox> </td>
        </tr>

        <tr>
            <th class="tAl">Labor</th>
            <td>
            <img src="../../../library/images/magnifier.gif" onclick="showSegmentCustomerSearch('LABOR')" class='imgBtn' />
            <asp:Label ID="lblLaborCustomer" runat="server" ClientIDMode="Static"  ></asp:Label>
            <img src="../../../library/images/icon_x.gif" id="ibtnDeleteLaborCustomer" onclick="deleteSegmentCustomer('LABOR')" class='imgBtn' />
             </td>
            <td><asp:TextBox ID="txtLaborPercent" CssClass="numbersOnly" style="width:20px" MaxLength="3" runat="server" ClientIDMode="Static" ></asp:TextBox> </td>
        </tr>
        <tr>
            <th class="tAl">Misc</th>
            <td>
            <img src="../../../library/images/magnifier.gif" onclick="showSegmentCustomerSearch('MISC')" class='imgBtn' />
            <asp:Label ID="lblMiscCustomer" runat="server" ClientIDMode="Static"  ></asp:Label> 
            <img src="../../../library/images/icon_x.gif" id="ibtnDeleteMiscCustomer" onclick="deleteSegmentCustomer('MISC')" class='imgBtn' />
            </td>
            <td><asp:TextBox ID="txtMiscPercent" CssClass="numbersOnly" style="width:20px" MaxLength="3" runat="server" ClientIDMode="Static" ></asp:TextBox> </td>
        </tr>

        <tr>
            <td class="tAl" colspan="2"> Set All Customers As 
                <select id="lstSetAllCustomer" onchange="setAllCustomer();"  >
                    <option value=""> </option>
                    <option value="PARTS"> Parts</option>
                    <option value="LABOR"> Labor</option>
                    <option value="MISC"> Misc</option>
                </select>
             </td>
             <td>
                
             </td>
        </tr>
        <tr>
            <td colspan="3" class="tAr" > 
                <asp:Button ID="btnSave" OnClientClick="return validation();"  runat="server" 
                    Text="Save" onclick="btnSave_Click" /> &nbsp;&nbsp;
                <asp:Button ID="btnCancel" OnClientClick="closeMe(); return false;"  runat="server" Text="Cancel" />
            </td>
        </tr>
     </table>
     <asp:HiddenField ID="hidPartsCustomerNo" runat="server" Value="" ClientIDMode="Static"  />
     <asp:HiddenField ID="hidLaborCustomerNo" runat="server" Value="" ClientIDMode="Static"  />
     <asp:HiddenField ID="hidMiscCustomerNo" runat="server" Value="" ClientIDMode="Static"  />
     <asp:HiddenField ID="hidRefreshParent" runat="server" Value="" ClientIDMode="Static"  />

        <script type="text/javascript" >
            var customerSearchType = "";

            $(function () {
                if ($("#hidPartsCustomerNo").val() == "") $("#ibtnDeletePartsCustomer").hide();
                if ($("#hidLaborCustomerNo").val() == "") $("#ibtnDeleteLaborCustomer").hide();
                if ($("#hidMiscCustomerNo").val() == "") $("#ibtnDeleteMiscCustomer").hide();

                if ($("#hidRefreshParent").val() == "1") {
                    closeMe();
                    //parent.document.location.href = parent.document.location.href;
                    parent.RefreshSegmentCustomer();
                }

            });

            function showSegmentCustomerSearch(detailType) {
                customerSearchType = detailType;
                parent.showSegmentCustomerSearch();
            }

            function setupCustomer(customerNo, customerName) {
               
                switch (customerSearchType) {
                    case 'PARTS':
                        $("#lblPartsCustomer").html(customerNo + " - " + customerName);
                        $("#hidPartsCustomerNo").val(customerNo);
                        $("#txtPartsPercent").val("100");
                        $("#ibtnDeletePartsCustomer").show();
                        break;
                    case 'LABOR':
                        $("#lblLaborCustomer").html(customerNo + " - " + customerName);
                        $("#hidLaborCustomerNo").val(customerNo);
                        $("#txtLaborPercent").val("100");
                        $("#ibtnDeleteLaborCustomer").show();
                        break;
                    case 'MISC':
                        $("#lblMiscCustomer").html(customerNo + " - " + customerName);
                        $("#hidMiscCustomerNo").val(customerNo);
                        $("#txtMiscPercent").val("100");
                        $("#ibtnDeleteMiscCustomer").show();
                        break;
                }
            }

            function deleteSegmentCustomer(customerType) {
                switch (customerType) {
                    case 'PARTS':
                        $("#lblPartsCustomer").html("");
                        $("#hidPartsCustomerNo").val("");
                        $("#txtPartsPercent").val("");
                        $("#ibtnDeletePartsCustomer").hide();
                        break;
                    case 'LABOR':
                        $("#lblLaborCustomer").html("");
                        $("#hidLaborCustomerNo").val("");
                        $("#txtLaborPercent").val("");
                        $("#ibtnDeleteLaborCustomer").hide();
                        break;
                    case 'MISC':
                        $("#lblMiscCustomer").html("");
                        $("#hidMiscCustomerNo").val("");
                        $("#txtMiscPercent").val("");
                        $("#ibtnDeleteMiscCustomer").hide();
                        break;

                }
            }

            function validation() {
                var strError = "";
                    if ($.trim($("#txtPartsPercent").val()) == "" && $("#hidPartsCustomerNo").val() != "") {
                        alert("Please enter Parts percent.");
                         strError += "Please enter Parts percent.";
                    }

                    if ($.trim($("#txtLaborPercent").val()) == "" && $("#hidLaborCustomerNo").val() != "") {
                        alert("Please enter Labor percent.");
                        strError += "Please enter Labor percent.";
                    }

                     if ($.trim($("#txtMiscPercent").val()) == "" && $("#hidMiscCustomerNo").val() != "") {
                         alert("Please enter Misc percent.");
                         strError += "Please enter Misc percent.";
                     }

                     var tempFloat = 0;
                     if ($.trim($("#txtPartsPercent").val()) != "") {
                         tempFloat = parseFloat($("#txtPartsPercent").val());
                         if (tempFloat < 0 || tempFloat > 100) {
                             alert("Please correct parts percent.");
                             strError += "Please correct parts percent.";
                         }
                     }
                     if ($.trim($("#txtLaborPercent").val()) != "") {
                         tempFloat = parseFloat($("#txtLaborPercent").val());
                         if (tempFloat < 0 || tempFloat > 100) {
                             alert("Please correct labor percent.");
                             strError += "Please correct labor percent.";
                         }
                     }

                     if ($.trim($("#txtMiscPercent").val()) != "") {
                         tempFloat = parseFloat($("#txtMiscPercent").val());
                         if (tempFloat < 0 || tempFloat > 100) {
                             alert("Please correct misc percent.");
                             strError += "Please correct misc percent.";
                         }
                     }
                     if (strError == "")
                         return true;
                     else
                         return false;

            }

            function setAllCustomer() {
                var customerNo = "";
                var customerType = $("#lstSetAllCustomer").val();

                switch (customerType) {
                    case 'PARTS':
                        if ($("#hidPartsCustomerNo").val() != "") {
                            $("#hidLaborCustomerNo").val($("#hidPartsCustomerNo").val());
                            $("#lblLaborCustomer").html($("#lblPartsCustomer").html());
                            $("#txtLaborPercent").val($("#txtPartsPercent").val());
                            $("#ibtnDeleteLaborCustomer").show();

                            $("#hidMiscCustomerNo").val($("#hidPartsCustomerNo").val());
                            $("#lblMiscCustomer").html($("#lblPartsCustomer").html());
                            $("#txtMiscPercent").val($("#txtPartsPercent").val());
                            $("#ibtnDeleteMiscCustomer").show();
                        }
                        break;
                    case 'LABOR':
                        if ($("#hidLaborCustomerNo").val() != "") {
                            $("#hidPartsCustomerNo").val($("#hidLaborCustomerNo").val());
                            $("#lblPartsCustomer").html($("#lblLaborCustomer").html());
                            $("#txtPartsPercent").val($("#txtLaborPercent").val());
                            $("#ibtnDeletePartsCustomer").show();

                            $("#hidMiscCustomerNo").val($("#hidLaborCustomerNo").val());
                            $("#lblMiscCustomer").html($("#lblLaborCustomer").html());
                            $("#txtMiscPercent").val($("#txtLaborPercent").val());
                            $("#ibtnDeleteMiscCustomer").show();
                        }
                        break;
                    case 'MISC':
                        if ($("#hidMiscCustomerNo").val() != "") {
                            $("#hidPartsCustomerNo").val($("#hidMiscCustomerNo").val());
                            $("#lblPartsCustomer").html($("#lblMiscCustomer").html());
                            $("#txtPartsPercent").val($("#txtMiscPercent").val());
                            $("#ibtnDeletePartsCustomer").show();

                            $("#hidLaborCustomerNo").val($("#hidMiscCustomerNo").val());
                            $("#lblLaborCustomer").html($("#lblMiscCustomer").html());
                            $("#txtLaborPercent").val($("#txtMiscPercent").val());
                            $("#ibtnDeleteLaborCustomer").show();
                        }
                        break;
                }
            }


            function closeMe() {
                parent.closeSegmentCustomer();
            }
     </script>
</asp:Content>
