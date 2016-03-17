// _lcid="1033" _version="11.0.5510"
// _localBinding
// Version: "11.0.5510"
// Copyright (c) Microsoft Corporation.  All rights reserved.
fImglibJssLoaded = true;
var fImglibDefautlView = false;
var L_DeleteMultipleItems_Text = "You are about to permanently remove the selected items from the library.";
var L_ListStyle_Text = " Details";
var L_ThumbnailStyle_Text = " Thumbnails";
var L_FilmstripStyle_Text = " Filmstrip";
var L_FileName_Text = "Name";		
var L_Title_Text = "Title";		
var L_Description_Text = "Description";	
var L_ImageSize_Text = "Picture Size";	
var L_ImageCreateDate_Text = "Date Picture Taken";	
var L_ImgAlt_Text = "Picture";
var L_DocumentAlt_Text = "Document";
var L_FolderAlt_Text = "Folder";
var L_AltViewProperty_Text = "Click here to view the picture properties.";
var L_GotoFolder_Text = "Click here to go to the folder.";
var L_Picture_Text = "Picture"; 
var L_Of_Text = "of";
var L_NoImageSelected_Text = "There are no pictures selected. Select one or more pictures and try again.";
var L_IEOnlyFeature_Text = "This feature requires Internet Explorer version 5.5 or greater for Windows to work.";
var L_NotAvailableOnWebPart_Text="This operation cannot be completed from a web part. Please go to the Picture Library and try again.";
var L_NoPreview_Text = "No Preview Available";
var L_OpenItem_Text = "Open item";
var L_SelectAll_Text = "Select|Unselect all";
var L_PreviousPicture_Text = "Previous picture";
var L_NextPicture_Text = "Next picture";
var L_SelectionCheckboxMSAATitle_Text = "selection checkbox";   
var L_SelectedViewError_Text = "Selected Images View requires Internet Explorer 5.0 or greater for Windows.";
var L_ExceedSelectionLimit_Text = "You have selected the maximum number of items.  Switch to the Selected Pictures view to review your selections.";
var L_SlideShowPlayButton_Text = "Play";
var L_SlideShowPauseButton_Text = "Pause";
var L_SlideShowStopButton_Text = "Stop";
var L_SlideShowPrevButton_Text = "Previous";
var L_SlideShowNextButton_Text = "Next";
var items = new Array;
var firstId = -1;    
var fSelectFieldAppeared = false;
var previewedId = 0;
var layoutUrl = "../../_layouts/" + L_Language_Text + "/";
var currentRecursiveViewStyle = "";
var currentRootFolder = "";
var ids = new Array;
var fAllSelected = false;
var selectedIdsStr = "";
var filterIdsStr = "";
var fSelectedView = false;
var currentViewGuid = "";
var fInitSelection = false;
var detailStyleText = "";
var currentViewStyle = "";
var selectedViewLink = null;
var currentViewLink = null;
var vCurrentListID = "";
var vCurrentListUrlAsHTML = "";
var urlCmdForDisplay = "";
var fNewItem = false;
var fInit = false;
var tbImg = null;
var tbTitle = null;
var tbPreview = null;
var hilitedRow = null;
var previewTimer = -1;
var timedItem = -1;
var currentPicture = 0;
var currentStrip = 0;
var stripSize = 5;
var listDirection = "ltr";
var lastMenuId = "";
var firstIdWithCheckbox = -1;
var fInitAttempted = false;
var fRecursive = false;
var fRTL = false;
var fEmptyView = false;
var fWebFldrView = false;
var fFilterOn = false;
var fInitViewStyle = false;
var fNextImageLoaded = false;
var fNeedReload = false;
var fEditingInProcess = false;
var listInfo = null;
var fIsInGroupByView = false;
var unverifiedSelectionIdsCount = 0;
var verifiedSelectionIdsCount  = 0;
 var selectionLimit = 200; 
function CListInfo(webWidth, webHeight, thumbSize)
{
    if (webWidth >= 160 && webWidth < 1280)
    {
        this.webImageWidth = webWidth;
    }
    else
    {
        this.webImageWidth = 640;
    }
    if (webHeight >= 160 && webHeight < 1280)
    {
        this.webImageHeight = webHeight;
    }
    else
    {
        this.webImageHeight = 640;
    }
    if (thumbSize >= 20 && thumbSize <= this.webImageWidth && thumbSize <= this.webImageHeight)
    {
        this.thumbnailSize = thumbSize;
    }
    else
    {
        this.thumbnailSize = 160;
    }
}
function CreateDerivedImageUrl(originalImageUrl, subdirStr)
{
    var url = originalImageUrl.replace(/\.([^\.]+)$/, "_$1");
    url = url + ".jpg";
    url = url.replace(/\/([^\/]+)$/, subdirStr + "$1");
    return url;
}
function EncodedThumbnailImage(id)
{
    if (id == null || items[id] == null)
        return;
    if (items[id].objType == 1)
    {
        return items[id].thumbnail;
    }
    else if (items[id].fUnknownImageType == true)
    {
        return items[id].thumbnail;
    }
    else
    {
        var thumbnailUrl = CreateDerivedImageUrl(items[id].originalImg,  "/_t/");
        return thumbnailUrl;
    }
}
function EncodedWebImage(id)
{
    if (id == null || items[id] == null)
        return;
    if (items[id].objType == 1)
    {
        return items[id].webimage;
    }
    else if (items[id].fUnknownImageType == true)
    {
        return items[id].webimage;
    }
    else
    {
        var webimgUrl = CreateDerivedImageUrl(items[id].originalImg,  "/_w/");
        return webimgUrl;
    }
}
function ViewEmptyScript( webImageWidth, webImageHeight, thumbnailSize)
{
    listInfo = new CListInfo(webImageWidth, webImageHeight, thumbnailSize);
    fEmptyView = true;
    InitViewUrls();
    InitItems();
    AddSelectAllCheckbox();
    return;
}
function WebFolderViewInit(listGuid)
{
    if (browseris.ie5up && browseris.win32)
    {
        fWebFldrView = true;
        InitViewUrls();
        vCurrentListID = listGuid;
        InitSelection();
    }
}
function GotoInfoPage(reason)
{
    if (reason == null || reason == "")
        return;
    var infopageUrl = layoutUrl + "infopage.aspx?List=" + vCurrentListID;
    infopageUrl += "&reason=" + reason;
    var rootFolder = GetUrlKeyValue("RootFolder");
    if (rootFolder != "")
        infopageUrl += "&RootFolder=" + rootFolder;
    window.location.href = infopageUrl;
}
function MakeFullUrl(folderUrl, siteUrl)
{
    var unescapedFolderUrl = unescapeProperly(folderUrl);
    if (0 == unescapedFolderUrl.indexOf("http://") || 0 == unescapedFolderUrl.indexOf("https://"))
        return unescapedFolderUrl;
    else
        return siteUrl + unescapedFolderUrl;
}
function PLMultipleUploadView()
{
    if (vCurrentListUrlAsHTML == "")
        return false;
    var strListDir = vCurrentListUrlAsHTML.substring(0, vCurrentListUrlAsHTML.length - 1);
    var subwebPos = strListDir.lastIndexOf("/");
    if (subwebPos == -1)
        return false;
    var subwebStr = strListDir.substring(0, subwebPos);
    var colonSlashSlashIndex = subwebStr.indexOf("://");
    if (colonSlashSlashIndex == -1)
        return false;
    var siteUrl = subwebStr;
    var nextSlashPos = subwebStr.indexOf("/", colonSlashSlashIndex + 3);
    if (nextSlashPos != -1)
        siteUrl = subwebStr.substring(0, nextSlashPos);
    var destinationFolder;
    var rootFolder = "";
    if (document.getElementById("destination") != null)
        destinationFolder = document.getElementById("destination").value;
    if (destinationFolder == null || destinationFolder == "")
        rootFolder = GetUrlKeyValue("RootFolder");
    var fUploadStarted = false;
    if (destinationFolder != "")
    {
       fUploadStarted = StartOIS("ois.exe /upload \"" + MakeFullUrl(destinationFolder, siteUrl) + "\"");
    }
    else if (rootFolder != "")
    {
       fUploadStarted = StartOIS("ois.exe /upload \"" + MakeFullUrl(rootFolder, siteUrl) + "\"");
    }
    else
    {
       fUploadStarted = StartOIS("ois.exe /upload \"" + vCurrentListUrlAsHTML + "\"");
    }
    if (!fUploadStarted)
        return false;
    layoutUrl = subwebStr + "/_layouts/" + L_Language_Text + "/";
    GotoInfoPage("uploading");
    return true;
}
function _EditSelectedImages()
{
    if (!browseris.ie || !browseris.win32)
    {
        alert(L_IEOnlyFeature_Text);
        return;
    }
    if (!fImglibDefautlView)
    {
        alert(L_NotOurView_Text);
        return;    
    }
    if (tbPreview == null)
    {
        alert( L_NotAvailableOnWebPart_Text);
        return;
    }
    var ids = MakeSelectionStr();
    ids = ids.replace(/\;/g, " ");
    if (ids == "")
    {
        alert(L_NoImageSelected_Text);
        return;
    }
    if (vCurrentListUrlAsHTML == "")
        return;
    var cmdLine = "ois.exe /editSP ";
    cmdLine += "\"" + vCurrentListUrlAsHTML + "\" " + ids;
    if  (StartOIS(cmdLine))
    {
        fEditingInProcess = true;
        SaveSelection();
        GotoInfoPage("editing");
    }
    else
        GotoInfoPage("noclient");
}
function EditSingleImage(id)
{
    if (!browseris.ie || !browseris.win32)
    {
        alert(L_IEOnlyFeature_Text);
        return;
    }
    if (id == "")
        return;
    if (vCurrentListUrlAsHTML == "")
        return;
    var cmdLine = "ois.exe /editSP ";
    cmdLine += "\"" + vCurrentListUrlAsHTML + "\" " + id;
    if  (StartOIS(cmdLine))
    {
        fEditingInProcess = true;
        SaveSelection();
        GotoInfoPage("editing");
    }
    else
        GotoInfoPage("noclient");
}
function SendImagesCore(selectionIds, strListDir)
{
    if (!browseris.ie || !browseris.win32)
    {
        alert(L_IEOnlyFeature_Text);
        return true;
    }
    if (selectionIds == "")
    {
        alert(L_NoImageSelected_Text);
        return true;
    }
    var cmdLine = "ois.exe /sendto \"" + strListDir + "\" " + selectionIds;
    return StartOIS(cmdLine);
}
function _SendImages()
{
    if (!browseris.ie || !browseris.win32)
    {
        alert(L_IEOnlyFeature_Text);
        return;
    }
    if (!fImglibDefautlView)
    {
        alert(L_NotOurView_Text);
        return;    
    }
    if (tbPreview == null)
    {
        alert( L_NotAvailableOnWebPart_Text);
        return;
    }
    var selectionIds = MakeSelectionStr();
    if (selectionIds == "")
    {
        alert(L_NoImageSelected_Text);
        return;
    }
    if (vCurrentListUrlAsHTML == "")
        return;
    if (!SendImagesCore(selectionIds, vCurrentListUrlAsHTML))
        GotoInfoPage("noclient");
}
function _DownloadImages()
{
    if (!browseris.ie || !browseris.win32)
    {
        alert(L_IEOnlyFeature_Text);
        return;
    }
    if (!fImglibDefautlView)
    {
        alert(L_NotOurView_Text);
        return;    
    }
    if (tbPreview == null)
    {
        alert( L_NotAvailableOnWebPart_Text);
        return;
    }
    var selectionIds = MakeSelectionStr();
    if (selectionIds == "")
    {
        alert(L_NoImageSelected_Text);
        return;
    }
    var advancedAspxUrl = layoutUrl + "Dladvopt.aspx?List=" + vCurrentListID +  "&SelectedIds=" + selectionIds + "&ViewUI=1";
    var rootFolder = GetUrlKeyValue("RootFolder");
    if (rootFolder != "")
        advancedAspxUrl += "&RootFolder=" + rootFolder;
    window.location.href = advancedAspxUrl;
}
function DownloadOriginalImage(id)
{
    if (tbPreview == null)
    {
        alert( L_NotAvailableOnWebPart_Text);
        return;
    }
    if (id == null || items[id] == null || items[id].objType != 0)
        return;
    var downloadHref = layoutUrl + "download.aspx?List=" + vCurrentListID + "&ItemId=" + id + "&Version=0";
    window.location.href = downloadHref;
}
function GetLinks(lnkId)
{
    if (browseris.ie)
        return document.all(lnkId);
    else
        return document.links[lnkId];
}
function InitImglibView(listID, languageText)
{
	vCurrentListID = listID;
	if (languageText == null)
		layoutUrl = "../../_layouts/" + L_Language_Text + "/";
	else
		layoutUrl = "../../_layouts/" + languageText + "/";
}
function RedirectToCorrectSelectView()
{
    fRecursive = true;
    fSelectedView = false; 
    InitSelection();
    LoadSelection();
    var currentUrl = window.location.href;
    var qmarkPosition = currentUrl.indexOf("?");
    var suffix = "";
    var viewUrl = "";
    if (qmarkPosition != -1)
    {
        suffix = currentUrl.substring(qmarkPosition + 1, currentUrl.length);
        viewUrl = currentUrl.substring(0, qmarkPosition);
    }
    else
    {
        viewUrl = currentUrl;
    }
    sortField = /SortField=[^&]*/i;
    sortDir = /SortDir=[^&]*/i;
    var sortFieldStr = suffix.match(sortField);
    var sortDirStr = suffix.match(sortDir);
    var idsStr=MakeSelectionStr();
    if (idsStr == "")
        idsStr = "none";
    viewUrl += "?" + "View=" + currentViewGuid + "&FilterName=ID&FilterMultiValue=" + idsStr;
    if (sortFieldStr != null && sortDirStr != null)
    {
        viewUrl += "&" + sortFieldStr + "&" + sortDirStr;
    }
    window.open(viewUrl, "_self", "", true);
}
function InitViewUrls()
{
    var currentUrl = window.location.href;
    var qmarkPosition = currentUrl.indexOf("?");
    var suffix = "";
    var viewUrl = "";
    if (qmarkPosition != -1)
    {
        suffix = currentUrl.substring(qmarkPosition + 1, currentUrl.length);
        viewUrl = currentUrl.substring(0, qmarkPosition);
    }
    else
    {
        viewUrl = currentUrl;
    }
    if (!browseris.ie5up || !browseris.win32)
    {
        if (fSelectedView)
        {
            alert(L_SelectedViewError_Text);
            var newViewUrl = viewUrl.replace(/\/forms\/[^\/]*$/i, "/");
            window.location.href = newViewUrl;
            return;
        }
    }
    currentRootFolder = suffix.match(/RootFolder=[^&]*/);
    var queryVariables = suffix.split("&");
    var filterSubstr = suffix.match(/View=([^&]*)&FilterName=ID&FilterMultiValue=([^&]*)/);
    var fIncompleteSelectedView = false;
    if (fSelectedView)
    {
        if (filterSubstr != null)
        {
            filterIdsStr = filterSubstr[1];
        }
        else
        {
            RedirectToCorrectSelectView();
        }
    }
    suffix = "";
    for (var i = 0; i < queryVariables.length; i ++)
    {
        if (queryVariables[i].match(/Filter=1/))
        {
            fFilterOn = true;
        }
    }
    links = GetLinks("onetidViewSelector");
    if (links != null && links.length > 1)
    {
        for (i = 0; i < links.length; i ++)
        {
            var viewClassName = links[i].parentElement.parentElement.parentElement.parentElement.parentElement.className;
            if (viewClassName.match(/ms-selectednav/))
            {
                currentViewLink = links[i];
            }
        }
        if (currentViewLink != null && !fEmptyView && !fWebFldrView && browseris.ie5up && browseris.win32)
        {
            var viewSelectionStr = "<TABLE border=0 cellspacing=0 cellpadding=0>";
            var curviewGifString = ctx.imagesPath+ "curview.gif" + "\">";
            var spaceGifString = ctx.imagesPath+ "blank.gif" + "\">";
            viewSelectionStr += "<TR><TD align=center valign=middle><img id=imgViewlist src=\"";
            viewSelectionStr += (currentViewStyle == "list")?curviewGifString:spaceGifString;                
            viewSelectionStr += "</TD><TD><TABLE><TR><TD align=center valign=middle style='padding-top:3'><A href=javascript:SwitchViewStyle('list')><img border=0 src=\"" + ctx.imagesPath + "detail.gif\" alt=" + L_ListStyle_Text + "></A></TD><TD nowrap><A href=javascript:SwitchViewStyle('list')>";
            viewSelectionStr += L_ListStyle_Text;
            viewSelectionStr += "</A></TD></TR></TABLE></TD></TR>";
            viewSelectionStr += "<TR><TD align=center valign=center><img id=imgViewthumbnail src=\"";
            viewSelectionStr += (currentViewStyle == "thumbnail")?curviewGifString:spaceGifString;                
            viewSelectionStr += "</TD><TD><TABLE><TR><TD align=center valign=middle><A href=javascript:SwitchViewStyle('thumbnail')><img border=0 src=\"" + ctx.imagesPath + "tbnail.gif\" alt=" + L_ThumbnailStyle_Text + "></A></TD><TD nowrap><A href=javascript:SwitchViewStyle('thumbnail')>";
            viewSelectionStr += L_ThumbnailStyle_Text;
            viewSelectionStr += "</A></TD></TR></TABLE></TD></TR>";
            viewSelectionStr += "<TR><TD align=center valign=center><img id=imgViewfilmstrip src=\"";
            viewSelectionStr += (currentViewStyle == "filmstrip")?curviewGifString:spaceGifString;
            viewSelectionStr += "</TD><TD><TABLE><TR><TD align=center valign=middle style='padding-bottom:3'><A href=javascript:SwitchViewStyle('filmstrip')><img border=0 src=\"" + ctx.imagesPath + "filmstrp.gif\" alt=" + L_FilmstripStyle_Text + "></A></TD><TD nowrap><A href=javascript:SwitchViewStyle('filmstrip')>";
            viewSelectionStr += L_FilmstripStyle_Text;
            viewSelectionStr += "</A></TD></TR></TABLE></TD></TR></TABLE>";
            currentViewLink.parentElement.insertAdjacentHTML("beforeEnd", viewSelectionStr);
            var titleWebImg = document.getElementById("onetidtpweb1");
            if (titleWebImg != null)
                titleWebImg.parentElement.width = 130;      
        }        
    }
}
function SwitchViewStyle(style)
{
    if (style == currentViewStyle || fEmptyView)
        return;
    if (tbPreview != null)
    {
        document.images["imgView" + currentViewStyle].src = ctx.imagesPath + "blank.gif";
        if (style == "filmstrip")
        {
            document.getElementById("contentfilmstrip").style.display="block";
            document.getElementById("contentthumbnail").style.display="none";
            document.getElementById("selectionCacheMgr").parentElement.parentElement.style.display="none";
            if (stripSize > 0)
            {
                document.images["fstb0"].focus();
            }
        }
        else if (style == "thumbnail")
        {
            document.getElementById("contentfilmstrip").style.display="none";
            document.getElementById("contentthumbnail").style.display="block";
            document.getElementById("selectionCacheMgr").parentElement.parentElement.style.display="none";
        }
        else
        {
            document.getElementById("contentfilmstrip").style.display="none";
            document.getElementById("contentthumbnail").style.display="none";
            document.getElementById("selectionCacheMgr").parentElement.parentElement.style.display="block";
        }
        currentViewStyle = style;
        document.images["imgView" + currentViewStyle].src = ctx.imagesPath + "curview.gif";
        if (currentViewStyle == "list")
            tbPreview.style.display = "block";
        else
            tbPreview.style.display = "none";
    }   
    InitSelection();
}
function NextSelectionOverLimit( newCount )
{
    if (( unverifiedSelectionIdsCount + verifiedSelectionIdsCount + newCount ) > selectionLimit)
        return true;
    return false;
}
function ToggleSelection(id)
{
    if (tbPreview == null)
        return;
    if (id < 0 || items[id] == null)
        return;
    if (items[id].fSelected == false)
    {
        if (NextSelectionOverLimit(1))
        {
            UIChange(id, false);
            alert(L_ExceedSelectionLimit_Text);
            return false;
        }
        else
        {
            items[id].fSelected = true;
            verifiedSelectionIdsCount ++;
            UIChange(id, true);
        }
    }
    else
    {
        items[id].fSelected = false;
        verifiedSelectionIdsCount --;
        UIChange(id, false);
    }
    SaveSelection();
    ConstructSelectionHref();
}
function ToggleSelectionAll()
{
    if (tbPreview == null)
        return;
    var i;
    var fSelect = !fAllSelected;
    var selectionChangeCount = 0;
    for (i = 0; i < ids.length; i ++)
    {
        if (items[ids[i]].fSelected != fSelect)
            selectionChangeCount ++;
    }
    if (fSelect)
    {
        if (NextSelectionOverLimit(selectionChangeCount))
        {
            alert(L_ExceedSelectionLimit_Text);
            return;
        }
        verifiedSelectionIdsCount = verifiedSelectionIdsCount + selectionChangeCount;
    }
    else
    {
        verifiedSelectionIdsCount = verifiedSelectionIdsCount - selectionChangeCount;
    }
    for (i = 0; i < ids.length; i ++)
    {
        items[ids[i]].fSelected = fSelect;
        UIChange(ids[i], fSelect);
    }
    SaveSelection();
    ConstructSelectionHref();
}
function ConstructSelectionHref()
{
    var selectionStr = MakeSelectionStr();
    if (selectionStr == "")
        selectionStr = "none";
    var imgSelectAll = document.images["cbxSelectAll"];
    if (imgSelectAll != null)
    {
        if (fAllSelected)
            imgSelectAll.src = ctx.imagesPath + "checkall.gif";
        else
            imgSelectAll.src = ctx.imagesPath + "unchecka.gif";
    }
    if (currentViewLink == null || !fSelectedView)
        return;
    var currentUrl = window.location.href;
    var qmarkPosition = currentUrl.indexOf("?");
    var queryString = "";
    var viewUrl = currentUrl;
    if (qmarkPosition != -1)
    {
        viewUrl = currentUrl.substring(0, qmarkPosition);
        queryString = currentUrl.substring(qmarkPosition + 1, currentUrl.length);
    }
    currentViewLink.href = viewUrl + "?" + "View=" + currentViewGuid + "&FilterName=ID&FilterMultiValue="+ selectionStr;
}
function LoadSelection()
{
    if (!fInitSelection)
    {
//@cc_on
//@if (@_jscript_version >= 5)
//@	try {
//@    selectionCacheMgr.load("OISSelectionStore");
//@ } catch (e) {
//@    return;
//@ };
//@else
                        return;
//@end
    }
    selectedIdsStr = "";
    var fWrongList = false;
    if (selectionCacheMgr.getAttribute("listGuid") && vCurrentListID != "")
    {
        savedListGuid = selectionCacheMgr.getAttribute("listGuid");
        if (savedListGuid != vCurrentListID)
        {
            fWrongList = true;
        }
    }
    if (selectionCacheMgr.getAttribute("cachedValue") && !fWrongList)
    {
        selectedIdsStr = selectionCacheMgr.getAttribute("cachedValue");
        selectionCacheMgr.innerText = selectedIdsStr;
        var selIds = selectedIdsStr.split(";");
        var selNum = selIds.length;
        selectedIdsStr = "";
        unverifiedSelectionIdsCount = 0;
        verifiedSelectionIdsCount = 0;
        for (var i = 0; i < selNum; i ++)
        {
            var selId = parseInt(selIds[i]);
            var fIdMatched = false;
            var j;            
            if (isNaN(selId))
            {
                continue;
            }
            for (j = 0; j < ids.length; j ++)
            {
                if (ids[j] == selId)
                {
                    if (!NextSelectionOverLimit(1))
                    {
                        items[ids[j]].fSelected = true;
                        verifiedSelectionIdsCount ++;
                        UIChange(selId, true);
                    }
                    fIdMatched = true;
                    break;
                }
            }
            if (!fIdMatched && !fSelectedView)
            {
                if (!NextSelectionOverLimit(1))
                {
                    if (selectedIdsStr == "")
                        selectedIdsStr = selIds[i];
                    else
                        selectedIdsStr += ";" + selIds[i];
                    unverifiedSelectionIdsCount ++;
                }
            }
        }
    }
    var needReload = selectionCacheMgr.getAttribute("Reload");
    if (needReload == "1")
        fNeedReload = true;
}
function InitSelection()
{
//@cc_on
//@if (@_jscript_version >= 5)
//@	try {
//@    selectionCacheMgr.load("OISSelectionStore");
//@ } catch (e) {
//@    if (!fInitAttempted) {fInitAttempted = true; setTimeout("InitSelection()", 500);} return;
//@ };
//@else
                        return;
//@end
    fInitSelection = true;
    if (!fInitViewStyle)
    {
        fInitViewStyle = true;
        var viewStyle = "thumbnail";
        if (selectionCacheMgr.getAttribute("viewStyle"))
        {
            var viewStyle = selectionCacheMgr.getAttribute("viewStyle");
            if (viewStyle != "list" && viewStyle != "filmstrip")
            {
                viewStyle = "thumbnail";
            }
            if (fFilterOn || fIsInGroupByView)
                viewStyle = "list";
        }
        if (!fWebFldrView)
        {
           if (!fRecursive)
            {
                SwitchViewStyle(viewStyle);
                if (viewStyle == "filmstrip")
                    ClickFrame(currentPicture);
            }
            else
            {
                currentViewStyle = viewStyle;   
            }
        }
        else
        {
            currentViewStyle = viewStyle;
        }
    }
    LoadSelection();
    var fReloadPending = fNeedReload;
    fNeedReload = false;
    SaveSelection();
    if (fReloadPending)
        window.location.reload(true);
    ConstructSelectionHref();
    return;
}
function ClearSelections()
{
    if (!fInitSelection)
        return;
    selectedIdsStr = "";
    var i;
    for (i = 0; i < ids.length; i ++)
    {
        items[ids[i]].fSelected = false;
        UIChange(ids[i], false);
    }
    SaveSelection();
    ConstructSelectionHref();
}
function MakeSelectionStr()
{
    var newSelStr = selectedIdsStr;
    var i;
    fAllSelected = true;
    for (i = 0; i < ids.length; i ++)
    {
        if (items[ids[i]].fSelected == true)
        {
            if (newSelStr == "")
            {
                newSelStr = "" + ids[i];
            }
            else
            {
                newSelStr += ";" + ids[i];
            }
        }
        else if (items[ids[i]].objType == 0)
        {
            fAllSelected = false;
        }
    }
    return newSelStr;
}
var expirationInMilSeconds = 604800000; 
function SaveSelection()
{
    if (browseris.ie5up && browseris.win32 && fInitSelection)
    {
        selectionCacheMgr.setAttribute("cachedValue", MakeSelectionStr());
        selectionCacheMgr.setAttribute("viewStyle", currentViewStyle);
        selectionCacheMgr.setAttribute("listGuid", vCurrentListID);
        if (fEditingInProcess)
            selectionCacheMgr.setAttribute("Reload", "1");
        else
            selectionCacheMgr.setAttribute("Reload", "0");
        var oTimeNow = new Date(); 
        oTimeNow.setTime(oTimeNow.getTime() + expirationInMilSeconds);
        var sExpirationDate = oTimeNow.toUTCString();
        selectionCacheMgr.expires = sExpirationDate;
        selectionCacheMgr.save("OISSelectionStore");
    }
    return;
}
function CreateRootFolderHref(id)
{
    if (id == null || items[id] == null)
        return "";
    if (items[id].objType != 1)
        return "";
    var currentHref = window.location.href;
    if (!ctx.recursiveView)
    {
        var folderHref = "RootFolder=" + escapeProperly(items[id].originalImg);
        if (-1 == currentHref.indexOf("?"))
        {
            currentHref = currentHref + "?" + folderHref;
        }
        else if (currentHref.match(/RootFolder=/))
        {
            currentHref = currentHref.replace(/RootFolder=[^&]*/, folderHref);
        }
        else
        {
            currentHref = currentHref + "&" + folderHref;
        }
    }
    currentHref = currentHref.replace(/&p_\w+=[^&]*/g, "");
    currentHref = currentHref.replace(/&PageFirstRow=[^&]*/, "");
    currentHref = currentHref.replace(/&View=[^&]*/, "");
    currentHref = currentHref.replace(/\?Paged=TRUE&/, "?");
    if (-1 == currentHref.indexOf("?"))
        return currentHref + "?View=" + currentViewGuid;
    else
        return currentHref + "&View=" + currentViewGuid;
}
function DisplayItemUrl(id)
{
    if (id == null || items[id] == null)
        return "";
    if (items[id].objType == 1)
    {
        return CreateRootFolderHref(id);
    }
    else if (items[id].fUnknownImageType == true)
    {
        return items[id].originalImg;
    }
    else
    {
        var cmd = "";
        if (urlCmdForDisplay == null)
            return;
        cmd = urlCmdForDisplay + "&ID=" + id;
        cmd += "&Source=" + GetSource();
        var menuTR = document.all("title" + id);
        if (menuTR != null)
        {
            var fileDir = menuTR.parentElement.parentElement.FileDirRef;
            if (fileDir != null && fileDir != "")
            {
                fileDir = escapeProperly("/" + fileDir);
                cmd = cmd.replace(/RootFolder=[^&]*&/, "");
                cmd = cmd + "&RootFolder=" + fileDir;
            }
        }
        return cmd;
    }
}
function CallDisplayItem(id)
{
    if (id == null || items[id] == null)
        return;
    window.location.href = DisplayItemUrl(id);
}
function DisplayItemOnFileRef(id)
{
    if (!browseris.ie5up || !browseris.win32)
    {
        CallDisplayItem(id);
        return false;
    }
    if (browseris.ie55up)
    {
        CallDisplayItem(id);
        return false;
    }
    else
    {
        event.cancelBubble = true;
        CallDisplayItem(id);
        return true;
    }
}
function CallEditItem(id)
{
    var cmd = "";
    if (urlCmdForDisplay == null)
        return;
    cmd = urlCmdForDisplay + "&ID=" + id;
    cmd += "&Source=" + GetSource();
    var menuTR = document.all("title" + id);
    if (menuTR != null)
    {
        var fileDir = menuTR.parentElement.parentElement.FileDirRef;
        if (fileDir != null && fileDir != "")
        {
            fileDir = escapeProperly("/" + fileDir);
            cmd = cmd.replace(/RootFolder=[^&]*&/, "");
            cmd = cmd + "&RootFolder=" + fileDir;
        }
    }
    var editUrl = cmd.replace(/dispform\.aspx/i, "EditForm.aspx");
    if (editUrl != "")
        window.location.href = editUrl;
}
function _DeleteImages()
{
    if (tbPreview == null)
    {
        alert( L_NotAvailableOnWebPart_Text);
        return;
    }
    if (!fImglibDefautlView)
    {
        alert(L_NotOurView_Text);
        return;    
    }
    var selectionStr = MakeSelectionStr();
    if (selectionStr == "")
    {
        alert(L_NoImageSelected_Text);
        return;
    }
    if (layoutUrl == "")
        return;             
    else if (confirm(L_DeleteMultipleItems_Text))
    {
        var deleteUrl = layoutUrl + "DeleteMu.aspx";
        deleteUrl += "?ListId=" + vCurrentListID+ "&SelectedIds=" + MakeSelectionStr();
        if (currentRootFolder != "" && currentRootFolder != null)
            deleteUrl += "&" + currentRootFolder;
        var form = document.forms[MSOWebPartPageFormName];
        if (null != form)
        {
            ClearSelections();
            form.action = deleteUrl;
            form.method="POST";
            form.submit();
        }
    }
}
function ShareList()
{
    if (layoutUrl == "")
        return;             
    var shareUrl = layoutUrl +"shropt.aspx?obj=" + vCurrentListID + "%2Clist";
    window.location.href = shareUrl;
}
function GetUint(str)
{
    var ui = parseInt(str.replace(/,/g, ""));
    if (ui > 0)
        return ui;
    return 0;
}
function GetScaleRatio(w, h, spaceW, spaceH)
{
    var ratio1 = (spaceW * 1.) / w;
    var ratio2 = (spaceH * 1.) / h;
    var ratio = (ratio1 > ratio2) ? ratio2 : ratio1;
    if (ratio > 1)
        ratio = 1;
    return ratio;
}
function GetHeight(w, h, spaceW, spaceH)
{
    if (w == 0 || h == 0)
        return spaceH;
    var result = h * GetScaleRatio(w, h, spaceW, spaceH);
    if (result < 1.0)
        return 1;
    else
        return result;
}
function GetWidth(w, h, spaceW, spaceH)
{
    if (w == 0 || h == 0)
        return spaceH;
    var result = w * GetScaleRatio(w, h, spaceW, spaceH);
    if (result < 1.0)
        return 1;
    else
        return result;
}
function UIChangeList(id, fSelected)
{
    if (id < 0 || items[id] == null)
        return;
    if (items[id].objType != 0)
        return;
    var chkBox = document.getElementById("cbx_" + id);
    if (chkBox != null)
    {
        chkBox.checked = fSelected;
    }
    if (!browseris.ie5up || !browseris.win32)
        return;
    var row = document.getElementById("row" + id);
    if (row != null)
    {
        if (fSelected == true)
            row.className = "ms-imglibselectedrow";
        else
            row.className = "";
    }
}
function MouseOverRow(id)
{
    if (tbPreview == null)
        return;
    if (FILIsMenuShown() == 1)
        return;
    if (timedItem != id)
    {
        if (previewTimer >= 0)   clearTimeout(previewTimer);
        previewTimer = setTimeout("HiLiteRow(" + id + ")", 200);
        timedItem = id;
    }
}
function MouseOutRow(id)
{
    if (tbPreview == null)
        return;
    if (FILIsMenuShown() == 1)
        return;
    if (previewTimer >= 0 && timedItem == id)   
    {
        clearTimeout(previewTimer);
        previewTimer = -1;
        timedItem = -1;
    }
}
function HiLiteRow(id)
{
    if (!fImglibDefautlView) return;    
    if (fInit == false)
    {
        InitItems();
        fInit = true;
    }
    if (id < 0 || items[id] == null)
        return;
    if (tbPreview == null)
        return;                     
    previewedId = id;
    if (tbImg)
    {
        tbImg.src = EncodedThumbnailImage(id);
        tbImg.width = GetWidth(items[id].imgWidth, items[id].imgHeight, 120, 90);
        tbImg.height = GetHeight(items[id].imgWidth, items[id].imgHeight, 120, 90);
    }
    if (tbTitle)
    {
        tbTitle.innerHTML = items[id].caption;
    }
    if (!browseris.ie5up || !browseris.win32)
        return;
    var row = document.getElementById("title" + id);
    if (row != null)
    {
        if (hilitedRow == row)
            return;
        else if (hilitedRow != null)
        {
            hilitedRow.children[1].style.visibility="hidden";
            hilitedRow.parentElement.parentElement.className = "ms-unselectedtitle";
        }
        hilitedRow = row;
        row.children[1].className = "ms-menuimagecell";
        row.children[1].style.visibility="visible";
        row.parentElement.parentElement.className = "ms-selectedtitle";
    }
}
function ClickRow(id)
{
    if (!fImglibDefautlView) return;    
    if (tbPreview == null)
        return;
    if (id < 0 || items[id] == null)
        return;
    if (browseris.ie)
        event.cancelBubble = true;
    HiLiteRow(id);
    ILShowMenu(id);
}
function ContextMenuOnRow(id)
{
    if (!browseris.ie55up || !browseris.win32)
        return true;
    if (event.srcElement.tagName == "A" )
        return true;
    ClickRow(id);
    return false;
}
function FILIsMenuShown()
{
    if (!browseris.ie5up || !browseris.win32)
        return false;
    if (lastMenuId == "")
        return 0;
    var m = document.all(lastMenuId);
    if (m != null)
	{
		var fIsOpen = false;
//@cc_on
//@if (@_jscript_version >= 5)
//@ try {
//@  fIsOpen = m.isOpen();
//@ } catch (e) {};
//@else
//@end
		if (!fIsOpen)
			lastMenuId = "";
		return fIsOpen;
	}
	return 0;
}
function ILShowMenu(itemID) 
{
    if (!browseris.ie5up || !browseris.win32)
        return;
    if (!browseris.ie55up)
    {
        CallEditItem(itemID);
        return;
    }
    var menuId = "plmenu_" + itemID;
    var m = document.getElementById(menuId);
    if (m == null)
    {
        m = CMenu(menuId);
    }
    else
    {
        m.innerHTML = "";
    }
    currentItemID = itemID;
    currentItemFileUrl = items[itemID].originalImg;
    currentItemFSObjType = items[itemID].objType;
    itemId = itemID;
    var menuTR = document.getElementById("title" + itemID);
    if (menuTR != null)
    {
        currentItemCheckedOutUserId = menuTR.COUId;
        itemTable = menuTR.parentElement.parentElement;
        if (items[itemID].fUnknownImageType == false)
        {
            itemTable.IsImage = "1";
        }
        else if (items[itemID].objType != 1)
        {
            itemTable.IsImage = "";
        }
    }
    ctx.isWebEditorPreview = 0;
    AddDocLibMenuItems(m, ctx);
    lastMenuId = menuId;
    if (menuTR != null)
    {
        OMenu(m, menuTR.parentElement.parentElement);
    }
    else
    {   
        OMenu(m, window.event.srcElement.parentElement);
    }
}
function InitItems()
{
    tbImg = document.images["ImgPreviewThumbnail"];
    if (browseris.ie)
    {
        tbPreview = document.getElementById("ImgPreviewTable");
        tbTitle = document.getElementById("lnkPreviewTitle");
    }
    else
    {
        if (browseris.nav6up)
        {
            tbPreview = document.getElementById("ImgPreviewTable");
            if (tbPreview != null)
                tbPreview.style.display = "block";
        }
        tbTitle = document.anchors["lnkPreviewTitle"];
    }
}
function AddSelectAllCheckbox()
{
    var chkBox = document.images["diidHeaderImageSelectedFlag"];
    if (chkBox == null)
        return;
    var tdHeadChkBox = null;
    if (browseris.nav6up)
        tdHeadChkBox = chkBox.parentNode;
    else
        tdHeadChkBox = chkBox.parentElement;
    if (tdHeadChkBox == null || tdHeadChkBox.tagName.toLowerCase() != "th")
        return;
    if (firstIdWithCheckbox == -1)
        tdHeadChkBox.innerHTML = "";
    else
    {
        tdHeadChkBox.innerHTML = "<a href='Javascript:ToggleSelectionAll()' onclick='ToggleSelectionAll();return false;'><img style='border:0' src='" + ctx.imagesPath + "unchecka.gif" + "' id=cbxSelectAll alt='" + L_SelectAll_Text +  "'></a>";
        var chkBoxs = document.getElementsByName("selectionCheckBox");
        if (chkBoxs == null)
            return;
        for (i = 0; i < chkBoxs.length; i ++)
        {
            var chkBox = chkBoxs[i];
            if (chkBox != null)
            {
                chkBox.disabled = false;
                chkBox.style.visibility="visible";
                if (browseris.ie)
                {
                    chkBox.parentElement.width = 30;    
                    chkBox.style.height = 18;
                }
            }
        }  
    }
}
function ClickPreview()
{
    CallDisplayItem(previewedId);
}
function ClickThumbnail(id)
{
    CallDisplayItem(id);
}
function UIChangeThumbnail(id, fSelected)
{
	if (items[id] == null || items[id].objType != 0)
		return;
    var tbImg = document.images["tb_" + id];
    if (null == tbImg)
        return;
    var chkBox = document.getElementById("cbxTB_" + id);
    if (chkBox != null)
    {
        chkBox.checked = fSelected;
    }
    if (fSelected)
    {
        tbImg.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.style.background = "#99BBFF";
    }
    else
    {
        tbImg.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.style.background = "";
    }
}
function CreateTile(id)
{
    var cellSize = listInfo.thumbnailSize + 10;
    var str = "";
    if (!browseris.ie)
    {
        return;
    }
    else
    {
        str = "<span class=thumbnail><TABLE><TR height=" + (2 + cellSize) + "><TD  width=" + cellSize + " class=ms-imglibthumbnail align=center>";
        str += "<table border=0 cellspacing=2 cellpadding=0 class=ms-imglibthumbnail><tr height=" + (listInfo.thumbnailSize + 4) + "><td width=" + (listInfo.thumbnailSize + 4) + " align=center verticalAlign=middle>"
        str += "<a href='Javascript:ClickThumbnail(" + id + ")'><img class=thumbnail height=" + GetHeight(items[id].imgWidth, items[id].imgHeight, listInfo.thumbnailSize, listInfo.thumbnailSize) + " id=tb_" + id + " src='" + items[id].thumbnail + "' style='border:0' alt='";
        if (items[id].objType != 0)
        {
            str += L_FolderAlt_Text;
        }
        else if (items[id].fUnknownImageType == true)
        {
            str += L_DocumentAlt_Text;
        }
        else
        {
            str += L_ImgAlt_Text;
        }
        str += "'></img></a>";
        str += "</TD></TR></TABLE>";
        str +="</TD></TR><TR height=0><TD valign=top nowrap";
        if (browseris.ie55up)
            str += ">";
        else
            str += " dir=" + listDirection + ">";
        if (items[id].objType != 1)
            str += "<input type=checkbox title='" + L_SelectionCheckboxMSAATitle_Text + "' id=cbxTB_" + id + " onclick=ToggleSelection(" + id + ")>";
        else
            str += "&nbsp";
        str += "<span style='width:" + (listInfo.thumbnailSize - 20) + ";font-size:80%;text-wrapping:nowrap;overflow:hidden;text-overflow:ellipsis'>" + items[id].caption + "</span>";
        str += "</TD></TR></TABLE></span>\n";
        document.write(str);
    }
}
function UIChangeFilmstrip(id, fSelected)
{
    var item;
    for (item = currentPicture; item < currentPicture + stripSize; item ++)
    {
        if (ids[item] == id)
            break;
    }
    if (item >= currentPicture + stripSize)
        return;
    var cbxObj = document.getElementById("cbxFS_" + (item - currentPicture));
    if (cbxObj != null && cbxObj.tagName.toLowerCase() == "input")
        cbxObj.checked = fSelected;
}
function LoadNextPicture(fAccending)
{
    event.cancelBubble = true;
    if (ids.length <= stripSize)
        return;
    var frmImg = null;
    if (currentStrip >= 0 && currentStrip < stripSize)
    {
        frmImg = document.images["fstb" + currentStrip];
        if (frmImg != null)
        {
            frmImg.parentElement.className = "";
            frmImg.parentElement.style.borderWidth = "0px";
        }
    }
    if (fAccending == 1)
    {
        if (currentPicture + stripSize >= ids.length)
            return;
        currentPicture = currentPicture + 1;
        currentStrip = currentStrip - 1;
    }
    else
    {
        if (currentPicture <= 0)
            return;
        currentPicture = currentPicture  - 1;
        currentStrip = currentStrip + 1;
    }
    for (var i = 0; i < stripSize; i ++)
    {
        var currentId = ids[currentPicture + i];
        var frmImg = document.images["fstb" + i];
        if (frmImg != null)
        {
            frmImg.src = EncodedThumbnailImage(currentId);
            frmImg.height = GetHeight(items[currentId].imgWidth, items[currentId].imgHeight, 96, 96);
            frmImg.width = GetWidth(items[currentId].imgWidth, items[currentId].imgHeight, 96, 96);
            if (items[currentId].objType != 0)
            {
                frmImg.alt = L_FolderAlt_Text;
            }
            else if (items[currentId].fUnknownImageType == true)
            {
                frmImg.alt = L_DocumentAlt_Text;
            }
            else
            {
                frmImg.alt = L_ImgAlt_Text;
            }
        }
        var cbxObj = document.getElementById("cbxFS_" + i);
        if (cbxObj != null && cbxObj.tagName.toLowerCase() == "input")
        {
            if (items[currentId].objType != 0)
            {
                cbxObj.style.display = "none";
                cbxObj.checked = false;
            }
            else
            {
                cbxObj.style.display = "inline";
                cbxObj.checked = items[currentId].fSelected;
            }
        }
        var titleObj = document.getElementById("title_" + i);
        if (titleObj != null)
            titleObj.innerHTML = items[currentId].caption;
    }
    var backGif;
    var forwardGif;
    if (fRTL)
    {
        backGif = ctx.imagesPath + "plslforw.gif";
        forwardGif = ctx.imagesPath + "plslback.gif";
    }
    else
    {
        backGif = ctx.imagesPath + "plslback.gif";
        forwardGif = ctx.imagesPath + "plslforw.gif";
    }
    if (currentPicture == 0)
    {
        document.images["backgif"].parentElement.parentElement.style.display = "none";
    }
    else
    {
        document.images["backgif"].parentElement.parentElement.style.display = "block";
    }
    if (currentPicture + stripSize >= ids.length)
    {
        document.images["forwardgif"].parentElement.parentElement.style.display = "none";
    }
    else
    {
        document.images["forwardgif"].parentElement.parentElement.style.display = "block";
    }
    if (currentStrip >= 0 && currentStrip < stripSize)
    {
        frmImg = document.images["fstb" + currentStrip];
        if (frmImg != null)
        {
            frmImg.parentElement.className = "ms-imglibthumbnail";
            frmImg.parentElement.style.borderWidth = "3px";
        }
    }
    return false;
}
function ClickFrame(frame)
{
    if (frame < 0 || frame >= stripSize)
        return false;
    var currentId = ids[currentPicture + frame];
    previewedId = currentId;
    var frmImg = null;
    if (currentStrip >= 0 && currentStrip < stripSize)
    {
        frmImg = document.images["fstb" + currentStrip];
        if (frmImg != null)
        {
            frmImg.parentElement.className = "";
            frmImg.parentElement.style.borderWidth = "0";
        }
    }
    currentStrip = frame;
    frmImg = document.images["fstb" + currentStrip];
    if (frmImg != null)
    {
        frmImg.parentElement.className = "ms-imglibthumbnail";
        frmImg.parentElement.style.borderWidth = "3px";
        frmImg.focus();
    }
    var imgCur = document.images['CurrentPic'];
    if (imgCur != null)
    {
        var fDelay = 0;
        imgCur.style.visibility = "hidden";
        if (browseris.ie55up && browseris.win32 && items[currentId].objType != 1 && !items[currentId].fUnknownImageType)
        {
            var imgSyncer = document.getElementById("webImageSyncer");
            if (imgSyncer != null && imgSyncer.imagedata != null)
            {
                imgSyncer.imagedata.src = EncodedWebImage(currentId);
                fDelay = 1;
            }
        }
        if (fDelay == 0)
            imgCur.src = EncodedWebImage(currentId);
        else
        {
            window.setTimeout("document.images['CurrentPic'].src = EncodedWebImage(" + currentId + ");", 500);
        }
        imgCur.height = GetHeight(items[currentId].imgWidth, items[currentId].imgHeight, 448, 448);
        imgCur.width = GetWidth(items[currentId].imgWidth, items[currentId].imgHeight, 448, 448);
    }
    var origPicLink = GetLinks("OriginalPicLink");
    var openItemLnk = GetLinks("OpenItemLink");
    if (origPicLink != null)
    {
        if (items[currentId].objType == 1)
        {
            var newHref = CreateRootFolderHref(currentId);
            if (newHref != "")
                origPicLink.href = newHref;
            document.getElementById("descrRow").style.visibility = "hidden";
            imgCur.alt = L_GotoFolder_Text;
        }
        else
        {
            origPicLink.href = items[currentId].originalImg;
            document.getElementById("descrRow").style.visibility = "visible";
            imgCur.alt = L_AltViewProperty_Text;
        }
        origPicLink.href = DisplayItemUrl(currentId);
    }
    if (openItemLnk != null)
    {
        openItemLnk.href = DisplayItemUrl(currentId);
    }
    document.getElementById("titleSpan").innerHTML = items[currentId].caption;
    document.getElementById("descrSpan").innerHTML = items[currentId].description;
    if (items[currentId].fUnknownImageType && items[currentId].objType == 0)
    {
        imgCur.style.display="none";
        document.getElementById("noPreviewSpan").style.display="block";
    }
    else
    {
        imgCur.style.display="block";
        document.getElementById("noPreviewSpan").style.display="none";
    }
    return false;
}
function ToggleSelectedItem(i)
{
    if (i < 0 || i >= stripSize)
        return;
    if (currentPicture + i < ids.length)
        ToggleSelection(ids[currentPicture + i]);
}
function FilmstripTbKeyPressed(frame)
{
    if (event.keyCode != 13)    
        return true;
    event.cancelBubble = true;
    ClickFrame(frame);
    return false;
}
function FilmstripKeyPressed()
{
    var step;
    if (event.keyCode == 37)    
    {
        if (fRTL)
            step = 1;
        else
            step = -1;
    }
    else if (event.keyCode == 39)    
    {
        if (fRTL)
            step = -1;
        else
            step = 1;
    }
    else
        return;
    if (currentStrip < 0 || currentStrip >= stripSize)
    {
        if (step > 0)
            ClickFrame(stripSize - 1);
        else
            ClickFrame(0);
        return;
    }
    var nextStrip = currentStrip + step;
    if (nextStrip < 0 || nextStrip >= stripSize)
    {
        LoadNextPicture(step == 1);
    }
    nextStrip = currentStrip + step;
    if (nextStrip < 0 || nextStrip >= stripSize)
    {
        if (step > 0)
            ClickFrame(stripSize - 1);
        else
            ClickFrame(0);
        return;
    }
    ClickFrame(nextStrip);
}
function CreateStrip()
{
    var str1;
    var str11 = ")' onkeydown='Javascript:FilmstripTbKeyPressed(";
    var str113 = ");'><TABLE style='cursor:pointer' WIDTH=108 border=0 cellspacing=0 cellpadding=0><TR height=108><TD" ;
    var str115 = " width=108 align=center><img onclick='Javascript:ClickFrame(";
    var str2 = "); return false;'" ;
    var str200 = " galleryimg=false border=0 alt='";
    var str20 = "' height=";
    var str21 = " tabindex=0 id=fstb";
    var str3 = " src='";
    var str4 = "'></TD><TR><TD nowrap><input style='width:16' type=checkbox title='" + L_SelectionCheckboxMSAATitle_Text + "' id=cbxFS_";
    var str5 = "><span style='font-size:80%;overflow:hidden;text-overflow:ellipsis; width:90' id=title_";
    var str6 = ">";
    var str7 = "</span></TD></TR></TABLE><td>";
    var strOut;
    var hideCheckBox = " style='display:none'";
    if (browseris.ie5up && browseris.win32)
    {
        str1 = "<td valign=top onclick='ClickFrame(";        
    }
    else
    {
        str1 = "<td width=108 onclick='ClickFrame(";
    }
    if (stripSize > ids.length)
        stripSize = ids.length;
    document.write("<table><tr>");
    for (var i = 0; i < stripSize; i ++)
    {
        strOut = str1 + i + str11 + i + str113; 
        if (i == currentStrip)
            strOut += " class=ms-imglibthumbnail border:3";
        strOut += str115 + i + str2 + i + str200;
        if (items[ids[i]].objType == 1)
            strOut += L_FolderAlt_Text;
        else if (items[ids[i]].fUnknownImageType == true)
            strOut += L_DocumentAlt_Text;
        else
            strOut += L_ImgAlt_Text;
        strOut += str20 + GetHeight(items[ids[i]].imgWidth, items[ids[i]].imgHeight, 96, 96) + str21 + i + str3 + items[ids[i]].thumbnail + str4 + i;
        strOut += " onclick=ToggleSelectedItem(" + i + ")";
        if (items[ids[i]].objType == 1)
            strOut += hideCheckBox;
        strOut += str5 + i +str6 + items[ids[i]].caption + str7;
        document.write(strOut);
    }
    document.write("</tr></table>");
}
function UIChange(item, fSelected)
{
    if (browseris.ie && tbPreview != null)
    {
        UIChangeThumbnail(item, fSelected);
        UIChangeFilmstrip(item, fSelected);
    }
    UIChangeList(item, fSelected);
}
function GenerateFooterContent(viewStyle, fVisible)
{
    if (viewStyle == "thumbnail")
    {
        if (browseris.ie)
        {
            var str = "<TABLE id=contentthumbnail";
            if (!fVisible)
                str += " style='display:none'";
            str += " border=0 cellspacing=0 cellpadding=3 width='100%'><TR><TD" 
            if (browseris.ie55up)
                str += " dir=" + listDirection + ">";
            else      
                str += " dir=ltr>";
            document.write(str);
            for (j = 0; j < ids.length; j ++)
                CreateTile(ids[j]);
            document.write("</TD></TR></TABLE>");
        }
    }
    else if (viewStyle == "filmstrip")
    {
        if (currentPicture + stripSize > ids.length)
            currentPicture = ids.length - stripSize;
        if (currentPicture < 0)
            currentPicture = 0;
        currentStrip = 0;
        var currentId = ids[currentPicture + currentStrip];
        previewedId = currentId;
        var strScript = "<TABLE id=contentfilmstrip dir=" + listDirection + " border=0 cellspacing=0 cellpadding=3 width='100%' onkeydown='Javascript:FilmstripKeyPressed()'" ;
        if (!fVisible)
            strScript += "style='display:none'";
        strScript += "><TR>";
        var backGif;
        var forwardGif;
        var blankGif = "/blank.gif";
        if (fRTL)
        {
            backGif = "/forward.gif";
            forwardGif = "/back.gif";
        }
        else
        {
            backGif = "/back.gif";
            forwardGif = "/forward.gif";
        }
        strScript += "<TD valign=center class=ms-imglibmenuarea style='cursor:pointer";
        if (currentPicture == 0)
            strScript += "; display:none";
        strScript += "' onclick='Javascript:LoadNextPicture(0);'><a href='Javascript:LoadNextPicture(0)' onclick='Javascript:LoadNextPicture(0); return false;'><img id=backgif src='" + ctx.imagesPath + backGif + "' border=0 alt=\"" + L_PreviousPicture_Text + "\"></a></TD>";
        strScript += "<TD nowrap align=center width=100%>";
        document.write(strScript);
        CreateStrip();
         strScript = "</TD><TD valign=center class=ms-imglibmenuarea style='cursor:pointer"; 
         if (currentPicture + stripSize >= ids.length)
            strScript += "; display:none";
        strScript += "' onclick='Javascript:LoadNextPicture(1);'><a href='Javascript:LoadNextPicture(1)' onclick='Javascript:LoadNextPicture(1); return false;'><img id=forwardgif src='" + ctx.imagesPath + forwardGif + "' border=0 alt=\"" + L_NextPicture_Text + "\"></a></TD><TR>";
        strScript += "<TR><TD align=center colspan=3><hr>";
        document.write(strScript);
        strScript = "<table class=ms-descriptiontext><tr height=336><td valign=middle align=center width=448><a name='OriginalPicLink' href='" + DisplayItemUrl(currentId)+ "'>";
        strScript = strScript + "<img  onload='CurrentPic.style.visibility=\"visible\";' border=0 tabindex=2 galleryimg=false name='CurrentPic' height=" + GetHeight(items[currentId].imgWidth, items[currentId].imgHeight, 448, 448);
        strScript = strScript + " src='" + items[currentId].webimage + "'";
        if (items[currentId].objType == 1)
            strScript = strScript + "alt='"  + L_GotoFolder_Text + "'"; 
        else
            strScript = strScript + "alt='"  + L_AltViewProperty_Text + "'"; 
        strScript = strScript + "align=center border=2/></a>";
        strScript = strScript + "<span id=noPreviewSpan style='display:none;font-size:150%'>" + L_NoPreview_Text + "<BR><a name='OpenItemLink' href='" + DisplayItemUrl(currentId)+ "'>" + L_OpenItem_Text + "</a></span>";
        strScript = strScript + "</td></tr><tr><td><table><tr><td vAlign=top>" + L_FileName_Text + ": </td><td>&nbsp;</td><td width=300>";
        strScript = strScript + "<span id=titleSpan>" + items[currentId].caption + "</td></tr><tr id=descrRow><td vAlign=top>";
        strScript = strScript + L_Description_Text + ": </td><td>&nbsp;</td><td width=300><span id=descrSpan>" + items[currentId].description + "</span></td></tr></table></td></tr></table></TD></TR></TABLE>";
        document.write(strScript);
    }
}
function ViewHeaderScript(viewStyle, webImageWidth, webImageHeight, thumbnailSize)
{
    if (viewStyle == "list" || viewStyle == "filmstrip")
    {
        currentViewStyle = viewStyle;
    }
    else
    {
        currentViewStyle = "thumbnail";
    }
    listInfo = new CListInfo(webImageWidth, webImageHeight, thumbnailSize);
    InitViewUrls();
}
function ViewFooterScript()
{
    InitItems();
    if (!browseris.ie5up || !browseris.win32)
    {
        if (firstId != -1)
        {
            var scriptStr = "HiLiteRow(" + firstId + ")";
            window.setTimeout(scriptStr, 200);
        }
        if (fSelectFieldAppeared)
        {
            if (tbPreview != null)
                AddSelectAllCheckbox();
        }
        return;
    }
    fInit = true;
    if (tbPreview != null)
    {
        listDirection = document.getElementById("selectionCacheMgr").parentElement.parentElement.parentElement.currentStyle.direction;
        if (listDirection != "rtl" && listDirection != "RTL")
            listDirection = "ltr";
        else
        {
            fRTL = true;
            var previewTitleLink = GetLinks("lnkPreviewTitle");
            if (previewTitleLink != null)
            {
                previewTitleLink.style.direction = "RTL";
            }
        }
        if (currentViewStyle == "thumbnail")
        {
            GenerateFooterContent("thumbnail", true);
            GenerateFooterContent("filmstrip", false);
            document.getElementById("selectionCacheMgr").parentElement.parentElement.style.display="none";
        }
        else if (currentViewStyle == "filmstrip")
        {
            GenerateFooterContent("thumbnail", false);
            GenerateFooterContent("filmstrip", true);
            document.getElementById("selectionCacheMgr").parentElement.parentElement.style.display="none";
        }
        else
        {
            GenerateFooterContent("thumbnail", false);
            GenerateFooterContent("filmstrip", false);
        }
    }
    if (firstId != -1)
    {
        HiLiteRow(firstId);
        if (tbPreview != null)
        {
            if (currentViewStyle == "list")
                tbPreview.style.display = "block";
            else
                tbPreview.style.display = "none";
        }
        if (fSelectFieldAppeared)
        {
            if (tbPreview != null)
                AddSelectAllCheckbox();
        }
    }
    if (tbPreview != null)
    {
        if (browseris.verIEFull >= 5.5 && browseris.iever < 6 && browseris.win32)
            setTimeout("InitSelection()", 500);
        else if (browseris.ie5up && browseris.win32)
            InitSelection();
    }
}
function ViewPreBodyScript(id)
{
    document.write("<TR id=row" + id + ">");
}
function ViewPostBodyScript(id)
{
    document.write("</TR>");
}
var bTranState = 0;
var slideshowInterval = 5000;
var slideshowIncremental = 500;
var timerId = -1;
var fAutoRun = false;
var fRepeat = false;
var fRetry = 0;
 var fRetryLimit = 2;    
function LoadNextSlide()
{
    if (fNextImageLoaded == false && (fRetry < fRetryLimit))
    {
        fRetry ++;
        return;
    }
    fRetry = 0;
    if (currentPicture >= ids.length)
    {
        if (!fRepeat)
        {
            return;
        }
        else
        {
            currentPicture = 0;
        }
    }
    pic1 = document.images["thisPic"];
    if (browseris.ie5up && browseris.win32)
       pic1.style.visibility = "hidden";
    pic1.src = EncodedWebImage(ids[currentPicture]);
    pic1.height = GetHeight(items[ids[currentPicture]].imgWidth, items[ids[currentPicture]].imgHeight, listInfo.webImageWidth,  listInfo.webImageHeight);
    pic1.width = GetWidth(items[ids[currentPicture]].imgWidth, items[ids[currentPicture]].imgHeight,  listInfo.webImageWidth, listInfo.webImageHeight);
    document.getElementById("tdCaption").innerHTML =  items[ids[currentPicture]].caption + "<BR>";
    document.getElementById("tdDesc").innerHTML = items[ids[currentPicture]].description + "<BR>";
    document.getElementById("tdImgDate").innerHTML = items[ids[currentPicture]].createdDate + "<BR>";
    currentPicture ++;
    document.getElementById("currentCount").innerHTML = "" + currentPicture;
    if ((currentPicture + 1) < ids.length)
    {
        if (browseris.ie5up && browseris.win32)
           fNextImageLoaded = false;
        pic2 = document.images["nextPic"];
        pic2.src = EncodedWebImage(ids[currentPicture + 1]);
    }
}
function AutoRun()
{
    if (fAutoRun)
    {
        LoadNextSlide();
        timerId = setTimeout("AutoRun()", slideshowInterval);
    }
}
function StartSlideShow()
{
    if (fAutoRun)
        return;
    fAutoRun = true;
    timerId =  setTimeout("AutoRun()", slideshowInterval);
}
function StopSlideShow()
{
    PauseSlideShow();
    currentPicture = 0;
    LoadNextSlide();
}
function PauseSlideShow()
{
    if (fAutoRun)
    {
        if (timerId != -1)
        {
            clearTimeout(timerId);
            timerId = -1;
        }
        fAutoRun = false;
    }
}
function ToggleRepeat()
{
    fRepeat = !fRepeat;
}
function NextSlide()
{
    if (browseris.ie)
        event.bubble = false;
    PauseSlideShow();
    if (currentPicture < ids.length)
    {
        if (currentPicture >= 0)
        {
            fRetry = fRetryLimit;   
            LoadNextSlide();
        }
    }
}
function PreviousSlide()
{
    if (browseris.ie)
        event.bubble = false;
    PauseSlideShow();
    if (currentPicture > 1)
    {
        currentPicture --;
        currentPicture --;
        fRetry = fRetryLimit;   
        LoadNextSlide();
    }
}
function HiliteButton()
{
    if (!browseris.ie)
        return;
    var img = event.srcElement;
    var imgSrc = img.src;
    imgSrc = imgSrc.replace(/1.gif$/g, "2.gif");
    img.src= imgSrc;
}
function DemoteButton()
{
    if (!browseris.ie)
        return;
    var img = event.srcElement;
    var imgSrc = img.src;
    imgSrc = imgSrc.replace(/2.gif$/g, "1.gif");
    img.src= imgSrc;
}
function ShowSlidePic()
{
    if (browseris.ie5up && browseris.win32)
    {
        var pic1 = document.images["thisPic"];
        if (pic1 != null)
            pic1.style.visibility = "visible";
    }
}
function SortIds()
{
    var currentUrl = window.location.href;
    var qmarkPosition = currentUrl.indexOf("?");
    var suffix = "";
    if (qmarkPosition != -1)
        suffix = currentUrl.substring(qmarkPosition + 1, currentUrl.length);
    else
        return;
    var queryVariables = suffix.split("&");
    var filterSubstr = suffix.match(/InstanceID=all&FilterName=ID&FilterMultiValue=([^&]*)/);
    if (filterSubstr != null)
        filterIdsStr = filterSubstr[1];
    if (filterIdsStr == "" || filterIdsStr == null)
        return;
    var filterIds = new Array;
    var idsSubStrs = filterIdsStr.split(";");
    for (i = 0, j = 0; i < idsSubStrs.length; i ++)
    {
        var id = parseInt(idsSubStrs[i]);
        if (id >= 0 && items[id] != null)
            filterIds[filterIds.length] = id;
    }
    ids = filterIds;
    filterIds = null;
}
function SlideShowContent()
{
    if (ids.length == 0)
        return;
    SortIds();
    if (currentPicture < 0)
        currentPicture = 0;
    if (currentPicture >= ids.length)
        currentPicture = ids.length - 1;
    var str = "<TABLE cellspacing=0 cellpadding=0 valign=middle align=center width=100% dir="  + listDirection + " height=100%>";
    str += "<TR height=" + listInfo.webImageHeight + ">";
    str += "<TD width=15>&nbsp;</TD>";	
    str += "<TD id=cellImage align=center valign=middle width=" + listInfo.webImageWidth + ">";
    str += "<img onload='ShowSlidePic();' id=thisPic galleryimg=false src=\'" + items[ids[currentPicture]].webimage + 
                "\' + width=" + GetWidth(items[ids[currentPicture]].imgWidth, items[ids[currentPicture]].imgHeight, listInfo.webImageWidth, listInfo.webImageHeight) + 
                " height=" + GetHeight(items[ids[currentPicture]].imgWidth, items[ids[currentPicture]].imgHeight, listInfo.webImageWidth, listInfo.webImageHeight) +  ">";
    var preloadStr = "<img id=nextPic style='position:absolute;visibility:hidden' width=10 height=10";
    if ((currentPicture + 1) < ids.length)
    {
        preloadStr += " src=\'" +  items[ids[currentPicture + 1]].webimage + "\'";
        preloadStr += " onload='fNextImageLoaded=true;'";
    }
    preloadStr += " >";
    str += preloadStr;
    str +="</TD>";
    str += "<TD width=15>&nbsp;</TD><TD valign=top><TABLE class=ms-formdescription cellspacing=2>";
    str += "<TR height=40><TD>" + L_Picture_Text + " <a id=currentCount>1</a> " + L_Of_Text + " " + ids.length + "</TD></TR>";
    str += "<TR id=controlRow><TD>";
    var prevGif = "";
    var nextGif = "";
    var playGif = "";
    if (fRTL)
    {
        prevGif = "plnext1.gif";
        nextGif = "plprev1.gif";
        playGif = "plplayr1.gif"
    }
    else
    {
        prevGif = "plprev1.gif";
        nextGif = "plnext1.gif";
        playGif = "plplay1.gif"
    }
    var buttonStr = "<img border=0 height=23 style='position:relative;cursor:pointer' onmouseover='HiliteButton()' onmouseout='DemoteButton()' src=\'" + ctx.imagesPath;
    var strPlay = "<a onclick='StartSlideShow(); return false;' href='javascript:StartSlideShow()'>" + buttonStr + playGif + "\' id=playButton alt='" + L_SlideShowPlayButton_Text + "'>" + "</a> ";
    var strPause = "<a onclick='PauseSlideShow(); return false;' href='javascript:StartSlideShow()'>" + buttonStr + "plpause1.gif" + "\' alt='" + L_SlideShowPauseButton_Text + "'>" + "</a> ";
    var strStop = "<a onclick='StopSlideShow(); return false;' href='javascript:StopSlideShow()'>" + buttonStr + "plstop1.gif" + "\' id=stopButton alt='" + L_SlideShowStopButton_Text + "'>" + "</a> ";
    var strPrev = "<a onclick='PreviousSlide(); return false;' href='javascript:PreviousSlide()'>" + buttonStr + prevGif  + "\' alt='" + L_SlideShowPrevButton_Text + "'></a> ";
    var strNext = "<a onclick='NextSlide(); return false;' href='javascript:NextSlide()'>" + buttonStr + nextGif + "\' alt='" + L_SlideShowNextButton_Text + "'></a>";
    if (fRTL)
    {
        str += strPrev + strNext + strStop + strPause + strPlay;
    }
    else
    {
        str += strPlay + strPause + strStop + strPrev + strNext;
    }
    str += "<HR></TD></TR>";
    str += "<TR><TD><B>" + L_FileName_Text + ":&nbsp</B></TD></TR><TR><TD id=tdCaption width=75%>" + items[ids[currentPicture]].caption + "<BR></TD></TR>";
    str += "<TR><TD><B>" + L_ImageCreateDate_Text + ":&nbsp</B></TD></TR><TR><TD id=tdImgDate>" +  items[ids[currentPicture]].createdDate + "<BR></TD></TR>";
    str += "<TR><TD><B>" + L_Description_Text + ":&nbsp</B></TD></TR><TR><TD id=tdDesc>" + items[ids[currentPicture]].description + "<BR></TD></TR>";
    if (ids.length > 1)
        currentPicture ++;
    str += "</TABLE></TD>"
    str += "</TR></TABLE>";
    document.write(str);
}
function RecursiveViewHeaderScript(viewStyle, webImageWidth, webImageHeight, thumbnailSize)
{
    fRecursive = true;
    listInfo = new CListInfo(webImageWidth, webImageHeight, thumbnailSize);
    if (viewStyle == "details")
    {
        currentRecursiveViewStyle = viewStyle;
        document.write("<TABLE style='display:none'>");
    }
    else
    {
        currentRecursiveViewStyle = "slideshow";
        document.write("<TABLE>");
    }
}
function RecursiveViewFooterScript()
{
    if (!browseris.ie5up || !browseris.win32)
        return;
    listDirection = document.getElementById("selectionCacheMgr").parentElement.parentElement.parentElement.currentStyle.direction;
    if (listDirection != "rtl" && listDirection != "RTL")
        listDirection = "ltr";
    else
        fRTL = true;
    if (browseris.verIEFull >= 5.5 && browseris.iever < 6 && browseris.win32)
        setTimeout("InitSelection()", 500);
    else if (browseris.ie5up && browseris.win32)
        InitSelection();
}
function CItem(originalImageUrl, id, baseName, extension, imgWidthStr, imgHeightStr, titleStr, descriptionStr, objectType, iconUrl, fNewItem)
{
    this.baseName = baseName;
    this.title = titleStr;
    this.originalImg = originalImageUrl;
    this.imgWidth = GetUint(imgWidthStr);
    this.imgHeight = GetUint(imgHeightStr);
    this.id = id;
    this.fSelected = false;
    this.fNewItem = fNewItem;
    this.description = descriptionStr;
    this.description = this.description.replace(/\r?\n/g, "<br>\n");
    this.objType = objectType;
    this.fUnknownImageType = true;
    this.iconUrl = iconUrl;
    this.caption = baseName;
    if (objectType == 1)
    {
        if ("" != extension)
            this.caption += "." + extension;
        this.thumbnail = this.webimage = ctx.imagesPath + "/fldrnew.gif";
        this.imgWidth = this.imgHeight = 37;
        return;
    }
    if (originalImageUrl == "")
        return;
    var lastSlashIndex = originalImageUrl.lastIndexOf("/");
    if (lastSlashIndex <= 0)
        return;
    var originalLocation = originalImageUrl.substring(0, lastSlashIndex + 1);
    if (this.imgWidth > 0 && this.imgHeight > 0)
    {
        this.thumbnail = originalLocation + "_t/" + baseName + "_" + extension + ".jpg";
        this.webimage = originalLocation + "_w/" + baseName + "_" + extension + ".jpg";
        this.fUnknownImageType = false;
    }
    else
    {
        this.thumbnail = this.webimage = ctx.imagesPath + "/" + iconUrl;
        this.imgWidth = this.imgHeight = 32;
    }
}
function InsertItem(originalImageUrl, id, baseName, extension, imgWidthStr, imgHeightStr, titleStr, descriptionStr, objectType, iconUrl, fNewItem)
{
    if (originalImageUrl == "")
        return;
    items[id] = new CItem(originalImageUrl, id, baseName, extension, imgWidthStr, imgHeightStr, titleStr, descriptionStr, objectType, iconUrl, fNewItem);
    if (firstId == -1)  firstId = id;
    ids[ids.length] = id;
}

// SIG // Begin signature block
// SIG // MIIaJgYJKoZIhvcNAQcCoIIaFzCCGhMCAQExCzAJBgUr
// SIG // DgMCGgUAMGcGCisGAQQBgjcCAQSgWTBXMDIGCisGAQQB
// SIG // gjcCAR4wJAIBAQQQEODJBs441BGiowAQS9NQkAIBAAIB
// SIG // AAIBAAIBAAIBADAhMAkGBSsOAwIaBQAEFFOSm0KsLMab
// SIG // h/mWpJtOSfpmcXHmoIIUvDCCArwwggIlAhBKGdI4jIJZ
// SIG // HKVdc18VXdyjMA0GCSqGSIb3DQEBBAUAMIGeMR8wHQYD
// SIG // VQQKExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMRcwFQYD
// SIG // VQQLEw5WZXJpU2lnbiwgSW5jLjEsMCoGA1UECxMjVmVy
// SIG // aVNpZ24gVGltZSBTdGFtcGluZyBTZXJ2aWNlIFJvb3Qx
// SIG // NDAyBgNVBAsTK05PIExJQUJJTElUWSBBQ0NFUFRFRCwg
// SIG // KGMpOTcgVmVyaVNpZ24sIEluYy4wHhcNOTcwNTEyMDAw
// SIG // MDAwWhcNMDQwMTA3MjM1OTU5WjCBnjEfMB0GA1UEChMW
// SIG // VmVyaVNpZ24gVHJ1c3QgTmV0d29yazEXMBUGA1UECxMO
// SIG // VmVyaVNpZ24sIEluYy4xLDAqBgNVBAsTI1ZlcmlTaWdu
// SIG // IFRpbWUgU3RhbXBpbmcgU2VydmljZSBSb290MTQwMgYD
// SIG // VQQLEytOTyBMSUFCSUxJVFkgQUNDRVBURUQsIChjKTk3
// SIG // IFZlcmlTaWduLCBJbmMuMIGfMA0GCSqGSIb3DQEBAQUA
// SIG // A4GNADCBiQKBgQDTLiDwaHwsLS6BHLEGsqcLtxENV9pT
// SIG // 2HXjyTMqstT2CVs08+mQ/gkM0NsbWrnN5/aIsZ3AhyXr
// SIG // fVgQc2p4y3EV/cZY9imrWF6WBP0tYhFYgRzKcZTVIlgv
// SIG // 1cwUBYQ2upSqtE1K6e47Iq1WmX4hnGyGwEpHl2q0pjbV
// SIG // /Akt07Q5mwIDAQABMA0GCSqGSIb3DQEBBAUAA4GBAGFV
// SIG // Dj57x5ISfhEQjiLM1LMTK1voROQLeJ6kfvOnB3Ie4lnv
// SIG // zITjiZRM205h77Ok+0Y9UDQLn3BW9o4qfxfO5WO/eWkH
// SIG // cy6wlSiK9e2qqdJdzQrKEAmPzrOvKJbEeSmEktz/umdC
// SIG // SKaQEOS/YficU+WT0XM/+P2dT4SsVdH9EWNjMIIEAjCC
// SIG // A2ugAwIBAgIQCHptXG9ik0+6xP1D4RQYnTANBgkqhkiG
// SIG // 9w0BAQQFADCBnjEfMB0GA1UEChMWVmVyaVNpZ24gVHJ1
// SIG // c3QgTmV0d29yazEXMBUGA1UECxMOVmVyaVNpZ24sIElu
// SIG // Yy4xLDAqBgNVBAsTI1ZlcmlTaWduIFRpbWUgU3RhbXBp
// SIG // bmcgU2VydmljZSBSb290MTQwMgYDVQQLEytOTyBMSUFC
// SIG // SUxJVFkgQUNDRVBURUQsIChjKTk3IFZlcmlTaWduLCBJ
// SIG // bmMuMB4XDTAxMDIyODAwMDAwMFoXDTA0MDEwNjIzNTk1
// SIG // OVowgaAxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMR8w
// SIG // HQYDVQQLExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTsw
// SIG // OQYDVQQLEzJUZXJtcyBvZiB1c2UgYXQgaHR0cHM6Ly93
// SIG // d3cudmVyaXNpZ24uY29tL3JwYSAoYykwMTEnMCUGA1UE
// SIG // AxMeVmVyaVNpZ24gVGltZSBTdGFtcGluZyBTZXJ2aWNl
// SIG // MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
// SIG // wHphh+uypwNjGysaYd6AtxUdoIuQPbsnkoQUOeuFzimS
// SIG // BmZIpANPjehPp/CvXtEvGceR8bWee5Ehzun/407w/K+V
// SIG // WLhjLeaO9ikYzXCOUMPtlrtA274l6EJV1vaF8gbni5kc
// SIG // MfMDD9RMnCQq3Bsbj4LzsO+nTeMUp+CP1sdowmFYqXLU
// SIG // +DBIT9kvb2Mg2YnKgnvCS7woxYFo5+aCQKxGOqD5PzbN
// SIG // TLtUQlp6ZXv+hOTHR1SsuT3sgMca98QzgYHJKpX7f146
// SIG // h5AU28wudfLva+Y9qWC+QgGqT6pbqD8iMZ8SFflzoR6C
// SIG // iwQr6kYCTG2PH1AulUsqeAaEdD2RjyxHMQIDAQABo4G4
// SIG // MIG1MEAGCCsGAQUFBwEBBDQwMjAwBggrBgEFBQcwAYYk
// SIG // aHR0cDovL29jc3AudmVyaXNpZ24uY29tL29jc3Avc3Rh
// SIG // dHVzMAkGA1UdEwQCMAAwRAYDVR0gBD0wOzA5BgtghkgB
// SIG // hvhFAQcBATAqMCgGCCsGAQUFBwIBFhxodHRwczovL3d3
// SIG // dy52ZXJpc2lnbi5jb20vcnBhMBMGA1UdJQQMMAoGCCsG
// SIG // AQUFBwMIMAsGA1UdDwQEAwIGwDANBgkqhkiG9w0BAQQF
// SIG // AAOBgQAt809jYCwY2vUkD1KzDOuzvGeFwiPtj0YNzxpN
// SIG // vvN8eiAwMhhoi5K7Mpnwk7g7FQYnez4CBgCkIZKEEwrF
// SIG // mOVAV8UFJeivrxFqqeU7y+kj9pQpXUBV86VTncg2Ojll
// SIG // CHNzpDLSr6y/xwU8/0Xsw+jaJNHOY64Jp/viG+P9QQpq
// SIG // ljCCBBIwggL6oAMCAQICDwDBAIs8PIgR0T72Y+zfQDAN
// SIG // BgkqhkiG9w0BAQQFADBwMSswKQYDVQQLEyJDb3B5cmln
// SIG // aHQgKGMpIDE5OTcgTWljcm9zb2Z0IENvcnAuMR4wHAYD
// SIG // VQQLExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xITAfBgNV
// SIG // BAMTGE1pY3Jvc29mdCBSb290IEF1dGhvcml0eTAeFw05
// SIG // NzAxMTAwNzAwMDBaFw0yMDEyMzEwNzAwMDBaMHAxKzAp
// SIG // BgNVBAsTIkNvcHlyaWdodCAoYykgMTk5NyBNaWNyb3Nv
// SIG // ZnQgQ29ycC4xHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jw
// SIG // b3JhdGlvbjEhMB8GA1UEAxMYTWljcm9zb2Z0IFJvb3Qg
// SIG // QXV0aG9yaXR5MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
// SIG // MIIBCgKCAQEAqQK9wXDmO/JOGyifl3heMOqiqY0lX/j+
// SIG // lUyjt/6doiA+fFGim6KPYDJr0UJkee6sdslU2vLrnIYc
// SIG // j5+EZrPFa3piI9YdPN4PAZLolsS/LWaammgmmdA6LL8M
// SIG // tVgmwUbnCj44liypKDmo7EmDQuOED7uabFVhrIJ8oWAt
// SIG // d0zpmbRkO5pQHDEIJBSfqeeRKxjmPZhjFGBYBWWfHTdS
// SIG // h/en75QCxhvTv1VFs4mAvzrsVJROrv2nem10Tq8YzJYJ
// SIG // KCEAV5BgaTe7SxIHPFb/W/ukZgoIptKBVlfvtjteFoF3
// SIG // BNr2vq6Alf6wzX/WpxpyXDzKvPAIoyIwswaFybMgdxOF
// SIG // 3wIDAQABo4GoMIGlMIGiBgNVHQEEgZowgZeAEFvQcO9p
// SIG // cp4jUX4Usk2O/8uhcjBwMSswKQYDVQQLEyJDb3B5cmln
// SIG // aHQgKGMpIDE5OTcgTWljcm9zb2Z0IENvcnAuMR4wHAYD
// SIG // VQQLExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xITAfBgNV
// SIG // BAMTGE1pY3Jvc29mdCBSb290IEF1dGhvcml0eYIPAMEA
// SIG // izw8iBHRPvZj7N9AMA0GCSqGSIb3DQEBBAUAA4IBAQCV
// SIG // 6AvAjfOXGDXtuAEk2HcR81xgMp+eC8s+BZGIj8k65iHy
// SIG // 8FeTLLWgR8hi7/zXzDs7Wqk2VGn+JG0/ycyq3gV83TGN
// SIG // PZ8QcGq7/hJPGGnA/NBD4xFaIE/qYnuvqhnIKzclLb5l
// SIG // oRKKJQ9jo/dUHPkhydYV81KsbkMyB/2CF/jlZ2wNUfa9
// SIG // 8VLHvefEMPwgMQmIHZUpGk3VHQKl8YDgA7Rb9LHdyFfu
// SIG // ZUnHUlS2tAMoEv+Q1vAIj364l8WrNyzkeuSod+N2oADQ
// SIG // aj/B0jaK4EESqDVqG2rbNeHUHATkqEUEyFozOG5NHA1i
// SIG // twqijNPVVD9GzRxVpnDbEjqHk3Wfp9KgMIIEyTCCA7Gg
// SIG // AwIBAgIQaguZT8AA3qoR1NhAmqi+5jANBgkqhkiG9w0B
// SIG // AQQFADBwMSswKQYDVQQLEyJDb3B5cmlnaHQgKGMpIDE5
// SIG // OTcgTWljcm9zb2Z0IENvcnAuMR4wHAYDVQQLExVNaWNy
// SIG // b3NvZnQgQ29ycG9yYXRpb24xITAfBgNVBAMTGE1pY3Jv
// SIG // c29mdCBSb290IEF1dGhvcml0eTAeFw0wMDEyMTAwODAw
// SIG // MDBaFw0wNTExMTIwODAwMDBaMIGmMQswCQYDVQQGEwJV
// SIG // UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
// SIG // UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
// SIG // cmF0aW9uMSswKQYDVQQLEyJDb3B5cmlnaHQgKGMpIDIw
// SIG // MDAgTWljcm9zb2Z0IENvcnAuMSMwIQYDVQQDExpNaWNy
// SIG // b3NvZnQgQ29kZSBTaWduaW5nIFBDQTCCASAwDQYJKoZI
// SIG // hvcNAQEBBQADggENADCCAQgCggEBAKKEFVPYCzAONJX/
// SIG // OhvC8y97bTcjTfPSjOX9r/3FAjQfJMflodxU7H4CdEer
// SIG // 2zJYFhRRKTjxfrK0jDpHtTlOblTCMQw6bfvNzctQnBuu
// SIG // p9jZSiY/tcXLj5biSfJt2OmWPt4Fz/CmVTetL2DNgGFC
// SIG // oUlUSg8Yt0vZk5kwWkd1ZLTTu922qwydT7hzOxg6qrSH
// SIG // jLCIsE1PH04RtTOA3w06ZG9ExzS9SpObvKYd+QUjTmAp
// SIG // j8wq8oSama2o2wpwe9Y0QZClt2bHXBsdozMOm1QDGj+Y
// SIG // kLjM5z0EdEMcj/c55rOsSHprKg5iAWE5dm79PpgHSxTx
// SIG // AUb9FQDgR9pP5AXkgCUCAQOjggEoMIIBJDATBgNVHSUE
// SIG // DDAKBggrBgEFBQcDAzCBogYDVR0BBIGaMIGXgBBb0HDv
// SIG // aXKeI1F+FLJNjv/LoXIwcDErMCkGA1UECxMiQ29weXJp
// SIG // Z2h0IChjKSAxOTk3IE1pY3Jvc29mdCBDb3JwLjEeMBwG
// SIG // A1UECxMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSEwHwYD
// SIG // VQQDExhNaWNyb3NvZnQgUm9vdCBBdXRob3JpdHmCDwDB
// SIG // AIs8PIgR0T72Y+zfQDAQBgkrBgEEAYI3FQEEAwIBADAd
// SIG // BgNVHQ4EFgQUKVy5G7bNM+67nll99+XKLsQNNCgwGQYJ
// SIG // KwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0PBAQD
// SIG // AgFGMA8GA1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQEE
// SIG // BQADggEBAEVY4ppBf/ydv0h3d66M2eYZxVe0Gr20uV8C
// SIG // oUVqOVn5uSecLU2e/KLkOIo4ZCJC37kvKs+31gbK6yq/
// SIG // 4BqFfNtRCD30ItPUwG2IgRVEX2SDZMSplCyK25A3Sg+3
// SIG // 6NRhj3Z24dkl/ySElY0EVlSUoRw6PoK87qWHjByMS3lf
// SIG // tUn6XjJpOh9UrXVN32TnMDzbZElE+/vEHEJx5qA9Re5r
// SIG // AJ+sQr26EbNW5PvVoiqB2B9OolW+J49wpqJsG/9UioK8
// SIG // gUumobFmeqkXp8sGwEfrprPpMRVTPSoEv/9zSNyLJ0P8
// SIG // Y+juJIdbvjbR6DH1Mtle33l6ujCsaYZK+4wRvxuNVFkw
// SIG // ggUPMIID96ADAgECAgphBxFDAAAAAAA0MA0GCSqGSIb3
// SIG // DQEBBQUAMIGmMQswCQYDVQQGEwJVUzETMBEGA1UECBMK
// SIG // V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
// SIG // A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSswKQYD
// SIG // VQQLEyJDb3B5cmlnaHQgKGMpIDIwMDAgTWljcm9zb2Z0
// SIG // IENvcnAuMSMwIQYDVQQDExpNaWNyb3NvZnQgQ29kZSBT
// SIG // aWduaW5nIFBDQTAeFw0wMjA1MjUwMDU1NDhaFw0wMzEx
// SIG // MjUwMTA1NDhaMIGhMQswCQYDVQQGEwJVUzETMBEGA1UE
// SIG // CBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEe
// SIG // MBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSsw
// SIG // KQYDVQQLEyJDb3B5cmlnaHQgKGMpIDIwMDIgTWljcm9z
// SIG // b2Z0IENvcnAuMR4wHAYDVQQDExVNaWNyb3NvZnQgQ29y
// SIG // cG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
// SIG // ggEKAoIBAQCqmb05qBgn9Cs9C0w/fHcup8u10YwNwjp0
// SIG // 15O14KBLP1lezkVPmnkp8UnMGkfuVcIIPhIg+FXy7l/T
// SIG // 4MqWvDDe/ljIJzLQhVTo8JEQu/MrvhnlA5sLhh3zsDmM
// SIG // uP0LHTxzJqxXK8opohWQghXid6NAUgOLncJwuh/pNPbz
// SIG // NZJOVYP42jC2IN5XBrVaQgbeWcvy36a9FUdxGSUj0stv
// SIG // mxl532pb8XYFeSn8w1bKj0QIhVWKy8gPRktVy4yWd0qH
// SIG // 6KlBBsf/DeloV2Nyw2lXtEPPMjow3Bvp1UMmKnn+ldsi
// SIG // ZyTJL9A04+b7UUmGuDzQJV/W7J4DYYepaEDH+OID5s8F
// SIG // AgMBAAGjggFAMIIBPDAOBgNVHQ8BAf8EBAMCBsAwEwYD
// SIG // VR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0OBBYEFGvIxlEg
// SIG // 8LQv06C2rn9eJrK4h1IpMIGpBgNVHSMEgaEwgZ6AFClc
// SIG // uRu2zTPuu55Zffflyi7EDTQooXSkcjBwMSswKQYDVQQL
// SIG // EyJDb3B5cmlnaHQgKGMpIDE5OTcgTWljcm9zb2Z0IENv
// SIG // cnAuMR4wHAYDVQQLExVNaWNyb3NvZnQgQ29ycG9yYXRp
// SIG // b24xITAfBgNVBAMTGE1pY3Jvc29mdCBSb290IEF1dGhv
// SIG // cml0eYIQaguZT8AA3qoR1NhAmqi+5jBKBgNVHR8EQzBB
// SIG // MD+gPaA7hjlodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20v
// SIG // cGtpL2NybC9wcm9kdWN0cy9Db2RlU2lnblBDQS5jcmww
// SIG // DQYJKoZIhvcNAQEFBQADggEBADUj/RNU/Onc8N0MFHr6
// SIG // p7PO/ac6yLrl5/YD+1Pbp5mpoJs2nAPrgkccIb0Uy+dn
// SIG // QAnHFpECVc5DQrTNG12w8zIEPRLlHacHp4+jfkVVdhuW
// SIG // lZFp8N0480iJ73BAt9u1VYDAA8QutijcCoIOx0Pjekhd
// SIG // uAaJkkBsbsXc+JrvC74hCowvOrXtp85xh2gj4bPkGH24
// SIG // RwGlK8RYy7KJbF/90yzEb7gjsg3/PPIRRXTyCQaZGN1v
// SIG // wIYBGBIdKxavVu9lM6HqZ070S4Kr6Q/cAfrfYH9mR13L
// SIG // LHDMe07ZBrhujAz+Yh5C+ZN8oqsKntAjEK5NeyeRbya+
// SIG // aPqmP58j68idu4cxggTWMIIE0gIBATCBtTCBpjELMAkG
// SIG // A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
// SIG // BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
// SIG // dCBDb3Jwb3JhdGlvbjErMCkGA1UECxMiQ29weXJpZ2h0
// SIG // IChjKSAyMDAwIE1pY3Jvc29mdCBDb3JwLjEjMCEGA1UE
// SIG // AxMaTWljcm9zb2Z0IENvZGUgU2lnbmluZyBQQ0ECCmEH
// SIG // EUMAAAAAADQwCQYFKw4DAhoFAKCBpjAZBgkqhkiG9w0B
// SIG // CQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4w
// SIG // DAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUgSGC
// SIG // fddZCT8tR8dpWRe3tP9dlaswRgYKKwYBBAGCNwIBDDE4
// SIG // MDagFIASAGkAbQBnAGwAaQBiAC4AagBzoR6AHGh0dHA6
// SIG // Ly9vZmZpY2UubWljcm9zb2Z0LmNvbSAwDQYJKoZIhvcN
// SIG // AQEBBQAEggEAkxaXzhCZAWBsdB6HFfdtTTZgmLLKml07
// SIG // Gn2sAfwepLLSUcpv+NEZEpqCcjwxKS7WZ2+/fz37UGMn
// SIG // RTGDi6X6509bBZhcOHwxwHU+zGUu2yZMLgqc6GUF2Pjc
// SIG // ZNRZXuBQG4nnZhpkRRnTDLvSOgvZE8FSj5SSJ2G1nga4
// SIG // 6Z1R6CTk98VQXCvDiuwtwnKX2Ug3Cl/FCQIrSn6s6FIk
// SIG // t3mZKewJzUpCxhNlW8AKQrPDxBL5NcGuxhLaC1q5f+Pr
// SIG // KFlYRsR1T1E0dlN7Zo8OmEVlL2IK3dmO3F90jtevrOA7
// SIG // WLMznUXTnd2Sl8uj7amtqOku/1402p/5nK0qIU5WYb8r
// SIG // WqGCAkwwggJIBgkqhkiG9w0BCQYxggI5MIICNQIBATCB
// SIG // szCBnjEfMB0GA1UEChMWVmVyaVNpZ24gVHJ1c3QgTmV0
// SIG // d29yazEXMBUGA1UECxMOVmVyaVNpZ24sIEluYy4xLDAq
// SIG // BgNVBAsTI1ZlcmlTaWduIFRpbWUgU3RhbXBpbmcgU2Vy
// SIG // dmljZSBSb290MTQwMgYDVQQLEytOTyBMSUFCSUxJVFkg
// SIG // QUNDRVBURUQsIChjKTk3IFZlcmlTaWduLCBJbmMuAhAI
// SIG // em1cb2KTT7rE/UPhFBidMAwGCCqGSIb3DQIFBQCgWTAY
// SIG // BgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3
// SIG // DQEJBTEPFw0wMzA3MTUwNjA0MzZaMB8GCSqGSIb3DQEJ
// SIG // BDESBBCxhXhxdPrByfQWO6DIYC0oMA0GCSqGSIb3DQEB
// SIG // AQUABIIBAIldJB41AYUesL3jjOXpYTsOsnvtfqmkOM9P
// SIG // U02z6ytD53PmCmkL65C3jUvmIZ1AVxsAE3Df1sPZTVN2
// SIG // oCRJC2Z0UaDZ6TukXvrQSJ5XNdJGr1xMs9UyYk9d2ySH
// SIG // LjGbgldBOfhoBjlqrOzEbY5cW+joRm9IIXh/2/BoAvnJ
// SIG // Jo54imNmdc69scZ2zkwzElAXwZugjskQxVk+LjhuCiBE
// SIG // OJtrr8M8Tgl2TOfho/CgqdrGs9Hzp2G6Joo+CuwLXjHL
// SIG // Rci1tYGa8xi4ZaQ8Goofxfe2tMMphReKcPETwPkOsTu2
// SIG // zTUub3A1/yuK/rVqNarz18iAX12iucfmZRixvX8gFxo=
// SIG // End signature block
