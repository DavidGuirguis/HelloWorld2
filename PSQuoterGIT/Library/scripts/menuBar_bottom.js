    function menuHandler(menuItem) {
      // Write generic menu handlers here!
      // Returning true collapses the menu. Returning false does not collapse the menu
      return true
    }

    function getOffsetPos(which,el,tagName) {
      var pos = 0 // el["offset" + which]
      while (el.tagName!=tagName) {
        pos+=el["offset" + which]
        el = el.offsetParent
      }
      return pos	
    }

    function getRootTable(el) {
      el = el.offsetParent
      if (el.tagName=="TR") 
        el = el.offsetParent
      return el
    }

    function getElement(el,tagName) {
      while ((el!=null) && (el.tagName!=tagName) )
        el = el.parentElement
      return el
    }

    function processClick() {
      var el = getReal(event.srcElement)
      if ((getRootTable(el).id=="menuBar") && (active)) {        
        cleanupMenu(menuActive)
        clearHighlight(menuActive)
        active=false
        lastHighlight=null
        doHighlight(el)
      }
      else {
        if ((el.className=="root") || (!menuHandler(el)))
          doMenuDown(el)
        else {
          if (el._childItem==null) 
            el._childItem = getChildren(el)
          if (el._childItem!=null)  return;
          if ((el.id!="break") && (el.className!="disabled") && (el.className!="disabledhighlight") && (el.className!="clear"))  {
            if (menuHandler(el)) {
              cleanupMenu(menuActive)
              clearHighlight(menuActive)
              active=false
              lastHighlight=null
            }
          }
        }
      }
    }

    function getChildren(el) {
      var tList = el.children.tags("TABLE")
      var i = 0
      while ((i<tList.length) && (tList[i].tagName!="TABLE"))
        i++
      if (i==tList.length)
        return null
      else
        return tList[i]
    }

    function doMenuDown(el) {

      if (el._childItem==null) 
        el._childItem = getChildren(el)
      if ((el._childItem!=null) && (el.className!="disabled") && (el.className!="disabledhighlight")) {
        // Performance Optimization - Cache child element
        ch = el._childItem
        if (ch.style.display=="block") {
          removeHighlight(ch.active)
          return
        }
        ch.style.display = "block"
        
        if (el.className=="root") {
          ch.style.pixelTop = el.offsetHeight + el.offsetTop + 2
          ch.style.pixelLeft = el.offsetLeft + 1
	  if (ch.style.pixelWidth==0)
            ch.style.pixelWidth = ch.rows[0].offsetWidth+50
          sinkMenu(el)
          active = true
          menuActive = el
          
        } else {
          // insert the child active
          if(colChildActive.Find(el) == null) colChildActive.Add(el);
          
          ch.style.pixelTop = getOffsetPos("Top",el,"TABLE") -3 // el.offsetTop + el.offsetParent.offsetTop - 3
          ch.style.pixelLeft = el.offsetLeft + el.offsetWidth
	  if (ch.style.pixelWidth==0)
            ch.style.pixelWidth = ch.offsetWidth+50
        } 
		hideElement('SELECT',ch)
		//hideElement('IFRAME',ch)
		hideElement('OBJECT',ch)
      }

    }
 
    function doHighlight(el) {
      el = getReal(el)
      if ("root"==el.className) {
        if ((menuActive!=null) && (menuActive!=el)) {
          clearHighlight(menuActive)
        }
        if (!active) {
          raiseMenu(el)
        }          
        else 
          sinkMenu(el)
        if ((active) && (menuActive!=el)) {
          cleanupMenu(menuActive)          
          doMenuDown(el)
        }
        menuActive = el  
        
        lastHighlight=null
      }
      else {
		// clean child active
        if (colChildActive.Count() > 0) {
			for(var i = 0; i < colChildActive.Count(); i++) {
				var childActive = colChildActive.Item(i);
			
				if (!childActive.contains(el)) {
					cleanupMenu(childActive)
					
					// remove the object
					colChildActive.Remove(i);
					
					//closeMenu(childActive, el)	
					
				} //if: !childActive.contains(el)
			} //for: colChildActive.Count()
		} //if: colChildActive.Count > 0
		
        if (("TD"==el.tagName) && ("clear"!=el.className)) {
          var ch = getRootTable(el)         
          if (ch.active!=null) {
            if (ch.active!=el) {
              if (ch.active.className=="disabledhighlight")  
                ch.active.className="disabled"
              else
                ch.active.className=""
              }
            }
          ch.active = el
          lastHighlight = el
          if ((el.className=="disabled") || (el.className=="disabledhighlight")) 
            el.className = "disabledhighlight"
          else {
            if (el.id!="break") {
              el.className = "highlight"
              if (el._childItem==null) 
                el._childItem = getChildren(el)
              if (el._childItem!=null) {
                doMenuDown(el)
              }
            }  
          }
        }
      }
    }

    function removeHighlight(el) {
      if (el!=null)
        if ((el.className=="disabled") || (el.className=="disabledhighlight"))  
          el.className="disabled"
        else
          el.className=""
    }

    function cleanupMenu(el) {
	  showElement('SELECT',el,menuActive)
      //showElement('IFRAME',el,menuActive)
      showElement('OBJECT',el,menuActive)
      if (el==null) return
      for (var i = 0; i < el.all.length; i++) {
        var item = el.all[i]
        if (item.tagName=="TABLE")
         item.style.display = ""
        removeHighlight(item.active)
        item.active=null
      }
	}

    function closeMenu(ch, el) {
      var start = ch
      
      /*
      while (ch.className!="root") {
          ch = ch.parentElement
          if (((!ch.contains(el)) && (ch.className!="root"))) {
            start=ch
          }
      }
      */
      cleanupMenu(start)
    }
 
    function checkMenu() {
      if (document.all.menuBar==null) return
      if ((!document.all.menuBar.contains(event.srcElement)) && (menuActive!=null)) {
        clearHighlight(menuActive)
        closeMenu(menuActive)
        active = false
        menuActive=null
        choiceActive = null
      }
    }

    function doCheckOut() {
      var el = event.toElement      
      if ((!active) && (menuActive!=null) && (!menuActive.contains(el))) {
        clearHighlight(menuActive)
        menuActive=null
      }
    }


    function processKey() {
      if (active) {
        switch (event.keyCode) {
         case 13: lastHighlight.click(); break;
         case 39:  // right
           if ((lastHighlight==null) || (lastHighlight._childItem==null)) {
             var idx = menuActive.cellIndex
//             if (idx==menuActive.offsetParent.cells.length-1)
             if (idx==getElement(menuActive,"TR").cells.length-1)
               idx = 0
             else
               idx++
             newItem = getElement(menuActive,"TR").cells[idx]
           } else
           {
             newItem = lastHighlight._childItem.rows[0].cells[0]
           }
           doHighlight(newItem)
           break; 
         case 37: //left
           if ((lastHighlight==null) || (getElement(getRootTable(lastHighlight),"TR").id=="menuBar")) {
             var idx = menuActive.cellIndex
             if (idx==0)
               idx = getElement(menuActive,"TR").cells.length-1
             else
               idx--
             newItem = getElement(menuActive,"TR").cells[idx]
           } else
           {
             newItem = getElement(lastHighlight,"TR")
             while (newItem.tagName!="TD")
               newItem = newItem.parentElement
           }
           doHighlight(newItem)
           break; 
         case 40: // down
            if (lastHighlight==null) {
              itemCell = menuActive._childItem
              curCell=0
              curRow = 0
            }
            else {
              itemCell = getRootTable(lastHighlight)
              if (lastHighlight.cellIndex==getElement(lastHighlight,"TR").cells.length-1) {
                curCell = 0
                curRow = getElement(lastHighlight,"TR").rowIndex+1
                if (getElement(lastHighlight,"TR").rowIndex==itemCell.rows.length-1)
                  curRow = 0
              } else {
                curCell = lastHighlight.cellIndex+1
                curRow = getElement(lastHighlight,"TR").rowIndex
              }
            }
            doHighlight(itemCell.rows[curRow].cells[curCell]);
            break;
         case 38: // up
            if (lastHighlight==null) {
              itemCell = menuActive._childItem
              curRow = itemCell.rows.length-1
              curCell= itemCell.rows[curRow].cells.length-1

            }
            else {
              itemCell = getRootTable(lastHighlight)
              if (lastHighlight.cellIndex==0) {
                curRow = getElement(lastHighlight,"TR").rowIndex-1
                if (curRow==-1)
                  curRow = itemCell.rows.length-1
                curCell= itemCell.rows[curRow].cells.length-1

              } else {
                curCell = lastHighlight.cellIndex - 1
                curRow = getElement(lastHighlight,"TR").rowIndex
              }
            }
            doHighlight(itemCell.rows[curRow].cells[curCell])
            break;
           if (lastHighlight==null) {
              curCell = menuActive._childItem
              curRow = curCell.rows.length-1
            }
            else {
              curCell = getRootTable(lastHighlight)
              if (getElement(lastHighlight,"TR").rowIndex==0)
                curRow = curCell.rows.length-1
              else
                curRow = getElement(lastHighlight,"TR").rowIndex-1
            }
            doHighlight(curCell.rows[curRow].cells[0])
            break;
        }
      }
    }
    
function hideElement(elmID,el)
{
	var posMenu = new Object;
	var posSelect = new Object;
	
	//
	getRealPos(el,posMenu);
	 	 
	for (i = 0; i < document.all.tags(elmID).length; i++)
	{
		obj = document.all.tags(elmID)[i];
		if (! obj || ! obj.offsetParent)
			continue;

		// Find the element's offsetTop and offsetLeft relative to the BODY tag.
		getRealPos(obj,posSelect)

		if (posMenu.x > (posSelect.x + obj.offsetWidth) || posSelect.x > (posMenu.x + el.offsetWidth))
			;
		else if(posSelect.y > (posMenu.y + el.offsetHeight) || posMenu.y > (posSelect.y + obj.offsetHeight))
			;
		else
			obj.style.visibility = "hidden";
	}
}

function showElement(elmID,el,elMenu)
{
	var posSelect = new Object();
	var posMenu = new Object();
	
	blnMenuActive = (arguments.length==3);
	
	try{
		if(el.className)
			if(el.className == "root")
				blnMenuActive = false;
				
		if(blnMenuActive && (elMenu!=null))
			if(elMenu.childNodes){
				specialone = elMenu.childNodes[1];
				getRealPos(specialone,posMenu)
			}

		for (i = 0; i < document.all.tags(elmID).length; i++)
		{
			obj = document.all.tags(elmID)[i];
			if (! obj || ! obj.offsetParent)
				continue;
			
			if (obj.style.visibility == "hidden" && blnMenuActive){
				// Find the element's offsetTop and offsetLeft relative to the BODY tag.
				getRealPos(obj,posSelect)
				
				if (posMenu.x > (posSelect.x + obj.offsetWidth) || posSelect.x > (posMenu.x + specialone.offsetWidth))
					obj.style.visibility = "";
				else if(posSelect.y > (posMenu.y + specialone.offsetHeight) || posMenu.y > (posSelect.y + obj.offsetHeight))
					obj.style.visibility = "";
				else
					;
			}else
				obj.style.visibility = "";
		}
	}catch(x){
		return false;
	}
}

function getRealPos(obj){
	var objLeft,objTop,objParent
	
	objLeft   = obj.offsetLeft;
	objTop    = obj.offsetTop;
	objParent = obj.offsetParent;

	while (objParent != null && objParent.tagName.toUpperCase() != "BODY")
	{
		objLeft  += objParent.offsetLeft;
		objTop   += objParent.offsetTop;
		objParent = objParent.offsetParent;
	}

	if(arguments.length==2){
		arguments[1].x = objLeft;
		arguments[1].y = objTop;
		
		return true;
	}
	
	if(arguments.length==1){
		this.x = objLeft;
		this.y = objTop;
		
		return true;
	}
}

document.onclick = checkMenu
