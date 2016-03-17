// Version: "11.0.5704.0"
// Copyright (c) Microsoft Corporation.  All rights reserved.
// _lcid="1033" _version="11.0.5704.0"
// _localbinding
var sOpenMenuID   = "";   
var sMenuButtonID = "";   
var strEcbSelectedClass   = "ms-selectedtitle";
var strEcbUnselectedClass = "ms-unselectedtitle";
var strMenuItemTableCell  = "ms-MenuUIItemTableCell";
var strMenuItemTableCellH = "ms-MenuUIItemTableCellHover";
var strMenuItemTable      = "ms-MenuUIItemTable";
var strMenuItemTableH     = "ms-MenuUIItemTableHover";
var strMenuUIIcon              = "ms-MenuUIIcon";
var strMenuUISeparator         = "ms-MenuUISeparator";
var strMenuUiLabelWithFont     = "ms-MenuUILabel ms-MenuUILabelFont";
var strMenuUIIconRtl           = "ms-MenuUIIconRtL";
var strMenuUISeparatorRtl      = "ms-MenuUISeparatorRtL";
var strMenuUiLabelWithFontRtl  = "ms-MenuUILabelRtL ms-MenuUILabelFont";

function fixupParmString(strParm)
{

    var strTmp = strParm.replace(/\\/g, "\\\\");
    return strTmp.replace(/\'/g, "\\\'");
}

function fixupUrlParm(strParm)
{

    var tmpParm = strParm;
    var outParm = "";

    var nIndex = tmpParm.indexOf("%252B");
    while (-1 != nIndex)
    {
        outParm = outParm + tmpParm.substring(0,nIndex) + "%2b";
        tmpParm = tmpParm.substr(nIndex+5);
        nIndex = tmpParm.indexOf("%252B");
    }
    if (tmpParm != "")
        outParm = outParm + tmpParm;

    tmpParm = outParm;
    outParm = "";

    nIndex = tmpParm.indexOf("\/");
    while (-1 != nIndex)
    {
        outParm = outParm + tmpParm.substring(0,nIndex) + "%2f";
        tmpParm = tmpParm.substr(nIndex+1);
        nIndex = tmpParm.indexOf("\/");
    }
    if (tmpParm != "")
        outParm = outParm + tmpParm;
    return outParm;
}

function mnuCustomizeItem(objMenuItem, targetURL, dicParms, rgDisables)
{
    objMenuItem.href = "";
    var strParms     = "";  
    var strTargetURL = "";  
    var strScript    = "";  
    var strScriptFuncReplaceMode = ""; 
    var fFuncMode    = false;
    var fFuncModeParamReplace = false;
    var strHref;

    strParms     = objMenuItem.getAttribute("parms");
    strTargetURL = objMenuItem.getAttribute("targetURL");
    strScript    = objMenuItem.getAttribute("scriptFunc");
    strScriptFuncReplaceMode = objMenuItem.getAttribute("scriptFuncReplaceMode");

    if (null != strScript && strScript != "")
    {
        fFuncMode = true;
        if (strScriptFuncReplaceMode != null)
        {
            fFuncModeParamReplace = true;
        }
        if (fFuncModeParamReplace)
        {
            strHref = "javascript:" + strScript;
        }
        else
        {
            strHref="javascript:" + strScript + "(";
        }
    } else if (null == strTargetURL || strTargetURL == "")
        strHref = targetURL;
    else
        strHref = strTargetURL;

    if (null != strParms)
    {
        var rgParms = strParms.split(",");
        var nParm;

        for (nParm = 0; nParm < rgParms.length; nParm++)
        {
            var nArg;

            for (nArg = 0; nArg < dicParms[0].length; nArg++)
            {
                if (rgParms[nParm] == dicParms[0][nArg])
                {
                    if (fFuncMode)
                    {
                        var strParm = fixupParmString(dicParms[1][nArg]);
                        if (fFuncModeParamReplace)
                        {
                            strHref = strHref.replace(rgParms[nParm], strParm.replace(/%/g, "%25"));
                        }
                        else
                        {

                            if (nParm != 0)
                                strHref += ",";

                            strHref += "'";
                            strHref += strParm;
                            strHref += "'";
                        }
                    }
                    else
                    {

                        if (nParm == 0)
                            strHref += "?"; 
                        else
                            strHref += "&"  

                        strHref += rgParms[nParm];
                        strHref += "=";

                        var strParm = escape(dicParms[1][nArg]);

                        strHref += fixupUrlParm(strParm);
                    }
                    break;  
                }
            }
        }
    }
    if (fFuncMode && !fFuncModeParamReplace)
    {
        strHref += ")";
    }

    objMenuItem.href = strHref;

    mnuEnableRow(objMenuItem, true);

    if (null != rgDisables)
    {
        for (nItem = 0; nItem < rgDisables.length; nItem++)
        {
            if (rgDisables[nItem] == objMenuItem.id)
            {
                mnuEnableRow(objMenuItem, false);
            }
        }
    }
    objMenuItem.onfocus = mnuItemSelect;
    objMenuItem.onblur  = mnuItemDeselect;
    objMenuItem.hideFocus = true;
    objMenuItem.onkeydown = mnuItemKeydown;
}

function mnuEnableRow(oElement, fEnable)
{
    var oRow = mnuGetMenuRowFromElement(oElement);
    for (var index=0; index < oRow.children.length; index++)
        oRow.children(index).disabled = !fEnable;
    oRow.disabled = !fEnable;
}

function itmToRtl(oRow)
{
    var colItemCells = oRow.all.tags("TD");
    for (var nCell = 0; nCell < colItemCells.length; nCell++)
    {
        var oCell = colItemCells(nCell);
        if (oCell.className == strMenuUIIcon)
            oCell.className = strMenuUIIconRtl;
        else if (oCell.className == strMenuUISeparator)
            oCell.className = strMenuUISeparatorRtl;
        else if (oCell.className == strMenuUiLabelWithFont)
            oCell.className = strMenuUiLabelWithFontRtl;
    }
}

function itmToLtr(oRow)
{
    var colItemCells = oRow.all.tags("TD");
    for (var nCell = 0; nCell < colItemCells.length; nCell++)
    {
        var oCell = colItemCells(nCell);
        if (oCell.className == strMenuUIIconRtl)
            oCell.className = strMenuUIIcon;
        else if (oCell.className == strMenuUISeparatorRtl)
            oCell.className = strMenuUISeparator;
        else if (oCell.className == strMenuUiLabelWithFontRtl)
            oCell.className = strMenuUiLabelWithFont;
    }
}

function mnuCustomizeItems(objMenu, targetURL, dicParms, rgDisables)
{
    var theDir = mnuGetDirection();
    if (theDir != document.dir)
    {
        var colMenuRows = objMenu.all.tags("TABLE");
        var nRow;

        if (theDir == "rtl")
        {
            for (nRow = 0; nRow < colMenuRows.length; nRow++)
                itmToRtl(colMenuRows(nRow));
        }
        else
        {
            for (nRow = 0; nRow < colMenuRows.length; nRow++)
                itmToRtl(colMenuRows(nRow));
        }
    }

    var fFocus = false;
    var colMenuItems = objMenu.all.tags("A");
    var nItem;
    for (nItem = 0; nItem < colMenuItems.length; nItem++)
    {
        mnuCustomizeItem(colMenuItems(nItem), targetURL, dicParms, rgDisables);

        if (!fFocus && !colMenuItems(nItem).isDisabled)
        {
            colMenuItems(nItem).focus();
            fFocus = true;
        }
    }
}

function mnuClose()
{
    if ("object" == typeof(document.all[sOpenMenuID]))
    {
        var objMenu = document.all(sOpenMenuID);
        sOpenMenuID = "";
        objMenu.style.display = "none"; 
        if (browseris.ie55up) 
            document.all("__hifMenu").style.display = "none";
        objMenu.releaseCapture();
        document.oncontextmenu = null;
        if ("object" == typeof(document.all[sMenuButtonID]))
        {
            document.all[sMenuButtonID].focus();
            sMenuButtonID = "";
        }
    }
}

function mnuGetEcbContainer(objEcb)
{
    if (null == objEcb)
        return null;
    var objParent = objEcb.parentElement;
    while (objParent != null && "TD" != objParent.tagName)
    {
        objParent = objParent.parentElement;
    }
    return objParent;
}

function mnuInsureBackingIFrame(objMenu)
{
    var oFrame = null;
    if ((null != document.frames) && (document.frames.length > 0))
    {
        var ifmContainer = document.getElementById("__hifMenu");
        if (ifmContainer != null)
            oFrame = document.frames("__hifMenu");
    }
    if (null == oFrame)
    {
        {
             var oBody = objMenu.parentElement;
             while (oBody != null && "BODY" != oBody.tagName)
             {
                 oBody = oBody.parentElement;
             }

             oBody.insertAdjacentHTML("afterBegin",
                 "<iframe id=\"__hifMenu\" scrolling=no " +

                 "src=\"/_layouts/images/blank.gif\" " +

                 "style=\"display:none;position:absolute;\"></iframe>");
             oFrame = document.frames("__hifMenu");
             var oDoc = oFrame.document;
             oDoc.open("text/html", "replace");
             oDoc.write("");
             oDoc.close();
        }
    }
    return oFrame;
}

function mnuDisplay(objMenu, x, y)
{
    if (objMenu != null)
    {       
        objMenu.style.position = "absolute";
        objMenu.style.left = x.toString() + "px";
        objMenu.style.top = y.toString() + "px";
        objMenu.style.display = "block";

        if (browseris.ie55up)
        {
            mnuInsureBackingIFrame(objMenu);
            objMenu.style.display = "none"; 
            document.all("__hifMenu").style.left = x.toString();
            document.all("__hifMenu").style.top = y.toString();
            document.all("__hifMenu").style.width = objMenu.offsetWidth;
            document.all("__hifMenu").style.height = objMenu.offsetHeight;
            document.all("__hifMenu").style.display = "block";
            objMenu.style.display = "block"; 
        }
    }
}

function mnuPreDisplay(objMenu, x, y, cx, cy)
{
    if (objMenu != null)
    {

        var sx = x - objMenu.clientWidth;
        var sy = y;
        if (cx < sx + objMenu.clientWidth)
        {
            sx = cx - objMenu.clientWidth;
            if (sx < 0)
                sx = 0;
        }
        if (cy < sy + objMenu.clientHeight)
        {
            sy = cy - objMenu.clientHeight;
            if (sy < 0)
                sy = 0;
        }

        mnuDisplay(objMenu, sx, sy);
    }
}

function mnuGetDirection()
{
    var objToTest = mnuGetInvokingMenuButton();
    while (null != objToTest)
    {
        var strDir = objToTest.currentStyle.direction.toLowerCase();
        if (strDir == "rtl" || strDir == "ltr")
        {
            return strDir;
        }
        objToTest = objToTest.parentElement;
    }
    return document.dir;
}

function mnuPosition(idMenu, idMenuButton)
{
    var objMenuContext   = document.all[idMenuButton];
    var objMenuContainer = mnuGetEcbContainer(objMenuContext);
    var theDir           = mnuGetDirection();
    var objBody          = document.all.tags("BODY")(0);

    if ("object" == typeof(document.all[idMenu]))
    {
        var objMenu = document.all(idMenu);
        var x = 0;  
        var y = 0;
        var cx = 0;
        var cy = 0;
        var cyContext = 0;

        if (objMenuContext == null)
            objMenuContext = mnuGetInvokingMenuButton();
        if (objMenuContext != null)
        {

            if (theDir == "rtl")
            {
                x = objMenuContext.offsetLeft;
            }
            else
            {
                if (objMenuContainer != null &&
                    objMenuContext.clientWidth > objMenuContainer.clientWidth)
                {
                    x = objMenuContext.offsetLeft + objMenuContainer.clientWidth;
                }
                else
                {
                    x = objMenuContext.offsetLeft + objMenuContext.offsetWidth;
                }
            }

            y = objMenuContext.offsetTop + objMenuContext.offsetHeight

            var objParent = objMenuContext.offsetParent;
            while ("BODY" != objParent.tagName)
            {

                if (objParent.currentStyle.overflow.toLowerCase() == "auto")
                {
                    x = x + objParent.offsetLeft;
                    y = y + objParent.offsetTop;
                }
                else
                {
                    x = x + objParent.offsetLeft - objParent.scrollLeft;
                    y = y + objParent.offsetTop - objParent.scrollTop;
                }
                objParent = objParent.offsetParent;
            }

            cx = objParent.offsetWidth + objParent.scrollLeft;
            cy = objParent.offsetHeight + objParent.scrollTop;

            mnuPreDisplay(objMenu, x, y, cx, cy);

            cyContext = objMenuContext.offsetHeight;
        }
        else
        {

            x = window.event.clientX + window.event.offsetX;
            y = window.event.clientY + window.event.offsetY;

            if (objBody != null)
            {
                cx = objBody.offsetWidth + objBody.scrollLeft;
                cy = objBody.offsetHeight + objBody.scrollTop;

                mnuPreDisplay(objMenu, x, y, cx, cy);
                if (window.event.srcElement != null)
                    cyContext = window.event.srcElement.offsetHeight;
                else
                    cyContext = 0;
            }
        }

        if (theDir != "rtl")
        {
            if (cx < objMenu.offsetWidth)
            {
                x = 0;
            }
            else
            {
                x = x - objMenu.offsetWidth;
            }
        }
        if (cy < y + objMenu.offsetHeight)
        {
            y = cy - objMenu.offsetHeight - cyContext;
        }

        if (theDir != "rtl")
            if (x < 0) x = 0;
        if (y < 0) y = 0;

        if (objBody != null)
        {
            if (x + objMenu.offsetWidth > objBody.clientWidth + objBody.scrollLeft)
                x = objBody.clientWidth + objBody.scrollLeft - objMenu.offsetWidth;
        }

        mnuDisplay(objMenu, x, y);        
    }
}

function mnuIsEcb(objSource)
{
    if (objSource.tagName != "TABLE")
        return false;
    if (objSource.className == null)
        return false;
    if (objSource.className == strEcbSelectedClass)
        return true;
    if (objSource.className == strEcbUnselectedClass)
        return true;
    return false;
}

function mnuGetInvokingMenuButton()
{
    var objSource = window.event.srcElement; 
    while (objSource != null && !mnuIsEcb(objSource))
    {
        objSource = objSource.parentElement;
    }
    return objSource;
}

function mnuOpen(idMenu, targetURL, dicParms, rgDisables)
{

    if (!browseris.ie5up || !browseris.win32)
    {
        window.event.cancelBubble = true;   
        window.event.returnValue = false;   
        return;
    }

    if (window.event.srcElement.tagName == "A" &&
        null != window.event.srcElement.href &&
        "" != window.event.srcElement.href)
    {
        window.event.srcElement.click();
        return;
    }

    mnuClose();                         

    var objMenubutton = mnuGetInvokingMenuButton();
    if (null != objMenubutton)
    {
        sMenuButtonID = objMenubutton.id;

        if ("object" == typeof(document.all[idMenu])) 
        {
            mnuPosition(idMenu, sMenuButtonID);            

            objMenu = document.all(idMenu);
            objMenu.style.display = "block";
            objMenu.setCapture();
            objMenu.onclick = mnuClick;
            objMenu.onmouseover = mnuMouseOver;
            objMenu.onlosecapture = mnuClose;
            document.oncontextmenu = mnuNoContext;

            if (mnuGetDirection() == "rtl")
            {
                objMenu.style.backgroundImage = "url(" + "/_layouts/images/MGradRTL.gif" + ")";
                objMenu.style.backgroundPositionX = "right";
            }
            else
            {
                objMenu.style.backgroundImage = "url(" + "/_layouts/images/MGrad.gif" + ")";
                objMenu.style.backgroundPositionX = "left";
            }

            objMenu.style.backgroundRepeat = "repeat-y"

            mnuCustomizeItems(objMenu, targetURL, dicParms, rgDisables);
            sOpenMenuID = idMenu;
        }
    }
    window.event.cancelBubble = true;   
    window.event.returnValue = false;   
    ecbFocus(sMenuButtonID);
}

function mnuKeyPress(idMenu, targetURL, dicParms, rgDisables)
{
    if (window.event.shiftKey && window.event.keyCode == 13)
        mnuOpen(idMenu, targetURL, dicParms, rgDisables);
}

function mnuGetMenuFromMenuItem(objMenuItem)
{
    var oCurrent = objMenuItem;
    while (oCurrent.className != "ms-MenuUI")
        oCurrent = oCurrent.parentElement;
    return oCurrent;
}

function mnuGetMenuRowFromElement(oElement)
{
    if (oElement.children.length > 0)
    {
        if (oElement.firstChild.className == strMenuItemTableCell ||
            oElement.firstChild.className == strMenuItemTableCellH)
                return oElement;
    }

    while (oElement.className != strMenuItemTableCell &&
           oElement.className != strMenuItemTableCellH)
        oElement = oElement.parentElement;
    return oElement.parentElement;
}

function mnuGetItemFromElement(oElement)
{
    var oRow = mnuGetMenuRowFromElement(oElement);
    if (oRow)
    return oRow.all.tags("A")(0);
    return null;
}

function mnuGetNextMenuItem(objMenuItem)
{
    var objMenu = mnuGetMenuFromMenuItem(objMenuItem);
    objMenuItem = mnuGetItemFromElement(objMenuItem);
    if (objMenuItem)
    {
        var colMenuItems = objMenu.all.tags("A");
        var oRow;
        var nItem;
        var nCurrent = -1;
        var oItem;
        for (nItem = 0; nItem < colMenuItems.length; nItem++)
        {
            oItem = colMenuItems(nItem);
            if (oItem == objMenuItem)
            {
                nCurrent = nItem;
            }
            else if (nCurrent != -1)
            {
                oRow = mnuGetMenuRowFromElement(oItem);
                if (oRow && !oRow.isDisabled)
                    return oItem;
            }
        }
        for (nItem = 0; nItem < nCurrent; nItem++)
        {
            oItem = colMenuItems(nItem);
            oRow = mnuGetMenuRowFromElement(oItem);
            if (oRow && !oRow.isDisabled)
                return oItem;
        }
    }
    return objMenuItem;
}

function mnuGetPreviousMenuItem(objMenuItem)
{
    var objMenu = mnuGetMenuFromMenuItem(objMenuItem);
    objMenuItem = mnuGetItemFromElement(objMenuItem);
    if (objMenuItem)
    {
        var colMenuItems = objMenu.all.tags("A");
        var oRow;
        var nItem;
        var nCurrent = -1;
        var oItem;
        for (nItem = colMenuItems.length -1; nItem > -1; nItem--)
        {
            oItem = colMenuItems(nItem);
            if (oItem == objMenuItem)
            {
                nCurrent = nItem;
            }
            else if (nCurrent != -1)
            {
                oRow = mnuGetMenuRowFromElement(oItem);
                if (oRow && !oRow.isDisabled)
                    return oItem;
            }
        }
        for (nItem = colMenuItems.length -1; nItem > nCurrent; nItem--)
        {
            oItem = colMenuItems(nItem);
            oRow = mnuGetMenuRowFromElement(oItem);
            if (oRow && !oRow.isDisabled)
                return oItem;
        }
    }
    return objMenuItem;
}

function mnuSelectPrevious(objMenuItem)
{
    var oPrevious = mnuGetPreviousMenuItem(objMenuItem);
    var oRow = mnuGetMenuRowFromElement(oPrevious);
    if (oRow && !oRow.isDisabled)
    {
        oPrevious.focus();
    }
}

function mnuSelectNext(objMenuItem)
{
    var oNext = mnuGetNextMenuItem(objMenuItem);
    var oRow = mnuGetMenuRowFromElement(oNext);
    if (oRow && !oRow.isDisabled)
    {
        oNext.focus();
    }
}

function mnuItemKeydown()
{
    switch (window.event.keyCode)
    {
        case 13: 
            window.event.cancelBubble = true; 
            window.event.returnValue = false; 
            mnuItemClick();
            break;
    case 27: 
            mnuClose();
            break;
    case 32: 
            window.event.cancelBubble = true; 
            window.event.returnValue = false; 
            mnuItemClick();
            break;
        case 38: 
            window.event.cancelBubble = true; 
            window.event.returnValue = false; 
            mnuSelectPrevious(window.event.srcElement);
            break;
        case  9: 
            window.event.cancelBubble = true; 
            window.event.returnValue = false; 
            if (window.event.shiftKey)
                mnuSelectPrevious(window.event.srcElement);
            else
                mnuSelectNext(window.event.srcElement);
            break;
        case 40: 
            window.event.cancelBubble = true; 
            window.event.returnValue = false; 
            mnuSelectNext(window.event.srcElement);
            break;
    }
}

function mnuItemMouseEnter()
{
    var oRow = mnuGetMenuRowFromElement(window.event.srcElement);
    if (oRow && !oRow.isDisabled)
    {
        var oItem = mnuGetItemFromElement(window.event.srcElement);
        if (oItem)
        {
            window.event.cancelBubble = true; 
            window.event.returnValue = false; 
            oItem.focus();
        }
    }
}

function mnuItemClick()
{
    var oRow = mnuGetMenuRowFromElement(window.event.srcElement);
    if (oRow && !oRow.isDisabled)
    {
        var oItem = mnuGetItemFromElement(window.event.srcElement);
        if (oItem)
        {
            oItem.click();
        }
    }
}

function mnuMouseOver()
{
    if ("object" == typeof(document.all[sOpenMenuID])) 
    {
        var objMenu = document.all(sOpenMenuID);
        for (var nObject = 0; nObject < objMenu.all.length; nObject++)
        {
            if (window.event.srcElement == objMenu.all(nObject))
            {
                window.event.cancelBubble = true; 
                window.event.returnValue = false; 
                mnuItemMouseEnter();
                return;
            }
        }
    }
}

function mnuClick()
{

    var objSource = window.event.srcElement; 
    var objParent = objSource.parentElement;
    if ("object" == typeof(document.all[sOpenMenuID])) 
    {
        var objMenu = document.all(sOpenMenuID);
        var nObject;
        for (nObject = 0; nObject < objMenu.all.length; nObject++)
        {
            if (objSource == objMenu.all(nObject))
            {
                mnuItemClick();
                return;
            }
        }

        if (objSource.className != null &&
            objSource.className == strEcbUnselectedClass)
            objSource.click();
        else if (objParent != null &&
            objParent.className != null &&
            objParent.className == strEcbSelectedClass)
            objParent.click();
        else
            mnuClose();
    }
}

function mnuGetRowFromMenuItem(objMenuItem)
{
    return mnuGetMenuRowFromElement(objMenuItem)
}

function mnuItemSelect()
{
    var oItem = mnuGetMenuRowFromElement(window.event.srcElement);
    var oItemTableCell = oItem.firstChild;
    var oItemTable = oItemTableCell.firstChild;
    oItemTableCell.className = strMenuItemTableCellH;
    oItemTable.className = strMenuItemTableH;
    window.status = oItem.innerText;
    window.event.cancelBubble = true; 
    window.event.returnValue = false; 
    ecbFocus(sMenuButtonID);
}

function mnuItemDeselect()
{
    var oItem = mnuGetMenuRowFromElement(window.event.srcElement);
    var oItemTableCell = oItem.firstChild;
    var oItemTable = oItemTableCell.firstChild;
    oItemTableCell.className = strMenuItemTableCell;
    oItemTable.className = strMenuItemTable;
    window.status = window.defaultStatus;
    window.event.cancelBubble = true; 
    window.event.returnValue = false; 
}

function mnuNoContext()
{
    return false;
}

function ecbGetSelectedElement(elem, tagName)
{
    while(elem != null && elem.tagName != tagName)
        elem = elem.parentElement;

    return elem;
}

function ecbMouseOver(itemId)
{
    var oEcb = document.getElementById(itemId);
    if (null != oEcb)
    {
        var oActive = document.activeElement;
        if (oActive == oEcb && oEcb.className != strEcbSelectedClass)
        {
            ecbFocus(itemId);
        }
        else
        {
            i = 0;
            while (oEcb.all[i] != null)
            {
                oEcb.all[i].style.cursor = "hand";
                i++;
            }
            oEcb.focus();
        }
    }
}

function ecbMouseOut()
{
    var oSrc = event.srcElement;
    while (oSrc != null && oSrc != document.activeElement)
        oSrc = ecbGetSelectedElement(oSrc.parentElement, "TABLE");
    if (oSrc == null)
        return; 
    var i = 0;
    while (oSrc.all[i] != null)
    {
        if (oSrc.all[i] == event.toElement)
            return;
        i++;
    }
    ecbDeSelect(oSrc);
}

function ecbBlur()
{
    var oTable = event.srcElement;
    if (mnuIsEcb(oTable))
        ecbDeSelect(oTable);
}

function ecbFocus(itemId)
{

    if (!browseris.ie5up || !browseris.win32)
        return;

    var ecbTable = document.getElementById(itemId);
    if (ecbTable != null && mnuIsEcb(ecbTable))
    {
        ecbTable.className     = strEcbSelectedClass;
        ecbTable.style.paddingTop = 0; 
        ecbTable.onmouseout    = ecbMouseOut;
        ecbTable.onblur        = ecbBlur;
        if (sOpenMenuID == "")
            ecbTable.oncontextmenu = ecbRightClick;
        else
            ecbTable.oncontextmenu = mnuNoContext;

        var titleRow = ecbTable.children[0].children[0];
        if (titleRow != null)
        {
            var i = 0;
            var imageCell;
            while (titleRow.children[i] != null)
                imageCell = titleRow.children[i++];

            if (imageCell != null)
            {
                imageCell.className = "ms-menuimagecell";
                imageCell.style.visibility="visible";
                imageCell.style.paddingBottom = 0;
                imageCell.style.paddingTop = 0;
            }

            if (ecbTable.parentElement.tagName == "TD")
            {
                var ecbTitleCell = titleRow.children[0];
                var ecbTitleElement;

                if (ecbTable.parentElement.clientWidth < ecbTable.offsetWidth)
                {
                    var cx = ecbTable.parentElement.clientWidth - ecbTable.offsetWidth;
                    var cxTitleCell  = ecbTitleCell.clientWidth + cx;
                    var cxElement    = cxTitleCell - imageCell.clientWidth + (imageCell.clientWidth - imageCell.offsetWidth) * 2;

                    if (ecbTitleCell.children[0] == null)
                    {
                        var strNewHtml = ecbTitleCell.innerText;
                        ecbTitleCell.innerText = "";
                        var oSpan = document.createElement("SPAN");
                        oSpan.innerText = strNewHtml;
                        ecbTitleCell.insertAdjacentElement("AfterBegin", oSpan)
                    }

                    ecbTitleCell.style.overflow = "hidden";
                    ecbTitleElement = ecbTitleCell.children[0];

                    ecbTitleElement.style.overflow = "hidden";
                    ecbTitleElement.style.width = cxElement.toString() + "px";

                    ecbTitleCell.style.width = cxTitleCell.toString() + "px";
                }
                if (ecbTitleCell.children[0] == null)
                {
                    ecbTitleElement = ecbTitleCell;
                }
                else
                {
                    ecbTitleElement = ecbTitleCell.children[0];
                }
                ecbTitleElement.title = ecbTitleElement.innerText;
            }
        }
    }
}

function ecbRightClick()
{

    if (window.event.srcElement.tagName == "A" &&
        null != window.event.srcElement.href &&
        "" != window.event.srcElement.href)
    {

        return true;
    }

    window.event.srcElement.click();
    return false;
}

function ecbDeSelect(oTable)
{
    if (oTable.tagName != "TABLE")
        return;
    oTable.className = strEcbUnselectedClass;
    oTable.style.paddingTop = 1; 
    document.oncontextmenu = null;

    var titleRow = oTable.children[0].children[0];
    if (null != titleRow)
    {
        var i = 0;
        var imageCell;
        while (titleRow.children[i] != null)
            imageCell = titleRow.children[i++];

        if (null != imageCell)
        {
            imageCell.style.visibility="hidden";
            imageCell.className = "";
        }

        var ecbTitleCell = titleRow.children[0];
        if (null != ecbTitleCell)
        {
            ecbTitleCell.style.overflow = "visible";
            ecbTitleCell.style.width = "100%";
            var ecbTitleElement = ecbTitleCell.children[0];
            if (null !=  ecbTitleElement)
            {
                ecbTitleElement.style.overflow = "visible";
                ecbTitleElement.style.width = "auto";
            }
        }
    }
}

