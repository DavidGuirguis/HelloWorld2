<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SegmentCustomersDisplay.ascx.cs" Inherits="Modules_Quote_Controls_SegmentCustomerDisplay" %>
 <table class="segmentCustomers" width="100%">
                    <tr>
                        <td colspan="9" class="tSb" style=" text-align:center; background-color:#ffeba5 "> Segment Summary  &nbsp;&nbsp;&nbsp;&nbsp; 
                            
                        <span style="float:right"> <asp:Button ID="btnSegmentCustomerEdit" runat="server" OnClientClick="return showSegmentCustomer();"  Text="Edit" /> </span> </td> 
                    </tr>
                    <tr>
                        <th style=" text-align:left">
                            Customer
                        </th>
                        <th colspan="2">
                            Parts
                        </th>
                        <th colspan="2">
                            Labor
                        </th>
                        <th colspan="2">
                            Misc
                        </th>
                        <th>
                            Total
                        </th>
                        <th><!-- <CODE_TAG_101750>-->
                            Seg Total
                        </th>
                    </tr>
                    <tr>
                        <th style="width:35%">
                        </th>
                        <th style="width:5%">
                            %
                        </th>
                        <th style="width:10%">
                            Amount
                        </th>
                        <th style="width:5%">
                            %
                        </th>
                        <th style="width:10%">
                            Amount
                        </th>
                        <th style="width:5%">
                            %
                        </th>
                        <th style="width:10%">
                            Amount
                        </th>
                        <th style="width:10%">
                            Amount
                        </th>
                        <th style="width:10%"><!-- <CODE_TAG_101750>-->
                            Amount
                        </th>
                    </tr>
                    <tr  id="trSegmentCustomerHeader" runat="server" >
                        <td style=" text-align:left">
                            <asp:Label ID="lblHeaderCustomer" runat="server"></asp:Label>
                        </td>
                        <td style=" text-align:center">
                            <asp:Label ID="lblHeaderCustomerPartsPercent" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblHeaderCustomerPartsInd" style="float:left" runat="server"></asp:Label>
                            <asp:Label ID="lblHeaderCustomerPartsTotal" style="float:right; color:black" runat="server"></asp:Label>
                        </td>
                        <td style=" text-align:center">
                            <asp:Label ID="lblHeaderCustomerLaborPercent" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblHeaderCustomerLaborInd" style="float:left" runat="server"></asp:Label>
                            <asp:Label ID="lblHeaderCustomerLaborTotal" style="float:right; color:black" runat="server"></asp:Label>
                        </td>
                        <td style=" text-align:center">
                            <asp:Label ID="lblHeaderCustomerMiscPercent" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblHeaderCustomerMiscInd" style="float:left" runat="server"></asp:Label>
                            <asp:Label ID="lblHeaderCustomerMiscTotal" style="float:right; color:black" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblHeaderCustomerTotal" runat="server"></asp:Label>
                        </td>
                        <td>
                            <!-- <CODE_TAG_101750>-->
                            <asp:Label ID="lblHeaderCustomerSegmentTotal" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr id="trSegmentCustomer1" runat="server"  >
                        <td style=" text-align:left">
                            <asp:Label ID="lblSegmentCustomer1" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblSegmentCustomer1PartsPercent" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblSegmentCustomer1PartsInd" style="float:left" runat="server"></asp:Label>
                            <asp:Label ID="lblSegmentCustomer1PartsTotal" style="float:right; color:black" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblSegmentCustomer1LaborPercent" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblSegmentCustomer1LaborInd" style="float:left" runat="server"></asp:Label>
                            <asp:Label ID="lblSegmentCustomer1LaborTotal" style="float:right; color:black" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblSegmentCustomer1MiscPercent" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblSegmentCustomer1MiscInd" style="float:left" runat="server"></asp:Label>
                            <asp:Label ID="lblSegmentCustomer1MiscTotal" style="float:right; color:black" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblSegmentCustomer1Total" runat="server"></asp:Label>
                        </td>
                        <td>
                            <!-- <CODE_TAG_101750>-->
                            <asp:Label ID="lblSegmentCustomer1SegmentTotal" runat="server"></asp:Label>
                        </td>
                    </tr>
                  <tr id="trSegmentCustomer2" runat="server"  >
                        <td style=" text-align:left">
                            <asp:Label ID="lblSegmentCustomer2" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblSegmentCustomer2PartsPercent" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblSegmentCustomer2PartsInd" style="float:left" runat="server"></asp:Label>
                            <asp:Label ID="lblSegmentCustomer2PartsTotal" style="float:right; color:black" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblSegmentCustomer2LaborPercent" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblSegmentCustomer2LaborInd" style="float:left" runat="server"></asp:Label>
                            <asp:Label ID="lblSegmentCustomer2LaborTotal" style="float:right; color:black" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblSegmentCustomer2MiscPercent" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblSegmentCustomer2MiscInd" style="float:left" runat="server"></asp:Label>
                            <asp:Label ID="lblSegmentCustomer2MiscTotal" style="float:right; color:black" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblSegmentCustomer2Total" runat="server"></asp:Label>
                        </td>
                        <td>
                            <!-- <CODE_TAG_101750>-->
                            <asp:Label ID="lblSegmentCustomer2SegmentTotal" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr id="trSegmentCustomer3" runat="server"  >
                        <td style=" text-align:left">
                            <asp:Label ID="lblSegmentCustomer3" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblSegmentCustomer3PartsPercent" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblSegmentCustomer3PartsInd" style="float:left" runat="server"></asp:Label>
                            <asp:Label ID="lblSegmentCustomer3PartsTotal" style="float:right; color:black" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblSegmentCustomer3LaborPercent" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblSegmentCustomer3LaborInd" style="float:left" runat="server"></asp:Label>
                            <asp:Label ID="lblSegmentCustomer3LaborTotal"  style="float:right; color:black" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblSegmentCustomer3MiscPercent" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblSegmentCustomer3MiscInd" style="float:left" runat="server"></asp:Label>
                            <asp:Label ID="lblSegmentCustomer3MiscTotal" style="float:right; color:black" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblSegmentCustomer3Total" runat="server"></asp:Label>
                        </td>
                        <td>
                            <!-- <CODE_TAG_101750>-->
                            <asp:Label ID="lblSegmentCustomer3SegmentTotal" runat="server"></asp:Label>
                        </td>
                    </tr>


                    <tr id="trSegmentTotal" runat="server">
                        <th style=" text-align:left">
                            <span style="float:left">Total &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:DropDownList ID="lstTotalFlatRate"  runat="server" ClientIDMode="Static" onchange="lstTotalFlatRate_onChange();"   >
                                <asp:ListItem Text="Calculated" Value="N"></asp:ListItem> 
                                <asp:ListItem Text="Flat Rate All" Value="F"></asp:ListItem> 
                            </asp:DropDownList>
                            </span>
                            <span style="float:right">
                                <asp:Label ID="lblGrandTotalVariance"  runat="server" ClientIDMode="Static" ></asp:Label>
                            </span>
                        </th>
                        <td></td>
                        <td>
                            <asp:Label ID="lblPartsTotalInd" style="float:left" runat="server"></asp:Label>
                            <asp:Label ID="lblPartsTotal" style="float:right; color:black" runat="server"></asp:Label>
                        </td>
                        <td></td>
                        <td>
                            <asp:Label ID="lblLaborTotalInd" style="float:left" runat="server"></asp:Label>
                            <asp:Label ID="lblLaborTotal" style="float:right; color:black" runat="server"></asp:Label>
                        </td>
                        <td></td>
                        <td>
                            <asp:Label ID="lblMiscTotalInd" style="float:left" runat="server"></asp:Label>
                            <asp:Label ID="lblMiscTotal" style="float:right; color:black" runat="server"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="lblGrandTotalInd" style="float:left; color:Red" runat="server"></asp:Label>
                            <asp:Label ID="lblGrandTotal" runat="server" ClientIDMode="Static" ></asp:Label>
                            <asp:TextBox ID="txtGrandTotal" runat="server" CssClass="tAr numbersOnly" ClientIDMode="Static" ></asp:TextBox>
                        </td>
                         <td>
                            <!-- <CODE_TAG_101750>-->
                            <asp:Label ID="lblGrandSegmentTotalInd" style="float:left; color:Red" runat="server"></asp:Label>
                            <asp:Label ID="lblGrandSegmentTotal" runat="server" ClientIDMode="Static" ></asp:Label>
                            <%--<asp:TextBox ID="txtGrandSegmentTotal" runat="server" CssClass="tAr numbersOnly" ClientIDMode="Static" ></asp:TextBox>--%>
                        </td>
                    </tr>
                </table>
                <script type="text/javascript" >
                    var CATAPICustomerNo = "<%= CATAPICustomerNo %>";
                
                </script>