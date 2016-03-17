// Version: "11.0.5704.0"
// Copyright (c) Microsoft Corporation.  All rights reserved.
// _lcid="1033" _version="11.0.5704.0"
// _localbinding
function spssbSTAMP(notificationTimestamp)
{
	document.forms[0].elements["spssbTS"].value = notificationTimestamp;
}

function spssbALERT(prefix, whoFiredEvent, alertId)
{
	document.forms[0].elements["subscriptionId"].value = alertId;
	spssbSUBMIT(prefix, whoFiredEvent);
}

function spssbSUBMIT(prefix, whoFiredEvent)
{
	document.forms[0].elements[_ppsi(prefix, 'spssWFEH')].value = whoFiredEvent;
	document.forms[0].submit();
}

function spssbDN(prefix, alertId, catId, docId, timestamp)
{
	document.forms[0].elements["spssbCat"].value = catId;
	document.forms[0].elements["spssbDoc"].value = docId;
	spssbSTAMP(timestamp);
	spssbALERT(prefix, 'DeleteNotification', alertId);
}

function spssbDS(prefix, alertId)
{
	spssbALERT(prefix, 'DeactivateAlert', alertId);
}

function spssbAS(prefix, alertId)
{
	spssbALERT(prefix, 'ActivateAlert', alertId);
}

function spssbDES(prefix, alertId)
{
	if (spssbCONF('spssbDeleteAlertConfirmation'))
		spssbALERT(prefix, 'DeleteAlert', alertId);
}

function spssbDSN(prefix, alertId, newest)
{
	spssbSTAMP(newest);
	if (spssbCONF('spssbDeleteAlertResultsConfirmation'))
		spssbALERT(prefix, 'DeleteAlertNotifications', alertId);
}

function spssbDAN(prefix, newest)
{
	spssbSTAMP(newest);
	if (spssbCONF('spssbDeleteAllResultsConfirmation'))
		spssbSUBMIT(prefix, 'DeleteAllNotifications');
}

function spssbSDAN(prefix, newest)
{
	spssbSTAMP(newest);
	if (spssbCONF('spssbDeleteAllResultsConfirmation'))
		spssbSUBMIT(prefix, 'DeleteAllSingletonNotifications');
}

function spssbDAS(prefix)
{
	if (spssbCONF('spssbDeleteAllAlertsConfirmation'))
		spssbSUBMIT(prefix, 'DeleteAllAlerts');
}

function spssbDEAS(prefix)
{
	spssbSUBMIT(prefix, 'DeactivateAllAlerts');
}

function spssbAAS(prefix)
{
	spssbSUBMIT(prefix, 'ActivateAllAlerts');
}

function spssbSDAS(prefix)
{
	spssbSUBMIT(prefix, 'DeleteAllSingletonAlerts');
}

function spssbSDEAS(prefix)
{
	spssbSUBMIT(prefix, 'DeactivateAllSingletonAlerts');
}

function spssbSAAS(prefix)
{
	spssbSUBMIT(prefix, 'ActivateAllSingletonAlerts');
}

function spssbOnshd(prefix, ct, eid, th, ts)
{
	Onshd(prefix, ct, eid, th, ts);
}

function spssbCONF(MsgID)
{
	var msg = document.forms[0].elements[MsgID].value;
	return window.confirm(msg);
}
