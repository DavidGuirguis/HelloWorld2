<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:output version="1.0" method="html" encoding="UTF-8" indent="no" />
  <xsl:variable name="XML1" select="/" />
  <xsl:variable name="fo:layout-master-set">
    <fo:layout-master-set>
      <fo:simple-page-master master-name="default-page" page-height="11in" page-width="8.5in" margin-left="0.6in" margin-right="0.6in">
        <fo:region-body margin-top="0.79in" margin-bottom="0.79in">
          <xsl:choose>
            <xsl:when test="$XML1/root/QuoteHeader/Table/bWatermark = 2">
              <xsl:attribute name="background-image">
                <xsl:value-of select="$XML1/root/QuoteHeader/Table/WatermarkUrl"/>
              </xsl:attribute>
            </xsl:when>
          </xsl:choose >
        </fo:region-body>
        <fo:region-after extent="10mm"/>
      </fo:simple-page-master>
      <fo:simple-page-master master-name="legalinfo-page" page-height="11in" page-width="8.5in" margin-left="0.6in" margin-right="0.6in">
        <fo:region-body margin-top="0.79in" margin-bottom="0.79in"/>
        <fo:region-after extent="10mm"/>
      </fo:simple-page-master>
    </fo:layout-master-set>
  </xsl:variable>

  <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="paraInternal" select="$XML1/root/Parameter/iInternal" />


  
  
  <xsl:template name="detailColumns">
    <xsl:param name="i" />
    <xsl:param name="count" />
    <xsl:param name="columnWidth" />
    <!--begin_: Line_by_Line_Output -->
    <xsl:if test="$i &lt;= $count">
      <fo:table-column column-width="{$columnWidth}in" />
    </xsl:if>

    <!--begin_: RepeatTheLoopUntilFinished-->
    <xsl:if test="$i &lt;= $count">
      <xsl:call-template name="detailColumns">
        <xsl:with-param name="i">
          <xsl:value-of select="$i + 1"/>
        </xsl:with-param>
        <xsl:with-param name="count">
          <xsl:value-of select="$count"/>
        </xsl:with-param>
        <xsl:with-param name="columnWidth">
          <xsl:value-of select="$columnWidth"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>

  </xsl:template>


  <xsl:template match="/">
    <xsl:variable name="maxwidth" select="7.30000" />

    <fo:root>
      <xsl:copy-of select="$fo:layout-master-set" />
      <fo:page-sequence master-reference="default-page" initial-page-number="1" format="1">
        <xsl:variable name="tablewidthFoot" select="$maxwidth * 0.98000" />
        <xsl:variable name="displayFooter" select="$XML1/root/QuoteFooter/DisplayFooter"></xsl:variable>
        <!-- Footer -->
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
                        <xsl:value-of select="root/QuoteHeader/Table/CustomerName" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell text-align="left">
                      <fo:block>
                        <xsl:value-of select="root/QuoteHeader/Table/QuoteNo" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell text-align="right">
                      <fo:block>
                        Page <fo:page-number/>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </fo:table-body>
              </fo:table>
            </fo:block>
          </fo:static-content>
        </xsl:if>
        <!-- //Footer -->

        <fo:flow flow-name="xsl-region-body">
          <fo:block>
            <fo:block>
              <fo:leader leader-pattern="space" />
            </fo:block>
            <xsl:variable name="tablewidth0" select="$maxwidth * 0.98000" />
            <xsl:variable name="defaultcolumns0" select="2" />
            <xsl:variable name="defaultcolumnwidth0" select="$tablewidth0 div $defaultcolumns0"/>
            <!-- LOGO -->
            <fo:table width="{$tablewidth0}in" space-before.optimum="1pt" space-after.optimum="2pt" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
              <fo:table-column column-width="{defaultcolumnwidth0}in" />
              <fo:table-column column-width="{defaultcolumnwidth0}in" />
              <fo:table-body>
                <xsl:variable name="logoAlign" select="root/QuoteHeader/logoAlign" />
                <fo:table-row text-align="{$logoAlign}">
                  <fo:table-cell bottom="0.00000in" height="0.01042in" number-columns-spanned="1">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:external-graphic>
                        <xsl:attribute name="src">
                          <xsl:value-of select="root/QuoteHeader/logoUrl" />
                        </xsl:attribute>
                      </fo:external-graphic>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" font-size="12px" font-weight="bold" text-align="right">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline text-decoration="underline">
                        <xsl:text>Quote No. </xsl:text>
                        <xsl:value-of select="root/QuoteHeader/Table/QuoteNo" />-
                        <xsl:value-of select="root/QuoteHeader/Table/Revision" />
                      </fo:inline>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
            <!-- //LOGO -->

            <!-- Customer Address Quote No -->
            <xsl:variable name="tablewidth3" select="$maxwidth * 0.98000" />
            <xsl:variable name="defaultcolumns3" select="6" />
            <xsl:variable name="defaultcolumnwidth3" select="$tablewidth3 div $defaultcolumns3"/>
            <fo:table width="{$tablewidth3}in" space-before.optimum="1pt" font-size="6px" space-after.optimum="2pt" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
              <fo:table-column column-width="{$defaultcolumnwidth3}in" />
              <fo:table-column column-width="{$defaultcolumnwidth3}in" />
              <fo:table-column column-width="{$defaultcolumnwidth3}in" />
              <fo:table-column column-width="{$defaultcolumnwidth3}in" />
              <fo:table-column column-width="{$defaultcolumnwidth3}in" />
              <fo:table-column column-width="{$defaultcolumnwidth3}in" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell bottom="0.00000in" number-columns-spanned="7" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline wrap-option="no-wrap">William Adams Pty. Ltd A.B.N 72 009 569 493 A.C.N. 009 569 493</fo:inline>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline wrap-option="no-wrap">HEAD OFFICE</fo:inline>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline></fo:inline>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline></fo:inline>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline wrap-option="no-wrap">VICTORIAN BRANCHES</fo:inline>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline wrap-option="no-wrap">Orbost: (03) 5154 3011</fo:inline>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline wrap-option="no-wrap">TASMANIAN BRANCHES</fo:inline>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline wrap-option="no-wrap">17 - 55 Nantilla Road</fo:inline>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline wrap-option="no-wrap">P.O. Box 164,</fo:inline>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline></fo:inline>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline wrap-option="no-wrap">Horsham: (03) 5382 0071</fo:inline>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline wrap-option="no-wrap">Swan Hill: (03) 5032 3332</fo:inline>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline wrap-option="no-wrap">Hobart: (03) 6249 0566</fo:inline>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline wrap-option="no-wrap">Clayton North, Victoria</fo:inline>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline wrap-option="no-wrap">Clayton Vic 3168</fo:inline>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline></fo:inline>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline wrap-option="no-wrap">Laverton: (03) 9931 9666</fo:inline>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline wrap-option="no-wrap">Traralgon: (03) 5175 6200</fo:inline>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline wrap-option="no-wrap">Launceston: (03) 6326 6366</fo:inline>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline wrap-option="no-wrap">Tel: (03) 9566 0666</fo:inline>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline wrap-option="no-wrap">Fax: (03) 9561 6273</fo:inline>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline></fo:inline>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline wrap-option="no-wrap">Mildura: (03) 5018 6100</fo:inline>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline wrap-option="no-wrap">Wodonga: (02) 6024 4744</fo:inline>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" display-align="before" text-align="left">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline wrap-option="no-wrap">Burnie: (03) 6433 8888</fo:inline>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
            <!-- //Customer Address Quote No -->

            <fo:block>
              <xsl:text>&#xA;</xsl:text>
            </fo:block>

            <!-- Quote Info -->
            <!-- Customer Name and address-->
            <xsl:variable name="tablewidth2" select="$maxwidth * 0.98000" />
            <fo:table width="{$tablewidth2}in" space-before.optimum="1pt" space-after.optimum="2pt" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
              <fo:table-column column-width="{$maxwidth}in" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell bottom="0.00000in" font-size="12px" font-weight="bold" display-align="before" text-align="left">
                    <fo:block padding-top="10pt" padding-bottom="1pt">
                      <xsl:value-of select="root/QuoteHeader/Table/CustomerName" />
                    </fo:block>
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:value-of select="root/QuoteHeader/Table/Address1" />
                    </fo:block>
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:value-of select="root/QuoteHeader/Table/Address2" />
                    </fo:block>
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:value-of select="root/QuoteHeader/Table/CityState" />
                    </fo:block>
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:value-of select="root/QuoteHeader/Table/ZipCode" />
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row >
              </fo:table-body >
            </fo:table >



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



            <xsl:variable name="columnwidth5_0" select="0.65417 * $factor5" />
            <xsl:variable name="columnwidth5_1" select="1.54167 * $factor5" />
            <xsl:variable name="columnwidth5_2" select="1.14583 * $factor5" />
            <xsl:variable name="columnwidth5_3" select="0.78332 * $factor5" />
            <xsl:variable name="columnwidth5_4" select="1.33333 * $factor5" />
            <fo:table width="{$tablewidth5}in" space-before.optimum="1pt" space-after.optimum="2pt" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
              <fo:table-column column-width="{$columnwidth5_0}in" />
              <fo:table-column column-width="{$columnwidth5_1}in" />
              <fo:table-column column-width="{$columnwidth5_2}in" />
              <fo:table-column column-width="{$columnwidth5_3}in" />
              <fo:table-column column-width="{$columnwidth5_4}in" />
              <fo:table-body>
                <fo:table-row font-size="7.5px" font-weight="bold" background-color="silver" text-align="center">
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      CUSTOMER NO.
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      CONTACT
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      PHONE NO.
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:value-of select="translate(root/QuoteHeader/Table/FaxLabel,$lcletters , $ucletters )" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-top-style="solid" border-top-color="black" border-top-width="0.01042in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      EMAIL
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <fo:table-row font-size="7.5px" font-weight="normal" text-align="center">
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:value-of select="root/QuoteHeader/Table/CustomerNo" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:value-of select="root/QuoteHeader/Table/ContactName" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:value-of select="root/QuoteHeader/Table/PhoneNo" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:value-of select="root/QuoteHeader/Table/FaxNo" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:value-of select="root/QuoteHeader/Table/Email" />
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <fo:table-row font-size="7.5px" font-weight="bold" background-color="silver" text-align="center">
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:value-of select="translate(root/QuoteHeader/headerText,$lcletters , $ucletters )" /> NO.
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      P.O. NO.
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      DATE
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" top="0.00000in" number-columns-spanned="2" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      WORK ORDER NO.
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <fo:table-row font-size="7.5px" font-weight="normal" text-align="center">
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:value-of select="root/QuoteHeader/Table/QuoteNo" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:value-of select="root/QuoteHeader/Table/PurchaseOrderNo" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:value-of select="root/QuoteHeader/Table/QuoteDate" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" top="0.00000in" number-columns-spanned="2" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:value-of select="root/QuoteHeader/Table/WorkOrderNo" />
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <fo:table-row font-size="7.5px" font-weight="bold" background-color="silver" text-align="center">
                  <!-- <CODE_TAG_100803> Ticket#7802-->
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      MAKE
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      MODEL
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt"  >
                      SERIAL NO.
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      UNIT NO.
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:value-of select="root/QuoteHeader/Table/SMUIndicatorDesc" />
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <fo:table-row font-size="8.5px" font-weight="normal" text-align="center">
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:value-of select="root/QuoteHeader/Table/Make" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:value-of select="root/QuoteHeader/Table/Model" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:value-of select="root/QuoteHeader/Table/SerialNo" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:value-of select="root/QuoteHeader/Table/UnitNo" />
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in" top="0.00000in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:value-of select="root/QuoteHeader/Table/SMU" />
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                
                <fo:table-row font-size="7.5px" font-weight="bold" background-color="silver" text-align="center">
                  <fo:table-cell bottom="0.00000in" top="0.00000in" number-columns-spanned="5" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      NOTES
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>

                <fo:table-row font-size="8.5px" font-weight="normal" text-align="left">
                  <fo:table-cell bottom="0.00000in" top="0.00000in" number-columns-spanned="5" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:for-each select="root/QuoteHeader/Table/ExternalNotes/Notes" >
                          <fo:block >
                              <xsl:apply-templates>
                              </xsl:apply-templates>
                          </fo:block >
                      </xsl:for-each >
                  </fo:block>
                  </fo:table-cell>
                </fo:table-row>

                <xsl:if test="$paraInternal=1">
                <fo:table-row font-size="7.5px" font-weight="bold" background-color="silver" text-align="center">
                  <fo:table-cell bottom="0.00000in" top="0.00000in" number-columns-spanned="5" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      SPECIAL INSTRUCTIONS
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                  <fo:table-row font-size="8.5px" font-weight="normal" text-align="left">
                    <fo:table-cell bottom="0.00000in" top="0.00000in"   number-columns-spanned="5" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in" border-left-style="solid" border-left-color="black" border-left-width="0.01042in" border-right-style="solid" border-right-color="black" border-right-width="0.01042in" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                      <fo:block padding-top="1pt" padding-bottom="1pt">
                        <xsl:for-each select="root/QuoteHeader/Table/InternalNotes/Notes" >
                          <fo:block >
                            <xsl:apply-templates>
                            </xsl:apply-templates>
                          </fo:block >
                        </xsl:for-each >
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>

                </xsl:if>
              </fo:table-body>
            </fo:table>
            <!-- //Quote Info -->

            <!-- Segment Info -->

            <!-- Configuration -->
            <xsl:variable name="SegmentDetailJobCodeDescShow" select="$XML1/root/Configuration/SegmentDetails/psQuote_Print_Segment_Detail_JobCodeDesc_Show"/>
            <xsl:variable name="SegmentDetailComponentCodeDescShow" select="$XML1/root/Configuration/SegmentDetails/psQuote_Print_Segment_Detail_ComponentCodeDesc_Show"/>
            <xsl:variable name="SegmentDetailExternalNotesShow" select="$XML1/root/Configuration/SegmentDetails/psQuote_Print_Segment_Detail_ExternalNotes_Show"/>
            <xsl:variable name="SegmentPartsDetailShow" select="$XML1/root/Configuration/SegmentDetails/psQuote_Print_Segment_Parts_Detail_Show"/>
            <xsl:variable name="SegmentLaborDetailShow" select="$XML1/root/Configuration/SegmentDetails/psQuote_Print_Segment_Labor_Detail_Show"/>
            <xsl:variable name="SegmentMiscDetailShow" select="$XML1/root/Configuration/SegmentDetails/psQuote_Print_Segment_Misc_Detail_Show"/>
            <xsl:variable name="SegmentJobCodeShow" select="$XML1/root/Configuration/SegmentDetails/psQuote_Print_Segment_JobCode_Show"/>
            <xsl:variable name="SegmentCompCodeShow" select="$XML1/root/Configuration/SegmentDetails/psQutoe_Print_Segment_CompCode_Show"/>
            <xsl:variable name="SegmentModCodeShow" select="$XML1/root/Configuration/SegmentDetails/psQutoe_Print_Segment_ModCode_Show"/>
            <xsl:variable name="SegmentJobLocCodeShow" select="$XML1/root/Configuration/SegmentDetails/psQutoe_Print_Segment_JobLocCode_Show"/>
            <xsl:variable name="SegmentQtyCodeShow" select="$XML1/root/Configuration/SegmentDetails/psQutoe_Print_Segment_QtyCode_Show"/>

            <xsl:variable name="SegmentTotalAmountShow" select="$XML1/root/Configuration/SegmentDetails/psQutoe_Print_Segment_TotalAmount_Show"/>
            <xsl:variable name="HideSegmentDetail" select="$XML1/root/QuoteHeader/Table/HideSegmentDetail"/>
            <xsl:variable name="SegmentExternalNotesShow" select="$XML1/root/Configuration/SegmentDetails/psQuote_Print_Segment_Detail_ExternalNotes_Show"/>



            <xsl:variable name="SegmentDetailPartsTotalColumns">
              <xsl:for-each select="$XML1/root/SegmentDetailColumns/Parts">
                <xsl:value-of select="@TotalColumns"/>
              </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="SegmentDetailLaborTotalColumns">
              <xsl:for-each select="$XML1/root/SegmentDetailColumns/Labor">
                <xsl:value-of select="@TotalColumns"/>
              </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="SegmentDetailMiscTotalColumns">
              <xsl:for-each select="$XML1/root/SegmentDetailColumns/Misc">
                <xsl:value-of select="@TotalColumns"/>
              </xsl:for-each>
            </xsl:variable>
            <!-- //Configuration -->

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
                        <xsl:if test="$HideSegmentDetail!=2">
                          <fo:table-row>
                            <fo:table-cell bottom="0.00000in" display-align="center" height="0.01042in" number-columns-spanned="4" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.02083in">
                              <fo:block padding-top="1pt" padding-bottom="1pt" />
                            </fo:table-cell>
                          </fo:table-row>
                        </xsl:if>
                        <fo:table-row display-align="before">
                          <fo:table-cell bottom="0.00000in" font-size="8.5px" font-weight="bold" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                            <fo:block padding-top="1pt" padding-bottom="1pt">
                              <fo:inline>
                                <xsl:text>SEGMENT:&#160; </xsl:text>
                              </fo:inline>
                              <xsl:value-of select="SegmentNo" />
                              <fo:inline>
                                <xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; </xsl:text>
                              </fo:inline>
                            </fo:block>
                          </fo:table-cell>
                          <fo:table-cell bottom="0.00000in" font-size="8.5px" number-columns-spanned="2" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                            <fo:block padding-top="1pt" padding-bottom="1pt">
                              <xsl:if test="$SegmentDetailJobCodeDescShow=2">
                                <xsl:value-of select="JobCodeDesc" />
                              </xsl:if>
                              <xsl:text>&#160;</xsl:text>
                              <xsl:if test="$SegmentDetailComponentCodeDescShow=2">
                                <xsl:value-of select="ComponentCodeDesc" />
                              </xsl:if>
                              <xsl:text>&#160;(&#160;</xsl:text>
                              <xsl:if test="$SegmentJobCodeShow=2">
                                <xsl:value-of select="JobCode" />
                                <xsl:text>&#160;</xsl:text>
                              </xsl:if>
                              <xsl:if test="$SegmentCompCodeShow=2">
                                <xsl:value-of select="ComponentCode" />
                                <xsl:text>&#160;</xsl:text>
                              </xsl:if>
                              <xsl:if test="$SegmentModCodeShow=2">
                                <xsl:value-of select="ModifierCode" />
                                <xsl:text>&#160;</xsl:text>
                              </xsl:if>
                              <xsl:if test="$SegmentJobLocCodeShow=2">
                                <xsl:value-of select="JobLocationCode" />
                                <xsl:text>&#160;</xsl:text>
                              </xsl:if>
                              <xsl:if test="$SegmentQtyCodeShow=2">
                                <xsl:value-of select="QuantityCode" />
                                <xsl:text>&#160;</xsl:text>
                              </xsl:if>
                              <xsl:text>)</xsl:text>


                            </fo:block>
                            <fo:block padding-top="1pt" padding-bottom="1pt">
                              <xsl:if test="$paraInternal=1">
                                <fo:block font-weight="bold"> &#160; </fo:block>
                                <fo:block font-weight="bold"> Notes: </fo:block>
                              </xsl:if> 
                              <xsl:if test="$SegmentExternalNotesShow=2">
                                 <xsl:for-each select="SegmentExternalNotes/Notes" >
                                   <fo:block >
                                     <xsl:apply-templates>
                                     </xsl:apply-templates>
                                   </fo:block >
                                 </xsl:for-each >
                              </xsl:if>
                            </fo:block>

                            <xsl:if test="$paraInternal=1">
                              <fo:block padding-top="1pt" padding-bottom="1pt">
                                <fo:block font-weight="bold"> &#160; </fo:block>
                              <fo:block font-weight="bold">  Special Instructions:  </fo:block>
                                <xsl:for-each select="SegmentInternalNotes/Notes" >
                                  <fo:block >
                                    <xsl:apply-templates>
                                    </xsl:apply-templates>
                                  </fo:block >
                                </xsl:for-each >
                              </fo:block>
                            </xsl:if>
                            
                          </fo:table-cell>
                          <xsl:if test="$HideSegmentDetail =2">
                            <fo:table-cell text-align="right" font-size="8.5px" font-weight="bold" >
                              <fo:block>
                                <xsl:if test="$SegmentTotalAmountShow =2">
                                  <xsl:value-of select="SegmentTotal" />
                                </xsl:if>
                              </fo:block>
                            </fo:table-cell>
                          </xsl:if>

                        </fo:table-row>

                        <xsl:if test="$HideSegmentDetail!=2">

                          <fo:table-row >
                            <fo:table-cell bottom="0.00000in" font-size="8.5px" font-weight="bold" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                              <fo:block padding-top="1pt" padding-bottom="1pt">
                                <xsl:text>Parts</xsl:text>
                              </fo:block>
                            </fo:table-cell>
                          </fo:table-row >
                          <fo:table-row>


                            <fo:table-cell bottom="0.00000in" number-columns-spanned="4" padding-left="20px">
                              <fo:block padding-top="1pt" padding-bottom="1pt" >

                                <xsl:variable name="partsColumnsCount" select="$XML1/root/Configuration/SegmentDetailColumns/Parts/@TotalColumns" />
                                <xsl:variable name="partsColumnWith" select="$maxwidth * 0.94 div $partsColumnsCount" />
                                <xsl:choose>
                                  <xsl:when test="$SegmentPartsDetailShow=2">
                                    <fo:table >
                                      <xsl:call-template name="detailColumns">
                                        <xsl:with-param name="i" select="1" />
                                        <xsl:with-param name="count" select="$partsColumnsCount" />
                                        <xsl:with-param name="columnWidth" select="$partsColumnWith" />
                                      </xsl:call-template>
                                      <fo:table-body>
                                        <fo:table-row>
                                          <xsl:for-each select="$XML1/root/Configuration/SegmentDetailColumns/Parts/Columns/Column" >
                                            <xsl:variable name="Colspan" select="./@Colspan" />
                                            <xsl:variable name="txtAlign" select="./@Align" />
                                            <fo:table-cell number-columns-spanned="{$Colspan}"  text-align="{$txtAlign}" font-size="8.5px" font-weight="bold">
                                              <fo:block >
                                                <xsl:value-of select="./@Name" />
                                              </fo:block >
                                            </fo:table-cell >
                                          </xsl:for-each >
                                        </fo:table-row>
                                        <xsl:for-each select="Parts/Detail" >
                                          <xsl:variable name="PartsDetailPosition" select="." />


                                          <xsl:variable name="Sos" select="Sos" />
                                          <xsl:variable name="PartNo" select="PartNo" />
                                          <xsl:variable name="Quantity" select="Quantity" />
                                          <xsl:variable name="Description" select="Description" />
                                          <xsl:variable name="UnitSellPrice" select="UnitSellPrice" />
                                          <xsl:variable name="UnitPrice" select="UnitPrice" />
                                          <xsl:variable name="Discount" select="Discount" />
                                          <xsl:variable name="ExtendedPrice" select="ExtendedPrice" />
                                          <xsl:variable name="IsCorePart" select="IsCorePart" />
                                          <fo:table-row>
                                            <xsl:for-each select="$XML1/root/Configuration/SegmentDetailColumns/Parts/Columns/Column" >
                                              <xsl:variable name="DataField" select="./@DataField" />
                                              <xsl:variable name="Colspan" select="./@Colspan" />
                                              <xsl:variable name="txtAlign" select="./@Align" />
                                              <!--number-columns-spanned="1"-->
                                              <fo:table-cell number-columns-spanned="{$Colspan}"  text-align="{$txtAlign}" font-size="8.5px">
                                                <fo:block >
                                                  <xsl:choose>
                                                    <xsl:when test="$DataField ='Sos'">
                                                      <xsl:value-of select="$Sos" />
                                                    </xsl:when>
                                                    <xsl:when test="$DataField ='ItemNo'">
                                                      <xsl:value-of select="$PartNo" />
                                                    </xsl:when>
                                                    <xsl:when test="$DataField ='Quantity'">
                                                      <xsl:value-of select="$Quantity" />
                                                    </xsl:when>
                                                    <xsl:when test="$DataField ='Description'">
                                                      <xsl:value-of select="$Description" />
                                                    </xsl:when>
                                                    <xsl:when test="$DataField ='UnitSellPrice'">
                                                      <xsl:value-of select="$UnitSellPrice" />
                                                    </xsl:when>
                                                    <xsl:when test="$DataField ='UnitPrice'">
                                                      <xsl:value-of select="$UnitPrice" />
                                                    </xsl:when>
                                                    <xsl:when test="$DataField ='Discount'">
                                                      <xsl:value-of select="$Discount" />
                                                    </xsl:when>
                                                    <xsl:when test="$DataField ='ExtendedPrice'">
                                                      <xsl:value-of select="$ExtendedPrice" />
                                                    </xsl:when>
                                                  </xsl:choose >
                                                </fo:block >
                                              </fo:table-cell >
                                            </xsl:for-each >
                                          </fo:table-row>
                                        </xsl:for-each >
                                      </fo:table-body >
                                    </fo:table >
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <fo:table>
                                      <fo:table-column column-width="{$maxwidth *0.94 * 0.5}in" />
                                      <fo:table-column column-width="{$maxwidth *0.94 * 0.5}in" />
                                      <fo:table-body>
                                        <fo:table-row>
                                          <fo:table-cell text-align="right" font-size="8.5px" font-weight="bold"  >
                                            <fo:block>
                                              Flat Rate Parts
                                            </fo:block>
                                          </fo:table-cell>
                                          <fo:table-cell text-align="right" font-size="8.5px" font-weight="bold" >
                                            <fo:block>
                                              <xsl:value-of select="PartsLockedTotal" />
                                            </fo:block>
                                          </fo:table-cell>
                                        </fo:table-row>
                                      </fo:table-body>
                                    </fo:table>
                                  </xsl:otherwise >
                                </xsl:choose>
                                <fo:table>
                                  <fo:table-column column-width="{$maxwidth *0.94 * 0.75}in" />
                                  <fo:table-column column-width="{$maxwidth *0.94 * 0.25}in" />
                                  <fo:table-body>
                                    <fo:table-row>
                                      <fo:table-cell text-align="right" font-size="8.5px" font-weight="bold" >
                                        <fo:block>
                                          Total Parts
                                        </fo:block>
                                      </fo:table-cell>
                                      <fo:table-cell text-align="right" font-size="8.5px" font-weight="bold" >
                                        <fo:block>
                                          <xsl:value-of select="PartsLockedTotal" />
                                        </fo:block>
                                      </fo:table-cell>
                                    </fo:table-row>

                                    <xsl:if test="PartsDiscountTotal  != 0.00">
                                      <fo:table-row>
                                        <fo:table-cell text-align="right" font-size="8.5px" font-weight="bold" >
                                          <fo:block>
                                            Less <xsl:value-of select="PartsDiscountPercent" />% - Parts
                                          </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell text-align="right" font-size="8.5px" font-weight="bold" >
                                          <fo:block>
                                            -<xsl:value-of select="PartsDiscountTotal" />
                                          </fo:block>
                                        </fo:table-cell>
                                      </fo:table-row>
                                    </xsl:if>


                                  </fo:table-body>
                                </fo:table>








                              </fo:block>
                            </fo:table-cell>


                          </fo:table-row>

                          <fo:table-row>
                            <fo:table-cell bottom="0.00000in" display-align="center" height="0.01042in" number-columns-spanned="4" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="1px">
                              <fo:block padding-top="1pt" padding-bottom="1pt" />
                            </fo:table-cell>
                          </fo:table-row>

                          <fo:table-row >
                            <fo:table-cell bottom="0.00000in" font-size="8.5px" font-weight="bold" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                              <fo:block padding-top="1pt" padding-bottom="1pt">
                                <xsl:text>Labor</xsl:text>
                              </fo:block>
                            </fo:table-cell>
                          </fo:table-row >
                          <fo:table-row>


                            <fo:table-cell bottom="0.00000in" number-columns-spanned="4" padding-left="20px">
                              <fo:block padding-top="1pt" padding-bottom="1pt" >
                                <xsl:variable name="laborColumnsCount" select="$XML1/root/Configuration/SegmentDetailColumns/Labor/@TotalColumns" />
                                <xsl:variable name="laborColumnWith" select="$maxwidth * 0.94 div $laborColumnsCount" />
                                <xsl:choose>
                                  <xsl:when test="$SegmentLaborDetailShow=2">
                                    <fo:table >
                                      <xsl:call-template name="detailColumns">
                                        <xsl:with-param name="i" select="1" />
                                        <xsl:with-param name="count" select="$laborColumnsCount" />
                                        <xsl:with-param name="columnWidth" select="$laborColumnWith" />
                                      </xsl:call-template>
                                      <fo:table-body>
                                        <fo:table-row>
                                          <xsl:for-each select="$XML1/root/Configuration/SegmentDetailColumns/Labor/Columns/Column" >
                                            <xsl:variable name="Colspan" select="./@Colspan" />
                                            <xsl:variable name="txtAlign" select="./@Align" />
                                            <fo:table-cell number-columns-spanned="{$Colspan}"  text-align="{$txtAlign}" font-size="8.5px" font-weight="bold">
                                              <fo:block >
                                                <xsl:value-of select="./@Name" />
                                              </fo:block >
                                            </fo:table-cell >
                                          </xsl:for-each >
                                        </fo:table-row>
                                        <xsl:for-each select="Labor/Detail" >
                                          <xsl:variable name="ItemNo" select="ItemNo" />
                                          <xsl:variable name="Quantity" select="Quantity" />
                                          <xsl:variable name="Description" select="Description" />
                                          <xsl:variable name="UnitPrice" select="UnitPrice" />
                                          <xsl:variable name="Discount" select="Discount" />
                                          <xsl:variable name="ExtendedPrice" select="ExtendedPrice" />
                                          <fo:table-row>
                                            <xsl:for-each select="$XML1/root/Configuration/SegmentDetailColumns/Labor/Columns/Column" >
                                              <xsl:variable name="DataField" select="./@DataField" />
                                              <xsl:variable name="Colspan" select="./@Colspan" />
                                              <xsl:variable name="txtAlign" select="./@Align" />
                                              <!--number-columns-spanned="1"-->
                                              <fo:table-cell number-columns-spanned="{$Colspan}"  text-align="{$txtAlign}" font-size="8.5px">
                                                <fo:block >
                                                  <xsl:choose>
                                                    <xsl:when test="$DataField ='ItemNo'">
                                                      <xsl:value-of select="$ItemNo" />
                                                    </xsl:when>
                                                    <xsl:when test="$DataField ='Quantity'">
                                                      <xsl:value-of select="$Quantity" />
                                                    </xsl:when>
                                                    <xsl:when test="$DataField ='Description'">
                                                      <xsl:value-of select="$Description" />
                                                    </xsl:when>
                                                    <xsl:when test="$DataField ='UnitPrice'">
                                                      <xsl:value-of select="$UnitPrice" />
                                                    </xsl:when>
                                                    <xsl:when test="$DataField ='Discount'">
                                                      <xsl:value-of select="$Discount" />
                                                    </xsl:when>
                                                    <xsl:when test="$DataField ='ExtendedPrice'">
                                                      <xsl:value-of select="$ExtendedPrice" />
                                                    </xsl:when>
                                                  </xsl:choose >
                                                </fo:block >
                                              </fo:table-cell >
                                            </xsl:for-each >
                                          </fo:table-row>
                                        </xsl:for-each >
                                      </fo:table-body >
                                    </fo:table >
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <fo:table>
                                      <fo:table-column column-width="{$maxwidth *0.94 * 0.5}in" />
                                      <fo:table-column column-width="{$maxwidth *0.94 * 0.5}in" />
                                      <fo:table-body>
                                        <fo:table-row>
                                          <fo:table-cell text-align="right" font-size="8.5px" font-weight="bold"  >
                                            <fo:block>
                                              Flat Rate Labor
                                            </fo:block>
                                          </fo:table-cell>
                                          <fo:table-cell text-align="right" font-size="8.5px" font-weight="bold"  >
                                            <fo:block>
                                              <xsl:value-of select="LaborLockedTotal" />
                                            </fo:block>
                                          </fo:table-cell>
                                        </fo:table-row>
                                      </fo:table-body>
                                    </fo:table>
                                  </xsl:otherwise >
                                </xsl:choose>
                                <fo:table>
                                  <fo:table-column column-width="{$maxwidth *0.94 * 0.75}in" />
                                  <fo:table-column column-width="{$maxwidth *0.94 * 0.25}in" />
                                  <fo:table-body>
                                    <fo:table-row>
                                      <fo:table-cell text-align="right" font-size="8.5px" font-weight="bold" >
                                        <fo:block>
                                          Total Labor
                                        </fo:block>
                                      </fo:table-cell>
                                      <fo:table-cell text-align="right" font-size="8.5px" font-weight="bold" >
                                        <fo:block>
                                          <xsl:value-of select="LaborLockedTotal" />
                                        </fo:block>
                                      </fo:table-cell>
                                    </fo:table-row>
                                  </fo:table-body>
                                </fo:table>


                              </fo:block>
                            </fo:table-cell>


                          </fo:table-row>
                          <fo:table-row>
                            <fo:table-cell bottom="0.00000in" display-align="center" height="0.01042in" number-columns-spanned="4" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="1px">
                              <fo:block padding-top="1pt" padding-bottom="1pt" />
                            </fo:table-cell>
                          </fo:table-row>

                          <fo:table-row >
                            <fo:table-cell bottom="0.00000in" font-size="8.5px" font-weight="bold" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                              <fo:block padding-top="1pt" padding-bottom="1pt">
                                <xsl:text>Misc</xsl:text>
                              </fo:block>
                            </fo:table-cell>
                          </fo:table-row >
                          <fo:table-row>


                            <fo:table-cell bottom="0.00000in" number-columns-spanned="4" padding-left="20px">
                              <fo:block padding-top="1pt" padding-bottom="1pt" >
                                <xsl:variable name="miscColumnsCount" select="$XML1/root/Configuration/SegmentDetailColumns/Misc/@TotalColumns" />
                                <xsl:variable name="miscColumnWith" select="$maxwidth * 0.94 div $miscColumnsCount" />
                                <xsl:choose>
                                  <xsl:when test="$SegmentMiscDetailShow=2">
                                    <fo:table >
                                      <xsl:call-template name="detailColumns">
                                        <xsl:with-param name="i" select="1" />
                                        <xsl:with-param name="count" select="$miscColumnsCount" />
                                        <xsl:with-param name="columnWidth" select="$miscColumnWith" />
                                      </xsl:call-template>
                                      <fo:table-body>
                                        <fo:table-row>
                                          <xsl:for-each select="$XML1/root/Configuration/SegmentDetailColumns/Misc/Columns/Column" >
                                            <xsl:variable name="Colspan" select="./@Colspan" />
                                            <xsl:variable name="txtAlign" select="./@Align" />
                                            <fo:table-cell number-columns-spanned="{$Colspan}"  text-align="{$txtAlign}" font-size="8.5px" font-weight="bold">
                                              <fo:block >
                                                <xsl:value-of select="./@Name" />
                                              </fo:block >
                                            </fo:table-cell >
                                          </xsl:for-each >
                                        </fo:table-row>
                                        <xsl:for-each select="Misc/Detail" >
                                          <xsl:variable name="ItemNo" select="ItemNo" />
                                          <xsl:variable name="Quantity" select="Quantity" />
                                          <xsl:variable name="Description" select="Description" />
                                          <xsl:variable name="UnitPrice" select="UnitPrice" />
                                          <xsl:variable name="Discount" select="Discount" />
                                          <xsl:variable name="ExtendedPrice" select="ExtendedPrice" />
                                          <fo:table-row>
                                            <xsl:for-each select="$XML1/root/Configuration/SegmentDetailColumns/Misc/Columns/Column" >
                                              <xsl:variable name="DataField" select="./@DataField" />
                                              <xsl:variable name="Colspan" select="./@Colspan" />
                                              <xsl:variable name="txtAlign" select="./@Align" />
                                              <!--number-columns-spanned="1"-->
                                              <fo:table-cell number-columns-spanned="{$Colspan}"  text-align="{$txtAlign}" font-size="8.5px">
                                                <fo:block >
                                                  <xsl:choose>
                                                    <xsl:when test="$DataField ='ItemNo'">
                                                      <xsl:value-of select="$ItemNo" />
                                                    </xsl:when>
                                                    <xsl:when test="$DataField ='Quantity'">
                                                      <xsl:value-of select="$Quantity" />
                                                    </xsl:when>
                                                    <xsl:when test="$DataField ='Description'">
                                                      <xsl:value-of select="$Description" />
                                                    </xsl:when>
                                                    <xsl:when test="$DataField ='UnitPrice'">
                                                      <xsl:value-of select="$UnitPrice" />
                                                    </xsl:when>
                                                    <xsl:when test="$DataField ='Discount'">
                                                      <xsl:value-of select="$Discount" />
                                                    </xsl:when>
                                                    <xsl:when test="$DataField ='ExtendedPrice'">
                                                      <xsl:value-of select="$ExtendedPrice" />
                                                    </xsl:when>
                                                  </xsl:choose >
                                                </fo:block >
                                              </fo:table-cell >
                                            </xsl:for-each >
                                          </fo:table-row>
                                        </xsl:for-each >
                                      </fo:table-body >
                                    </fo:table >
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <fo:table>
                                      <fo:table-column column-width="{$maxwidth *0.94 * 0.5}in" />
                                      <fo:table-column column-width="{$maxwidth *0.94 * 0.5}in" />
                                      <fo:table-body>
                                        <fo:table-row>
                                          <fo:table-cell text-align="right" font-size="8.5px" font-weight="bold"  >
                                            <fo:block>
                                              Flat Rate Misc
                                            </fo:block>
                                          </fo:table-cell>
                                          <fo:table-cell text-align="right" font-size="8.5px" font-weight="bold"  >
                                            <fo:block>
                                              <xsl:value-of select="MiscLockedTotal" />
                                            </fo:block>
                                          </fo:table-cell>
                                        </fo:table-row>
                                      </fo:table-body>
                                    </fo:table>
                                  </xsl:otherwise >
                                </xsl:choose>
                                <fo:table>
                                  <fo:table-column column-width="{$maxwidth *0.94 * 0.75}in" />
                                  <fo:table-column column-width="{$maxwidth *0.94 * 0.25}in" />
                                  <fo:table-body>
                                    <fo:table-row>
                                      <fo:table-cell text-align="right" font-size="8.5px" font-weight="bold" >
                                        <fo:block>
                                          Total Misc
                                        </fo:block>
                                      </fo:table-cell>
                                      <fo:table-cell text-align="right" font-size="8.5px" font-weight="bold" >
                                        <fo:block>
                                          <xsl:value-of select="MiscLockedTotal" />
                                        </fo:block>
                                      </fo:table-cell>
                                    </fo:table-row>
                                  </fo:table-body>
                                </fo:table>


                              </fo:block>
                            </fo:table-cell>


                          </fo:table-row>
                          <fo:table-row>
                            <fo:table-cell bottom="0.00000in" display-align="center" height="0.01042in" number-columns-spanned="4" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="1px">
                              <fo:block padding-top="1pt" padding-bottom="1pt" />
                            </fo:table-cell>
                          </fo:table-row>







                          <fo:table-row font-size="8.5px" font-weight="bold">
                            <fo:table-cell number-columns-spanned="4" text-align="right" padding-left="20px">
                              <fo:block padding-top="1pt" padding-bottom="1pt">

                                <fo:table>
                                  <fo:table-column column-width="{$maxwidth *0.94 * 0.75}in" />
                                  <fo:table-column column-width="{$maxwidth *0.94 * 0.25}in" />
                                  <fo:table-body>
                                    <fo:table-row>
                                      <fo:table-cell text-align="right" font-size="8.5px" font-weight="bold" >
                                        <fo:block>
                                          Segment&#160;&#160;
                                          <xsl:value-of select="SegmentNo" /> &#160;&#160;
                                          <xsl:if test="$SegmentTotalAmountShow =2">
                                            Total
                                          </xsl:if>
                                        </fo:block>
                                      </fo:table-cell>
                                      <fo:table-cell text-align="right" font-size="8.5px" font-weight="bold" >
                                        <fo:block>
                                          <xsl:if test="$SegmentTotalAmountShow =2">
                                            <xsl:value-of select="SegmentTotal" />
                                          </xsl:if>
                                        </fo:block>
                                      </fo:table-cell>
                                    </fo:table-row>
                                  </fo:table-body>
                                </fo:table>







                              </fo:block>
                            </fo:table-cell>
                          </fo:table-row>

                        </xsl:if >
                      </xsl:for-each>
                    </xsl:for-each>
                  </xsl:for-each>
                </xsl:for-each>
              </fo:table-body>
            </fo:table>

            <fo:table>
              <fo:table-column column-width="{$maxwidth *0.98 * 0.75}in" />
              <fo:table-column column-width="{$maxwidth *0.98 * 0.25}in" />
              <fo:table-body>
                <fo:table-row>
                  <fo:table-cell text-align="right" font-size="10px" font-weight="bold" >
                    <fo:block>
                      Total Segments

                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell text-align="right" font-size="8.5px" font-weight="bold" >
                    <fo:block>
                      <xsl:value-of select="$XML1/root/QuoteTotalByCustomer" />
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
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


            <fo:table width="{$tablewidth15}in" space-before.optimum="1pt" space-after.optimum="2pt" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
              <fo:table-column column-width="50%"/>
              <fo:table-column column-width="20%"/>
              <fo:table-column column-width="30%"/>
              <fo:table-body>
                <xsl:for-each select="$XML1">
                  <xsl:for-each select="root">
                    <xsl:for-each select="Financials">
                      <xsl:for-each select="Item">
                        <xsl:choose>
                          <xsl:when test="ItemId = ''">
                            <fo:table-row>
                              <fo:table-cell bottom="0.00000in" display-align="center" number-columns-spanned="4" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.01042in">
                                <fo:block />
                              </fo:table-cell>
                            </fo:table-row>
                          </xsl:when>
                        </xsl:choose>
                        <fo:table-row display-align="before">
                          <xsl:choose>
                            <xsl:when test="ItemId = ''">
                              <fo:table-cell bottom="0.00000in" font-size="8.5px" font-weight="bold" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                  <xsl:for-each select="ItemName">
                                    <fo:inline>
                                      <xsl:apply-templates>
                                        <xsl:with-param name="maxwidth" select="50%" />
                                      </xsl:apply-templates>
                                    </fo:inline>
                                  </xsl:for-each>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell bottom="0.00000in" font-size="8.5px" font-weight="bold" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                  <xsl:for-each select="Percent">
                                    <fo:inline>
                                      <xsl:apply-templates>
                                        <xsl:with-param name="maxwidth" select="20%" />
                                      </xsl:apply-templates>
                                    </fo:inline>
                                  </xsl:for-each>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell bottom="0.00000in" font-size="8.5px" text-align="right" font-weight="bold" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                  <xsl:for-each select="Amount">
                                    <fo:inline>
                                      <xsl:apply-templates>
                                        <xsl:with-param name="maxwidth" select="30%" />
                                      </xsl:apply-templates>
                                    </fo:inline>
                                  </xsl:for-each>
                                </fo:block>
                              </fo:table-cell>
                            </xsl:when>
                            <xsl:otherwise>
                              <fo:table-cell bottom="0.00000in" font-size="8.5px" number-columns-spanned="2" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                  <xsl:for-each select="ItemName">
                                    <fo:inline>
                                      <xsl:apply-templates>
                                        <xsl:with-param name="maxwidth" select="50%" />
                                      </xsl:apply-templates>
                                    </fo:inline>
                                  </xsl:for-each>
                                </fo:block>
                              </fo:table-cell>
                              <fo:table-cell bottom="0.00000in" font-size="8.5px" text-align="right" padding-top="0.00000in" padding-bottom="0.00000in" padding-left="0.00000in" padding-right="0.00000in">
                                <fo:block padding-top="1pt" padding-bottom="1pt">
                                  <xsl:for-each select="Amount">
                                    <fo:inline>
                                      <xsl:apply-templates>
                                        <xsl:with-param name="maxwidth" select="30%" />
                                      </xsl:apply-templates>
                                    </fo:inline>
                                  </xsl:for-each>
                                </fo:block>
                              </fo:table-cell>

                            </xsl:otherwise>
                          </xsl:choose>
                        </fo:table-row>
                      </xsl:for-each>
                    </xsl:for-each>
                  </xsl:for-each>
                </xsl:for-each>
              </fo:table-body>
            </fo:table>
            <!-- //Segment Info -->

            <!-- Term Condition -->
            <xsl:variable name="tablewidth_TermCond" select="$maxwidth * 0.98000" />
            <fo:table width="{$tablewidth_TermCond}in" font-style="italic" space-before.optimum="1pt" space-after.optimum="2pt" border-top-style="solid" border-top-color="black" border-top-width="0.02083in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.02083in" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black">
              <fo:table-column column-width="{$tablewidth_TermCond}in" />
              <fo:table-body>
                <fo:table-row font-size="8.5px" font-weight="normal" top="0.00000in" keep-with-next="always">
                  <fo:table-cell bottom="0.00000in" text-align="left" font-weight="bold" >
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <xsl:text>&#160;</xsl:text>
                      <xsl:for-each select="$XML1">
                        <xsl:for-each select="root">
                          <xsl:for-each select="TermCond">
                            <fo:block>
                              <xsl:text>- </xsl:text>
                              <xsl:apply-templates>
                                <xsl:with-param name="maxwidth" select="$tablewidth_TermCond" />
                              </xsl:apply-templates>
                            </fo:block >
                          </xsl:for-each>
                        </xsl:for-each>
                      </xsl:for-each>
                      <xsl:text>&#160;</xsl:text>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
            <!-- //Term Condition -->

            <!-- Sign Section -->
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
            <fo:table width="{$tablewidth16}in" space-before.optimum="1pt" space-after.optimum="2pt" border-top-color="black" border-top-width="0.02083in" border-bottom-style="solid" border-bottom-color="black" border-bottom-width="0.02083in" border-collapse="separate" bottom="0.00000in" top="0.00000in" color="black" display-align="center">
              <fo:table-column column-width="{$columnwidth16_0}in" />
              <fo:table-column column-width="{$columnwidth16_1}in" />
              <fo:table-column column-width="{$columnwidth16_2}in" />
              <fo:table-column column-width="{$columnwidth16_3}in" />
              <fo:table-body>
                <fo:table-row font-size="8.5px" font-weight="normal" font-style="italic" keep-with-next="always">
                  <fo:table-cell bottom="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt" font-weight="bold">
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
                  <fo:table-cell bottom="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt" font-weight="bold">
                      <fo:inline>
                        <xsl:text> from start date</xsl:text>
                      </fo:inline>
                    </fo:block>
                  </fo:table-cell>
                  <fo:table-cell bottom="0.00000in">
                    <fo:block padding-top="1pt" padding-bottom="1pt" />
                  </fo:table-cell>
                </fo:table-row>
                <fo:table-row font-size="8.5px" font-style="italic" font-weight="bold" keep-with-next="always">
                  <fo:table-cell bottom="0.00000in" number-columns-spanned="4">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline>
                        <xsl:text>&quot;The signature is an authorization to proceed with the required repair work as described within the quote&quot;.</xsl:text>
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
                <fo:table-row font-size="8.5px" font-style="italic" font-weight="bold" keep-with-next="always">
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
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <fo:table-row font-size="8.5px" font-style="italic" font-weight="bold" keep-with-next="always">
                  <fo:table-cell number-columns-spanned="4">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline>
                        <xsl:text>Date ____ / ____ / ________. </xsl:text>
                      </fo:inline>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <fo:table-row font-size="8.5px" font-weight="normal" keep-with-next="always">
                  <fo:table-cell bottom="0.00000in" number-columns-spanned="3">
                    <fo:block padding-top="1pt" padding-bottom="1pt">
                      <fo:inline>
                        <xsl:text>Any questions? Please call </xsl:text>
                      </fo:inline>
                     <!--Ticket 13410 <xsl:for-each select="$XML1">
                        <xsl:for-each select="root">
                          <xsl:for-each select="QuoteHeader">
                            <xsl:for-each select="Table">
                              <xsl:for-each select="CreatorFirstName">
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
                              <xsl:for-each select="CreatorLastName">
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
                      </fo:inline>-->

                      <xsl:comment>

                        <!-- Added Rep name before Fax -->

                      </xsl:comment>

                      <!--Ticket 13410 <xsl:for-each select="$XML1">
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
                      </xsl:for-each>-->

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
                        <!--Ticket 13410 -->
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
                        <xsl:text> at </xsl:text> <!--Ticket 13410 -->
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
            <!-- //Sign Section -->
          </fo:block>
        </fo:flow>
      </fo:page-sequence>

      <fo:page-sequence master-reference="legalinfo-page" initial-page-number="auto" format="1">
        <xsl:variable name="tablewidthFoot" select="$maxwidth * 0.98000" />
        <xsl:variable name="displayFooter" select="$XML1/root/QuoteFooter/DisplayFooter"></xsl:variable>
        <!-- Footer -->
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
                        <xsl:value-of select="root/QuoteHeader/Table/CustomerName" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell text-align="left">
                      <fo:block>
                        <xsl:value-of select="root/QuoteHeader/Table/QuoteNo" />
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell text-align="right">
                      <fo:block>
                        Page <fo:page-number/>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </fo:table-body>
              </fo:table>
            </fo:block>
          </fo:static-content>
        </xsl:if>
        <!-- //Footer -->

        <fo:flow flow-name="xsl-region-body">
          <fo:block>
            <fo:block>
              <fo:leader leader-pattern="space" />
            </fo:block>
            <xsl:variable name="tablewidth0" select="$maxwidth * 0.98000" />
            <xsl:variable name="defaultcolumns0" select="2" />
            <xsl:variable name="defaultcolumnwidth0" select="$tablewidth0 div $defaultcolumns0"/>

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



            <xsl:variable name="columnwidth5_0" select="0.65417 * $factor5" />
            <xsl:variable name="columnwidth5_1" select="1.54167 * $factor5" />
            <xsl:variable name="columnwidth5_2" select="1.14583 * $factor5" />
            <xsl:variable name="columnwidth5_3" select="0.78332 * $factor5" />
            <xsl:variable name="columnwidth5_4" select="1.33333 * $factor5" />


            <!-- Segment Info -->



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

            <!-- Policy -->
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
                <!--<fo:table-row>
			                        <fo:table-cell line-height="6pt" padding-bottom="1px" padding-top="2px" border-style="solid" border-width="0pt" border-color="white" padding-start="0pt" padding-end="0pt" padding-before="0pt" padding-after="0pt" text-align="center" display-align="center">
				                        <fo:block>
					                        <fo:block padding-top="2px" break-before="page">
						                        <fo:block>							
						                        </fo:block>
					                        </fo:block>
				                        </fo:block>
			                        </fo:table-cell>
		                        </fo:table-row>-->
                <fo:table-row font-size="6.0px" font-weight="normal" top="0.00000in">
                  <fo:table-cell bottom="0.00000in" text-align="justify" number-columns-spanned="4">
                    <fo:block padding-top="0pt" padding-bottom="0pt">
                      <fo:block font-size="7.5px" padding-top="1pt" padding-bottom="1pt" font-family="helvetica" font-weight="bold" text-align="center">
                        <fo:inline>
                          <xsl:text>PARTS RETURN POLICY</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>1. All normally stocked parts returned for credit up to seven (7) days from invoice will be subject to 5% handling fee. Parts returned within eight (8) to twenty eight(28) days of invoice will be subject to a 10% handling and stocking fee. Parts returned after twenty eight(28) days from invoice will not be accepted for credit.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>2.  NON STOCKED parts specifically ordered to meet customer requirements will not be accepted for credit.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>3.  Parts must be undamaged and returned in original and undamaged packaging</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>4.  Parts must not have been fitted or otherwise used.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>5.  All Batteries, Ball and Roller Bearings, Cups, Cones, Seals, Seal Kits, Gaskets, Gasket Kits, Cat Oils and Fluids in containers, Hoses and items specifically made
							            or cut to specifications are strictly NON RETURNABLE.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>6.  It is mandatory that a copy of our original invoice or Shipping List accompany goods.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>7.  Freight costs involved with credit returns are the Customer's responsibility.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>8.  It is the Customer's responsibility to arrange insurance cover for goods during return transportation, should this be desired.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>9.  Credit requests with a total value of less than $20.00 will not be accepted.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>10. Remanufactured and Service Exchange parts require that the core component be returned to William Adams.  If the core for a Remanufactured or Service
							            Exchange part is returned within 14 days from invoice the core credit will be refunded in full.  Between 15 and 28 days, 50 percent of the core charges only will be
							            refunded.  Cores returned after 28 days from invoice will not be accepted and no refund will be made.  (Remanufactured parts for T.E.P.S. dealers stock will be
							            excepted from this clause).
									            </xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block>
                        <fo:leader leader-pattern="space" />
                      </fo:block>
                      <fo:block font-size="7.5px" padding-top="1pt" padding-bottom="1pt" font-family="helvetica" font-weight="bold" text-align="center">
                        <fo:inline>
                          <xsl:text>CONDITIONS OF QUOTATION AND SALE</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify" >
                        <fo:inline>
                          <xsl:text>1.  Every quotation is subject to withdrawal at any time before acceptance by the Company and no order is to be deemed to have been accepted by the Company
							            until formal acceptance is posted or delivered.  All prices quoted for Parts are current at today's date but are subject to change without notice and prices in effect
							            at date of delivery will be invoiced.  The Company will nevertheless endeavour to supply in accordance with prices and conditions of the quotation.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>2.  Where parts are quoted for delivery "ex stock" such parts are subject to prior sale.  Where delivery other than "ex stock" is shown parts will so far as the Company
							            can ascertain be available at that time but such parts are subject to allocation to other customers should firm orders be received prior to any other resulting from
							            this quotation.  Parts can only be allocated to a customer upon notification of a firm order.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>3.  Prices quoted do not include delivery and delivery shall be made to the customer 'ex warehouse'.  In the event that the customer requests the company to arrange
							            transportation of the goods sold then the cost of transportation will be charged to the customer separately.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>4.  If by reason of any cause whatsoever beyond the control of the Company, the Company is unable or prevented from providing service or delivery at the time
							            stipulated the Company shall be entitled to determine the contract and the customer shall not in consequence have any claims for damages but without prejudice
							            to the rights of payments made or expenses incurred by the Company in connection with the contract.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>5.  Except as provided in Clause 4 hereof after an order has been accepted by the Company such order shall not be subject to cancellation without the written
							            consent of both parties.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>6.  The liability of the Company for damages arising out of this Contract  shall (subject to other limitations herein contained) be limited to the costs of rectification of
							            any faulty workmanship or replacement of any defective part and the Company accepts no other responsibility or liability whatsoever including liability for
							            negligence or any liability for consequential loss however arising. All conditions and warranties contained in or implied by any statute or rule of law are hereby
							            expressly excluded and negated provided that nothing in this Contract shall exclude, restrict or modify any condition warranty or liability which may at the time
							            be implied in the Contract where to do so is illegal or would render any provision of this Contract void.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>7.  In cases where the Company accepts responsibility for delivery by rail, ship, aircraft or other vehicle, the customer will be responsible for immediate examination
							            of goods after arrival at destination and in the event of any goods arriving in a damaged condition must report the matter in writing to the Company.  No claim
							            for goods damaged in transit will be entertained unless made within three (3) days after arrival at destination.  Unless expressly agreed, the responsibility of the
							            Company ceases on goods being delivered to transportation company or depot.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>8.  Insurance has not been included in the quotation.  In the absence of specific instructions to the contrary, the Company may insure the goods against marine war
							            risk (insofar as cover can be obtained) and the cost of such insurance will be charged to the customers account.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>9.  All plant manufactured by the Company is warranted for 180 days after date of despatch.  This warranty is limited to the replacement F.O.R/F.O.B.  Capital City
							            of such parts as shall have been returned to the Company, all charges prepaid, and which upon inspection appear to the Company to have been defective in
							            material and/or workmanship.  No warranty is made or authorised to be made other than that herein set forth and no warranty is given by the Company in respect
							            of plant and materials not of its manufacture, or to trade accessories, such being subject to the warranty of their respective makers.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>10. Should work of any kind be carried out by the Company on the customer's or any other premises the Company shall not be liable for any loss or damage
							            occasioned to the customer or any contractor or any of their employees or agents arising from any cause connected in any way with such work.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>11. Prices are subject to customer's order being for the whole amount mentioned in the quotation.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>12. Prices quoted for labour are firm for 30 days.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>13. Subject to this contract, repairs carried out are warranted against faulty workmanship for a period of 90 days from completion of repair.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>14. The Company shall be entitled to charge reasonable storage charges if delivery of the plant, machines or other property is not taken within two (2) days after
							            notice is given by the Company that the work has been completed.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>15. The Company shall not be responsible for any damage of any kind whatsoever to plant, machines and/or other property whilst the same is in the possession of
							            or under the control of the Company.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>16. The Company shall not be responsible for securely placing on transport any property owned by the Customer.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>17. The Company, its servants and agents are hereby authorised to use,  operate and drive the plant machines or other property for the purpose of testing and/or
							            inspection and the provision of services. The customer warrants that it has full right and title in any assets provided to the Company for the provision of
							            services and grants the Company a lien over the assets as security for payment for such services.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>18. In the event that the Australian Taxation Office does not accept the conditional sales tax exemption or certificate number by the purchaser the company will be
							            indemnified for any sales tax payable.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>19. Ownership in any goods hereby sold shall not pass to the customer until all monies owing under this contract and in respect of all other goods supplied by the
							            Company to the customer and all debts owing by the customer to the Company have been paid in full.  The customer agrees that goods will be dealt with at all
							            times on a "first in first out" basis and acknowledges that a certificate signed by an officer of the Company identifying goods as unpaid for shall be conclusive
							            evidence that the goods have not been paid for and of the Company's title thereto. No parts shall be fitted or used until fully paid for.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>20. Until monies due for all goods supplied are paid for in full the customer will act in a fiduciary capacity to the Company. The customer shall unless the Company
							            otherwise agreed in writing store the goods so that they are clearly identified as property of the Company.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>21. Risk in any goods hereby sold shall pass to the customer upon delivery notwithstanding that ownership may not have been passed.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>22. The customer agrees that the Company may give to and seek from any credit providers that may be named in a credit report issued by a credit reporting agency
							            information about the customer's credit arrangements. The customer understands that this information can include any information about the customers credit
							            worthiness, credit standing, credit history or credit capacity that credit providers are allowed to give or receive from each other under the Privacy Act.
							            The customer understands the information may be used for the following purposes:
							            *   to assess an application by the Applicant for credit.
							            *   to notify other credit providers of a default by the customer.
							            *  to exchange information with other credit providers as to the status of the credit  agreement where the customer is in default with other credit  providers.
							            *  to assess the credit worthiness of the customer.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>23. The terms of payment for parts and service sales are 30 days nett from end of month of purchase, unless otherwise agreed.  The customer agrees to pay interest
							            on all monies outstanding after the expiration of 30 days from the end  of month of purchase.  The rate of interest charged will be one per centum per annum
							            greater than the authorised Westpac Bankcard interest rate. This clause  does not apply if the goods supplied were supplied to an individual predominantly for
							            personal domestic or household purposes.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>24. Anything to the contrary notwithstanding the terms and conditions contained herein shall be the only conditions upon which the Company sells the goods and
							            undertakes the work herein described. No terms and conditions stated by the customer in accepting or acknowledging this invoice shall be binding upon the
							            Company unless accepted in writing by the Company.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>25. This quotation, order and contract shall be governed by and construed according to the laws of Victoria.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>26. (i) The customer shall pay all government duties imposts GST and other indirect taxes in respect of the goods sold or services provided.
							            (ii) 'GST' means GST within the meaning of the A New System (Goods and Services Tax) Act 1999 as ammended from time to time.
							            (iii) Unless specifically stated otherwise all amounts expressed or described are GST exclusive amounts.
							            (iv) If any GST is payable by the Company in respect of the supply of goods or the provision of services to the customer then the amount expressed or decribed
							            herein ('Original Amount') is to be increased so that the Company receives an amount ('Increased Amount') which, after subtracting the GST liability of the
							            of the Company on that Increased Amount, results in the Company retaining the Original Amount after payment of that GST liability.
							            (v)  The Company will do all things reasonably available to it (including issuing tax invoices) to assist the customer to claim input credits (if any) in respect
							            of the supply of the goods and services.</xsl:text>
                        </fo:inline>
                      </fo:block>
                      <fo:block padding-top="1pt" padding-bottom="1pt"  text-align="justify">
                        <fo:inline>
                          <xsl:text>27. The Company does not warrant that the goods are Year 2000 compliant. The customer accepts the responsibility for ensuring that the goods are Year 2000
							            compliant. For the purpose of this clause "Year 2000 compliant" means that neither the performance nor the functionality of the goods will be affected by the
							            dates prior to, during or after the Year 2000 and are compatible with related products with which these goods need to complete the function involving the recording
							            of an interval of time.</xsl:text>
                        </fo:inline>
                      </fo:block>
                    </fo:block>
                    <!--<fo:block>
					                        <xsl:text>&#xA;</xsl:text>
				                        </fo:block>-->
                  </fo:table-cell>
                </fo:table-row>
                <!--<fo:table-row font-size="8.5px" font-weight="normal" top="0.00000in" font-style="italic">
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
		                        </fo:table-row>-->
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
              </fo:table-body>
            </fo:table>
            <!-- //Policy -->
          </fo:block>
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>




</xsl:stylesheet>
