<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:tm="http://noname.org"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xd t"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Feb 10, 2023</xd:p>
            <xd:p><xd:b>Author:</xd:b> elli</xd:p>
            <xd:p>Script to insert TM numbers into the altIdentifier element</xd:p>
            <xd:p>To run this from the command line using Saxon. 
                <xd:ul>
                    <xd:li>
                <xd:pre>saxon -s:INPUT-FILE-DIR -xsl:XSL-FILE -o:OUTPUT-FILE-DIR -xi:off</xd:pre>
                <xd:pre>saxon -s:INPUT-FILE-DIR -xsl:XSL-FILE -o:OUTPUT-FILE-DIR -xi:off</xd:pre></xd:li>
                      
                <xd:li>Before running the command, make sure the the path to the xsl file (-xsl parameter)  reflects the path on your computer, from root. Unless you are running it from the directory the XSL file is in.</xd:li>
                <xd:li>Change any other paths necessary if you are running the command from a different location in your file structure. </xd:li>
                <xd:li>The last parameter <xd:pre>-xi:off</xd:pre> will ignore any xi:includes in the file, which prevents the full bibliography and controlled vocabularies from being copied into each file.</xd:li>
            </xd:ul></xd:p>
            <xd:p>
                <xd:ul>
                    <xd:li>look into file with TM numbers</xd:li>
               <xd:li>See if there is a matching USEP id (use idno/@xml:id)</xd:li>
               <xd:li>take the TM number for that USEP id and output it as content for the idno</xd:li>
               <xd:li>Output "None" if there is no TM number or if TM number cell is blank.</xd:li>
                    <xd:li>If there is already a TM number or some other text, just copy it out. </xd:li>
                </xd:ul>
                <p>Note that the table of TM numbers has to be in the same folder as the XSL file. </p>
            </xd:p>
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
    <xsl:variable name="usep-id" select="//t:publicationStmt/t:idno/@xml:id"/> <!-- from current file -->
    <xsl:variable name="edr-file" select="//t:bibl/t:ref[contains(@target,'EDR')]"/> <!-- from current file -->
    <xsl:variable name="edr-table" select="document('tm-table.xml')/tm:Table/tm:Row[tm:usepID[@n = $usep-id]]/tm:edrID/@n"/>
    <xsl:variable name="tm" select="document('tm-table.xml')/tm:Table/tm:Row[tm:usepID[@n = $usep-id]]/tm:tmID/@n"/>
    
    <xsl:template match="t:idno[parent::t:altIdentifier[@type='TM_number']]">
        <xsl:element name="idno" exclude-result-prefixes="#all">
            <xsl:if test="(string-length(.) = 0)">
                <xsl:choose>
                    <xsl:when test="string-length($tm) = 0">
                        <xsl:text>Unknown TM</xsl:text>
                    </xsl:when>
                    <xsl:when test="($edr-file = $edr-table)">
                        <xsl:value-of select="$tm"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>EDR Mismatch</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="(string-length(.) > 0)">
                <xsl:value-of select="."/>
            </xsl:if>
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
