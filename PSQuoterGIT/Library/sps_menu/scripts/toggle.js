// Version: "11.0.5704.0"
// Copyright (c) Microsoft Corporation.  All rights reserved.
// _lcid="1033" _version="11.0.5704.0"
// _localbinding
// JScript source code

// Global variables expected to be set before calling this script...
//	strCollapseMinus - Full image path for "minus" button.
//	strCollapsePlus  - Full image path for "plus" button.

// kbToggle
function kbToggle(GroupNumber)
{
    // See if the user hit the space bar. If so, toggle the group state.
    if (String.fromCharCode(window.event.keyCode) == " ")
        ToggleGroup(GroupNumber);
}

function GroupShouldBeOpen(GroupNumber)
{
    var elButton = document.all("tog" + GroupNumber);
    var rgParts = elButton.src.split("/");
    if (rgParts[rgParts.length - 1] == "CollapseMinus.gif")
        return true;
    return false;
}

function ToggleButton(GroupNumber)
{
    var elButton = document.all("tog" + GroupNumber);
    if (GroupShouldBeOpen(GroupNumber))
    {
        elButton.src = strCollapsePlus;
        return false;
    }
    else
    {
        elButton.src = strCollapseMinus;
        return true;
    }
}
 
function ToggleGroup(GroupNumber)
{
    // Toggle the group button for the group and get a flag with it's state.
    var fOpen = ToggleButton(GroupNumber);
    
    // There should be a table named "tblThis" in the document. We're interested
    // in it's rows only.
    for ( i = 0; i < tblThis.rows.length; i++ )
    {
        var trCurrent = tblThis.rows(i);

        // The "togglegroup" attribute may contain multiple levels of
        // grouping. Each group is separated from the others with a
        // comma character (","). The row is a member of all of the
        // groups in this collection.
        strToggleGroup = trCurrent.getAttribute("togglegroup");
        if (null != strToggleGroup)
        {
            var rgGroups = strToggleGroup.split(",");
                
            //Walk the groups from left to right. When we're hiding a
            // group, we can stop processing when we've gotten to the one
            // we're interested in. When we're showing a group, we need to
            // respect the open/closed state of the child groups...
            for (nGroup = 0; nGroup < rgGroups.length; nGroup++)
            {
                if (rgGroups[nGroup] == GroupNumber)
                {
                    if (fOpen)
                    {
                        // Now look at each remaining group in the set. If
                        // any of them should be closed, we don't need to show
                        // the row or look at any more groups.
                        var fShow = true;
                        for(;nGroup < rgGroups.length && fShow == true; nGroup++)
                        {
                            if (!GroupShouldBeOpen(rgGroups[nGroup]))
                            {
                                fShow = false;
                                break;
                            }
                        }
                        if (fShow)
                            trCurrent.style.setAttribute("display", "block", 0);
                    }
                    else
                    {
                        trCurrent.style.setAttribute("display", "none", 0);
                        break; // No need to keep processing groups.
                    }
                    break;
                }
            }
        }
    }
}
