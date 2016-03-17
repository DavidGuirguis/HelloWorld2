var colChildActive = new Collection()
var menuActive = null
var lastHighlight = null
var active = false
  
function getReal(el) {
// Find a table cell element in the parent chain */
temp = el
while ((temp!=null) && (temp.tagName!="TABLE") && (temp.className!="root") && (temp.id!="menuBar")) {
if (temp.tagName=="TD")
el = temp
temp = temp.parentElement
}
return el
}
    
