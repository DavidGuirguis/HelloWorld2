// Version: "11.0.5704.0"
// Copyright (c) Microsoft Corporation.  All rights reserved.
// _lcid="1033" _version="11.0.5704.0"
// _localbinding
function spslcLBP(
	oItem,
	sUrl, 
	sAlertType,
	sObjectDefinition,
	sObjectUrl,
	sObjectDisplay,
	sSuggestedTitle,
	sXmlParameters)
{
	CancelHrefProcessing();

	var form = document.forms[0];

	var action = form.action;
	var method = form.method;
	var target = form.target;

	var bRestore__VIEWSTATE = false;
	var obj__VIEWSTATE = form.elements["__VIEWSTATE"];

	sUrl = GetUrlToReturnTo(oItem, sUrl);

	try {

		form.method = 'POST';
		form.action = document.forms[0].elements["spslcCreationPageUrl"].value;

		form.target = '_parent';

		document.forms[0].elements["UrlToReturnTo"].value = sUrl;
		document.forms[0].elements["SubscriptionType"].value = sAlertType;
		document.forms[0].elements["ObjectDefinition"].value = sObjectDefinition;
		document.forms[0].elements["ObjectDisplay"].value = sObjectDisplay;
		document.forms[0].elements["ObjectUrl"].value = sObjectUrl;
		document.forms[0].elements["SuggestedTitle"].value = sSuggestedTitle;
		document.forms[0].elements["XmlParameters"].value = sXmlParameters;

		if ("object" == typeof(obj__VIEWSTATE))
		{
			obj__VIEWSTATE.parentNode.removeChild(obj__VIEWSTATE);
			bRestore__VIEWSTATE = true;
		}

		if (typeof(window.__smartNav) == 'object') {
			document.detachEvent('onstop', window.__smartNav.stopHif);
			form.submit = form._submit;
		}
		form.submit();

	}
	finally
	{

		form.action = action;
		form.method = method;
		form.target = target;
		if (bRestore__VIEWSTATE)
		{
			form.appendChild(obj__VIEWSTATE);
		}
	}
}

function GetUrlToReturnTo(oItem, sUrl)
{

	var sItemId = GetItemId(oItem);
	if (sItemId != '')

		sItemId = '#' + sItemId;

	if (sUrl != null)
		sUrl = RemoveMySuffix(sUrl);

	if (sUrl == null || sUrl == '')
		if (document.getElementById && document.forms[0].elements["ReturnToMeURL"] != null)
			sUrl = RemoveMySuffix(document.forms[0].elements["ReturnToMeURL"].value);
	if (sUrl == null || sUrl == '')
		sUrl = RemoveMySuffix(window.parent.location.href);

	if (sItemId == '')
		return sUrl;

	if (sUrl.indexOf('?') < 0 || sUrl.substring(sUrl.indexOf('?') + 1).length == 0)
		return sUrl + sItemId;

	return sUrl + '&__=' + sItemId;
}

function RemoveMySuffix(str)
{
	if (str == '' || str == null)
		return '';
	var suffix = str.indexOf('&__=#');
	if (suffix >= 0) return str.substring(0, suffix);

	suffix = str.indexOf('?__=#');
	if (suffix >= 0) return str.substring(0, suffix);

	suffix = str.indexOf('#');
	if (suffix >= 0) return str.substring(0, suffix);

	suffix = str.indexOf('&__=');
	if (suffix < 0 || suffix + '&__='.length < str.length)
		return str;
	return str.substring(0, suffix);
}

function GetItemId(oItem)
{
	if (oItem == null || oItem == '')
	{
		if (window.event == null)
			return '';
		if (window.event.srcElement.getAttribute &&
			window.event.srcElement.getAttribute('id') != null)
			return window.event.srcElement.getAttribute('id');
		return '';
	}
	if (typeof(oItem) != 'object')
		return oItem;
	if (oItem.getAttribute && oItem.getAttribute('id') != null)
		return oItem.getAttribute('id');
	return '';
}

function CancelHrefProcessing()
{
	if (window.event != null)
	{
		if (window.event.srcElement.tagName == "A")
			window.event.returnValue = false;
	}
}

function UrlEncode(str)
{
	return canonicalizedUtf8FromUnicode(str);
}

function spslcELBG(
	oItem,
	sAlertId)
{
	CancelHrefProcessing();
	var sUrl = GetUrlToReturnTo(oItem, null);
	var url = document.forms[0].elements["spslcEditPageUrl"].value + '?' +
		"UrlToReturnTo" + '=' + UrlEncode(sUrl) + '&' +
		"subscriptionId"   + '=' + UrlEncode(sAlertId);
        window.location.href = url;
}

function spslcLBG(
	oItem,
	sUrl,
	sAlertType,
	sObjectDefinition,
	sObjectUrl,
	sObjectDisplay,
	sSuggestedTitle,
	sXmlParameters)
{
	CancelHrefProcessing();
	var sUrl = GetUrlToReturnTo(oItem, sUrl);
	var url = document.forms[0].elements["spslcCreationPageUrl"].value + '?' +
		"UrlToReturnTo"        + '=' + UrlEncode(sUrl)    + '&' +
		"SubscriptionType"        + '=' + UrlEncode(sAlertType)        + '&' +
		"ObjectDefinition" + '=' + UrlEncode(sObjectDefinition) + '&' +
		"ObjectUrl"        + '=' + UrlEncode(sObjectUrl)        + '&' +
		"ObjectDisplay"    + '=' + UrlEncode(sObjectDisplay)    + '&' +
		"SuggestedTitle"   + '=' + UrlEncode(sSuggestedTitle)   + '&' +
		"XmlParameters"    + '=' + UrlEncode(sXmlParameters);
        window.location.href = url;
}

function spssbGetMyAlerts(view)
{
	var url = document.forms[0].elements["spslcMyAlertsPageUrl"].value;
	return url + view;
}

function spssbMyAlert(view)
{
	spssbMyAlerts('?ConsoleView=' + view);
}

function spssbMyAlerts(view)
{
        window.location.href = spssbGetMyAlerts(view);
}

