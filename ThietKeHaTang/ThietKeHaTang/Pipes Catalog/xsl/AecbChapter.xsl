<?xml version="1.0"?>
<!--
****************************************************************************************
*
* Chapter.xls
*
*
*
*
* Author Werner Jaeger
*
* Copyright (c) 2000, All Rights Reserved.
*
* History:
*           03/26/2000  created
****************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/TR/WD-xsl">

   <xsl:template match="/">
      <HTML>
         <HEAD>
            <LINK REL="stylesheet" TYPE="text/css" HREF="../css/chapter.css" />
         </HEAD>
         <BODY>
            <xsl:apply-templates select=".//Chapter"/>
         </BODY>
      </HTML>
   </xsl:template>

   <xsl:template match="Chapter">
      <DIV CLASS="clsChapterName"><xsl:value-of select="@name"/></DIV>
      
      <xsl:if test="Images"><xsl:apply-templates select="Images"/></xsl:if>
      <xsl:apply-templates select="Desc"/>      
      <xsl:if test="Link"><xsl:apply-templates select="Link"/></xsl:if>
      <xsl:if test="Documents"><xsl:apply-templates select="Documents"/></xsl:if>
   </xsl:template>
   
   <xsl:template match="Images">
      <IMG CLASS="clsChapterImage">
         <xsl:attribute name="SRC"><xsl:value-of select="Image/URL/@xlink:href"/></xsl:attribute>
         <xsl:attribute name="BORDER">0</xsl:attribute>
         <xsl:attribute name="TITLE"><xsl:value-of select="Image/URL/@xlink:title"/></xsl:attribute>
      </IMG><P></P>
   </xsl:template>
   
   <xsl:template match="Desc">
      <PRE CLASS="clsChapterDesc">
         <xsl:value-of/>
      </PRE>
   </xsl:template>
   
   <xsl:template match="Link">
      <DIV CLASS="clsChapterLink">
         <xsl:apply-templates select="URL"/>
      </DIV>
   </xsl:template>
   
   <xsl:template match="Documents">
      <DIV CLASS="clsChapterDocuments">
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