<?xml version="1.0"?>
<!--
****************************************************************************************
* AecbSelectView.xls
* display a view table as a html table
* elements of each table cell are idrop controls
* Author wj
* Copyright (c) 2000, 2001 All Rights Reserved.
* 03/21/2000  created
****************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/TR/WD-xsl">

   <!--Evaluate Formula -->
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

   <xsl:template match="/">
      <HTML>
         <HEAD>
            <TITLE>Part Table: <xsl:value-of select="@desc"/></TITLE>
            <LINK REL="stylesheet" TYPE="text/css" HREF="../css/Part.css"/>
            <SCRIPT FOR="window" EVENT="onload">
               <xsl:for-each select="/LandPart/ColumnUnique/RowUnique">
                  <xsl:for-each select="../../ColumnConstView">
                     try
                     {
                        idrop_<xsl:value-of select="@id"/><xsl:value-of select="context(-2)/@id"/>.PackageXML = <xsl:value-of select="@id"/><xsl:value-of select="context(-2)/@id"/>.XMLDocument.xml
                     }
                     catch(e) {}
                  </xsl:for-each>
                  <xsl:for-each select="../../ColumnView/Drawing[@idref=context(-1)/@id]">
                     try
                     {
                        idrop_<xsl:value-of select="../@id"/><xsl:value-of select="@idref"/>.PackageXML = <xsl:value-of select="../@id"/><xsl:value-of select="@idref"/>.XMLDocument.xml
                     }
                     catch(e) {}
                  </xsl:for-each>
               </xsl:for-each>
            </SCRIPT>
         </HEAD>
         
         <BODY>
            <xsl:for-each select="LandPart/ColumnUnique/RowUnique">
            
            
                <!--ConstViewPackage-->
			<xsl:for-each xmlns:xsl="http://www.w3.org/TR/WD-xsl" select="/Table/ColumnConstView[@visible='1'] | /Table/ColumnConstView[not(@visible)]">
			   <XML>
			  	   <!-- tag this data island with the column ID-->
				   <xsl:attribute name="id"><xsl:value-of select="@id"/><xsl:value-of select="context(-2)/@id"/></xsl:attribute>
			
			  	   <!-- create the XML declaration-->
			  	   <xsl:pi name="xml">version="1.0"</xsl:pi>
			
			  	   <!-- create the package XML-->
				   <xsl:element name="package">
			
			  	     	<!--
			  	     	**********************************************************************************
			  	     	*
			  	     	* create the proxy from the first image element available in the current row
			  	     	*
			  	     	**********************************************************************************
			  	     	-->
			  			<xsl:element name="proxy" >
			  			   <xsl:attribute name="defaultsrc"><xsl:value-of select = "/Table/@baseUrl"/><xsl:value-of select="Images/Image/URL/@xlink:href"/></xsl:attribute>
			    			<xsl:element name="caption"><xsl:value-of select="@desc"/></xsl:element>
			  			</xsl:element>
			
			  	     	<!-- Create the one and only dataset-->
			  			<xsl:element name="dataset">
			  			   <xsl:attribute name="defaultsrc"><xsl:value-of select = "/Table/@baseUrl"/><xsl:value-of select="Recipe"/></xsl:attribute>
			
			     			<xsl:element name="datasrc">
			  	   		   <xsl:attribute name="clipformat">CF_IDROP.FOO</xsl:attribute>
			
			         		<xsl:element name="datafile">
			   		         <xsl:attribute name="src"><xsl:value-of select = "/Table/@baseUrl"/><xsl:value-of select="Recipe"/></xsl:attribute>
			   		      </xsl:element>
			
			   		      <xsl:if test="XRefFiles">
			   		         <xsl:for-each select="XRefFiles/URL">
			   			         <xsl:element name="xreffile">
			   			            <xsl:attribute name="src"><xsl:value-of select = "/Table/@baseUrl"/><xsl:value-of select="@xlink:href"/></xsl:attribute>
			   			         </xsl:element>
			   			      </xsl:for-each>
			   		      </xsl:if>
			  			   </xsl:element>
					   </xsl:element>
					</xsl:element>
			   </XML>
			</xsl:for-each>     
			
			      
			<!-- Drawing Package-->
			<xsl:for-each xmlns:xsl="http://www.w3.org/TR/WD-xsl" select="/LandPart/ColumnView[@visible='1']/Drawing[@idref=context(-1)/@id] | /LandPart/ColumnView[not(@visible)]/Drawing[@idref=context(-1)/	@id]">
			   <XML>
			  	   <!-- tag this data island with the column + row ID-->
				   <xsl:attribute name="id"><xsl:value-of select="../@id"/><xsl:value-of select="@idref"/></xsl:attribute>
			
			  	   <!-- create the XML declaration-->
			  	   <xsl:pi name="xml">version="1.0"</xsl:pi>
			
			  	   <!-- create the package XML-->
				   <xsl:element name="package">
			
			  	     	<!--
			  	     	**********************************************************************************
			  	     	*
			  	     	* create the proxy from the first image element available in the current row
			  	     	*
			  	     	**********************************************************************************
			  	     	 -->
			  			<xsl:element name="proxy" >
			  			   <xsl:attribute name="defaultsrc"><xsl:value-of select = "/LandPart/@baseUrl"/><xsl:value-of select="../Images/Image/URL/@xlink:href"/></xsl:attribute>
			    			<xsl:element name="caption"><xsl:value-of select="../@desc"/></xsl:element>
			  			</xsl:element>
			
			  	     	<!-- Create the one and only dataset-->
			  			<xsl:element name="dataset">
			  			   <xsl:attribute name="defaultsrc"><xsl:value-of select = "/LandPart/@baseUrl"/><xsl:value-of/></xsl:attribute>
			
			     			<xsl:element name="datasrc">
			  	   		   <xsl:attribute name="clipformat">CF_IDROP.DWG</xsl:attribute>
			
			         		<xsl:element name="datafile">
			   		         <xsl:attribute name="src"><xsl:value-of select = "/LandPart/@baseUrl"/><xsl:value-of/></xsl:attribute>
			   		      </xsl:element>
			
			   		      <xsl:if test="../XRefFiles">
			   		         <xsl:for-each select="../XRefFiles/URL">
			   			         <xsl:element name="xreffile">
			   			            <xsl:attribute name="src"><xsl:value-of select = "/LandPart/@baseUrl"/><xsl:value-of select="@xlink:href"/></xsl:attribute>
			   			         </xsl:element>
			   			      </xsl:for-each>
			   		      </xsl:if>
			  			   </xsl:element>
			  			</xsl:element>
					</xsl:element>
			   </XML>
		</xsl:for-each>
			 
            

            </xsl:for-each>
            <xsl:apply-templates select="LandPart"/>
         </BODY>
      </HTML>
   </xsl:template>

   <xsl:template match="LandPart">
      <!-- TODO review this code and remove if possible -->
      <!-- dummy object for workaround IE 5.01 first object is instantiated before onload event -->
      <OBJECT ID="dummy" WIDTH="0" HEIGHT="0" CLASSID="clsid:AF2880B4-B183-11D2-ADE7-00A0245D8F3F"></OBJECT>

      <!-- build an html table corresponding to the part table with an extra column for idrop-->
      <TABLE CLASS="clsPartTable">
	      <xsl:apply-templates select="ColumnUnique"/>
      </TABLE>
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
            <xsl:for-each select="/LandPart/ColumnConstView[@visible='1'] | /LandPart/ColumnConstView[not(@visible)]">
               <TH>
                  <xsl:value-of select="@desc"/>
               </TH>
            </xsl:for-each>
            <xsl:for-each select="/LandPart/ColumnView[@visible='1'] | /LandPart/ColumnView[not(@visible)]">
               <TH>
                  <xsl:value-of select="@desc"/>
               </TH>
            </xsl:for-each>
            <xsl:for-each select="/LandPart/Column[@visible='1'] | /LandPart/Column[not(@visible)]">
               <TH>
                  <xsl:value-of select="@desc"/>
               </TH>
            </xsl:for-each>
            <xsl:for-each select="/LandPart/ColumnConst[@visible='1'] | /LandPart/ColumnConst[not(@visible)]">
               <TH>
                  <xsl:value-of select="@desc"/>
               </TH>
            </xsl:for-each>
            <xsl:for-each select="/LandPart/ColumnCalc[@visible='1'] | /LandPart/ColumnCalc[not(@visible)]">
               <TH>
                  <xsl:value-of select="@desc"/>
               </TH>
            </xsl:for-each>
         </TR>
      </THEAD>

      <TBODY>
         <xsl:for-each select = "RowUnique">
            <xsl:eval language="VBScript">SetCurId(me.getAttribute("id"))</xsl:eval>
            <TR>
               <xsl:apply-templates select="/LandPart/ColumnConstView[@visible='1'] | /LandPart/ColumnConstView[not(@visible)]"/>
               <xsl:apply-templates select="/LandPart/ColumnView[@visible='1']/Drawing[@idref=context(-1)/@id] | /LandPart/ColumnView[not(@visible)]/Drawing[@idref=context(-1)/@id]"/>

               <xsl:apply-templates select="/LandPart/Column[@visible='1']/Row[@idref=context(-1)/@id] | /LandPart/Column[not(@visible)]/Row[@idref=context(-1)/@id]"/>
               <xsl:apply-templates select="/LandPart/ColumnConst[@visible='1'] | /LandPart/ColumnConst[not(@visible)]"/>
               <xsl:apply-templates select="/LandPart/ColumnCalc[@visible='1'] | /LandPart/ColumnCalc[not(@visible)]"/>
            </TR>
         </xsl:for-each>
      </TBODY>
   </xsl:template>


   ********************************************
   *
   * render Row element in html table
   *
   ********************************************
   <xsl:template match="Row">
      <TD>
         <xsl:value-of/>
      </TD>
   </xsl:template>

   ********************************************
   *
   * render ColumnConst element in html table
   *
   ********************************************
   <xsl:template match="ColumnConst">
      <TD>
         <xsl:value-of/>
      </TD>
   </xsl:template>

   ********************************************
   *
   * render ColumnCalc element in html table
   *
   ********************************************
   <xsl:template match="ColumnCalc">
      <TD>
         <xsl:eval language="VBScript">EvaluateFormula(me.text)</xsl:eval>
      </TD>
   </xsl:template>


   ***********************************************
   *
   * render ColumnConstView element in html table
   *
   ***********************************************
   <xsl:template match="ColumnConstView">
      <TD>
	      <OBJECT>
	         <xsl:attribute name="id">idrop_<xsl:value-of select="@id"/><xsl:value-of select="context(-2)/@id"/></xsl:attribute>
	         <xsl:attribute name="width">80</xsl:attribute>
	         <xsl:attribute name="height">80</xsl:attribute>
	         <xsl:attribute name="CLASSID">clsid:AF2880B4-B183-11D2-ADE7-00A0245D8F3F</xsl:attribute>
<!--	         <xsl:attribute name="codebase">http://vizdevel/idrop/idrop.cab#version=-1,-1,-1,-1</xsl:attribute> -->
	         <PARAM name="validatexml" value="1"/>
 	      </OBJECT>
      </TD>
        
   </xsl:template>


   ********************************************
   *
   * render Drawing element in html table
   *
   ********************************************
   <xsl:template match="Drawing">
      <TD>
	      <OBJECT>
	         <xsl:attribute name="id">idrop_<xsl:value-of select="../@id"/><xsl:value-of select="@idref"/></xsl:attribute>
	         <xsl:attribute name="width">80</xsl:attribute>
	         <xsl:attribute name="height">80</xsl:attribute>
	         <xsl:attribute name="CLASSID">clsid:AF2880B4-B183-11D2-ADE7-00A0245D8F3F</xsl:attribute>
<!--	         <xsl:attribute name="codebase">http://vizdevel/idrop/idrop.cab#version=-1,-1,-1,-1</xsl:attribute> -->
	         <PARAM name="validatexml" value="1"/>
 	      </OBJECT>
      </TD>
   </xsl:template>
</xsl:stylesheet>