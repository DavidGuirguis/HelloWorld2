// Common Used Functions Go Here

// = isObject ------------------------
function isObject(obj) {
	return (typeof(obj) == "object") && (obj != null);
}
//:isObject

function Trim(str) {
	if(str == null  || typeof(str) == "undefined") return str;
	
	return str.toString().trim();
}

function RTrim(str) {
    return (str || "").toString().replace(/\s+$/g, "");
}

function printHidden(sUrl) {
	try{
		if (window.navigator.userAgent.indexOf("MSIE ")!=-1 && navigator.appVersion.substr(0, 1) >= 4){
		    document.body.insertAdjacentHTML("afterBegin", 
				"<iframe name='printHiddenFrame' src='/library/images/spacer.gif' width='0' height='0'></iframe>");
			doc = printHiddenFrame.document;
			doc.open();
			doc.write(
				"<frameset onload='parent.printFrame(printMe);' rows=\"100%\">" +
				"<frame name=printMe src=\"" + sUrl + "\">" +
				"</frameset>");
			doc.close();
		}
		else{
			document.location.href=sUrl;
		}
	}catch(e){
		var x = window.open(sUrl, "sl_print", "width=500,height=400,left=100,top=100,toolbar=yes,menubar=yes,resizable=yes");
		x.focus();
		x.print();
	}
}

function printFrame(frame) {
  frame.focus();
  frame.print();
  return;
}

var hiddenUrlOpenerOptions = {};
function openUrlHidden(sUrl, readyStateChangeCallback) {
    
    if (window.navigator.userAgent.indexOf("MSIE ") != -1 && navigator.appVersion.substr(0, 1) >= 4) {
        var frameAttribs = "";

        //setup callback
        if (typeof (readyStateChangeCallback) == "function") {
            var keySuffix = new Date().getTime();
            var optionKey = sUrl.toLowerCase() + keySuffix;
            hiddenUrlOpenerOptions[optionKey] = { readyStateChangeCallback: readyStateChangeCallback };

            frameAttribs = " keySuffix='" + keySuffix + "' url='" + sUrl.replace(/(['"])/gi, "\$1") + "' onreadystatechange='hiddenFrameOnReadyStateChange(this);' ";
        }
        
	    document.body.insertAdjacentHTML("afterBegin",
			"<iframe id='HiddenFrame' name='HiddenFrame' src='/library/images/spacer.gif' width='0' height='0'"
			+ frameAttribs + "></iframe>");

	    HiddenFrame.document.open();
		HiddenFrame.document.location.href = sUrl;
		HiddenFrame.document.close();
	}else {
		document.location.href=sUrl;
	}
}

function hiddenFrameOnReadyStateChange(oFrame) {
    var options = hiddenUrlOpenerOptions[oFrame.url.toLowerCase() + oFrame.keySuffix];

    if (options) {
        if (typeof (options.readyStateChangeCallback) == "function") {
            options.readyStateChangeCallback(oFrame);
        }
    }
}
/**************** Open Window ****************************/
var applicationPath = "";

function openWin(url, width, height, name, params, returnHandler) {
	// inside the application
    if (url.startsWith("modules/"))
		url		= applicationPath + url;

	// window name
	if(name == null) name = "XPop_" + Math.round(Math.random() * 1000) + "_" + Math.round(Math.random() * 100);
	
	// params
	var defaultParams = {
		width: parseInt(width)
		,height: parseInt(height)
		
		,scrollbars: "yes"
		,menubar: "yes"
		,toolbar: "yes"
		,location: "no"
		,status: "yes"
		,resizable: "yes"
	};
	
	var arrParams;
	// overriding default settings
	if(params != null) {
		params	= params.toLowerCase().replace(/\s*/g, "");
		arrParams = params.split(",");
		for(var i=0; i<arrParams.length; i++){
			var arrData = arrParams[i].split("=");
			defaultParams[arrData[0]] = arrData[1];
		}
	}

	// dimentions
	if(isNaN(defaultParams.width)) defaultParams.width = 580;
	if(isNaN(defaultParams.height)) defaultParams.height = 480;
	
	// position
	var offsetHeight = 30;
	
	// height offset
	if(defaultParams["menubar"] == "yes") offsetHeight += 30;	
	if(defaultParams["toolbar"] == "yes") offsetHeight += 30;	
	if(defaultParams["location"] == "yes")offsetHeight += 30;	
	if(defaultParams["status"] == "yes")  offsetHeight += 30;	

	var adjuster = function(pos){ return (pos < 0) ? 10 : pos; };

	if(defaultParams["left"] == null) defaultParams.left = isNaN(defaultParams.width) ? null : adjuster((screen.width - defaultParams.width)/2);
	if(defaultParams["top"] == null) defaultParams.top  = isNaN(defaultParams.height) ? null : adjuster((screen.height - defaultParams.height - offsetHeight)/2);
 
	// get params from object
	arrParams = [];
	for(var key in defaultParams){
		if(defaultParams[key] != null) arrParams.push(key + "=" + defaultParams[key]);
	}
	params = arrParams.join(",");

	x = window.open(
		url, 
		name, 
		params);
	
	if(x) x.focus();	
	
	if(returnHandler == true) return x;
}

function goMod(module, params, tt) {
	var url = applicationPath + module;

    if(params == null) params = "";
    if(tt == null) tt = "";

    // template
    if(tt != "") {
        if(params != "" && !params.endsWith('&'))  params += "&";
        params += "TT=" + tt;
    }

    if (params != "") {
        if (params.startsWith('&')) params = params.substr(1);
        url += "?" + params;
    }
	
	document.location.href	= url;
}

/*-----------------------------------------------------------------------*/
/*-	 Function : SetDefaultButton
/*-----------------------------------------------------------------------*/
var x_defaultButton	= null;

function registerDefaultButton(f) {
    try {
		if(event.keyCode == 13) {
			// prevent the default submission buttion get clicked
			if(x_defaultButton == "" 
			    || canCancelBubble()
			    || !canSubmit() ) {
				event.cancelBubble = true;
				event.returnValue = false;
			}
			
			try{
				if(typeof(x_defaultButton) == "string" && x_defaultButton != "" && canSubmit() ) f.all[x_defaultButton].click();			
			}catch(e){
			}
		}
	}catch(e){
	}
}

function getSrcElementType() {
	if(isObject(event.srcElement) && typeof(event.srcElement.type) == "string")
		return event.srcElement.type;
	else
		return null;
}

function canSubmit() {
	var eleType = getSrcElementType();

	if(eleType == "textarea" || eleType == "reset" || eleType == null)
		return false;
	else
		return true;
}

function canCancelBubble() {
	if(getSrcElementType() == "textarea")
		return false;
	else
		return true;
}
/*-----------------------------------------------------------------------*/

// get parent element
function getParentElementByTagName(obj, tagName, elementIDorMapFunction) {
	var oParent = obj.parentNode;
	this.id = null;
	var mapFunc = null;
	
	// can't find parent element
	if(isObject(oParent) == false)
		return null;
	
	if(typeof(elementIDorMapFunction) == "string"){
	    //check exact element id
	    this.id = elementIDorMapFunction;
	    mapFunc = function(element){
	        return this.id == element.id;
	    }.bind(this); 
    }
    else if(typeof(elementIDorMapFunction) == "function")
        //custom map func
        mapFunc = elementIDorMapFunction;
	
	if(mapFunc == null) {
		// check the object by tagName
		while( isObject(oParent) && (oParent.tagName != "HTML") && (oParent.tagName != tagName)) 
			oParent = oParent.parentNode;
	}
	else {
		// check the object by tagName and map func
		while( isObject(oParent) && (oParent.tagName != "HTML") && !((oParent.tagName == tagName) && mapFunc(oParent))  ) 
			oParent = oParent.parentNode;
	}
	
	if( isObject(oParent) && (oParent.tagName != "HTML") ) {
		return oParent;
	}
	else {
		return null;
	}
}

// get element(s) by tagname  
// -  id: integer, to return the object by index in the collection
//		  string   to return the object by the object's name or id (first occurrence)
//		  omitted  return the collection
function getElementsByTagName(obj, tagName, id, checkStartsWith) {
	if( (isObject(obj) == false) || (typeof(obj.getElementsByTagName) == "undefined") ) 
		return null;

	var coll = obj.getElementsByTagName(tagName);

	if(id == null) {
		// 'id' param omitted
		return coll
	}
	else {
		if(coll.length == 0) return null;
	
		if(typeof(id) == "number") {
			// get object by index
			return coll[id];				
		}
		else {
			var idLen = id.length;
		
			for(var i=0; i<coll.length; i++) {
				// name attr presents
				if( (typeof(coll[i].name) == "string") && ( (/* check starts with */checkStartsWith && coll[i].name.substr(0,idLen) == id) || (coll[i].name == id) ) )
					return coll[i];
				else if( (typeof(coll[i].id) == "string") && ( (/* check starts with */checkStartsWith && coll[i].id.substr(0,idLen) == id) || (coll[i].id == id) ) )
					return coll[i];
			}			
		}	
	}	
	return null;
}

//--------------------------------------------------
// StyleSheet
//--------------------------------------------------
function getStyleSheetRule(selectorText, vStyleSheetIndex, iStyleSheetSubIndex) {
	var styleSheet = null;
	
	if(iStyleSheetSubIndex == null)
		styleSheet = document.styleSheets[vStyleSheetIndex];
	else
		styleSheet = document.styleSheets[vStyleSheetIndex, iStyleSheetSubIndex];

	if(styleSheet == null) return null;
	
	var rule = null;
	
	for(var i=0; i<styleSheet.rules.length; i++) {
		if(styleSheet.rules(i).selectorText == selectorText) {
			rule = styleSheet.rules(i);
		}
	}
	
	return rule;
}

function Collection()
{
	function Item(Index)
	{
		var Obj = null;
		if(Index != null)
		{
			var realIndex = parseInt(Index);
			if (!isNaN(realIndex) && realIndex >= 0 && realIndex < this.length)
				Obj = this[realIndex];
		}
		return Obj;
	}
	function Find(Object)
	{
		var i;
		var obj = null;
		for (i=0; i<this.length; i++)
		{
			if (this[i] == Object)
			{
				obj = this[i];
				break;
			}
		}
		return obj;
	}
	function FindByName(Name, Qualifier)
	{
		var i;
		var obj = null;
		for (i=0; i<this.length; i++)
		{
			if (this[i].Name == Name && this[i].Qualifier == Qualifier)
			{
				obj = this[i];
				break;
			}
		}
		return obj;
	}
	function Add(Object)
	{
		var ArraySize = this.length;
		this[ArraySize] = Object;
		return this[ArraySize];
	}
	function Remove(Index)
	{
		var i;
		var realIndex = parseInt(Index);
		if (isFinite(realIndex) && realIndex >= 0 && realIndex < this.length)
		{
			for (i=realIndex; i<this.length-1; i++)
				this[i] = this[i+1];
			this.length--;
		}
	}
	function RemoveObject(Object)
	{
		var i;
		for (i=0; i<this.length; i++)
		{
			if (this[i] == Object)
			{
				this.Remove(i);
				break;
			}
		}
	}
	function Count()
	{
		return this.length;
	}
	var obj = Array();
	obj.Item = Item;
	obj.Count = Count;
	obj.Add = Add;
	obj.Remove = Remove;
	obj.Find = Find;
	obj.FindByName = FindByName;
	obj.RemoveObject = RemoveObject;
	return obj;
}

/***************************************************
** StartsWith
****************************************************/
function StartsWith(str, strStart) {
	if(str == null || strStart == null) return false;

	var lenStr = str.length;
	var lenStrStart = strStart.length;

	if(lenStrStart > lenStr) return false;
	
	return str.substr(0, lenStrStart) == strStart;
} // StartsWith

function StartsWith_(str) {
	return StartsWith(this, str);
} // StartsWith_


/***************************************************
** EndsWith
****************************************************/
function EndsWith(str, strEnd) {
	if(str == null || strEnd == null) return false;

	var lenStr = str.length;
	var lenStrEnd = strEnd.length;

	if(lenStrEnd > lenStr) return false;
	
	return str.substr(lenStr - lenStrEnd) == strEnd;
} // EndsWith

function EndsWith_(str) {
	return EndsWith(this, str);
} // EndsWith_

/*********************************************************/
// Add a extention functions to String constructor.
String.prototype.test = function(re){
    return re.test(this);
}
String.prototype.containsWord = function(str){
    re = new RegExp("\\b" + str + "\\b","ig");
    return re.test(this);
}
String.prototype.trim = function()
{
    // Use a regular expression to replace leading and trailing 
    // spaces with the empty string
    return this.replace(/(^\s*)|(\s*$)/g, "");
}
String.prototype.IsNullOrWhiteSpace = function () {
    return this == null || Trim(this).length == 0;
}

String.prototype.startsWith = StartsWith_;
String.prototype.endsWith = EndsWith_;

function isNullOrUndefined(val) {
    return val == null || typeof (val) == 'undefined';
}

function getStringFormatPlaceHolderRegEx(placeHolderIndex) {
    return new RegExp('({)?\\{' + placeHolderIndex + '\\}(?!})', 'gm')
}

function cleanStringFormatResult(txt) {
    if (txt == null) return "";

    return txt.replace(getStringFormatPlaceHolderRegEx("\\d+"), "");
}

String.prototype.format = function () {
    var txt = this.toString();
    for (var i = 0; i < arguments.length; i++) {
        var exp = getStringFormatPlaceHolderRegEx(i);
        txt = txt.replace(exp, (isNullOrUndefined(arguments[i]) ? "" : arguments[i]));
    }
    return cleanStringFormatResult(txt);
}
String.format = function () {
    var s = arguments[0];
    if (s == null) return "";

    for (var i = 0; i < arguments.length - 1; i++) {
        var reg = getStringFormatPlaceHolderRegEx(i);
        s = s.replace(reg, (isNullOrUndefined(arguments[i + 1]) ? "" : arguments[i + 1]));
    }
    return cleanStringFormatResult(s);
}
/***********************************************/

// TableHelper
var TableHelper = {
	registerHighlighter : function(element, cssHighlighter, isRegisterable) {
		// table
		if(element == null) return;
		
		if (typeof element != 'object') {
			element = document.getElementById(element);
			if(element == null || typeof element != 'object') return;
		};
		if(element.tagName != "TABLE") return;
		
		// cssHighlighter
		if (typeof cssHighlighter != 'string') {
			cssHighlighter	= "rowHiLit";
		};
		
		// isRegisterable
		if (typeof isRegisterable != 'function') {
			isRegisterable = function(table, row){
				return row.className == "rl" || row.className == "rd";
			};
		}
		
		var tBody,row,i,j;
		for(i=0; i < element.tBodies.length; i++){
			tBody = element.tBodies[i];
			
			if(tBody.rows.length > 500) continue;
			
			for(j=0; j < tBody.rows.length; j++){
				row = $j(tBody.rows[j]);
				if (isRegisterable(element, row[0])) {
                    row.attr("cssHilit", cssHighlighter);
                    row.mouseover(TableHelper.hilitMouseOver);
					row.mouseout(TableHelper.hilitMouseOut);
				}
			}
		};
	}
	,hilitMouseOver : function() {
		var row = this;

		if (row.className.indexOf(row.getAttribute("cssHilit")) == -1) 
		{
		    row.className += " " + row.getAttribute("cssHilit");
		}
	}
	
	,hilitMouseOut : function(row) {
		var row = this;

		row.className = row.className.replace(" " + row.getAttribute("cssHilit"), "");
	}
}
//- /TableHelper --
function isEditable(obj, containerTagName, containerID, checkStartsWith) {
	// not a object
	if(isObject(obj) == false) return false;
	
	// disabled
	if(obj.disabled) return false;
	
	// readonly
	if(typeof(obj.readOnly) != "undefined" && obj.readOnly) return false;
	
	// not visible
	if(isVisible(obj) == false) return false;
	
	// container is not visible
	if(typeof(containerTagName) == "string" && typeof(containerID) == "string"){
		// specific container is specified
		var elementIDorMapFunction = typeof(containerID) == "string" && checkStartsWith ? function(element){return element.id.startsWith(this.id);} : containerID;
		var oContainer = getParentElementByTagName(obj, containerTagName, elementIDorMapFunction);

		if(oContainer != null && typeof(oContainer) == "object")
			// check visibility
			return isVisible(oContainer);
		else
			// can't find
			return true;
	}
	else{
		// check all containers
		var oParent = obj.parentElement;
	
		while( (oParent != null) && (typeof(oParent) == "object") && (oParent.tagName != "HTML")){
			if(isVisible(oParent) == false) return false;
			
			oParent = oParent.parentElement;
		}
		
		return true;
	}
} // isEditable

function isVisible(obj) {
	if(obj.tagName == "INPUT" && obj.type == "hidden") 
		return false;
	else
		return obj.style.display.toLowerCase() != "none" && obj.style.visibility.toLowerCase() != "hidden"
} // isVisible

//---------------------------------------------------------------
// disableOnPostBack
//---------------------------------------------------------------
var optDisabled_DefinedOnly		= 0x01;		/* check property 'disabledOnPostBack' if it's true */
var optDisabled_AlsoOnServer	= 0x02;		/* do not send the data to server */
var disabledAtClient	= "client";			/* disable the elements at client only. Only usable when 'optDisabled_AlsoOnServer' flag is being used. */

var gFrmActive = null;
var gFrmPosting = false;

function cancelDisableOnPostBack() {
    if (gFrmActive == null) return;

    try {
        disableOnPostBack(gFrmActive, null, false);
    }
    catch (e) {
    }
}

function disableOnPostBack(oFrm, options, bDisabled) {
	var bDisableDefinedOnly  = false;
	var bDisableAlsoOnServer = false;
	
	// get options
	gFrmActive	= oFrm;
	
	bDisabled	= bDisabled != false;
	if(bDisabled == false) gFrmPosting = false;

	// change cursor
	document.body.style.cursor	= (bDisabled) ? "wait" : "auto";

	// exit here if the posting is in progress
	if(gFrmPosting) return false;
	
	// flag posting in progress		
	gFrmPosting	= true;

	if(!isNaN(options)) {
		bDisableDefinedOnly		= (options & optDisabled_DefinedOnly) == optDisabled_DefinedOnly;
		bDisableAlsoOnServer	= (options & optDisabled_AlsoOnServer) == optDisabled_AlsoOnServer;
	}

	// disable now
	if(bDisableAlsoOnServer) 
		// disable elements immediately, so the data WONT BE SENT to server
		disableOnPostBack_(bDisableDefinedOnly, true, bDisabled);

	if(bDisabled)
		// delay disable elements to ALLOW TO SEND the data to server
		setTimeout("disableOnPostBack_(" + bDisableDefinedOnly + ", false, " + bDisabled + ")", 1);
	else
		disableOnPostBack_(bDisableDefinedOnly, false, bDisabled);
	
	return true;
}

function disableOnPostBack_(bDisableDefinedOnly, bDisableAtServer, bDisabled) {
	// Looking for non-input elements in the form
	for(var i=0; i<gFrmActive.elements.length; i++){
		// form is not posting, exit from here
		if(gFrmPosting == false) return;
		
		if((gFrmActive.elements[i].tagName != "INPUT") && canDisable(gFrmActive.elements[i], bDisableDefinedOnly, bDisableAtServer))
			gFrmActive.elements[i].disabled = bDisabled;
	}
	
	// Input Elements
	var oInputs = gFrmActive.getElementsByTagName("INPUT");
	for(var i=0; i<oInputs.length; i++) {
		// form is not posting, exit from here
		if(gFrmPosting == false) return;

		if(canDisable(oInputs[i], bDisableDefinedOnly, bDisableAtServer))
			oInputs[i].disabled = bDisabled;
	}
} // disableOnPostBack

function canDisable(obj, bDisableDefinedOnly, bDisableAtServer) {
	if(typeof(obj.disabled) == "undefined") return false;

	var sDisabledFlagValue = obj.disabledOnPostBack;
	var bDisabledFlagDefined = (typeof(sDisabledFlagValue) != "undefined");
	
	// flag not defined
	if( bDisabledFlagDefined == false ) {
		// eliminate if the flag is required but not present
		if( bDisableDefinedOnly ) return false;
			
		// set the flag value to 'disabledAtClient' if not defined. ie send to server as it is.
		sDisabledFlagValue = disabledAtClient;
	}

	// format the flag
	sDisabledFlagValue = sDisabledFlagValue.toLowerCase();
	
	// element type
	var type = (typeof(obj.type) == "undefined") ? "" : obj.type;
	
	if(bDisableAtServer) {
		// disable at server
		return sDisabledFlagValue == "true";
	}
	else {
		// disable at client
		if(type == "hidden") 
			// ignore hidden fields
			return false;
		else
			return (sDisabledFlagValue == "true") || (sDisabledFlagValue == disabledAtClient);
	}
} // canDisable
//---------------------------------------------------------

function RadioGroup(elementName) {
	var _selectedValue = null;
	var oElements = document.getElementsByName(elementName);
	
	for(var i=0; i<oElements.length; i++)
		if(oElements[i].checked) {
			_selectedValue = oElements[i].value;
			break;
		}
	
	this.selectedValue = _selectedValue;
}

function refreshOpener(closeCurrent, refreshCurrent)
{
	try{
		if(typeof(opener.refreshPage) == "function")
			opener.refreshPage();
		else
			opener.location.replace(opener.location.href.replace(/#.*$/g, ""));
	}
	catch(e)
	{
	}	

	if(closeCurrent == true){
		window.close();
		return;
	}
	
	if(refreshCurrent == true){
	    if(event) event.returnValue = false;
	    window.location.replace(window.location.href.replace(/#.*$/g, ""));	    
	}
}

/** Send/Receive data **/
function sendToOpener(data, closeWin){
	try{
		top.opener.handleData(data);
	}catch(e){	
	}
	
	if(closeWin == true) window.close();
}

/* Layout fix */
function fixBottomPaneTop(element, parentNodeID){
    if(element.parentNode && element.parentNode.id == parentNodeID){
        var top = 0;
        var container = element.parentNode;
        
        for(var i=0; i<container.childNodes.length; i++){
            if(false == container.childNodes[i].canHaveHTML) continue;
            if(container.childNodes[i] == element) break;
            
            top += container.childNodes[i].offsetHeight;
        }
        
        top = container.offsetHeight - top - element.offsetHeight - 2;
        
        return top > 0 ? top : 0;
    }
    else{
        return 0;
    }
}

function isEmptyString(str){
	if(typeof(str) == "string")
		return str.trim().length == 0;
	
	return true;
}//- isEmptyString


//register interactive mode detector
var cookieNameInteractiveModeDetector = "x:InteractiveMode";

function setInteractiveModeDetectorCookie() {
    document.cookie = cookieNameInteractiveModeDetector + "=1";
}

function registerInteractiveModeDetector(arrForms) {

    document.cookie = cookieNameInteractiveModeDetector + "=0";

    $j(function () {
        //convert to array
        if (typeof (arrForms) == "string" || !arrForms.length) arrForms = [arrForms];

        for (var i = 0; i < arrForms.length; i++) {
            if (typeof (arrForms[i]) == "string") arrForms[i] = document.getElementsByName(arrForms[i]);

            var arrChildForms = arrForms[i];

            //convert to array
            if (!arrForms[i].length || arrForms[i].elements) arrChildForms = [arrForms[i]];

            for (var j = 0; j < arrChildForms.length; j++) {
                var oForm = arrChildForms[j];

                if (isObject(oForm) && oForm.tagName == "FORM") {
                    $j(oForm).submit(function () {
                        setInteractiveModeDetectorCookie();
                    });
                }
            }
        }
    });
}

//reset
document.cookie = cookieNameInteractiveModeDetector + "=; expires=Thu, 2 Aug 2001 20:47:11 UTC;";
//-register interactive mode detector

//<BEGIN-fxiao, 2008-11-10>
// form validator wrapper
function g_validate(f) {
    try {
        return validate(f);
    } catch (e) {
        alert("Unexpected error: " + e.description);
        return false;
    }
} // g_validate

// HTMLEncode
function HTMLEncode(Value) {
    var XMLString = "";
    var re = /&/g;
    XMLString = Value.replace(re, "&amp;");
    re = /</g;
    XMLString = XMLString.replace(re, "&lt;");
    re = />/g;
    XMLString = XMLString.replace(re, "&gt;");
    re = /"/g;
    XMLString = XMLString.replace(re, "&quot;");
    return XMLString;
}
function HTMLEncode_() {
    return HTMLEncode(this);
}

String.prototype.htmlEncode = HTMLEncode_;
//</END-fxiao, 2008-11-10>

Date.prototype.toISODateString = function () {
    var month = (this.getMonth() + 1).toString();
    var day = this.getDate().toString();

    if (month.length == 1) month = "0" + month;
    if (day.length == 1) day = "0" + day;

    return this.getFullYear() + "-" + month + "-" + day;
}

if(!Function.prototype.bind){
    Function.prototype.bind = function(o) {
	    if(!window.__objs) {
		    window.__objs = [];
		    window.__funcs = [];
	    }

	    var objId = o.__oid;
	    if(!objId)
		    __objs[objId = o.__oid = __objs.length] = o;

	    var me = this;
	    var funcId = me.__fid;
	    if(!funcId)
		    __funcs[funcId = me.__fid = __funcs.length] = me;

	    if(!o.__closures)
		    o.__closures = [];

	    var closure = o.__closures[funcId];
	    if(closure)
		    return closure;

	    o = null;
	    me = null;

	    return __objs[objId].__closures[funcId] = function() {
		    return __funcs[funcId].apply(__objs[objId], arguments);
	    };
    }
}

function isCustomerNumberValidForCustomerView(customerNo) {
    var custNo_New = "NON-DBS";

    if (typeof (customerNo) == "undefined"
        || customerNo == null
        || customerNo.toString().trim() == ""
        || customerNo.toString().trim().toUpperCase() == custNo_New
    )
        return false;

    return true;
}
//-isCustomerNumberValidForCustomerView

//Hide/show Pane using jQuery
var childElementsVisibilitySelectorFilter = "input, select, textarea"; //used to hide/show child elements that could be shown in IE6 even though the parent is hidden
function hidePane(element) {
    if (typeof (element.jquery) == "undefined") element = jQuery(element);
    element.hide.apply(element, jQuery.makeArray(arguments).slice(1));
    //hide all children inputs
    element.find(childElementsVisibilitySelectorFilter).hide();

    return element;
};
function showPane(element) {
    if (typeof (element.jquery) == "undefined") element = jQuery(element);
    element.show.apply(element, jQuery.makeArray(arguments).slice(1));
    //show all children inputs
    element.find(childElementsVisibilitySelectorFilter).show();

    return element;
};
//-Hide/show Pane using jQuery

//copy stylesheets
function copyStyleSheets(srcDoc, destDoc) {
    var destDocHead = destDoc.getElementsByTagName("head")[0];
    var srcDocPath = srcDoc.location.pathname;
    if (!srcDocPath.endsWith("/")) {
        var ipos = srcDocPath.lastIndexOf("/");
        var scriptName = srcDocPath.substr(ipos + 1);
        if (scriptName.indexOf(".") == -1)
            srcDocPath += "/";
        else
            srcDocPath = srcDocPath.substr(0, ipos + 1);
    }

    for (var i = 0; i < srcDoc.styleSheets.length; i++) {
        var oStyleSheetSource = srcDoc.styleSheets[i];
        var oStyleSheet = destDoc.createStyleSheet();

        //link stylesheet
        if (oStyleSheetSource.href.trim().length > 0) {
            var stylesheetHref = oStyleSheetSource.href.startsWith("..")
                ? (srcDocPath + oStyleSheetSource.href)
                : oStyleSheetSource.href
                ;
            var newStyleSheet = destDoc.createElement("<link rel='stylesheet' href='" + stylesheetHref + "' type='text/css'></link>");
            destDocHead.appendChild(newStyleSheet);

            continue;
        }

        //inline
        oStyleSheet.cssText = fixCssText(srcDocPath, oStyleSheetSource.cssText);

        for (var idxImport = 0; idxImport < oStyleSheetSource.imports.length; idxImport++) {
            oStyleSheet.imports[idxImport].cssText = fixCssText(srcDocPath, oStyleSheetSource.imports[idxImport].cssText);
        }
    }

    function fixCssText(docPath, cssText) {
        cssText = cssText.replace(/url\s*\(\s*(["'])([^\/])/gi, "url($1" + docPath + "$2");
        cssText = cssText.replace(/url\s*\(\s*([^\/"'])/gi, "url(" + docPath + "$1");
        return cssText;
    }
}
//-copy stylesheets

//valEmptyFields
function valEmptyFields(container) {
    if (typeof (container) == "undefined" || container == null) container = $j(document.body);
    if (!container.jquery) container = $j(container);

    var emptyFieldsFocused = false;
    var firstEmptyField = $j(null);
    var emptyFields = container.find(".requiredWrapper-Field")
        .map(function (i) {
            var self = $j(this);
            var hiddenWrapper = self.parents(":not(form):hidden");

            //ignore hidden fields
            if (hiddenWrapper.length > 0) return;

            var element = self.find("input,select,textarea");
            var val = element.val();

            if (val != null && val.trim().length == 0) {
                if (!emptyFieldsFocused) {
                    element.focus();

                    firstEmptyField = element;
                    emptyFieldsFocused = true;
                }
                return this;
            }
        })
    ;

    emptyFields.firstEmptyField = firstEmptyField;

    return emptyFields;
}
//-valEmptyFields

//toggleRequiredFieldClass
function toggleRequiredFieldClass(container) {
    if (typeof (container) == "undefined" || container == null) container = $j(document.body);
    if (!container.jquery) container = $j(container);

    var requiredFieldTitles = container.find(".display-requiredWrapper-Title");

    if (requiredFieldTitles.length == 0) {
        //edit mode
        container.find(".requiredWrapper-Title").find(".required").removeClass("required").addClass("display-required");
        container.find(".requiredWrapper-Title").removeClass("requiredWrapper-Title").addClass("display-requiredWrapper-Title");

        container.find(".requiredWrapper-Field").removeClass("requiredWrapper-Field").addClass("display-requiredWrapper-Field");
    }
    else {
        //display mode
        requiredFieldTitles.find(".display-required").removeClass("display-required").addClass("required");
        requiredFieldTitles.removeClass("display-requiredWrapper-Title").addClass("requiredWrapper-Title");
        container.find(".display-requiredWrapper-Field").removeClass("display-requiredWrapper-Field").addClass("requiredWrapper-Field");
    }
}
//-toggleRequiredFieldClass

//wrapFormField
function wrapFormFieldTitle(container, isMandatory, inEditMode) {
    if (!container.jquery) container = $j(container);

    isMandatory = isMandatory == true;
    inEditMode = inEditMode == true;

    if (isMandatory) {
        var prefix = inEditMode ? "" : "display-";
        if (container.find("[class*='requiredWrapper-Title']").length == 0) {
            container
                .append("<span class='" + prefix + "required'> *</span>")
                .wrapInner("<span class='" + prefix + "requiredWrapper-Title' />")
            ;
        }
    }
}
//-wrapFormField

Array.prototype.toHtmlListOptions = function () {
    var htmlBuilder = [];

    $j.each(this, function (i, item) {
        var value = "";
        var text = "";

        if (typeof (item) != "undefined") {
            if (item.constructor == Array) {
                if (item.length > 1) {
                    value = item[0].toString();
                    text = item[1].toString();
                }
                else {
                    value = item[0].toString();
                    text = value;
                }
            }
            else {
                value = item.toString();
                text = value;
            }

            htmlBuilder.push("<option value=\"" + value + "\">" + text + "</option>");
        }
    });

    return htmlBuilder.join("");
};
//-Array extensions


$(function () {
    $("#divErrors").dialog({ width: 550,
        //height: 400,
        draggable: true,
        position: 'center',
        resizable: false,
        modal: true,
        title: 'Error Message',
        autoOpen: false
    });

    jQuery('.numbersOnly').keyup(function () { this.value = this.value.replace(/[^0-9\.]/g, ''); });
});
function showErrors(errorContent) {
    $("#divErrorsContent").html(errorContent);
    $("#divErrors").dialog("open");
}

function closeErrors() {
    $("#divErrors").dialog("close");
}

//***************************************************************************************************************************************
//function txtSearchbleListKeyUp(txtSearchbleBoxName, hidSearchbleBoxName, arrListCode, txtCodeOnlyBoxName) {
//<CODE_TAG_103329>
//function txtSearchbleListKeyUp(txtSearchbleBoxName, hidSearchbleBoxName, arrListCode, txtCodeOnlyBoxName, separator) {
function txtSearchbleListKeyUp(txtSearchbleBoxName, hidSearchbleBoxName, arrListCode, txtCodeOnlyBoxName, separator, chargeCodeListInd) {  //<CODE_TAG_105100>lwang
    if (separator == undefined)
        separator = ','; //</CODE_TAG_103329>
    //</CODE_TAG_103329>
    var strkey = $("[id*=" + txtSearchbleBoxName + " ]").val();
    //displaySearchbleList(strkey, txtSearchbleBoxName, hidSearchbleBoxName, arrListCode, txtCodeOnlyBoxName);
    displaySearchbleList(strkey, txtSearchbleBoxName, hidSearchbleBoxName, arrListCode, txtCodeOnlyBoxName, separator);
    displaySearchbleList(strkey, txtSearchbleBoxName, hidSearchbleBoxName, arrListCode, txtCodeOnlyBoxName, separator, chargeCodeListInd);//<CODE_TAG_105100>lwang
}
//function displaySearchbleList(strkey, txtSearchbleBoxName, hidSearchbleBoxName, arrListCode, txtCodeOnlyBoxName) {
//<CODE_TAG_103329>
/*function displaySearchbleList(strkey, txtSearchbleBoxName, hidSearchbleBoxName, arrListCode, txtCodeOnlyBoxName) {
    displaySearchbleList(strkey, txtSearchbleBoxName, hidSearchbleBoxName, arrListCode, txtCodeOnlyBoxName,",")
}*/

//function displaySearchbleList(strkey, txtSearchbleBoxName, hidSearchbleBoxName, arrListCode, txtCodeOnlyBoxName, separator) {
function displaySearchbleList(strkey, txtSearchbleBoxName, hidSearchbleBoxName, arrListCode, txtCodeOnlyBoxName, separator, chargeCodeListInd) {	 //<CODE_TAG_105100>
    if (separator == undefined)
        separator = ','; //</CODE_TAG_103329>
    //<CODE_TAG_105100> 
    if (typeof chargeCodeListInd === 'undefined' || (!chargeCodeListInd))  //chargeCodeInd used to decide if this call is for labor/Misc charge code list, if gets "Y" then Yes
        chargeCodeListInd = "";
    //</CODE_TAG_105100>

    var div_position = $("[id*=" + txtSearchbleBoxName + "]").offset(); //  position();
    var div_top = div_position.top + 15;
    var div_left = div_position.left;
    var div_width = $("[id*=" + txtSearchbleBoxName + "]").width();
    $("#divSearchbleList").css({ "left": div_left, "top": div_top });
    $("#divSearchbleList").width(div_width);

    if (txtCodeOnlyBoxName == null)
        txtCodeOnlyBoxName = "";

    var strList = "<ul>";
    var strItemValue = "";
    var strItem = "";
    var listCount = 0;
    var arrStr;

    var matchedItem = "";
    var matchedItemvalue = "";
    if (typeof chargeCodeDisplay === 'undefined') chargeCodeDisplay = $j("#hdnChargeCodeDisplay").val();    //<CODE_TAG_105100>lwang
   
    $.each(arrListCode, function (index, value) {
        arrStr = value.split(separator);
        strItemValue = arrStr[0];
        //<CODE_TAG_105100>
        
        if (chargeCodeListInd == "Y" && chargeCodeDisplay == "1") //Check if call from charge Code dropdownlist, and if only show charge code
            strItemValue = strItemValue.substring(0, 3);
        //</CODE_TAG_105100>
        //strItem = escape(arrStr[1]);
        strItem = arrStr[1];
        //<CODE_TAG_105100>
        if (chargeCodeListInd == "Y" && chargeCodeDisplay == "1") //Check if call from charge Code dropdownlist, and if only show charge code
            strItem = strItem.substring(0, 3);
        //</CODE_TAG_105100>
        if (strItem.toUpperCase().indexOf(strkey.toUpperCase()) >= 0) {
            //strList += "<li  ><a ><span onclick=\"SearchbleItemClick('" + strItemValue + "','" + strItem + "','" + txtSearchbleBoxName + "','" + hidSearchbleBoxName + "','" + txtCodeOnlyBoxName + "')\"> " + strItem + "</span></a></li>";
            //<CODE_TAG_103410>
            strList += "<li  ><a ><span onclick=\"SearchbleItemClick('" + strItemValue + "','" + strItem.replace(/&#39;/ig, "&#00;") + "','" + txtSearchbleBoxName + "','" + hidSearchbleBoxName + "','" + txtCodeOnlyBoxName + "')\"> " + strItem + "</span></a></li>";

            if (listCount == 0) {
                matchedItemvalue = strItemValue;
                matchedItem = unescape(strItem);
            }
            listCount++;
        }
    });
    strList += "</ul>";


    $("#divSearchbleList").html(strList);
    
    switch (listCount) {
        case 0:
            $("#divSearchbleList").hide();
            break;
        case 1:
            $("[id*=" + txtSearchbleBoxName + "]").val($("<div/>").html(matchedItem).text());
            $("[id*=" + hidSearchbleBoxName + "]").val(matchedItemvalue);
            if (txtCodeOnlyBoxName != "") $("[id*=" + txtCodeOnlyBoxName + "]").val(matchedItemvalue);

            if (txtSearchbleBoxName.indexOf("txtLaborItemNo") >= 0) {
                itemId = txtSearchbleBoxName.replace("txtLaborItemNo", "");
                setupLaborChargeCode(itemId);
            }
            if (txtSearchbleBoxName.indexOf("txtMiscItemNo") >= 0) {
                itemId = txtSearchbleBoxName.replace("txtMiscItemNo", "");
                setupMiscChargeCode(itemId);
            }

            $("#divSearchbleList").hide();
            break;
        default:
            $("#divSearchbleList").show();
            break;
    }
    
    window.event.cancelBubble = true;
}

function displayMultipleSearchbleList(strkey, txtSearchbleBoxName, hidSearchbleBoxName, arrListCode, txtCodeOnlyBoxName, separator) {
    if (separator == undefined)
        separator = ','; //</CODE_TAG_103329>
    var div_position = $("[id*=" + txtSearchbleBoxName + "]").offset(); //  position();
    var div_top = div_position.top + 15;
    var div_left = div_position.left;
    var div_width = $("[id*=" + txtSearchbleBoxName + "]").width();
    $("#divSearchbleList").css({ "left": div_left, "top": div_top });
    $("#divSearchbleList").width(div_width);
    $('#divSearchbleList').click(function (event) {
        event.stopPropagation();
    });

    if (txtCodeOnlyBoxName == null)
        txtCodeOnlyBoxName = "";

    if (txtSearchbleBoxName.indexOf("txtStoreCode") >= 0) {
        $("[id*=txtCostCenterCode]").val("");
        $("[id*=hidCostCenterCode]").val("");
    }

    var strList = "<ul>";
    var strItemValue = "";
    var strItem = "";
    var listCount = 0;
    var arrStr;

    var matchedItem = "";
    var matchedItemvalue = "";
    var itemStrList = $("[id*=" + txtSearchbleBoxName + "]").val();
    $.each(arrListCode, function (index, value) {
        arrStr = value.split(separator);
        strItemValue = arrStr[0];
        strItem = arrStr[1];
        if (strItem != null && strItem != undefined)
        {
            if (itemStrList != "" && itemStrList.indexOf(strItem) >= 0) 
                strList += "<li class=\"selected\"><label><input type=\"checkbox\" onclick=\"MultipleSearchbleItemClick('" + strItemValue + "','" + strItem.replace(/&#39;/ig, "&#00;") + "','" + txtSearchbleBoxName + "','" + hidSearchbleBoxName + "','" + txtCodeOnlyBoxName + "')\" value='" + strItem + "' checked=\"checked\"/> " + strItem + "</label></li>";
            else
                strList += "<li class=\"selected\"><label><input type=\"checkbox\" onclick=\"MultipleSearchbleItemClick('" + strItemValue + "','" + strItem.replace(/&#39;/ig, "&#00;") + "','" + txtSearchbleBoxName + "','" + hidSearchbleBoxName + "','" + txtCodeOnlyBoxName + "')\" value='" + strItem + "'/> " + strItem + "</label></li>";
        }
        if (listCount == 0) {
            matchedItemvalue = strItemValue;
            matchedItem = unescape(strItem);
        }
        listCount++;            
    });

    strList += "</ul>";


    $("#divSearchbleList").html(strList);

    switch (listCount) {
        case 0:
            $("#divSearchbleList").hide();
            break;
        case 1:
            $("[id*=" + txtSearchbleBoxName + "]").val($("<div/>").html(matchedItem).text());
            $("[id*=" + hidSearchbleBoxName + "]").val(matchedItemvalue);
            if (txtCodeOnlyBoxName != "") $("[id*=" + txtCodeOnlyBoxName + "]").val(matchedItemvalue);

            if (txtSearchbleBoxName.indexOf("txtLaborItemNo") >= 0) {
                itemId = txtSearchbleBoxName.replace("txtLaborItemNo", "");
                setupLaborChargeCode(itemId);
            }
            if (txtSearchbleBoxName.indexOf("txtMiscItemNo") >= 0) {
                itemId = txtSearchbleBoxName.replace("txtMiscItemNo", "");
                setupMiscChargeCode(itemId);
            }

            $("#divSearchbleList").hide();
            break;
        default:
            $("#divSearchbleList").show();
            break;
    }

    window.event.cancelBubble = true;
}

function SearchbleItemClick(strItemValue, strItem, txtSearchbleBoxName, hidSearchbleBoxName, txtCodeOnlyBoxName) {
    var itemId = "";
    strItem = strItem.replace(/&#00;/ig, "\'"); //<CODE_TAG_103410>
    $("[id*=" + txtSearchbleBoxName + "]").val(strItem);
    $("[id*=" + hidSearchbleBoxName + "]").val(strItemValue);

    if (txtCodeOnlyBoxName != "") $("[id*=" + txtCodeOnlyBoxName + "]").val(strItemValue);

    $("#divSearchbleList").hide();
    
    pageDataChanged = true;

    if (txtSearchbleBoxName.indexOf("txtLaborItemNo") >= 0) {
        itemId = txtSearchbleBoxName.replace("txtLaborItemNo", "");
        setupLaborChargeCode(itemId);
    }
    if (txtSearchbleBoxName.indexOf("txtMiscItemNo") >= 0) {
        itemId = txtSearchbleBoxName.replace("txtMiscItemNo", "");
        setupMiscChargeCode(itemId);
    }


    $("[id*=" + txtSearchbleBoxName + "]").focus();
    $("[id*=" + txtSearchbleBoxName + "]").select();

}

function MultipleSearchbleItemClick(strItemValue, strItem, txtSearchbleBoxName, hidSearchbleBoxName, txtCodeOnlyBoxName) {
    var itemStr = "";
    var itemCode = "";
    var itemStrList = $("[id*=" + txtSearchbleBoxName + "]").val();
    var itemCodeList = $("[id*=" + hidSearchbleBoxName + "]").val();
    var allInputs = $("input[value='" + strItem + "']").first();
    strItem = strItem.replace(/&#00;/ig, "\'");
    if (itemStrList.indexOf(strItem) != -1)
    {
        itemStr = itemStrList.replace(strItem, '');
        itemStr = itemStr.replace(';;', ';');
        itemCode = itemCodeList.replace(strItemValue, '');
        itemCode = itemCode.replace('||', '|');
    }
    else
    {
        itemStr = itemStrList + ";" + strItem;
        itemCode = itemCodeList + "|" + strItemValue;
    }
    if (itemStr.substr(0, 1) == ";") itemStr = itemStr.substr(1);
    if (itemCode.substr(0, 1) == "|") itemCode = itemCode.substr(1);
    if (itemStr.substr(itemStr.length - 1, 1) == ";") itemStr = itemStr.substr(0, itemStr.length-1);
    if (itemCode.substr(itemCode.length - 1, 1) == "|") itemCode = itemCode.substr(0, itemCode.length-1);
    $("[id*=" + txtSearchbleBoxName + "]").val(itemStr);
    $("[id*=" + hidSearchbleBoxName + "]").val(itemCode);

    pageDataChanged = true;

}



function txtCodeOnly_onkeydown(txtCodeOnlyBoxName, txtSearchbleBoxName, hidSearchbleBoxName, arrListCode, nextFocusName, separator) {
    if (separator == undefined) separator = ",";

    if (event.keyCode == '9') {
        var arrStr, strItemValue, strItem;
        var strkey = $.trim($("[id*=" + txtCodeOnlyBoxName + "]").val());
        var found = false;
        if (strkey == "") {
            $("[id*=" + txtSearchbleBoxName + "]").val("");
            $("[id*=" + hidSearchbleBoxName + "]").val("");
            $("[id*=" + txtSearchbleBoxName + "]").focus();
        }
        else {
            $.each(arrListCode, function (index, value) {
                //arrStr = value.split(",");
                arrStr = value.split(separator);
                strItemValue = $.trim(arrStr[0]);
                strItem = arrStr[1];
                if (strItemValue.toUpperCase() == strkey.toUpperCase()) {
                    $("[id*=" + txtSearchbleBoxName + "]").val($("<div/>").html(strItem).text());
                    $("[id*=" + hidSearchbleBoxName + "]").val(strItemValue);

                    found = true;
                    return;
                }
            });

            if (!found) {
                $("[id*=" + txtSearchbleBoxName + "]").val("no matched item");
                $("[id*=" + hidSearchbleBoxName + "]").val("");

                $("[id*=" + txtSearchbleBoxName + "]").focus();
            }
            else {
                $("[id*=" + nextFocusName + "]").focus();
            }
        }
        event.cancelBubble = true;
        event.returnValue = false;
        return false;
    }
}
//function txtCodeOnly_onblur(txtCodeOnlyBoxName, txtSearchbleBoxName, hidSearchbleBoxName, arrListCode) {
//<CODE_TAG_103329>
function txtCodeOnly_onblur(txtCodeOnlyBoxName, txtSearchbleBoxName, hidSearchbleBoxName, arrListCode, separator) {
    if (separator == undefined) separator = ",";
//</CODE_TAG_103329>
    var arrStr, strItemValue, strItem;
    var strkey = $.trim($("[id*=" + txtCodeOnlyBoxName + "]").val());
    var found = false;

    if (strkey == "") {
        $("[id*=" + txtSearchbleBoxName + "]").val("");
        $("[id*=" + hidSearchbleBoxName + "]").val("");
    }
    else {
        $.each(arrListCode, function (index, value) {
            //arrStr = value.split(",");
            arrStr = value.split(separator);  //<CODE_TAG_103329>
            strItemValue = $.trim(arrStr[0]);
            strItem = arrStr[1];

            if (strItemValue.toUpperCase() == strkey.toUpperCase()) {
                $("[id*=" + txtSearchbleBoxName + "]").val($("<div/>").html(strItem).text());
                $("[id*=" + hidSearchbleBoxName + "]").val(strItemValue);
                found = true;
                return;
            }
        });

        if (!found) {
            $("[id*=" + txtSearchbleBoxName + "]").val("no matched item");
            $("[id*=" + hidSearchbleBoxName + "]").val("");
        }
    }
}





$(document).click(function (event) {
    $('#divSearchbleList:visible').hide();
    $('.ajax__calendar_container').css("visibility","hidden");
});
//***************************************************************************************************************************************
var pageDataChanged = false;
var allowDataChangedWarning = true;

function CommonFunctionAjaxHandler(op, para) {
    var rt = "";
    var request = $.ajax({
        url: applicationPath + "modules/Quote/CommonFunctionAjaxHandler.ashx?op=" + op + para,
        type: "GET",
        cache: false,
        async: false,
        success: function (htmlContent) {
            rt = htmlContent;
        },
        error: function () { }
    });

    return rt;
}
//**********************************************************************************************************************
//<CODE_TAG_103922>
function unescapeHTML(p_string) {
    if ((typeof p_string === "string") && (new RegExp(/&amp;|&lt;|&gt;|&quot;|&#39;/).test(p_string))) {
        return p_string.replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&quot;/g, "\"").replace(/&#39;/g, "'");
    }

    return p_string;
}
//</CODE_TAG_103922>

function displayNote(section) {
    var offset = 0;
    var rowsCount = 0;
    var notes = "";
    var masterIndicators = "";
    eval("offset=" + section + "Offset");
    eval("rowsCount=" + section + "RowsCount");
    eval("notes=" + section + "Notes");
    eval("masterIndicators=" + section + "MasterIndicators");

    var arrNotes = notes.split(String.fromCharCode(5));
    var arrMasterIndicators = masterIndicators.split(String.fromCharCode(5));

    for (var i = 0; i <= rowsCount * 2; i++) {
        var num = i + offset;
        var sNum = num.toString();
        if (sNum.length == 2) sNum = "0" + sNum;
        if (sNum.length == 1) sNum = "00" + sNum;

        if (section == "Instructions" && num < 5)
            sNum += "*";
        $("#span" + section + "Number" + i).html(sNum);

        if (num <= arrNotes.length) {
            //$("#txt" + section + "Note" + i).val(unescape(arrNotes[num - 1]));
            $("#txt" + section + "Note" + i).val(unescapeHTML(arrNotes[num - 1])); //<CODE_TAG_103922>
            
            switch (arrMasterIndicators[num - 1]) {
                case "I":
                    $("#chk" + section + "MasterIndicatorInternal" + i).attr('checked', true);
                    $("#chk" + section + "MasterIndicatorExternal" + i).attr('checked', false);
                    break;

                case "E":
                    $("#chk" + section + "MasterIndicatorInternal" + i).attr('checked', false);
                    $("#chk" + section + "MasterIndicatorExternal" + i).attr('checked', true);
                    break;

                case "B":
                    $("#chk" + section + "MasterIndicatorInternal" + i).attr('checked', true);
                    $("#chk" + section + "MasterIndicatorExternal" + i).attr('checked', true);
                    break;

                default:
                    $("#chk" + section + "MasterIndicatorInternal" + i).attr('checked', false);
                    $("#chk" + section + "MasterIndicatorExternal" + i).attr('checked', false);



            }
        }
        else {
            $("#txt" + section + "Note" + i).val("");
            $("#chk" + section + "MasterIndicatorInternal" + i).attr('checked', false);
            $("#chk" + section + "MasterIndicatorExternal" + i).attr('checked', false);
        }
    }

    if (offset > 0) {
        $("#img" + section + "First").show();
        $("#img" + section + "Previous").show();
    }
    else {
        $("#img" + section + "Previous").hide();
        $("#img" + section + "First").hide();
    }
    if (offset + rowsCount * 2 < arrNotes.length) {
        $("#img" + section + "Next").show();
        $("#img" + section + "Last").show();
        $("#img" + section + "Add").hide();
    }
    else {
        $("#img" + section + "Next").hide();
        $("#img" + section + "Last").hide();
        $("#img" + section + "Add").show();
    }

}



function saveNote(section) {
    var offset = 0;
    var rowsCount = 0;
    var notes = "";
    var masterIndicators = "";

    eval("offset=" + section + "Offset");
    eval("rowsCount=" + section + "RowsCount");
    eval("notes=" + section + "Notes");
    eval("masterIndicators=" + section + "MasterIndicators");

    var arrNotes = notes.split(String.fromCharCode(5));
    var arrMasterIndicators = masterIndicators.split(String.fromCharCode(5));
    var curMasterIndicator = '';

    for (var i = 1; i <= rowsCount * 2; i++) {
        var num = i + offset;
        arrNotes[num - 1] = $("#txt" + section + "Note" + i).val();
        curMasterIndicator = '';
        if ($("#chk" + section + "MasterIndicatorInternal" + i).attr('checked'))
            curMasterIndicator = 'I';
        if ($("#chk" + section + "MasterIndicatorExternal" + i).attr('checked'))
            curMasterIndicator = 'E';
        if ($("#chk" + section + "MasterIndicatorInternal" + i).attr('checked') && $("#chk" + section + "MasterIndicatorExternal" + i).attr('checked'))
            curMasterIndicator = 'B';

        arrMasterIndicators[num - 1] = curMasterIndicator;
    }
    
    notes = "";
    masterIndicators = "";

    for (var i = 0; i < arrNotes.length; i++) {
        //if (notes != "") notes += String.fromCharCode(5);
        //if (masterIndicators != "") masterIndicators += String.fromCharCode(5);

        if (i != 0) {
            notes += String.fromCharCode(5);
            masterIndicators += String.fromCharCode(5);
        }

        notes += arrNotes[i];
        masterIndicators += arrMasterIndicators[i];
    }

    eval(section + "Notes=notes;");
    eval(section + "MasterIndicators=masterIndicators;");

}

function SegmentNoteAdd(section) {
    saveNote(section);

    var offset = 0;
    var rowsCount = 0;
    var notes = "";
    
    eval("offset=" + section + "Offset");
    eval("rowsCount=" + section + "RowsCount");
    eval("notes=" + section + "Notes");
    
    var arrNotes = notes.split(String.fromCharCode(5));

    while (offset + rowsCount < arrNotes.length) {
        offset += rowsCount;
    }

    eval(section + "Offset =offset");
    displayNote(section);
}

function SegmentNoteFirst(section) {
    saveNote(section);
    eval(section + "Offset = 0;");
    displayNote(section);
}

function SegmentNotePrevious(section) {
    saveNote(section);
    eval(section + "Offset -=" + section + "RowsCount;");
    displayNote(section);
}

function SegmentNoteNext(section) {
    saveNote(section);
    eval(section + "Offset +=" + section + "RowsCount;");
    displayNote(section);
}

function SegmentNoteLast(section) {
    saveNote(section);
    var offset = 0;
    var rowsCount = 0;
    var notes = "";

    eval("offset=" + section + "Offset");
    eval("rowsCount=" + section + "RowsCount");
    eval("notes=" + section + "Notes");

    var arrNotes = notes.split(String.fromCharCode(5));

    while (offset + rowsCount * 2 < arrNotes.length) {
        offset += rowsCount;
    }

    eval(section + "Offset =offset");

    displayNote(section);
}
