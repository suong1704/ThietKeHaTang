/********************************************************************************************
 *
 * AecbTreeView.js
 * this .js file contains functions used to implement a 'TreeView' in an HTML browser.
 * 
 * Autodesk Inc. Copyright (c) 2000, All Rights Reserved.
 * Prototype Code only -- Not for distribution
 * Developed for internal use based on pXml schema, modified for Aecb sample catalog & iDrop usage
 *
 * the HTML code must conform to following rules:
 *
 * - the tree as a whole must be enclosed with a <UL> </UL> tag.
 * - every subtree also must be enclosed with a <UL>..</UL> tag.
 * - a tree item (leaf and branch) must be constructed as follows:
 *
 *     for a leaf
 *     <LI CLASS="clsNoKids">
 *          <SPAN ID="">ItemName</SPAN>
 *     </LI>
 *
 *     for a branch
 *     <LI CLASS="clsHasKids">
 *          <SPAN ID="">ItemName</SPAN>
 *          <UL> ... subtrees ... </UL>
 *     </LI>
 *
 *
 * every item can have the following states:
 * - selected
 * - open
 * - closed
 *
 * this states are dynamically stored as CLASS attribute of the <SPAN> tag.
 * e. g. if user clicks on an item the onClick handler changes
 * the CLASS attribute of the clicked <SPAN> tag
 *
 * following CLASS attributes are used:
 * - "clsSelected"            (leaf or branch)
 * - "clsOpen"                (only for branch)
 * - "clsSelectedAndOpen"     (only for branch)
 * - "" (empty, the default)
 *
 * A linked stylesheet (.css) is used to determine how the different states are
 * displayed to the user.
 *
 * To do this it uses class selectors e.g.
 *    LI.clsHasKids SPAN.clsSelectedAndOpen
 *    {
 *       font-weight:bold;
 *       color:black;
 *       list-style-image:url(of.gif);
 *    }
 *
 * This .js only evaluates the following mouse events to control the tree behavior
 * - onmouseover
 * - onmouseout
 * - ondblclick
 * - onclick
 *
 * The event handlers recognizing an tree item by looking at the tagName property of the
 * event source element. If it is "SPAN" then it looks at className property of the parent
 * wether it is equal to "clsHasKids" or "clsNoKids".
 *
 * collapsing/expanding of an branch is done by setting the .style.display attribute
 * of the first <UL> child element:
 *
 *    var oChild = GetChildElem("SPAN"element.parentElement, "UL")
 *    oChild.style.display to "block" (expanded) or to "none" (collapsed)
 *
 * INTERFACE
 *
 * onSelectionChanged(id, param); is fired to parent window if selection has changed
 * selectItem(id);         can be called from outside to synchronize the tree
 *
 ********************************************************************************************/


// find the first childnode of 'eSrc' which has the tagName 'sTagName'
// this method is not recursivly descending through childnodes

function GetChildElem(eSrc,sTagName)
{
   var cKids = eSrc.children;
   //debugger;
   
   for (var i=0;i<cKids.length;i++)
   {
      if (sTagName == cKids[i].tagName) 
      {
		//debugger;
		return cKids[i];
      }
   }
   //debugger;
   return(false);
}

// find the rightmost element in the tree which is located along client window coordinate iY

function FindElementRightMostFromY(oElem, iY)
{

   //debugger
   
   var cKids = oElem.children;
   var oFoundElem = null;
   for (var i=0; i<cKids.length && !oFoundElem; i++)
   {
	  oFoundElem = FindElementRightMostFromY(cKids[i], iY);
      if (!oFoundElem && (cKids[i].offsetTop + cKids[i].offsetHeight >= iY))
         oFoundElem = cKids[i];
   }

   return(oFoundElem);
   
   //debugger
}


// finds the recently selectet item and resets it to unselected

function ResetSelected()
{

   //debugger
   
   var oObject = document.all.tags("SPAN");
   if (oObject != null)
   {
      if (oObject.length != null)
      {
         for (i = 0; i < oObject.length; i++)
         {
            if (oObject(i).className == "clsSelected")
            {
               oObject(i).className = "";
               break;
            }
            if (oObject(i).className == "clsSelectedAndOpen")
            {
               oObject(i).className = "clsOpen";
               break;
            }
         }
      }
   }
   
   //debugger
}


// don't allow selection of the text aera of a tree item

function document.onselectstart()
{
   //debugger
   
   var eSrc = window.event.srcElement;
   if (eSrc.tagName == "INPUT")
      window.event.returnValue = true;      
   else
      window.event.returnValue = false;
      
   //debugger
}


// hard coded mouse over behavior of a branch element
// change text color of the item to maroon

function document.onmouseover()
{
   var eSrc = window.event.srcElement;
	if ("SPAN" == eSrc.tagName && "clsHasKids" == eSrc.parentElement.className)
	{
		eSrc.style.color = "maroon";
   }
}

// hard coded mouse over behavior of a branch element
// resetse text color of the item to default

function document.onmouseout()
{
    //debugger
    
    var eSrc = window.event.srcElement;
    if ("SPAN" == eSrc.tagName && "clsHasKids" == eSrc.parentElement.className)
    {
        eSrc.style.color = "";
    }
    
    //debugger
}


// if user makes a dblclick on the text of a tree item expand or collapse it

function document.ondblclick()
{
    //debugger
    
    // expand or collapse tree item
    var eSrc = window.event.srcElement;
    if (eSrc.tagName == "SPAN" && eSrc.parentElement.className == "clsHasKids")
    {
        var eChild = GetChildElem(eSrc.parentElement,"UL");
        eChild.style.display = ("block" == eChild.style.display ? "none" : "block");
        eSrc.className = (eChild.style.display == "block" ? "clsSelectedAndOpen" : "clsSelected");
    }
    
    //debugger
}

// if a user clicks on the list marker symbol of a branch item expand or collapse it
// if he clicked in the text aera of the item select it

function document.onclick()
{
	//debugger;
	
    var eSrc = window.event.srcElement;

    if (eSrc.tagName == "SPAN")
    {
        //user clicked in the text aera
        handleClick(eSrc, false);
    }
    else if (eSrc.tagName == "LI")
    {
        // The user user may have clicked in an "LI" element of a folder
        // whose listmarker is displayed above the mouse pointer
        // this is if he clicked left of the item
        // so lets look what element is really displayed right of the mouse pointer
        var oRight = FindElementRightMostFromY(eSrc, window.event.offsetY);
        var oFound = eSrc;
        if (oRight)
        {
            if (oRight.tagName == "SPAN")
                oFound = oRight.parentElement;
            else if (oRight.tagName == "UL")
                oFound = oRight.lastChild;
            else if (oRight.tagName == "LI")
                oFound = oRight;
        }

        if ((oFound == eSrc) && (eSrc.className == "clsHasKids") && (window.event.offsetX <= (eSrc.offsetLeft)))
        {
            // user clicked in list marker symbol
            var oChild = GetChildElem(eSrc,"UL");
            oChild.style.display = ("block" == oChild.style.display ? "none" : "block");
            var oSpan = GetChildElem(eSrc,"SPAN");
            if (oSpan.className == "clsSelected" || oSpan.className == "clsSelectedAndOpen")
                oSpan.className = (oChild.style.display == "block" ? "clsSelectedAndOpen" : "clsSelected")
            else
                oSpan.className = (oChild.style.display == "block" ? "clsOpen" : "")
        }
    }
    
    //debugger
}

// selectItem
// Purpose: synchronize tree view with selection from content view
// Called: from onclick event of an element in the content view

function selectItem(id)
{
	//debugger;
	
    var oObject = document.all.item(id);
    if (oObject != null)
    {
         // sync tree with content
         handleClick(oObject, true);
    }
    
    //debugger;
}


function handleClick(oObject, fSync)
{

   //debugger;
	
   // mark/unmark selected
   if ("SPAN" == oObject.tagName && ("clsNoKids" == oObject.parentElement.className || "clsHasKids" == oObject.parentElement.className))
   {
      ResetSelected();

      oObject.className = "clsSelected";

      if ("clsHasKids" == oObject.parentElement.className)
      {
   		if (GetChildElem(oObject.parentElement,"UL").style.display == "block")
            oObject.className = "clsSelectedAndOpen";
      }
   }

   // expand or collapse tree item
   toggleNodeDisplay(oObject, fSync);

   // send message to parent window
   // the selection has changed
   if (("SPAN" == oObject.tagName && "LI" == oObject.parentElement.tagName) || "LI" == oObject.tagName)
   {
      if (oObject.getAttribute("ID"))
      {
         try
         {
            parent.onSelectionChanged(oObject.getAttribute("ID"), oObject.getAttribute("Param"));
         }
         catch(e)
         {
            if ((e.number & 0xFFFF) != 438) // 438 == Object doesn't support this property or method is o. k. anything else is not o.k.
               throw e;
         }
      }
   }
   
   //debugger;
}


function toggleNodeDisplay(oObject, fSync)
{
   //debugger 
   
   // expand or collapse tree item
      
   if (oObject && fSync)
   {
      // if parent node is not expanded do it
      toggleNodeDisplay(GetChildElem(oObject.parentElement.parentElement.parentElement, "SPAN"), fSync);

      if ("SPAN" == oObject.tagName)
      {
        if ("clsHasKids" == oObject.parentElement.className)
		{
		   var eChild = GetChildElem(oObject.parentElement,"UL");
		   		   
		   if (eChild != null)
		      eChild.style.display = "block";

		   if (oObject.className == "clsSelected" || oObject.className == "clsSelectedAndOpen")
		      oObject.className = "clsSelectedAndOpen";
		   else
		      oObject.className = "clsOpen";
		}
      }
   }
   
   //debugger
}
