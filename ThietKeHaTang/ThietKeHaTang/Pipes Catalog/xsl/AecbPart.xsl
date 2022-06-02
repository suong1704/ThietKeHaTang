<?xml version="1.0"?>
<!--
****************************************************************************************
* AecbPart.xls
* Author wj
* Copyright (c) 2000, 2001 All Rights Reserved.
* 03/26/2000  created
* Modified for ABS and Civil Catalog HTML Browser Prototype 2001,2002,2003 cs
****************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/TR/WD-xsl">

    <xsl:template match="/">
        <HTML>
            <HEAD>
                <LINK REL="stylesheet" TYPE="text/css" HREF="../css/catalog.css"/>
                <LINK REL="stylesheet" TYPE="text/css" HREF="../css/part.css" />
            </HEAD>
            <BODY>
                <xsl:apply-templates select=".//Part"/>
            </BODY>
        </HTML>
    </xsl:template>

    <xsl:template match="Part">
        <!--<DIV CLASS="clsPartName">-->
        <!--    <xsl:value-of select="@name"/>-->
        <!--</DIV>-->
        <xsl:if test="Images">            
            <xsl:apply-templates select="Images"/>
        </xsl:if>
        <xsl:apply-templates select="Desc"/>      
        <xsl:if test="Link">
            <xsl:apply-templates select="Link"/>
        </xsl:if>
        <xsl:if test="Documents">
            <xsl:apply-templates select="Documents"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="Images">
       <P><B><font color="#0000FF">Click on Image to iDrop</font></B></P>
       <P></P>
       <IMG CLASS="clsPartImage">
        
            <!-- TODO move the ONCLICK and CURSOR CHANGE to better represent Part Family iDrop Selection -->
            <xsl:attribute name="ONCLICK">parent.callDisplayIDropPackage3 ('Drag and Drop Parts')</xsl:attribute>
            
            <xsl:attribute name="SRC">
                <xsl:value-of select="Image/URL/@xlink:href"/>
            </xsl:attribute>
            <xsl:attribute name="BORDER">0</xsl:attribute>
            <xsl:attribute name="TITLE">
                <xsl:value-of select="Image/URL/@xlink:title"/>
            </xsl:attribute>
        </IMG>
        <P></P>
    </xsl:template>
  
    <!--xsl:template match="Desc"-->
        <!--PRE CLASS="clsPartDesc"-->
            <!--xsl:value-of/-->
        <!--/PRE-->
    <!--/xsl:template-->
   
   <xsl:template match="Link">
      <DIV CLASS="clsPartLink">
         <xsl:apply-templates select="URL"/>
      </DIV>
   </xsl:template>
   
   <xsl:template match="Documents">
      <DIV CLASS="clsPartDocuments">
         <SPAN><xsl:value-of select="@name"/></SPAN>
         <UL>
            <xsl:for-each select="Document">
               <xsl:apply-templates select="URL"/>
            </xsl:for-each>
         </UL>
      </DIV>
   </xsl:template>
   
   <xsl:template match="URL">
      <xsl:if test ="@xml:lang[.=/pXML/@xml:lang]">
      <LI><A>
         <xsl:attribute name="HREF"><xsl:value-of select="@xlink:href"/></xsl:attribute>
         <xsl:attribute name="TARGET">_blank</xsl:attribute>
         <xsl:value-of select="@xlink:title"/>
      </A></LI>
      </xsl:if>
   </xsl:template>
</xsl:stylesheet>