<?xml version="1.0"?>
<!--
****************************************************************************************
* AecbTable.xls
* display a part table as an html table
* Copyright (c) 2000, 2001 Autodesk, Inc. All Rights Reserved.
*
* History:
*           03/20/2000  created by: wj as pXml prototype
*           08/10/2000  edited by: jb to support ColumnConstList and place ColumnConst in a seperate table. 
*           09/12/2000  edited by: cs to support revisions to ColumnConstList and ColumnConst usage.
*           10/12/2001  revisions to prototype browser and I-drop support for Aecb content 
*           10/10/2003  revisions to prototype land content using new Range table storage
****************************************************************************************
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/TR/WD-xsl">

   <xsl:template match="/">
      <xsl:apply-templates select="LandPart"/>
   </xsl:template>

   <xsl:template match="LandPart">
      <HTML>
         <HEAD>
            <TITLE>Table Data: <xsl:value-of select="@desc"/></TITLE>
            <LINK REL="stylesheet" TYPE="text/css" HREF="../css/AecbPart.css"/>
	    <SCRIPT TYPE='text/javascript' LANGUAGE='javascript' SRC='../js/columConstList.js' ID="LibJS"></SCRIPT>
         </HEAD>

         <BODY>
         
            <DIV CLASS="clsPartTableDesc">Table Values</DIV>
            <TABLE CLASS="clsPartTable">
	            <xsl:apply-templates select="ColumnUnique"/>
            </TABLE>
	   
	   <p></p>

	    <DIV CLASS="clsPartTableDesc">Constant List Values</DIV>
	    <TABLE CLASS="clsColumnConstListTable">      
	              <xsl:for-each select="/LandPart/ColumnConstList[@visible='1'] | /LandPart/ColumnConstList[not(@visible)]">
                         <TR>
                            <TH><xsl:value-of select="@desc"/></TH>
			    <xsl:for-each select="Item">
                               <xsl:apply-templates select="."/>
                            </xsl:for-each>
                         </TR>
                      </xsl:for-each>	
            </TABLE>
            
	   <p></p>
	   
	    <DIV CLASS="clsPartTableDesc">Range Values  [Min, Max, Default]</DIV>
	    <TABLE CLASS="clsColumnConstRange">      
	              <xsl:for-each select="/LandPart/ColumnRangeList[@visible='1'] | /LandPart/ColumnRangeList[not(@visible)]">
                         <TR>
                            <TH><xsl:value-of select="@desc"/></TH>
			   		 <xsl:for-each select="Item">
                               	<xsl:apply-templates select="."/>
                            </xsl:for-each>
                         </TR>
                      </xsl:for-each>	
            </TABLE>
            
	   <p></p>            

	    <DIV CLASS="clsPartTableDesc">Constant Values</DIV>
            <TABLE CLASS="clsColumnConstTable">   
               <xsl:apply-templates select="ColumnConst"/> 
            </TABLE>

	   <p></p>

	    <DIV CLASS="clsPartTableDesc">Calculated Values [Formula]</DIV>
            <TABLE CLASS="clsColumnCalcTable">
               <xsl:apply-templates select="ColumnCalc"/>  
            </TABLE>

         </BODY>

      </HTML>

   </xsl:template>


   <!--
   ****************************************************************************************************
   *
   * Process a ColumnUnique
   *
   * - create the table columns
   * - fill each row
   ****************************************************************************************************
   -->
   <xsl:template match="ColumnUnique">

      <!-- build the header row, and fill in the headings-->
      <THEAD>
         <TR>
             
	    <xsl:for-each select="/LandPart/Column[@visible='1'] | /LandPart/Column[not(@visible)]">
               <TH>
                  <xsl:value-of select="@desc"/>
               </TH>
            </xsl:for-each>	

            <!-- xsl:for-each select="/LandPart/ColumnCalc[@visible='1'] | /LandPart/ColumnCalc[not(@visible)]" -->
               <!--TH -->
                  <!--xsl:value-of select="@desc"/-->
               <!--/TH-->
            <!--/xsl:for-each-->

         </TR>
      </THEAD>

      <!--Two Basic Tasks Performed Here ... Rendering the table in the right pane and enabling ONCLICK to support I-Drop -->
      
      <TBODY>
         <xsl:for-each>
            <xsl:eval language="VBScript">SetCurId(me.getAttribute("id"))</xsl:eval> 
            <TR TITLE="Parts" STYLE="cursor:hand">
		  <!-- TODO move the ONCLICK and CURSOR CHANGE to better represent Part Family iDrop Selection -->
               <xsl:attribute name="ONCLICK">parent.callDisplayIDropPackage3 ('Drag and Drop Parts')</xsl:attribute>
               <xsl:apply-templates select="/LandPart/Column[@visible='1']/Row[@id=context(-1)/@id] | /LandPart/Column[not(@visible)]/Row[@idref=context(-1)/@id]"/>
            </TR>
         </xsl:for-each>
      </TBODY>

   </xsl:template>
 
      
   *****************************************************
   *
   * render Row element in html table
   *
   *****************************************************
   <xsl:template match="Row">
      <TD>
         <xsl:value-of/>
      </TD>
   </xsl:template>


   *****************************************************
   *
   * render Item element in html table
   *
   *****************************************************
   <xsl:template match="Item">
      <TD>
         <xsl:value-of/>
      </TD>
   </xsl:template>


   *****************************************************
   *
   * render ColumnConst element in html table
   *
   *****************************************************
   <xsl:template match="ColumnConst">
     <TR>
      <!--TH-->
         <!--xsl:value-of select="@desc"/-->
      <!--/TH-->
      <TD>
         <!--xsl:value-of/-->
        <B><xsl:value-of select="@desc"/></B>
      </TD>
      <TD>
         <xsl:value-of/>
      </TD>
     </TR>
   </xsl:template>


   *****************************************************
   *
   * render ColumnCalc element in html table
   *
   *****************************************************
      <xsl:template match="ColumnCalc">
     <TR>
      <!--TH-->
         <!--xsl:value-of select="@desc"/-->
      <!--/TH-->
      <TD>
         <!--xsl:value-of/-->
	  <!-- xsl:eval language="VBScript">EvaluateFormula(me.text)</xsl:eval -->         
        <B><xsl:value-of select="@desc"/></B>
      </TD>
      <TD>
         <xsl:value-of/>
      </TD>
     </TR>
   </xsl:template>
   
   <!--Evaluate Formula Script-->
   <xsl:script xmlns:xsl="http://www.w3.org/TR/WD-xsl" language="VBScript"><![CDATA[
	      
	      Dim strCurId
	      strCurId = "r0"
	
	      Function SetCurId(strId)
	         strCurId = strId
	      End Function
	
	      Function EvaluateFormula(strFormula)
	         Dim strId
	         Dim strEval
	         Dim oNodeList
	
	         strId = strCurId
	         strEval = strFormula
	
	         Set oNodeList = selectNodes("/LandPart/Column")
	         For l=0 To (oNodeList.length - 1)     'look if any column name is contained in formula string
	            Dim oElement                       'and replace column name wit the value of the column
	            Dim strVariable
	            Set oElement = oNodeList.item(l)
	            strVariable = oElement.getAttribute("name")
	            If Len(strVariable) > 0 Then
	               Dim lPos
	               lPos = InStr(1, strEval, strVariable, vbTextCompare)
	               If lPos > 0 Then
	                  Dim oNode
	                  Set oNode = selectSingleNode("/LandPart/Column[@name = '" + strVariable + "']/Row" + "[@idref='" + strId + "']")
	                  If Not IsNull(oNode) Then
	                     Dim strValue
	                     strValue = oNode.text
	                     If Len(strValue) > 0 Then
	                        strEval = Replace(strEval, strVariable, strValue)
	                     End If
	                  End If
	               End If
	            End If
	         Next
	         EvaluateFormula = eval(strEval)
	      End Function
	
	]]></xsl:script>

</xsl:stylesheet>