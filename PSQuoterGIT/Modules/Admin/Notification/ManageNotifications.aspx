<%@ Page Title="" Language="C#" MasterPageFile="~/Library/MasterPages/_base.master"
    AutoEventWireup="true" CodeFile="ManageNotifications.aspx.cs" Inherits="ManageNotifications" %>

<asp:Content ID="Content5" ContentPlaceHolderID="cntMP" runat="Server">

	<table id="tblDataList" class="tbl" style="width: 100%" cellspacing="1" cellpadding="2" border="0">
		<thead>
			<tr class="thc">
				<td rowspan="2">Recipient</td>
				<td rowspan="2">Event</td>
				<td rowspan="2">Comments</td>
				<td rowspan="2">Changed By</td>

				<td colspan="4" class="tAc">Criteria</td>
				<td colspan="1" class="tAc">Notification Settings</td>

				<td rowspan="2" class="tAc"><input disable-on-ajax="" id="btnAdd" type="button" data-Add="" value="Add" class="ui-button ui-widget ui-state-default ui-corner-all"/></td>
			</tr>
			<tr class="thc">
				<td>Quote Type</td>
				<%--<td>Status changed to</td>--%>
				<td>Branch</td>
				<td>Division</td>
				<td>Commodity</td>

				<td>Addr. Field</td>
				<td style="display:none">Subject</td>
				<td style="display:none">Body</td>
			</tr>
		</thead>
		<tbody>
			<tr id="trTempDataRow" style="display:none;" data-settingid="">
				<td>
					<span hide-on-edit="" id="spnRecipientView" name="spnRecipientView" nowrap>
					</span>
					<select show-on-edit="" disable-on-ajax="" id="drpRecipientType" name="drpRecipientType" style="display:none" data-value="">
						<option value=""></option>
						<% foreach (var item in objNotification.listRecipientType){%>
							<option value="<%=item.RecipientTypeId%>" data-showtextarea="<%=item.ShowTextArea%>" data-showusersearch="<%=item.ShowUserSearch%>"><%=item.RecipientTypeName%></option>
						<%}%>
					</select><br>
					<div show-on-edit="" id="divNewTeamMember" style="margin-bottom: 10px;display:none;">
						<form id="frmNewTeamMember" method="post">
							<span id="spnRecipient" name="spnRecipient"></span>
							<input type="hidden" data-required="true" value="" id="RecipientXUId" name="RecipientXUId" />
							<%= Helpers.HtmlHelper.RecipientFinder("Find Recipient", "spnRecipient", "RecipientXUId", "Find Recipient", "Remove Recipient" , useIFrameDialog: true)%>
						</form>
					</div>
					<input show-on-edit="" style="display:none;width:94%" disable-on-ajax="" id="txtRecipientDistributionList" name="txtRecipientDistributionList" type="text" value="" data-value=""/>
				</td>
				<td>
					<span hide-on-edit="" id="spnEvent" name="spnEvent"></span>
					<select show-on-edit="" disable-on-ajax="" id="drpEvent" name="drpEvent" style="display:none;" data-value="">
						<option value=""></option>
						<% foreach (var item in objNotification.listEvent){%>
							<option value="<%=item.EventId%>" data-subject="<%=item.EmailSubject%>" data-body="<%=item.EmailBody%>"><%=item.EventName%></option>
						<%}%>
					</select>
				</td>
				<td>
					<span hide-on-edit="" id="spnComment" name="spnComment"></span>
					<input show-on-edit="" disable-on-ajax=""id="txtComment" name="txtComment" type="text" style="display:none; width:94%" value="" data-value=""/>
				</td>
				<td>
					<span id="spnChangedBy" name="spnChangedBy" nowrap></span>
				</td>
				<td>					
					<span hide-on-edit="" id="spnQuoteType" name="spnQuoteType"></span>
					<span show-on-edit="" id="spnChkQuoteType" name="spnChkQuoteType" style="display:none;" data-value="">
						<% foreach (var item in objNotification.listQuoteType){%>
							<span nowrap><input type="checkbox" disable-on-ajax="" id="chkQuoteType" name="chkQuoteType" value="<%=item.QuoteTypeId%>" /><%=item.QuoteTypeDesc%><br></span>
						<%}%>
					</span>
				</td>
				<%--<td>
					<span hide-on-edit="" id="spnQuoteStatus" name="spnQuoteStatus"></span>
					<span show-on-edit="" id="spnChkQuoteStatus" name="spnChkQuoteStatus" style="display:none;" data-value="">
						<% foreach (var item in objNotification.listQuoteStatus){%>
							<span nowrap><input type="checkbox" disable-on-ajax="" id="chkQuoteStatus" name="chkQuoteStatus" value="<%=item.QuoteStatusId%>" /><%=item.QuoteStatusName%><br></span>
						<%}%>
					</span>
				</td>--%>
				<td>
					<span hide-on-edit="" id="spnBranch" name="spnBranch"></span>
					<span show-on-edit="" id="spnEditBranch" name="spnEditBranch" style="display:none;" data-currentvalue=''></span>
					<BR /><a show-on-edit="" href='javascript:return false;' id="lnkSelectBranch" name="lnkSelectBranch" style="display:none;" data-value='' disable-on-ajax="" >Select Branch</a>
				</td>
				<td>
					<span hide-on-edit="" id="spnDivision" name="spnDivision"></span>
					<span show-on-edit="" id="spnEditDivision" name="spnEditDivision" style="display:none;" data-currentvalue=''></span>
					<BR /><a show-on-edit="" href='javascript:return false;' id="lnkSelectDivision" name="lnkSelectDivision" style="display:none;" data-value='' disable-on-ajax="" >Select Division</a>
				</td>
				<td>
					<span hide-on-edit="" id="spnCommodity" name="spnCommodity"></span>
					<span show-on-edit="" id="spnEditCommodity" name="spnEditCommodity" style="display:none;" data-currentvalue=''></span>
					<BR /><a show-on-edit="" href='javascript:return false;' id="lnkSelectCommodity" name="lnkSelectCommodity" style="display:none;" data-value='' disable-on-ajax="" >Select Commodity</a>
				</td>
				<td>
					<span hide-on-edit="" id="spnEmailAddressFieldName" name="spnEmailAddressFieldName"></span>
					<select show-on-edit="" disable-on-ajax="" id="drpEmailAddressFieldName" name="drpEmailAddressFieldName" style="display:none;" data-value="">
						<% foreach (var item in objNotification.listEmailAddressField){%>
							<option value="<%=item.EmailAddressFieldId%>"><%=item.EmailAddressFieldName%></option>
						<%}%>
					</select>
				</td>
				<td style="display:none">
					<span hide-on-edit="" id="spnEmailSubject" name="spnEmailSubject"></span>
					<input show-on-edit="" disable-on-ajax=""id="txtEmailSubject" name="txtEmailSubject" type="text" style="display:none; width:94%" value="" data-value=""/>
				</td>
				<td style="display:none">
					<span hide-on-edit="" id="spnEmailBody" name="spnEmailBody"></span>
					<input show-on-edit="" disable-on-ajax=""id="txtEmailBody" name="txtEmailBody" type="text" style="display:none; width:94%" value="" data-value=""/>
				</td>
				<td class="tAc" width="105">
					<input hide-on-edit="" disable-on-ajax="" id="btnEdit" type="button" data-Edit="" value="Edit" class="ui-button ui-widget ui-state-default ui-corner-all"/>
					<input hide-on-edit="" disable-on-ajax="" id="btnDelete" type="button" data-Delete="" value="Delete" class="ui-button ui-widget ui-state-default ui-corner-all"/>
					<input show-on-edit="" disable-on-ajax="" id="btnSave" type="button" style="display:none;" data-Save="" value="Save" class="ui-button ui-widget ui-state-default ui-corner-all"/>
					<input show-on-edit="" disable-on-ajax="" id="btnCancel" type="button" style="display:none;" data-Cancel="" value="Cancel" class="ui-button ui-widget ui-state-default ui-corner-all"/>
				</td>
			</tr>
		<% 
			var rowIndex = 0;
			foreach(Entities.Notification.NotificationSetting obj in objNotification.listNotificationSetting)  {%>
			<tr id="trDataRow" class="<%= (rowIndex++ % 2 == 0 ? "rl" : "rd")%>" data-settingid="<%= obj.SettingId%>">
				<td>
					<span hide-on-edit="" id="spnRecipientView" name="spnRecipientView" nowrap>
						<%
							if(obj.ShowUserSearch)
								Response.Write(Helpers.Util.FormatFullName(obj.RecipientFirstName, obj.RecipientLastName));
							else if(obj.ShowTextArea)
								Response.Write(obj.RecipientDistributionList);
							else
								Response.Write(obj.RecipientTypeName);
						%>
					</span>
					<select show-on-edit="" disable-on-ajax="" id="drpRecipientType" name="drpRecipientType" style="display:none" data-value="<%= obj.RecipientTypeId%>">
						<option value=""></option>
						<% foreach (var item in objNotification.listRecipientType){%>
							<option value="<%=item.RecipientTypeId%>" data-showtextarea="<%=item.ShowTextArea%>" data-showusersearch="<%=item.ShowUserSearch%>"><%=item.RecipientTypeName%></option>
						<%}%>
					</select><br>
					<div show-on-edit="" id="divNewTeamMember" style="margin-bottom: 10px;display:none;">
						<form id="frmNewTeamMember" method="post">
							<span id="spnRecipient" name="spnRecipient" data-value="<%=Helpers.Util.FormatFullName(obj.RecipientFirstName, obj.RecipientLastName) %>"></span>
							<input type="hidden" data-required="true" value="" id="RecipientXUId" name="RecipientXUId" data-value="<%= obj.RecipientXUId %>" />
							<%= Helpers.HtmlHelper.RecipientFinder("Find Recipient", "spnRecipient", "RecipientXUId", "Find Recipient", "Remove Recipient" , useIFrameDialog: true)%>
						</form>
					</div>
					<input show-on-edit="" style="display:none; width:94%" disable-on-ajax="" id="txtRecipientDistributionList" name="txtRecipientDistributionList" type="text" value="" data-value="<%= obj.RecipientDistributionList%>"/>
				</td>
				<td>
					<span hide-on-edit="" id="spnEvent" name="spnEvent"><%= obj.EventName%></span>
					<select show-on-edit="" disable-on-ajax="" id="drpEvent" name="drpEvent" style="display:none;" data-value="<%= obj.EventId%>">
						<option value=""></option>
						<% foreach (var item in objNotification.listEvent){%>
							<option value="<%=item.EventId%>" data-subject="<%=item.EmailSubject%>" data-body="<%=item.EmailBody%>"><%=item.EventName%></option>
						<%}%>
					</select>
				</td>
				<td>
					<span hide-on-edit="" id="spnComment" name="spnComment"><%= obj.Comment%></span>
					<input show-on-edit="" disable-on-ajax=""id="txtComment" name="txtComment" type="text" style="display:none; width:94%" value="" data-value="<%= obj.Comment%>"/>
				</td>
				<td>
					<span id="spnChangedBy" name="spnChangedBy" nowrap><%= (Helpers.Util.FormatFullName(obj.ChangeFirstName, obj.ChangeLastName) !="" ? string.Format("{0} on {1}", Helpers.Util.FormatFullName(obj.ChangeFirstName, obj.ChangeLastName), Helpers.DateTimeHelper.FormatDate(obj.EnterDate, false, null)) : "")%></span>
				</td>
				<td>					
					<span hide-on-edit="" id="spnQuoteType" name="spnQuoteType"><%= obj.QuoteTypeList == null ? "" : obj.QuoteTypeList.Replace("}{","; ").Replace("}","").Replace("{","") %></span>
					<span show-on-edit="" id="spnChkQuoteType" name="spnChkQuoteType" style="display:none;" data-value="<%=obj.bmQuoteTypeId%>">
						<% foreach (var item in objNotification.listQuoteType){%>
							<span nowrap><input type="checkbox" disable-on-ajax="" id="chkQuoteType" name="chkQuoteType" value="<%=item.QuoteTypeId%>" /><%=item.QuoteTypeDesc%><br></span>
						<%}%>
					</span>
				</td>
				<%--<td>
					<span hide-on-edit="" id="spnQuoteStatus" name="spnQuoteStatus"><%= obj.QuoteStatusList == null ? "" : obj.QuoteStatusList.Replace("}{","; ").Replace("}","").Replace("{","") %></span>
					<span show-on-edit="" id="spnChkQuoteStatus" name="spnChkQuoteStatus" style="display:none;" data-value="<%=obj.bmQuoteStatusId%>">
						<% foreach (var item in objNotification.listQuoteStatus){%>
							<span nowrap><input type="checkbox" disable-on-ajax="" id="chkQuoteStatus" name="chkQuoteStatus" value="<%=item.QuoteStatusId%>" /><%=item.QuoteStatusName%><br></span>
						<%}%>
					</span>
				</td>--%>
				<td>
					<span hide-on-edit="" id="spnBranch" name="spnBranch"><%= (obj.BranchList == null ? "All Branches" : obj.BranchList.Replace("}{","; ").Replace("}","").Replace("{",""))%></span>
					<span show-on-edit="" id="spnEditBranch" name="spnEditBranch" style="display:none;" data-currentvalue='<%= obj.BranchNoList%>'><%= (obj.BranchList == null ? "All Branches" : obj.BranchList.Replace("}{","; ").Replace("}","").Replace("{",""))%></span>
					<BR /><a show-on-edit="" href='javascript:return false;' id="lnkSelectBranch" name="lnkSelectBranch" style="display:none;" data-value='<%= obj.BranchNoList%>' disable-on-ajax="" >Select Branch</a>
				</td>
				<td>
					<span hide-on-edit="" id="spnDivision" name="spnDivision"><%= (obj.DivisionList == null ? "" : obj.DivisionList.Replace("}{","; ").Replace("}","").Replace("{",""))%></span>
					<span show-on-edit="" id="spnEditDivision" name="spnEditDivision" style="display:none;" data-currentvalue='<%= obj.bmDivisionId%>'><%= (obj.DivisionList == null ? "" : obj.DivisionList.Replace("}{","; ").Replace("}","").Replace("{",""))%></span>
					<BR /><a show-on-edit="" href='javascript:return false;' id="lnkSelectDivision" name="lnkSelectDivision" style="display:none;" data-value='<%= obj.bmDivisionId%>' disable-on-ajax="" >Select Division</a>
				</td>
				<td>
					<span hide-on-edit="" id="spnCommodity" name="spnCommodity"><%= (obj.CommodityCategoryList == null ? "All Commodities" : obj.CommodityCategoryList.Replace("}{","; ").Replace("}","").Replace("{",""))%></span>
					<span show-on-edit="" id="spnEditCommodity" name="spnEditCommodity" style="display:none;" data-currentvalue='<%= obj.CommodityCategoryIdList%>'><%= (obj.CommodityCategoryList == null ? "All Commodities" : obj.CommodityCategoryList.Replace("}{","; ").Replace("}","").Replace("{",""))%></span>
					<BR /><a show-on-edit="" href='javascript:return false;' id="lnkSelectCommodity" name="lnkSelectCommodity" style="display:none;" data-value='<%= obj.CommodityCategoryIdList%>' disable-on-ajax="" >Select Commodity</a>
				</td>
				<td>
					<span hide-on-edit="" id="spnEmailAddressFieldName" name="spnEmailAddressFieldName"><%= obj.EmailAddressFieldName%></span>
					<select show-on-edit="" disable-on-ajax="" id="drpEmailAddressFieldName" name="drpEmailAddressFieldName" style="display:none;" data-value="<%= obj.EmailAddressFieldId%>">
						<% foreach (var item in objNotification.listEmailAddressField){%>
							<option value="<%=item.EmailAddressFieldId%>"><%=item.EmailAddressFieldName%></option>
						<%}%>
					</select>
				</td>
				<td style="display:none">
					<span hide-on-edit="" id="spnEmailSubject" name="spnEmailSubject"><%= obj.EmailSubject%></span>
					<input show-on-edit="" disable-on-ajax=""id="txtEmailSubject" name="txtEmailSubject" type="text" style="display:none; width:94%" value="" data-value="<%= obj.EmailSubject%>"/>
				</td>
				<td style="display:none">
					<span hide-on-edit="" id="spnEmailBody" name="spnEmailBody"><%= obj.EmailBody%></span>
					<input show-on-edit="" disable-on-ajax=""id="txtEmailBody" name="txtEmailBody" type="text" style="display:none; width:94%" value="" data-value="<%= obj.EmailBody%>"/>
				</td>
				<td class="tAc" width="105">
					<input hide-on-edit="" disable-on-ajax="" id="btnEdit" type="button" data-Edit="" value="Edit" class="ui-button ui-widget ui-state-default ui-corner-all"/>
					<input hide-on-edit="" disable-on-ajax="" id="btnDelete" type="button" data-Delete="" value="Delete" class="ui-button ui-widget ui-state-default ui-corner-all"/>
					<input show-on-edit="" disable-on-ajax="" id="btnSave" type="button" style="display:none;" data-Save="" value="Save" class="ui-button ui-widget ui-state-default ui-corner-all"/>
					<input show-on-edit="" disable-on-ajax="" id="btnCancel" type="button" style="display:none;" data-Cancel="" value="Cancel" class="ui-button ui-widget ui-state-default ui-corner-all"/>
				</td>
			</tr>
		<%} %>
			<tr id="trNewRow" style="display:none;" data-settingid="" class="rd">
				<td>
					<select show-on-edit="" disable-on-ajax="" id="drpRecipientType" name="drpRecipientType" data-value="">
						<option value=""></option>
						<% foreach (var item in objNotification.listRecipientType){%>
							<option value="<%=item.RecipientTypeId%>" data-showtextarea="<%=item.ShowTextArea%>" data-showusersearch="<%=item.ShowUserSearch%>"><%=item.RecipientTypeName%></option>
						<%}%>
					</select><br>
					<div id="divNewTeamMember" style="margin-bottom: 10px;display:none">
						<form id="frmNewTeamMember" method="post">
							<span id="spnRecipient" name="spnRecipient"></span>
							<input type="hidden" data-required="true" value="" id="RecipientXUId" name="RecipientXUId" />
							<%= Helpers.HtmlHelper.RecipientFinder("Find Recipient", "spnRecipient", "RecipientXUId", "Find Recipient", "Remove Recipient" , useIFrameDialog: true)%>
						</form>
					</div>
					<input style="display:none" show-on-edit="" disable-on-ajax=""id="txtRecipientDistributionList" name="txtRecipientDistributionList" type="text" width:94%" value="" data-value=""/>
				</td>
				<td>
					<select show-on-edit="" disable-on-ajax="" id="drpEvent" name="drpEvent" data-value="">
						<option value=""></option>
						<% foreach (var item in objNotification.listEvent){%>
							<option value="<%=item.EventId%>" data-subject="<%=item.EmailSubject%>" data-body="<%=item.EmailBody%>"><%=item.EventName%></option>
						<%}%>
					</select>
				</td>
				<td>
					<input show-on-edit="" disable-on-ajax=""id="txtComment" name="txtComment" type="text" style="width:94%" value="" data-value=""/>
				</td>
				<td>
					<span id="spnChangedBy" name="spnChangedBy" nowrap></span>
				</td>
				<td>					
					<span show-on-edit="" id="spnChkQuoteType" name="spnChkQuoteType" data-value="">
						<% foreach (var item in objNotification.listQuoteType){%>
							<span nowrap><input type="checkbox" disable-on-ajax="" id="chkQuoteType" name="chkQuoteType" value="<%=item.QuoteTypeId%>" /><%=item.QuoteTypeDesc%><br></span>
						<%}%>
					</span>
				</td>
				<%--<td>
					<span show-on-edit="" id="spnChkQuoteStatus" name="spnChkQuoteStatus" data-value="">
						<% foreach (var item in objNotification.listQuoteStatus){%>
							<span nowrap><input type="checkbox" disable-on-ajax="" id="chkQuoteStatus" name="chkQuoteStatus" value="<%=item.QuoteStatusId%>" /><%=item.QuoteStatusName%><br></span>
						<%}%>
					</span>
				</td>--%>
				<td>
					<span show-on-edit="" id="spnEditBranch" name="spnEditBranch" data-currentvalue=''></span>
					<BR /><a show-on-edit="" href='javascript:return false;' id="lnkSelectBranch" name="lnkSelectBranch" data-value='' disable-on-ajax="" >Select Branch</a>
				</td>
				<td>
					<span show-on-edit="" id="spnEditDivision" name="spnEditDivision" data-currentvalue=''></span>
					<BR /><a show-on-edit="" href='javascript:return false;' id="lnkSelectDivision" name="lnkSelectDivision" data-value='' disable-on-ajax="" >Select Division</a>
				</td>
				<td>
					<span show-on-edit="" id="spnEditCommodity" name="spnEditCommodity" data-currentvalue=''></span>
					<BR /><a show-on-edit="" href='javascript:return false;' id="lnkSelectCommodity" name="lnkSelectCommodity" data-value='' disable-on-ajax="" >Select Commodity</a>
				</td>
				<td>
					<select show-on-edit="" disable-on-ajax="" id="drpEmailAddressFieldName" name="drpEmailAddressFieldName" data-value="">
						<option value=""></option>
						<% foreach (var item in objNotification.listEmailAddressField){%>
							<option value="<%=item.EmailAddressFieldId%>"><%=item.EmailAddressFieldName%></option>
						<%}%>
					</select>
				</td>
				<td style="display:none">
					<input show-on-edit="" disable-on-ajax=""id="txtEmailSubject" name="txtEmailSubject" type="text" style="width:94%" value="" data-value=""/>
				</td>
				<td style="display:none">
					<input show-on-edit="" disable-on-ajax=""id="txtEmailBody" name="txtEmailBody" type="text" style="width:94%" value="" data-value=""/>
				</td>
				<td class="tAc" width="105">
					<input disable-on-ajax="" id="btnAddNewSave" type="button" data-AddNewSave="" value="Save" class="ui-button ui-widget ui-state-default ui-corner-all"/>
					<input disable-on-ajax="" id="btnAddNewCancel" type="button" data-AddNewCancel="" value="Cancel" class="ui-button ui-widget ui-state-default ui-corner-all"/>
				</td>
			</tr>
			<tr id="trNoDataRow" style="display:<%= objNotification.listNotificationSetting.Count > 0 ? "none" : "block" %>;">
				<td colspan="14" style="padding: 10px 10px 10px 10px;">
					No Recipients Found.
				</td>
			</tr>
		</tbody>
	</table>
	<input type="hidden" value="2000" id="hdnAddingIndex" name="hdnAddingIndex"/>
	<div id="divBranch">
		<div>
			<input type="checkbox" value="-1" id="SelectBranch_-1" name="chkBranch" class="SelectBranch" data-name="All Branches"/>All Branches
			<div style="padding:0; border-bottom:solid #a0a0a0 1px; margin-top:5px; margin-bottom:5px;"></div>
		</div>
		<% foreach (var item in objNotification.listBranch){%>
			<div style='display: inline-block; zoom: 1; *display: inline; min-width: 140px; margin-right: 10px; margin-bottom: 5px;'>
				<input id='SelectBranch_<%= item.BranchNo%>' name="chkBranch" type='checkbox' class='SelectBranch' value='<%=item.BranchNo%>' data-name="<%=item.BranchName%>"/><%=item.BranchName%>
			</div>
		<%}%>
	</div>
	
	<div id="divDivision">
		<div>
			<input type="checkbox" value="0" id="SelectDivision_0" name="chkDivision" data-name="All Divisions"/>Select All
			<div style="padding:0; border-bottom:solid #a0a0a0 1px; margin-top:5px; margin-bottom:5px;"></div>
		</div>
		<% foreach (var item in objNotification.listDivision){%>
			<div style='display: inline-block; zoom: 1; *display: inline; min-width: 140px; margin-right: 10px; margin-bottom: 5px;'>
				<input id='SelectDivision_<%= item.DivisionId%>' name="chkDivision" type='checkbox' class='SelectDivision' value='<%=item.DivisionId%>' data-name="<%=item.DivisionName%>"/><%=item.DivisionName +" - " + item.DivisionNameDesc%>
			</div>
		<%}%>
	</div>
		
	<div id="divCommodity">
		<div>
			<input type="checkbox" value="-1" id="SelectCommodity_-1" name="chkCommodity" class="SelectCommodity" data-name="All Commodities"/>All Commodities
			<div style="padding:0; border-bottom:solid #a0a0a0 1px; margin-top:5px; margin-bottom:5px;"></div>
		</div>
		<% foreach (var item in objNotification.listCommodityCategory){%>
			<div style='display: inline-block; zoom: 1; *display: inline; min-width: 140px; margin-right: 10px; margin-bottom: 5px;'>
				<input id='SelectCommodity_<%= item.CommodityCategoryId%>' name="chkCommodity" type='checkbox' class='SelectCommodity' value='<%=item.CommodityCategoryId%>' data-name="<%=item.CommodityCategoryName%>"/><%=item.CommodityCategoryName%>
			</div>
		<%}%>
	</div>	
		
	<div id="dlgIFrameDialog" style="display: none;">
        <iframe id="iframeUserSearch" src=""  width="625px" height="500px" frameborder="0" scrolling="no"></iframe>
    </div>
	
	<script type="text/javascript">
		$j(document).ready(function () {
			RefreshBindings();

			$j("#dlgIFrameDialog").dialog({
				width: 650,
				height: 550,
				draggable: true,
				position: 'center',
				resizable: false,
				modal: true,
				title: 'Find Recipient',
				autoOpen: false
			});
		});

		function openIFrameDialog() {
			$("#iframeUserSearch").attr("src", "<%=Url.ApplicationPath%>/modules/admin/User_Search.aspx");
			$j("#dlgIFrameDialog").dialog("open");
		}

		function RefreshBindings() {
			$j("[name=drpRecipientType]").unbind('change');
			$j("[name=drpRecipientType]").change(function () {
				var selectedTr = $j(this).closest("tr");
				$j("#divNewTeamMember", selectedTr).hide();
				$j("#txtRecipientDistributionList", selectedTr).hide();

				var ShowTextArea = $('option:selected', this).attr('data-showtextarea');
				var ShowUserSearch = $('option:selected', this).attr('data-showusersearch');

				if(ShowTextArea == "True")
					$j("#txtRecipientDistributionList", selectedTr).show();
				if(ShowUserSearch == "True")
					$j("#divNewTeamMember", selectedTr).show();
			});

			$j("[name=drpEvent]").unbind('change');
			$j("[name=drpEvent]").change(function () {
				var selectedTr = $j(this).closest("tr");
				$j("#txtEmailSubject", selectedTr).val($('option:selected', this).attr('data-subject'));
				$j("#txtEmailBody", selectedTr).val($('option:selected', this).attr('data-body'));
			});
			
			$j("input[data-Add]").unbind('click');
			$j("input[data-Add]").click(function () {
				$j("#btnAdd").attr("disabled", true);
			
				var FirstRow = $('#tblDataList > tbody > tr:first');
				var AddNewRow = $('#tblDataList > tbody > tr[id="trNewRow"]');
				var NewRow = $(AddNewRow).clone();

				NewRow.removeAttr('style');
				NewRow.removeAttr('id');
				NewRow.attr('id','trTempNewRow');
				NewRow.attr('data-settingid','0');

				NewRow.hide();
				$(FirstRow).after(NewRow);
				$j("#trNoDataRow").fadeOut();
				NewRow.fadeIn(1000);
						
				//Init Branches
				//Insert the selected Ids and Names into 2 arrays
				var BranchNos = new Array();
				var BranchNames = new Array();
				BranchNos.push(-1);
				BranchNames.push("All Branches");
				//Update the span
				var label = $j("#spnEditBranch", NewRow);
				label.attr("data-currentvalue", "{" + BranchNos.join("}{") + "}");
				label.text(BranchNames.join("; "));

				//Init Commodities
				//Insert the selected Ids and Names into 2 arrays
				var CommodityIds = new Array();
				var CommodityNames = new Array();
				CommodityIds.push(-1);
				CommodityNames.push("All Commodities");
				//Update the span
				var label = $j("#spnEditCommodity", NewRow);
				label.attr("data-currentvalue", "{" + CommodityIds.join("}{") + "}");
				label.text(CommodityNames.join("; "));

				//Init Divisions
				var checkedControls = $j(".SelectDivision");
				//Insert the selected Ids and Names into 2 arrays
				var bmDivisionid = 0;
				var DivisionNames = new Array();
				checkedControls.each(function (idx) {
					bmDivisionid = bmDivisionid + parseInt($(this).val());
					DivisionNames.push($(this).attr("data-name"));
				});
				//Update the span
				var label = $j("#spnEditDivision", NewRow);
				label.attr("data-currentvalue", bmDivisionid);
				label.text(DivisionNames.join("; "));

				RefreshBindings();
			});

			$j("input[data-AddNewCancel]").unbind('click');
			$j("input[data-AddNewCancel]").click(function () {
				$j("#btnAdd").removeAttr("disabled");
				
				setTimeout(function () {
					$j("#trTempNewRow").fadeOut();
					setTimeout(function () {
						$j("#trTempNewRow").remove();

						//Show the No data row if the deleted row was the last record
						if ($('#tblDataList tr[id="trDataRow"]').length == 0) {
							$j("#trNoDataRow").fadeIn();									
							$j("#trNoDataRow").effect("highlight", { color: "rgb(255, 204, 102)" }, 1000);
						}
					}, 600);
				}, 200);
			});

			$j("input[data-AddNewSave]").unbind('click');
			$j("input[data-AddNewSave]").click(function () {
				var selectedTr = $j("#trTempNewRow");
				if(Validate(selectedTr) != 'Valide')
					return;
				
				var drpRecipientType = $j("#drpRecipientType", selectedTr);
				var txtRecipientDistributionList = $j("#txtRecipientDistributionList", selectedTr);
				var RecipientXUId = $j("#RecipientXUId", selectedTr).val();

				var drpEvent = $j("#drpEvent", selectedTr);
				var txtComment = $j("#txtComment", selectedTr);

				var spnChkQuoteType = $j("#spnChkQuoteType", selectedTr);
				var bmQuoteTypeId = 0;
				$j("#chkQuoteType:checked", spnChkQuoteType).each(function(){
					bmQuoteTypeId = bmQuoteTypeId + parseInt($j(this).val());
				});

				//var spnChkQuoteStatus = $j("#spnChkQuoteStatus", selectedTr);
				//var bmQuoteStatusId = 0;
				//$j("#chkQuoteStatus:checked", spnChkQuoteStatus).each(function(){
				//	bmQuoteStatusId = bmQuoteStatusId + parseInt($j(this).val());
				//});

				var spnEditDivision = $j("#spnEditDivision", selectedTr);
				var spnEditBranch = $j("#spnEditBranch", selectedTr);
				var spnEditCommodity = $j("#spnEditCommodity", selectedTr);

				var drpEmailAddressFieldName = $j("#drpEmailAddressFieldName", selectedTr);
				var txtEmailSubject = $j("#txtEmailSubject", selectedTr);
				var txtEmailBody = $j("#txtEmailBody", selectedTr);
							
				//Disable all the save buttons till this action finished
				$j("[disable-on-ajax]").attr("disabled", true);

				var data = "ActionName=Add"+
							"&RecipientXUID="+RecipientXUId+
							"&RecipientTypeId="+ drpRecipientType.val() +
							"&RecipientDistributionList="+ txtRecipientDistributionList.val() +
							"&EventId="+ drpEvent.val()+
							"&Comment="+ encodeURIComponent(txtComment.val())+
							"&bmQuoteTypeId="+ bmQuoteTypeId+
							//"&bmQuoteStatusId="+ bmQuoteStatusId+
							"&bmDivisionId="+ spnEditDivision.attr('data-currentvalue')+
							"&BranchNoList="+ encodeURIComponent(spnEditBranch.attr('data-currentvalue'))+
							"&CommodityCategoryIdList="+ encodeURIComponent(spnEditCommodity.attr('data-currentvalue'))+
							"&EmailAddressFieldId="+ drpEmailAddressFieldName.val()+
							"&EmailSubject="+ encodeURIComponent(txtEmailSubject.val())+
							"&EmailBody="+ encodeURIComponent(txtEmailBody.val())

				$j.ajax({
					url: 'NotificationAjaxHandler.ashx?' + data
					, type: 'POST'
					, traditional: true
					, contentType: 'application/json; charset=utf-8'
					, dataType: 'json'
					, success: function (result, textStatus, jqXHR) {
						if (result.executionState.Success) {
							var FirstRow = $('#tblDataList > tbody > tr:first');
							var NewRow = $(FirstRow).clone();
							NewRow.attr('id', "trDataRow");	
							NewRow.attr('data-settingid', result.SettingId);
							
							if (result.ShowUserSearch == "True")
								$j("#spnRecipientView", NewRow).html(result.RecipientFullName);
							else if (result.ShowTextArea == "True")
								$j("#spnRecipientView", NewRow).html(result.RecipientDistributionList);
							else
								$j("#spnRecipientView", NewRow).html(result.RecipientTypeName);

							$j("#drpRecipientType", NewRow).attr('data-value', result.RecipientTypeId);
							$j("#txtRecipientDistributionList", NewRow).attr('data-value', result.RecipientDistributionList);
							$j("#RecipientXUId", NewRow).attr('data-value', result.RecipientXUId);
							$j("#spnRecipient", NewRow).attr('data-value', result.RecipientFullName);

							$j("#drpEvent", NewRow).attr('data-value', result.EventId);
							$j("#spnEvent", NewRow).html(result.EventName);

							$j("#txtComment", NewRow).attr('data-value', result.Comment)
							$j("#spnComment", NewRow).html(result.Comment);
							$j("#spnChangedBy", NewRow).html("{0} on {1}".format(result.ChangeFullName, result.ChangeDate));
							
							$j("#spnChkQuoteType", NewRow).attr('data-value', result.bmQuoteTypeId);
							$j("#spnQuoteType", NewRow).html(result.QuoteTypeList);

							//$j("#spnChkQuoteStatus", NewRow).attr('data-value', result.bmQuoteStatusId);
							//$j("#spnQuoteStatus", NewRow).html(result.QuoteStatusList);

							$j("#spnBranch", NewRow).html(result.BranchList == "" ? "All Branches" : result.BranchList);
							$j("#spnEditBranch", NewRow).html(result.BranchList == "" ? "All Branches" : result.BranchList);
							$j("#spnEditBranch", NewRow).attr('data-currentvalue', result.BranchNoList);
							$j("#lnkSelectBranch", NewRow).attr('data-value', result.BranchNoList);

							$j("#spnDivision", NewRow).html(result.DivisionList);
							$j("#spnEditDivision", NewRow).html(result.DivisionList);
							$j("#spnEditDivision", NewRow).attr('data-currentvalue', result.bmDivisionId);
							$j("#lnkSelectDivision", NewRow).attr('data-value', result.bmDivisionId);

							$j("#spnCommodity", NewRow).html(result.CommodityCategoryList == "" ? "All Commodities" : result.CommodityCategoryList);
							$j("#spnEditCommodity", NewRow).html(result.CommodityCategoryList == "" ? "All Commodities" : result.CommodityCategoryList);
							$j("#spnEditCommodity", NewRow).attr('data-currentvalue', result.CommodityCategoryIdList);
							$j("#lnkSelectCommodity", NewRow).attr('data-value', result.CommodityCategoryIdList);

							$j("#drpEmailAddressFieldName", NewRow).attr('data-value', result.EmailAddressFieldId);
							$j("#spnEmailAddressFieldName", NewRow).html(result.EmailAddressFieldName);

							$j("#txtEmailSubject", NewRow).attr('data-value', result.EmailSubject)
							$j("#spnEmailSubject", NewRow).html(result.EmailSubject);

							$j("#txtEmailBody", NewRow).attr('data-value', result.EmailBody)
							$j("#spnEmailBody", NewRow).html(result.EmailBody);
														
							$j("#trTempNewRow").remove();
							NewRow.removeAttr('style');
							$(FirstRow).after(NewRow);
							AdjustTableCss("tblDataList");
							
							$j(NewRow).effect("highlight", { color: "rgb(255, 204, 102)" }, 1000);
							$j("#trNoDataRow").fadeOut();
							
							RefreshBindings();
						}
						else {
							if(result.executionState.Status == 1 || result.executionState.Status == 100)
								alert('Failed to update the changes: duplicated recipients found.');
							else{
								alert('Error occurred. Cannot proceed your operation. {0}'.format(result.executionState.Description));
							}
						}

						$j("[disable-on-ajax]").removeAttr("disabled");
						//$j("#btnAdd").removeAttr("disabled");
					}
					, error: function (jqXHR, textStatus, errorThrown) {
						$j("[disable-on-ajax]").removeAttr("disabled");
						alert('Error occurred. Cannot proceed your operation. {0}'.format(errorThrown));
					}
				});
			});

			$j("input[data-Edit]").unbind('click');
			$j("input[data-Edit]").click(function () {
				var selectedTr = $j(this).closest("tr");
				SetRowControlsVisibility(true, selectedTr);	

				//Init the select controls
				var selectControls = $j("select", selectedTr);
				$.each(selectControls, function () {
					$j(this).val($j(this).attr('data-value'));
				});
				
				//Init the checkbox controls
				var CheckboxControls = $j("input[type=checkbox]", selectedTr);
				$j(CheckboxControls).removeAttr('checked');
				$.each(CheckboxControls, function () {
					var value = $j(this).closest("[data-value]").attr('data-value');
					if (($j(this).val() & value) != 0) {
						$j(this).attr('checked', 'checked');
					}
				});

				//Init the textbox controls
				var TextboxControls = $j("input[type=text]", selectedTr);
				$j(TextboxControls).val("");
				$.each(TextboxControls, function () {
					$j(this).val($j(this).attr('data-value'));
				});

				//Init the Recipient 
				var drpRecipientType = $j("#drpRecipientType", selectedTr);
				var txtRecipientDistributionList = $j("#txtRecipientDistributionList", selectedTr);
				var divNewTeamMember = $j("#divNewTeamMember", selectedTr);
				var ShowTextArea = $('option:selected', drpRecipientType).attr('data-showtextarea');
				var ShowUserSearch = $('option:selected', drpRecipientType).attr('data-showusersearch');

				txtRecipientDistributionList.hide();
				divNewTeamMember.hide();
				if (ShowTextArea == "True")
					txtRecipientDistributionList.show();
				else if (ShowUserSearch == "True")
					divNewTeamMember.show();

				$j("#spnRecipient", selectedTr).text($j("#spnRecipient", selectedTr).attr('data-value'));
				$j("#RecipientXUId", selectedTr).val($j("#RecipientXUId", selectedTr).attr('data-value'));
			});

			$j("input[data-Cancel]").unbind('click');
			$j("input[data-Cancel]").click(function () {
				var selectedTr = $j(this).closest("tr");
				SetRowControlsVisibility(false, selectedTr);
			});

			$j("input[data-Save]").unbind('click');
			$j("input[data-Save]").click(function () {
				var selectedTr = $j(this).closest("tr");
				if(Validate(selectedTr) != 'Valide')
					return;

				SetRowControlsVisibility(false, selectedTr);	

				var SettingId = selectedTr.attr('data-settingid');

				var drpRecipientType = $j("#drpRecipientType", selectedTr);
				var txtRecipientDistributionList = $j("#txtRecipientDistributionList", selectedTr);
				var RecipientXUId = $j("#RecipientXUId", selectedTr).val();

				var ShowTextArea = $('option:selected', drpRecipientType).attr('data-showtextarea');
				var ShowUserSearch = $('option:selected', drpRecipientType).attr('data-showusersearch');
				if (ShowTextArea == "True") {
					RecipientXUId = 0;
				}
				else if (ShowUserSearch == "True") {
					txtRecipientDistributionList.val("");
				}
				else {
					RecipientXUId = 0;
					txtRecipientDistributionList.val("");
				}

				var drpEvent = $j("#drpEvent", selectedTr);
				var txtComment = $j("#txtComment", selectedTr);

				var spnChkQuoteType = $j("#spnChkQuoteType", selectedTr);
				var bmQuoteTypeId = 0;
				$j("#chkQuoteType:checked", spnChkQuoteType).each(function(){
					bmQuoteTypeId = bmQuoteTypeId + parseInt($j(this).val());
				});

				//var spnChkQuoteStatus = $j("#spnChkQuoteStatus", selectedTr);
				//var bmQuoteStatusId = 0;
				//$j("#chkQuoteStatus:checked", spnChkQuoteStatus).each(function(){
				//	bmQuoteStatusId = bmQuoteStatusId + parseInt($j(this).val());
				//});

				var spnEditDivision = $j("#spnEditDivision", selectedTr);
				var spnEditBranch = $j("#spnEditBranch", selectedTr);
				var spnEditCommodity = $j("#spnEditCommodity", selectedTr);

				var drpEmailAddressFieldName = $j("#drpEmailAddressFieldName", selectedTr);
				var txtEmailSubject = $j("#txtEmailSubject", selectedTr);
				var txtEmailBody = $j("#txtEmailBody", selectedTr);
							
				//Disable all the save buttons till this action finished
				$j("[disable-on-ajax]").attr("disabled", true);

				//if (txtComment.val() == txtComment.attr('data-value')
				//	&& drpOppType.val() == drpOppType.attr('data-value')
				//	&& drpOppEquipmentStatus.val() == drpOppEquipmentStatus.attr('data-value')
				//	&& drpProductType.val() == drpProductType.attr('data-value')
				//	&& drpEmailAddressFieldName.val() == drpEmailAddressFieldName.attr('data-value')
				//
				//	&& spnEditRegion.attr('data-currentvalue') == lnkSelectRegion.attr('data-value')
				//
				//	&& bmOppItemType == spnChkOppItemType.attr('data-value')
				//	&& bmNotificationTriggerType == spnChkNotificationTriggerType.attr('data-value')
				//	)
				//{
				//	alert('Nothing changed to be saved.');
				//	return false;
				//}
			
				//Disable all the save buttons till this action finished
				$j("[disable-on-ajax]").attr("disabled", true);
				
				var data = "ActionName=Update"+
							"&SettingId="+SettingId+
							"&RecipientXUID=" + RecipientXUId +
							"&RecipientTypeId=" + drpRecipientType.val() +
							"&RecipientDistributionList=" + txtRecipientDistributionList.val() +
							"&EventId="+ drpEvent.val()+
							"&Comment="+ encodeURIComponent(txtComment.val())+
							"&bmQuoteTypeId="+ bmQuoteTypeId+
							//"&bmQuoteStatusId="+ bmQuoteStatusId+
							"&bmDivisionId="+ spnEditDivision.attr('data-currentvalue')+
							"&BranchNoList="+ encodeURIComponent(spnEditBranch.attr('data-currentvalue'))+
							"&CommodityCategoryIdList="+ encodeURIComponent(spnEditCommodity.attr('data-currentvalue'))+
							"&EmailAddressFieldId="+ drpEmailAddressFieldName.val()+
							"&EmailSubject="+ encodeURIComponent(txtEmailSubject.val())+
							"&EmailBody="+ encodeURIComponent(txtEmailBody.val())

				$j.ajax({
					url: 'NotificationAjaxHandler.ashx?' + data
					, type: 'POST'
					, traditional: true
					, contentType: 'application/json; charset=utf-8'
					, dataType: 'json'
					, success: function (result, textStatus, jqXHR) {
						if (result.executionState.Success) {

							if (result.ShowUserSearch == "True")
								$j("#spnRecipientView", selectedTr).html(result.RecipientFullName);
							else if (result.ShowTextArea == "True")
								$j("#spnRecipientView", selectedTr).html(result.RecipientDistributionList);
							else
								$j("#spnRecipientView", selectedTr).html(result.RecipientTypeName);
							$j("#drpRecipientType", selectedTr).attr('data-value', result.RecipientTypeId);
							$j("#RecipientXUId", selectedTr).attr('data-value', result.RecipientXUId);
							$j("#txtRecipientDistributionList", selectedTr).attr('data-value', result.RecipientDistributionList);
							$j("#spnRecipient", selectedTr).attr('data-value', result.RecipientFullName);

							$j("#drpEvent", selectedTr).attr('data-value', result.EventId);
							$j("#spnEvent", selectedTr).html(result.EventName);

							$j("#txtComment", selectedTr).attr('data-value', result.Comment)
							$j("#spnComment", selectedTr).html(result.Comment);
							$j("#spnChangedBy", selectedTr).html("{0} on {1}".format(result.ChangeFullName, result.ChangeDate));
							
							$j("#spnChkQuoteType", selectedTr).attr('data-value', result.bmQuoteTypeId);
							$j("#spnQuoteType", selectedTr).html(result.QuoteTypeList);

							//$j("#spnChkQuoteStatus", selectedTr).attr('data-value', result.bmQuoteStatusId);
							//$j("#spnQuoteStatus", selectedTr).html(result.QuoteStatusList);

							$j("#spnBranch", selectedTr).html(result.BranchList == "" ? "All Branches" : result.BranchList);
							$j("#spnEditBranch", selectedTr).html(result.BranchList == "" ? "All Branches" : result.BranchList);
							$j("#spnEditBranch", selectedTr).attr('data-currentvalue', result.BranchNoList);
							$j("#lnkSelectBranch", selectedTr).attr('data-value', result.BranchNoList);

							$j("#spnDivision", selectedTr).html(result.DivisionList);
							$j("#spnEditDivision", selectedTr).html(result.DivisionList);
							$j("#spnEditDivision", selectedTr).attr('data-currentvalue', result.bmDivisionId);
							$j("#lnkSelectDivision", selectedTr).attr('data-value', result.bmDivisionId);

							$j("#spnCommodity", selectedTr).html(result.CommodityCategoryList == "" ? "All Commodities" : result.CommodityCategoryList);
							$j("#spnEditCommodity", selectedTr).html(result.CommodityCategoryList == "" ? "All Commodities" : result.CommodityCategoryList);
							$j("#spnEditCommodity", selectedTr).attr('data-currentvalue', result.CommodityCategoryIdList);
							$j("#lnkSelectCommodity", selectedTr).attr('data-value', result.CommodityCategoryIdList);

							$j("#drpEmailAddressFieldName", selectedTr).attr('data-value', result.EmailAddressFieldId);
							$j("#spnEmailAddressFieldName", selectedTr).html(result.EmailAddressFieldName);

							$j("#txtEmailSubject", selectedTr).attr('data-value', result.EmailSubject)
							$j("#spnEmailSubject", selectedTr).html(result.EmailSubject);

							$j("#txtEmailBody", selectedTr).attr('data-value', result.EmailBody)
							$j("#spnEmailBody", selectedTr).html(result.EmailBody);
							
							selectedTr.effect("highlight", { color: "rgb(255, 204, 102)" }, 1000);							
						}
						else {
							if(result.executionState.Status == 1 || result.executionState.Status == 100)
								alert('Failed to update the changes: duplicated recipients found.');
							else{
								alert('Error occurred. Cannot proceed your operation. {0}'.format(result.executionState.Description));
							}
						}
						$j("[disable-on-ajax]").removeAttr("disabled");
					}
					, error: function (jqXHR, textStatus, errorThrown) {
						$j("[disable-on-ajax]").removeAttr("disabled");
						alert('Error occurred. Cannot proceed your operation. {0}'.format(errorThrown));
					}
				});
			});

			$j("input[data-Delete]").unbind('click');
			$j("input[data-Delete]").click(function () {
				var selectedTr = $j(this).closest("tr");
				selectedTr.closest("tr").effect('highlight');
				if (!confirm('Are you sure to delete it?'))
					return;
				
				var SettingId = selectedTr.attr('data-settingid');

				//Disable all controls till this action finished
				$j("[disable-on-ajax]").attr("disabled", true);

				var data = "ActionName=Delete"+
							"&SettingId="+ SettingId

				$j.ajax({
					//url: "NotificationAjaxHandler.ashx?OP=&field=&ItemID=" + index + "&SOS=" + SOS + "&PartNo=" + PartNo + "&Source=BULKPARTS",
					url: "NotificationAjaxHandler.ashx?" + data
					, type: 'POST'
					, traditional: true
					, contentType: 'application/json; charset=utf-8'
					, dataType: 'json'
					//, data: JSON.stringify(data)
					, success: function (result, textStatus, jqXHR) {
						if (result.executionState.Success) {
							setTimeout(function () {
								selectedTr.fadeOut();
								setTimeout(function () {
									selectedTr.remove();
									AdjustTableCss("tblDataList");

									//Show the No data row if the deleted row was the last record
									if ($('#tblDataList tr[id="trDataRow"]').length == 0) {
										$j("#trNoDataRow").fadeIn();
									}
								}, 600);
							}, 200);
						}
						else
							alert('Error occurred. Cannot proceed your operation. {0}'.format(result.executionState.Description));
						$j("[disable-on-ajax]").removeAttr("disabled");
					}
					, error: function (jqXHR, textStatus, errorThrown) {
						$j("[disable-on-ajax]").removeAttr("disabled");
						alert('Error occurred. Cannot proceed your operation. {0}'.format(errorThrown));
					}
				});
			});

			//--= Branch Popup Windown =--//
			$j("[name=lnkSelectBranch]").unbind('click');
			$j("[name=lnkSelectBranch]").click(function () {
				var selectedTr =  $j(this).closest("tr");
				var SettingId = selectedTr.attr("data-settingid");
				//init the selected SettingId on the checkboxes 
				$j("[name=chkBranch]").attr("data-settingid", SettingId);

				//uncheck all checkboxes
				$j("[name=chkBranch").removeAttr("checked");
				
				//Check the selected Branches
				var selected = $j("#spnEditBranch", selectedTr).attr("data-currentvalue").replace(/}{/g , ",").replace("{" , "").replace("}" , "").split(",");
				$.each(selected, function () {
					$j("#SelectBranch_" + this).attr("checked", "checked");
				});
				
				//open dialog and send the selected SettingId
				var div = $j("#divBranch");
				div.attr("data-settingid", SettingId);
				div.dialog("open");
				return false;
			});

			$j("#divBranch").dialog({
				autoOpen: false
				, modal: true
				, title: "Select Branch"
				, width: 550
				, buttons: {
					"OK": function () {
						var div = $j(this);
						var SettingId = div.attr("data-settingid");
						var checkedControls = $j(".SelectBranch:checked");
						var selectedTr = $j("tr[data-settingid=" + SettingId + "]");

						//Insert the selected Ids and Names into 2 arrays
						var BranchNos = new Array();
						var BranchNames = new Array();
						checkedControls.each(function (idx) {
							BranchNos.push($(this).val());
							BranchNames.push($(this).attr("data-name"));
						});
						
						//Update the span
						var label = $j("#spnEditBranch", selectedTr);
						label.attr("data-currentvalue", "{" + BranchNos.join("}{") + "}");
						label.text(BranchNames.join("; "));

						//Close the dialog
						div.dialog("close");
					}
				}
			});

			$j("[name=chkBranch]").unbind('click');
			$j("[name=chkBranch]").click(function () {
				var chk = $j(this);
				if (chk.is(":checked")) {
					if (chk.val() == -1) //All Branchs
						$j(".SelectBranch").not(this).removeAttr("checked");
					else
						$j("#SelectBranch_-1").removeAttr("checked");
				}
			});
			//--= /Branch Popup Windown =--//

			//--= Division Popup Windown =--//
			$j("[name=lnkSelectDivision]").unbind('click');
			$j("[name=lnkSelectDivision]").click(function () {
				var selectedTr =  $j(this).closest("tr");
				var SettingId = selectedTr.attr("data-settingid");
				//init the selected SettingId on the checkboxes 
				$j("[name=chkDivision]").attr("data-settingid", SettingId);

				//uncheck all checkboxes
				$j("[name=chkDivision").removeAttr("checked");
				
				//Check the selected Divisions
				var bmDivisionId = $j("#spnEditDivision", selectedTr).attr("data-currentvalue");
				$.each($j(".SelectDivision"), function () {
					if((bmDivisionId & $j(this).val()) != 0)
						$j(this).attr("checked", "checked");
				});
				
				//Check the All Divisions Checkbox
				$j("#SelectDivision_0").removeAttr("checked");
        		if ($j(".SelectDivision").length == $j(".SelectDivision:checked").length)
        			$j("#SelectDivision_0").attr("checked", "checked");

				//open dialog and send the selected SettingId
				var div = $j("#divDivision");
				div.attr("data-settingid", SettingId);
				div.dialog("open");
				return false;
			});
			$j("#divDivision").dialog({
				autoOpen: false
				, modal: true
				, title: "Select Division"
				, width: 550
				, buttons: {
					"OK": function () {
						var div = $j(this);
						var SettingId = div.attr("data-settingid");
						var checkedControls = $j(".SelectDivision:checked");
						var selectedTr = $j("tr[data-settingid=" + SettingId + "]");

						//Insert the selected Ids and Names into 2 arrays
						var bmDivisionid = 0;
						var DivisionNames = new Array();
						checkedControls.each(function (idx) {
							bmDivisionid = bmDivisionid + parseInt( $(this).val());
							DivisionNames.push($(this).attr("data-name"));
						});
						
						//Update the span
						var label = $j("#spnEditDivision", selectedTr);
						label.attr("data-currentvalue", bmDivisionid);
						label.text(DivisionNames.join("; "));

						//Close the dialog
						div.dialog("close");
					}
				}
			});
			$j("[name=chkDivision]").unbind('click');
			$j("[name=chkDivision]").click(function () {
				var chk = $j(this);
				if (chk.is(":checked")) {
					if (chk.val() == 0) //Select All
						$j(".SelectDivision").attr("checked", "checked");
					else{
						$j("#SelectDivision_0").removeAttr("checked");
        				if ($j(".SelectDivision").length == $j(".SelectDivision:checked").length)
        					$j("#SelectDivision_0").attr("checked", "checked");
					}
				}
				else{
					if (chk.val() == 0) //Select All
						$j(".SelectDivision").removeAttr("checked");
					else
						$j("#SelectDivision_0").removeAttr("checked");
				}
			});
			//--= /Division Popup Windown =--//

			//--= Commodity Popup Windown =--//
			$j("[name=lnkSelectCommodity]").unbind('click');
			$j("[name=lnkSelectCommodity]").click(function () {
				var selectedTr =  $j(this).closest("tr");
				var SettingId = selectedTr.attr("data-settingid");
				//init the selected SettingId on the checkboxes 
				$j("[name=chkCommodity]").attr("data-settingid", SettingId);

				//uncheck all checkboxes
				$j("[name=chkCommodity").removeAttr("checked");
				
				//Check the selected Commodity
				var selected = $j("#spnEditCommodity", selectedTr).attr("data-currentvalue").replace(/}{/g , ",").replace("{" , "").replace("}" , "").split(",");
				$.each(selected, function () {
					$j("#SelectCommodity_" + this).attr("checked", "checked");
				});

				//open dialog and send the selected SettingId
				var div = $j("#divCommodity");
				div.attr("data-settingid", SettingId);
				div.dialog("open");
				return false;
			});
			$j("#divCommodity").dialog({
				autoOpen: false
				, modal: true
				, title: "Select Commodity Category"
				, width: 550
				, buttons: {
					"OK": function () {
						var div = $j(this);
						var SettingId = div.attr("data-settingid");
						var checkedControls = $j(".SelectCommodity:checked");
						var selectedTr = $j("tr[data-settingid=" + SettingId + "]");

						//Insert the selected Ids and Names into 2 arrays
						var CommodityIds = new Array();
						var CommodityNames = new Array();
						checkedControls.each(function (idx) {
							CommodityIds.push($(this).val());
							CommodityNames.push($(this).attr("data-name"));
						});
						
						//Update the span
						var label = $j("#spnEditCommodity", selectedTr);
						label.attr("data-currentvalue", "{" + CommodityIds.join("}{") + "}");
						label.text(CommodityNames.join("; "));
						
						//Close the dialog
						div.dialog("close");
					}
				}
			});
			$j("[name=chkCommodity]").unbind('click');
			$j("[name=chkCommodity]").click(function () {
				var chk = $j(this);
				if (chk.is(":checked")) {
					if (chk.val() == -1) //All Commodity
						$j(".SelectCommodity").not(this).removeAttr("checked");
					else
						$j("#SelectCommodity_-1").removeAttr("checked");
				}
			});
			//--= /Commodity Popup Windown =--//
		}

		function Validate(selectedTr){
			var BranchList = $j("#spnEditBranch", selectedTr).attr("data-currentvalue");
			var CommodityList = $j("#spnEditCommodity", selectedTr).attr("data-currentvalue");

			var bmDivisoinId = $j("#spnEditDivision", selectedTr).attr("data-currentvalue");
			
			var lstQuoteType = selectedTr.find("input[name='chkQuoteType']:checked");
			//var lstQuoteStatus = selectedTr.find("input[name='chkQuoteStatus']:checked");
			
			var drpEvent = selectedTr.find("[name='drpEvent']");
			var drpEmailAddressFieldName = selectedTr.find("[name='drpEmailAddressFieldName']");
			
			var txtEmailSubject = selectedTr.find("[name='txtEmailSubject']");
			var txtEmailBody = selectedTr.find("[name='txtEmailBody']");

			//Recipient
			var drpRecipientType = $j("#drpRecipientType", selectedTr);
			var ShowTextArea = $('option:selected', drpRecipientType).attr('data-showtextarea');
			var ShowUserSearch = $('option:selected', drpRecipientType).attr('data-showusersearch');

			if(ShowTextArea == "True"){
				if($j("#txtRecipientDistributionList", selectedTr).length > 0)
					if($j("#txtRecipientDistributionList", selectedTr).val() ==""){
						alert("Missing Recipient");
						return;
					}
			}
			else if(ShowUserSearch == "True"){
				if($j("#RecipientXUId", selectedTr).length > 0)
					if($j("#RecipientXUId", selectedTr).val() ==""){
						alert("Missing Recipient");
						return;
					}
			}
			
			//Event
			if(drpEvent.val() == ""){
				alert("Missing Event");
				return;
			}

			//Quote type
			if(lstQuoteType.length == 0){
				alert("Missing Quote Type");
				return;            
			}

			////Quote Status
			//if(lstQuoteStatus.length == 0){
			//	alert("Missing Quote Status");
			//	return;            
			//}

			//Division
			if(bmDivisoinId == 0){
				alert("Missing Division");
				return;
			}

			//Branch
			if(BranchList == "" || BranchList == "{}"){
				alert("Missing Branch");
				return;
			}

			//Commodity
			if(CommodityList == "" || CommodityList == "{}"){
				alert("Missing Commodity");
				return;
			}

			//Email Address Field
			if(drpEmailAddressFieldName.val() == ""){
				alert("Missing Email Address Field");
				return;
			}
            
			////email Subject
			//if(txtEmailSubject.val() == ""){
			//	alert("Missing Email Subject");
			//	return;            
			//}

			////email Body
			//if(txtEmailBody.val() == ""){
			//	alert("Missing Email Body");
			//	return;            
			//}
			return 'Valide';
		}
		
		function SetRowControlsVisibility(EditMode, selectedTr) {
			if (EditMode) {
				$("[hide-on-edit]", selectedTr).hide();
				$("[show-on-edit]", selectedTr).fadeIn(1500);
			}
			else {
				$("[hide-on-edit]", selectedTr).fadeIn(1500);
				$("[show-on-edit]", selectedTr).hide();
			}
		}
		function AdjustTableCss(TableId){
			var rowIndex = 0;
			$.each($j("#"+TableId+">tbody>tr[id=trDataRow]"), function () {
				if(rowIndex++ % 2 == 0)
					$j(this).attr('class',"rl");
				else
					$j(this).attr('class',"rd");
			});
		}
	</script>
</asp:Content>