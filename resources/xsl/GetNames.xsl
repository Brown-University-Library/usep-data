<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xd t"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <xsl:output
        method="xml"
        encoding="utf-8"
        indent="yes"/>
    
    <xsl:template match="/">
        <names>
        <!-- 
        Mac OSX : file:////Volumes/CORSAIR/cds/xml 
        Ubuntu: /media/CORSAIR/cds/
        -->
        
        <xsl:for-each select="collection('file:////var/www/htdocs/projects/usepigraphy/new/xml?select=*.xml;recurse=yes;on-error=ignore')">
		<name>

                    <xsl:attribute name="id">
                        <xsl:value-of select="TEI/teiHeader/fileDesc/publicationStmt/idno/@xml:id" />
                    </xsl:attribute>  

                <xsl:attribute name="collection">
                    <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/region/text()"/>
                    <xsl:text>.</xsl:text>
                    <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/settlement/text()"/>
                    <xsl:if test="(string-length(TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/institution/text())!=0)">
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/institution/text()"/>
                    </xsl:if>
                    <xsl:if test="(string-length(TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/repository/text())!=0)">
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/msDesc/msIdentifier/repository/text()"/>
                    </xsl:if>                    
                </xsl:attribute> 
                <xsl:attribute name="BibOnly">
                	<xsl:choose>
                    <xsl:when test="(not(count(TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/*) > 0) and not(count(TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/objectDesc/*) > 0))">
                        <xsl:text>True</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>False</xsl:text>
                    </xsl:otherwise>   
                    </xsl:choose>
                </xsl:attribute>  
                <xsl:attribute name="Transcription">
                	<xsl:choose>
                    <xsl:when test="(count(TEI/text/body/div[@type='edition']/*) > 0)">
                        <xsl:text>True</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>False</xsl:text>
                    </xsl:otherwise>   
                    </xsl:choose>
                </xsl:attribute>  
                <xsl:attribute name="Metadata">
                	<xsl:choose>
                    <xsl:when test="((count(TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/*) > 0) and (count(TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/objectDesc/*) > 0) and not(count(TEI/text/body/div[@type='edition']/*) > 0))">
                        <xsl:text>True</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>False</xsl:text>
                    </xsl:otherwise>   
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="Thumbnail">
                	<xsl:if test="string-length(TEI/facsimile/surface[1]/graphic[1]/@url) > 0">
                		<xsl:value-of select="TEI/facsimile/surface[1]/graphic[1]/@url" />
                	</xsl:if>
                </xsl:attribute>                   
                    
                <xsl:value-of select="TEI/teiHeader/fileDesc/titleStmt/title/text()"/>

                </name>  

        </xsl:for-each>
        </names>            
    </xsl:template>
    
</xsl:stylesheet>
