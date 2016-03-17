<?xml version="1.0" encoding="ISO-8859-1" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:user="urn:www-toromont-com:slrequest"
                version="1.0">
	<xsl:output  method="html" version="4.0" encoding="ISO-8859-1" />
	<msxsl:script language="JScript" implements-prefix="user">
      <![CDATA[
		var iRow=0;
		var iGroup=0;
		var sPrevGroupName="";
		var sGroupName = "";
	
		function getRowBGColor() {
			if(iRow++ % 2 == 0)
				return "rl";
			else
				return "rd";
		}

		function getGroupBGColor(nList) {
      var nodeName = "";
      while (nList.MoveNext())
      {
         if (nodeName == "")
             nodeName =  nList.Current.Name;
      }
			//Reason
			if(nodeName=="Body") nodeName = "Reason";
						
			sGroupName	= "";
			if(nodeName != sPrevGroupName){
				iGroup++;
				sPrevGroupName = nodeName;
				sGroupName = sPrevGroupName;
			}
			
			if(iGroup % 2 == 0)
				return "rd";

			else
				return "rl";
		}
		function getGroupBGColor_Old(nodeList) {
			var node = nodeList.item(0);
			var nodeName = node.nodeName;
						
			//Reason
			if(nodeName=="Body") nodeName = "Reason";
						
			sGroupName	= "";
			if(nodeName != sPrevGroupName){
				iGroup++;
				sPrevGroupName = nodeName;
				sGroupName = sPrevGroupName;
			}
			
			if(iGroup % 2 == 0)
				return "rd";

			else
				return "rl";
		}

		function getGroupName() {
			return sGroupName;
		}
		function getGroupRSName(rsd) {
      var rt = "";
			while (rsd.MoveNext())
      {
         var rsList = rsd.Current.SelectChildren(XPathNodeType.All);
         while(rsList.MoveNext())
         {
            if (sGroupName.ToUpper() == rsList.Current.Name.ToUpper())
               rt =  rsList.Current.Value;
         }
      }
      
      return rt;
		}
    
]]></msxsl:script>
   <!-- [Dealer Changes: 102224-<2006-09-01:JFu>]:Carolina Cat Sales Link Implementation: Customer Info - Physical Location". -->
   <xsl:variable name="vTypeID" select="//Header/TypeId"></xsl:variable>

	<xsl:template match="/">
		
			  <div style="padding:5px;width:100%;">
				<table  width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr>
						<td class="tb" width="125">
              <xsl:value-of select="//Header/RM/Header/RsFrom"/>
            </td>
						<td class="t"><xsl:value-of select="//Header/First_Name"/><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="//Header/Last_Name"/></td>
					</tr>
					<tr>
						<td class="tb">
              <xsl:value-of select="//Header/RM/Header/RsDate"/>
            </td>
						<td class="t"><xsl:value-of select="concat(substring-before(//Header/Date_Time,'T'),' ',substring-after(//Header/Date_Time,'T'))"/></td>
					</tr>
					<tr>
						<td class="tb">
              <xsl:value-of select="//Header/RM/Header/RsCustomer"/>
            </td>
						<td class="t">
							<xsl:choose>
								<xsl:when test="normalize-space(//Header/Customer_Name) = ''">
									<xsl:value-of select="//Header/Customer_Number" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="normalize-space(//Header/Customer_Number) = ''">
											<xsl:value-of select="//Header/Customer_Name" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="//Header/Customer_Name" /><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>(<xsl:value-of select="//Header/Customer_Number" />)
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
					<tr>
						<td class="tb">
              <xsl:value-of select="//Header/RM/Header/RsDivision"/>
            </td>
						<td class="t"><xsl:value-of select="//Header/Division"/></td>
					</tr>
				<xsl:for-each select="//Header/*[name() = 'Influencer_Name' or name() = 'Serial_Number' or name() = 'Equip_Manuf_Code']">
					<tr>
						<td class="tb">
							<xsl:call-template name="strip">
								<xsl:with-param name="name">
									<xsl:value-of select="name()" />
								</xsl:with-param>
							</xsl:call-template>:
						</td>
						<td class="t">
							<xsl:value-of select="."/>
						</td>
					</tr>
				</xsl:for-each>
					<tr>
						<td class="tb">
              <xsl:value-of select="//Header/RM/Header/RsType"/>
            </td>
						<td class="t"><xsl:value-of select="//Header/Type" /></td>
					</tr>
          
          <!-- <CODE_TAG_100616> 9/21/2010 yhua-->
          <tr>
              <xsl:choose>
                <xsl:when test="string-length(normalize-space(//Header/Sender_Note)) = 0">
                </xsl:when>
                <xsl:otherwise>
                  <td class="tb">
                    <xsl:value-of select="//Header/RM/Header/RsSendersNote"/>
                  </td>
                  <td class="t" width="360">
                     <xsl:call-template name="ShowingNote">
                       <xsl:with-param name="note" select="//Header/Sender_Note" />
                     </xsl:call-template>
                  </td>
                </xsl:otherwise>
              </xsl:choose>            
          </tr>
          <tr>
            <td colspan="2" height="5"></td>
          </tr>
          <!-- </CODE_TAG_100616>-->
        </table>
        <table class="tbl" width="100%" cellpadding="2" cellspacing="0" border="0">
					<!-- request details	-->
					
					<tr>
						<td colspan="2" id="rshl" class="thc" >
              <xsl:value-of select="//Header/RM/Header/RsRequest"/>
            </td>
					</tr>
					
					<xsl:apply-templates select="Request/Header/following-sibling::*" />
					
				</table>
			  </div>			
	</xsl:template>
  
	<xsl:template match="Header">
		<xsl:for-each select="*">
			<xsl:if test="name() != 'Type' and name() != 'TypeId'">
				<tr valign="top">
					<td class="tb" width="125">
						<xsl:call-template name="strip">
							<xsl:with-param name="name">
								<xsl:value-of select="name()" />
							</xsl:with-param>
						</xsl:call-template>:
				</td>
					<td class="t">
						<xsl:choose>
							<xsl:when test="name()='Date_Time'">
								<xsl:value-of select="concat(substring-before(.,'T'),' ',substring-after(.,'T'))" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="." />
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
  
	<!-- request details -->
	<xsl:template match="*">
		<!-- [Dealer Changes: 102224-<2006-09-01:JFu>]:Carolina Cat Sales Link Implementation: Customer Info - Physical Location". -->
		<xsl:if test="$vTypeID = 10">
			<xsl:if test="name()='Address'">
			<tr>
				<td colspan="2" class="rl" style="background-color:#aaa; color:white; font-weight:bold;border-left:1px solid black;border-right:1px solid black;">
				<xsl:choose>
					<xsl:when test="@Description !=''">
						<xsl:value-of select="@Description" />
					</xsl:when> 
					<xsl:otherwise>
            <xsl:value-of select="//Header/RM/Header/RsBillingAddress"/>
					</xsl:otherwise>
				</xsl:choose> 
				</td>
			</tr>			
			</xsl:if>
			<xsl:if test="name()='Customer'">
				<tr>
					<td width="100%" colspan="2" class="rl" style="background-color:#aaa; color:white; font-weight:bold;border-left:1px solid black;border-right:1px solid black;" height="2"></td>
				</tr>  
			</xsl:if>
		</xsl:if>
		<!-- end of [Dealer Changes: 102224-<2006-09-01:JFu>]:Carolina Cat Sales Link Implementation: Customer Info - Physical Location". -->
		<xsl:for-each select="*">
			<xsl:sort select="name()"/>
			
			<tr valign="top">
				<td class="tb" ><xsl:attribute name="class"><xsl:value-of select="user:getGroupBGColor(.)"/></xsl:attribute>
					<xsl:if test="user:getGroupName()!=''">
						<xsl:call-template name="strip">
							<xsl:with-param name="name">
								<xsl:value-of select="user:getGroupRSName(//Header/RM/Detail)" />
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
				</td>
				<td class="t" ><xsl:attribute name="class"><xsl:value-of select="user:getRowBGColor()"/></xsl:attribute>
					<xsl:choose>
						<xsl:when test="name()='Purchase_Date'">
							<xsl:value-of select="." />				<!-- AZ: September 4, 2007 => just this line got changed -->
						</xsl:when>

						<xsl:when test="user:getGroupName()='ExtraDetail'">
							<xsl:call-template name="ExtraDetails">
								<xsl:with-param name="name">
									<xsl:value-of select="name()" />
								</xsl:with-param>
							</xsl:call-template>						
						</xsl:when>

						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="name()='Add_Code' or name()='Delete_Code'">
									<xsl:value-of select="concat(@Description,' - ',@Code)" /><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="." />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>
	
	<!-- strip underscope -->
	<xsl:template name="strip">
		<xsl:param name="name" />
		<xsl:choose>
			<xsl:when test="substring-before($name,'_')=''">
				<xsl:value-of select="$name" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(substring-before($name,'_'),' ')" />
				<xsl:call-template name="strip">
					<xsl:with-param name="name">
						<xsl:value-of select="substring-after($name,'_')" />
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Extra Details -->
	<xsl:template name="ExtraDetails">
		<xsl:param name="name" />
		<table>
		<xsl:for-each select="*">
			<xsl:sort select="name()"/>
			<tr>
			<td  class="tb">
				<xsl:attribute name="class"><xsl:value-of select="user:getGroupBGColor(.)"/></xsl:attribute>
				<xsl:call-template name="strip">
					<xsl:with-param name="name">
						<xsl:value-of select="concat(@TypeDesc,' ( ',@TypeCode,' )')" />
					</xsl:with-param>
				</xsl:call-template>:
			</td>
			<td>
				<xsl:attribute name="class"><xsl:value-of select="user:getGroupBGColor(.)"/></xsl:attribute>
				<xsl:value-of select="." />
			</td>	
			</tr>		
		</xsl:for-each>
		</table>
	</xsl:template>
  
  <!-- <CODE_TAG_100616> 9/21/2010 yhua-->
  <!-- Convert Carrige Return-->
  <xsl:template name="ShowingNote">
    <xsl:param name="note" select="." />
    <xsl:choose>
      <xsl:when test="contains($note,'&#013;')">
        <xsl:value-of select="substring-before($note,'&#013;')" disable-output-escaping="yes"/>
        <br />
        <xsl:call-template name="ShowingNote">
           <xsl:with-param name="note" select="substring-after($note,'&#013;')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$note" disable-output-escaping="yes"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- </CODE_TAG_100616>-->

</xsl:stylesheet>