/****************************************************************************************
*
* AecbContentBrowserlib.js
*
* Copyright (c) 2000, 2001 All Rights Reserved.
*
* History:
*           03/21/2000  created as part of AdpML sample (lib.js)
*           modified by js (AecDetailsLib.js)
*           11/5/2001 modified by cs (AecbContentBrowserLib.js)
****************************************************************************************/

function GetBaseUrl (strFileSpec)
{
   var i = strFileSpec.lastIndexOf("\\");
   var j = strFileSpec.lastIndexOf("/");
   var len = i > j ? i : j
   strPath = strFileSpec.substr(0, len+1);

   return(strPath);
}

function GetBaseName(strFileSpec)
{
   var i = strFileSpec.lastIndexOf("\\");
   var j = strFileSpec.lastIndexOf("/");
   var l = i > j ? i : j
   strPath = strFileSpec.substr(0, l+1);

   return(strPath);
}



// Parse error formatting function
function reportParseError(error)
{
  var strPos = "";
  for (var i=1; i<error.linepos; i++)
    strPos += " ";

  strErr = "<font face=Verdana size=2><font size=4><P>XML Error loading '" +  error.url + "'</font>" + "<P><B>" + error.reason + "</B></P></font>";

  if (error.line > 0)
    strErr += "<font size=3><XMP>" + "at line " + error.line + ", character " + error.linepos + "\n" + error.srcText + "\n" + strPos + "^" + "</XMP></font>";

  return(strErr);
}


// Runtime error formatting function
function reportRuntimeError(exception)
{
  return("<font face=Verdana size=2><font size=4><P>Runtime Error</font>" + "<P><B>" + exception.description + "</B></P></font>");
}


function getUrlArgument(urlStr, argumentStr)
{
    argumentStr += "=";
	var nameStartIndex = urlStr.search(argumentStr);
	var argStr = new String (argumentStr);
	var argStrLentgh = argumentStr.length;
	var value = null;
	if (nameStartIndex != -1)
	{
		nameStartIndex += argStrLentgh;
		var nameEndIndex = urlStr.indexOf("&", nameStartIndex);
		if (nameEndIndex != -1)
			value = urlStr.substr(nameStartIndex, nameEndIndex - nameStartIndex);
		else
			value = urlStr.substr(nameStartIndex);
	}
	return value;
}
