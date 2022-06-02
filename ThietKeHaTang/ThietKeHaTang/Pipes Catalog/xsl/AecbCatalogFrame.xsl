<?xml version="1.0"?>
<!--
****************************************************************************************
*
* AecbCatalogFrame.xls
*
* xsl to render a pXML catalog as an treeview
*
* Copyright (c) 2000, 2001 Autodesk, Inc. All Rights Reserved.
*
****************************************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">

   <!--
   ***************************************
   *
   * root processing
   * - create HTML header and BODY tag
   * - start traversing the xml tree
   ***************************************
   -->
   <xsl:template match="/">
      <HTML>
         <HEAD>
            <TITLE>pXML catalog navigation</TITLE>
            <META name='save' content='history'/>
	        <LINK REL='stylesheet' TYPE='text/css' HREF='../css/AecbCatalogFrame.css'/>
	        <!--SCRIPT TYPE='text/javascript' LANGUAGE='javascript' SRC='../js/AecbContentBrowserLib.js' ID="LibJS"></SCRIPT-->
              <SCRIPT TYPE='text/javascript' LANGUAGE='javascript' SRC='../js/AecbTreeView.js' ID="TreeViewJS"></SCRIPT>
              <!--SCRIPT TYPE='text/javascript' LANGUAGE='javascript' SRC='../js/catalogsearch.js' ID="CatalogSearchJS"></SCRIPT-->
         </HEAD>
         <BODY>
            <!--Display the company logo -->
            <xsl:if test="pXML/Supplier/Images">
               <IMG CLASS="clsCompanyLogo" STYLE="cursor:hand">
                  <xsl:attribute name="ONCLICK">window.open('<xsl:value-of select="pXML/Supplier/Link/URL/@xlink:href"/>', '_new');</xsl:attribute>
                  <xsl:attribute name="SRC"><xsl:value-of select="pXML/Supplier/Images/Image/URL/@xlink:href"/></xsl:attribute>
                  <xsl:attribute name="BORDER">0</xsl:attribute>
                  <xsl:attribute name="TITLE"><xsl:value-of select="pXML/Desc"/></xsl:attribute>
               </IMG><P></P>
            </xsl:if>

            <!-- Tabulator -->
            <TABLE STYLE='behavior:url(#default#savehistory)' CELLPADDING='0' CELLSPACING='0' WIDTH='100%' BORDER='0'>
               <TR VALIGN='TOP'>
                  <TD CLASS='clsTabSelected' ID='tabs' ONCLICK='tabClick(0);'>
                     <IMG ID='tabIMGs' SRC='../images/tab-left.gif' ALIGN='absmiddle'/>Catalog<IMG ID='tabIMGs' SRC='../images/tab-rightp.gif' ALIGN='absmiddle' />
                  </TD>
                  <TD WIDTH='100%' BGCOLOR='#3366CC'>
                  </TD>
               </TR>

            	<TR>
            	   <TD COLSPAN='4' BGCOLOR='#99CCFF' HEIGHT='6'><IMG SRC='../images/ts.gif' HEIGHT='6' /></TD>
            	</TR>
            </TABLE>

            <DIV ID='TabContent' CLASS='clsTabContentNavigation' STYLE='display:block; overflow:auto; width=100%; height:expression(document.body.clientHeight - offsetTop)'>
               <xsl:apply-templates select="pXML"/>
            </DIV>
            
         </BODY>
     </HTML>
   </xsl:template>

   <xsl:template match="pXML">
      <!-- create the tree root (catalog) -->
      <UL>
         <LI CLASS="clsHasKids">
            <SPAN Param="Catalog">
               <xsl:attribute name="ID"><xsl:value-of select="@id"/></xsl:attribute>
               <xsl:value-of select="@name"/>
            </SPAN>
            <!-- Recursively process the chapters -->
            <UL><xsl:apply-templates select="Chapter"/></UL>
         </LI>
      </UL>
   </xsl:template>

   <!--
   ********************************************************************
   *
   * render a Chapter element
   *
   ********************************************************************
   -->
   <xsl:template match="Chapter[@visible='1'] | Chapter[not(@visible)]">
      <LI CLASS="clsHasKids">
         <SPAN Param="Chapter">
            <xsl:attribute name="ID"><xsl:value-of select="@id"/></xsl:attribute>
            <xsl:value-of select="@name"/>
         </SPAN>
         <!-- Recurse on parts and subchapters -->
         <UL>
            <xsl:apply-templates select="Chapter"/>
            <xsl:apply-templates select="Part"/>
         </UL>
      </LI>
   </xsl:template>

   <!--
   ********************************************************************
   *
   * render a Part element
   *
   ********************************************************************
   -->
   <xsl:template match="Part[@visible='1'] | Part[not(@visible)]">
      <LI  CLASS="clsNoKids">
         <SPAN Param="Part">
            <xsl:attribute name="ID"><xsl:value-of select="@id"/></xsl:attribute>
            <xsl:value-of select="@name"/>
         </SPAN>
      </LI>
   </xsl:template>

</xsl:stylesheet>
