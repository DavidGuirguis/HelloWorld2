<%@ Page Title="" Language="C#" MasterPageFile="~/Library/MasterPages/iFrame.master" AutoEventWireup="true" CodeFile="ImportBulkParts.aspx.cs" Inherits="ImportBulkParts" 
	clientIDMode="Static"%>

<asp:Content ID="Content1" ContentPlaceHolderID="cntMP" runat="Server">
	<table id="table1" width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td>
				<asp:Panel ID="pnlInitTables" ScrollBars="Auto" Width="260" Height="605" runat="server">
					<div id="divInitTables" runat="server">
						<table id="tableParts" width="100%" cellpadding="30" cellspacing="0" border="0">
							<tr>
								<td style="text-align: right; padding: 5px 0px 5px 0px">
									<asp:Button ID="btnNext" runat="server" Text="ValidateWebService" OnClick="btnNext_Click" style="display:none;"/>
									<asp:HiddenField ID="hidRowsCount" runat="server"/>
									<input type="button" ID="btnValidateLocally" value="Validate" onclick="return ValidatePartsLocally(1)"/>
								</td>
							</tr>
							<tr>
								<td style="font-weight: bold; text-align: left; background-color: #f7ae39; height: 20px">Adding Parts
								</td>
							</tr>
							<tr>
								<td align="center">
									<table id="tableParts_Entry"  cellpadding="20" cellspacing="30" border="0">
										<tr id="tableParts_Entry_Header">
											<td class="header" style=" text-align: left; width:16px"></td>
											<td class="header" style=" text-align: left; width:35px">SOS
											</td>
											<td class="header" style=" text-align: left; width:95px">Part No
											</td>
											<td class="header" style="text-align: right; width:35px">Qty
											</td>
                                            <%//<CODE_TAG_104427> Dav
                                            if (isShowDiscount)
                                            { 
                                                if (!string.IsNullOrEmpty(partDiscountHeading))
                                                    Response.Write("<td class='header' style='text-align: right; width:35px'>" + partDiscountHeading + "(%)</td>");
                                                else
                                                    Response.Write("<td class='header' style='text-align: right; width:35px'>" + ((isMarkupDiscount) ? "Markup(%)" : "Discount(%)") + "</th>");
                                            }
                                            //</CODE_TAG_104427> Dav%>
										</tr>

										<%
										for(int i= 1; i<19; i++)
										{
										%>
										<tr id="tableParts_Entry_Data">
											<td><img alt="" src="" id="imgStatus" width="16" /></td>
											<td class="detail" style="text-align: left;">
												<input type="text" ID="txtSOS" name="txtSOS<%=i%>" value="<%= AppContext.Current.AppSettings["psQuoter.ERPAPI.Segment.Parts.CATPart.SOS.Code"].Trim().ToUpper().As<string>("000") %>" class="w25" style="text-transform: uppercase;"/>
											</td>
											<td class="detail" style="text-align: left;">
												<input type="text" ID="txtPartNo" name="txtPartNo<%=i%>" value="" class="w90p" style="text-transform: uppercase;"/>
											</td>
											<td class="detail" style="text-align: right;">
												<input type="text" ID="txtQty" name="txtQty<%=i%>" value="1" class="w25  tAr"/>
											</td>
                                            <%//<CODE_TAG_104427> Dav
                                            if (isShowDiscount) {  %>
                                            <td class="detail" style="text-align: right;">
                                                <input type="text" ID="txtPartDiscount" name="txtPartDiscount<%=i%>" value="" class="w25  tAr"/>
                                            </td>
                                            <% }
                                            //</CODE_TAG_104427> Dav%>
										</tr>
										<%
										}
										%>
										<tr>
                                            <%--<CODE_TAG_104427> Dav--%>
                                            <%--<td colspan="4" style="border-top:1px solid black;"></td>--%>

                                            <% if (isShowDiscount){%>
                                            <td colspan="5" style="border-top:1px solid black;"></td>
                                            <%} else {%>
										    <td colspan="4" style="border-top:1px solid black;"></td>
                                            <%}%>
                                            <%--</CODE_TAG_104427> Dav--%>
										</tr>
										<tr>
											<td></td>
											<td><b>Total:</b></td>
											<td style="text-align:left; padding-left:6px"><span id="spnPartTotal"></span></td>
											<td style="text-align:right; padding-right:8px"><span id="spnQtyTotal"></span></td>
                                            <%//<CODE_TAG_104427> Dav
                                            if (isShowDiscount){%>
                                            <td></td>
                                            <%}
                                            //</CODE_TAG_104427> Dav%>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td style="font-weight: bold; text-align: right; background-color: #f7ae39; height: 2px">
								</td>
							</tr>
							<tr>
								<td style="text-align: right; padding: 5px 0px 5px 0px">
									<input type="button" ID="btnValidateLocally" value="Validate" onclick="return ValidatePartsLocally(1)"/>
								</td>
							</tr>
						</table>
					</div>
				</asp:Panel>
		    </td>
			<td style="padding-left:25px" >
				<asp:Panel ID="Panel2" ScrollBars="Auto" Width="720" Height="600" runat="server">
					<asp:ScriptManager ID="scriptmanager1" runat="Server" AsyncPostBackTimeout="120" EnableScriptGlobalization="True" />
					<asp:UpdatePanel ID="updPartsValidation" runat="server" EnableViewState="true" UpdateMode="Conditional">
						<Triggers>
							<asp:AsyncPostBackTrigger ControlID="btnNext" />
						</Triggers>
						<ContentTemplate>
							<div id="divMainTables" style="padding-top:0px">
								<table width="100%">
									<tr>
										<td style="padding: 5px 0px 5px 0px; height:21px;">
											<asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red" Text=""></asp:Label>
										</td>
										<td style="text-align: right; padding: 5px 0px 5px 0px; height:21px;">
											<asp:Button OnClientClick="importPartsToParent();" ID="btnImport" name="btnImport" Text="Import" runat="server" CssClass="ui-button ui-widget ui-state-default ui-corner-all" />
											<asp:Button OnClientClick="closeMe();" ID="btnClose" name="btnClose" Text="Cancel" runat="server" CssClass="ui-button ui-widget ui-state-default ui-corner-all" />
										</td>
									</tr>
								</table>
									<asp:Repeater ID="rptParts_Validated" runat="server" OnItemDataBound="rptParts_Validated_ItemDataBound">
										<HeaderTemplate>
											<table id="tableParts_Validated" width="100%" cellpadding="30" cellspacing="0">
												<tr>
													<td colspan="11" style="font-weight: bold; text-align: left; background-color: #f7ae39; height: 20px; vertical-align:middle;"><img title="Validated Parts" src="../../../library/images/checkmark.png"  width="16"/> Validated Parts
													</td>
												</tr>
												<tr>
													<td class="header" style="width: 5%; text-align: left;">SOS
													</td>
													<td class="header" style="width: 10%; text-align: left;">Part No
													</td>
													<td class="header" style="width: 15%; text-align: left;">Description
													</td>
                                                    <td class="header" style="width: 5%; text-align: right;">Qty
													</td>
													<td class="header" style="width: 10%; text-align: right;">Unit Sell
													</td>
													<td class="header" style="width: 10%; text-align: right;">Unit Disc
													</td>
													<td class="header" style="width: 10%; text-align: right;">Net Sell
													</td>
													<td class="header" style="width: 10%; text-align: right;">Unit Price
													</td>
                                                    <%//<CODE_TAG_104427> Dav
                                                    if (isShowDiscount)
                                                    {
                                                        if (!string.IsNullOrEmpty(partDiscountHeading))
                                                        {
                                                            %>
                                                            <%--<td class='header' style='width: 10%; text-align: right;'><%= partDiscountHeading %>(%)</td>--%>
                                                            <%--<td class='header' style='width: 10%; text-align: right;'><%= partDiscountHeading %></td>--%>
                                                        <%}
                                                        else
                                                        {%>
                                                            <%--<td class='header' style='width: 10%; text-align: right;'><%= ((isMarkupDiscount) ? "Markup(%)" : "Discount(%)") %></td>--%>
                                                            <%--<td class='header' style='width: 10%; text-align: right;'><%= ((isMarkupDiscount) ? "Markup Price" : "Discount Price") %></td>--%>
                                                        <%}
                                                    }
                                                   //</CODE_TAG_104427> Dav %>
													<td class="header" style="width: 5%; text-align: Center;">Core
													</td>
												</tr>
										</HeaderTemplate>
										<ItemTemplate>
											<tr>
												<td class="detail" style="text-align: left;">
													<asp:Label ID="lblSOS" runat="server" Text=""></asp:Label>
													<asp:HiddenField ID="hidPartPrice" runat="server" />
												</td>
												<td class="detail" style="text-align: left;">
													<asp:Label ID="lblPartNo" runat="server" Text=""></asp:Label>
												</td>
												<td class="detail" style="text-align: left;">
													<asp:Label ID="lblDesc" runat="server" Text=""></asp:Label>
												</td>
												<td class="detail" style="text-align: right;">
													<asp:Label ID="lblQty" runat="server" Text=""></asp:Label>
												</td>
												<td class="detail" style="text-align: right;">
													<asp:Label ID="lblUnitSell" runat="server" Text=""></asp:Label>
												</td>
												<td class="detail" style="text-align: right;">
													<asp:Label ID="lblUnitDisc" runat="server" Text=""></asp:Label>
												</td>
												<td class="detail" style="text-align: right;">
													<asp:Label ID="lblNetSell" runat="server" Text=""></asp:Label>
												</td>
												<td class="detail" style="text-align: right;">
													<asp:Label ID="lblUnitPrice" runat="server" Text=""></asp:Label>
												</td>
                                                <%//<CODE_TAG_104427> Dav
                                                if (isShowDiscount)
                                                {%>
                                                    <%--<td class='detail' style='text-align: right;'><asp:Label ID='lblPartDiscount' runat='server' Text=''></asp:Label></td>--%>
                                                    <%--<td class='detail' style='text-align: right;'><asp:Label ID='lblPartDiscPrice' runat='server' Text=''></asp:Label></td>--%>
                                                <%
                                                }
                                                //</CODE_TAG_104427> Dav%>
												<td class="detail" style="text-align: center;">
													<asp:Label ID="lblCore" runat="server" Text=""></asp:Label>
												</td>
											</tr>
										</ItemTemplate>
										<AlternatingItemTemplate>
											<tr>
												<td class="detailAlter" style="text-align: left;">
													<asp:Label ID="lblSOS" runat="server" Text=""></asp:Label>
													<asp:HiddenField ID="hidPartPrice" runat="server" />
												</td>
												<td class="detailAlter" style="text-align: left;">
													<asp:Label ID="lblPartNo" runat="server" Text=""></asp:Label>
												</td>
												<td class="detailAlter" style="text-align: left;">
													<asp:Label ID="lblDesc" runat="server" Text=""></asp:Label>
												</td>
												<td class="detailAlter" style="text-align: right;">
													<asp:Label ID="lblQty" runat="server" Text=""></asp:Label>
												</td>
												<td class="detailAlter" style="text-align: right;">
													<asp:Label ID="lblUnitSell" runat="server" Text=""></asp:Label>
												</td>
												<td class="detailAlter" style="text-align: right;">
													<asp:Label ID="lblUnitDisc" runat="server" Text=""></asp:Label>
												</td>
												<td class="detailAlter" style="text-align: right;">
													<asp:Label ID="lblNetSell" runat="server" Text=""></asp:Label>
												</td>
												<td class="detailAlter" style="text-align: right;">
													<asp:Label ID="lblUnitPrice" runat="server" Text=""></asp:Label>
												</td>
                                                <%//<CODE_TAG_104427> Dav
                                                if (isShowDiscount)
                                                {%>
                                                   <%-- <td class='detailAlter' style='text-align: right;'><asp:Label ID='lblPartDiscount' runat='server' Text=''></asp:Label></td>--%>
                                                    <%--<td class='detailAlter' style='text-align: right;'><asp:Label ID='lblPartDiscPrice' runat='server' Text=''></asp:Label></td>--%>
                                                <%
                                                }
                                                //</CODE_TAG_104427> Dav%>
												<td class="detailAlter" style="text-align: center;">
													<asp:Label ID="lblCore" runat="server" Text=""></asp:Label>
												</td>
											</tr>
										</AlternatingItemTemplate>
										<FooterTemplate>
											</table>
										</FooterTemplate>
									</asp:Repeater>
									<asp:Repeater ID="rptParts_Replacements" runat="server" OnItemDataBound="rptParts_Replacement_ItemDataBound">
										<HeaderTemplate>
											<table id="tableParts_Replacements" width="100%" cellpadding="0" cellspacing="0">
												<tr>
													<td colspan="12" style="font-weight: bold; text-align: left; background-color: #f7ae39; height: 20px; vertical-align:middle;"><img title="Validated Parts" src="../../../library/images/retweet.png"  width="16"/> Replacement Parts
													</td>
												</tr>
										</HeaderTemplate>
										<ItemTemplate>
											<tr>
												<td colspan="12" style="font-weight: bold; text-align: left; background-color: #efefef; height: 20px; border-top: 2px solid #f7ae39;">Current Part:
												</td>
											</tr>
											<tr>
												<td class="header" style="width: 5%; text-align: left;">SOS
												</td>
												<td class="header" style="width: 10%; text-align: left;">Part No
												</td>
												<td class="header" style="width: 15%; text-align: left;">Description
												</td>
                                                <td class="header" style="width: 5%; text-align: right;">Qty
												</td>
												<td class="header" style="width: 10%; text-align: right;">Unit Sell
												</td>
												<td class="header" style="width: 10%; text-align: right;">Unit Disc
												</td>
												<td class="header" style="width: 10%; text-align: right;">Net Sell
												</td>
												<td class="header" style="width: 10%; text-align: right;">Unit Price
												</td>
                                                <%//<CODE_TAG_104427> Dav
                                                if (isShowDiscount)
                                                {
                                                    if (!string.IsNullOrEmpty(partDiscountHeading))
                                                    {
                                                        %>
                                                        <%--<td class='header' style='width: 10%; text-align: right;'><%= partDiscountHeading %>(%)</td>--%>
                                                        <%--<td class='header' style='width: 10%; text-align: right;'><%= partDiscountHeading %></td>--%>
                                                    <%}
                                                    else
                                                    {%>
                                                        <%--<td class='header' style='width: 10%; text-align: right;'><%= ((isMarkupDiscount) ? "Markup(%)" : "Discount(%)") %></td>--%>
                                                        <%--<td class='header' style='width: 10%; text-align: right;'><%= ((isMarkupDiscount) ? "Markup Price" : "Discount Price") %></td>--%>
                                                    <%}
                                                }
                                                //</CODE_TAG_104427> Dav %>
												<td class="header" style="width: 5%; text-align: center;">Core
												</td>
												<td class="header" style="width: 15%; text-align: center;"></td>
												<td class="header" style="width: 5%; text-align: right;"></td>
											</tr>
											<tr>
												<td class="detail" style="text-align: left;">
													<asp:Label ID="lblSOS" runat="server" Text="Label"></asp:Label>
												</td>
												<td class="detail" style="text-align: left;">
													<asp:Label ID="lblPartNo" runat="server" Text=""></asp:Label>
												</td>
												<td class="detail" style="text-align: left;">
													<asp:Label ID="lblDesc" runat="server" Text=""></asp:Label>
												</td>
												<td class="detail" style="text-align: right;">
													<asp:Label ID="lblQty" runat="server" Text=""></asp:Label>
												</td>
												<td class="detail" style="text-align: right;">
													<asp:Label ID="lblUnitSell" runat="server" Text=""></asp:Label>
												</td>
												<td class="detail" style="text-align: right;">
													<asp:Label ID="lblUnitDisc" runat="server" Text=""></asp:Label>
												</td>
												<td class="detail" style="text-align: right;">
													<asp:Label ID="lblNetSell" runat="server" Text=""></asp:Label>
												</td>
												<td class="detail" style="text-align: right;">
													<asp:Label ID="lblUnitPrice" runat="server" Text=""></asp:Label>
												</td>
                                                <%//<CODE_TAG_104427> Dav
                                                if (isShowDiscount)
                                                {%>
                                                    <%--<td class='detail' style='text-align: right;'><asp:Label ID='lblPartDiscount' runat='server' Text=''></asp:Label></td>--%>
                                                    <%--<td class='detail' style='text-align: right;'><asp:Label ID='lblPartDiscPrice' runat='server' Text=''></asp:Label></td>--%>
                                                <%
                                                }
                                                //</CODE_TAG_104427> Dav%>
												<td class="detail" style="text-align: center;">
													<asp:Label ID="lblCore" runat="server" Text=""></asp:Label>
												</td>
												<td class="detail" style="text-align: left;"></td>
												<td class="detail" style="text-align: right;">
													<asp:Literal ID="litRadioPart" runat="server"></asp:Literal>
												</td>
											</tr>
											<tr>
												<td colspan="11" style="font-weight: bold; text-align: left; background-color: #efefef; height: 20px">Replacement Parts:
												</td>
											</tr>
											<tr>
												<td colspan="100">
													<asp:Repeater ID="rptParts_Detail" runat="server" OnItemDataBound="rptParts_Replacement_Detail_ItemDataBound">
														<HeaderTemplate>
															<table width="100%" cellpadding="0" cellspacing="0">
																<tr>
																	<td class="header" style="width: 5%; text-align: left;">SOS
													                </td>
													                <td class="header" style="width: 10%; text-align: left;">Part No
													                </td>
													                <td class="header" style="width: 15%; text-align: left;">Description
													                </td>
                                                                    <td class="header" style="width: 5%; text-align: right;">Qty
													                </td>
													                <td class="header" style="width: 10%; text-align: right;">Unit Sell
													                </td>
													                <td class="header" style="width: 10%; text-align: right;">Unit Disc
													                </td>
													                <td class="header" style="width: 10%; text-align: right;">Net Sell
													                </td>
													                <td class="header" style="width: 10%; text-align: right;">Unit Price
													                </td>
                                                                    <%//<CODE_TAG_104427> Dav
                                                                    if (isShowDiscount)
                                                                    {
                                                                        if (!string.IsNullOrEmpty(partDiscountHeading))
                                                                        {
                                                                            %>
                                                                            <%--<td class='header' style='width: 10%; text-align: right;'><%= partDiscountHeading %>(%)</td>--%>
                                                                            <%--<td class='header' style='width: 10%; text-align: right;'><%= partDiscountHeading %></td>--%>
                                                                        <%}
                                                                        else
                                                                        {%>
                                                                            <%--<td class='header' style='width: 10%; text-align: right;'><%= ((isMarkupDiscount) ? "Markup(%)" : "Discount(%)") %></td>--%>
                                                                            <%--<td class='header' style='width: 10%; text-align: right;'><%= ((isMarkupDiscount) ? "Markup Price" : "Discount Price") %></td>--%>
                                                                        <%}
                                                                    }
                                                                    //</CODE_TAG_104427> Dav %>
																	<td class="header" style="width: 5%; text-align: center;">Core
																	</td>
																	<td class="header" style="width: 15%; text-align: center;">Availablity
																	</td>
																	<td class="header" style="width: 5%; text-align: right;">
																		<asp:Literal ID="litRadioPart" runat="server"></asp:Literal>
																	</td>
																</tr>
														</HeaderTemplate>
														<ItemTemplate>
															<tr>
																<td class="detail" style="text-align: left;">
																	<asp:Label ID="lblSOS" runat="server" Text=""></asp:Label>
																</td>
																<td class="detail" style="text-align: left;">
																	<asp:Label ID="lblPartNo" runat="server" Text=""></asp:Label>
																</td>
																<td class="detail" style="text-align: left;">
																	<asp:Label ID="lblDesc" runat="server" Text=""></asp:Label>
																</td>
																<td class="detail" style="text-align: right;">
																	<asp:Label ID="lblQty" runat="server" Text=""></asp:Label>
																</td>
																<td class="detail" style="text-align: right;">
																	<asp:Label ID="lblUnitSell" runat="server" Text=""></asp:Label>
																</td>
																<td class="detail" style="text-align: right;">
																	<asp:Label ID="lblUnitDisc" runat="server" Text=""></asp:Label>
																</td>
																<td class="detail" style="text-align: right;">
																	<asp:Label ID="lblNetSell" runat="server" Text=""></asp:Label>
																</td>
																<td class="detail" style="text-align: right;">
																	<asp:Label ID="lblUnitPrice" runat="server" Text=""></asp:Label>
																</td>
                                                                <%//<CODE_TAG_104427> Dav
                                                                if (isShowDiscount)
                                                                {%>
                                                                    <%--<td class='detail' style='text-align: right;'><asp:Label ID='lblPartDiscount' runat='server' Text=''></asp:Label></td>--%>
                                                                    <%--<td class='detail' style='text-align: right;'><asp:Label ID='lblPartDiscPrice' runat='server' Text=''></asp:Label></td>--%>
                                                                    <%
                                                                }
                                                                //</CODE_TAG_104427> Dav%>
																<td class="detail" style="text-align: center;">
																	<asp:Label ID="lblCore" runat="server" Text=""></asp:Label>
																</td>
																<td class="detail" style="text-align: left;">
																	<asp:Label ID="lblIndirect" runat="server" Text=""></asp:Label>
																</td>

																<td class="detail" style="text-align: right;">
																	<asp:Literal ID="litCheckboxPart" runat="server"></asp:Literal>
																</td>
															</tr>
														</ItemTemplate>
														<AlternatingItemTemplate>
															<tr>
																<td class="detailAlter" style="text-align: left;">
																	<asp:Label ID="lblSOS" runat="server" Text=""></asp:Label>
																</td>
																<td class="detailAlter" style="text-align: left;">
																	<asp:Label ID="lblPartNo" runat="server" Text=""></asp:Label>
																</td>
																<td class="detailAlter" style="text-align: left;">
																	<asp:Label ID="lblDesc" runat="server" Text=""></asp:Label>
																</td>
																<td class="detailAlter" style="text-align: right;">
																	<asp:Label ID="lblQty" runat="server" Text=""></asp:Label>
																</td>
																<td class="detailAlter" style="text-align: right;">
																	<asp:Label ID="lblUnitSell" runat="server" Text=""></asp:Label>
																</td>
																<td class="detailAlter" style="text-align: right;">
																	<asp:Label ID="lblUnitDisc" runat="server" Text=""></asp:Label>
																</td>
																<td class="detailAlter" style="text-align: right;">
																	<asp:Label ID="lblNetSell" runat="server" Text=""></asp:Label>
																</td>
																<td class="detailAlter" style="text-align: right;">
																	<asp:Label ID="lblUnitPrice" runat="server" Text=""></asp:Label>
																</td>
                                                                <%//<CODE_TAG_104427> Dav
                                                                if (isShowDiscount)
                                                                {%>
                                                                    <%--<td class='detailAlter' style='text-align: right;'><asp:Label ID='lblPartDiscount' runat='server' Text=''></asp:Label></td>--%>
                                                                    <%--<td class='detailAlter' style='text-align: right;'><asp:Label ID='lblPartDiscPrice' runat='server' Text=''></asp:Label></td>--%>
                                                                <%
                                                                }
                                                                //</CODE_TAG_104427> Dav%>
																<td class="detailAlter" style="text-align: center;">
																	<asp:Label ID="lblCore" runat="server" Text=""></asp:Label>
																</td>
																<td class="detailAlter" style="text-align: left;">
																	<asp:Label ID="lblIndirect" runat="server" Text=""></asp:Label>
																</td>
																<td class="detailAlter" style="text-align: right;">
																	<asp:Literal ID="litCheckboxPart" runat="server"></asp:Literal>
																</td>
															</tr>
														</AlternatingItemTemplate>
														<FooterTemplate>
															</table>
														</FooterTemplate>
													</asp:Repeater>
												</td>
											</tr>
										</ItemTemplate>
										<FooterTemplate>
											</table>
										</FooterTemplate>
									</asp:Repeater>
									<asp:Repeater ID="rptParts_Alternates" runat="server" OnItemDataBound="rptParts_Alter_ItemDataBound">
										<HeaderTemplate>
											<table id="tableParts_Alternates" width="100%" cellpadding="0" cellspacing="0">
												<tr>
													<td colspan="11" style="font-weight: bold; text-align: left; background-color: #f7ae39; height: 20px; vertical-align:middle;"><img title="Validated Parts" src="../../../library/images/shuffle.png"  width="16"/> Alternate Parts
													</td>
												</tr>
										</HeaderTemplate>
										<ItemTemplate>
											<tr>
												<td colspan="11" style="font-weight: bold; text-align: left; background-color: #efefef; height: 20px; border-top: 2px solid #f7ae39;">Current Part:
												</td>
											</tr>
											<tr>
												<td class="header" style="width: 5%; text-align: left;">SOS
												</td>
												<td class="header" style="width: 10%; text-align: left;">Part No
												</td>
												<td class="header" style="width: 15%; text-align: left;">Description
												</td>
                                                <td class="header" style="width: 5%; text-align: right;">Qty
												</td>
												<td class="header" style="width: 10%; text-align: right;">Unit Sell
												</td>
												<td class="header" style="width: 10%; text-align: right;">Unit Disc
												</td>
												<td class="header" style="width: 10%; text-align: right;">Net Sell
												</td>
												<td class="header" style="width: 10%; text-align: right;">Unit Price
												</td>
                                                <%//<CODE_TAG_104427> Dav
                                                if (isShowDiscount)
                                                {
                                                    if (!string.IsNullOrEmpty(partDiscountHeading))
                                                    {
                                                        %>
                                                        <%--<td class='header' style='width: 10%; text-align: right;'><%= partDiscountHeading %>(%)</td>--%>
                                                        <%--<td class='header' style='width: 10%; text-align: right;'><%= partDiscountHeading %></td>--%>
                                                    <%}
                                                    else
                                                    {%>
                                                        <%--<td class='header' style='width: 10%; text-align: right;'><%= ((isMarkupDiscount) ? "Markup(%)" : "Discount(%)") %></td>--%>
                                                        <%--<td class='header' style='width: 10%; text-align: right;'><%= ((isMarkupDiscount) ? "Markup Price" : "Discount Price") %></td>--%>
                                                    <%}
                                                }
                                                //</CODE_TAG_104427> Dav %>
												<td class="header" style="width: 5%; text-align: center;">Core
												</td>
												<td class="header" style="width: 5%; text-align: right;"></td>
											</tr>
											<tr>
												<td class="detail" style="text-align: left;">
													<asp:Label ID="lblSOS" runat="server" Text="Label"></asp:Label>
												</td>
												<td class="detail" style="text-align: left;">
													<asp:Label ID="lblPartNo" runat="server" Text=""></asp:Label>
												</td>
												<td class="detail" style="text-align: left;">
													<asp:Label ID="lblDesc" runat="server" Text=""></asp:Label>
												</td>
												<td class="detail" style="text-align: right;">
													<asp:Label ID="lblQty" runat="server" Text=""></asp:Label>
												</td>
												<td class="detail" style="text-align: right;">
													<asp:Label ID="lblUnitSell" runat="server" Text=""></asp:Label>
												</td>
												<td class="detail" style="text-align: right;">
													<asp:Label ID="lblUnitDisc" runat="server" Text=""></asp:Label>
												</td>
												<td class="detail" style="text-align: right;">
													<asp:Label ID="lblNetSell" runat="server" Text=""></asp:Label>
												</td>
												<td class="detail" style="text-align: right;">
													<asp:Label ID="lblUnitPrice" runat="server" Text=""></asp:Label>
												</td>
                                                <%//<CODE_TAG_104427> Dav
                                                if (isShowDiscount)
                                                {%>
                                                    <%--<td class='detail' style='text-align: right;'><asp:Label ID='lblPartDiscount' runat='server' Text=''></asp:Label></td>--%>
                                                    <%--<td class='detail' style='text-align: right;'><asp:Label ID='lblPartDiscPrice' runat='server' Text=''></asp:Label></td>--%>
                                                <%
                                                }
                                                //</CODE_TAG_104427> Dav%>
												<td class="detail" style="text-align: center;">
													<asp:Label ID="lblCore" runat="server" Text=""></asp:Label>
												</td>
												<td class="detail" style="text-align: right;">
													<asp:Literal ID="litRadioPart" runat="server"></asp:Literal>
												</td>
											</tr>
											<tr>
												<td colspan="11" style="font-weight: bold; text-align: left; background-color: #efefef; height: 20px">Alternate Parts:
												</td>
											</tr>
											<tr>
												<td colspan="100">
													<asp:Repeater ID="rptParts_Detail" runat="server" OnItemDataBound="rptParts_Alter_Detail_ItemDataBound">
														<HeaderTemplate>
															<table width="100%" cellpadding="0" cellspacing="0">
																<tr>
																	<td class="header" style="width: 5%; text-align: left;">SOS
													                </td>
													                <td class="header" style="width: 10%; text-align: left;">Part No
													                </td>
													                <td class="header" style="width: 15%; text-align: left;">Description
													                </td>
                                                                    <td class="header" style="width: 5%; text-align: right;">Qty
													                </td>
													                <td class="header" style="width: 10%; text-align: right;">Unit Sell
													                </td>
													                <td class="header" style="width: 10%; text-align: right;">Unit Disc
													                </td>
													                <td class="header" style="width: 10%; text-align: right;">Net Sell
													                </td>
													                <td class="header" style="width: 10%; text-align: right;">Unit Price
													                </td>
                                                                    <%//<CODE_TAG_104427> Dav
                                                                    if (isShowDiscount)
                                                                    {
                                                                        if (!string.IsNullOrEmpty(partDiscountHeading))
                                                                        {
                                                                            %>
                                                                            <%--<td class='header' style='width: 10%; text-align: right;'><%= partDiscountHeading %>(%)</td>--%>
                                                                            <%--<td class='header' style='width: 10%; text-align: right;'><%= partDiscountHeading %></td>--%>
                                                                        <%}
                                                                        else
                                                                        {%>
                                                                            <%--<td class='header' style='width: 10%; text-align: right;'><%= ((isMarkupDiscount) ? "Markup(%)" : "Discount(%)") %></td>--%>
                                                                            <%--<td class='header' style='width: 10%; text-align: right;'><%= ((isMarkupDiscount) ? "Markup Price" : "Discount Price") %></td>--%>
                                                                        <%}
                                                                    }
                                                                    //</CODE_TAG_104427> Dav %>
																	<td class="header" style="width: 5%; text-align: center;">Core
																	</td>
																	<td class="header" style="width: 5%; text-align: right;"></td>
																</tr>
														</HeaderTemplate>
														<ItemTemplate>
															<tr>
																<td class="detail" style="text-align: left;">
																	<asp:Label ID="lblSOS" runat="server" Text=""></asp:Label>
																</td>
																<td class="detail" style="text-align: left;">
																	<asp:Label ID="lblPartNo" runat="server" Text=""></asp:Label>
																</td>
																<td class="detail" style="text-align: left;">
																	<asp:Label ID="lblDesc" runat="server" Text=""></asp:Label>
																</td>
																<td class="detail" style="text-align: right;">
																	<asp:Label ID="lblQty" runat="server" Text=""></asp:Label>
																</td>
																<td class="detail" style="text-align: right;">
																	<asp:Label ID="lblUnitSell" runat="server" Text=""></asp:Label>
																</td>
																<td class="detail" style="text-align: right;">
																	<asp:Label ID="lblUnitDisc" runat="server" Text=""></asp:Label>
																</td>
																<td class="detail" style="text-align: right;">
																	<asp:Label ID="lblNetSell" runat="server" Text=""></asp:Label>
																</td>
																<td class="detail" style="text-align: right;">
																	<asp:Label ID="lblUnitPrice" runat="server" Text=""></asp:Label>
																</td>
                                                                <%//<CODE_TAG_104427> Dav
                                                                if (isShowDiscount)
                                                                {%>
                                                                    <%--<td class='detail' style='text-align: right;'><asp:Label ID='lblPartDiscount' runat='server' Text=''></asp:Label></td>--%>
                                                                    <%--<td class='detail' style='text-align: right;'><asp:Label ID='lblPartDiscPrice' runat='server' Text=''></asp:Label></td>--%>
                                                                <%
                                                                }
                                                                //</CODE_TAG_104427> Dav%>
																<td class="detail" style="text-align: center;">
																	<asp:Label ID="lblCore" runat="server" Text=""></asp:Label>
																</td>
																<td class="detail" style="text-align: right;">
																	<asp:Literal ID="litRadioPart" runat="server"></asp:Literal>
																</td>
															</tr>
														</ItemTemplate>
														<AlternatingItemTemplate>
															<tr>
																<td class="detailAlter" style="text-align: left;">
																	<asp:Label ID="lblSOS" runat="server" Text=""></asp:Label>
																</td>
																<td class="detailAlter" style="text-align: left;">
																	<asp:Label ID="lblPartNo" runat="server" Text=""></asp:Label>
																</td>
																<td class="detailAlter" style="text-align: left;">
																	<asp:Label ID="lblDesc" runat="server" Text=""></asp:Label>
																</td>
																<td class="detailAlter" style="text-align: right;">
																	<asp:Label ID="lblQty" runat="server" Text=""></asp:Label>
																</td>
																<td class="detailAlter" style="text-align: right;">
																	<asp:Label ID="lblUnitSell" runat="server" Text=""></asp:Label>
																</td>
																<td class="detailAlter" style="text-align: right;">
																	<asp:Label ID="lblUnitDisc" runat="server" Text=""></asp:Label>
																</td>
																<td class="detailAlter" style="text-align: right;">
																	<asp:Label ID="lblNetSell" runat="server" Text=""></asp:Label>
																</td>
																<td class="detailAlter" style="text-align: right;">
																	<asp:Label ID="lblUnitPrice" runat="server" Text=""></asp:Label>
																</td>
                                                                <%//<CODE_TAG_104427> Dav
                                                                if (isShowDiscount)
                                                                {%>
                                                                    <%--<td class='detailAlter' style='text-align: right;'><asp:Label ID='lblPartDiscount' runat='server' Text=''></asp:Label></td>--%>
                                                                    <%--<td class='detailAlter' style='text-align: right;'><asp:Label ID='lblPartDiscPrice' runat='server' Text=''></asp:Label></td>--%>
                                                                <%
                                                                }
                                                                //</CODE_TAG_104427> Dav%>
																<td class="detailAlter" style="text-align: center;">
																	<asp:Label ID="lblCore" runat="server" Text=""></asp:Label>
																</td>
																<td class="detailAlter" style="text-align: right;">
																	<asp:Literal ID="litRadioPart" runat="server"></asp:Literal>
																</td>
															</tr>
														</AlternatingItemTemplate>
														<FooterTemplate>
															</table>
														</FooterTemplate>
													</asp:Repeater>
												</td>
											</tr>
										</ItemTemplate>
										<FooterTemplate>
											</table>
										</FooterTemplate>
									</asp:Repeater>
									<asp:Repeater ID="rptParts_Exceptions" runat="server" OnItemDataBound="rptParts_Exceptions_ItemDataBound">
										<HeaderTemplate>
											<table id="tableParts_Exceptions" width="100%" cellpadding="0" cellspacing="0">
												<tr>
													<td colspan="10" style="font-weight: bold; text-align: left; background-color: #f7ae39; height: 20px; vertical-align:middle;"><img title="Validated Parts" src="../../../library/images/blocked.png"  width="16"/> Exceptions
													</td>
												</tr>
												<tr>
													<td class="header" style="width: 20%; text-align: left;">Part No
													</td>
													<td class="header" style="width: 75%; text-align: left;">Error Message
													</td>
													<td class="header" style="width: 5%;"></td>
												</tr>
										</HeaderTemplate>
										<ItemTemplate>
											<tr>
												<td class="detail" style="text-align: left;">
													<asp:Label ID="lblPartNo" runat="server" Text=""></asp:Label>
												</td>
												<td class="detail" style="text-align: left;">
													<asp:Label ID="lblMsg" runat="server" Text=""></asp:Label>
												</td>
												<td class="detail" style="text-align: right;">
													<asp:Literal ID="litCheckPart" runat="server"></asp:Literal>
												</td>
											</tr>
										</ItemTemplate>
										<AlternatingItemTemplate>
											<tr>
												<td class="detailAlter" style="text-align: left;">
													<asp:Label ID="lblPartNo" runat="server" Text=""></asp:Label>
												</td>
												<td class="detailAlter" style="text-align: left;">
													<asp:Label ID="lblMsg" runat="server" Text=""></asp:Label>
												</td>
												<td class="detailAlter" style="text-align: right;">
													<asp:Literal ID="litCheckPart" runat="server"></asp:Literal>
												</td>
											</tr>
										</AlternatingItemTemplate>
										<FooterTemplate>
											</table>
										</FooterTemplate>
									</asp:Repeater>
								<table width="100%">
									<tr>
										<td style="text-align: right; padding: 5px 0px 5px 0px">
											<asp:Button OnClientClick="importPartsToParent();" ID="btnImport2" name="btnImport" Text="Import" runat="server" CssClass="ui-button ui-widget ui-state-default ui-corner-all" />
											<asp:Button OnClientClick="closeMe();" ID="btnClose2" name="btnClose" Text="Cancel" runat="server" CssClass="ui-button ui-widget ui-state-default ui-corner-all" />
										</td>
									</tr>
								</table>
							</div>
						</ContentTemplate>
					</asp:UpdatePanel>
				</asp:Panel>
		    </td>
		</tr>
	</table>
	
	<asp:UpdateProgress ID="updProgress" runat="server">
		<ProgressTemplate>
			<div id="div_Waiting" style="position: absolute; left: 380px; top: 150px; z-index:100">
				<img id="img_Waiting" src="../../../library/images/waiting.gif" />
			</div>
		</ProgressTemplate>
	</asp:UpdateProgress>
	
	<div id="divPartSearch" style="display:none;">
		<iframe id="iframePartSearch" src="" width="100%" height="480px" frameborder="0" scrolling="yes"  ></iframe>
    </div>

	<script type="text/javascript">	
		
		var globalIndex = 1;
		$(document).ready(function () {
			$j("[id=imgStatus]").hide();
			UpdateTotals();
			RefreshBindings();

			$j("#divPartSearch").dialog({
				width: 815,
				height: 530,
				draggable: true,
				position: 'right',
				resizable: false,
				modal: true,
				title: 'Parts Search',
				autoOpen: false,
				close: CloseDialog
			});
		});

		function CloseDialog() {
			$j("#bottomContainer").html("");
			$j("#topContainer").html("");

			if (globalIndex < $j("[id=tableParts_Entry_Data]").length) {
				globalIndex++;
				ValidatePartsLocally(globalIndex);
			}
			else {
				//postback
				ValidateParts();
			}
		}

		function RefreshBindings() {
			//Allow only numbers
			$('[id=txtQty]').unbind('keydown');
			$('[id=txtQty]').keydown(function (event) {
				// Allow: backspace, delete, tab, escape
				if ($.inArray(event.keyCode, [46, 8, 9, 27]) != -1 ||
					// Allow: Ctrl+A
					(event.keyCode == 65 && event.ctrlKey === true) ||
					// Allow: home, end, left, right
					(event.keyCode >= 35 && event.keyCode <= 39)) {
					// let it happen, don't do anything
					return;
				}
				else {
					// Ensure that it is a number and stop the keypress
					if (event.shiftKey || (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105)) {
						event.preventDefault();
					}
				}
			});

			$('[id=txtQty]').unbind('keyup');
			$('[id=txtQty]').keyup(function (event) {
				UpdateTotals();
			});

			$('[id=txtPartNo]').unbind('keyup');
			$('[id=txtPartNo]').keyup(function () {
				UpdateTotals();
			});

		    //Remove the onblur event from all the rows then add it to the last one only
		    //<CODE_TAG_104427> Dav
			//$j("[id*=txtQty]").removeAttr("onblur");
			//var LastRow = $("[id=tableParts_Entry_Data]:last");
		    //$j("[id*=txtQty]", LastRow).attr("onblur", "AddLine(this)");

            <%if(isShowDiscount){%>
		        $j("[id*=txtPartDiscount]").removeAttr("onblur");
			    var LastRow = $("[id=tableParts_Entry_Data]:last");
			    $j("[id*=txtPartDiscount]", LastRow).attr("onblur", "AddLine(this)");
		    <%} else {%>
		        $j("[id*=txtQty]").removeAttr("onblur");
		        var LastRow = $("[id=tableParts_Entry_Data]:last");
		        $j("[id*=txtQty]", LastRow).attr("onblur", "AddLine(this)");
            <%}%>
		    //</CODE_TAG_104427> Dav
		}

		function InitTable()
		{
			//Hide all images and remove all tr status tags
			$j("[id=tableParts_Entry_Data]").removeAttr("data-status");
			$j("[id=imgStatus]").hide();
			$("#divMainTables").html("");
		}
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
		function EndRequestHandler(sender, args)
        {
			//move the scroll to the top
			$('#pnlInitTables').scrollTop(0);

			//show the status icons
			$j("#tableParts_Validated tr").each(function () {
				if ($("#lblPartNo", this).text() == "") {
					return true;
				}
				var PartNo = $("#lblPartNo", this).text().trim();
				var SOS = $("#lblSOS", this).text().trim();				
				$j("#tableParts_Entry tr").each(function () {
					if ($.trim($("#txtPartNo", this).val()) != "") {
						if ($.trim($("#txtPartNo", this).val().toUpperCase()) == PartNo.toUpperCase()
							&& $.trim($("#txtSOS", this).val().toUpperCase()) == SOS.toUpperCase()) {
							$(this).attr("data-status", "validated");
							$("#imgStatus", this).attr("src", "../../../library/images/checkmark.png");
							$("#imgStatus", this).attr("title", "Validated Parts");
							$("#imgStatus", this).show();
						}
					}
				});
			});
			
			$j("#tableParts_Replacements tr").each(function () {
				if ($("#lblPartNo", this).text() == "") {
					return true;
				}
				var PartNo = $("#lblPartNo", this).text().trim();
				var SOS = $("#lblSOS", this).text().trim();
				$j("#tableParts_Entry tr").each(function () {
					if ($.trim($("#txtPartNo", this).val()) != "") {
						if ($.trim($("#txtPartNo", this).val().toUpperCase()) == PartNo.toUpperCase()
							&& $.trim($("#txtSOS", this).val().toUpperCase()) == SOS.toUpperCase()) {
							$(this).attr("data-status", "replacement");
							$("#imgStatus", this).attr("src", "../../../library/images/retweet.png");
							$("#imgStatus", this).attr("title", "Replacement Parts");
							$("#imgStatus", this).show();
						}
					}
				});
			});
			
			$j("#tableParts_Alternates tr").each(function () {
				if ($("#lblPartNo", this).text() == "") {
					return true;
				}
				var PartNo = $("#lblPartNo", this).text().trim();
				var SOS = $("#lblSOS", this).text().trim();
				$j("#tableParts_Entry tr").each(function () {
					if($.trim($("#txtPartNo", this).val())!= ""){
						if ($.trim($("#txtPartNo", this).val().toUpperCase()) == PartNo.toUpperCase()
							&& $.trim($("#txtSOS", this).val().toUpperCase()) == SOS.toUpperCase()) {
							$(this).attr("data-status", "alternate");
							$("#imgStatus", this).attr("src", "../../../library/images/shuffle.png");
							$("#imgStatus", this).attr("title", "Alternate Parts");
							$("#imgStatus", this).show();
						}
					}
				});
			});

			$j("#tableParts_Exceptions tr").each(function () {
				if ($("#lblPartNo", this).text() == "") {
					return true;
				}
				var PartNo = $("#lblPartNo", this).text().trim();
				var SOS = $("#lblSOS", this).text().trim();
				$j("#tableParts_Entry tr").each(function () {
					if($.trim($("#txtPartNo", this).val())!= ""){
						if ($.trim($("#txtPartNo", this).val().toUpperCase()) == PartNo.toUpperCase()
							//&& $.trim($("#txtSOS", this).val().toUpperCase()) == SOS.toUpperCase()
							) {
							$(this).attr("data-status", "exception");
							$("#imgStatus", this).attr("src", "../../../library/images/blocked.png");
							$("#imgStatus", this).attr("title", "Exceptions");
							$("#imgStatus", this).show();
						}
					}
				});
			});

			//Grouping the Parts as per the status
			var HeaderRow = $j("#tableParts_Entry_Header");
			var Rows = $("#tableParts_Entry tr[data-status='exception']")
			$(HeaderRow).after(Rows);
			Rows = $("#tableParts_Entry tr[data-status='alternate']")
			$(HeaderRow).after(Rows);
			Rows = $("#tableParts_Entry tr[data-status='replacement']")
			$(HeaderRow).after(Rows);
			Rows = $("#tableParts_Entry tr[data-status='validated']")
			$(HeaderRow).after(Rows);

			//Adjust the Names of the controls to reflect the new ordering. without this step, if the user click on validate again and uses the Part Search popup, the selected Part will be updated in wrong control
			var index = 1;
			$j("[id=tableParts_Entry_Data]").each(function () {
				$j("[id*=txtPartNo]", this).attr("name", "txtPartNo" + index);
				$j("[id*=txtSOS]", this).attr("name", "txtSOS" + index);
				$j("[id*=txtQty]", this).attr("name", "txtQty" + index);   // <CODE_TAG_105398> lwang
				index++;
			});

			//Refresh all bindings and add onblur event on the last row
			RefreshBindings();
		}
		
		function UpdateTotals(obj) {
			var PartsCount = $("#tableParts_Entry [id=txtPartNo][value!=]").length;
			
			var QtyTotal = 0;
			$j("#tableParts_Entry [id=tableParts_Entry_Data]").each(function () {
				if ($j("#txtPartNo", this).val().trim() != "") {
					QtyTotal = QtyTotal + parseInt($("#txtQty", this).val());
				}
			});
			$j("#spnPartTotal").text(PartsCount+" part(s)");
			$j("#spnQtyTotal").text(QtyTotal);
		}

		function ValidatePartsLocally(index) {
			$j('#updProgress').show();
			InitTable();

			globalIndex = index;
			var tr = $j("[id=tableParts_Entry_Data]")[index-1];
			var SOS = "";
			var PartNo = "";

			SOS = $j("#txtSOS", tr).val().trim();
			PartNo = $j("#txtPartNo", tr).val().trim();

			//if ($j("#txtSOS", tr).val().trim() == "" && $j("#txtPartNo", tr).val().trim() != "") {
			if ($j("#txtPartNo", tr).val().trim() != "") {
				var request = $.ajax({
					url: "SegmentDetailAjaxHandler.ashx?OP=&field=&ItemID=" + index + "&SOS=" + SOS + "&PartNo=" + PartNo + "&Source=BULKPARTS",
					type: "POST",
					cache: false,
					async: true,
					beforeSend: function () {
						
					},
					complete: function () {
						
					},
					success: function (htmlContent) {
						var rtOp = htmlContent.substr(0, 1);	//E:Multiple/No Parts found			U:Update SOS Only
						htmlContent = htmlContent.substr(2);
						var rtSOS = htmlContent.substr(0, htmlContent.indexOf(","));
						htmlContent = htmlContent.substr(htmlContent.indexOf(",") + 1);
						
						$j("#txtSOS", tr).val(rtSOS);
						if (rtOp == "E") {
							$j('#updProgress').hide();

							$j(tr).effect('highlight', 1000);
							$j("[id=imgStatus]").hide();
							$("#imgStatus", tr).attr("src", "../../../library/images/arrow.png");
							$("#imgStatus", tr).show();
							$('#pnlInitTables').scrollTop(parseInt($('#tableParts tr:eq(' + index + ')').position().top));
							
							eval(htmlContent);
							return false;
						}
						else {
							if (index < $j("[id=tableParts_Entry_Data]").length) {
								index++;
								ValidatePartsLocally(index);
							}
							else {
								ValidateParts();
							}
						}
					},
					error: function () {
						//alert("error");
					}
				});
			}
			else {
				if (index < $j("[id=tableParts_Entry_Data]").length) {
					index++;
					ValidatePartsLocally(index);
				}
				else {
					ValidateParts();
				}
			}
		}

		function partSearch(itemId, sos, partNo, sosDesc) {
			currentPartItemId = itemId;
			var strURL = "../Part_Search.aspx?RecordNo=20&IsBulkPartsImport=1&ItemID=" + itemId;
			if (sos != null)
				strURL += "&sos=" + sos;
			if (partNo != null)
				strURL += "&partNo=" + partNo;
			if (sosDesc != null)
				strURL += "&sosDesc=" + sosDesc;
			
			$j("#iframePartSearch").attr("src", strURL);
			$j("#divPartSearch").dialog("open");
		}
		function closePartSearch() {
			$j('#divPartSearch').dialog('close','Add');
		}
		function updatePart(index, partNo, sos) {
			$j("[name=txtSOS" + index + "]").val(sos);
			$j("[name=txtPartNo" + index + "]").val(partNo);
		}
		function ValidateParts() {
			$j("[id*=hidRowsCount]").val($j("[id=tableParts_Entry_Data]").length);
			$("#<%=btnNext.ClientID %>").click();
		}
		
		function AddLine(obj) {
			var LastRow = $j(obj).closest("tr");
			var RowIndex = $j("[id=tableParts_Entry_Data]").length;
			var NewControlId = parseInt(RowIndex, 0) + 1;
			var NewRow = $(LastRow).clone();

			$j("[id*=txtQty]", LastRow).removeAttr("onblur");

			var NewSOSControl = $j("[id*=txtSOS]", NewRow);
			$(NewRow).attr("data-status", "");
			$j("[id*=txtSOS]", NewRow).val('<%= AppContext.Current.AppSettings["psQuoter.ERPAPI.Segment.Parts.CATPart.SOS.Code"].Trim().ToUpper().As<string>("000") %>').attr("name", "txtSOS" + NewControlId);
			$j("[id*=txtPartNo]", NewRow).attr("value", '').attr("name", "txtPartNo" + NewControlId);
			$j("[id*=txtQty]", NewRow).val('1').attr("name", "txtQty" + NewControlId);
			$j("[id*=txtPartDiscount]", NewRow).attr("value", '').attr("name", "txtPartDiscount" + NewControlId);       //<CODE_TAG_104427> Dav
			$j("[id*=imgStatus]", NewRow).hide();

			$(LastRow).after(NewRow);
			$j(NewSOSControl).focus();

			UpdateTotals();
			RefreshBindings();
		}

		function importPartsToParent() {

			var selectedData = "{\"data\":[";

			$('#tableParts_Validated tr').each(function () {
				var hidData = $(this).find("[id*=hidPartPrice]"); 
				if (hidData.length != 0) {
					selectedData += hidData.val() + ",";
				}
			});

			$('#tableParts_Replacements input[type=radio]:checked').each(function () {
				if ($(this).attr("partData") != "")
					selectedData += $(this).attr("partData") + ",";
			});

			$('#tableParts_Replacements input[type=checkbox]:checked').each(function () {
				selectedData += $(this).attr("partData") + ",";
			});

			$('#tableParts_Alternates input[type=radio]:checked').each(function () {
				selectedData += $(this).attr("partData") + ",";
			});

			$('#tableParts_Exceptions input[type=checkbox]:checked').each(function () {
				selectedData += $(this).attr("partData") + ",";
			});
			if (selectedData.substring(selectedData.length - 1, selectedData.length) == ",") {
				selectedData = selectedData.substring(0, selectedData.length - 1);
			}
			selectedData += "]}";

			parent.importSelectedParts(selectedData);
			closeMe();
		}
		
		function setReplacementSelectedPart(partNo, val) {
			if (val == 1) {
				$("[name^=chk_" + partNo + "]").removeAttr("disabled");
				$("[name^=chk_" + partNo + "]").filter("[indirectFlag=N]").prop('checked', true);
				$("[name^=chk_" + partNo + "]").filter("[indirectFlag=Y]").prop('checked', false);
			}
			else {
				$("[name^=chk_" + partNo + "]").prop('checked', false);
				$("[name^=chk_" + partNo + "]").attr("disabled", "true");
			}
		}

		function closeMe() {
			$("#divMainTables").html("");
			$("#divInitTables").html("");
			parent.closeImportBulk();
		}
		
		function UpdateImg(ctrl, imgsrc) {
			$("#" + ctrl).attr("src", imgsrc);
		}
	</script>

</asp:Content>
