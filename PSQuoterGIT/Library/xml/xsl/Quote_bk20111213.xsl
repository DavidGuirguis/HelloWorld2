<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xsl:output version="1.0" method="html" encoding="UTF-8" indent="no" />
    <xsl:variable name="XML1" select="/" />
    <xsl:variable name="fo:layout-master-set">
        <fo:layout-master-set>
            <fo:simple-page-master master-name="default-page" page-height="11in" page-width="8.5in" margin-left="0.6in" margin-right="0.6in">
                <fo:region-body margin-top="0.79in" margin-bottom="0.79in" />
                <fo:region-after extent="10mm"/>	<!-- [<IAranda 20080915> PrintConfig.]-->
            </fo:simple-page-master>
        </fo:layout-master-set>
    </xsl:variable>
	<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	<xsl:template match="/">
        <xsl:variable name="maxwidth" select="7.30000" />
        <fo:root>
            <xsl:copy-of select="$fo:layout-master-set" />
            <fo:page-sequence master-reference="default-page" initial-page-number="1" format="1">
				<!-- [<IAranda 20080915> PrintConfig.] START-->
				<xsl:variable name="tablewidthFoot" select="$maxwidth * 0.98000" />
				<xsl:variable name="displayFooter" select="$XML1/root/QuoteFooter/DisplayFooter"></xsl:variable>
				<xsl:if test="$displayFooter != 0">
					<fo:static-content flow-name="xsl-region-after">
						<fo:block>
							<fo:table width="{$tablewidthFoot}in">
								<fo:table-column column-width="4in" />
								<fo:table-column />
								<fo:table-column />
								<fo:table-body font-size="7px">
									<fo:table-row>
										<fo:table-cell>
											<fo:block>
												<xsl:for-each select="$XML1">
													<xsl:for-each select="root/QuoteHeader/Table/CustomerName">
														<fo:inline>
															<xsl:apply-templates></xsl:apply-templates>
														</fo:inline>
													</xsl:for-each>
												</xsl:for-each>
											</fo:block>
										</fo:table-cell>
										<fo:table-cell text-align="left">
											<fo:block>
												<xsl:for-each select="$XML1">
													<xsl:for-each select="root/QuoteHeader/Table/QuoteNo">
														<fo:inline>
															<xsl:apply-templates></xsl:apply-templates>
														</fo:inline>
													</xsl:for-each>
												</xsl:for-each>
											</fo:block>
										</fo:table-cell>
										<fo:table-cell text-align="right">
											<fo:block>Page <fo:page-number/></fo:block>
										</fo:table-cell>
									</fo:table-row>
								</fo:table-body>
							</fo:table>
						</fo:block>
					</fo:static-content>
				</xsl:if>
				<!-- [<IAranda 20080915> PrintConfig.] END-->
                <fo:flow flow-name="xsl-region-body">
                    <fo:block>
                        <fo:block>
                            <fo:leader leader-pattern="space" />
                        </fo:block>
                        <xsl:variable name="tablewidth0" select="$maxwidth * 0.98000" />
                        <xsl:variable name="sumcolumnwidths0" select="0.000" />
                        <xsl:variable name="defaultcolumns0" select="1 + 1" />
                        <xsl:variable name="defaultcolumnwidth0">
                            <xsl:choose>
                                <xsl:when test="$defaultcolumns0 &gt; 0">
                                    <xsl:value-of select="($tablewidth0 - $sumcolumnwidths0) div $defaultcolumns0" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="0.000" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="columnwidth0_0" select="$defaultcolumnwidth0" />
                        <xsl:variable name="columnwidth0_1" select="$defaultcolumnwidth0" />
                        <fo:table width="{$tablewidth0}in" space-before.optimum="1pt" space-after.optimum="2pt" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
                            <fo:table-column column-width="{$columnwidth0_0}in" />
                            <fo:table-column column-width="{$columnwidth0_1}in" />
                            <fo:table-body>
<!-- <IAranda 20080618> Start-->
                                <xsl:variable name="logoAlign" select="root/QuoteHeader/logoAlign" />	<!-- [<IAranda 20080807> LogoAlign.] -->
                                <fo:table-row text-align="{$logoAlign}">		<!-- [<IAranda 20080807> LogoAlign.] -->
                                    <fo:table-cell bottom="0.00000in" height="0.01042in" number-columns-spanned="1">
                                        <fo:block padding-top="1pt" padding-bottom="1pt">
														<fo:external-graphic>
															<xsl:attribute name="src"><xsl:value-of select="root/QuoteHeader/logoUrl" /></xsl:attribute>
														</fo:external-graphic>
										</fo:block>
                                    </fo:table-cell>
                                    <!-- BEGIN: <CODE_TAG_100877> Ticket#7867  04/01/2011 kshao-->
                                    <!--<fo:table-cell bottom="0.00000in" height="0.01042in" font-size="12px" font-weight="bold" number-columns-spanned="1" >-->
                                    <fo:table-cell bottom="0.00000in" height="0.01042in" font-size="12px" font-weight="bold" number-columns-spanned="1" text-align="right">
                                    <!-- END: <CODE_TAG_100877> Ticket#7867  04/01/2011 kshao-->
										<fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                  <!-- BEGIN: <CODE_TAG_100877> Ticket#7867  03/28/2011 kshao-->
                                                                  <!--<xsl:for-each select="BranchAddress"> -->
                                                                    <xsl:for-each select="BranchAddress1">
                                                                  <!-- end:   //<CODE_TAG_100877> Ticket#7867  03/28/2011 kshao-->
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth0_1" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                 </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                         </fo:block>
                                         <!-- BEGIN: <CODE_TAG_100877> Ticket#7867  03/28/2011 kshao-->
                                          <fo:block padding-top="1pt" padding-bottom="1pt">
                                            <xsl:for-each select="$XML1">
                                              <xsl:for-each select="root">
                                                <xsl:for-each select="QuoteHeader">
                                                  <xsl:for-each select="Table">
                                                    <xsl:for-each select="BranchAddress2">
                                                      <fo:inline>
                                                        <xsl:apply-templates>
                                                          <xsl:with-param name="maxwidth" select="$columnwidth0_1" />
                                                        </xsl:apply-templates>
                                                      </fo:inline>
                                                    </xsl:for-each>
                                                  </xsl:for-each>
                                                </xsl:for-each>
                                              </xsl:for-each>
                                            </xsl:for-each>
                                          </fo:block>
                                         <!-- end:   //<CODE_TAG_100877> Ticket#7867  03/28/2011 kshao-->
                                         <fo:block padding-top="1pt" padding-bottom="1pt">
											<xsl:for-each select="$XML1">
												<xsl:for-each select="root">
													<xsl:for-each select="QuoteHeader">
														<xsl:for-each select="Table">
															<xsl:for-each select="BranchPhone">
																<fo:inline>
																	<xsl:apply-templates>
																		<xsl:with-param name="maxwidth" select="$columnwidth0_1" />
																	</xsl:apply-templates>
																</fo:inline>
															</xsl:for-each>
														</xsl:for-each>
													</xsl:for-each>
												</xsl:for-each>
											</xsl:for-each>
										</fo:block>
                                   </fo:table-cell>
                                </fo:table-row>
<!-- <IAranda 20080618> End-->
                                <fo:table-row>
                                    <fo:table-cell bottom="0.00000in" number-columns-spanned="2" text-align="center">
                                        <fo:block padding-top="1pt" padding-bottom="1pt" />
                                    </fo:table-cell>
                                </fo:table-row>
                                <fo:table-row>
                                    <fo:table-cell bottom="0.00000in" number-columns-spanned="2" text-align="center">
                                        <fo:block padding-top="1pt" padding-bottom="1pt">
                                            <xsl:choose>
                                                <xsl:when test="$XML1/root/QuoteHeader/Table/Type =&quot;A&quot;">
                                                    <xsl:variable name="tablewidth1" select="$columnwidth0_0 * 1.00000 + $columnwidth0_1 * 1.00000" />
                                                    <xsl:variable name="sumcolumnwidths1" select="0.04167" />
                                                    <xsl:variable name="defaultcolumns1" select="1" />
                                                    <xsl:variable name="defaultcolumnwidth1">
                                                        <xsl:choose>
                                                            <xsl:when test="$defaultcolumns1 &gt; 0">
                                                                <xsl:value-of select="($tablewidth1 - $sumcolumnwidths1) div $defaultcolumns1" />
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="0.000" />
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:variable>
                                                    <xsl:variable name="columnwidth1_0" select="$defaultcolumnwidth1" />
                                                    <fo:table width="{$tablewidth1}in" space-before.optimum="1pt" space-after.optimum="2pt" border-collapse="separate" border-separation="0.04167in" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
                                                        <fo:table-column column-width="{$columnwidth1_0}in" />
                                                        <fo:table-body>
                                                            <fo:table-row>
                                                                <fo:table-cell bottom="0.00000in" padding-top="0.01042in" padding-bottom="0.01042in" padding-left="0.01042in" padding-right="0.01042in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <fo:block space-before.optimum="-8pt">
                                                                            <fo:leader leader-length="100%" leader-pattern="rule" rule-thickness="1pt" color="#000000" />
                                                                        </fo:block>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                            </fo:table-row>
                                                            <fo:table-row>
                                                                <fo:table-cell bottom="0.00000in" font-size="24px" font-weight="bold" display-align="before" height="0.62500in" text-align="center" padding-top="0.01042in" padding-bottom="0.01042in" padding-left="0.01042in" padding-right="0.01042in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <fo:inline>
                                                                            <xsl:text>ADDITIONAL REPAIR NOTIFICATION</xsl:text>
                                                                        </fo:inline>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                            </fo:table-row>
                                                        </fo:table-body>
                                                    </fo:table>
                                                </xsl:when>
                                                <xsl:otherwise />
                                            </xsl:choose>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>
                        <xsl:choose>
                            <xsl:when test="$XML1/root/QuoteHeader/Table/Type =&quot;Q&quot;">
                                <xsl:variable name="tablewidth2" select="$maxwidth * 0.98000" />
                                <xsl:variable name="sumcolumnwidths2" select="0.000" />
                                <xsl:variable name="defaultcolumns2" select="1 + 1" />
                                <xsl:variable name="defaultcolumnwidth2">
                                    <xsl:choose>
                                        <xsl:when test="$defaultcolumns2 &gt; 0">
                                            <xsl:value-of select="($tablewidth2 - $sumcolumnwidths2) div $defaultcolumns2" />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="0.000" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="columnwidth2_0" select="$defaultcolumnwidth2" />
                                <xsl:variable name="columnwidth2_1" select="$defaultcolumnwidth2" />
                                <fo:table width="{$tablewidth2}in" space-before.optimum="1pt" space-after.optimum="2pt" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
                                    <fo:table-column column-width="{$columnwidth2_0}in" />
                                    <fo:table-column column-width="{$columnwidth2_1}in" />
                                    <fo:table-body>
                                        <fo:table-row>
                                            <fo:table-cell bottom="0.00000in" font-size="12px" font-weight="bold" display-align="before" text-align="left">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="CustomerName">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth2_0" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" number-rows-spanned="3" text-align="right">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:choose>
                                                        <xsl:when test="$XML1/root/Parameter/iInternal =1">
                                                            <fo:inline font-size="18px" font-weight="bold">
                                                                <xsl:text>Service Dept. Copy</xsl:text>
                                                            </fo:inline>
                                                        </xsl:when>
                                                        <xsl:otherwise>
<!-- [<IAranda 20080915> PrintConfig.] Start-->
															<xsl:for-each select="$XML1">
																<xsl:for-each select="root">
																	<xsl:for-each select="QuoteHeader">
																		<xsl:for-each select="headerText">
																				<fo:inline font-size="36px" font-weight="bold">
																					<xsl:apply-templates>
																						
																					</xsl:apply-templates>
																				</fo:inline>
																		</xsl:for-each>
																	</xsl:for-each>
																</xsl:for-each>
															</xsl:for-each>
<!-- [<IAranda 20080915> PrintConfig.] End-->
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                        <fo:table-row>
                                            <fo:table-cell bottom="0.00000in" font-size="12px" font-weight="bold" text-align="left" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="Address1">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth2_0" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                    <xsl:if test="$XML1/root/QuoteHeader/Table/Address1 !=&quot;&quot;">
                                                        <fo:inline>
                                                            <xsl:text>&#160;</xsl:text>
                                                        </fo:inline>
                                                    </xsl:if>
                                                  <!-- BEGIN: <CODE_TAG_100877> Ticket#7867  04/04/2011 kshao-->
                                                  </fo:block>
                                                  <fo:block padding-top="1pt" padding-bottom="1pt">
                                                  <!-- END: <CODE_TAG_100877> Ticket#7867  04/04/2011 kshao-->
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="Address2">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth2_0" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                    <xsl:if test="/root/QuoteHeader/Table/Address2 !=&quot;&quot;">
                                                        <fo:inline>
                                                            <xsl:text>&#160;</xsl:text>
                                                        </fo:inline>
                                                    </xsl:if>
                                                  <!-- BEGIN: <CODE_TAG_100877> Ticket#7867  04/04/2011 kshao-->
                                                  </fo:block>
                                                  <fo:block padding-top="1pt" padding-bottom="1pt">
                                                  <!-- END: <CODE_TAG_100877> Ticket#7867  04/04/2011 kshao-->
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="Address3">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth2_0" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                </fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                        <fo:table-row>
                                            <fo:table-cell bottom="0.00000in" font-size="12px" font-weight="bold" text-align="left">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="CityState">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth2_0" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                    <xsl:choose>
                                                        <xsl:when test="/root/QuoteHeader/Table/ZipCode !=&quot;&quot;">
                                                            <fo:inline>
                                                                <xsl:text>, </xsl:text>
                                                            </fo:inline>
                                                            <xsl:for-each select="$XML1">
                                                                <xsl:for-each select="root">
                                                                    <xsl:for-each select="QuoteHeader">
                                                                        <xsl:for-each select="Table">
                                                                            <xsl:for-each select="ZipCode">
                                                                                <fo:inline>
                                                                                    <xsl:apply-templates>
                                                                                        <xsl:with-param name="maxwidth" select="$columnwidth2_0" />
                                                                                    </xsl:apply-templates>
                                                                                </fo:inline>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:when>
                                                        <xsl:otherwise />
                                                    </xsl:choose>
                                                </fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                    </fo:table-body>
                                </fo:table>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="tablewidth3" select="$maxwidth * 0.98000" />
                                <xsl:variable name="sumcolumnwidths3" select="0.000" />
                                <xsl:variable name="defaultcolumns3" select="1 + 1" />
                                <xsl:variable name="defaultcolumnwidth3">
                                    <xsl:choose>
                                        <xsl:when test="$defaultcolumns3 &gt; 0">
                                            <xsl:value-of select="($tablewidth3 - $sumcolumnwidths3) div $defaultcolumns3" />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="0.000" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="columnwidth3_0" select="$defaultcolumnwidth3" />
                                <xsl:variable name="columnwidth3_1" select="$defaultcolumnwidth3" />
                                <fo:table width="{$tablewidth3}in" space-before.optimum="1pt" space-after.optimum="2pt" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
                                    <fo:table-column column-width="{$columnwidth3_0}in" />
                                    <fo:table-column column-width="{$columnwidth3_1}in" />
                                    <fo:table-body>
                                        <fo:table-row>
                                            <fo:table-cell bottom="0.00000in" font-size="12px" font-weight="bold" display-align="before" text-align="left">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="CustomerName">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth3_0" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" font-size="12px" font-weight="bold" text-align="right">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <fo:inline text-decoration="underline">
                                                        <xsl:text>FAX BACK ASAP TO </xsl:text>
                                                    </fo:inline>
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="SRFaxNo">
                                                                        <fo:inline text-decoration="underline">
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth3_1" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                    <fo:inline>
                                                        <xsl:text>&#160;</xsl:text>
                                                    </fo:inline>
                                                </fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                        <fo:table-row>
                                            <fo:table-cell bottom="0.00000in" font-size="12px" font-weight="bold" text-align="left">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="Address1">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth3_0" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                    <fo:inline>
                                                        <xsl:text>&#160;</xsl:text>
                                                    </fo:inline>
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="Address2">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth3_0" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                    <fo:inline>
                                                        <xsl:text>&#160;</xsl:text>
                                                    </fo:inline>
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="Address3">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth3_0" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" font-size="12px" font-weight="bold">
                                                <fo:block padding-top="1pt" padding-bottom="1pt" />
                                            </fo:table-cell>
                                        </fo:table-row>
                                        <fo:table-row>
                                            <fo:table-cell bottom="0.00000in" font-size="12px" font-weight="bold" text-align="left">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="CityState">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth3_0" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                    <xsl:choose>
                                                        <xsl:when test="/root/QuoteHeader/Table/ZipCode !=&quot;&quot;">
                                                            <fo:inline>
                                                                <xsl:text>, </xsl:text>
                                                            </fo:inline>
                                                            <xsl:for-each select="$XML1">
                                                                <xsl:for-each select="root">
                                                                    <xsl:for-each select="QuoteHeader">
                                                                        <xsl:for-each select="Table">
                                                                            <xsl:for-each select="ZipCode">
                                                                                <fo:inline>
                                                                                    <xsl:apply-templates>
                                                                                        <xsl:with-param name="maxwidth" select="$columnwidth3_0" />
                                                                                    </xsl:apply-templates>
                                                                                </fo:inline>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:when>
                                                        <xsl:otherwise />
                                                    </xsl:choose>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt" />
                                            </fo:table-cell>
                                        </fo:table-row>
                                    </fo:table-body>
                                </fo:table>
                            </xsl:otherwise>
                        </xsl:choose>
                        <fo:block>
                            <xsl:text>&#xA;</xsl:text>
                        </fo:block>
                        <xsl:choose>
                            <xsl:when test="$XML1/root/QuoteHeader/Table/Type =&quot;A&quot;">
                                <xsl:variable name="tablewidth4" select="$maxwidth * 0.98000 - 0.01042" />
                                <xsl:variable name="sumcolumnwidths4" select="1.04167 + 1.14583 + 1.14583" />
                                <xsl:variable name="factor4">
                                    <xsl:choose>
                                        <xsl:when test="$sumcolumnwidths4 &gt; 0.00000 and $sumcolumnwidths4 &gt; $tablewidth4">
                                            <xsl:value-of select="$tablewidth4 div $sumcolumnwidths4" />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="1.000" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="defaultcolumns4" select="1 + 1" />
                                <xsl:variable name="defaultcolumnwidth4">
                                    <xsl:choose>
                                        <xsl:when test="$factor4 &lt; 1.000">
                                            <xsl:value-of select="0.000" />
                                        </xsl:when>
                                        <xsl:when test="$defaultcolumns4 &gt; 0">
                                            <xsl:value-of select="($tablewidth4 - $sumcolumnwidths4) div $defaultcolumns4" />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="0.000" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="columnwidth4_0" select="1.04167 * $factor4" />
                                <xsl:variable name="columnwidth4_1" select="$defaultcolumnwidth4" />
                                <xsl:variable name="columnwidth4_2" select="1.14583 * $factor4" />
                                <xsl:variable name="columnwidth4_3" select="1.14583 * $factor4" />
                                <xsl:variable name="columnwidth4_4" select="$defaultcolumnwidth4" />
                                <fo:table width="{$maxwidth}in">
                                    <fo:table-column />
                                    <fo:table-column column-width="{$tablewidth4}in" />
                                    <fo:table-column column-width="{0.01042}in" />
                                    <fo:table-body>
                                        <fo:table-row>
                                            <fo:table-cell>
                                                <fo:block />
                                            </fo:table-cell>
                                            <fo:table-cell>
                                                <fo:block>
                                                    <fo:table width="{$tablewidth4}in" space-before.optimum="1pt" space-after.optimum="2pt" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
                                                        <fo:table-column column-width="{$columnwidth4_0}in" />
                                                        <fo:table-column column-width="{$columnwidth4_1}in" />
                                                        <fo:table-column column-width="{$columnwidth4_2}in" />
                                                        <fo:table-column column-width="{$columnwidth4_3}in" />
                                                        <fo:table-column column-width="{$columnwidth4_4}in" />
                                                        <fo:table-body>
                                                            <fo:table-row font-size="8.5px" font-weight="bold" background-color="silver" text-align="center">
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <fo:inline>
                                                                            <xsl:text>CUSTOMER NO.</xsl:text>
                                                                        </fo:inline>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <fo:inline>
                                                                            <xsl:text>CONTACT</xsl:text>
                                                                        </fo:inline>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <fo:inline>
                                                                            <xsl:text>PHONE NO.</xsl:text>
                                                                        </fo:inline>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <xsl:for-each select="$XML1">
																			<xsl:for-each select="root">
																				<xsl:for-each select="QuoteHeader">
																					<xsl:for-each select="Table">
																					<xsl:for-each select="FaxLabel">
																							<xsl:value-of select="translate(. , $lcletters , $ucletters)"/>
																					</xsl:for-each>
																				</xsl:for-each>
																			</xsl:for-each>
																		</xsl:for-each>
																		</xsl:for-each>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <fo:inline>
                                                                            <xsl:text>EMAIL</xsl:text>
                                                                        </fo:inline>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                            </fo:table-row>
                                                            <fo:table-row font-size="8.5px" font-weight="normal" text-align="center">
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <xsl:for-each select="$XML1">
                                                                            <xsl:for-each select="root">
                                                                                <xsl:for-each select="QuoteHeader">
                                                                                    <xsl:for-each select="Table">
                                                                                        <xsl:for-each select="CustomerNo">
                                                                                            <fo:inline>
                                                                                                <xsl:apply-templates>
                                                                                                    <xsl:with-param name="maxwidth" select="$columnwidth4_0 - 0.01042 - 0.01042" />
                                                                                                </xsl:apply-templates>
                                                                                            </fo:inline>
                                                                                        </xsl:for-each>
                                                                                    </xsl:for-each>
                                                                                </xsl:for-each>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <xsl:for-each select="$XML1">
                                                                            <xsl:for-each select="root">
                                                                                <xsl:for-each select="QuoteHeader">
                                                                                    <xsl:for-each select="Table">
                                                                                        <xsl:for-each select="ContactName">
                                                                                            <fo:inline>
                                                                                                <xsl:apply-templates>
                                                                                                    <xsl:with-param name="maxwidth" select="$columnwidth4_1 - 0.01042 - 0.01042" />
                                                                                                </xsl:apply-templates>
                                                                                            </fo:inline>
                                                                                        </xsl:for-each>
                                                                                    </xsl:for-each>
                                                                                </xsl:for-each>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <xsl:for-each select="$XML1">
                                                                            <xsl:for-each select="root">
                                                                                <xsl:for-each select="QuoteHeader">
                                                                                    <xsl:for-each select="Table">
                                                                                        <xsl:for-each select="PhoneNo">
                                                                                            <fo:inline>
                                                                                                <xsl:apply-templates>
                                                                                                    <xsl:with-param name="maxwidth" select="$columnwidth4_2 - 0.01042 - 0.01042" />
                                                                                                </xsl:apply-templates>
                                                                                            </fo:inline>
                                                                                        </xsl:for-each>
                                                                                    </xsl:for-each>
                                                                                </xsl:for-each>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <xsl:for-each select="$XML1">
                                                                            <xsl:for-each select="root">
                                                                                <xsl:for-each select="QuoteHeader">
                                                                                    <xsl:for-each select="Table">
                                                                                        <xsl:for-each select="FaxNo">
                                                                                            <fo:inline>
                                                                                                <xsl:apply-templates>
                                                                                                    <xsl:with-param name="maxwidth" select="$columnwidth4_3 - 0.01042 - 0.01042" />
                                                                                                </xsl:apply-templates>
                                                                                            </fo:inline>
                                                                                        </xsl:for-each>
                                                                                    </xsl:for-each>
                                                                                </xsl:for-each>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <xsl:for-each select="$XML1">
                                                                            <xsl:for-each select="root">
                                                                                <xsl:for-each select="QuoteHeader">
                                                                                    <xsl:for-each select="Table">
                                                                                        <xsl:for-each select="Email">
                                                                                            <fo:inline>
                                                                                                <xsl:apply-templates>
                                                                                                    <xsl:with-param name="maxwidth" select="$columnwidth4_4 - 0.01042 - 0.01042" />
                                                                                                </xsl:apply-templates>
                                                                                            </fo:inline>
                                                                                        </xsl:for-each>
                                                                                    </xsl:for-each>
                                                                                </xsl:for-each>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                            </fo:table-row>
                                                            <fo:table-row font-size="8.5px" font-weight="bold" background-color="silver" text-align="center">
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <!-- Rajesh feb 25, 2009 -->
                                                                        <xsl:for-each select="$XML1">
																			<xsl:for-each select="root">
																				<xsl:for-each select="QuoteHeader">
																					<xsl:for-each select="headerText">
																							<xsl:value-of select="translate(. , $lcletters , $ucletters)"/>
																					</xsl:for-each>
																				</xsl:for-each>
																			</xsl:for-each>
																		</xsl:for-each>
                                                                        <fo:inline>
                                                                            <xsl:text>QUOTE NO.</xsl:text>
                                                                        </fo:inline>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <fo:inline>
                                                                            <xsl:text>P.O. NO.</xsl:text>
                                                                        </fo:inline>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <fo:inline>
                                                                            <xsl:text>DATE</xsl:text>
                                                                        </fo:inline>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <fo:inline>
                                                                            <xsl:text>WORK ORDER NO.</xsl:text>
                                                                        </fo:inline>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <fo:inline>
                                                                            <xsl:text>ORIGINAL QUOTE NO.</xsl:text>
                                                                        </fo:inline>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                            </fo:table-row>
                                                            <fo:table-row font-size="8.5px" font-weight="normal" text-align="center">
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <xsl:for-each select="$XML1">
                                                                            <xsl:for-each select="root">
                                                                                <xsl:for-each select="QuoteHeader">
                                                                                    <xsl:for-each select="Table">
                                                                                        <xsl:for-each select="QuoteNo">
                                                                                            <fo:inline>
                                                                                                <xsl:apply-templates>
                                                                                                    <xsl:with-param name="maxwidth" select="$columnwidth4_0 - 0.01042 - 0.01042" />
                                                                                                </xsl:apply-templates>
                                                                                            </fo:inline>
                                                                                        </xsl:for-each>
                                                                                    </xsl:for-each>
                                                                                </xsl:for-each>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <xsl:for-each select="$XML1">
                                                                            <xsl:for-each select="root">
                                                                                <xsl:for-each select="QuoteHeader">
                                                                                    <xsl:for-each select="Table">
                                                                                        <xsl:for-each select="PurchaseOrderNo">
                                                                                            <fo:inline>
                                                                                                <xsl:apply-templates>
                                                                                                    <xsl:with-param name="maxwidth" select="$columnwidth4_1 - 0.01042 - 0.01042" />
                                                                                                </xsl:apply-templates>
                                                                                            </fo:inline>
                                                                                        </xsl:for-each>
                                                                                    </xsl:for-each>
                                                                                </xsl:for-each>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <xsl:for-each select="$XML1">
                                                                            <xsl:for-each select="root">
                                                                                <xsl:for-each select="QuoteHeader">
                                                                                    <xsl:for-each select="Table">
                                                                                        <xsl:for-each select="QuoteDate">
                                                                                            <fo:inline>
                                                                                                <xsl:apply-templates>
                                                                                                    <xsl:with-param name="maxwidth" select="$columnwidth4_2 - 0.01042 - 0.01042" />
                                                                                                </xsl:apply-templates>
                                                                                            </fo:inline>
                                                                                        </xsl:for-each>
                                                                                    </xsl:for-each>
                                                                                </xsl:for-each>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" background-color="white" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <xsl:for-each select="$XML1">
                                                                            <xsl:for-each select="root">
                                                                                <xsl:for-each select="QuoteHeader">
                                                                                    <xsl:for-each select="Table">
                                                                                        <xsl:for-each select="WorkOrderNo">
                                                                                            <fo:inline>
                                                                                                <xsl:apply-templates>
                                                                                                    <xsl:with-param name="maxwidth" select="$columnwidth4_3 - 0.01042 - 0.01042" />
                                                                                                </xsl:apply-templates>
                                                                                            </fo:inline>
                                                                                        </xsl:for-each>
                                                                                    </xsl:for-each>
                                                                                </xsl:for-each>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" background-color="white" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <xsl:for-each select="$XML1">
                                                                            <xsl:for-each select="root">
                                                                                <xsl:for-each select="QuoteHeader">
                                                                                    <xsl:for-each select="Table">
                                                                                        <xsl:for-each select="OriginalQuoteNo">
                                                                                            <fo:inline>
                                                                                                <xsl:apply-templates>
                                                                                                    <xsl:with-param name="maxwidth" select="$columnwidth4_4 - 0.01042 - 0.01042" />
                                                                                                </xsl:apply-templates>
                                                                                            </fo:inline>
                                                                                        </xsl:for-each>
                                                                                    </xsl:for-each>
                                                                                </xsl:for-each>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                            </fo:table-row>
                                                            <fo:table-row font-size="8.5px" font-weight="bold" background-color="silver" text-align="center">
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <fo:inline>
                                                                            <xsl:text>MAKE</xsl:text>
                                                                        </fo:inline>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <fo:inline>
                                                                            <xsl:text>MODEL</xsl:text>
                                                                        </fo:inline>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <fo:inline>
                                                                            <xsl:text>SERIAL NO.</xsl:text>
                                                                        </fo:inline>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <fo:inline>
                                                                            <xsl:text>UNIT NO.</xsl:text>
                                                                        </fo:inline>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <fo:inline>
                                                                            <xsl:text>HOURS</xsl:text>
                                                                        </fo:inline>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                            </fo:table-row>
                                                            <fo:table-row font-size="8.5px" font-weight="normal" text-align="center">
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <xsl:for-each select="$XML1">
                                                                            <xsl:for-each select="root">
                                                                                <xsl:for-each select="QuoteHeader">
                                                                                    <xsl:for-each select="Table">
                                                                                        <xsl:for-each select="Make">
                                                                                            <fo:inline>
                                                                                                <xsl:apply-templates>
                                                                                                    <xsl:with-param name="maxwidth" select="$columnwidth4_0 - 0.01042 - 0.01042" />
                                                                                                </xsl:apply-templates>
                                                                                            </fo:inline>
                                                                                        </xsl:for-each>
                                                                                    </xsl:for-each>
                                                                                </xsl:for-each>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <xsl:for-each select="$XML1">
                                                                            <xsl:for-each select="root">
                                                                                <xsl:for-each select="QuoteHeader">
                                                                                    <xsl:for-each select="Table">
                                                                                        <xsl:for-each select="Model">
                                                                                            <fo:inline>
                                                                                                <xsl:apply-templates>
                                                                                                    <xsl:with-param name="maxwidth" select="$columnwidth4_1 - 0.01042 - 0.01042" />
                                                                                                </xsl:apply-templates>
                                                                                            </fo:inline>
                                                                                        </xsl:for-each>
                                                                                    </xsl:for-each>
                                                                                </xsl:for-each>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <xsl:for-each select="$XML1">
                                                                            <xsl:for-each select="root">
                                                                                <xsl:for-each select="QuoteHeader">
                                                                                    <xsl:for-each select="Table">
                                                                                        <xsl:for-each select="SerialNo">
                                                                                            <fo:inline>
                                                                                                <xsl:apply-templates>
                                                                                                    <xsl:with-param name="maxwidth" select="$columnwidth4_2 - 0.01042 - 0.01042" />
                                                                                                </xsl:apply-templates>
                                                                                            </fo:inline>
                                                                                        </xsl:for-each>
                                                                                    </xsl:for-each>
                                                                                </xsl:for-each>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <xsl:for-each select="$XML1">
                                                                            <xsl:for-each select="root">
                                                                                <xsl:for-each select="QuoteHeader">
                                                                                    <xsl:for-each select="Table">
                                                                                        <xsl:for-each select="UnitNo">
                                                                                            <fo:inline>
                                                                                                <xsl:apply-templates>
                                                                                                    <xsl:with-param name="maxwidth" select="$columnwidth4_3 - 0.01042 - 0.01042" />
                                                                                                </xsl:apply-templates>
                                                                                            </fo:inline>
                                                                                        </xsl:for-each>
                                                                                    </xsl:for-each>
                                                                                </xsl:for-each>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell bottom="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                        <xsl:for-each select="$XML1">
                                                                            <xsl:for-each select="root">
                                                                                <xsl:for-each select="QuoteHeader">
                                                                                    <xsl:for-each select="Table">
                                                                                        <xsl:for-each select="Hours">
                                                                                            <fo:inline>
                                                                                                <xsl:apply-templates>
                                                                                                    <xsl:with-param name="maxwidth" select="$columnwidth4_4 - 0.01042 - 0.01042" />
                                                                                                </xsl:apply-templates>
                                                                                            </fo:inline>
                                                                                        </xsl:for-each>
                                                                                    </xsl:for-each>
                                                                                </xsl:for-each>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                            </fo:table-row>
                                                        </fo:table-body>
                                                    </fo:table>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell>
                                                <fo:block />
                                            </fo:table-cell>
                                        </fo:table-row>
                                    </fo:table-body>
                                </fo:table>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="tablewidth5" select="$maxwidth * 0.98000" />
                                <xsl:variable name="sumcolumnwidths5" select="1.04167 + 1.04167 + 1.14583 + 1.14583" />
                                <xsl:variable name="factor5">
                                    <xsl:choose>
                                        <xsl:when test="$sumcolumnwidths5 &gt; 0.00000 and $sumcolumnwidths5 &gt; $tablewidth5">
                                            <xsl:value-of select="$tablewidth5 div $sumcolumnwidths5" />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="1.000" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="defaultcolumns5" select="1" />
                                <xsl:variable name="defaultcolumnwidth5">
                                    <xsl:choose>
                                        <xsl:when test="$factor5 &lt; 1.000">
                                            <xsl:value-of select="0.000" />
                                        </xsl:when>
                                        <xsl:when test="$defaultcolumns5 &gt; 0">
                                            <xsl:value-of select="($tablewidth5 - $sumcolumnwidths5) div $defaultcolumns5" />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="0.000" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="columnwidth5_0" select="0.65417 * $factor5" /> <!-- <CODE_TAG_100803> Ticket#7802-->
								                <xsl:variable name="columnwidth5_1" select="1.54167 * $factor5" />	<!-- <CODE_TAG_100627>-->
								                <xsl:variable name="columnwidth5_2" select="1.14583 * $factor5" />
                                <xsl:variable name="columnwidth5_3" select="0.78332 * $factor5" /><!-- <CODE_TAG_100803> Ticket#7802-->
                                <xsl:variable name="columnwidth5_4" select="1.33333 * $factor5" /> <!-- <CODE_TAG_100627> --><!-- <CODE_TAG_100803> Ticket#7802-->
									                <fo:table width="{$tablewidth5}in" space-before.optimum="1pt" space-after.optimum="2pt" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
                                    <fo:table-column column-width="{$columnwidth5_0}in" />
                                    <fo:table-column column-width="{$columnwidth5_1}in" />
                                    <fo:table-column column-width="{$columnwidth5_2}in" />
                                    <fo:table-column column-width="{$columnwidth5_3}in" />
                                    <fo:table-column column-width="{$columnwidth5_4}in" />
                                    <fo:table-body>
                                        <fo:table-row font-size="7.5px" font-weight="bold" background-color="silver" text-align="center"><!-- <CODE_TAG_100803> Ticket#7802-->
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <fo:inline>
                                                        <xsl:text>CUSTOMER NO.</xsl:text>
                                                    </fo:inline>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <fo:inline>
                                                        <xsl:text>CONTACT</xsl:text>
                                                    </fo:inline>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <fo:inline>
                                                        <xsl:text>PHONE NO.</xsl:text>
                                                    </fo:inline>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:for-each select="$XML1">
														<xsl:for-each select="root">
															<xsl:for-each select="QuoteHeader">
																<xsl:for-each select="Table">
																<xsl:for-each select="FaxLabel">
																		<xsl:value-of select="translate(. , $lcletters , $ucletters)"/>
																</xsl:for-each>
															</xsl:for-each>
														</xsl:for-each>
													</xsl:for-each>
													</xsl:for-each>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <fo:inline>
                                                        <xsl:text>EMAIL</xsl:text>
                                                    </fo:inline>
                                                </fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                        <fo:table-row font-size="7.5px" font-weight="normal" text-align="center"><!-- <CODE_TAG_100803> Ticket#7802-->
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="CustomerNo">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth5_0 - 0.01042 - 0.01042" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="ContactName">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth5_1 - 0.01042" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="PhoneNo">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth5_2 - 0.01042" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="FaxNo">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth5_3 - 0.01042" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="Email">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth5_4 - 0.01042" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                </fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                        <fo:table-row font-size="7.5px" font-weight="bold" background-color="silver" text-align="center"> <!-- <CODE_TAG_100803> Ticket#7802-->
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <!-- Rajesh feb 25, 2009 -->
                                                    <xsl:for-each select="$XML1">
														<xsl:for-each select="root">
															<xsl:for-each select="QuoteHeader">
																<xsl:for-each select="headerText">
																		<xsl:value-of select="translate(. , $lcletters , $ucletters)"/>
																</xsl:for-each>
															</xsl:for-each>
														</xsl:for-each>
													</xsl:for-each>
                                                    <fo:inline>
                                                        <xsl:text> NO.</xsl:text>
                                                    </fo:inline>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <fo:inline>
                                                        <xsl:text>P.O. NO.</xsl:text>
                                                    </fo:inline>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <fo:inline>
                                                        <xsl:text>DATE</xsl:text>
                                                    </fo:inline>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" number-columns-spanned="2" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <fo:inline>
                                                        <xsl:text>WORK ORDER NO.</xsl:text>
                                                    </fo:inline>
                                                </fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                        <fo:table-row font-size="7.5px" font-weight="normal" text-align="center"> <!-- <CODE_TAG_100803> Ticket#7802-->
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="QuoteNo">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth5_0 - 0.01042 - 0.01042" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="PurchaseOrderNo">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth5_1 - 0.01042" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="QuoteDate">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth5_2 - 0.01042" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" number-columns-spanned="2" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="WorkOrderNo">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth5_3 + $columnwidth5_4 - 0.01042" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                </fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                        <fo:table-row font-size="7.5px" font-weight="bold" background-color="silver" text-align="center"> <!-- <CODE_TAG_100803> Ticket#7802-->
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <fo:inline>
                                                        <xsl:text>MAKE</xsl:text>
                                                    </fo:inline>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <fo:inline>
                                                        <xsl:text>MODEL</xsl:text>
                                                    </fo:inline>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <fo:inline>
                                                        <xsl:text>SERIAL NO.</xsl:text>
                                                    </fo:inline>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <fo:inline>
                                                        <xsl:text>UNIT NO.</xsl:text>
                                                    </fo:inline>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <fo:inline>
                                                        <xsl:text>HOURS</xsl:text>
                                                    </fo:inline>
                                                </fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                        <fo:table-row font-size="8.5px" font-weight="normal" text-align="center">
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="Make">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth5_0 - 0.01042 - 0.01042" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="Model">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth5_1 - 0.01042" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="SerialNo">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth5_2 - 0.01042" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="UnitNo">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth5_3 - 0.01042" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                </fo:block>
                                            </fo:table-cell>
                                            <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="Hours">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth5_4 - 0.01042" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                </fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                    </fo:table-body>
                                </fo:table>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="$XML1/root/QuoteHeader/Table/Type =&quot;A&quot;">
                                <xsl:variable name="tablewidth6" select="$maxwidth * 0.98000" />
                                <xsl:variable name="sumcolumnwidths6" select="0.000" />
                                <xsl:variable name="defaultcolumns6" select="1 + 1 + 1 + 1 + 1" />
                                <xsl:variable name="defaultcolumnwidth6">
                                    <xsl:choose>
                                        <xsl:when test="$defaultcolumns6 &gt; 0">
                                            <xsl:value-of select="($tablewidth6 - $sumcolumnwidths6) div $defaultcolumns6" />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="0.000" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="columnwidth6_0" select="$defaultcolumnwidth6" />
                                <xsl:variable name="columnwidth6_1" select="$defaultcolumnwidth6" />
                                <xsl:variable name="columnwidth6_2" select="$defaultcolumnwidth6" />
                                <xsl:variable name="columnwidth6_3" select="$defaultcolumnwidth6" />
                                <xsl:variable name="columnwidth6_4" select="$defaultcolumnwidth6" />
                                <fo:table width="{$tablewidth6}in" space-before.optimum="1pt" space-after.optimum="2pt" border-collapse="separate" bottom="0.00000in" font-size="10px" top="0.00000in" color="black" display-align="center">
                                    <fo:table-column column-width="{$columnwidth6_0}in" />
                                    <fo:table-column column-width="{$columnwidth6_1}in" />
                                    <fo:table-column column-width="{$columnwidth6_2}in" />
                                    <fo:table-column column-width="{$columnwidth6_3}in" />
                                    <fo:table-column column-width="{$columnwidth6_4}in" />
                                    <fo:table-body>
                                        <fo:table-row>
                                            <fo:table-cell bottom="0.00000in" number-columns-spanned="5">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <fo:inline>
                                                        <xsl:text>While working on your equipment we came across some additional repairs that we had not quoted on. We wanted to make sure that you were notified and give you the opportunity to decide if you would like us to repair these additional items. Please review the quote following and FAX US BACK ASAP. We need your response whether you would like us to proceed or not. We are due to complete your repair soon and need to schedule the technician.</xsl:text>
                                                    </fo:inline>
                                                </fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                    </fo:table-body>
                                </fo:table>
                                <xsl:choose>
                                    <xsl:when test="$XML1/root/QuoteHeader/Table/NewCompletionDate !=&quot;&quot;">
                                        <xsl:variable name="tablewidth7" select="$maxwidth * 0.98000" />
                                        <xsl:variable name="sumcolumnwidths7" select="0.000" />
                                        <xsl:variable name="defaultcolumns7" select="1" />
                                        <xsl:variable name="defaultcolumnwidth7">
                                            <xsl:choose>
                                                <xsl:when test="$defaultcolumns7 &gt; 0">
                                                    <xsl:value-of select="($tablewidth7 - $sumcolumnwidths7) div $defaultcolumns7" />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="0.000" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <xsl:variable name="columnwidth7_0" select="$defaultcolumnwidth7" />
                                        <fo:table width="{$tablewidth7}in" space-before.optimum="1pt" space-after.optimum="2pt" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
                                            <fo:table-column column-width="{$columnwidth7_0}in" />
                                            <fo:table-body>
                                                <fo:table-row>
                                                    <fo:table-cell bottom="0.00000in" font-size="10px">
                                                        <fo:block padding-top="1pt" padding-bottom="1pt">
                                                            <fo:inline>
                                                                <xsl:text>New estimated completion date:&#160; </xsl:text>
                                                            </fo:inline>
                                                            <xsl:for-each select="$XML1">
                                                                <xsl:for-each select="root">
                                                                    <xsl:for-each select="QuoteHeader">
                                                                        <xsl:for-each select="Table">
                                                                            <xsl:for-each select="NewCompletionDate">
                                                                                <fo:inline text-decoration="underline">
                                                                                    <xsl:apply-templates>
                                                                                        <xsl:with-param name="maxwidth" select="$columnwidth7_0" />
                                                                                    </xsl:apply-templates>
                                                                                </fo:inline>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </fo:block>
                                                    </fo:table-cell>
                                                </fo:table-row>
                                            </fo:table-body>
                                        </fo:table>
                                    </xsl:when>
                                    <xsl:otherwise />
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise />
                        </xsl:choose>
                        <xsl:variable name="tablewidth8" select="$maxwidth * 0.98000" />
                        <xsl:variable name="sumcolumnwidths8" select="0.000" />
                        <xsl:variable name="defaultcolumns8" select="1 + 1 + 1 + 1" />
                        <xsl:variable name="defaultcolumnwidth8">
                            <xsl:choose>
                                <xsl:when test="$defaultcolumns8 &gt; 0">
                                    <xsl:value-of select="($tablewidth8 - $sumcolumnwidths8) div $defaultcolumns8" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="0.000" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="columnwidth8_0" select="$defaultcolumnwidth8" />
                        <xsl:variable name="columnwidth8_1" select="$defaultcolumnwidth8" />
                        <xsl:variable name="columnwidth8_2" select="$defaultcolumnwidth8" />
                        <xsl:variable name="columnwidth8_3" select="$defaultcolumnwidth8" />
                        <fo:table width="{$tablewidth8}in" space-before.optimum="1pt" space-after.optimum="2pt" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
                            <fo:table-column column-width="{$columnwidth8_0}in" />
                            <fo:table-column column-width="{$columnwidth8_1}in" />
                            <fo:table-column column-width="{$columnwidth8_2}in" />
                            <fo:table-column column-width="{$columnwidth8_3}in" />
                            <fo:table-body>
                                <xsl:for-each select="$XML1">
                                    <xsl:for-each select="root">
                                        <xsl:for-each select="QuoteDetail">
                                            <xsl:for-each select="Segment">
                                                <fo:table-row>
                                                    <fo:table-cell bottom="0.00000in" display-align="center" height="0.01042in" number-columns-spanned="4" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.02083in">
                                                        <fo:block padding-top="1pt" padding-bottom="1pt" />
                                                    </fo:table-cell>
                                                </fo:table-row>
                                                <fo:table-row display-align="before">
<!-- [<IAranda. 20080807>. DescColPrint.] START -->
                                                    <fo:table-cell bottom="0.00000in" font-size="8.5px" font-weight="bold" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                        <fo:block padding-top="1pt" padding-bottom="1pt">
                                                            <fo:inline>
                                                                <xsl:text>SEGMENT:&#160; </xsl:text>
                                                            </fo:inline>
                                                            <xsl:for-each select="SegmentNo">
                                                                <fo:inline>
                                                                    <xsl:apply-templates>
                                                                        <xsl:with-param name="maxwidth" select="$columnwidth8_0 + $columnwidth8_1 + $columnwidth8_2" />
                                                                    </xsl:apply-templates>
                                                                </fo:inline>
                                                            </xsl:for-each>

                                                          <fo:inline>
                                                                <xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; </xsl:text>
                                                            </fo:inline>
                                                            <fo:inline>
                                                                <xsl:text>&#160;</xsl:text>
                                                            </fo:inline>
                                                        </fo:block>
                                                    </fo:table-cell>
													<fo:table-cell bottom="0.00000in" font-size="8.5px" font-weight="bold" number-columns-spanned="3" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
														<fo:block padding-top="1pt" padding-bottom="1pt">
															<xsl:choose>
                                                                <xsl:when test="Description !=&quot;&quot;">
                                                                    <xsl:for-each select="Description">
																		<xsl:for-each select="para">
																			<fo:block space-after.optimum="0pt" line-height="8pt">
																				<xsl:attribute name="space-before.optimum">
																					<xsl:if test="position()=1">1pt</xsl:if>
																					<xsl:if test="position()&gt;1">4pt</xsl:if>
																				</xsl:attribute>
																				<fo:inline line-height="8pt">
																					<xsl:apply-templates />
																				</fo:inline>
																			</fo:block>
																		</xsl:for-each>
                                                                    </xsl:for-each>
                                                                </xsl:when>
                                                                <xsl:otherwise />
                                                            </xsl:choose>
														</fo:block>
                            
                            
                            
                            
                                                    </fo:table-cell>
<!-- [<IAranda. 20080807>. DescColPrint.] END -->
<!-- Duplicate Refer to Ticket # 2750 Rajesh Shaw Feb 10th 2009            
												<fo:table-cell bottom="0.00000in" font-size="8.5px" font-weight="normal" text-align="right" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                        <fo:block padding-top="1pt" padding-bottom="1pt">
                                                            
															<xsl:choose>
                                                                <xsl:when test="DBSRepairOptionId !=0 or  ../../Parameter/iDetail =0">
                                                                    <xsl:for-each select="SegmentTotal">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth8_3" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:when>
                                                                <xsl:otherwise />
                                                            </xsl:choose>
                                                        </fo:block>
                                                    </fo:table-cell>-->
                                                </fo:table-row>
                                                <fo:table-row>
                                                    <fo:table-cell bottom="0.00000in" number-columns-spanned="4">
                                                        <fo:block padding-top="1pt" padding-bottom="1pt">
                                                            <xsl:choose>
                                                                <!--xsl:when test="../../Parameter/iDetail =1 and ( DBSRepairOptionId =0 or ( DBSRepairOptionId !=0 and   ../../Parameter/iInternal =1))" --> <!-- '[<IAranda 20080915> PrintConfig.] -->
                                                                <xsl:when test="../../Parameter/iDetail =1">
                                                                    <xsl:choose>
                                                                        <!-- xsl:when test="../../Parameter/iInternal =1 and  ../../Parameter/iRepair =1" -->	<!-- '[<IAranda 20080915> PrintConfig.] -->
                                                                        <xsl:when test="../../Parameter/iRepair =1">
                                                                            <xsl:variable name="tablewidth9" select="$columnwidth8_0 * 1.00000 + $columnwidth8_1 * 1.00000 + $columnwidth8_2 * 1.00000 + $columnwidth8_3 * 1.00000" />
                                                                            <xsl:variable name="sumcolumnwidths9" select="0.26042 + 0.26042 + 0.26042 + 0.46875 + 0.26042 + 2.08333 + 0.83333 + 0.83333" />
                                                                            <xsl:variable name="factor9">
                                                                                <xsl:choose>
                                                                                    <xsl:when test="$sumcolumnwidths9 &gt; 0.00000 and $sumcolumnwidths9 &gt; $tablewidth9">
                                                                                        <xsl:value-of select="$tablewidth9 div $sumcolumnwidths9" />
                                                                                    </xsl:when>
                                                                                    <xsl:otherwise>
                                                                                        <xsl:value-of select="1.000" />
                                                                                    </xsl:otherwise>
                                                                                </xsl:choose>
                                                                            </xsl:variable>
                                                                            <xsl:variable name="defaultcolumns9" select="1 + 1" />
                                                                            <xsl:variable name="defaultcolumnwidth9">
                                                                                <xsl:choose>
                                                                                    <xsl:when test="$factor9 &lt; 1.000">
                                                                                        <xsl:value-of select="0.000" />
                                                                                    </xsl:when>
                                                                                    <xsl:when test="$defaultcolumns9 &gt; 0">
                                                                                        <xsl:value-of select="($tablewidth9 - $sumcolumnwidths9) div $defaultcolumns9" />
                                                                                    </xsl:when>
                                                                                    <xsl:otherwise>
                                                                                        <xsl:value-of select="0.000" />
                                                                                    </xsl:otherwise>
                                                                                </xsl:choose>
                                                                            </xsl:variable>
                                                                            <xsl:variable name="columnwidth9_0" select="0.26042 * $factor9" />
                                                                            <xsl:variable name="columnwidth9_1" select="0.26042 * $factor9" />
                                                                            <xsl:variable name="columnwidth9_2" select="0.26042 * $factor9" />
                                                                            <xsl:variable name="columnwidth9_3" select="0.46875 * $factor9" />
                                                                            <xsl:variable name="columnwidth9_4" select="0.26042 * $factor9" />
                                                                            <xsl:variable name="columnwidth9_5" select="$defaultcolumnwidth9" />
                                                                            <xsl:variable name="columnwidth9_6" select="$defaultcolumnwidth9" />
                                                                            <xsl:variable name="columnwidth9_7" select="2.08333 * $factor9" />
                                                                            <xsl:variable name="columnwidth9_8" select="0.83333 * $factor9" />
                                                                            <xsl:variable name="columnwidth9_9" select="0.83333 * $factor9" />
                                                                            <xsl:variable name="columnwidth9_10" select="0.83333 * $factor9" />
                                                                            <fo:table width="{$tablewidth9}in" space-before.optimum="1pt" space-after.optimum="2pt" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
                                                                                <fo:table-column column-width="{$columnwidth9_0}in" />
                                                                                <fo:table-column column-width="{$columnwidth9_1}in" />
                                                                                <fo:table-column column-width="{$columnwidth9_2}in" />
                                                                                <fo:table-column column-width="{$columnwidth9_3}in" />
                                                                                <fo:table-column column-width="{$columnwidth9_4}in" />
                                                                                <fo:table-column column-width="{$columnwidth9_5}in" />
                                                                                <fo:table-column column-width="{$columnwidth9_6}in" />
                                                                                <fo:table-column column-width="{$columnwidth9_7}in" />
                                                                                <fo:table-column column-width="{$columnwidth9_8}in" />
                                                                                <fo:table-column column-width="{$columnwidth9_9}in" />
                                                                                <xsl:if test="//QuoteDetail/@ShowUnitPriceSeperately = '2'">
																					<fo:table-column column-width="{$columnwidth9_10}in" />
																				</xsl:if>
                                                                                <fo:table-body>
                                                                                    <fo:table-row font-size="8.5px" font-weight="bold" display-align="after">
                                                                                        <fo:table-cell bottom="0.00000in" text-align="center">
                                                                                            <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                <fo:inline text-decoration="underline">
                                                                                                    <xsl:text>Job Code</xsl:text>
                                                                                                </fo:inline>
                                                                                            </fo:block>
                                                                                        </fo:table-cell>
                                                                                        <fo:table-cell bottom="0.00000in" text-align="center">
                                                                                            <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                <fo:inline text-decoration="underline">
                                                                                                    <xsl:text>Comp Code</xsl:text>
                                                                                                </fo:inline>
                                                                                            </fo:block>
                                                                                        </fo:table-cell>
                                                                                        <fo:table-cell bottom="0.00000in" text-align="center">
                                                                                            <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                <fo:inline text-decoration="underline">
                                                                                                    <xsl:text>Mod Code</xsl:text>
                                                                                                </fo:inline>
                                                                                            </fo:block>
                                                                                        </fo:table-cell>
                                                                                        <fo:table-cell bottom="0.00000in" text-align="center">
                                                                                            <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                <fo:inline text-decoration="underline">
                                                                                                    <xsl:text>Job Loc Code</xsl:text>
                                                                                                </fo:inline>
                                                                                            </fo:block>
                                                                                        </fo:table-cell>
                                                                                        <fo:table-cell bottom="0.00000in" text-align="center">
                                                                                            <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                <fo:inline text-decoration="underline">
                                                                                                    <xsl:text>Qty Code</xsl:text>
                                                                                                </fo:inline>
                                                                                            </fo:block>
                                                                                        </fo:table-cell>
                                                                                        <fo:table-cell bottom="0.00000in" text-align="center">
                                                                                            <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                <fo:inline text-decoration="underline">
                                                                                                    <xsl:text>Qty</xsl:text>
                                                                                                </fo:inline>
                                                                                            </fo:block>
                                                                                        </fo:table-cell>
                                                                                        <fo:table-cell bottom="0.00000in">
                                                                                            <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                <fo:inline text-decoration="underline">
                                                                                                    <xsl:text>Item No</xsl:text>
                                                                                                </fo:inline>
                                                                                            </fo:block>
                                                                                        </fo:table-cell>
                                                                                        <fo:table-cell bottom="0.00000in">
                                                                                            <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                <fo:inline text-decoration="underline">
                                                                                                    <xsl:text>Description</xsl:text>
                                                                                                </fo:inline>
                                                                                            </fo:block>
                                                                                        </fo:table-cell>
                                                                                        <!--<BEGIN-fxiao, 2010-01-11::Separate Discount from Unit Price>-->
                                                                                        <xsl:choose>
                                                                                        	<xsl:when test="//QuoteDetail/@ShowUnitPriceSeperately = '2'">
                                                                                        		<fo:table-cell bottom="0.00000in" text-align="right">
                                                                                        		    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                        		        <fo:inline text-decoration="underline">
                                                                                        		            <xsl:text>Unit Price</xsl:text>
                                                                                        		        </fo:inline>
                                                                                        		    </fo:block>
                                                                                        		</fo:table-cell>
                                                                                        		<fo:table-cell bottom="0.00000in" text-align="right">
                                                                                        		    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                        		        <fo:inline text-decoration="underline">
																											                                                   <xsl:value-of select="//Label/QuoteDetail/Disc" /><xsl:text> Price</xsl:text>
                                                                                        		        </fo:inline>
                                                                                        		    </fo:block>
                                                                                        		</fo:table-cell>
                                                                                        </xsl:when>
																							                                          <xsl:otherwise>
                                                                                          <!--<CODE_TAG_100780> 12/29/2010 yhua-->
                                                                                          <xsl:choose>
                                                                                            <xsl:when test="//QuoteDetail/@ShowUnitPriceColumnOnly = '2'">
                                                                                              <fo:table-cell bottom="0.00000in" text-align="right">
                                                                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                  <fo:inline text-decoration="underline">
                                                                                                    <xsl:text>Unit Price</xsl:text>
                                                                                                  </fo:inline>
                                                                                                </fo:block>
                                                                                              </fo:table-cell>
                                                                                            </xsl:when>
                                                                                            <xsl:otherwise>
                                                                                              <fo:table-cell bottom="0.00000in" text-align="right">
                                                                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                  <fo:inline text-decoration="underline">
                                                                                                    <xsl:text>Unit/</xsl:text><xsl:value-of select="//Label/QuoteDetail/Disc" /><xsl:text> Price</xsl:text>
                                                                                                  </fo:inline>
                                                                                                </fo:block>
                                                                                              </fo:table-cell>
                                                                                            </xsl:otherwise>
                                                                                          </xsl:choose>
                                                                                          <!--</CODE_TAG_100780>-->
                                                                                        </xsl:otherwise>
                                                                                       </xsl:choose>
                                                                                        <!--</END-fxiao, 2010-01-11>-->
                                                                                        <fo:table-cell bottom="0.00000in" text-align="right">
                                                                                            <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                <fo:inline text-decoration="underline">
                                                                                                    <xsl:text>Ext Price</xsl:text>
                                                                                                </fo:inline>
                                                                                            </fo:block>
                                                                                        </fo:table-cell>
                                                                                    </fo:table-row>
                                                                                </fo:table-body>
                                                                            </fo:table>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:variable name="tablewidth10" select="$columnwidth8_0 * 1.00000 + $columnwidth8_1 * 1.00000 + $columnwidth8_2 * 1.00000 + $columnwidth8_3 * 1.00000" />
                                                                            <xsl:variable name="sumcolumnwidths10" select="0.29167 + 0.84375 + 1.88542 + 0.84375 + 0.84375 + 1.05208" />
                                                                            <xsl:variable name="factor10">
                                                                                <xsl:choose>
                                                                                    <xsl:when test="$sumcolumnwidths10 &gt; 0.00000 and $sumcolumnwidths10 &gt; $tablewidth10">
                                                                                        <xsl:value-of select="$tablewidth10 div $sumcolumnwidths10" />
                                                                                    </xsl:when>
                                                                                    <xsl:otherwise>
                                                                                        <xsl:value-of select="1.000" />
                                                                                    </xsl:otherwise>
                                                                                </xsl:choose>
                                                                            </xsl:variable>
                                                                            <xsl:variable name="defaultcolumns10" select="1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1" />
                                                                            <xsl:variable name="defaultcolumnwidth10">
                                                                                <xsl:choose>
                                                                                    <xsl:when test="$factor10 &lt; 1.000">
                                                                                        <xsl:value-of select="0.000" />
                                                                                    </xsl:when>
                                                                                    <xsl:when test="$defaultcolumns10 &gt; 0">
                                                                                        <xsl:value-of select="($tablewidth10 - $sumcolumnwidths10) div $defaultcolumns10" />
                                                                                    </xsl:when>
                                                                                    <xsl:otherwise>
                                                                                        <xsl:value-of select="0.000" />
                                                                                    </xsl:otherwise>
                                                                                </xsl:choose>
                                                                            </xsl:variable>
                                                                            <xsl:variable name="columnwidth10_0" select="$defaultcolumnwidth10" />
                                                                            <xsl:variable name="columnwidth10_1" select="$defaultcolumnwidth10" />
                                                                            <xsl:variable name="columnwidth10_2" select="$defaultcolumnwidth10" />
                                                                            <xsl:variable name="columnwidth10_3" select="$defaultcolumnwidth10" />
                                                                            <xsl:variable name="columnwidth10_4" select="$defaultcolumnwidth10" />
                                                                            <xsl:variable name="columnwidth10_5" select="$defaultcolumnwidth10" />
                                                                            <xsl:variable name="columnwidth10_6" select="$defaultcolumnwidth10" />
                                                                            <xsl:variable name="columnwidth10_7" select="$defaultcolumnwidth10" />
                                                                            <xsl:variable name="columnwidth10_8" select="$defaultcolumnwidth10" />
                                                                            <xsl:variable name="columnwidth10_9" select="$defaultcolumnwidth10" />
                                                                            <xsl:variable name="columnwidth10_10" select="$defaultcolumnwidth10" />
                                                                            <xsl:variable name="columnwidth10_11" select="$defaultcolumnwidth10" />
                                                                            <xsl:variable name="columnwidth10_12" select="$defaultcolumnwidth10" />
                                                                            <xsl:variable name="columnwidth10_13" select="0.01167 * $factor10" />	<!-- <CODE_TAG_100626> -->
                                                                            <xsl:variable name="columnwidth10_14" select="0.05167 * $factor10" /> 	<!-- <CODE_TAG_100626> -->
																			<xsl:variable name="columnwidth10_15" select="0.05167 * $factor10" />	<!-- <CODE_TAG_100626> -->
																			<xsl:variable name="columnwidth10_16" select="0.05167 * $factor10" />	<!-- <CODE_TAG_100626> -->
																			<xsl:variable name="columnwidth10_17" select="0.05167 * $factor10" />	<!-- <CODE_TAG_100626> -->
																			<xsl:variable name="columnwidth10_18" select="0.05167 * $factor10" />	<!-- <CODE_TAG_100626> -->
																			<xsl:variable name="columnwidth10_19" select="0.05167 * $factor10" />	<!-- <CODE_TAG_100626> -->
																			<xsl:variable name="columnwidth10_20" select="1.34375 * $factor10" />  <!-- <CODE_TAG_100626> -->
                                                                            <xsl:variable name="columnwidth10_21" select="1.88542 * $factor10" />
																			<xsl:variable name="columnwidth10_22">
																				<!-- DESCRIPTION -->
																				<!--<BEGIN-fxiao, 2010-01-11::Separate Discount from Unit Price - adjust description column width to format layout properly>-->
                                                                            	<xsl:choose>
																					<xsl:when test="//QuoteDetail/@ShowUnitPriceSeperately = '2'"><xsl:value-of select="0.74375  * $factor10" /></xsl:when>	<!-- <CODE_TAG_100626> -->
																					<xsl:otherwise><xsl:value-of select="2.12 * 0.84375 * $factor10"/></xsl:otherwise>		<!-- <CODE_TAG_100626> -->
																				</xsl:choose>
																				<!--</END-fxiao, 2010-01-11>-->
																			</xsl:variable>
                                                                            <xsl:variable name="columnwidth10_23" select="0.84375 * $factor10" />
                                                                            <xsl:variable name="columnwidth10_24" select="1.05208 * $factor10" />
                                                                            <fo:table width="{$tablewidth10}in" space-before.optimum="1pt" space-after.optimum="2pt" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
                                                                                <fo:table-column column-width="{$columnwidth10_0}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_1}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_2}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_3}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_4}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_5}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_6}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_7}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_8}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_9}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_10}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_11}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_12}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_13}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_14}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_15}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_16}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_17}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_18}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_19}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_20}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_21}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_22}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_23}in" />
                                                                                <fo:table-column column-width="{$columnwidth10_24}in" />
                                                                                <fo:table-body>
                                                                                    <fo:table-row font-size="8.5px" font-weight="bold">
                                                                                        <fo:table-cell bottom="0.00000in" number-columns-spanned="14" text-align="center" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                                            <fo:block padding-top="1pt" padding-bottom="1pt" />
                                                                                        </fo:table-cell>
                                                                                        <fo:table-cell bottom="0.00000in" number-columns-spanned="6" text-align="center" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.10000in">
                                                                                            <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                <fo:inline text-decoration="underline">
                                                                                                    <xsl:text>Qty</xsl:text>
                                                                                                </fo:inline>
                                                                                            </fo:block>
                                                                                        </fo:table-cell>
                                                                                        <fo:table-cell bottom="0.00000in" text-align="left" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.000in" padding-right="0.00000in">
                                                                                            <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                <fo:inline text-decoration="underline">
                                                                                                    <xsl:text>Item No</xsl:text>
                                                                                                </fo:inline>
                                                                                            </fo:block>
                                                                                        </fo:table-cell>
                                                                                        <fo:table-cell bottom="0.00000in" height="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                                            <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                <fo:inline text-decoration="underline">
                                                                                                    <xsl:text>Description</xsl:text>
                                                                                                </fo:inline>
                                                                                            </fo:block>
                                                                                        </fo:table-cell>
                                                                                        <!--<BEGIN-fxiao, 2010-01-11::Separate Discount from Unit Price>-->
                                                                                        <xsl:choose>
                                                                                        	<xsl:when test="//QuoteDetail/@ShowUnitPriceSeperately = '2'">
                                                                                        		<fo:table-cell bottom="0.00000in" text-align="right" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                                        		    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                        		        <fo:inline text-decoration="underline">
                                                                                        		            <xsl:text>Unit Price</xsl:text>
                                                                                        		        </fo:inline>
                                                                                        		    </fo:block>
                                                                                        		</fo:table-cell>
                                                                                             
                                                                                              <fo:table-cell bottom="0.00000in" text-align="right" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                  <fo:inline text-decoration="underline">
                                                                                                      <xsl:if test="DiscountColumnShow = 2">
                                                                                                    <xsl:value-of select="//Label/QuoteDetail/Disc" />
                                                                                                    <xsl:text> Price </xsl:text>
                                                                                                    </xsl:if >
                                                                                                  </fo:inline>
                                                                                                </fo:block>
                                                                                              </fo:table-cell>
                                                                                            
                                                                                        	</xsl:when>
                                                                                        	<xsl:otherwise>
                                                                                            <!--<CODE_TAG_100780> 12/29/2010 yhua-->
                                                                                            <xsl:choose>
                                                                                              <xsl:when test="//QuoteDetail/@ShowUnitPriceColumnOnly = '2'">
                                                                                                <fo:table-cell bottom="0.00000in" text-align="right">
                                                                                                  <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                    <fo:inline text-decoration="underline">
                                                                                                      <xsl:text>Unit Price</xsl:text>
                                                                                                    </fo:inline>
                                                                                                  </fo:block>
                                                                                                </fo:table-cell>
                                                                                              </xsl:when>
                                                                                              <xsl:otherwise>
                                                                                                <fo:table-cell bottom="0.00000in" text-align="right">
                                                                                                  <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                    <fo:inline text-decoration="underline">
                                                                                                      <xsl:text>Unit/</xsl:text><xsl:value-of select="//Label/QuoteDetail/Disc" /><xsl:text> Price</xsl:text>
                                                                                                    </fo:inline>
                                                                                                  </fo:block>
                                                                                                </fo:table-cell>
                                                                                              </xsl:otherwise>
                                                                                            </xsl:choose>
                                                                                            <!--</CODE_TAG_100780>-->                                                                                        	
                                                                                        	</xsl:otherwise>
                                                                                        </xsl:choose>
                                                                                        <!--</END-fxiao, 2010-01-11>-->
                                                                                        <fo:table-cell bottom="0.00000in" text-align="right" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                                            <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                <fo:inline text-decoration="underline">
                                                                                                    <xsl:text>Ext Price</xsl:text>
                                                                                                </fo:inline>
                                                                                            </fo:block>
                                                                                        </fo:table-cell>
                                                                                        <fo:table-cell bottom="0.00000in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                                            <fo:block padding-top="1pt" padding-bottom="1pt" />
                                                                                        </fo:table-cell>
                                                                                    </fo:table-row>
                                                                                </fo:table-body>
                                                                            </fo:table>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:when>
                                                                <xsl:otherwise />
                                                            </xsl:choose>
                                                            <xsl:choose>
                                                                <!-- xsl:when test="(DBSRepairOptionId =0 or  ../../Parameter/iInternal =1) and  ../../Parameter/iDetail =1" --> <!-- '[<IAranda 20080915> PrintConfig.] -->
                                                                <xsl:when test="../../Parameter/iDetail =1" >
                                                                    <xsl:variable name="tablewidth11" select="$columnwidth8_0 * 1.00000 + $columnwidth8_1 * 1.00000 + $columnwidth8_2 * 1.00000 + $columnwidth8_3 * 1.00000" />
                                                                    <xsl:variable name="sumcolumnwidths11" select="1.04167" />
                                                                    <xsl:variable name="factor11">
                                                                        <xsl:choose>
                                                                            <xsl:when test="$sumcolumnwidths11 &gt; 0.00000 and $sumcolumnwidths11 &gt; $tablewidth11">
                                                                                <xsl:value-of select="$tablewidth11 div $sumcolumnwidths11" />
                                                                            </xsl:when>
                                                                            <xsl:otherwise>
                                                                                <xsl:value-of select="1.000" />
                                                                            </xsl:otherwise>
                                                                        </xsl:choose>
                                                                    </xsl:variable>
                                                                    <xsl:variable name="defaultcolumns11" select="1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1" />
                                                                    <xsl:variable name="defaultcolumnwidth11">
                                                                        <xsl:choose>
                                                                            <xsl:when test="$factor11 &lt; 1.000">
                                                                                <xsl:value-of select="0.000" />
                                                                            </xsl:when>
                                                                            <xsl:when test="$defaultcolumns11 &gt; 0">
                                                                                <xsl:value-of select="($tablewidth11 - $sumcolumnwidths11) div $defaultcolumns11" />
                                                                            </xsl:when>
                                                                            <xsl:otherwise>
                                                                                <xsl:value-of select="0.000" />
                                                                            </xsl:otherwise>
                                                                        </xsl:choose>
                                                                    </xsl:variable>
                                                                    <xsl:variable name="columnwidth11_0" select="$defaultcolumnwidth11" />
                                                                    <xsl:variable name="columnwidth11_1" select="$defaultcolumnwidth11" />
                                                                    <xsl:variable name="columnwidth11_2" select="$defaultcolumnwidth11" />
                                                                    <xsl:variable name="columnwidth11_3" select="$defaultcolumnwidth11" />
                                                                    <xsl:variable name="columnwidth11_4" select="$defaultcolumnwidth11" />
                                                                    <xsl:variable name="columnwidth11_5" select="$defaultcolumnwidth11" />
                                                                    <xsl:variable name="columnwidth11_6" select="$defaultcolumnwidth11" />
                                                                    <xsl:variable name="columnwidth11_7" select="$defaultcolumnwidth11" />
                                                                    <xsl:variable name="columnwidth11_8" select="$defaultcolumnwidth11" />
                                                                    <xsl:variable name="columnwidth11_9" select="1.04167 * $factor11" />
                                                                    <fo:table width="{$tablewidth11}in" space-before.optimum="1pt" space-after.optimum="2pt" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
                                                                        <fo:table-column column-width="{$columnwidth11_0}in" />
                                                                        <fo:table-column column-width="{$columnwidth11_1}in" />
                                                                        <fo:table-column column-width="{$columnwidth11_2}in" />
                                                                        <fo:table-column column-width="{$columnwidth11_3}in" />
                                                                        <fo:table-column column-width="{$columnwidth11_4}in" />
                                                                        <fo:table-column column-width="{$columnwidth11_5}in" />
                                                                        <fo:table-column column-width="{$columnwidth11_6}in" />
                                                                        <fo:table-column column-width="{$columnwidth11_7}in" />
                                                                        <fo:table-column column-width="{$columnwidth11_8}in" />
                                                                        <fo:table-column column-width="{$columnwidth11_9}in" />
                                                                        <fo:table-body>
                                                                            <xsl:for-each select="Repair">
                                                                                <fo:table-row>
                                                                                    <fo:table-cell bottom="0.00000in" font-size="8.5px" font-weight="bold" number-columns-spanned="9" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                                        <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                            <xsl:for-each select="CategoryName">
                                                                                                <fo:inline>
                                                                                                    <xsl:apply-templates>
                                                                                                        <xsl:with-param name="maxwidth" select="$columnwidth11_0 + $columnwidth11_1 + $columnwidth11_2 + $columnwidth11_3 + $columnwidth11_4 + $columnwidth11_5 + $columnwidth11_6 + $columnwidth11_7 + $columnwidth11_8" />
                                                                                                    </xsl:apply-templates>
                                                                                                </fo:inline>
                                                                                            </xsl:for-each>
                                                                                        </fo:block>
                                                                                    </fo:table-cell>
                                                                                    <fo:table-cell bottom="0.00000in" font-size="8.5px" font-weight="bold" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                                        <fo:block padding-top="1pt" padding-bottom="1pt" />
                                                                                    </fo:table-cell>
                                                                                </fo:table-row>
                                                                                <fo:table-row>
                                                                                    <fo:table-cell bottom="0.00000in" font-size="8.5px" font-weight="bold" number-columns-spanned="10">
                                                                                        <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                            <xsl:choose>
																								<!-- '[<IAranda 20080915> PrintConfig.] -->
                                                                                                <!--xsl:when test="../../../Parameter/iInternal =1 and  ../../../Parameter/iRepair =1 and  ../../../Parameter/iJob =1" / -->
                                                                                                <xsl:when test="../../../Parameter/iRepair =1 and  ../../../Parameter/iJob =1" />
                                                                                                <xsl:otherwise>
                                                                                                    <xsl:choose>
																										<!-- '[<IAranda 20080915> PrintConfig.] -->
                                                                                                        <!-- xsl:when test="../../../Parameter/iInternal =1 and  ../../../Parameter/iRepair =1 and  ../../../Parameter/iJob =0" / -->
                                                                                                        <xsl:when test="../../../Parameter/iRepair =1 and  ../../../Parameter/iJob =0" />
                                                                                                        <xsl:otherwise>
                                                                                                            <xsl:variable name="tablewidth12" select="$columnwidth11_0 * 1.00000 + $columnwidth11_1 * 1.00000 + $columnwidth11_2 * 1.00000 + $columnwidth11_3 * 1.00000 + $columnwidth11_4 * 1.00000 + $columnwidth11_5 * 1.00000 + $columnwidth11_6 * 1.00000 + $columnwidth11_7 * 1.00000 + $columnwidth11_8 * 1.00000 + $columnwidth11_9 * 1.00000" />
                                                                                                            <xsl:variable name="sumcolumnwidths12" select="0.000" />
                                                                                                            <xsl:variable name="defaultcolumns12" select="1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1" />
                                                                                                            <xsl:variable name="defaultcolumnwidth12">
                                                                                                                <xsl:choose>
                                                                                                                    <xsl:when test="$defaultcolumns12 &gt; 0">
                                                                                                                        <xsl:value-of select="($tablewidth12 - $sumcolumnwidths12) div $defaultcolumns12" />
                                                                                                                    </xsl:when>
                                                                                                                    <xsl:otherwise>
                                                                                                                        <xsl:value-of select="0.000" />
                                                                                                                    </xsl:otherwise>
                                                                                                                </xsl:choose>
                                                                                                            </xsl:variable>
                                                                                                            <xsl:variable name="columnwidth12_0" select="$defaultcolumnwidth12" />
                                                                                                            <xsl:variable name="columnwidth12_1" select="$defaultcolumnwidth12" />
                                                                                                            <xsl:variable name="columnwidth12_2" select="$defaultcolumnwidth12" />
                                                                                                            <xsl:variable name="columnwidth12_3" select="$defaultcolumnwidth12" />
                                                                                                            <xsl:variable name="columnwidth12_4" select="$defaultcolumnwidth12" />
                                                                                                            <xsl:variable name="columnwidth12_5" select="$defaultcolumnwidth12" />
                                                                                                            <xsl:variable name="columnwidth12_6" select="$defaultcolumnwidth12" />
                                                                                                            <xsl:variable name="columnwidth12_7" select="$defaultcolumnwidth12" />
                                                                                                            <xsl:variable name="columnwidth12_8" select="$defaultcolumnwidth12" />
                                                                                                            <xsl:variable name="columnwidth12_9" select="$defaultcolumnwidth12" />
                                                                                                            <xsl:variable name="columnwidth12_10" select="$defaultcolumnwidth12" />
                                                                                                            <xsl:variable name="columnwidth12_11" select="$defaultcolumnwidth12" />
                                                                                                            <xsl:variable name="columnwidth12_12" select="$defaultcolumnwidth12" />
                                                                                                            <xsl:variable name="columnwidth12_13" select="$defaultcolumnwidth12" />
                                                                                                            <xsl:variable name="columnwidth12_14" select="$defaultcolumnwidth12" />
                                                                                                            <xsl:variable name="columnwidth12_15" select="$defaultcolumnwidth12" />
                                                                                                            <xsl:variable name="columnwidth12_16" select="$defaultcolumnwidth12" />
                                                                                                            <xsl:variable name="columnwidth12_17" select="$defaultcolumnwidth12" />
                                                                                                            <xsl:variable name="columnwidth12_18" select="$defaultcolumnwidth12" />
                                                                                                            <xsl:variable name="columnwidth12_19" select="$defaultcolumnwidth12" />
                                                                                                            <xsl:variable name="columnwidth12_20" select="$defaultcolumnwidth12" />
                                                                                                            <fo:table width="{$tablewidth12}in" space-before.optimum="1pt" space-after.optimum="2pt" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
                                                                                                                <fo:table-column column-width="{$columnwidth12_0}in" />
                                                                                                                <fo:table-column column-width="{$columnwidth12_1}in" />
                                                                                                                <fo:table-column column-width="{$columnwidth12_2}in" />
                                                                                                                <fo:table-column column-width="{$columnwidth12_3}in" />
                                                                                                                <fo:table-column column-width="{$columnwidth12_4}in" />
                                                                                                                <fo:table-column column-width="{$columnwidth12_5}in" />
                                                                                                                <fo:table-column column-width="{$columnwidth12_6}in" />
                                                                                                                <fo:table-column column-width="{$columnwidth12_7}in" />
                                                                                                                <fo:table-column column-width="{$columnwidth12_8}in" />
                                                                                                                <fo:table-column column-width="{$columnwidth12_9}in" />
                                                                                                                <fo:table-column column-width="{$columnwidth12_10}in" />
                                                                                                                <fo:table-column column-width="{$columnwidth12_11}in" />
                                                                                                                <fo:table-column column-width="{$columnwidth12_12}in" />
                                                                                                                <fo:table-column column-width="{$columnwidth12_13}in" />
                                                                                                                <fo:table-column column-width="{$columnwidth12_14}in" />
                                                                                                                <fo:table-column column-width="{$columnwidth12_15}in" />
                                                                                                                <fo:table-column column-width="{$columnwidth12_16}in" />
                                                                                                                <fo:table-column column-width="{$columnwidth12_17}in" />
                                                                                                                <fo:table-column column-width="{$columnwidth12_18}in" />
                                                                                                                <fo:table-column column-width="{$columnwidth12_19}in" />
                                                                                                                <fo:table-column column-width="{$columnwidth12_20}in" />
                                                                                                                <fo:table-body>
                                                                                                                    <xsl:for-each select="Detail">
                                                                                                                        <fo:table-row>
                                                                                                                            <fo:table-cell bottom="0.00000in" number-columns-spanned="21" text-align="center">
                                                                                                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                                                    <xsl:variable name="tablewidth13" select="$columnwidth12_0 * 1.00000 + $columnwidth12_1 * 1.00000 + $columnwidth12_2 * 1.00000 + $columnwidth12_3 * 1.00000 + $columnwidth12_4 * 1.00000 + $columnwidth12_5 * 1.00000 + $columnwidth12_6 * 1.00000 + $columnwidth12_7 * 1.00000 + $columnwidth12_8 * 1.00000 + $columnwidth12_9 * 1.00000 + $columnwidth12_10 * 1.00000 + $columnwidth12_11 * 1.00000 + $columnwidth12_12 * 1.00000 + $columnwidth12_13 * 1.00000 + $columnwidth12_14 * 1.00000 + $columnwidth12_15 * 1.00000 + $columnwidth12_16 * 1.00000 + $columnwidth12_17 * 1.00000 + $columnwidth12_18 * 1.00000 + $columnwidth12_19 * 1.00000 + $columnwidth12_20 * 1.00000" />
                                                                                                                                    <xsl:variable name="sumcolumnwidths13" select="0.52083 + 0.83333 + 0.83333 + 1.87500 + 0.83333 + 0.83333 + 1.04167" />
                                                                                                                                    <xsl:variable name="factor13">
                                                                                                                                        <xsl:choose>
                                                                                                                                            <xsl:when test="$sumcolumnwidths13 &gt; 0.00000 and $sumcolumnwidths13 &gt; $tablewidth13">
                                                                                                                                                <xsl:value-of select="$tablewidth13 div $sumcolumnwidths13" />
                                                                                                                                            </xsl:when>
                                                                                                                                            <xsl:otherwise>
                                                                                                                                                <xsl:value-of select="1.000" />
                                                                                                                                            </xsl:otherwise>
                                                                                                                                        </xsl:choose>
                                                                                                                                    </xsl:variable>
                                                                                                                                    <xsl:variable name="defaultcolumns13" select="1 + 1 + 1 + 1" />
                                                                                                                                    <xsl:variable name="defaultcolumnwidth13">
                                                                                                                                        <xsl:choose>
                                                                                                                                            <xsl:when test="$factor13 &lt; 1.000">
                                                                                                                                                <xsl:value-of select="0.000" />
                                                                                                                                            </xsl:when>
                                                                                                                                            <xsl:when test="$defaultcolumns13 &gt; 0">
                                                                                                                                                <xsl:value-of select="($tablewidth13 - $sumcolumnwidths13) div $defaultcolumns13" />
                                                                                                                                            </xsl:when>
                                                                                                                                            <xsl:otherwise>
                                                                                                                                                <xsl:value-of select="0.000" />
                                                                                                                                            </xsl:otherwise>
                                                                                                                                        </xsl:choose>
                                                                                                                                    </xsl:variable>
                                                                                                                                    <xsl:variable name="columnwidth13_0" select="0.52083 * $factor13" />
                                                                                                                                    <xsl:variable name="columnwidth13_1" select="$defaultcolumnwidth13" />
                                                                                                                                    <xsl:variable name="columnwidth13_2" select="$defaultcolumnwidth13" />
                                                                                                                                    <xsl:variable name="columnwidth13_3" select="$defaultcolumnwidth13" />
                                                                                                                                    <xsl:variable name="columnwidth13_4" select="$defaultcolumnwidth13" />
                                                                                                                                    <xsl:variable name="columnwidth13_5" select="0.34333 * $factor13" /> <!--<CODE_TAG_100626> -->
                                                                                                                                    <xsl:variable name="columnwidth13_6" select="1.33333 * $factor13" /> <!--<CODE_TAG_100626> -->
																																	<xsl:variable name="columnwidth13_7">
																																		<!-- DESCRIPTION -->
																																		<!--<BEGIN-fxiao, 2010-01-11::Separate Discount from Unit Price - adjust description column width to format layout properly>-->
																																		<xsl:choose>
																																			<xsl:when test="//QuoteDetail/@ShowUnitPriceSeperately = '2'">
																																				<xsl:value-of select="1.87500 * $factor13" />
																																			</xsl:when>
																																			<xsl:otherwise>
																																				<xsl:value-of select="2.7500 * $factor13"/>
																																			</xsl:otherwise>
																																		</xsl:choose>
																																		<!--</END-fxiao, 2010-01-11>-->
																																	</xsl:variable>
                                                                                                                                    <xsl:variable name="columnwidth13_8" select="0.83333 * $factor13" />
                                                                                                                                    <xsl:variable name="columnwidth13_9" select="0.83333 * $factor13" />
																																	<xsl:variable name="columnwidth13_10">
																																		<!-- LAST COLUMN -->
																																		<!--<BEGIN-fxiao, 2010-01-11::Separate Discount from Unit Price - adjust description column width to format layout properly>-->
																																		<xsl:choose>
																																			<xsl:when test="//QuoteDetail/@ShowUnitPriceSeperately = '2'">
																																				<xsl:value-of select="1.04167 * $factor13" />
																																			</xsl:when>
																																			<xsl:otherwise>
																																				<xsl:value-of select="0"/>
																																			</xsl:otherwise>
																																		</xsl:choose>
																																		<!--</END-fxiao, 2010-01-11>-->
																																	</xsl:variable>
                                                                                                                                    <fo:table width="{$tablewidth13}in" space-before.optimum="1pt" space-after.optimum="2pt" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
                                                                                                                                        <fo:table-column column-width="{$columnwidth13_0}in" />
                                                                                                                                        <fo:table-column column-width="{$columnwidth13_1}in" />
                                                                                                                                        <fo:table-column column-width="{$columnwidth13_2}in" />
                                                                                                                                        <fo:table-column column-width="{$columnwidth13_3}in" />
                                                                                                                                        <fo:table-column column-width="{$columnwidth13_4}in" />
                                                                                                                                        <fo:table-column column-width="{$columnwidth13_5}in" />
                                                                                                                                        <fo:table-column column-width="{$columnwidth13_6}in" />
                                                                                                                                        <fo:table-column column-width="{$columnwidth13_7}in" />
                                                                                                                                        <fo:table-column column-width="{$columnwidth13_8}in" />
                                                                                                                                        <fo:table-column column-width="{$columnwidth13_9}in" />
                                                                                                                                        <fo:table-column column-width="{$columnwidth13_10}in" />
                                                                                                                                        <fo:table-body>
                                                                                                                                            <fo:table-row font-size="8.5px" font-weight="normal" top="0.00000in">
                                                                                                                                                <fo:table-cell bottom="0.00000in" top="0.00000in" white-space-collapse="true" wrap-option="no-wrap" number-columns-spanned="5" text-align="left" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                                                                                                                                    <fo:block padding-top="1pt" padding-bottom="1pt" />
                                                                                                                                                </fo:table-cell>
                                                                                                                                                <fo:table-cell bottom="0.00000in" font-size="8.5px" font-weight="normal" top="0.00000in" white-space-collapse="true" wrap-option="no-wrap" text-align="center" padding-top="0.00000in" padding-bottom="0.00000in">
                                                                                                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                                                                        <xsl:for-each select="Quantity">
                                                                                                                                                            <fo:inline>
                                                                                                                                                                <xsl:apply-templates>
                                                                                                                                                                    <xsl:with-param name="maxwidth" select="$columnwidth13_5" />
                                                                                                                                                                </xsl:apply-templates>
                                                                                                                                                            </fo:inline>
                                                                                                                                                        </xsl:for-each>
                                                                                                                                                    </fo:block>
                                                                                                                                                </fo:table-cell>
                                                                                                                                                <fo:table-cell bottom="0.00000in" font-size="8.5px" font-weight="normal" top="0.00000in" white-space-collapse="true" wrap-option="no-wrap" text-align="left" padding-top="0.00000in" padding-bottom="0.00000in">
                                                                                                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                                                                        <xsl:for-each select="ItemNo">
                                                                                                                                                            <fo:inline>
                                                                                                                                                                <xsl:apply-templates>
                                                                                                                                                                    <xsl:with-param name="maxwidth" select="$columnwidth13_6" />
                                                                                                                                                                </xsl:apply-templates>
                                                                                                                                                            </fo:inline>
                                                                                                                                                        </xsl:for-each>
                                                                                                                                                    </fo:block>
                                                                                                                                                </fo:table-cell>
                                                                                                                                                <fo:table-cell bottom="0.00000in" top="0.00000in" height="0.01042in" text-align="left" padding-top="0.00000in" padding-bottom="0.00000in">
                                                                                                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                                                                        <xsl:for-each select="Description">
                                                                                                                                                            <fo:inline>
                                                                                                                                                                <xsl:apply-templates>
                                                                                                                                                                    <xsl:with-param name="maxwidth" select="$columnwidth13_7" />
                                                                                                                                                                </xsl:apply-templates>
                                                                                                                                                            </fo:inline>
                                                                                                                                                        </xsl:for-each>
                                                                                                                                                    </fo:block>
                                                                                                                                                </fo:table-cell>
                                                                                                                                                <fo:table-cell bottom="0.00000in" font-size="8.5px" font-weight="normal" top="0.00000in" white-space-collapse="true" wrap-option="no-wrap" text-align="right" padding-top="0.00000in" padding-bottom="0.00000in">
                                                                                                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                                                                        <xsl:for-each select="UnitPrice">
                                                                                                                                                            <fo:inline>
                                                                                                                                                                <xsl:apply-templates>
                                                                                                                                                                    <xsl:with-param name="maxwidth" select="$columnwidth13_8" />
                                                                                                                                                                </xsl:apply-templates>
                                                                                                                                                            </fo:inline>
                                                                                                                                                        </xsl:for-each>
                                                                                                                                                    </fo:block>
                                                                                                                                                </fo:table-cell>
                                                                                                                                                <!--<BEGIN-fxiao, 2010-01-11::Separate Discount from Unit Price>-->
                                                                                                                                                <xsl:if test="//QuoteDetail/@ShowUnitPriceSeperately = '2'">
                                                                                                                                                  
                                                                                                                                                	<fo:table-cell bottom="0.00000in" font-size="8.5px" font-weight="normal" top="0.00000in" white-space-collapse="true" wrap-option="no-wrap" text-align="right" padding-top="0.00000in" padding-bottom="0.00000in">
                                                                                                                                                		<fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                                                                      <xsl:if test="DiscountColumnShow = 2">
                                                                                                                                                		    <xsl:for-each select="DiscPrice">
                                                                                                                                                		        <fo:inline>
                                                                                                                                                              
                                                                                                                                                		            <xsl:apply-templates>
                                                                                                                                                		                <xsl:with-param name="maxwidth" select="$columnwidth13_8" />
                                                                                                                                                		            </xsl:apply-templates>
                                                                                                                                                             
                                                                                                                                                		        </fo:inline>
                                                                                                                                                		    </xsl:for-each>
                                                                                                                                                      </xsl:if>
                                                                                                                                                		</fo:block>
                                                                                                                                                	</fo:table-cell>
                                                                                                                                                  
																																				                                                                      </xsl:if>
                                                                                                                                                <!--</END-fxiao, 2010-01-11>-->
                                                                                                                                                <fo:table-cell bottom="0.00000in" font-size="8.5px" font-weight="normal" top="0.00000in" white-space-collapse="true" wrap-option="no-wrap" text-align="right" padding-top="0.00000in" padding-bottom="0.00000in">
                                                                                                                                                    <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                                                                                        <xsl:for-each select="ExtendedPrice">
                                                                                                                                                            <fo:inline>
                                                                                                                                                                <xsl:apply-templates>
                                                                                                                                                                    <xsl:with-param name="maxwidth" select="$columnwidth13_9" />
                                                                                                                                                                </xsl:apply-templates>
                                                                                                                                                            </fo:inline>
                                                                                                                                                        </xsl:for-each>
                                                                                                                                                    </fo:block>
                                                                                                                                                </fo:table-cell>
                                                                                                                                                <fo:table-cell bottom="0.00000in" font-size="8.5px" font-weight="normal" top="0.00000in" white-space-collapse="true" wrap-option="no-wrap" text-align="right" padding-top="0.00000in" padding-bottom="0.00000in">
                                                                                                                                                    <fo:block padding-top="1pt" padding-bottom="1pt" />
                                                                                                                                                </fo:table-cell>
                                                                                                                                            </fo:table-row>
                                                                                                                                        </fo:table-body>
                                                                                                                                    </fo:table>
                                                                                                                                </fo:block>
                                                                                                                            </fo:table-cell>
                                                                                                                        </fo:table-row>
                                                                                                                    </xsl:for-each>
                                                                                                                </fo:table-body>
                                                                                                            </fo:table>
                                                                                                        </xsl:otherwise>
                                                                                                    </xsl:choose>
                                                                                                </xsl:otherwise>
                                                                                            </xsl:choose>
                                                                                        </fo:block>
                                                                                    </fo:table-cell>
                                                                                </fo:table-row>
                                                                                <fo:table-row font-size="8.5px" font-weight="bold">
                                                                                    <fo:table-cell bottom="0.00000in" font-size="8.5px" font-weight="bold" number-columns-spanned="9" text-align="right" border-top-style="solid" border-top-color="black" border-top-width="0.01042in">
                                                                                        <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                            <fo:inline>
                                                                                                <xsl:text>Total </xsl:text>
                                                                                            </fo:inline>
                                                                                            <xsl:for-each select="CategoryName">
                                                                                                <fo:inline>
                                                                                                    <xsl:apply-templates>
                                                                                                        <xsl:with-param name="maxwidth" select="$columnwidth11_0 + $columnwidth11_1 + $columnwidth11_2 + $columnwidth11_3 + $columnwidth11_4 + $columnwidth11_5 + $columnwidth11_6 + $columnwidth11_7 + $columnwidth11_8" />
                                                                                                    </xsl:apply-templates>
                                                                                                </fo:inline>
                                                                                            </xsl:for-each>
                                                                                            <fo:inline>
                                                                                                <xsl:text>&#160;</xsl:text>
                                                                                            </fo:inline>
                                                                                        </fo:block>
                                                                                    </fo:table-cell>
                                                                                    <fo:table-cell bottom="0.00000in" font-size="8.5px" font-weight="bold" height="0.01042in" text-align="right" border-top-style="solid" border-top-color="black" border-top-width="0.01042in">
                                                                                        <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                            <xsl:for-each select="iTotal">
                                                                                                <fo:inline>
                                                                                                    <xsl:apply-templates>
                                                                                                        <xsl:with-param name="maxwidth" select="$columnwidth11_9" />
                                                                                                    </xsl:apply-templates>
                                                                                                </fo:inline>
                                                                                            </xsl:for-each>
                                                                                        </fo:block>
                                                                                    </fo:table-cell>
                                                                                </fo:table-row>
                                                                            </xsl:for-each>
                                                                        </fo:table-body>
                                                                    </fo:table>
                                                                </xsl:when>
                                                                <xsl:otherwise />
                                                            </xsl:choose>
                                                        </fo:block>
                                                    </fo:table-cell>
                                                </fo:table-row>
                                                <fo:table-row font-size="8.5px" font-weight="bold">
                                                    <fo:table-cell bottom="0.00000in" number-columns-spanned="4" text-align="right">
                                                        <fo:block padding-top="1pt" padding-bottom="1pt">
															<!-- [<IAranda 20080915> PrintConfig.] -->
                                                            <!-- xsl:if test="DBSRepairOptionId =0 or ( DBSRepairOptionId !=0 and  ../../Parameter/iInternal =1)" -->
                                                            <xsl:if test="1=1">
                                                                <xsl:variable name="tablewidth14" select="$columnwidth8_0 * 1.00000 + $columnwidth8_1 * 1.00000 + $columnwidth8_2 * 1.00000 + $columnwidth8_3 * 1.00000" />
                                                                <xsl:variable name="sumcolumnwidths14" select="1.04167" />
                                                                <xsl:variable name="factor14">
                                                                    <xsl:choose>
                                                                        <xsl:when test="$sumcolumnwidths14 &gt; 0.00000 and $sumcolumnwidths14 &gt; $tablewidth14">
                                                                            <xsl:value-of select="$tablewidth14 div $sumcolumnwidths14" />
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:value-of select="1.000" />
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:variable>
                                                                <xsl:variable name="defaultcolumns14" select="1 + 1 + 1 + 1 + 1 + 1" />
                                                                <xsl:variable name="defaultcolumnwidth14">
                                                                    <xsl:choose>
                                                                        <xsl:when test="$factor14 &lt; 1.000">
                                                                            <xsl:value-of select="0.000" />
                                                                        </xsl:when>
                                                                        <xsl:when test="$defaultcolumns14 &gt; 0">
                                                                            <xsl:value-of select="($tablewidth14 - $sumcolumnwidths14) div $defaultcolumns14" />
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:value-of select="0.000" />
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:variable>
                                                                <xsl:variable name="columnwidth14_0" select="$defaultcolumnwidth14" />
                                                                <xsl:variable name="columnwidth14_1" select="$defaultcolumnwidth14" />
                                                                <xsl:variable name="columnwidth14_2" select="$defaultcolumnwidth14" />
                                                                <xsl:variable name="columnwidth14_3" select="$defaultcolumnwidth14" />
                                                                <xsl:variable name="columnwidth14_4" select="$defaultcolumnwidth14" />
                                                                <xsl:variable name="columnwidth14_5" select="$defaultcolumnwidth14" />
                                                                <xsl:variable name="columnwidth14_6" select="1.04167 * $factor14" />
                                                                <fo:table width="{$tablewidth14}in" space-before.optimum="1pt" space-after.optimum="2pt" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
                                                                    <fo:table-column column-width="{$columnwidth14_0}in" />
                                                                    <fo:table-column column-width="{$columnwidth14_1}in" />
                                                                    <fo:table-column column-width="{$columnwidth14_2}in" />
                                                                    <fo:table-column column-width="{$columnwidth14_3}in" />
                                                                    <fo:table-column column-width="{$columnwidth14_4}in" />
                                                                    <fo:table-column column-width="{$columnwidth14_5}in" />
                                                                    <fo:table-column column-width="{$columnwidth14_6}in" />
                                                                    <fo:table-body>
                                                                        <fo:table-row font-size="8.5px" font-weight="bold">
                                                                            <fo:table-cell bottom="0.00000in" number-columns-spanned="3" text-align="right">
                                                                                <fo:block padding-top="1pt" padding-bottom="1pt" />
                                                                            </fo:table-cell>
                                                                            <fo:table-cell bottom="0.00000in" number-columns-spanned="3" text-align="right">
                                                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                    <fo:inline>
                                                                                        <xsl:text>Segment </xsl:text>
                                                                                    </fo:inline>
                                                                                    <xsl:for-each select="SegmentNo">
                                                                                        <fo:inline>
                                                                                            <xsl:apply-templates>
                                                                                                <xsl:with-param name="maxwidth" select="$columnwidth14_3 + $columnwidth14_4 + $columnwidth14_5" />
                                                                                            </xsl:apply-templates>
                                                                                        </fo:inline>
                                                                                    </xsl:for-each>
                                                                                    <fo:inline>
                                                                                        <xsl:text> Total </xsl:text>
                                                                                    </fo:inline>
                                                                                </fo:block>
                                                                            </fo:table-cell>
                                                                            <fo:table-cell bottom="0.00000in" text-align="right">
                                                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                                                    <xsl:for-each select="SegmentTotal"><!--<CODE_TAG_100350>Replace iSegTotal element</CODE_TAG_100350>-->
																						<fo:inline>
                                                                                            <xsl:apply-templates>
                                                                                                <xsl:with-param name="maxwidth" select="$columnwidth14_6" />
                                                                                            </xsl:apply-templates>
                                                                                        </fo:inline>
                                                                                    </xsl:for-each>
                                                                                </fo:block>
                                                                            </fo:table-cell>
                                                                        </fo:table-row>
                                                                    </fo:table-body>
                                                                </fo:table>
                                                            </xsl:if>
                                                        </fo:block>
                                                    </fo:table-cell>
                                                </fo:table-row>
                                            </xsl:for-each>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </fo:table-body>
                        </fo:table>
                        <xsl:variable name="tablewidth15" select="$maxwidth * 0.98000" />
                        <xsl:variable name="sumcolumnwidths15" select="1.04167 + 1.04167" />
                        <xsl:variable name="factor15">
                            <xsl:choose>
                                <xsl:when test="$sumcolumnwidths15 &gt; 0.00000 and $sumcolumnwidths15 &gt; $tablewidth15">
                                    <xsl:value-of select="$tablewidth15 div $sumcolumnwidths15" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="1.000" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="defaultcolumns15" select="1 + 1 + 1 + 1 + 1 + 1 + 1 + 1" />
                        <xsl:variable name="defaultcolumnwidth15">
                            <xsl:choose>
                                <xsl:when test="$factor15 &lt; 1.000">
                                    <xsl:value-of select="0.000" />
                                </xsl:when>
                                <xsl:when test="$defaultcolumns15 &gt; 0">
                                    <xsl:value-of select="($tablewidth15 - $sumcolumnwidths15) div $defaultcolumns15" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="0.000" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="columnwidth15_0" select="$defaultcolumnwidth15" />
                        <xsl:variable name="columnwidth15_1" select="$defaultcolumnwidth15" />
                        <xsl:variable name="columnwidth15_2" select="$defaultcolumnwidth15" />
                        <xsl:variable name="columnwidth15_3" select="$defaultcolumnwidth15" />
                        <xsl:variable name="columnwidth15_4" select="$defaultcolumnwidth15" />
                        <xsl:variable name="columnwidth15_5" select="$defaultcolumnwidth15" />
                        <xsl:variable name="columnwidth15_6" select="$defaultcolumnwidth15" />
                        <xsl:variable name="columnwidth15_7" select="$defaultcolumnwidth15" />
                        <xsl:variable name="columnwidth15_8" select="1.04167 * $factor15" />
                        <xsl:variable name="columnwidth15_9" select="1.04167 * $factor15" />
                        <fo:table width="{$tablewidth15}in" space-before.optimum="1pt" space-after.optimum="2pt" border-top-style="solid" border-top-color="black" border-top-width="0.02083in" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
                            <fo:table-column column-width="{$columnwidth15_0}in" />
                            <fo:table-column column-width="{$columnwidth15_1}in" />
                            <fo:table-column column-width="{$columnwidth15_2}in" />
                            <fo:table-column column-width="{$columnwidth15_3}in" />
                            <fo:table-column column-width="{$columnwidth15_4}in" />
                            <fo:table-column column-width="{$columnwidth15_5}in" />
                            <fo:table-column column-width="{$columnwidth15_6}in" />
                            <fo:table-column column-width="{$columnwidth15_7}in" />
                            <fo:table-column column-width="{$columnwidth15_8}in" />
                            <fo:table-column column-width="{$columnwidth15_9}in" />
                            <fo:table-body>
                            <!-- [<IAranda. 20080604>. PSQuoter Changes. START] -->
                                <fo:table-row font-size="8.5px" font-weight="bold">
                                    <fo:table-cell bottom="0.00000in" text-align="right" number-columns-spanned="9" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.02083in">
                                        <fo:block padding-top="1pt" padding-bottom="1pt">
                                            <fo:inline>
                                                <xsl:text>TOTAL </xsl:text>
                                            </fo:inline>
											<xsl:for-each select="$XML1">
												<xsl:for-each select="root">
													<xsl:for-each select="QuoteHeader">
														<xsl:for-each select="headerText">
																<xsl:value-of select="translate(. , $lcletters , $ucletters)"/>
														</xsl:for-each>
													</xsl:for-each>
												</xsl:for-each>
											</xsl:for-each>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell bottom="0.00000in" text-align="right" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.02083in">
                                        <fo:block padding-top="1pt" padding-bottom="1pt">
                                            <xsl:for-each select="$XML1">
                                                <xsl:for-each select="root">
                                                    <xsl:for-each select="QuoteHeader">
                                                        <xsl:for-each select="Table">
                                                            <xsl:for-each select="QuoteTotal">
                                                                <fo:inline>
                                                                    <xsl:apply-templates>
                                                                        <xsl:with-param name="maxwidth" select="$columnwidth15_9" />
                                                                    </xsl:apply-templates>
                                                                </fo:inline>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                </xsl:for-each>
                                            </xsl:for-each>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            <!-- [<IAranda. 20080604>. PSQuoter Changes. END] -->
                            </fo:table-body>
                        </fo:table>




<!-- [<IAranda. 20080604>. PSQuoter Changes. START] -->
<xsl:variable name="tablewidth116" select="$maxwidth * 0.98000" />
                                        <xsl:variable name="sumcolumnwidths116" select="1.87500 + 1.04167" />
                                        <xsl:variable name="factor116">
                                            <xsl:choose>
                                                <xsl:when test="$sumcolumnwidths116 &gt; 0.00000 and $sumcolumnwidths116 &gt; $tablewidth116">
                                                    <xsl:value-of select="$tablewidth116 div $sumcolumnwidths116" />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="1.000" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <xsl:variable name="defaultcolumns116" select="1 + 1" />
                                        <xsl:variable name="defaultcolumnwidth116">
                                            <xsl:choose>
                                                <xsl:when test="$factor116 &lt; 1.000">
                                                    <xsl:value-of select="0.000" />
                                                </xsl:when>
                                                <xsl:when test="$defaultcolumns116 &gt; 0">
                                                    <xsl:value-of select="($tablewidth116 - $sumcolumnwidths116) div $defaultcolumns116" />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="0.000" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <xsl:variable name="columnwidth116_0" select="1.87500 * $factor116" />
                                        <xsl:variable name="columnwidth116_1" select="$defaultcolumnwidth116" />
                                        <xsl:variable name="columnwidth116_2" select="1.04167 * $factor116" />
                                        <xsl:variable name="columnwidth116_3" select="$defaultcolumnwidth116" />
<fo:table width="{$tablewidth116}in" space-before.optimum="1pt" space-after.optimum="2pt" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
                                            <fo:table-column column-width="{$columnwidth116_0}in" />
                                            <fo:table-column column-width="{$columnwidth116_1}in" />
                                            <fo:table-column column-width="{$columnwidth116_2}in" />
                                            <fo:table-column column-width="{$columnwidth116_3}in" />
	<fo:table-body>
		<fo:table-row font-size="8.5px" font-weight="normal" top="0.00000in" font-style="italic">
			<fo:table-cell bottom="0.00000in" number-columns-spanned="4">
                <fo:block padding-top="1pt" padding-bottom="1pt">
                    <fo:block>
                        <xsl:text>&#xA;</xsl:text>
                    </fo:block>
                    <fo:block>
                        <fo:leader leader-pattern="space" />
                    </fo:block>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
		<fo:table-row font-size="8.5px" font-weight="normal" top="0.00000in" font-style="italic">
			<fo:table-cell bottom="0.00000in" text-align="left" number-columns-spanned="4" font-weight="bold" >
				<fo:block padding-top="1pt" padding-bottom="1pt">
					<xsl:for-each select="$XML1">
						<xsl:for-each select="root">
							<xsl:for-each select="TermCond">
								<fo:block>
									- <!--<CODE_TAG_100494>Add dash</CODE_TAG_100494>--> 
									<xsl:apply-templates>
										<xsl:with-param name="maxwidth" select="$columnwidth116_1" />
									</xsl:apply-templates>
		                        </fo:block >
		                    </xsl:for-each>
		                   
						</xsl:for-each>
					</xsl:for-each>
                </fo:block>
                <fo:block>
					<xsl:text>&#xA;</xsl:text>
				</fo:block>
            </fo:table-cell>
		</fo:table-row>
		<fo:table-row font-size="8.5px" font-weight="normal" top="0.00000in" font-style="italic">
			<fo:table-cell bottom="0.00000in" number-columns-spanned="4">
				<fo:block padding-top="1pt" padding-bottom="1pt">
					<fo:block>
						<xsl:text>&#xA;</xsl:text>
					</fo:block>
					<fo:block>
						<fo:leader leader-pattern="space" />
					</fo:block>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
		<!--<CODE_TAG_100278>Show disclaimers-->
		<xsl:for-each select="$XML1">
			<xsl:for-each select="root">
				<xsl:for-each select="Disclaimers">
					<fo:table-row font-size="8.5px" font-weight="normal" top="0.00000in" font-style="italic">
						<fo:table-cell bottom="0.00000in" text-align="left" number-columns-spanned="4">
							<fo:block padding-top="1pt" padding-bottom="1pt" font-weight="bold" border-top-style="solid" border-top-color="black" border-top-width="0.0104in" space-before.optimum="2pt">
								<xsl:for-each select="para">
									<fo:block space-after.optimum="0pt">
										<xsl:attribute name="space-before.optimum">
											<xsl:if test="position()=1">1pt</xsl:if>
											<xsl:if test="position()&gt;1">4pt</xsl:if>
										</xsl:attribute>
										<fo:inline>
											<xsl:apply-templates />
										</fo:inline>
									</fo:block>
								</xsl:for-each>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:for-each>
		<!--</CODE_TAG_100278>Show disclaimers-->
	</fo:table-body>
</fo:table>
 
<!-- [<IAranda. 20080604>. PSQuoter Changes. END] -->








                        <xsl:choose>
                            <xsl:when test="$XML1/root/QuoteHeader/Table/Type =&quot;Q&quot;">
                                <xsl:choose>
                                    <xsl:when test="$XML1/root/Parameter/iInternal =0">
                                        <xsl:variable name="tablewidth16" select="$maxwidth * 0.98000" />
                                        <xsl:variable name="sumcolumnwidths16" select="1.87500 + 1.04167" />
                                        <xsl:variable name="factor16">
                                            <xsl:choose>
                                                <xsl:when test="$sumcolumnwidths16 &gt; 0.00000 and $sumcolumnwidths16 &gt; $tablewidth16">
                                                    <xsl:value-of select="$tablewidth16 div $sumcolumnwidths16" />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="1.000" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <xsl:variable name="defaultcolumns16" select="1 + 1" />
                                        <xsl:variable name="defaultcolumnwidth16">
                                            <xsl:choose>
                                                <xsl:when test="$factor16 &lt; 1.000">
                                                    <xsl:value-of select="0.000" />
                                                </xsl:when>
                                                <xsl:when test="$defaultcolumns16 &gt; 0">
                                                    <xsl:value-of select="($tablewidth16 - $sumcolumnwidths16) div $defaultcolumns16" />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="0.000" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <xsl:variable name="columnwidth16_0" select="1.87500 * $factor16" />
                                        <xsl:variable name="columnwidth16_1" select="$defaultcolumnwidth16" />
                                        <xsl:variable name="columnwidth16_2" select="1.04167 * $factor16" />
                                        <xsl:variable name="columnwidth16_3" select="$defaultcolumnwidth16" />
                                        <fo:table width="{$tablewidth16}in" space-before.optimum="1pt" space-after.optimum="2pt" border-top-style="solid" border-top-color="black" border-top-width="0.02083in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.02083in" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
                                            <fo:table-column column-width="{$columnwidth16_0}in" />
                                            <fo:table-column column-width="{$columnwidth16_1}in" />
                                            <fo:table-column column-width="{$columnwidth16_2}in" />
                                            <fo:table-column column-width="{$columnwidth16_3}in" />
                                            <fo:table-body>
                                                <fo:table-row font-size="8.5px" font-weight="normal">
                                                    <fo:table-cell bottom="0.00000in" font-style="italic" font-weight="bold">
                                                        <fo:block padding-top="1pt" padding-bottom="1pt">
                                                            <fo:inline>
                                                                <xsl:text>ESTIMATED REPAIR TIME:</xsl:text>
                                                            </fo:inline>
                                                        </fo:block>
                                                    </fo:table-cell>
                                                    <fo:table-cell bottom="0.00000in" text-align="center" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in">
                                                        <fo:block padding-top="1pt" padding-bottom="1pt">
                                                            <xsl:for-each select="$XML1">
                                                                <xsl:for-each select="root">
                                                                    <xsl:for-each select="QuoteHeader">
                                                                        <xsl:for-each select="Table">
                                                                            <xsl:for-each select="EstimatedRepairTime">
                                                                                <fo:inline>
                                                                                    <xsl:apply-templates>
                                                                                        <xsl:with-param name="maxwidth" select="$columnwidth16_1" />
                                                                                    </xsl:apply-templates>
                                                                                </fo:inline>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </fo:block>
                                                    </fo:table-cell>
                                                    <fo:table-cell bottom="0.00000in" font-style="italic" font-weight="bold">
                                                        <fo:block padding-top="1pt" padding-bottom="1pt">
                                                            <fo:inline>
                                                                <xsl:text> from start date</xsl:text>
                                                            </fo:inline>
                                                        </fo:block>
                                                    </fo:table-cell>
                                                    <fo:table-cell bottom="0.00000in">
                                                        <fo:block padding-top="1pt" padding-bottom="1pt" />
                                                    </fo:table-cell>
                                                </fo:table-row>
                                                <fo:table-row font-size="8.5px" font-style="italic" font-weight="bold">
                                                    <fo:table-cell bottom="0.00000in" number-columns-spanned="4">
                                                        <fo:block padding-top="1pt" padding-bottom="1pt">
                                                            <fo:inline>
																<!--<CODE_TAG_100494>Add acknowledge message-->
																<xsl:text>&quot;</xsl:text>
																<xsl:choose>
																	<xsl:when test="/root/AcknowledgeMessage">
																		<xsl:value-of select="/root/AcknowledgeMessage"/>
																	</xsl:when>
																	<xsl:otherwise>
																		The signature is an authorization to proceed with the required repair work as described within the quote
																	</xsl:otherwise>
																</xsl:choose>
																<xsl:text>&quot;.</xsl:text>
																<!--</CODE_TAG_100494>-->
                                                            </fo:inline>
                                                            <fo:block>
                                                                <xsl:text>&#xA;</xsl:text>
                                                            </fo:block>
                                                            <fo:block>
                                                                <fo:leader leader-pattern="space" />
                                                            </fo:block>
                                                        </fo:block>
                                                    </fo:table-cell>
                                                </fo:table-row>
                                                <fo:table-row font-size="8.5px" font-style="italic" font-weight="bold">
                                                    <fo:table-cell bottom="0.00000in" number-columns-spanned="4">
                                                        <fo:block padding-top="1pt" padding-bottom="1pt">
                                                            <fo:inline>
                                                                <xsl:text>Issued PO# _____________________, Authorized Name ________________________________________ Please Print</xsl:text>
                                                            </fo:inline>
                                                            <fo:block>
                                                                <xsl:text>&#xA;</xsl:text>
                                                            </fo:block>
                                                            <fo:block>
                                                                <fo:leader leader-pattern="space" />
                                                            </fo:block>
                                                            <fo:block>
                                                                <fo:leader leader-pattern="space" />
                                                            </fo:block>
                                                            <fo:block>
                                                                <fo:leader leader-pattern="space" />
                                                            </fo:block>
                                                        </fo:block>
                                                    </fo:table-cell>
                                                </fo:table-row>
                                                <fo:table-row font-size="8.5px" font-style="italic" font-weight="bold">
                                                    <fo:table-cell bottom="0.00000in" number-columns-spanned="4">
                                                        <fo:block padding-top="1pt" padding-bottom="1pt">
                                                            <fo:inline>
                                                                <xsl:text>Date ____ / ____ / ________. </xsl:text>
                                                            </fo:inline>
                                                        </fo:block>
                                                    </fo:table-cell>
                                                </fo:table-row>
                                                <fo:table-row font-size="8.5px" font-weight="normal">
                                                    <fo:table-cell bottom="0.00000in" number-columns-spanned="3">
                                                        <fo:block padding-top="1pt" padding-bottom="1pt">
															<xsl:choose>
                                                                <xsl:when test="$XML1/root/QuoteHeader/Table/SRPhoneNo !=&quot;&quot;">
                                                            <fo:inline>
                                                                <xsl:text>Any questions? Please call </xsl:text>
                                                            </fo:inline>
                                                            <xsl:for-each select="$XML1">
                                                                <xsl:for-each select="root">
                                                                    <xsl:for-each select="QuoteHeader">
                                                                        <xsl:for-each select="Table">
                                                                            <xsl:for-each select="SRFName">
                                                                                <fo:inline>
                                                                                    <xsl:apply-templates>
                                                                                        <xsl:with-param name="maxwidth" select="$columnwidth16_0 + $columnwidth16_1 + $columnwidth16_2" />
                                                                                    </xsl:apply-templates>
                                                                                </fo:inline>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                            <fo:inline>
                                                                <xsl:text>&#160;</xsl:text>
                                                            </fo:inline>
                                                            <xsl:for-each select="$XML1">
                                                                <xsl:for-each select="root">
                                                                    <xsl:for-each select="QuoteHeader">
                                                                        <xsl:for-each select="Table">
                                                                            <xsl:for-each select="SRLName">
                                                                                <fo:inline>
                                                                                    <xsl:apply-templates>
                                                                                        <xsl:with-param name="maxwidth" select="$columnwidth16_0 + $columnwidth16_1 + $columnwidth16_2" />
                                                                                    </xsl:apply-templates>
                                                                                </fo:inline>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                            <fo:inline>
                                                                <xsl:text> at </xsl:text>
                                                            </fo:inline>
                                                            <xsl:for-each select="$XML1">
                                                                <xsl:for-each select="root">
                                                                    <xsl:for-each select="QuoteHeader">
                                                                        <xsl:for-each select="Table">
                                                                            <xsl:for-each select="SRPhoneNo">
                                                                                <fo:inline>
                                                                                    <xsl:apply-templates>
                                                                                        <xsl:with-param name="maxwidth" select="$columnwidth16_0 + $columnwidth16_1 + $columnwidth16_2" />
                                                                                    </xsl:apply-templates>
                                                                                </fo:inline>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                            <fo:inline>
                                                                <xsl:text>.</xsl:text>
                                                            </fo:inline>
                                                            </xsl:when>
                                                                <xsl:otherwise />
                                                            </xsl:choose>
                                                            <xsl:choose>
                                                                <xsl:when test="$XML1/root/QuoteHeader/Table/SRFaxNo !=&quot;&quot;">
																	<fo:inline>
																		<xsl:text> Fax Number </xsl:text>
																	</fo:inline>
																	<xsl:for-each select="$XML1">
																		<xsl:for-each select="root">
																			<xsl:for-each select="QuoteHeader">
																				<xsl:for-each select="Table">
																					<xsl:for-each select="SRFaxNo">
																						<fo:inline>
																							<xsl:apply-templates>
																								<xsl:with-param name="maxwidth" select="$columnwidth16_0 + $columnwidth16_1 + $columnwidth16_2" />
																							</xsl:apply-templates>
																						</fo:inline>
																					</xsl:for-each>
																				</xsl:for-each>
																			</xsl:for-each>
																		</xsl:for-each>
																	</xsl:for-each>
																	<fo:inline>
																		<xsl:text>.</xsl:text>
																	</fo:inline>
																</xsl:when>	
																<xsl:otherwise />
                                                            </xsl:choose>
                                                        </fo:block>
                                                    </fo:table-cell>
                                                    <fo:table-cell bottom="0.00000in" text-align="center" border-top-style="solid" border-top-color="black" border-top-width="0.01042in">
                                                        <fo:block padding-top="1pt" padding-bottom="1pt">
                                                            <fo:inline>
                                                                <xsl:text>Signature</xsl:text>
                                                            </fo:inline>
                                                        </fo:block>
                                                    </fo:table-cell>
                                                </fo:table-row>
                                            </fo:table-body>
                                        </fo:table>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:variable name="tablewidth17" select="$maxwidth * 0.98000" />
                                        <xsl:variable name="sumcolumnwidths17" select="1.56250 + 1.04167 + 1.04167 + 3.33333" />
                                        <xsl:variable name="factor17">
                                            <xsl:choose>
                                                <xsl:when test="$sumcolumnwidths17 &gt; 0.00000 and $sumcolumnwidths17 &gt; $tablewidth17">
                                                    <xsl:value-of select="$tablewidth17 div $sumcolumnwidths17" />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="1.000" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <xsl:variable name="columnwidth17_0" select="1.56250 * $factor17" />
                                        <xsl:variable name="columnwidth17_1" select="1.04167 * $factor17" />
                                        <xsl:variable name="columnwidth17_2" select="1.04167 * $factor17" />
                                        <xsl:variable name="columnwidth17_3" select="3.33333 * $factor17" />
                                        <fo:table width="{$tablewidth17}in" space-before.optimum="1pt" space-after.optimum="2pt" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.02083in" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
                                            <fo:table-column column-width="{$columnwidth17_0}in" />
                                            <fo:table-column column-width="{$columnwidth17_1}in" />
                                            <fo:table-column column-width="{$columnwidth17_2}in" />
                                            <fo:table-column column-width="{$columnwidth17_3}in" />
                                            <fo:table-body>
                                                <fo:table-row font-size="8.5px" font-weight="normal">
                                                    <fo:table-cell bottom="0.00000in">
                                                        <fo:block padding-top="1pt" padding-bottom="1pt">
                                                            <fo:inline>
                                                                <xsl:text>ESTIMATED REPAIR TIME:</xsl:text>
                                                            </fo:inline>
                                                        </fo:block>
                                                    </fo:table-cell>
                                                    <fo:table-cell bottom="0.00000in">
                                                        <fo:block padding-top="1pt" padding-bottom="1pt">
                                                            <fo:inline text-decoration="underline">
                                                                <xsl:text>&#160;&#160;&#160;&#160;&#160; </xsl:text>
                                                            </fo:inline>
                                                            <xsl:for-each select="$XML1">
                                                                <xsl:for-each select="root">
                                                                    <xsl:for-each select="QuoteHeader">
                                                                        <xsl:for-each select="Table">
                                                                            <xsl:for-each select="EstimatedRepairTime">
                                                                                <fo:inline text-decoration="underline">
                                                                                    <xsl:apply-templates>
                                                                                        <xsl:with-param name="maxwidth" select="$columnwidth17_1" />
                                                                                    </xsl:apply-templates>
                                                                                </fo:inline>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                            <fo:inline text-decoration="underline">
                                                                <xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; </xsl:text>
                                                            </fo:inline>
                                                        </fo:block>
                                                    </fo:table-cell>
                                                    <fo:table-cell bottom="0.00000in">
                                                        <fo:block padding-top="1pt" padding-bottom="1pt">
                                                            <fo:inline>
                                                                <xsl:text> from start date</xsl:text>
                                                            </fo:inline>
                                                        </fo:block>
                                                    </fo:table-cell>
                                                    <fo:table-cell bottom="0.00000in">
                                                        <fo:block padding-top="1pt" padding-bottom="1pt" />
                                                    </fo:table-cell>
                                                </fo:table-row>
                                                <fo:table-row font-size="8.5px" font-weight="normal">
                                                    <fo:table-cell bottom="0.00000in" height="0.14583in" number-columns-spanned="4">
                                                        <fo:block padding-top="1pt" padding-bottom="1pt" />
                                                    </fo:table-cell>
                                                </fo:table-row>
                                                <fo:table-row font-size="8.5px" font-weight="normal">
                                                    <fo:table-cell bottom="0.00000in" number-columns-spanned="3">
                                                        <fo:block padding-top="1pt" padding-bottom="1pt">
                                                            <fo:inline>
                                                                <xsl:text>Any questions? Please call </xsl:text>
                                                            </fo:inline>
                                                            <xsl:for-each select="$XML1">
                                                                <xsl:for-each select="root">
                                                                    <xsl:for-each select="QuoteHeader">
                                                                        <xsl:for-each select="Table">
                                                                            <xsl:for-each select="SRFName">
                                                                                <fo:inline>
                                                                                    <xsl:apply-templates>
                                                                                        <xsl:with-param name="maxwidth" select="$columnwidth17_0 + $columnwidth17_1 + $columnwidth17_2" />
                                                                                    </xsl:apply-templates>
                                                                                </fo:inline>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                            <fo:inline>
                                                                <xsl:text>&#160;</xsl:text>
                                                            </fo:inline>
                                                            <xsl:for-each select="$XML1">
                                                                <xsl:for-each select="root">
                                                                    <xsl:for-each select="QuoteHeader">
                                                                        <xsl:for-each select="Table">
                                                                            <xsl:for-each select="SRLName">
                                                                                <fo:inline>
                                                                                    <xsl:apply-templates>
                                                                                        <xsl:with-param name="maxwidth" select="$columnwidth17_0 + $columnwidth17_1 + $columnwidth17_2" />
                                                                                    </xsl:apply-templates>
                                                                                </fo:inline>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                            <fo:inline>
                                                                <xsl:text> at </xsl:text>
                                                            </fo:inline>
                                                            <xsl:for-each select="$XML1">
                                                                <xsl:for-each select="root">
                                                                    <xsl:for-each select="QuoteHeader">
                                                                        <xsl:for-each select="Table">
                                                                            <xsl:for-each select="SRPhoneNo">
                                                                                <fo:inline>
                                                                                    <xsl:apply-templates>
                                                                                        <xsl:with-param name="maxwidth" select="$columnwidth17_0 + $columnwidth17_1 + $columnwidth17_2" />
                                                                                    </xsl:apply-templates>
                                                                                </fo:inline>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                            <fo:inline>
                                                                <xsl:text>.</xsl:text>
                                                            </fo:inline>
                                                            <xsl:choose>
                                                                <xsl:when test="$XML1/root/QuoteHeader/Table/SRFaxNo !=&quot;&quot;">
																	<fo:inline>
                                                                        <xsl:text> Fax Number </xsl:text>
                                                                    </fo:inline>
                                                                    <xsl:for-each select="$XML1">
                                                                        <xsl:for-each select="root">
                                                                            <xsl:for-each select="QuoteHeader">
                                                                                <xsl:for-each select="Table">
                                                                                    <xsl:for-each select="SRFaxNo">
                                                                                        <fo:inline>
                                                                                            <xsl:apply-templates>
                                                                                                <xsl:with-param name="maxwidth" select="$columnwidth17_0 + $columnwidth17_1 + $columnwidth17_2" />
                                                                                            </xsl:apply-templates>
                                                                                        </fo:inline>
                                                                                    </xsl:for-each>
                                                                                </xsl:for-each>
                                                                            </xsl:for-each>
                                                                        </xsl:for-each>
                                                                    </xsl:for-each>
                                                                    <fo:inline>
                                                                        <xsl:text>.</xsl:text>
                                                                    </fo:inline>
                                                                </xsl:when>
                                                                <xsl:otherwise />
                                                            </xsl:choose>
                                                        </fo:block>
                                                    </fo:table-cell>
                                                    <fo:table-cell bottom="0.00000in" text-align="center">
                                                        <fo:block padding-top="1pt" padding-bottom="1pt" />
                                                    </fo:table-cell>
                                                </fo:table-row>
                                            </fo:table-body>
                                        </fo:table>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="tablewidth18" select="$maxwidth * 0.98000" />
                                <xsl:variable name="sumcolumnwidths18" select="0.000" />
                                <xsl:variable name="defaultcolumns18" select="1" />
                                <xsl:variable name="defaultcolumnwidth18">
                                    <xsl:choose>
                                        <xsl:when test="$defaultcolumns18 &gt; 0">
                                            <xsl:value-of select="($tablewidth18 - $sumcolumnwidths18) div $defaultcolumns18" />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="0.000" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="columnwidth18_0" select="$defaultcolumnwidth18" />
                                <fo:table width="{$tablewidth18}in" space-before.optimum="1pt" space-after.optimum="2pt" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.02083in" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
                                    <fo:table-column column-width="{$columnwidth18_0}in" />
                                    <fo:table-body>
                                        <fo:table-row font-size="10px">
                                            <fo:table-cell bottom="0.00000in" text-align="center">
                                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                                    <fo:inline>
                                                        <xsl:text>For any additional information, please call </xsl:text>
                                                    </fo:inline>
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="SRFName">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth18_0" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                    <fo:inline>
                                                        <xsl:text>&#160;</xsl:text>
                                                    </fo:inline>
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="SRLName">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth18_0" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                    <fo:inline>
                                                        <xsl:text> at </xsl:text>
                                                    </fo:inline>
                                                    <xsl:for-each select="$XML1">
                                                        <xsl:for-each select="root">
                                                            <xsl:for-each select="QuoteHeader">
                                                                <xsl:for-each select="Table">
                                                                    <xsl:for-each select="SRPhoneNo">
                                                                        <fo:inline>
                                                                            <xsl:apply-templates>
                                                                                <xsl:with-param name="maxwidth" select="$columnwidth18_0" />
                                                                            </xsl:apply-templates>
                                                                        </fo:inline>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </xsl:for-each>
                                                    <fo:inline>
                                                        <xsl:text>.</xsl:text>
                                                    </fo:inline>
                                                </fo:block>
                                            </fo:table-cell>
                                        </fo:table-row>
                                    </fo:table-body>
                                </fo:table>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:block>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>
</xsl:stylesheet>
