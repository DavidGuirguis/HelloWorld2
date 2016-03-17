// Version: "11.0.5704.0"
// Copyright (c) Microsoft Corporation.  All rights reserved.
// _lcid="1033" _version="11.0.5704.0"
// _localbinding
//--------------------------------------------------------------
// Utilities for handing the SPS-specific DHTML in Office dialogs
//----------------------------------------------------------

function setRowStyles( rowElem, strStyle )
{
	currElem = rowElem.nextSibling;
	while( true )
	{
		if( null == currElem )
		{
			return;
		}
		if( currElem.tagName != "TR" ||	null == currElem.depth )
		{
			return;
		}
		if( currElem.depth <= rowElem.depth )
		{
			return;
		}
		
		currElem.style.display = strStyle;
		currElem = currElem.nextSibling;
	}
}
function toggle()
{
	var imgElem = window.event.srcElement;
	var rowElem = imgElem;
	while( rowElem.tagName != "TR" )
	{
		rowElem = rowElem.parentElement;
	}
	
	if( rowElem.state == "notloaded" )
	{
		var strSingleCat = "proxy.aspx?ProxyCmd=OneCatAsXml";
		var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
		var strURL = strSingleCat+"&CatID="+rowElem.guid;
		xmlhttp.open("GET", strURL, false);
		xmlhttp.send();
		
		var xmldom = new ActiveXObject("Microsoft.XMLDOM");
		xmldom.async = false;
		if( !xmldom.load(xmlhttp.responseBody) )
		{
			//alert( xmldom.parseError.reason );
			return;
		}

		var nodeList = xmldom.selectNodes( "//root/category" );
		var table = rowElem.parentElement;
		
		for (var i = 0; i < nodeList.length; i++) 
		{
  		    var node = nodeList.item(i);
			var strState = node.selectSingleNode( "state" ).text;
			var strIconName;
			if( "notloaded" == strState )
			{
				strIconName = "expand.gif";
			}
			else
			{
				strIconName = "wpempty.gif";
			}			
			var strImg = "<img border=\"0\" src=\"..\\images\\" + strIconName + "\" onclick=\"toggle()\" />";
			var rowNew = table.insertRow( rowElem.rowIndex + 1 + i );
			rowNew.guid = node.selectSingleNode( "catid" ).text;

			var nDepth = node.selectSingleNode( "depth" ).text - 0;
			rowNew.depth = nDepth;

			rowNew.state = strState;
			rowNew.id = node.selectSingleNode( "web" ).text;
			rowNew.onclick = selectrow;
			rowNew.onmousedown = selectrow;
			var cell = rowNew.insertCell();
			cell.innerHTML = strImg + "&nbsp;&nbsp;" + node.selectSingleNode( "name" ).text;
			cell.style.paddingLeft = nDepth * 21;
			cell.className = "ms-odcatcell";
		}
		
		rowElem.state = "collapsed";
	}
	
	if( rowElem.state == "collapsed" )
	{
		setRowStyles( rowElem, "inline" );
		rowElem.state = "expanded";
		imgElem.src = "..\\images\\collapse.gif";
	}
	else if( rowElem.state == "expanded" )
	{
		setRowStyles( rowElem, "none" );
		rowElem.state = "collapsed";
		imgElem.src = "..\\images\\expand.gif";
	}

	checkScroll();
}
