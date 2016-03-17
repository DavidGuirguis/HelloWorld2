// Version: "11.0.5704.0"
// Copyright (c) Microsoft Corporation.  All rights reserved.
// _lcid="1033" _version="11.0.5704.0"
// _localbinding
function localecompare(a, b) {
	return a.toLocaleLowerCase().localeCompare(b.toLocaleLowerCase());
}

function stringcompare(a, b) {
	var strA = a.toLowerCase();
	var strB = b.toLowerCase();
	if ( strA < strB ) return -1;
	if ( strA > strB ) return 1;
	return 0;
}

function xSort(List) {
	xQuickSort(List, 0, List.length - 1);
}

function xRecomputeSelected() {
	var strOrgleList = '';
	var optionlist = document.getElementById('Audience_SelectedList').options;

	for (i = 0; i < optionlist.length; i++) {
		if(i > 0) {
			strOrgleList += ','; 
		}
		strOrgleList += "'" + optionlist[i].value + "'";
	}
	document.getElementById('__Audiences_SelectedList').value = strOrgleList;
}

function xMove(Source, Target) {
	while (Source.selectedIndex != -1) {
		var index = Source.selectedIndex;
		var oldoption = Source.options[index]; 
		var newoption = new Option(oldoption.text, oldoption.value); 

		if (oldoption.text.toLocaleLowerCase) 
			sText = oldoption.text.toLocaleLowerCase();
		else
			sText = oldoption.text.toLowerCase();

		iPos = xBinarySearch(sText, sText.length, Target, 0, Target.length - 1 );	
		iPos = xGetPosition(sText, Target, iPos);

		Target.options[Target.length] = newoption;
		Source.options[index] = null;

		if ((iPos < Target.length) && (iPos >= 0)) {
			Target.insertBefore(newoption, Target.options[iPos]);
		}
	}

	xRecomputeSelected();
}

function xFind(Text, List) {
	while (Text.value.charAt(0)==' ') {
		Text.value = Text.value.substring(1,Text.value.length);
	}

	if (Text.value == '') {
		List.selectedIndex = -1;
		List.selectedIndex = 0;
		return;
	}

	if (Text.value.toLocaleLowerCase)
		sText = Text.value.toLocaleLowerCase();
	else
		sText = Text.value.toLowerCase();

	iPos = xBinarySearch(sText, sText.length, List, 0, List.length - 1 );	
	iPos = xGetPosition(sText, List, iPos);
	if (iPos == List.length) {
		List.selectedIndex = List.length - 1;
	}
	else {
		List.selectedIndex = iPos;
	}
}

function xBinarySearch(sText, iTextLen, List, iL, iR)
{
	if (iL > iR)
		return iL; 

	iM = Math.floor((iL + iR) / 2);

	sItem = List.options[iM].text.substr(0,iTextLen);
	if (sItem.toLocaleLowerCase)
		sItem.toLocaleLowerCase();
	else
		sItem.toLowerCase();

	if (sText == sItem)
		return iM;
	if (iL == iR)
		return iL; 
	if (sText < sItem)
		return xBinarySearch(sText, iTextLen, List, iL, iM-1);
	else
		return xBinarySearch(sText, iTextLen, List, iM+1, iR);
}

function xCurrValue(List, iPos, len) {
	opt = List.options[iPos];
	if (opt == null)
		return '';
	else if (opt.text.toLocaleLowerCase)
		return opt.text.substr(0,len).toLocaleLowerCase();
	else
		return opt.text.substr(0,len).toLowerCase();
}

function xGetPosition(sText, List, iPos)
{
	if (sText == null) 
		return iPos;

	if (sText.toLocaleLowerCase) {
		sText = sText.toLocaleLowerCase();

		while (sText.localeCompare(xCurrValue(List,iPos,sText.length)) > 0) {  
			if (iPos >= List.length-1) {
				return List.length;
			}
			iPos++;
		}

		moved = false;
		while (sText.localeCompare(xCurrValue(List,iPos,sText.length)) < 0) {  
			if (iPos == 0) {
				return iPos;
			}
			moved = true;
			iPos--;
		}

		while (sText.localeCompare(xCurrValue(List,iPos,sText.length)) == 0) {  
			if (iPos == 0) {
				return iPos;
			}
			moved = true;
			iPos--;
		}

		if (moved) 
			iPos++;
	}
	else { 
		sText = sText.toLowerCase();

		while (sText > xCurrValue(List,iPos,sText.length)) {  
			if (iPos >= List.length-1) {
				return List.length;
			}
			iPos++;
		}

		moved = false;
		while (sText < xCurrValue(List,iPos,sText.length)) {  
			if (iPos == 0) {
				return iPos;
			}
			moved = true;
			iPos--;
		}

		while (sText == xCurrValue(List,iPos,sText.length)) {  
			if (iPos == 0) {
				return iPos;
			}
			moved = true;
			iPos--;
		}

		if (moved) iPos++;
	}

	return iPos;
}

function xFillData(arrInput, ddl) {
	var i;
	for (i = 0; i < arrInput.length; i++) {
		var opt = new Option();
		opt.text = arrInput[i];
		opt.value = arrIds[arrInput[i]];
		ddl[i] = opt;
	}
}
