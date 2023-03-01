<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xd t"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Feb 10, 2023</xd:p>
            <xd:p><xd:b>Author:</xd:b> elli</xd:p>
            <xd:p>Script to add a small XML chunk to the titleStmt so that we can record responsibility</xd:p>
            <xd:p>To run this from the command line using Saxon. 
                <xd:ul>
                    <xd:li>
                <xd:pre>saxon -s:INPUT-FILE-DIR -xsl:XSL-FILE -o:OUTPUT-FILE-DIR -xi:off</xd:pre></xd:li>
                <xd:li>Before running the command, make sure the the path to the xsl file (-xsl parameter)  reflects the path on your computer, from root. </xd:li>
                <xd:li>Change any other paths necessary if you are running the command from a different location in your file structure. </xd:li>
                <xd:li>The last parameter <xd:pre>-xi:off</xd:pre> will ignore any xi:includes in the file, which prevents the full bibliography and controlled vocabularies from being copied into each file.</xd:li>
            </xd:ul></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml" />
    <xsl:preserve-space elements="text"/>
   <!-- <xsl:strip-space elements="*"/> -->   
    
    
   <!-- <xsl:template match="t:TEI">
        <xsl:copy>
            <xsl:apply-templates select="t:teiHeader"/>
            <xsl:apply-templates select="t:facsimile"/>
            <xsl:apply-templates select="t:text"/>
        </xsl:copy>
        
    </xsl:template>-->
    
    <xsl:template match="t:titleStmt">
       <xsl:element name="titleStmt" exclude-result-prefixes="#all">
           <xsl:copy-of select="t:title" exclude-result-prefixes="#all" copy-namespaces="no" />
           <author>Author</author>
           <respStmt>
               <resp>Translation</resp>
               <name>Translator</name>
           </respStmt>
           <respStmt>
               <resp>Commentary</resp>
               <name>Commenter</name>
           </respStmt>
       </xsl:element>
    </xsl:template>
    
  <!--  <xsl:template match="t:text | t:facsimile | t:encodingDesc | t:revisionDesc">
        <xsl:copy> <xsl:apply-templates/></xsl:copy>
    </xsl:template>-->
    
    <xsl:template match="@*|node()" >
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
