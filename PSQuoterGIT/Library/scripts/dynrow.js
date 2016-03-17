//<CREATED-fxiao, 2008-11-10::Used for managing dynamic rows />

/*****************************************************************************/
/* Dyn Add/Remove Rows														 */
/*****************************************************************************/

// a class that encapsulate functionality handling add/remove row dynamically
function DynRow(obj) {
	// get tBody object and current row
	var curRow = (obj.tagName == "TR") ? obj : getParentElementByTagName(obj, "TR");
	var oTBody = getParentElementByTagName(curRow, "TBODY");
	var maxLength = -1;	// unlimited

	// get max number of rows can be added
	if( (typeof(oTBody.maxLength) == "string") || (typeof(oTBody.maxLength) == "number") )
		maxLength	= parseInt(oTBody.maxLength);

	// properties
	this.IsFirstRow		= (curRow.sectionRowIndex == 0);
	this.IsLastRow		= (curRow.sectionRowIndex == (oTBody.rows.length-1));
	
	this.CurRow			= curRow;
	this.TBody			= oTBody;
	
	this.MaxLength		= maxLength;
}

// methods definition
function dynRow_newRow(processCell, processButtons) {
	// exit if reach the max rows
	if(!this.CanAdd) return null;

	// custom process function passed
	var bProcessCell = (typeof(processCell) == "function");
	
	// create new row
	var newRow = this.TBody.insertRow();
			
	// process cells
	var curCells = this.CurRow.cells;
	var newCell;
	
	for(var i=0; i<curCells.length; i++){
		newCell	= newRow.insertCell();
		
		// copying content
		newCell.innerHTML = curCells[i].innerHTML;
		
		// merging attributes including id and name attr
		newCell.mergeAttributes(curCells[i], false);

		if(bProcessCell) {
			// custom process
			processCell(curCells[i], newCell);
		}
		
		// process buttons
		if( (typeof(newCell.buttonTagName) == "string") ) {
			dynRow_processButtons_(false, false, this.CanAdd(), curCells[i], processButtons);
			dynRow_processButtons_(false, true, this.CanAdd(), newCell, processButtons);
		} // if( (typeof(newCell.buttonTagName) == "string") )
	} // for(curCells)

	// reset input elements when no custom process specified
	if(!bProcessCell) {
		var oInputs = newRow.getElementsByTagName("INPUT");
		for(var i=0; i<oInputs.length; i++) {
			if(oInputs[i].type != "button") {
				if(oInputs[i].value)
					oInputs[i].value = "";
				else if(oInputs[i].checked)
					oInputs[i].checked = false;				
			}
		} // for(oInputs)
		
		var oSelects = newRow.getElementsByTagName("SELECT");
		for(var i=0; i<oSelects.length; i++)
			oSelects[i].selectedIndex = 0;
			
		var oTextAreas = newRow.getElementsByTagName("TEXTAREA");
		for(var i=0; i<oTextAreas.length; i++)
			oTextAreas[i].value = "";
	} // if(!bProcessCell)
	
	return newRow;
} // dynRow_newRow

// delete current row
function dynRow_deleteRow(processButtons) {
	var curCells = this.CurRow.cells;

	for(var i=0; i<curCells.length; i++){
		var curCell = curCells[i];
	
		// process buttons
		if( (typeof(curCell.buttonTagName) == "string") ) {
			// previous row
			if(this.IsLastRow && (typeof(this.CurRow.previousSibling) == "object"))
				dynRow_processButtons_(
					(this.CurRow.previousSibling.sectionRowIndex == 0), // is first row
					this.IsLastRow,			// is last row
					true,									// can add new 
					this.CurRow.previousSibling.cells[i],	// button cell
					processButtons							// custom function
				);
		
			// last row
			if(!this.IsLastRow)				
				dynRow_processButtons_(
					this.TBody.rows.length==2,				// is first row
					true,									// is last row
					true,									// can add new 
					this.TBody.lastChild.cells[i],			// button cell
					processButtons							// custom function
				);
		} // if( (typeof(newCell.buttonTagName) == "string") )
	} // for(curCells)
	
	// delete current row
	this.TBody.deleteRow(this.CurRow.sectionRowIndex);
}	

// check if a new row can be added
function dynRow_canAdd() {
	return (this.MaxLength == -1) || (this.TBody.rows.length < this.MaxLength);
} // dynRow_canAdd

// private methods
function dynRow_processButtons_(isFirstRow, isLastRow, canAdd, newCell, processButtons){
	// use custom function
	if(typeof(processButtons) == "function") {
		processButtons(isFirstRow, isLastRow, canAdd, newCell);
		return;
	}

	var sTagName = newCell.buttonTagName.toUpperCase();
	
	// no buttons
	if( (sTagName != "BUTTON") && (sTagName != "INPUT") ) return;
	
	var oBtns = newCell.getElementsByTagName(sTagName);
	
	for(var i=0; i<oBtns.length; i++) {
		if(typeof(oBtns[i].action) == "string") {
			switch(oBtns[i].action.toLowerCase()) {
				case "add":
					// add
					oBtns[i].style.display	= (isLastRow || isFirstRow) ? "" : "none";
					oBtns[i].disabled		= !canAdd;
											
					break;
				case "remove":
					// remove
					oBtns[i].disabled		= (isFirstRow) ? true : false;
					
					break;
			} // switch			
		} // if(typeof(oBtns[i].action) == "string")
	} // for
} // dynRow_processButtons_

// public methods - DynRow
DynRow.prototype.Add	= dynRow_newRow;
DynRow.prototype.Delete	= dynRow_deleteRow;
DynRow.prototype.CanAdd	= dynRow_canAdd;

/*---------------------------------------------------------*/
/*-- sample code							
/*---------------------------------------------------------*/
/*

<script language=javascript>
<!--
	// add new row
	function addRow(oBtn) {
		var oDynRow = new DynRow(oBtn);
		var newRow = oDynRow.Add();
			
	} // addRow
	
	// delete row
	function removeRow(oBtn) {
		var oDynRow = new DynRow(oBtn);
		oDynRow.Delete();
	} // removeRow
//-->
</script>


<table cellpadding=2 cellspacing=1 border=0>
  <tbody id=spnEdit maxLength=10>
	<tr>
		<td><input type=text class=fe name=SubsidiaryName><input type=hidden name=SubsidiaryId></td>
		<td buttonTagName="BUTTON"><button class=fe50 disabled=true action="remove" onclick="removeRow(this)">Remove</button>&nbsp;<button class=fe50 action="add" onclick="addRow(this)">Add</button></td>
	</tr>							
  </tbody>
</table>

*/

/*****************************************************************************/
